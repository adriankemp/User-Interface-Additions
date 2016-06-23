//
//  CircularView.h
//  CircularView
//
//  Created by Adrian Kemp on 2016-06-23.
//

#import <UIKit/UIKit.h>

FOUNDATION_EXPORT double CircularViewVersionNumber;
FOUNDATION_EXPORT const unsigned char CircularViewVersionString[];
IB_DESIGNABLE

@interface CircularView : UIView

@property (nonatomic, assign) IBInspectable CGFloat strokeWidth;

@property (nonatomic, strong) IBInspectable UIColor *fillColor;
@property (nonatomic, strong) IBInspectable UIImage *fillImage;
@property (nonatomic, strong) IBInspectable UIColor *strokeColor;
@property (nonatomic, strong) IBInspectable UIImage *strokeImage;

@end
