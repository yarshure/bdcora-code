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

-(void)initializeFramePositions {
	CGFloat  frameX = NSWidth([self frame]);
	CGFloat  frameY = NSHeight([self frame]);
	leftFramePosition = NSMakeRect(0.0f, 0.0f, frameX / 4.0f, 
                                 frameY / 4.0f);
	rightFramePosition = NSMakeRect(7.0f * frameX / 8.0f, 
                                  7.0f *frameY / 16.0f, 
                                  frameX / 8.0f, frameY/ 8.0f); 
	
	mover = [[NSImageView alloc] initWithFrame:leftFramePosition];
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
  if(isRight) {
    [mover setFrame:leftFramePosition];
  } else {
    [mover setFrame:rightFramePosition];
  }
  isRight = !isRight;
}

@end
