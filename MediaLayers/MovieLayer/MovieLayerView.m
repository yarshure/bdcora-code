/***
 * Excerpted from "Core Animation for Mac OS X and the iPhone",
 * published by The Pragmatic Bookshelf.
 * Copyrights apply to this code. It may not be used to create training material, 
 * courses, books, articles, and the like. Contact us if you are in doubt.
 * We make no guarantees that this code is fit for any purpose. 
 * Visit http://www.pragmaticprogrammer.com/titles/bdcora for more book information.
***/
//
//  MovieLayerView.m
//  MovieLayer
//
//  Created by Bill Dudney on 2/15/08.
//  Copyright 2008 Gala Factory. All rights reserved.
//

#import "MovieLayerView.h"
#import "MovieLayoutManager.h"

@interface QTMovie (Extras)
- (id)currentFrameCGImage;
- (id)posterCGImage;
@end

@interface MovieLayerView(Color)
- (CGColorRef)black;
- (CGColorRef)red;
@end

@interface MovieLayerView (BookStuff)
- (CALayer *)movieLayerWithMovie:(QTMovie *)movie named:(NSString *)movieName;
- (void)loadMovieLayers;
- (void)stopSelectedMovie;
- (void)playSelectedMovie;
- (void)moveUp:(id)sender;
- (void)moveToNextMovie;
- (void)moveRight:(id)sender;
- (void)moveToPreviousMovie;
- (void)moveDown:(id)sender;
- (void)moveLeft:(id)sender;
@end

@implementation MovieLayerView

- (void)awakeFromNib {
  self.layer = [CALayer layer];
  self.layer.backgroundColor = CGColorGetConstantColor(kCGColorBlack);
  [self setWantsLayer:YES];
  [self loadMovieLayers]; 
  [self.layer setValue:[NSNumber numberWithInt:0] forKey:@"selectedIndex"];
  self.layer.layoutManager = [MovieLayoutManager layoutManager];
  [self playSelectedMovie];
  [self becomeFirstResponder];
}

-(BOOL)acceptsFirstResponder {
  return YES;
}

@end

@implementation MovieLayerView (BookStuff)

- (CALayer *)movieLayerWithMovie:(QTMovie *)movie named:(NSString *)movieName {
  QTMovieLayer *movieLayer = [QTMovieLayer layerWithMovie:movie]; 
  movieLayer.bounds = CGRectMake(0.0f, 0.0f, 620.0f, 480.0f);
  movieLayer.name = [NSString stringWithFormat:@"movie - %@", movieName];
  movieLayer.cornerRadius = 14.0f;
  movieLayer.masksToBounds = YES;
  [movieLayer addConstraint:
   [CAConstraint constraintWithAttribute:kCAConstraintMidX 
                              relativeTo:@"superlayer" 
                               attribute:kCAConstraintMidX]];
  [movieLayer addConstraint:
   [CAConstraint constraintWithAttribute:kCAConstraintMaxY 
                              relativeTo:@"superlayer" 
                               attribute:kCAConstraintMaxY 
                                  offset:-5.0f]];
  CALayer *moviePosterLayer = [CALayer layer];
  moviePosterLayer.contents = [movie posterCGImage];
  moviePosterLayer.cornerRadius = 14.0f;
  moviePosterLayer.masksToBounds = YES;
  CATransition *fade = [CATransition animation];
  fade.duration = 0.15f;
  fade.type = kCATransitionFade;
  moviePosterLayer.actions = [NSDictionary dictionaryWithObject:fade forKey:@"hidden"];
  [moviePosterLayer addConstraint:[CAConstraint constraintWithAttribute:kCAConstraintMidX 
                                                             relativeTo:movieLayer.name
                                                              attribute:kCAConstraintMidX]];
  [moviePosterLayer addConstraint:[CAConstraint constraintWithAttribute:kCAConstraintMidY 
                                                             relativeTo:movieLayer.name 
                                                              attribute:kCAConstraintMidY]];
  [moviePosterLayer addConstraint:[CAConstraint constraintWithAttribute:kCAConstraintWidth
                                                             relativeTo:movieLayer.name
                                                              attribute:kCAConstraintWidth]];
  [moviePosterLayer addConstraint:[CAConstraint constraintWithAttribute:kCAConstraintHeight 
                                                             relativeTo:movieLayer.name 
                                                              attribute:kCAConstraintHeight]];
  
  CATextLayer *nameLayer = [CATextLayer layer];
  nameLayer.name = [NSString stringWithFormat:@"name - %@", movieName];
  nameLayer.string = movieName;
  nameLayer.alignmentMode = kCAAlignmentCenter;
  nameLayer.truncationMode = kCATruncationMiddle;
  nameLayer.font = [NSFont boldSystemFontOfSize:18.0f];
  nameLayer.fontSize = 24.0f;
  nameLayer.backgroundColor = [self black];
  [nameLayer addConstraint:[CAConstraint constraintWithAttribute:kCAConstraintMidX relativeTo:@"superlayer" attribute:kCAConstraintMidX]];
  [nameLayer addConstraint:[CAConstraint constraintWithAttribute:kCAConstraintWidth relativeTo:@"superlayer" attribute:kCAConstraintWidth]];
  [nameLayer addConstraint:[CAConstraint constraintWithAttribute:kCAConstraintMinY relativeTo:@"superlayer" attribute:kCAConstraintMinY]];
  
  CALayer *holder = [CALayer layer];
  holder.layoutManager = [CAConstraintLayoutManager layoutManager];
  [holder addSublayer:movieLayer];
  [holder addSublayer:moviePosterLayer];
  [holder addSublayer:nameLayer];
  [holder setValue:movie forKey:@"movie"];
  [holder setValue:movieLayer forKey:@"movieLayer"];
  [holder setValue:moviePosterLayer forKey:@"moviePosterLayer"];
  [holder setValue:nameLayer forKey:@"nameLayer"];
  holder.name = [NSString stringWithFormat:@"holder - %@", movieName];
  return holder;
}

