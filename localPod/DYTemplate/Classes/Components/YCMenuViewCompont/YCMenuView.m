//
//  YCMenuView.m
//
//  github地址：https://github.com/WellsYC/YCMenuView
//  简书地址：https://www.jianshu.com/u/f853cbc68abb


#define kScreenWidth               [UIScreen mainScreen].bounds.size.width
#define kScreenHeight              [UIScreen mainScreen].bounds.size.height
#define kMainWindow                [UIApplication sharedApplication].keyWindow

#define kArrowWidth          15
#define kArrowHeight         10
#define kDefaultMargin       10
#define kAnimationTime       0.25

#import "YCMenuView.h"

@interface UIView (YCFrame)
@property (nonatomic, assign) CGFloat x;
@property (nonatomic, assign) CGFloat y;
@property (nonatomic, assign) CGPoint origin;

@property (nonatomic, assign) CGFloat centerX;
@property (nonatomic, assign) CGFloat centerY;

@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, assign) CGSize  size;
@end

@implementation UIView (YCFrame)
- (CGFloat)x
{
    return self.frame.origin.x;
}
- (void)setX:(CGFloat)value
{
    CGRect frame = self.frame;
    frame.origin.x = value;
    self.frame = frame;
}
- (CGFloat)y
{
    return self.frame.origin.y;
}
- (void)setY:(CGFloat)value
{
    CGRect frame = self.frame;
    frame.origin.y = value;
    self.frame = frame;
}
- (CGPoint)origin
{
    return self.frame.origin;
}
- (void)setOrigin:(CGPoint)origin
{
    CGRect frame = self.frame;
    frame.origin = origin;
    self.frame = frame;
}
- (CGFloat)centerX
{
    return self.center.x;
}
- (void)setCenterX:(CGFloat)centerX
{
    CGPoint center = self.center;
    center.x = centerX;
    self.center = center;
}
- (CGFloat)centerY
{
    return self.center.y;
}
- (void)setCenterY:(CGFloat)centerY
{
    CGPoint center = self.center;
    center.y = centerY;
    self.center = center;
}
- (CGFloat)width
{
    return self.frame.size.width;
}
- (void)setWidth:(CGFloat)width
{
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}
- (CGFloat)height
{
    return self.frame.size.height;
}
- (void)setHeight:(CGFloat)height
{
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}
- (CGSize)size
{
    return self.frame.size;
}
- (void)setSize:(CGSize)size
{
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
}
@end

@interface YCMenuCell : UITableViewCell
@property (nonatomic,assign) BOOL         isShowSeparator;
@property (nonatomic,strong) UIColor    * separatorColor;
@end
@implementation YCMenuCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        _isShowSeparator = YES;
        _separatorColor = [UIColor lightGrayColor];
    }
    return self;
}

- (void)setSeparatorColor:(UIColor *)separatorColor{
    _separatorColor = separatorColor;
    [self setNeedsDisplay];
}
- (void)setIsShowSeparator:(BOOL)isShowSeparator{
    _isShowSeparator = isShowSeparator;
    [self setNeedsDisplay];
}
- (void)drawRect:(CGRect)rect{
    if (!_isShowSeparator)return;
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:CGRectMake(35, rect.size.height - 0.5, rect.size.width, 0.5)];
    [_separatorColor setFill];
    [path fillWithBlendMode:kCGBlendModeNormal alpha:1.0f];
    [path closePath];
}
@end


@interface YCMenuAction()
@property (nonatomic) NSString      *title;
@property (nonatomic) UIImage       *image;
@property (copy, nonatomic)void (^handler)(YCMenuAction *);
@end
@implementation YCMenuAction
+ (instancetype)actionWithTitle:(NSString *)title image:(UIImage *)image handler:(void (^)(YCMenuAction *))handler{
    YCMenuAction *action = [[YCMenuAction alloc] initWithTitle:title image:image handler:handler];
    return action;
}
+ (instancetype)actionWithTitle:(NSString *)title image:(UIImage * _Nullable)image {
    YCMenuAction *action = [[YCMenuAction alloc] initWithTitle:title image:image handler:nil];
    return action;

}
- (instancetype)initWithTitle:(NSString *)title image:(UIImage * _Nullable)image handler:(void (^)(YCMenuAction *))handler{
    if (self = [super init]) {
        _title = title;
        _image = image;
        if (handler) {
            _handler = [handler copy];
        }
    }
    return self;
}
@end

typedef int ContentStyle;
@interface YCMenuView()<UITableViewDelegate,UITableViewDataSource, UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
{
    CGPoint          _refPoint;
    UIView          *_refView;
    CGFloat          _menuWidth;
    
