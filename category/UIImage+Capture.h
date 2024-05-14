//
//  UIImage+Capture.h
//  AFNetworking
//
//  Created by apple on 2020/4/27.
//



#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (Capture)
/*
 多张图合成一张图
 mainImage  底图
 imagesArray 按照数组的顺序依次合到原图里
 rectsArray  图片在原图的位置
 */

- (UIImage*) mergedImageOnMainImage:(UIImage *)mainImage
                     WithImageArray:(NSArray *)imageArray
                 AndImagePointArray:(NSArray *)imageRectsArray
                        webViewSize:(CGSize)webViewSize;

- (UIImage *)sourceImage:(UIImage *)sourceImage
              targetSize:(CGSize)targetSize;

/// 裁剪图片为正方形
/// @param originalImage 原图片
/// @param centerBool 是否由中心点取mCGRect范围
+ (UIImage*)cutSquareImage:(UIImage *)originalImage
                centerBool:(BOOL)centerBool;

/// 将图片缩放成指定尺寸（多余部分自动删除）
/// @param newSize 指定尺寸
- (UIImage*)scaledToNewSize:(CGSize)newSize;

@end


NS_ASSUME_NONNULL_END
