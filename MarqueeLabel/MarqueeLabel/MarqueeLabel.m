//
//  MarqueeLabel.m
//  MarqueeLabel
//
//  Created by Adrian Kemp on 2015-06-10.
//

#import <objc/runtime.h>
#import "MarqueeLabel.h"

@interface MarqueeLabel ()

@property (nonatomic, strong) NSArray *observedKeyPaths;
@property (nonatomic, strong) MarqueeLabel *duplicateLabel;

@end

@implementation MarqueeLabel

- (void)dealloc {
    for (NSString *observedKeyPath in self.observedKeyPaths) {
        [self removeObserver:self forKeyPath:observedKeyPath];
    }
}

- (void)observeBaseClassValues {
    unsigned int propertyCount = 0;
    objc_property_t *properties = class_copyPropertyList([UILabel class], &propertyCount);
    
    NSMutableArray *observedKeyPaths = [NSMutableArray new];
    for (unsigned int propertyIndex = 0; propertyIndex < propertyCount; propertyIndex++) {
        NSString *propertyName = [NSString stringWithCString:property_getName(properties[propertyIndex]) encoding:NSUTF8StringEncoding];
        NSString *selectorString = [[@"set" stringByAppendingString:propertyName.capitalizedString] stringByAppendingString:@":"];
        if ([super respondsToSelector:NSSelectorFromString(selectorString)]) {
            [observedKeyPaths addObject:propertyName];
            [self addObserver:self forKeyPath:propertyName options:NSKeyValueObservingOptionNew context:nil];
        }
    }
    
    self.observedKeyPaths = [observedKeyPaths copy];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self observeBaseClassValues];
    
    self.duplicateLabel = [self.class new];
    for (NSString *observedKeyPath in self.observedKeyPaths) {
        id value = [self valueForKey:observedKeyPath];
        [self.duplicateLabel setValue:value forKey:observedKeyPath];
        [self.duplicateLabel setNeedsDisplay];
    }
    if (self.attributedText) { //reset attributed text, as it gets lost.
        self.duplicateLabel.attributedText = self.attributedText;
    }
    
    [self.layer addSublayer:self.duplicateLabel.layer];
    CGSize requiredSize = [super sizeThatFits:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)];
    self.duplicateLabel.layer.frame = CGRectMake(0, 0, requiredSize.width, requiredSize.height);
}

- (void)updateConstraints {
    [super updateConstraints];
    [self addAnimation];
}

- (void)drawLayer:(CALayer *)layer inContext:(CGContextRef)ctx {
    if (self.duplicateLabel && layer == self.layer) {
        return;
    } else {
        [super drawLayer:layer inContext:ctx];
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    id value = [self valueForKey:keyPath];
    [self.duplicateLabel setValue:value forKey:keyPath];
}

- (void)addAnimation {
    if (self.duplicateLabel == nil) {
        return;
    }
    CGSize viewSize = [self systemLayoutSizeFittingSize:CGSizeMake(CGFLOAT_MAX,CGFLOAT_MAX)];
    [self.duplicateLabel.layer removeAllAnimations];
    CGPoint currentCenter = self.duplicateLabel.layer.position;
    
    CABasicAnimation *marqueeAnimation = [CABasicAnimation animationWithKeyPath:@"position"];
    marqueeAnimation.fromValue = [NSValue valueWithCGPoint:currentCenter];
    marqueeAnimation.toValue = [NSValue valueWithCGPoint:CGPointMake(MIN(viewSize.width - currentCenter.x, currentCenter.x), currentCenter.y)];
    marqueeAnimation.duration = self.scrollingDuration;
    marqueeAnimation.beginTime = self.fadeDuration/2;
    marqueeAnimation.fillMode = kCAFillModeForwards;
    marqueeAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    
    CABasicAnimation *fadeInAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    fadeInAnimation.fromValue = @0;
    fadeInAnimation.toValue = @1;
    fadeInAnimation.duration = self.fadeDuration/2;
    fadeInAnimation.fillMode = kCAFillModeForwards;
    fadeInAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    
    CABasicAnimation *fadeOutAnimation = [fadeInAnimation copy];
    fadeOutAnimation.beginTime = self.scrollingPause + self.scrollingDuration + self.fadeDuration/2;
    fadeOutAnimation.fromValue = @1;
    fadeOutAnimation.toValue = @0;
    
    CAAnimationGroup *repeatGroup = [CAAnimationGroup animation];
    repeatGroup.duration = self.scrollingPause + self.scrollingDuration + self.fadeDuration;
    if (self.fadeDuration > 0.0f) {
        repeatGroup.animations = @[fadeInAnimation, marqueeAnimation, fadeOutAnimation];
    } else {
        repeatGroup.animations = @[marqueeAnimation];
    }
    repeatGroup.repeatCount = HUGE_VALF;
    [self.duplicateLabel.layer addAnimation:repeatGroup forKey:@"marquee"];
}

@end
