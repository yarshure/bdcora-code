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
//  MenuLayout
//
//  Created by Bill Dudney on 01/09/2008.
//  Copyright 2007 Gala Factory. All rights reserved.
//

#import "MyController.h"
#import "MyView.h"
#import "Platter3DLayoutManager.h"

@interface MyController(Color)
- (CGColorRef)black;
- (CGColorRef)white;
- (CGColorRef)blue;
- (CGColorRef)red;
- (CGColorRef)green;
@end

@implementation MyController

@synthesize offset;

- (void)awakeFromNib {
  self.offset = 10.0f;
  CALayer *layer = [CALayer layer];
  layer.name = @"root";
  layer.backgroundColor = [self black];
  layer.layoutManager = [CAConstraintLayoutManager layoutManager];
  [view setLayer:layer];
  [view setWantsLayer:YES];
	[[view window] makeFirstResponder:view];
  CALayer *scrollLayer = [self scrollLayer];
  [view.layer addSublayer:scrollLayer];
  [view.layer setValue:scrollLayer forKey:@"scrollLayer"];
  CALayer *platterLayer = [self platterLayer];
  [view.layer addSublayer:platterLayer];
  [view.layer setValue:platterLayer forKey:@"platterLayer"];
  [self performSelectorOnMainThread:@selector(selectItemAt:) 
                         withObject:[NSNumber numberWithInteger:0] 
                      waitUntilDone:NO];
}

- (CGImageRef)cgImageNamed:(NSString *)name {
  NSImage *image = [NSImage imageNamed:name];
  [image setSize:NSMakeSize(96.0f, 96.0f)];
  NSData* data = [image TIFFRepresentation];
  CGImageSourceRef imageSourceRef = CGImageSourceCreateWithData((CFDataRef)data, NULL);
  CGImageRef imageRef = NULL;
  if(NULL != imageSourceRef) {
    imageRef = CGImageSourceCreateImageAtIndex(imageSourceRef, 0, NULL);
    CFRelease(imageSourceRef);
  }
  return imageRef;
}

- (NSArray *)platterImageLayersForImageNames:(NSArray *)imageNames {
  NSMutableArray *platterImages = [NSMutableArray array];
  for(NSString *name in imageNames) {
    CALayer *imageLayer = [CALayer layer];
    CGImageRef image = [self cgImageNamed:name];
    CGRect bounds = CGRectMake(0.0f, 0.0f, CGImageGetWidth(image), CGImageGetHeight(image));
    imageLayer.bounds = bounds;
    imageLayer.position = CGPointMake(0.0f, 0.0f);
    imageLayer.contents = (id)image;
    imageLayer.name = name;
    [platterImages addObject:imageLayer];
  }
  return platterImages;
}

- (CALayer *)platterLayer {
  CALayer *platterLayer = [CALayer layer];
  platterLayer.layoutManager = [Platter3DLayoutManager layoutManager];
  NSArray *imageNames = [NSArray arrayWithObjects:NSImageNameBonjour, 
                         NSImageNameDotMac, NSImageNameComputer, 
                         NSImageNameFolderBurnable, NSImageNameFolderSmart,
                         NSImageNameNetwork, NSImageNameColorPanel, nil];
  NSArray *imageLayers = [self platterImageLayersForImageNames:imageNames];
  platterLayer.sublayers = imageLayers;
  [platterLayer addConstraint:
   [CAConstraint constraintWithAttribute:kCAConstraintMinX 
                              relativeTo:@"superlayer" 
                               attribute:kCAConstraintMinX]];
  [platterLayer addConstraint:
   [CAConstraint constraintWithAttribute:kCAConstraintMaxX 
                              relativeTo:@"superlayer" 
                               attribute:kCAConstraintMidX]];
  [platterLayer addConstraint:
   [CAConstraint constraintWithAttribute:kCAConstraintMinY 
                              relativeTo:@"superlayer" 
                               attribute:kCAConstraintMinY]];
  [platterLayer addConstraint:
   [CAConstraint constraintWithAttribute:kCAConstraintMaxY 
                              relativeTo:@"superlayer" 
                               attribute:kCAConstraintMaxY]];
  return platterLayer;
}

- (CAScrollLayer *)scrollLayer {
  CAScrollLayer *scrollLayer = [CAScrollLayer layer];
  scrollLayer.name = @"scroll";
  scrollLayer.layoutManager = [CAConstraintLayoutManager layoutManager];
  [scrollLayer addConstraint:
   [CAConstraint constraintWithAttribute:kCAConstraintMinX 
                              relativeTo:@"superlayer" 
                               attribute:kCAConstraintMidX]];
  [scrollLayer addConstraint:
   [CAConstraint constraintWithAttribute:kCAConstraintMaxX 
                              relativeTo:@"superlayer" 
                               attribute:kCAConstraintMaxX]];
  [scrollLayer addConstraint:
   [CAConstraint constraintWithAttribute:kCAConstraintMinY 
                              relativeTo:@"superlayer" 
                               attribute:kCAConstraintMinY]];
  [scrollLayer addConstraint:
   [CAConstraint constraintWithAttribute:kCAConstraintMaxY 
                              relativeTo:@"superlayer" 
                               attribute:kCAConstraintMaxY]];
  [scrollLayer addSublayer:[self menuLayer]];
  return scrollLayer;
}