    CGFloat         _arrowPosition; // 三角底部的起始点x
    CGFloat         _topMargin;
    BOOL            _isReverse; // 是否反向
    BOOL            _needReload; //是否需要刷新
}
@property(nonatomic,copy) NSArray<YCMenuAction *>   *actions;
@property(nonatomic,strong)UITableView              *tableView;
@property(nonatomic,strong)UIView                   *contentView;
@property(nonatomic,strong)UIView                   *bgView;
@property (nonatomic, strong) UICollectionView *collectionView;
//0 ： list, 1 : bookrack
@property (nonatomic, assign) ContentStyle style;

@end

static NSString *const menuCellID = @"YCMenuCell";
@implementation YCMenuView

+ (instancetype)menuWithActions:(NSArray<YCMenuAction *> *)actions width:(CGFloat)width atPoint:(CGPoint)point{
    NSAssert(width>0.0f, @"width要大于0");
    YCMenuView *menu = [[YCMenuView alloc] initWithActions:actions width:width atPoint:point style:0];
    return menu;
}
+ (instancetype)menuWithActions:(NSArray<YCMenuAction *> *)actions width:(CGFloat)width relyonView:(id)view{
    NSAssert(width>0.0f, @"width要大于0");
    NSAssert([view isKindOfClass:[UIView class]]||[view isKindOfClass:[UIBarButtonItem class]], @"relyonView必须是UIView或UIBarButtonItem");
    YCMenuView *menu = [[YCMenuView alloc] initWithActions:actions width:width relyonView:view style:0];
    return menu;
}
+ (instancetype)menuCollectionWithActions:(NSArray<YCMenuAction *> *)actions width:(CGFloat)width relyonView:(id)view {
    NSAssert(width>0.0f, @"width要大于0");
    NSAssert([view isKindOfClass:[UIView class]]||[view isKindOfClass:[UIBarButtonItem class]], @"relyonView必须是UIView或UIBarButtonItem");
    YCMenuView *menu = [[YCMenuView alloc] initWithActions:actions width:width relyonView:view style:1];
    return menu;
    
}

- (instancetype)initWithActions:(NSArray<YCMenuAction *> *)actions width:(CGFloat)width atPoint:(CGPoint)point style:(ContentStyle)style {
    if (self = [super init]) {
        self.style = style;
        _actions = [actions copy];
        _refPoint = point;
        _menuWidth = width;
        [self defaultConfiguration];
        [self setupSubView];
    }
    return self;
}

- (instancetype)initWithActions:(NSArray<YCMenuAction *> *)actions width:(CGFloat)width relyonView:(id)view style:(ContentStyle)style {
    if (self = [super init]) {
        // 针对UIBarButtonItem做的处理
        if ([view isKindOfClass:[UIBarButtonItem class]]) {
            UIView *bgView = [view valueForKey:@"_view"];
            _refView = bgView;
        }else{
            _refView = view;
        }
        self.style = style;
        _actions = [actions copy];
        _menuWidth = width;
        [self defaultConfiguration];
        [self setupSubView];
    }
    return self;
}

- (void)defaultConfiguration{
    self.alpha = 0.0f;
    [self setDefaultShadow];
    
    _cornerRaius = 5.0f;
    _separatorColor = [UIColor blackColor];
    _menuColor = [UIColor whiteColor];
    _menuCellHeight = 44.0f;
    _maxDisplayCount = 5;
    _isShowShadow = YES;
    _dismissOnselected = YES;
    _dismissOnTouchOutside = YES;
    
    _textColor = [UIColor blackColor];
    _textFont = [UIFont systemFontOfSize:15.0f];
    _offset = 0.0f;
}

- (void)setupSubView{
    [self calculateArrowAndFrame];
    [self setupMaskLayer];
    if (self.style == 0) {
        [self.contentView addSubview:self.tableView];
        
    } else if (self.style == 1) {
        [self.contentView addSubview:self.collectionView];
    }
    [self addSubview:self.contentView];
}

- (void)reloadData{
    [self.contentView removeFromSuperview];
    [self.tableView removeFromSuperview];
    [self.collectionView removeFromSuperview];
    self.contentView = nil;
    self.tableView = nil;
    self.collectionView = nil;
    [self setupSubView];
}

