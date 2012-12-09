/***
 * Excerpted from "Core Animation for Mac OS X and the iPhone",
 * published by The Pragmatic Bookshelf.
 * Copyrights apply to this code. It may not be used to create training material, 
 * courses, books, articles, and the like. Contact us if you are in doubt.
 * We make no guarantees that this code is fit for any purpose. 
 * Visit http://www.pragmaticprogrammer.com/titles/bdcora for more book information.
***/
//
//  PhotoRotateView.m
//  PhotoPop
//
//  Created by Bill Dudney on 2/7/08.
//  Copyright 2008 Gala Factory. All rights reserved.
//

static CGFloat kLayerWidth = 140.0f;
static CGFloat kLayerHeight = 105.0f;

#import "PhotoRotateView.h"

@interface PhotoRotateView(Color)
- (CGColorRef)black;
@end

@implementation PhotoRotateView

- (CGFloat)randomNumberLessThan:(CGFloat)top {
  return ((CGFloat)random() / (CGFloat)RAND_MAX) * top;
}

- (CGImageRef)imageNamed:(NSString *)name ofType:(NSString *)type {
  CGImageRef image = NULL;
  NSString *path = [[NSBundle mainBundle] pathForResource:name
                                                   ofType:type];
  NSURL *imageURL = [NSURL fileURLWithPath:path];
  CGImageSourceRef src = CGImageSourceCreateWithURL((CFURLRef)imageURL, NULL);
  if(NULL != src) {
    image = CGImageSourceCreateImageAtIndex(src, 0, NULL);
    CFRelease(src);
  }
  return image;
}

- (CALayer *)createLayerForImageNamed:(NSString *)name 
                               ofType:(NSString *)type {
  CALayer *layer = [CALayer layer];
  layer.contents = (id)[self imageNamed:name ofType:type];
  layer.bounds = 
  CGRectMake(0.0f, 0.0f, kLayerWidth, kLayerHeight);
  layer.position = CGPointMake(NSMidX([self bounds]),
                               NSMidY([self bounds]));
  layer.name = name;
  return layer;
}

- (IBAction)setXAnchorPoint:(id)sender {
  CGFloat newValue = [sender floatValue];
  if(newValue >= 0.0f && newValue <= 1.0f) {
    beachLayer.anchorPoint = CGPointMake(newValue, beachLayer.anchorPoint.y); 
  } else {
    NSBeep();
    [sender setFloatValue:0.5f];
  }
}

- (IBAction)setYAnchorPoint:(id)sender {
  CGFloat newValue = [sender floatValue];
  if(newValue >= 0.0f && newValue <= 1.0f) {
    beachLayer.anchorPoint = CGPointMake(beachLayer.anchorPoint.x, newValue); 
  } else {
    NSBeep();
    [sender setFloatValue:0.5f];
  }
}

- (IBAction)rotate:(id)sender {
  [beachLayer setValue:[NSNumber numberWithFloat:(30.0f * M_PI / 180.0f)]
            forKeyPath:@"transform.rotation"];
}

- (IBAction)unrotate:(id)sender {
  [beachLayer setValue:[NSNumber numberWithFloat:0.0f]
            forKeyPath:@"transform.rotation"];
}

- (void)awakeFromNib {
  [self setLayer:[CALayer layer]];
  self.layer.backgroundColor = [self black];
  [self setWantsLayer:YES];
  
  beachLayer = [self createLayerForImageNamed:@"beach" ofType:@"jpg"];
  [self.layer addSublayer:beachLayer];
  
  [xAnchor setFloatValue:beachLayer.anchorPoint.x];
  [yAnchor setFloatValue:beachLayer.anchorPoint.y];
}

@end

@implementation PhotoRotateView (Color)

- (CGColorSpaceRef)genericRGBSpace {
  static CGColorSpaceRef space = NULL;
  if(NULL == space) {
    space = CGColorSpaceCreateWithName (kCGColorSpaceGenericRGB);
  }
  return space;
}

- (CGColorRef)black {
  static CGColorRef black = NULL;
  if(black == NULL) {
    CGFloat values[4] = {0.0, 0.0, 0.0, 1.0};
    black = CGColorCreate([self genericRGBSpace], values);
  }
  return black;
}

@end
