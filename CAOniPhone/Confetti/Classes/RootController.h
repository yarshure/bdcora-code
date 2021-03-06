/***
 * Excerpted from "Core Animation for Mac OS X and the iPhone",
 * published by The Pragmatic Bookshelf.
 * Copyrights apply to this code. It may not be used to create training material, 
 * courses, books, articles, and the like. Contact us if you are in doubt.
 * We make no guarantees that this code is fit for any purpose. 
 * Visit http://www.pragmaticprogrammer.com/titles/bdcora for more book information.
***/
//
//  RootController.h
//  Confetti
//
//  Created by Bill Dudney on 5/21/08.
//  Copyright 2008 Gala Factory. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RootController : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate> {
  UIImage *image;
  CALayer *imageLayer;
  CGImageRef drawnImage;
}

@property(nonatomic, retain) UIImage *image;
@property(nonatomic, retain) CALayer *imageLayer;

@end
