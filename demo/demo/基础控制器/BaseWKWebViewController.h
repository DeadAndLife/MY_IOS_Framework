//
//  BaseWKWebViewController.h
//  rabbit
//
//  Created by admin on 2020/1/9.
//  Copyright © 2020 jixiultd. All rights reserved.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface BaseWKWebViewController : BaseViewController
/** 加载网络URL */
//- (void)loadNetworkHTML:(NSString *)htmlString;
/** 加载本地URL */
//- (void)loadLocalHTML:(NSString *)htmlString;

//@property(nonatomic, copy)NSString *url;

@property (nonatomic, copy) NSString *titleString;

@property (nonatomic, copy) NSString *filePath;

@property (nonatomic, copy) NSString *requestURLString;

@property (nonatomic, copy) NSString *htmlString;

/**
 加载文件

 @param URLString 文件路径
 */
- (void)loadFileURLString:(NSString *)URLString;

/**
 加载网络路径

 @param URLString 网络路径
 */
- (void)loadRequestURLString:(NSString *)URLString;

/**
 加载html

 @param HtmlString html
 @param baseURLString 基础网址
 */
- (void)loadHtmlString:(NSString *)HtmlString baseURLString:(NSString *)baseURLString;

@end

NS_ASSUME_NONNULL_END
