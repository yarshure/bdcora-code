/***
 * Excerpted from "Core Animation for Mac OS X and the iPhone",
 * published by The Pragmatic Bookshelf.
 * Copyrights apply to this code. It may not be used to create training material, 
 * courses, books, articles, and the like. Contact us if you are in doubt.
 * We make no guarantees that this code is fit for any purpose. 
 * Visit http://www.pragmaticprogrammer.com/titles/bdcora for more book information.
***/
//
//  MyController.m
//  SimpleMenu
//
//  Created by Bill Dudney on 12/3/07.
//  Copyright 2007 Gala Factory. All rights reserved.
//

#import "MyController.h"

@interface MyController(Color)
- (CGColorRef)black;
- (CGColorRef)white;
- (CGColorRef)blue;
@end

@implementation MyController
- (void)awakeFromNib {
  CALayer *layer = [CALayer layer];
  layer.backgroundColor = [self black];
  [view setLayer:layer];
  [view setWantsLayer:YES];
  [view.layer addSublayer:[self menuLayer]];
}

- (NSArray *)menuItemsFromNames:(NSArray *)itemNames 
                         offset:(CGFloat)offset 
                           size:(CGSize)size { 
  NSMutableArray *menuItems = [NSMutableArray array];
  CGFloat fontSize = 24.0f;
  NSFont *font = [NSFont boldSystemFontOfSize:fontSize];
  int counter = 1;
  for(NSString *itemName in itemNames) {
    CATextLayer *layer = [CATextLayer layer];
    layer.string = itemName;
    layer.name = itemName;
    layer.foregroundColor = [self white];
    layer.font = font;
    layer.fontSize = fontSize;
    layer.alignmentMode = kCAAlignmentCenter;
    CGSize preferredSize = [layer preferredFrameSize];
    CGFloat width = (size.width - preferredSize.width) / 2.0f;
    CGFloat height = size.height - 
    counter * (offset + preferredSize.height);
    layer.frame = CGRectMake(width, height, 
                             preferredSize.width, preferredSize.height);
    [menuItems addObject:layer];
    counter++;
  }
  return menuItems;
}

- (CALayer *)menuLayer { 
  CGFloat offset = 10.0f;
  CALayer *menu = [CALayer layer];
  menu.name = @"menu";
  NSRect bounds = [view bounds];
  NSRect rect = NSInsetRect(bounds, bounds.size.width / 4.0f, offset);
  rect.origin.x += bounds.size.width / 4.0f - offset;
  menu.frame = NSRectToCGRect(rect);
  menu.borderWidth = 2.0f;
  menu.borderColor = [self white];
  NSArray *names = [NSArray arrayWithObjects:
                    @"Option 1", @"Option 2", @"Option 3", nil];
  NSArray *items = [self menuItemsFromNames:names 
                                     offset:offset 
                                       size:menu.frame.size];
  [menu setSublayers:items];
  return menu;
}    

@end

@implementation MyController(Color)

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