- (CATextLayer *)textLayerForName:(NSString *)itemName {
  NSFont *font = [NSFont boldSystemFontOfSize:18.0f];
  CATextLayer *textLayer = [CATextLayer layer];
  textLayer.string = itemName;
  textLayer.name = itemName;
  textLayer.foregroundColor = [self white];
  textLayer.font = font;
  textLayer.alignmentMode = kCAAlignmentLeft;
  [textLayer addConstraint:
   [CAConstraint constraintWithAttribute:kCAConstraintMidY 
                              relativeTo:@"superlayer"
                               attribute:kCAConstraintMidY]];
  [textLayer addConstraint:
   [CAConstraint constraintWithAttribute:kCAConstraintMinX 
                              relativeTo:@"superlayer"
                               attribute:kCAConstraintMinX 
                                  offset:self.offset/2.0f]];
  return textLayer;
}    

- (CATextLayer *)arrowLayer {
  NSFont *font = [NSFont boldSystemFontOfSize:18.0f];
  CATextLayer *arrowLayer = [CATextLayer layer];
  arrowLayer.string = @">";
  arrowLayer.foregroundColor = [self white];
  arrowLayer.font = font;
  arrowLayer.alignmentMode = kCAAlignmentRight;
  [arrowLayer addConstraint:
   [CAConstraint constraintWithAttribute:kCAConstraintMidY 
                              relativeTo:@"superlayer"
                               attribute:kCAConstraintMidY]];
  [arrowLayer addConstraint:
   [CAConstraint constraintWithAttribute:kCAConstraintMaxX 
                              relativeTo:@"superlayer"
                               attribute:kCAConstraintMaxX]];
  return arrowLayer;
}    

