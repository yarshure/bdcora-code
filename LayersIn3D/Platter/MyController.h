/***
 * Excerpted from "Core Animation for Mac OS X and the iPhone",
 * published by The Pragmatic Bookshelf.
 * Copyrights apply to this code. It may not be used to create training material, 
 * courses, books, articles, and the like. Contact us if you are in doubt.
 * We make no guarantees that this code is fit for any purpose. 
 * Visit http://www.pragmaticprogrammer.com/titles/bdcora for more book information.
***/
//
//  MyController.h
//  MenuLayout
//
//  Created by Bill Dudney on 01/09/2008.
//  Copyright 2007 Gala Factory. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <QuartzCore/QuartzCore.h>

@class MyView;

@interface MyController : NSObject {
  IBOutlet MyView *view;
  CGFloat offset;
  CIFilter *bloomArrowEffect;
  CALayer *highlightLayer;
}

@property(assign) CGFloat offset;

- (CALayer *)menuLayer;
- (CAScrollLayer *)scrollLayer;
- (CALayer *)platterLayer;
- (void)selectItemAt:(NSNumber *)index;
- (void)selectNext;
- (void)selectPrevious;

@end
