/***
 * Excerpted from "Core Animation for Mac OS X and the iPhone",
 * published by The Pragmatic Bookshelf.
 * Copyrights apply to this code. It may not be used to create training material, 
 * courses, books, articles, and the like. Contact us if you are in doubt.
 * We make no guarantees that this code is fit for any purpose. 
 * Visit http://www.pragmaticprogrammer.com/titles/bdcora for more book information.
***/
//
//  Created by Bill Dudney on 10/16/07.
//  Copyright 2007 Bill Dudney. All rights reserved.
//

#import "SharedContentView.h"
#import <QuartzCore/QuartzCore.h>
#import <Quartz/Quartz.h>

@implementation SharedContentView

@synthesize mover;

- (CALayer *)makeCompositionLayer {
  QCCompositionRepository *repo = 
  [QCCompositionRepository sharedCompositionRepository];
  QCComposition *composition = 
  [repo compositionWithIdentifier:@"/moving shapes"];
  QCCompositionLayer *compLayer = 
  [QCCompositionLayer compositionLayerWithComposition:composition];
  CGColorRef cgcolor = CGColorCreateGenericRGB(0.25f, 0.675, 0.1, 1.0);
  [compLayer setValue:(id)cgcolor 
           forKeyPath:[NSString stringWithFormat:@"patch.%@.value", 
                       QCCompositionInputPrimaryColorKey]];
  [compLayer setValue:[NSNumber numberWithFloat:5.0f] 
           forKeyPath:[NSString stringWithFormat:@"patch.%@.value", 
                       QCCompositionInputPaceKey]];
  CGColorRelease(cgcolor);
  return compLayer;
}    

- (void)awakeFromNib { 
  [self setWantsLayer:YES];
  [self setLayer:[self makeCompositionLayer]];
}

- (BOOL)acceptsFirstResponder {
  return YES;
}

- (void)keyDown:(NSEvent *)event { 
	if ([event modifierFlags] & (NSAlphaShiftKeyMask|NSShiftKeyMask)) {
    [NSAnimationContext beginGrouping];
    [[NSAnimationContext currentContext] setDuration:2.0f];
  }
  
  if([[event characters] characterAtIndex:0] == 'a' || 
     [[event characters] characterAtIndex:0] == 'A') {
    NSView *view = self.mover;
    if(nil == [view superview]) {
      [[self animator] addSubview:view];
    } else {
      [[view animator] removeFromSuperview];
    }
  } else {
    [super keyDown:event];
  }
  
	if ([event modifierFlags] & (NSAlphaShiftKeyMask|NSShiftKeyMask)) {
    [NSAnimationContext endGrouping];
  }
}

- (NSImageView *)mover {
  if(nil == mover) {
    mover = [[NSImageView alloc] initWithFrame:[self bounds]];
    [mover setImageScaling:NSScaleToFit];
    [mover setImage:[NSImage imageNamed:@"photo.jpg"]];
    CGFloat xInset = 0.25f * NSWidth([self bounds]);
    CGFloat yInset = 0.25f * NSHeight([self bounds]);
    NSRect moverFrame = NSInsetRect([self bounds], xInset, yInset);
    moverFrame.origin.x = 
    NSMidX([self bounds]) - (NSWidth(moverFrame) / 2.0f);
    moverFrame.origin.y = 
    NSMidY([self bounds]) - (NSHeight(moverFrame) / 2.0f);
    [mover setFrame:moverFrame];
    [mover setAlphaValue:0.50f];
  }
  return mover;
}

@end
