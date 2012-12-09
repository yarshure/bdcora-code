/***
 * Excerpted from "Core Animation for Mac OS X and the iPhone",
 * published by The Pragmatic Bookshelf.
 * Copyrights apply to this code. It may not be used to create training material, 
 * courses, books, articles, and the like. Contact us if you are in doubt.
 * We make no guarantees that this code is fit for any purpose. 
 * Visit http://www.pragmaticprogrammer.com/titles/bdcora for more book information.
***/
//
//  MyView.m
//  MenuLayout
//
//  Created by Bill Dudney on 01/09/2008.
//  Copyright 2007 Gala Factory. All rights reserved.
//

#import "MyView.h"
#import <QuartzCore/QuartzCore.h>
#import "MyController.h"

@implementation MyView

-(void)moveUp:(id)sender {
  [controller selectPrevious];
}

-(void)moveDown:(id)sender {
  [controller selectNext];
}

@end
