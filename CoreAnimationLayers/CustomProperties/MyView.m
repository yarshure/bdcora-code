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
//  CustomProperties
//
//  Created by Bill Dudney on 5/20/08.
//  Copyright 2008 Gala Factory. All rights reserved.
//

#import "MyView.h"
#import "MyLayer.h"

@implementation MyView

- (IBAction)updateLineWidth:(id)sender {
  sublayer.lineWidth = [sender floatValue];
}

- (void)awakeFromNib { 
  self.layer = [CALayer layer];
  self.layer.layoutManager = [CAConstraintLayoutManager layoutManager];
  self.wantsLayer = YES;
  sublayer = [MyLayer layer];
  sublayer.constraints = [NSArray arrayWithObjects:
                          [CAConstraint constraintWithAttribute:kCAConstraintMidX relativeTo:@"superlayer" attribute:kCAConstraintMidX], 
                          [CAConstraint constraintWithAttribute:kCAConstraintMidY relativeTo:@"superlayer" attribute:kCAConstraintMidY], 
                          [CAConstraint constraintWithAttribute:kCAConstraintMidX relativeTo:@"superlayer" attribute:kCAConstraintMidX], 
                          [CAConstraint constraintWithAttribute:kCAConstraintWidth relativeTo:@"superlayer" attribute:kCAConstraintWidth scale:0.75f offset:0.0f], 
                          [CAConstraint constraintWithAttribute:kCAConstraintHeight relativeTo:@"superlayer" attribute:kCAConstraintHeight scale:0.75f offset:0.0f],nil];
  [self.layer addSublayer:sublayer];
}

@end
