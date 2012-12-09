/***
 * Excerpted from "Core Animation for Mac OS X and the iPhone",
 * published by The Pragmatic Bookshelf.
 * Copyrights apply to this code. It may not be used to create training material, 
 * courses, books, articles, and the like. Contact us if you are in doubt.
 * We make no guarantees that this code is fit for any purpose. 
 * Visit http://www.pragmaticprogrammer.com/titles/bdcora for more book information.
***/
//
//  QuartzCompositionView.m
//  QuartzComposerLayers
//
//  Created by Bill Dudney on 2/19/08.
//  Copyright 2008 Gala Factory. All rights reserved.
//

#import "QuartzCompositionView.h"

@interface QuartzCompositionView(Color)
- (CGColorRef)black;
@end

@interface QuartzCompositionView (BookStuff)

@property(readonly) CABasicAnimation *animation;

- (QCCompositionLayer *)compositionLayer;

@end

@implementation QuartzCompositionView

- (void)awakeFromNib {
  self.layer = self.compositionLayer;
  self.wantsLayer = YES;
}

- (void)mouseDown:(NSEvent *)event {
  if(nil == [self.layer animationForKey:@"compositionAnimation"]) {
    [self.layer addAnimation:self.animation forKey:@"compositionAnimation"];
  } else {
    [self.layer removeAnimationForKey:@"compositionAnimation"];
  }
}

@end

@implementation QuartzCompositionView(BookStuff)

- (CABasicAnimation *)animation {
  static CABasicAnimation *animation = nil;
  if(nil == animation) {
    NSString *keyPath = [NSString stringWithFormat:@"patch.%@.value", 
                         QCCompositionInputPaceKey];
    animation = [[CABasicAnimation animationWithKeyPath:keyPath] retain];
    animation.repeatCount = 1.0e100;
    animation.fromValue = [NSNumber numberWithFloat:0.25f];
    animation.toValue = [NSNumber numberWithFloat:3.0f];
    animation.autoreverses = YES;
    animation.duration = 10.0f;
  }
  return animation;
}

- (NSString *)compositionPath {
  // this is in a separate method just so that I did not have to mess with
  // making it fit into the book
  return @"/Developer/Examples/Quartz Composer/Compositions/Graphic Animations/Cells.qtz";
}

- (QCCompositionLayer *)compositionLayer {
  return [QCCompositionLayer compositionLayerWithFile:[self compositionPath]];
}

@end


@implementation QuartzCompositionView (Color)

- (CGColorSpaceRef)genericRGBSpace {
  static CGColorSpaceRef space = NULL;
  if(NULL == space) {
    space = CGColorSpaceCreateWithName (kCGColorSpaceGenericRGB);
  }
  return space;
}

- (CGColorRef)black {
  static CGColorRef black = NULL;
  if(black == NULL) {
    CGFloat values[4] = {0.0, 0.0, 0.0, 1.0};
    black = CGColorCreate([self genericRGBSpace], values);
  }
  return black;
}

@end
