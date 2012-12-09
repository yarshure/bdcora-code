/***
 * Excerpted from "Core Animation for Mac OS X and the iPhone",
 * published by The Pragmatic Bookshelf.
 * Copyrights apply to this code. It may not be used to create training material, 
 * courses, books, articles, and the like. Contact us if you are in doubt.
 * We make no guarantees that this code is fit for any purpose. 
 * Visit http://www.pragmaticprogrammer.com/titles/bdcora for more book information.
***/
//
//  PlatterLayoutManager.m
//  Platter
//
//  Created by Bill Dudney on 1/21/08.
//  Copyright 2008 Gala Factory. All rights reserved.
//

#import "PlatterLayoutManager.h"
#import <QuartzCore/QuartzCore.h>

@implementation PlatterLayoutManager

+ (id)layoutManager {
  return [[[self alloc] init] autorelease];
}

- (id)init {
  self = [super init];
  selectedImageSize = 128.0f;
  return self;
}

- (void)layoutSublayersOfLayer:(CALayer *)layer {
  NSNumber *selectedItemIndex = [layer valueForKey:@"selectedItem"];
  NSInteger selectedItemIndexInt = [selectedItemIndex intValue];
  CALayer *selectedImageLayer = [[layer sublayers]
                                 objectAtIndex:selectedItemIndexInt];
  CGRect layerBounds = layer.bounds;
  CGPoint selectedPosition = 
  CGPointMake(layerBounds.size.width - selectedImageSize / 1.5f, 
              layerBounds.size.height / 2.0);
  NSInteger index = 0;
  for(index = 0;index < [[layer sublayers] count];index++) {
    CALayer *sublayer = [[layer sublayers] objectAtIndex:index];
    if(sublayer == selectedImageLayer) {
      selectedImageLayer.zPosition = 100.0f;
      selectedImageLayer.bounds = CGRectMake(0.0f, 0.0f, 
                                             selectedImageSize, 
                                             selectedImageSize);
      selectedImageLayer.position = selectedPosition;
    } else {
      NSInteger offset = selectedItemIndexInt - index;
      if(offset > 0) { 
        sublayer.bounds = CGRectMake(0.0f, 0.0f, selectedImageSize * 2.0f, 
                                     selectedImageSize * 2.0f);
        sublayer.position = 
        CGPointMake(-selectedImageSize * 2.0f, 
                    selectedPosition.y + selectedImageSize/2.0f);
        sublayer.zPosition = 200.0f;
      } else {
        CGFloat unselectedImageSize = 
        selectedImageSize * (1.0f + (0.35f * offset));
        sublayer.bounds = CGRectMake(0.0f, 0.0f, 
                                     unselectedImageSize, 
                                     unselectedImageSize);
        sublayer.position = 
        CGPointMake(selectedPosition.x + (offset * 135.0f), 
                    selectedPosition.y + (offset * 5.0f));
        sublayer.zPosition = offset * 30.0f;
      }
    }
  }
}

@end
