/***
 * Excerpted from "Core Animation for Mac OS X and the iPhone",
 * published by The Pragmatic Bookshelf.
 * Copyrights apply to this code. It may not be used to create training material, 
 * courses, books, articles, and the like. Contact us if you are in doubt.
 * We make no guarantees that this code is fit for any purpose. 
 * Visit http://www.pragmaticprogrammer.com/titles/bdcora for more book information.
***/
//
//  TimingController.h
//  LayerTiming
//
//  Created by Bill Dudney on 2/6/08.
//  Copyright 2008 Gala Factory. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "TimingView.h"

@interface TimingController : NSObject {
  IBOutlet TimingView *timingView;
  NSInteger layerFillMode;
  NSArray *fillModeNames;
}

@property(assign) CGFloat layerSpeed;
@property(assign) CGFloat layerRepeatCount;
@property(assign) CGFloat layerDuration;
@property(assign) CGFloat layerOffset;
@property(assign) CGFloat layerBeginTime;
@property(assign) BOOL layerAutoreverse;
@property(assign) BOOL moveLayer;
@property(assign) NSInteger layerFillMode;
@property(retain) TimingView *timingView;

- (IBAction)top:(id)sender;
- (IBAction)bottom:(id)sender;
- (IBAction)left:(id)sender;
- (IBAction)right:(id)sender;
- (IBAction)recenter:(id)sender;

@end
