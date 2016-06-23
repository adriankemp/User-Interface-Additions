//
//  PageIndicatorPipSet.m
//  PageIndicator
//
//  Created by Adrian Kemp on 2015-04-27.
//

#import "PageIndicatorPipSet.h"

@interface PageIndicatorPipSet ()

@property (nonatomic, strong) UIImage *pipSetImage; //You just know people will reference it instead of saving a copy, so let's make that efficient.

@end

@implementation PageIndicatorPipSet

- (void)setRightPipImage:(UIImage *)rightPipImage {
    _rightPipImage = rightPipImage;
    self.pipSetImage = nil;
}

- (void)setleftPipImage:(UIImage *)leftPipImage {
    _leftPipImage = leftPipImage;
    self.pipSetImage = nil;
}

- (void)setCenterPipImage:(UIImage *)centerPipImage {
    _centerPipImage = centerPipImage;
    self.pipSetImage = nil;
}

- (CGSize)renderedSizeForPageCount:(NSUInteger)pageCount {
    if (pageCount == 0) {
        return CGSizeZero;
    } else if (self.pipSetImage) {
        return self.pipSetImage.size;
    } else {
        CGSize renderedSize = CGSizeZero;
        renderedSize.width += (self.leftPipImage.size.width ?: self.centerPipImage.size.width);
        renderedSize.width += self.centerPipImage.size.width * (pageCount - 2);
        renderedSize.width += (self.rightPipImage.size.width ?: self.centerPipImage.size.width);
        
        renderedSize.height = MAX(self.centerPipImage.size.height, MAX(self.leftPipImage.size.height, self.rightPipImage.size.height));
        return renderedSize;
    }
}

- (UIImage *)imageForPageCount:(NSInteger)pageCount {
    if (!self.pipSetImage) {
        CGSize finalImageSize = [self renderedSizeForPageCount:pageCount];
        
        CGPoint currentRenderPoint = CGPointZero;
        UIGraphicsBeginImageContextWithOptions(finalImageSize, NO, 0.0f);
        CGContextRef imageContext = UIGraphicsGetCurrentContext();
        
        currentRenderPoint = [self drawPipImage:(self.leftPipImage ?: self.centerPipImage) atPoint:currentRenderPoint inContext:imageContext];
        for (NSInteger currentPagePip = 2; currentPagePip < pageCount; currentPagePip++) {
            currentRenderPoint = [self drawPipImage:self.centerPipImage atPoint:currentRenderPoint inContext:imageContext];
        }
        currentRenderPoint = [self drawPipImage:(self.rightPipImage ?: self.centerPipImage) atPoint:currentRenderPoint inContext:imageContext];
        
        self.pipSetImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    
    return self.pipSetImage;
}

- (CGPoint)drawPipImage:(UIImage *)pipImage atPoint:(CGPoint)drawPoint inContext:(CGContextRef)context {
    CGContextDrawImage(context, CGRectMake(drawPoint.x, drawPoint.y, pipImage.size.width, pipImage.size.height), pipImage.CGImage);
    return CGPointMake(drawPoint.x + pipImage.size.width, drawPoint.y);
}

@end
