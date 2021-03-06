/***
 * Excerpted from "Core Animation for Mac OS X and the iPhone",
 * published by The Pragmatic Bookshelf.
 * Copyrights apply to this code. It may not be used to create training material, 
 * courses, books, articles, and the like. Contact us if you are in doubt.
 * We make no guarantees that this code is fit for any purpose. 
 * Visit http://www.pragmaticprogrammer.com/titles/bdcora for more book information.
***/
//
//  CaptureView.h
//  CaptureLayer
//
//  Created by Bill Dudney on 2/19/08.
//  Copyright 2008 Gala Factory. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <QuartzCore/QuartzCore.h>
#import <QTKit/QTKit.h>

@interface CaptureView : NSView {
  QTCaptureLayer *captureLayer;
  CIFilter *filter;
  CABasicAnimation *animation;
}

@end
