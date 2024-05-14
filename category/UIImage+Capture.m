//
//  UIImage+Capture.m
//  AFNetworking
//
//  Created by apple on 2020/4/27.
//

#import "UIImage+Capture.h"


@implementation UIImage (Capture)
- (UIImage *)mergedImageOnMainImage:(UIImage *)mainImage
                     WithImageArray:(NSArray *)imageArray
                 AndImagePointArray:(NSArray *)imageRectsArray
                        webViewSize:(CGSize)webViewSize
{
    CGFloat width = mainImage.size.width;
    CGFloat height = mainImage.size.height;
    
    UIGraphicsBeginImageContext(CGSizeMake(width,height ));
    
    [mainImage drawInRect:CGRectMake(0, 0,width, height)];
    for (NSInteger i = 0; i < imageArray.count; i++) {
        CGRect originRect = [imageRectsArray[i] CGRectValue];
        UIImage *image = imageArray[i];
        //        image = [self sourceImage:image targetSize:originRect.size];
        [image drawInRect:originRect];
        
    }
    CGImageRef  newMergeImage = CGImageCreateWithImageInRect(UIGraphicsGetImageFromCurrentImageContext().CGImage, CGRectMake(0, 0, width, height ));
    UIGraphicsEndImageContext();
    if (newMergeImage) {
        UIImage *outPutImage = [UIImage imageWithCGImage:newMergeImage];
        return outPutImage;
    }
    
    
    return mainImage;
}

- (UIImage *)sourceImage:(UIImage *)sourceImage targetSize:(CGSize)targetSize{
    CGFloat souceImageW = sourceImage.size.width;
    CGFloat souceImageH = sourceImage.size.height;
    if (souceImageH == 0 || souceImageW == 0) {
        return sourceImage;
    }
    BOOL isBiggerH = souceImageH > souceImageW;
    CGFloat targetW = isBiggerH ? MIN(targetSize.width, targetSize.height) : MAX(targetSize.width, targetSize.height);
    CGFloat targetH = isBiggerH ? MAX(targetSize.width, targetSize.height) : MIN(targetSize.width, targetSize.height);
    CGFloat coefficientW = targetW * 1.0 / souceImageW;
    CGFloat coefficientH = targetH * 1.0 / souceImageH ;
    CGFloat finalCoefficient = MIN(coefficientW, coefficientH);
    if (finalCoefficient > 1) {
        return sourceImage;   // 不需要缩小
    }else{
        CGPoint thumbnailPoint =CGPointMake(0.0,0.0);//这个是图片剪切的起点位置
        UIGraphicsBeginImageContext(CGSizeMake(MIN(finalCoefficient * souceImageW, targetW), MIN(finalCoefficient * souceImageH, targetH)));//开始剪切
        CGRect thumbnailRect =CGRectZero;//剪切起点(0,0)
        thumbnailRect.origin= thumbnailPoint;
        thumbnailRect.size.width= souceImageW * finalCoefficient;
        thumbnailRect.size.height= souceImageH * finalCoefficient;
        [sourceImage drawInRect:thumbnailRect];
        UIImage*newImage =UIGraphicsGetImageFromCurrentImageContext();//截图拿到图片
        return newImage;
    }
}

/// 裁剪图片为正方形
/// @param originalImage 原图片
/// @param centerBool 是否由中心点取mCGRect范围
+ (UIImage*)cutSquareImage:(UIImage *)originalImage centerBool:(BOOL)centerBool {
    /*如若centerBool为Yes则是由中心点取mCGRect范围的图片*/
    float imgWidth = originalImage.size.width;
    float imgHeight = originalImage.size.height;
    float viewWidth = originalImage.size.width;
    float viewHidth = originalImage.size.height;
    
    BOOL isSmallerH = imgHeight < imgWidth;
    
    if (isSmallerH) {
        viewWidth = imgHeight;
    }else {
        imgHeight = viewWidth;
    }
    
    CGRect rect;
    if(centerBool){
        rect = CGRectMake((imgWidth-viewWidth)/2,(imgHeight-viewHidth)/2,viewWidth,viewHidth);
    }else{
        if(viewHidth < viewWidth){
            if(imgWidth <= imgHeight){
                rect = CGRectMake(0, 0, imgWidth, imgWidth*imgHeight/viewWidth);
            }else{
                float width = viewWidth*imgHeight/viewHidth;
                float x = (imgWidth - width)/2;
                if(x > 0){
                    rect = CGRectMake(x, 0, width, imgHeight);
                }else{
                    rect = CGRectMake(0, 0, imgWidth, imgWidth*viewHidth/viewWidth);
                }
            }
        }else{
            if(imgWidth <= imgHeight){
                float height = viewHidth*imgWidth/viewWidth;
                if(height < imgHeight){
                    rect = CGRectMake(0,0, imgWidth, height);
                }else{
                    rect = CGRectMake(0,0, viewWidth*imgHeight/viewHidth,imgHeight);
                }
            }else{
                float width = viewWidth * imgHeight / viewHidth;
                if(width < imgWidth){
                    float x = (imgWidth - width)/2;
                    rect = CGRectMake(x,0,width, imgHeight);
                }else{
                    rect = CGRectMake(0,0,imgWidth, imgHeight);
                }
            }
        }
    }
    
    // 注意: 这里图片会被旋转
    CGImageRef subImageRef = CGImageCreateWithImageInRect(originalImage.CGImage, rect);
    CGRect smallBounds = CGRectMake(0,0,CGImageGetWidth(subImageRef),CGImageGetHeight(subImageRef));
    
    UIGraphicsBeginImageContext(smallBounds.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextDrawImage(context, smallBounds, subImageRef);
    // 这里将图片按照原始方向旋转回去
    UIImage *smallImage = [UIImage imageWithCGImage:subImageRef scale:originalImage.scale orientation:originalImage.imageOrientation];
    UIGraphicsEndImageContext();
    
    return smallImage;
}

- (UIImage*)scaledToNewSize:(CGSize)newSize {
    
    //计算比例
    float aspectWidth = newSize.width / self.size.width;
    float aspectHeight = newSize.height / self.size.height;
    float aspectRatio = MAX(aspectWidth, aspectHeight);
    //图片绘制区域
    CGRect scaledImageRect = CGRectZero;
    scaledImageRect.size.width = self.size.width * aspectRatio;
    scaledImageRect.size.height = self.size.height * aspectRatio;
    scaledImageRect.origin.x = (newSize.width - self.size.width * aspectRatio) / 2.0;
    scaledImageRect.origin.y = (newSize.height - self.size.height * aspectRatio) / 2.0;
    
    UIGraphicsBeginImageContext(newSize);
    [self drawInRect:scaledImageRect];
    UIImage *scaledImage =UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return scaledImage;
    
}

@end