- (CGPoint)getRefPoint{
    CGRect absoluteRect = [_refView convertRect:_refView.bounds toView:kMainWindow];
    CGPoint refPoint;
    CGFloat menuHeight = (_actions.count > _maxDisplayCount) ? _maxDisplayCount * _menuCellHeight + kArrowHeight: _actions.count * _menuCellHeight + kArrowHeight;
    if (absoluteRect.origin.y + absoluteRect.size.height +  menuHeight > kScreenHeight - 10) {
        refPoint = CGPointMake(absoluteRect.origin.x + absoluteRect.size.width / 2, absoluteRect.origin.y);
        _isReverse = YES;
    }else{
        refPoint = CGPointMake(absoluteRect.origin.x + absoluteRect.size.width / 2, absoluteRect.origin.y + absoluteRect.size.height);
        _isReverse = NO;
    }
    return refPoint;
}

- (void)show{
    // 自定义设置统一在这边刷新一次
    if (_needReload) [self reloadData];
    
    [kMainWindow addSubview: self.bgView];
    [kMainWindow addSubview: self];
    self.layer.affineTransform = CGAffineTransformMakeScale(0.1, 0.1);
    [UIView animateWithDuration: kAnimationTime animations:^{
        self.layer.affineTransform = CGAffineTransformIdentity;
        self.alpha = 1.0f;
        self.bgView.alpha = 1.0f;
    }];
}

- (void)dismiss{
    if (!_dismissOnTouchOutside) return;
    [UIView animateWithDuration: kAnimationTime animations:^{
        self.layer.affineTransform = CGAffineTransformMakeScale(0.1, 0.1);
        self.alpha = 0.0f;
        self.bgView.alpha = 0.0f;
    } completion:^(BOOL finished) {
        self.layer.affineTransform = CGAffineTransformIdentity;
        [self removeFromSuperview];
        [self.bgView removeFromSuperview];
    }];
}

#pragma mark - Private
- (void)setupMaskLayer{
    CAShapeLayer *layer = [self drawMaskLayer];
    self.contentView.layer.mask = layer;
}

- (void)calculateArrowAndFrame{
    if (_refView) {
        _refPoint = [self getRefPoint];
    }
    
    CGFloat originX;
    CGFloat originY;
    CGFloat width;
    CGFloat height;
    
    width = _menuWidth;
    NSInteger counts = _actions.count;
    height = (counts > _maxDisplayCount) ? _maxDisplayCount * _menuCellHeight + kArrowHeight: counts * _menuCellHeight + kArrowHeight;
    if (_style == 1 ) {
        NSInteger row = counts / 3 ;
        height = row * self.menuCellHeight + kArrowHeight + ((row - 1) * 10) + 16;
        if (counts % 3 > 0) {
            height += self.menuCellHeight + 10;
        }
        
        if (height > 300) {
            height = 300;
        }
    }
    // 默认在中间
    _arrowPosition = 0.5 * width - 0.5 * kArrowWidth;
    
    // 设置出menu的x和y（默认情况）
    originX = _refPoint.x - _arrowPosition - 0.5 * kArrowWidth;
    originY = _refPoint.y;
    
    // 考虑向左右展示不全的情况，需要反向展示
    if (originX + width > kScreenWidth - 10) {
        originX = kScreenWidth - kDefaultMargin - width;
    }else if (originX < 10) {
        //向上的情况间距也至少是kDefaultMargin
        originX = kDefaultMargin;
    }
    
    //设置三角形的起始点
    if ((_refPoint.x <= originX + width - _cornerRaius) && (_refPoint.x >= originX + _cornerRaius)) {
        _arrowPosition = _refPoint.x - originX - 0.5 * kArrowWidth;
    }else if (_refPoint.x < originX + _cornerRaius) {
        _arrowPosition = _cornerRaius;
    }else {
        _arrowPosition = width - _cornerRaius - kArrowWidth;
    }
    
    //如果不是根据关联视图，得算一次是否反向
    if (!_refView) {
        _isReverse = (originY + height > kScreenHeight - kDefaultMargin)?YES:NO;
    }
    
    CGPoint  anchorPoint;
    if (_isReverse) {
        originY = _refPoint.y - height;
        anchorPoint = CGPointMake(fabs(_arrowPosition) / width, 1);
        _topMargin = 0;
    }else{
        anchorPoint = CGPointMake(fabs(_arrowPosition) / width, 0);
        _topMargin = kArrowHeight;
    }
    originY += originY >= _refPoint.y ? _offset : -_offset;
    
    //保存原来的frame，防止设置锚点后偏移
    self.layer.anchorPoint = anchorPoint;
    self.frame = CGRectMake(originX, originY, width, height);
    
    if (self.style == 1) {
        
        self.collectionView.frame = CGRectMake(0, _topMargin, self.width, self.height - kArrowHeight);
       
    }
}

