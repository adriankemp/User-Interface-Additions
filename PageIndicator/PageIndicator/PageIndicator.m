//
//  PageIndicator.m
//  PageIndicator
//
//  Created by Adrian Kemp on 2015-04-27.
//

#import "PageIndicator.h"

@interface PageIndicator ()

@property (nonatomic, weak) IBOutlet UIView *backingView;
@property (nonatomic, weak) IBOutlet UIView *highlightView;
@property (nonatomic, weak) IBOutlet UIView *highlightContainerView;

@property (nonatomic, assign) NSInteger pageCount;

@end

@implementation PageIndicator
@synthesize highlightFrame=_highlightFrame;
@synthesize backingView=_backingView;
@synthesize highlightView=_highlightView;
@synthesize highlightContainerView=_highlightContainerView;

- (void)prepareForInterfaceBuilder {
    if (self.backingView == self.highlightView) {/*generate them if missing*/}
    self.pageCount = 9;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.clipsToBounds = YES;
    if (self.backingView == self.highlightView) {/*generate them if missing*/}
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self.backingView == self.highlightView) {/*generate them if missing*/}
    return self;
}

- (CGRect)highlightFrame {
    if (CGRectIsEmpty(_highlightFrame)) {
        if (self.highlightPipSet) {
            _highlightFrame = CGRectMake(0, 0, self.highlightPipSet.centerPipImage.size.width, self.highlightPipSet.centerPipImage.size.height);
        } else {
            _highlightFrame = CGRectMake(0, 0, 20, 20);
        }
    }
    return _highlightFrame;
}

- (UIView *)backingView {
    if (!_backingView) {
        UIImage *backingViewImage;
        if (self.backingPipSet) {
            backingViewImage = [self.backingPipSet imageForPageCount:self.pageCount];
        }
        [self addSubview:_backingView = (UIView *)[[UIImageView alloc] initWithImage:backingViewImage]];
        [self sizeToFit];
    }
    return _backingView;
}

- (void)setBackingView:(UIView *)backingView {
    if (_backingView == backingView) {return;}
    [_backingView removeFromSuperview];
    _backingView = backingView;
}

- (UIView *)highlightView {
    if (!_highlightView) {
        UIImage *highlightViewImage;
        if (self.highlightPipSet) {
            highlightViewImage = [self.highlightPipSet imageForPageCount:self.pageCount];
        }
        [self.highlightContainerView addSubview:_highlightView = (UIView *)[[UIImageView alloc] initWithImage:highlightViewImage]];
    }
    return _highlightView;
}

- (void)setHighlightView:(UIView *)highlightView {
    if(_highlightView == highlightView) {return;}
    [_highlightView removeFromSuperview];
    _highlightView = highlightView;
}

- (UIView *)highlightContainerView {
    if (!_highlightContainerView) {
        self.highlightFrame = CGRectZero;
        [self addSubview:_highlightContainerView = (UIView *)[[UIView alloc] initWithFrame:self.highlightFrame]];
        _highlightContainerView.clipsToBounds = YES;
    }
    return _highlightContainerView;
}

- (void)setHighlightContainerView:(UIView *)highlightContainerView {
    [_highlightContainerView removeFromSuperview];
    _highlightContainerView = highlightContainerView;
}

- (void)setScrollView:(UIScrollView *)scrollView {
    [_scrollView removeObserver:self forKeyPath:@"contentOffset"];
    
    //This looks odd, I know. Here's the deal -- if you set the scroll view via a storyboard (or nib)
    //it will not have set up it's content size right away, that happens after constraints fire.
    //So, what we do is register ourselves to observe it, but don't actually set it. When the constraints
    //fire we'll get an observation callback on the contentOffset and will then proceed to reset self.scrollView
    if ( !CGSizeEqualToSize(scrollView.contentSize, CGSizeZero) ) {
        _scrollView = scrollView;
        [scrollView removeObserver:self forKeyPath:@"contentOffset"];
        self.pageCount = (NSInteger)ceil(self.scrollView.contentSize.width / self.scrollView.bounds.size.width);
        dispatch_async(dispatch_get_main_queue(), ^{
            [self invalidateIntrinsicContentSize];
        });
    }
    [scrollView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)setHighlightPipSet:(PageIndicatorPipSet *)highlightPipSet {
    _highlightPipSet = highlightPipSet;
    self.highlightContainerView = nil;
    self.highlightView = nil;
    [self.highlightView setNeedsDisplay];
}

- (void)setBackingPipSet:(PageIndicatorPipSet *)backingPipSet {
    _backingPipSet = backingPipSet;
    self.backingView = nil;
    [self.backingView setNeedsDisplay];
}

- (CGSize)intrinsicContentSize {
    return [self sizeThatFits:CGSizeZero];
}

- (CGSize)sizeThatFits:(CGSize)size {
    return [self.backingPipSet renderedSizeForPageCount:self.pageCount];
}

#pragma mark - Key Value Observation selectors

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if (self.scrollView == nil) {self.scrollView = object;} //Rewiring a scrollview that came from nib/storyboard (see above)
    if (object != self.scrollView) {return;}
    
    UIScrollView *scrollView = object;
    CGFloat scrollingProgress;
    scrollingProgress = scrollView.contentOffset.x / scrollView.contentSize.width;
    CGFloat xOffset = self.backingView.bounds.size.width * scrollingProgress;
    self.highlightContainerView.transform = CGAffineTransformMakeTranslation(xOffset, 0.0f);
    self.highlightView.transform = CGAffineTransformMakeTranslation(-xOffset, 0.0f);
}

@end
