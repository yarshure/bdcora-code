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
//  SimpleBox
//
//  Created by Bill Dudney on 3/19/08.
//  Copyright Gala Factory 2008. All rights reserved.
//

#import "MyView.h"
#import "BoxView.h"

@implementation MyView

@synthesize boxView;

- (void)awakeFromNib {
  CGFloat size = 44.0f;
  CGRect rect = CGRectMake((320.0f - size) / 2.0f , size + 10.0f, size, size);
  boxView = [[[BoxView alloc] initWithFrame:rect] autorelease];
  boxView.backgroundColor = [UIColor redColor];
  
  self.backgroundColor = [UIColor blackColor];
  
  [self addSubview:boxView];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
  UITouch *touch = touches.anyObject;
  [UIView beginAnimations:@"center" context:nil]; 
  self.boxView.center = [touch locationInView:self]; 
  [UIView commitAnimations]; 
}

@end
