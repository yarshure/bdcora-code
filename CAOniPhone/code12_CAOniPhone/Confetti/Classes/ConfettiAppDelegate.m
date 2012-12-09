/***
 * Excerpted from "Core Animation for Mac OS X and the iPhone",
 * published by The Pragmatic Bookshelf.
 * Copyrights apply to this code. It may not be used to create training material, 
 * courses, books, articles, and the like. Contact us if you are in doubt.
 * We make no guarantees that this code is fit for any purpose. 
 * Visit http://www.pragmaticprogrammer.com/titles/bdcora for more book information.
***/
//
//  ConfettiAppDelegate.m
//  Confetti
//
//  Created by Bill Dudney on 5/21/08.
//  Copyright Gala Factory 2008. All rights reserved.
//

#import "ConfettiAppDelegate.h"
#import "RootController.h"

@implementation ConfettiAppDelegate

@synthesize window;
@synthesize navController;

- (void)applicationDidFinishLaunching:(UIApplication *)application {
  RootController *rootController = [[[RootController alloc] initWithNibName:@"Root" bundle:nil] autorelease];
  self.navController = [[UINavigationController alloc] initWithRootViewController:rootController];
	window.frame = [UIScreen mainScreen].bounds;
	[window addSubview:self.navController.view];
}


- (void)dealloc {
	[window release];
	[super dealloc];
}

@end
