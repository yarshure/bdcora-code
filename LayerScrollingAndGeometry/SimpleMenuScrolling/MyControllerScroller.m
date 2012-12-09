/***
 * Excerpted from "Core Animation for Mac OS X and the iPhone",
 * published by The Pragmatic Bookshelf.
 * Copyrights apply to this code. It may not be used to create training material, 
 * courses, books, articles, and the like. Contact us if you are in doubt.
 * We make no guarantees that this code is fit for any purpose. 
 * Visit http://www.pragmaticprogrammer.com/titles/bdcora for more book information.
***/
//
//  MyControllerScroller.m
//  SimpleMenu
//
//  Created by Bill Dudney on 12/3/07.
//  Copyright 2007 Gala Factory. All rights reserved.
//

#import "MyControllerScroller.h"
#import "MyView.h"

@interface MyControllerScroller(Color)
- (CGColorRef)black;
- (CGColorRef)white;
- (CGColorRef)blue;
- (CGColorRef)red;
- (CGColorRef)green;
@end

@implementation MyControllerScroller
@synthesize offset;

- (void)awakeFromNib { 
  self.offset = 10.0f;
  CALayer *layer = [CALayer layer];
  layer.name = @"root";
  layer.backgroundColor = [self black];
  layer.layoutManager = [CAConstraintLayoutManager layoutManager];
  [view setLayer:layer];
  [view setWantsLayer:YES];
  [view.layer addSublayer:[self scrollLayer]]; 
	[[view window] makeFirstResponder:view]; 
  [self performSelectorOnMainThread:@selector(selectItemAt:) 
                         withObject:[NSNumber numberWithInteger:0] 
                      waitUntilDone:NO];
}

- (CAScrollLayer *)scrollLayer { 
  CAScrollLayer *scrollLayer = [CAScrollLayer layer];
  scrollLayer.name = @"scroll";
  scrollLayer.layoutManager = [CAConstraintLayoutManager layoutManager];
  [scrollLayer addConstraint:
   [CAConstraint constraintWithAttribute:kCAConstraintMinX 
                              relativeTo:@"superlayer" 
                               attribute:kCAConstraintMidX 
                                  offset:self.offset]];
  [scrollLayer addConstraint:
   [CAConstraint constraintWithAttribute:kCAConstraintMaxX 
                              relativeTo:@"superlayer" 
                               attribute:kCAConstraintMaxX 
                                  offset:-self.offset]];
  [scrollLayer addConstraint:
   [CAConstraint constraintWithAttribute:kCAConstraintMinY 
                              relativeTo:@"superlayer" 
                               attribute:kCAConstraintMinY 
                                  offset:self.offset]];
  [scrollLayer addConstraint:
   [CAConstraint constraintWithAttribute:kCAConstraintMaxY 
                              relativeTo:@"superlayer" 
                               attribute:kCAConstraintMaxY 
                                  offset:-self.offset]];
  [scrollLayer addSublayer:[self menuLayer]];
  return scrollLayer;
}    

- (NSArray *)menuItemsFromNames:(NSArray *)itemNames { 
  NSMutableArray *menuItems = [NSMutableArray array];
  NSFont *font = [NSFont boldSystemFontOfSize:18.0f];
  int counter = 0;
  for(NSString *itemName in itemNames) {
    CATextLayer *layer = [CATextLayer layer];
    layer.string = itemName;
    layer.name = itemName;
    layer.foregroundColor = [self white];
    layer.font = font;
    layer.alignmentMode = kCAAlignmentLeft;
    [layer addConstraint:
     [CAConstraint constraintWithAttribute:kCAConstraintMidX 
                                relativeTo:@"superlayer"
                                 attribute:kCAConstraintMidX]];
    [layer addConstraint:
     [CAConstraint constraintWithAttribute:kCAConstraintWidth 
                                relativeTo:@"superlayer" 
                                 attribute:kCAConstraintWidth]];
    if(counter == 0) {
      [layer addConstraint:
       [CAConstraint constraintWithAttribute:kCAConstraintMaxY
                                  relativeTo:@"superlayer" 
                                   attribute:kCAConstraintMaxY 
                                      offset:-self.offset]];
    } else {
      NSString *previousLayerName = [itemNames objectAtIndex:counter - 1];
      [layer addConstraint:
       [CAConstraint constraintWithAttribute:kCAConstraintMaxY 
                                  relativeTo:previousLayerName
                                   attribute:kCAConstraintMinY 
                                      offset:-self.offset]];
    }
    [menuItems addObject:layer];
    counter++;
  }
  return menuItems;
}