- (NSArray *)menuItemsFromNames:(NSArray *)itemNames {
  NSMutableArray *menuItems = [NSMutableArray array];
  int counter = 0;
  for(NSString *itemName in itemNames) {
    CATextLayer *textLayer = [self textLayerForName:itemName];
    CALayer *layer = [CALayer layer];
    layer.name = itemName;
    layer.layoutManager = [CAConstraintLayoutManager layoutManager];
    
    CGSize preferredFrameSize = textLayer.preferredFrameSize;
    [layer setValue:[NSValue valueWithSize:*(NSSize*)&preferredFrameSize] 
         forKeyPath:@"frame.size"];
    [layer addSublayer:textLayer];
    CALayer *arrowLayer = [self arrowLayer];
    [layer addSublayer:arrowLayer];
    [layer setValue:[self arrowLayer] forKey:@"arrowLayer"];
    
    [layer addConstraint:
     [CAConstraint constraintWithAttribute:kCAConstraintMidX 
                                relativeTo:@"superlayer"
                                 attribute:kCAConstraintMidX]];
    [layer addConstraint:
     [CAConstraint constraintWithAttribute:kCAConstraintWidth 
                                relativeTo:@"superlayer" 
                                 attribute:kCAConstraintWidth 
                                    offset:-2.2 * self.offset]];
    if(counter == 0) {
      [layer addConstraint:
       [CAConstraint constraintWithAttribute:kCAConstraintMaxY
                                  relativeTo:@"superlayer" 
                                   attribute:kCAConstraintMaxY]];
    } else {
      NSString *previousLayerName = [itemNames objectAtIndex:counter - 1];
      [layer addConstraint:
       [CAConstraint constraintWithAttribute:kCAConstraintMaxY 
                                  relativeTo:previousLayerName
                                   attribute:kCAConstraintMinY 
                                      offset:-self.offset]];
    }
    layer.cornerRadius = 2.0f;
    layer.shadowRadius = 15.0f;
    layer.shadowOffset = CGSizeMake(0.0f, 0.0f);
    layer.shadowColor = [self blue];
    layer.backgroundColor = [self black];
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
                    @"Movies", @"TV Shows", @"Music", @"Podcasts", 
                    @"Photos", @"Settings", @"Sources", nil];
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

- (CALayer *)highlightLayer {
  if(nil == highlightLayer) {
    highlightLayer = [CALayer layer]; 
    highlightLayer.masksToBounds = YES;
    highlightLayer.zPosition = -100.0f;
    highlightLayer.layoutManager = [CAConstraintLayoutManager layoutManager];
    [highlightLayer addConstraint: 
     [CAConstraint constraintWithAttribute:kCAConstraintWidth
                                relativeTo:@"superlayer" 
                                 attribute:kCAConstraintWidth]];
    [highlightLayer addConstraint:
     [CAConstraint constraintWithAttribute:kCAConstraintHeight
                                relativeTo:@"superlayer" 
                                 attribute:kCAConstraintHeight]];
    [highlightLayer addConstraint:
     [CAConstraint constraintWithAttribute:kCAConstraintMinX
                                relativeTo:@"superlayer" 
                                 attribute:kCAConstraintMinX]];
    [highlightLayer addConstraint:
     [CAConstraint constraintWithAttribute:kCAConstraintMinY
                                relativeTo:@"superlayer" 
                                 attribute:kCAConstraintMinY]];
    CALayer *reflectionLayer = [CALayer layer];
    reflectionLayer.backgroundColor = [self white];
    reflectionLayer.opacity = 0.25f;
    reflectionLayer.cornerRadius = 6.0f;
    [reflectionLayer addConstraint:
     [CAConstraint constraintWithAttribute:kCAConstraintWidth
                                relativeTo:@"superlayer" 
                                 attribute:kCAConstraintWidth]];
    [reflectionLayer addConstraint:
     [CAConstraint constraintWithAttribute:kCAConstraintHeight
                                relativeTo:@"superlayer" 
                                 attribute:kCAConstraintHeight]];
    [reflectionLayer addConstraint:
     [CAConstraint constraintWithAttribute:kCAConstraintMinX
                                relativeTo:@"superlayer" 
                                 attribute:kCAConstraintMinX]];
    [reflectionLayer addConstraint:
     [CAConstraint constraintWithAttribute:kCAConstraintMinY
                                relativeTo:@"superlayer" 
                                 attribute:kCAConstraintMidY 
                                    offset:self.offset/2.0f]];
    [highlightLayer addSublayer:reflectionLayer];
  }
  return highlightLayer;
}

- (void)unselectCurrentSelection {
  CAScrollLayer *scrollLayer = [[view.layer sublayers] objectAtIndex:0];
  CALayer *menuLayer = [[scrollLayer sublayers] objectAtIndex:0];
  // unselect the current selection
  NSInteger prevSel = [[scrollLayer valueForKey:@"selectedItem"] intValue];
  CALayer *prevSelItemLayer = [[menuLayer sublayers] objectAtIndex:prevSel];
  // remove the hightlight from the currently selected layer as its about to not be
  // selected
  [[prevSelItemLayer valueForKey:@"highlightLayer"] removeFromSuperlayer];
  // make the shadow transparent
  prevSelItemLayer.shadowOpacity = 0.0f;
}  

- (void)selectItemAt:(NSNumber *)index {
  CAScrollLayer *scrollLayer = [view.layer valueForKey:@"scrollLayer"];
  CALayer *platterLayer = [view.layer valueForKey:@"platterLayer"];
  // menu layer sublayers count == platter later sublayers count
  // so getting the value here is sufficient for our platter layer too
  CALayer *menuLayer = [[scrollLayer sublayers] objectAtIndex:0];
  NSInteger value = [index intValue];
  if(value < 0) {
    value = [[menuLayer sublayers] count] - 1;
  } else if (value >= [[menuLayer sublayers] count]) {
    value = 0;
  }
  // undoes everthing we do below for the selection
  [self unselectCurrentSelection];
  
  [scrollLayer setValue:[NSNumber numberWithInteger:value] forKey:@"selectedItem"];
  [platterLayer setValue:[NSNumber numberWithInteger:value]
                  forKey:@"selectedItem"];
  [platterLayer setNeedsLayout];
  // get the newly selected item
  CALayer *itemLayer = [[menuLayer sublayers] objectAtIndex:value];
  // make sure its scrolled to visible
  [itemLayer scrollRectToVisible:itemLayer.bounds];
  // -- apply the selection features --
  itemLayer.shadowOpacity = 0.85f;
  CALayer *highlight = [self highlightLayer];
  [itemLayer addSublayer:highlight];
}

- (void)selectNext {
  CAScrollLayer *scrollLayer = [[view.layer sublayers] objectAtIndex:0];
  NSNumber *selectedIndex = [scrollLayer valueForKey:@"selectedItem"];
  [self selectItemAt:[NSNumber numberWithInteger:[selectedIndex intValue] + 1]];
}

- (void)selectPrevious {
  CAScrollLayer *scrollLayer = [[view.layer sublayers] objectAtIndex:0];
  NSNumber *selectedIndex = [scrollLayer valueForKey:@"selectedItem"];
  [self selectItemAt:[NSNumber numberWithInteger:[selectedIndex intValue] - 1]];
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