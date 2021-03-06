/***
 * Excerpted from "Core Animation for Mac OS X and the iPhone",
 * published by The Pragmatic Bookshelf.
 * Copyrights apply to this code. It may not be used to create training material, 
 * courses, books, articles, and the like. Contact us if you are in doubt.
 * We make no guarantees that this code is fit for any purpose. 
 * Visit http://www.pragmaticprogrammer.com/titles/bdcora for more book information.
***/

//
//  Controller.m
//  LayerBackedControls
//
//  Created by Bill Dudney on 11/4/07.
//  Copyright 2007 Bill Dudney. All rights reserved.
//

#import "Controller.h"

@implementation Controller

- (void)awakeFromNib {
  [[rotatingButton superview] setWantsLayer:YES];
}

- (IBAction) rotateButton:(id)sender {
  CGFloat rotation = [rotatingButton frameCenterRotation];
  [rotatingButton setFrameCenterRotation:
   rotation + 15.0f];
}

- (IBAction) beep:(id)sender {
  NSBeep();
}

@end