- (void)loadMovieLayers {
  NSError *error = nil;
  NSString *path = @"/System/Library/Compositions";
  NSArray *movieNames = [[NSFileManager defaultManager] 
                         contentsOfDirectoryAtPath:path
                         error:&error];
  for(NSString *movieName in movieNames) {
    if(![[movieName pathExtension] isEqualToString:@"mov"]) { 
      continue;
    }
    NSString *moviePath = [path stringByAppendingPathComponent:movieName];
    if([QTMovie canInitWithFile:moviePath]) {
      NSError *error = nil;
      QTMovie *movie = [QTMovie movieWithFile:moviePath error:&error]; 
      if(nil == error) {
        CALayer *movieLayer = [self movieLayerWithMovie:movie named:movieName];
        [self.layer addSublayer:movieLayer];
      } else {
        NSLog(@"error = %@", error);
      }
    }
  }
}

- (void)stopSelectedMovie {
  NSInteger selection = [[self.layer valueForKey:@"selectedIndex"] intValue];
  CALayer *holderLayer = [self.layer.sublayers objectAtIndex:selection];
  QTMovie *movie = [holderLayer valueForKey:@"movie"];
  [movie stop];
}

- (void)playSelectedMovie {
  NSInteger selection = [[self.layer valueForKey:@"selectedIndex"] intValue];
  CALayer *holderLayer = [self.layer.sublayers objectAtIndex:selection];
  QTMovie *movie = [holderLayer valueForKey:@"movie"];
  [movie play];
  [[holderLayer valueForKey:@"moviePosterLayer"] setHidden:YES];
}

- (void)moveUp:(id)sender {
  if([[NSApp currentEvent] modifierFlags] & NSShiftKeyMask) {
    [self.layer.layoutManager 
     setValue:[NSNumber numberWithBool:YES] forKey:@"slowMoFlag"];
  }
  [self moveToNextMovie];
}

- (void)moveToNextMovie {
  [self stopSelectedMovie]; 
  NSInteger selection = [[self.layer valueForKey:@"selectedIndex"] intValue];
  NSNumber *newSelection = 
  [NSNumber numberWithInt:(selection + 1) % [self.layer.sublayers count]];
  [self.layer setValue:newSelection forKey:@"selectedIndex"];
  [self.layer setNeedsLayout];
  [self playSelectedMovie]; 
}


- (void)moveRight:(id)sender {
  if([[NSApp currentEvent] modifierFlags] & NSShiftKeyMask) {
    [self.layer.layoutManager setValue:[NSNumber numberWithBool:YES] forKey:@"slowMoFlag"];
  }
  [self moveToNextMovie];
}

- (void)moveToPreviousMovie {
  [self stopSelectedMovie];
  NSInteger selection = [[self.layer valueForKey:@"selectedIndex"] intValue] - 1;
  selection = selection > -1 ? selection % [self.layer.sublayers count] : [self.layer.sublayers count] - 1;
  [self.layer setValue:[NSNumber numberWithInt:selection] forKey:@"selectedIndex"];
  [self.layer setNeedsLayout];
  [self playSelectedMovie];
}

- (void)moveDown:(id)sender {
  if([[NSApp currentEvent] modifierFlags] & NSShiftKeyMask) {
    [self.layer.layoutManager setValue:[NSNumber numberWithBool:YES] forKey:@"slowMoFlag"];
  }
  [self moveToPreviousMovie];
}

- (void)moveLeft:(id)sender {
  if([[NSApp currentEvent] modifierFlags] & NSShiftKeyMask) {
    [self.layer.layoutManager setValue:[NSNumber numberWithBool:YES] forKey:@"slowMoFlag"];
  }
  [self moveToPreviousMovie];
}

@end

@implementation MovieLayerView (Color)

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

- (CGColorRef)red {
  static CGColorRef red = NULL;
  if(red == NULL) {
    CGFloat values[4] = {1.0, 0.0, 0.0, 1.0};
    red = CGColorCreate([self genericRGBSpace], values);
  }
  return red;
}

@end

@implementation QTMovie (Extras)

- (CGImageRef)imageRefWithFrame:(NSImage *)frame {
	NSData* data = [frame TIFFRepresentation];
  // http://developer.apple.com/technotes/tn2005/tn2143.html
  CGImageRef        imageRef = NULL;
  CGImageSourceRef  sourceRef;
  
  sourceRef = CGImageSourceCreateWithData((CFDataRef)data, NULL);
  if(sourceRef) {
    imageRef = CGImageSourceCreateImageAtIndex(sourceRef, 0, NULL);
    CFRelease(sourceRef);
  }
  
  return imageRef;
}

- (id)currentFrameCGImage {
  return (id)[self imageRefWithFrame:[self currentFrameImage]];
}

- (id)posterCGImage {
  return (id)[self imageRefWithFrame:[self posterImage]];
}

@end
