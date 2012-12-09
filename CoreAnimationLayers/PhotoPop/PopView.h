/***
 * Excerpted from "Core Animation for Mac OS X and the iPhone",
 * published by The Pragmatic Bookshelf.
 * Copyrights apply to this code. It may not be used to create training material, 
 * courses, books, articles, and the like. Contact us if you are in doubt.
 * We make no guarantees that this code is fit for any purpose. 
 * Visit http://www.pragmaticprogrammer.com/titles/bdcora for more book information.
***/
//
//  PopView.h
//  PhotoPop
//
//  Created by Bill Dudney on 2/7/08.
//  Copyright 2008 Gala Factory. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <QuartzCore/QuartzCore.h>

@interface PopView : NSView {
  CALayer *beach1Layer;
  CALayer *beach2Layer;
  CALayer *beach3Layer;
}

- (IBAction)move:(id)sender;

@end
