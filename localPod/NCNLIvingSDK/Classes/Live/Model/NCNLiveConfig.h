//  Created by hansen 



#import <Foundation/Foundation.h>
#import "NCNCourseData.h"

@interface NCNLiveConfig : NSObject
/**{
 }*/
@property (nonatomic, strong) NCNCourseData *courseData;

/** 学生端推流地址*/
@property (nonatomic, copy) NSString *stuPushRtmp;

/**是否正在录播*/
@property (nonatomic, copy) NSString *isRecord;

/**0: 白板 1：ppt */
@property (nonatomic, copy) NSString *pageType;

/**是否锁住学生端屏幕  暂时不可用*/
@property (nonatomic, copy) NSString *isLock;

/**正在举手的学生id*/
@property (nonatomic, copy) NSString *stuId;

/**教师拉流地址*/
@property (nonatomic, copy) NSString *teacherRtmp;

/**正在举手的学生名称*/
@property (nonatomic, copy) NSString *stuName;

/**是否开始上课*/
@property (nonatomic, copy) NSString *isBegin;

/**当前白板或者ppt的页面数*/
@property (nonatomic, copy) NSString *currentPage;

/**是否允许举手*/
@property (nonatomic, copy) NSString *isHandup;

/**直播间id*/
@property (nonatomic, copy) NSString *liveRoom;

/**正在举手的学生波流地址*/
@property (nonatomic, copy) NSString *stuPlayRtmp;







+ (instancetype)liveConfigWithDict:(NSDictionary *)dict;

@end
