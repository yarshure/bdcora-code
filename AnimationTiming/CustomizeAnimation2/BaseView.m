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

#import "BaseView.h"
#import <QuartzCore/QuartzCore.h>

@implementation BaseView
@synthesize mover;
-(void)initializeFramePositions {
  NSRect moverRect = NSInsetRect([self bounds], 
                                 [self bounds].size.width / 4.0f, 
                                 [self bounds].size.height / 4.0f);
  moverRect.origin.x = 0.0f;
	mover = [[NSImageView alloc] initWithFrame:moverRect];
  leftPosition = NSMakePoint(0.0, NSMinY(moverRect));
	rightPosition = NSMakePoint(NSMaxX([self bounds]) - NSWidth(moverRect), NSMinY(moverRect)); 
	isRight = NO;
}

-(void)addImageToSubview {
	[mover setImageScaling:NSScaleToFit];
	[mover setImage:[NSImage imageNamed:@"photo.jpg"]];
}

- (id)initWithFrame:(NSRect)frame { 
  self = [super initWithFrame:frame];
  if (self) {
		[self initializeFramePositions]; 
		[self addImageToSubview];        
		[self addSubview:mover];         
	}
  return self;
}

- (BOOL)acceptsFirstResponder { 
  return YES;
}

- (void)keyDown:(NSEvent *)event { 
	[self move];
}

- (void)move { 
  NSPoint target;
	if(isRight) {
		target = leftPosition;
	} else {
		target = rightPosition;
	}
	[[mover animator] setFrameOrigin:target];
	isRight = !isRight;
}

@end
