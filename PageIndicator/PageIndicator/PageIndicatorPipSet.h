//
//  PageIndicatorPipSet.h
//  PageIndicator
//
//  Created by Adrian Kemp on 2015-04-27.
//

#import <UIKit/UIKit.h>

@interface PageIndicatorPipSet : NSObject

@property (nonatomic, copy) UIImage *leftPipImage;
@property (nonatomic, copy) UIImage *rightPipImage;
@property (nonatomic, copy) UIImage *centerPipImage;

- (CGSize)renderedSizeForPageCount:(NSUInteger)pageCount;
- (UIImage *)imageForPageCount:(NSInteger)pageCount;

@end
