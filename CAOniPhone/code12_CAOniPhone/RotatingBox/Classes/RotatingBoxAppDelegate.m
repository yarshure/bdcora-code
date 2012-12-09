/***
 * Excerpted from "Core Animation for Mac OS X and the iPhone",
 * published by The Pragmatic Bookshelf.
 * Copyrights apply to this code. It may not be used to create training material, 
 * courses, books, articles, and the like. Contact us if you are in doubt.
 * We make no guarantees that this code is fit for any purpose. 
 * Visit http://www.pragmaticprogrammer.com/titles/bdcora for more book information.
***/
//
//  RotatingBoxAppDelegate.m
//  RotatingBox
//
//  Created by Bill Dudney on 5/25/08.
//  Copyright Gala Factory 2008. All rights reserved.
//

#import "RotatingBoxAppDelegate.h"
#import "EAGLView.h"

@implementation RotatingBoxAppDelegate

@synthesize window;
@synthesize glView;

- (void)applicationDidFinishLaunching:(UIApplication *)application {
  [glView startAnimation];
}

- (void)dealloc {
	[window release];
	[glView release];
	[super dealloc];
}

@end
