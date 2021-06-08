//
//  HttpManager.h
//  qukanjs
//
//  Created by iOSzhang Inc on 21/1/14.
//

#import <Foundation/Foundation.h>
#import <AFNetworking.h>

#define CODE_SUCCESS 1
#define NEED_LOGIN 404
#define CODE_KEY @"code"
#define MSG_KEY @"msg"

#define hostAutoChange(urlString, portSting) [HttpManager hostAutoChange:urlString port:portSting]

typedef void(^NetworkBlock)(id responseObject, NSError *error);
typedef BOOL(^UpdataTokenBlock)(id responseObject, NSError *error);

NS_ASSUME_NONNULL_BEGIN

@interface HttpManager : NSObject

@property (nonatomic) AFHTTPSessionManager *jsonSessionManager;
@property (nonatomic) AFHTTPSessionManager *sessionManager;

+ (instancetype)share;

+ (NSString *)hostAutoChange:(NSString *)urlString port:(NSString *)port;

- (void)resetUserToken;

- (BOOL)isDevelopmentMode;

- (NSURLSessionDataTask *)POST:(NSString *)URLString parameters:(id)parameters networkBlock:(NetworkBlock)networkBlock;

- (NSURLSessionDataTask *)GET:(NSString *)URLString parameters:(id)parameters networkBlock:(NetworkBlock)networkBlock;

- (NSURLSessionDataTask *)POST:(NSString *)URLString parameters:(nullable id)parameters constructingBodyWithBlock:(nullable void (^)(id<AFMultipartFormData> _Nonnull))block success:(void (^)(NSURLSessionDataTask *task, id responseObject))success failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure;

- (void)uploadImageWithURLString:(NSString *)URLString image:(UIImage *)image imageName:(NSString *)imageName params:(NSDictionary *)params progress:(nullable void (^)(NSProgress * _Nonnull))uploadProgress block:(NetworkBlock)networkBlock;

- (void)uploadImageWithURLString:(NSString *)URLString photos:(NSArray *)photos imageNames:(NSArray *)imageNames params:(NSDictionary *)params progress:(nullable void (^)(NSProgress * _Nonnull))uploadProgress block:(NetworkBlock)networkBlock;

@end

NS_ASSUME_NONNULL_END
