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

#import "TransitionView.h"
#import <QuartzCore/QuartzCore.h>

@implementation TransitionView

@synthesize beach;
@synthesize snow;

- (id)initWithFrame:(NSRect)frame { 
  self = [super initWithFrame:frame];
  if (self) {
    [self addSubview:self.beach];
  }
  return self;
}

- (BOOL)acceptsFirstResponder { 
  return YES;
}

- (void)keyDown:(NSEvent *)event { 
  if(nil != [self.beach superview]) {
    [[self animator] replaceSubview:self.beach with:self.snow];
  } else if(nil != [self.snow superview]) {
    [[self animator] replaceSubview:self.snow with:self.beach];
  }
}

- (NSImageView *)beach { 
  if(nil == beach) {
    beach = [self imageViewForImageNamed:@"beach.jpg"];
  }
  return beach;
}    

- (NSImageView *)snow { 
  if(nil == snow) {
    snow = [self imageViewForImageNamed:@"snow.jpg"];
  }
  return snow;
}

- (NSImageView *)imageViewForImageNamed:(NSString *)imageName { 
  CGFloat xInset = 0.125f * NSWidth(self.frame);
  CGFloat yInset = 0.125f * NSHeight(self.frame);
  NSRect subFrame = NSInsetRect(self.frame, xInset, yInset);
  subFrame.origin.x = NSMidX([self bounds]) - (NSWidth(subFrame) / 2.0f);
  subFrame.origin.y = NSMidY([self bounds]) - (NSHeight(subFrame) / 2.0f);
  NSImageView *imageView = [[NSImageView alloc] initWithFrame:subFrame];
  [imageView setImageScaling:NSScaleToFit];
  [imageView setImage:[NSImage imageNamed:imageName]];
  return imageView;
}

@end
