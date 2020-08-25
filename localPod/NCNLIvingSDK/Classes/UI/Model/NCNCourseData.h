//
//  NCNCourseData.h
//  NCNLivingSDK
//
//  Created by 汪宁 on 2020/5/8.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NCNCourseData : NSObject
@property (nonatomic, copy) NSString *fileName;
@property (nonatomic, copy) NSString *id;
/**
 课件ppt    dict ==  [imageUrl      seq]
 */
@property (nonatomic, copy) NSArray<NSDictionary *> *imageList;


+ (instancetype)courseDataWithDict:(NSDictionary *)dict;
@end

NS_ASSUME_NONNULL_END
