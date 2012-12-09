/***
 * Excerpted from "Core Animation for Mac OS X and the iPhone",
 * published by The Pragmatic Bookshelf.
 * Copyrights apply to this code. It may not be used to create training material, 
 * courses, books, articles, and the like. Contact us if you are in doubt.
 * We make no guarantees that this code is fit for any purpose. 
 * Visit http://www.pragmaticprogrammer.com/titles/bdcora for more book information.
***/
//
//  MyView.h
//  SimpleMenuScrolling
//
//  Created by Bill Dudney on 12/5/07.
//  Copyright 2007 Gala Factory. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class MyControllerScroller;

@interface MyView : NSView {
  IBOutlet MyControllerScroller *controller;
}

@end
