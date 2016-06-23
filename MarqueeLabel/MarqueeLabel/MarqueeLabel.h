//
//  MarqueeLabel.h
//  MarqueeLabel
//
//  Created by Adrian Kemp on 2016-06-23.
//

#import <UIKit/UIKit.h>

FOUNDATION_EXPORT double MarqueeLabelVersionNumber;
FOUNDATION_EXPORT const unsigned char MarqueeLabelVersionString[];

IB_DESIGNABLE

@interface MarqueeLabel : UILabel

@property (nonatomic, assign) IBInspectable CGFloat scrollingDuration;
@property (nonatomic, assign) IBInspectable CGFloat scrollingPause;
@property (nonatomic, assign) IBInspectable CGFloat fadeDuration;

@end