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
//  TiledLayer
//
//  Created by Bill Dudney on 5/19/08.
//  Copyright 2008 Gala Factory. All rights reserved.
//

#import "MyView.h"
#import "TiledDelegate.h"

@implementation MyView

- (BOOL)acceptsFirstResponder {
  return YES;
}

- (void)awakeFromNib {
  self.layer = [CALayer layer];
  self.wantsLayer = YES;
  self.layer.masksToBounds = YES;
  self.layer.cornerRadius = 8.0f;
  
  photoLayer = [CATiledLayer layer];
  TiledDelegate *delegate = [[TiledDelegate alloc] init];
  photoLayer.delegate = delegate; 
  zoomLevel = 1.0f;
  photoLayer.frame = CGRectMake(0.0f, 0.0f, delegate.imageSize.width,
                                delegate.imageSize.height);
  // set the levels of detail (range is 2^-2 to 2^1)
  photoLayer.levelsOfDetail = 4; 
  // set the bias for how many 'zoom in' levels there are
  photoLayer.levelsOfDetailBias = 1; // up to 2x (2^1)of the largest photo
  [photoLayer setNeedsDisplay]; // display the whole layer
  
  [self.layer addSublayer:photoLayer];  
}

- (void)moveRight:(id)sender {
  CGFloat zoomFactor = zoomLevel > 1.0f ? zoomLevel : 1.0f / zoomLevel;
  CGFloat newXPos = photoLayer.position.x - (10.0f * zoomFactor);
  if(newXPos > (CGRectGetMaxX(photoLayer.superlayer.bounds) - 
                CGRectGetWidth(photoLayer.frame) * photoLayer.anchorPoint.x)) {
    photoLayer.position = CGPointMake(newXPos, photoLayer.position.y);
  }
}

- (void)moveLeft:(id)sender {
  CGFloat zoomFactor = zoomLevel > 1.0f ? zoomLevel : 1.0f / zoomLevel;
  CGFloat newXPos = photoLayer.position.x + (10.0f * zoomFactor);
  if((CGRectGetWidth(photoLayer.frame) * photoLayer.anchorPoint.x) - newXPos > 
     CGRectGetMinX(photoLayer.superlayer.bounds)) {
    photoLayer.position = CGPointMake(newXPos, photoLayer.position.y);
  }
}

- (void)moveUp:(id)sender {
  CGFloat zoomFactor = zoomLevel > 1.0f ? zoomLevel : 1.0f / zoomLevel;
  CGFloat newYPos = photoLayer.position.y - (10.0f * zoomFactor);
  // superlayer.height - half the height of big pic 
  if(newYPos > (CGRectGetMaxY(photoLayer.superlayer.bounds) - 
                CGRectGetHeight(photoLayer.frame) * photoLayer.anchorPoint.y)) {
    photoLayer.position = CGPointMake(photoLayer.position.x, newYPos);
  }
}

- (void)moveDown:(id)sender {
  CGFloat zoomFactor = zoomLevel > 1.0f ? zoomLevel : 1.0f / zoomLevel;
  CGFloat newYPos = photoLayer.position.y + (10.0f * zoomFactor);
  if((CGRectGetHeight(photoLayer.frame) * photoLayer.anchorPoint.y) - newYPos >
     CGRectGetMinY(photoLayer.superlayer.bounds)) {
    photoLayer.position = CGPointMake(photoLayer.position.x, newYPos);
  }
}

// move around with two finger scrolling or with the scroll wheel
- (void)scrollWheel:(NSEvent *)event {
  CGFloat newXPos = photoLayer.position.x + event.deltaX;
  CGFloat newYPos = photoLayer.position.y - event.deltaY;
  BOOL useNewX = NO;
  BOOL useNewY = NO;
  // if deltaX is positive moving left otherwise moving right
  if(event.deltaX > 0.0f) {
    if((CGRectGetWidth(photoLayer.frame) * photoLayer.anchorPoint.x) - newXPos > 
       CGRectGetMinX(photoLayer.superlayer.bounds)) {
      useNewX = YES;
    }
  } else {
    if(newXPos > 
       (CGRectGetMaxX(photoLayer.superlayer.bounds) - 
            CGRectGetWidth(photoLayer.frame) * photoLayer.anchorPoint.x)) {
      useNewX = YES;
    }
  }
  if(event.deltaY > 0.0f) { // moving up if greater than zero
    if(newYPos > 
       (CGRectGetMaxY(photoLayer.superlayer.bounds) - 
        CGRectGetHeight(photoLayer.frame) * photoLayer.anchorPoint.y)) {
      useNewY = YES;
    }
  } else {
    if((CGRectGetHeight(photoLayer.frame) * photoLayer.anchorPoint.y) - newYPos > 
       CGRectGetMinY(photoLayer.superlayer.bounds)) {
      useNewY = YES;
    }
  }
  if(!useNewX) { // revert to old pos if need be
    newXPos = photoLayer.position.x;
  }
  if(!useNewY) { // revert to old pos if need be
    newYPos = photoLayer.position.y;
  }
  photoLayer.position = CGPointMake(newXPos, newYPos);
}

// zoom in or out on clicks...
- (void)mouseDown:(NSEvent *)event {
  if(event.modifierFlags & NSControlKeyMask) { // zoom out
    NSInteger power = photoLayer.levelsOfDetail - photoLayer.levelsOfDetailBias;
    if(zoomLevel > pow(2, -power)) { // don't go further that 2 ^ -(levelsOfDetail - levelsOfDetailBias)
      zoomLevel *= 0.5f;
      photoLayer.transform = CATransform3DMakeScale(zoomLevel, zoomLevel, 1.0f);
    }
  } else { // zoom in
    if(zoomLevel < pow(2, photoLayer.levelsOfDetailBias)) {
      zoomLevel *= 2.0f;
      photoLayer.position = CGPointMake(photoLayer.position.x * 2.0f, photoLayer.position.y * 2.0f);
      photoLayer.transform = CATransform3DMakeScale(zoomLevel, zoomLevel, 1.0f);
    }
  }
  // this is the lazy way, should be finding the relative
  // position of the click and centering over that
  photoLayer.position = CGPointMake(CGRectGetWidth(photoLayer.frame) * photoLayer.anchorPoint.x,
                                    CGRectGetHeight(photoLayer.frame) * photoLayer.anchorPoint.y);
  
  [super mouseDown:event];
}

@end