- (CAShapeLayer *)drawMaskLayer{
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    CGFloat bottomMargin = !_isReverse?0 :kArrowHeight;
    
    // 定出四个转角点
    CGPoint topRightArcCenter = CGPointMake(self.width - _cornerRaius, _topMargin + _cornerRaius);
    CGPoint topLeftArcCenter = CGPointMake(_cornerRaius, _topMargin + _cornerRaius);
    CGPoint bottomRightArcCenter = CGPointMake(self.width - _cornerRaius, self.height - bottomMargin - _cornerRaius);
    CGPoint bottomLeftArcCenter = CGPointMake(_cornerRaius, self.height - bottomMargin - _cornerRaius);
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    // 从左上倒角的下边开始画
    [path moveToPoint: CGPointMake(0, _topMargin + _cornerRaius)];
    [path addLineToPoint: CGPointMake(0, bottomLeftArcCenter.y)];
    [path addArcWithCenter: bottomLeftArcCenter radius: _cornerRaius startAngle: -M_PI endAngle: -M_PI-M_PI_2 clockwise: NO];
    
    if (_isReverse) {
        [path addLineToPoint: CGPointMake(_arrowPosition, self.height - kArrowHeight)];
        [path addLineToPoint: CGPointMake(_arrowPosition + 0.5*kArrowWidth, self.height)];
        [path addLineToPoint: CGPointMake(_arrowPosition + kArrowWidth, self.height - kArrowHeight)];
    }
    [path addLineToPoint: CGPointMake(self.width - _cornerRaius, self.height - bottomMargin)];
    [path addArcWithCenter: bottomRightArcCenter radius: _cornerRaius startAngle: -M_PI-M_PI_2 endAngle: -M_PI*2 clockwise: NO];
    [path addLineToPoint: CGPointMake(self.width, self.height - bottomMargin + _cornerRaius)];
    [path addArcWithCenter: topRightArcCenter radius: _cornerRaius startAngle: 0 endAngle: -M_PI_2 clockwise: NO];
    
    if (!_isReverse) {
        [path addLineToPoint: CGPointMake(_arrowPosition + kArrowWidth, _topMargin)];
        [path addLineToPoint: CGPointMake(_arrowPosition + 0.5 * kArrowWidth, 0)];
        [path addLineToPoint: CGPointMake(_arrowPosition, _topMargin)];
    }
    
    [path addLineToPoint: CGPointMake(_cornerRaius, _topMargin)];
    [path addArcWithCenter: topLeftArcCenter radius: _cornerRaius startAngle: -M_PI_2 endAngle: -M_PI clockwise: NO];
    [path closePath];
    
    maskLayer.path = path.CGPath;
    return maskLayer;
}
- (void)setDefaultShadow{
    self.layer.shadowOpacity = 0.5;
    self.layer.shadowOffset = CGSizeMake(0, 0);
    self.layer.shadowRadius = 5.0;
}

#pragma mark - <UITableViewDelegate,UITableViewDataSource>
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _actions.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    YCMenuCell *cell = [tableView dequeueReusableCellWithIdentifier:menuCellID forIndexPath:indexPath];
    YCMenuAction *action = _actions[indexPath.row];
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.font = _textFont;
    cell.textLabel.textColor = _textColor;
    cell.textLabel.text = action.title;
    cell.separatorColor = _separatorColor;
    cell.imageView.image = action.image?action.image:nil;
    
    if (indexPath.row == _actions.count - 1) {
        cell.isShowSeparator = NO;
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    YCMenuAction *action = _actions[indexPath.row];
    if (action.handler) {
        action.handler(action);
    }
    if (self.didSelectedCellCallback) {
        self.didSelectedCellCallback(self,indexPath);
    }
    if (_dismissOnselected) [self dismiss];
}
#pragma mark <UICollectionview delegate>
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return  _actions.count;
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    UILabel *label = cell.contentView.subviews.firstObject;
    if (label == nil) {
        
        label = [UILabel new];
        label.backgroundColor = [UIColor dy_colorWithHexString:@"#EAEAEA"];
        label.textColor = self.textColor;
        if (@available(iOS 14.0, *)) {
            label.textAlignment = UIListContentTextAlignmentCenter;
        } else {
            label.textAlignment = UITextAlignmentCenter;
            // Fallback on earlier versions
        }
        label.font = self.textFont;
        [label addRound:self.menuCellHeight * 0.5];
        [cell.contentView addSubview:label];
        label.frame = CGRectMake(0, 0, cell.width, self.menuCellHeight);
    }
    YCMenuAction *action = _actions[indexPath.row];
    label.text = action.title;
    
    return  cell;
    
    
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    YCMenuAction *action = _actions[indexPath.row];
    if (action.handler) {
        action.handler(action);
    }
    if (self.didSelectedCellCallback) {
        self.didSelectedCellCallback(self,indexPath);
    }
    if (_dismissOnselected) [self dismiss];
    
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    YCMenuAction *action = _actions[indexPath.row];

    CGFloat width = [action.title boundingRectWithSize:CGSizeMake(collectionView.width, self.height) options:0 attributes:@{NSFontAttributeName: self.textFont} context:nil].size.width + 15;
    if (width < 60) {
        width = 60;
    }
    return CGSizeMake(width, self.menuCellHeight);
}