- (CALayer *)menuLayer { 
  CALayer *menu = [CALayer layer];
  menu.name = @"menu";
  [menu addConstraint:
   [CAConstraint constraintWithAttribute:kCAConstraintWidth
                              relativeTo:@"superlayer" 
                               attribute:kCAConstraintWidth]];
  [menu addConstraint:
   [CAConstraint constraintWithAttribute:kCAConstraintMidX 
                              relativeTo:@"superlayer" 
                               attribute:kCAConstraintMidX]];
  
  menu.layoutManager = [CAConstraintLayoutManager layoutManager];
  NSArray *names = [NSArray arrayWithObjects:
                    @"Option 1 ", @"Option 2", @"Option 3", @"Option 4", 
                    @"Option 5", @"Option 6", @"Option 7", @"Option 8", 
                    @"Option 9", @"Option 10", @"Option 11", nil];
  NSArray *items = [self menuItemsFromNames:names];
  CGFloat height = self.offset; 
  for(CALayer *itemLayer in items) {
    height += itemLayer.preferredFrameSize.height + self.offset;
  }
  [menu setValue:[NSNumber numberWithFloat:height] 
      forKeyPath:@"frame.size.height"]; 
  [menu setSublayers:items];
  return menu;
}    

- (void)selectItemAt:(NSNumber *)index {
  CAScrollLayer *scrollLayer = [[view.layer sublayers] objectAtIndex:0];
  CALayer *menuLayer = [[scrollLayer sublayers] objectAtIndex:0];
  NSInteger value = [index intValue];
  if(value < 0) {
    value = [[menuLayer sublayers] count] - 1;
  } else if (value >= [[menuLayer sublayers] count]) {
    value = 0;
  }
  [scrollLayer setValue:[NSNumber numberWithInteger:value] 
                 forKey:@"selectedItem"]; 
  CALayer *itemLayer = [[menuLayer sublayers] objectAtIndex:value];
  [itemLayer scrollRectToVisible:itemLayer.bounds];
}

- (void)selectNext {
  CAScrollLayer *scrollLayer = [[view.layer sublayers] objectAtIndex:0];
  NSNumber *selectedIndex = [scrollLayer valueForKey:@"selectedItem"];
  [self selectItemAt:
   [NSNumber numberWithInteger:[selectedIndex intValue] + 1]];
}

- (void)selectPrevious {
  CAScrollLayer *scrollLayer = [[view.layer sublayers] objectAtIndex:0];
  NSNumber *selectedIndex = [scrollLayer valueForKey:@"selectedItem"];
  [self selectItemAt:
   [NSNumber numberWithInteger:[selectedIndex intValue] - 1]];
}    

@end

@implementation MyControllerScroller(Color)

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

- (CGColorRef)white{
  static CGColorRef white = NULL;
  if(white == NULL) {
    CGFloat values[4] = {1.0, 1.0, 1.0, 1.0};
    white = CGColorCreate([self genericRGBSpace], values);
  }
  return white;
}

- (CGColorRef)blue {
  static CGColorRef blue = NULL;
  if(blue == NULL) {
    CGFloat values[4] = {0.0, 0.0, 1.0, 1.0};
    blue = CGColorCreate([self genericRGBSpace], values);
  }
  return blue;
}

- (CGColorRef)red {
  static CGColorRef red = NULL;
  if(red == NULL) {
    CGFloat values[4] = {1.0, 0.0, 0.0, 1.0};
    red = CGColorCreate([self genericRGBSpace], values);
  }
  return red;
}

- (CGColorRef)green {
  static CGColorRef green = NULL;
  if(green == NULL) {
    CGFloat values[4] = {0.0, 1.0, 0.0, 1.0};
    green = CGColorCreate([self genericRGBSpace], values);
  }
  return green;
}

@end