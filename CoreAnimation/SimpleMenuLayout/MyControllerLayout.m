/***
 * Excerpted from "Core Animation for Mac OS X and the iPhone",
 * published by The Pragmatic Bookshelf.
 * Copyrights apply to this code. It may not be used to create training material, 
 * courses, books, articles, and the like. Contact us if you are in doubt.
 * We make no guarantees that this code is fit for any purpose. 
 * Visit http://www.pragmaticprogrammer.com/titles/bdcora for more book information.
***/
//
//  MyControllerLayout.m
//  SimpleMenu
//
//  Created by Bill Dudney on 12/3/07.
//  Copyright 2007 Gala Factory. All rights reserved.
//

#import "MyControllerLayout.h"

@interface MyControllerLayout(Color)
- (CGColorRef)black;
- (CGColorRef)white;
- (CGColorRef)blue;
@end

@implementation MyControllerLayout
- (void)awakeFromNib {
  CALayer *layer = [CALayer layer];
  layer.backgroundColor = [self black];
  layer.layoutManager = [CAConstraintLayoutManager layoutManager]; 
  [view setLayer:layer];
  [view setWantsLayer:YES];
  [view.layer addSublayer:[self menuLayer]];
}

- (NSArray *)menuItemsFromNames:(NSArray *)itemNames 
                         offset:(CGFloat)offset {
  NSMutableArray *menuItems = [NSMutableArray array];
  NSFont *font = [NSFont boldSystemFontOfSize:18.0f];
  int counter = 0;
  for(NSString *itemName in itemNames) {
    CATextLayer *layer = [CATextLayer layer];
    layer.string = itemName;
    layer.name = itemName;
    layer.foregroundColor = [self white];
    layer.font = font;
    layer.alignmentMode = kCAAlignmentCenter;
    [layer addConstraint:
     [CAConstraint constraintWithAttribute:kCAConstraintMidX 
                                relativeTo:@"superlayer"
                                 attribute:kCAConstraintMidX]];
    [layer addConstraint:
     [CAConstraint constraintWithAttribute:kCAConstraintWidth 
                                relativeTo:@"superlayer" 
                                 attribute:kCAConstraintWidth 
                                    offset:-2.0f * offset]];
    if(counter == 0) {
      [layer addConstraint:
       [CAConstraint constraintWithAttribute:kCAConstraintMaxY
                                  relativeTo:@"superlayer" 
                                   attribute:kCAConstraintMaxY 
                                      offset:-offset]];
    } else {
      NSString *previousLayerName = [itemNames objectAtIndex:counter - 1];
      [layer addConstraint:
       [CAConstraint constraintWithAttribute:kCAConstraintMaxY 
                                  relativeTo:previousLayerName
                                   attribute:kCAConstraintMinY 
                                      offset:-offset]];
    }
    [menuItems addObject:layer];
    counter++;
  }
  return menuItems;
}

- (CALayer *)menuLayer {
  CGFloat offset = 10.0f;
  CALayer *menu = [CALayer layer];
  menu.name = @"menu";
  [menu addConstraint:
   [CAConstraint constraintWithAttribute:kCAConstraintMinX 
                              relativeTo:@"superlayer" 
                               attribute:kCAConstraintMidX]];
  [menu addConstraint:
   [CAConstraint constraintWithAttribute:kCAConstraintMaxX 
                              relativeTo:@"superlayer" 
                               attribute:kCAConstraintMaxX offset:-offset]];
  [menu addConstraint:
   [CAConstraint constraintWithAttribute:kCAConstraintMinY 
                              relativeTo:@"superlayer" 
                               attribute:kCAConstraintMinY offset:offset]];
  [menu addConstraint:
   [CAConstraint constraintWithAttribute:kCAConstraintMaxY 
                              relativeTo:@"superlayer" 
                               attribute:kCAConstraintMaxY offset:-offset]];
  menu.borderWidth = 2.0f;
  menu.borderColor = [self white];
  menu.layoutManager = [CAConstraintLayoutManager layoutManager];
  
  NSArray *names = [NSArray arrayWithObjects:
                    @"Option 1", @"Option 2", @"Option 3", nil];
  NSArray *items = [self menuItemsFromNames:names 
                                     offset:offset];
  [menu setSublayers:items];
  
  return menu;
}    

@end

@implementation MyControllerLayout(Color)

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

@end