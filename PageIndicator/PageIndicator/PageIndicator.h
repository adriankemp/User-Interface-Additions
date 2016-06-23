//
//  PageIndicator.h
//  PageIndicator
//
//  Created by Adrian Kemp on 2016-06-23.
//

#import <UIKit/UIKit.h>
#import <PageIndicator/PageIndicatorPipSet.h>

FOUNDATION_EXPORT double PageIndicatorVersionNumber;
FOUNDATION_EXPORT const unsigned char PageIndicatorVersionString[];
IB_DESIGNABLE

@interface PageIndicator : UIView

@property (nonatomic, assign) CGRect highlightFrame;
@property (nonatomic, weak) IBOutlet UIScrollView *scrollView;
@property (nonatomic, copy) PageIndicatorPipSet *backingPipSet;
@property (nonatomic, copy) PageIndicatorPipSet *highlightPipSet;

@end
