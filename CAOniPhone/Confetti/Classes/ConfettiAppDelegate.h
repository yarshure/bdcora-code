/***
 * Excerpted from "Core Animation for Mac OS X and the iPhone",
 * published by The Pragmatic Bookshelf.
 * Copyrights apply to this code. It may not be used to create training material, 
 * courses, books, articles, and the like. Contact us if you are in doubt.
 * We make no guarantees that this code is fit for any purpose. 
 * Visit http://www.pragmaticprogrammer.com/titles/bdcora for more book information.
***/
//
//  ConfettiAppDelegate.h
//  Confetti
//
//  Created by Bill Dudney on 5/21/08.
//  Copyright Gala Factory 2008. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ConfettiAppDelegate : NSObject <UIApplicationDelegate> {
	IBOutlet UIWindow *window;
  UINavigationController *navController;
}

@property (nonatomic, retain) UIWindow *window;
@property (nonatomic, retain) UINavigationController *navController;

@end

