/***
 * Excerpted from "Core Animation for Mac OS X and the iPhone",
 * published by The Pragmatic Bookshelf.
 * Copyrights apply to this code. It may not be used to create training material, 
 * courses, books, articles, and the like. Contact us if you are in doubt.
 * We make no guarantees that this code is fit for any purpose. 
 * Visit http://www.pragmaticprogrammer.com/titles/bdcora for more book information.
***/
//
//  TiledDelegate.m
//  TiledLayer
//
//  Created by Bill Dudney on 5/19/08.
//  Copyright 2008 Gala Factory. All rights reserved.
//

#import "TiledDelegate.h"

@implementation TiledDelegate

@synthesize sliceSize;
@synthesize imageSize;

- (id)init {
  self = [super init];
  self.sliceSize = CGSizeMake(1527.0f, 1094.0f);
  self.imageSize = CGSizeMake(1527.0f * 6.0f, 1094.0f * 4.0f);
  return self;
}

- (CGImageRef)imageNamed:(NSString *)name ofType:(NSString *)type {
  CGImageRef newImage = NULL;
  NSString *path = [[NSBundle mainBundle] pathForResource:name
                                                   ofType:type];
  if(path != nil) {
    NSURL *imageURL = [NSURL fileURLWithPath:path];
    if(nil != imageURL) {
      CGImageSourceRef src = CGImageSourceCreateWithURL((CFURLRef)imageURL, NULL);
      if(NULL != src) {
        newImage = CGImageSourceCreateImageAtIndex(src, 0, NULL);
        CFRelease(src);
      }
    }
  }
  return newImage;
}

- (void)dealloc {
  [super dealloc];
}

- (void)drawLayer:(CALayer *)layer inContext:(CGContextRef)ctx {
  CGRect bounds = CGContextGetClipBoundingBox(ctx);
  NSInteger leftColumn = floor(CGRectGetMinX(bounds) / self.sliceSize.width);
  NSInteger bottomRow = floor(CGRectGetMinY(bounds) / self.sliceSize.height);
  NSInteger rightColumn = floor(CGRectGetMaxX(bounds) / self.sliceSize.width);
  NSInteger topRow = floor(CGRectGetMaxY(bounds) / self.sliceSize.height);
  NSInteger rowCount = topRow - bottomRow + 1;
  NSInteger columnCount = rightColumn - leftColumn + 1;
  for(int i = bottomRow;i < bottomRow + rowCount;i++) {
    for(int j = leftColumn;j < leftColumn + columnCount;j++) {
      CGPoint origin = CGPointMake(j * self.sliceSize.width,
                                   i * self.sliceSize.height);
      NSString *imgName = [NSString stringWithFormat:@"%dx%dy", 
                           (NSInteger)origin.x, (NSInteger)origin.y];
      CGImageRef image = [self imageNamed:imgName ofType:@"png"];
      if(NULL != image) {
        CGRect drawRect = CGRectMake(origin.x, origin.y, self.sliceSize.width,
                                     self.sliceSize.height);
        CGContextDrawImage(ctx, drawRect, image);

        CGImageRelease(image);
      }
    }
  }
}

@end