#pragma mark - Setting&&Getting
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, _topMargin, self.width, self.height - kArrowHeight) style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.bounces = _actions.count > _maxDisplayCount? YES : NO;
        _tableView.rowHeight = _menuCellHeight;
        _tableView.tableFooterView = [UIView new];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerClass:[YCMenuCell class] forCellReuseIdentifier:menuCellID];
    }
    return _tableView;
}
- (UICollectionView *)collectionView {
    
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
        layout.sectionInset = UIEdgeInsetsMake(8, 8, 8, 8);
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, _topMargin, self.width, self.height - kArrowHeight) collectionViewLayout:layout];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        [_collectionView registerClass:UICollectionViewCell.class forCellWithReuseIdentifier:@"cell"];
        _collectionView.backgroundColor = UIColor.whiteColor;
        
    }
    return _collectionView;
    
}
- (UIView *)bgView{
    if (!_bgView) {
        _bgView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _bgView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.1];
        _bgView.alpha = 0.0f;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)];
        [_bgView addGestureRecognizer:tap];
    }
    return _bgView;
}

- (UIView *)contentView{
    if (!_contentView) {
        _contentView = [[UIView alloc] initWithFrame:self.bounds];
        _contentView.backgroundColor = _menuColor;
        _contentView.layer.masksToBounds = YES;
    }
    return _contentView;
}
#pragma mark - 设置属性
- (void)setCornerRaius:(CGFloat)cornerRaius{
    if (_cornerRaius == cornerRaius)return;
    _cornerRaius = cornerRaius;
    self.contentView.layer.mask = [self drawMaskLayer];
}
- (void)setMenuColor:(UIColor *)menuColor{
    if ([_menuColor isEqual:menuColor]) return;
    _menuColor = menuColor;
    self.contentView.backgroundColor = menuColor;
}
- (void)setBackgroundColor:(UIColor *)backgroundColor{
    if ([_menuColor isEqual:backgroundColor]) return;
    _menuColor = backgroundColor;
    self.contentView.backgroundColor = _menuColor;
}
- (void)setSeparatorColor:(UIColor *)separatorColor{
    if ([_separatorColor isEqual:separatorColor]) return;
    _separatorColor = separatorColor;
    [self.tableView reloadData];
    [self.collectionView reloadData];
}
- (void)setMenuCellHeight:(CGFloat)menuCellHeight{
    if (_menuCellHeight == menuCellHeight)return;
    _menuCellHeight = menuCellHeight;
    _needReload = YES;
}
- (void)setMaxDisplayCount:(NSInteger)maxDisplayCount{
    if (_maxDisplayCount == maxDisplayCount)return;
    _maxDisplayCount = maxDisplayCount;
    _needReload = YES;
}
- (void)setIsShowShadow:(BOOL)isShowShadow{
    if (_isShowShadow == isShowShadow)return;
    _isShowShadow = isShowShadow;
    if (!_isShowShadow) {
        self.layer.shadowOpacity = 0.0;
        self.layer.shadowOffset = CGSizeMake(0, 0);
        self.layer.shadowRadius = 0.0;
    }else{
        [self setDefaultShadow];
    }
}
- (void)setTextFont:(UIFont *)textFont{
    if ([_textFont isEqual:textFont]) return;
    _textFont = textFont;
    [self.tableView reloadData];
    [self.collectionView reloadData];

}
- (void)setTextColor:(UIColor *)textColor{
    if ([_textColor isEqual:textColor]) return;
    _textColor = textColor;
    [self.tableView reloadData];
    [self.collectionView reloadData];

}
- (void)setOffset:(CGFloat)offset{
    if (_offset == offset) return;
    _offset = offset;
    if (_offset < 0.0f) {
        _offset = 0.0f;
    }
    self.y += self.y >= _refPoint.y ? _offset : -_offset;
}

@end
