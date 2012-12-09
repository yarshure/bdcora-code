/***
 * Excerpted from "Core Animation for Mac OS X and the iPhone",
 * published by The Pragmatic Bookshelf.
 * Copyrights apply to this code. It may not be used to create training material, 
 * courses, books, articles, and the like. Contact us if you are in doubt.
 * We make no guarantees that this code is fit for any purpose. 
 * Visit http://www.pragmaticprogrammer.com/titles/bdcora for more book information.
***/
//
//  OpenGLLayer.h
//  OpenGLLayer
//
//  Created by Bill Dudney on 11/30/07.
//  Copyright 2007 Gala Factory. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <Quartz/Quartz.h>
#import <QuartzCore/QuartzCore.h>

@interface OpenGLLayer : CAOpenGLLayer {
  CFTimeInterval previousTime;
  GLdouble rotation;
  BOOL animate;
  CGLContextObj localContext;
}

@property(assign) BOOL animate;
@property(assign) CGLContextObj localContext;

@end
