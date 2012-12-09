/***
 * Excerpted from "Core Animation for Mac OS X and the iPhone",
 * published by The Pragmatic Bookshelf.
 * Copyrights apply to this code. It may not be used to create training material, 
 * courses, books, articles, and the like. Contact us if you are in doubt.
 * We make no guarantees that this code is fit for any purpose. 
 * Visit http://www.pragmaticprogrammer.com/titles/bdcora for more book information.
***/
//
//  RootController.m
//  Confetti
//
//  Created by Bill Dudney on 5/21/08.
//  Copyright 2008 Gala Factory. All rights reserved.
//

#import "RootController.h"
#import <QuartzCore/QuartzCore.h>

// location of layer to start
static CGFloat kMaxWidth = 300.0f;
static CGFloat kMaxHeight = 380.0f;
static CGFloat kMinX = 10.0f;
static CGFloat kMinY = 20.0f;
static CGFloat kXSlices = 6.0f;
static CGFloat kYSlices = 8.0f;

@implementation RootController

@synthesize image;
@synthesize imageLayer;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
	if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
    self.title = @"Confetti";
	}
	return self;
}

- (void)loadView {
  [super loadView];

  self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"Pop" style:UIBarButtonItemStyleBordered target:self action:@selector(pop:)] autorelease];
  self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(photo:)] autorelease];
  
  self.imageLayer = [CALayer layer];
  self.imageLayer.frame = CGRectMake(kMinX, kMinY, kMaxWidth, kMaxHeight);
  self.imageLayer.contentsGravity = kCAGravityResizeAspectFill;
  self.imageLayer.masksToBounds = YES;
  [self.view.layer addSublayer:self.imageLayer];
}

- (void)photo:(id)sender {
  if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
    UIImagePickerController* picker = [[UIImagePickerController alloc] init];
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    picker.delegate = self;
    picker.allowsImageEditing = NO;
    // Picker is displayed asynchronously.
    [self presentModalViewController:picker animated:YES];
  } else {
    // pop up an alert
  }
}

- (void)animationDidStop:(CAAnimation *)theAnimation finished:(BOOL)flag {
  imageLayer.contents = (id)drawnImage;
  // remove all sublayers from imageLayer
  NSArray *sublayers = [NSArray arrayWithArray:[imageLayer sublayers]];
  for(CALayer *layer in sublayers) {
    [layer removeFromSuperlayer];
  }
}

- (CGPoint)randomDestinationX:(CGFloat)x Y:(CGFloat)y imageSize:(CGSize)size {
  CGPoint destination;
  if((x <= (kXSlices / 2.0f)) && (y <= (kYSlices / 2.0f))) { // top left quadrant
    destination.x = -50.0f * ((CGFloat)(random() % 10000)) / 2000.0f;
    destination.y = -50.0f * ((CGFloat)(random() % 10000)) / 2000.0f;
  } else if((x > (kXSlices / 2.0f)) && (y <= (kYSlices / 2.0f))) { // top right quadrant
    destination.x = size.width + (50.0f * ((CGFloat)(random() % 10000)) / 2000.0f);
    destination.y = -50.0f * ((CGFloat)(random() % 10000)) / 2000.0f;
  } else if((x > (kXSlices / 2.0f)) && (y > (kYSlices / 2.0f))) { // bottom right quadrant
    destination.x = size.width + (50.0f * ((CGFloat)(random() % 10000)) / 2000.0f);
    destination.y = size.height + (50.0f * ((CGFloat)(random() % 10000)) / 2000.0f);
  } else if((x <= (kXSlices / 2.0f)) && (y > (kYSlices / 2.0f))) { // bottom right quadrant
    destination.x = -50.0f * ((CGFloat)(random() % 10000)) / 2000.0f;
    destination.y = size.height + (50.0f * ((CGFloat)(random() % 10000)) / 2000.0f);
  }
  return destination;
}

- (CAAnimation *)animationForX:(NSInteger)x Y:(NSInteger)y 
                     imageSize:(CGSize)size {
  // return a group animation, one for opacity from 1 to zero and a keyframe
  // with a path appropriate for the x and y coords
  CAAnimationGroup *group = [CAAnimationGroup animation];
  group.delegate = self;
  group.duration = 2.0f;

  CABasicAnimation *opacity = [CABasicAnimation 
                               animationWithKeyPath:@"opacity"];  
  opacity.fromValue = [NSNumber numberWithDouble:1.0f];
  opacity.toValue = [NSNumber numberWithDouble:0.0f];

  CABasicAnimation *position = [CABasicAnimation 
                                animationWithKeyPath:@"position"];
  position.timingFunction = [CAMediaTimingFunction 
                             functionWithName:kCAMediaTimingFunctionEaseIn];
  CGPoint dest = [self randomDestinationX:x Y:y imageSize:size];
  position.toValue = [NSValue valueWithCGPoint:dest];

  group.animations = [NSArray arrayWithObjects:opacity, position, nil]; 
  return group;
}

- (void)pop:(id)sender {
  if(nil != imageLayer.contents) {
    CGSize imageSize = CGSizeMake(CGImageGetWidth(drawnImage), 
                                  CGImageGetHeight(drawnImage));
    NSMutableArray *layers = [NSMutableArray array];
    for(int x = 0;x < kXSlices;x++) {
      for(int y = 0;y < kYSlices;y++) {
        CGRect frame = CGRectMake((imageSize.width / kXSlices) * x,
                                  (imageSize.height / kYSlices) * y,
                                  imageSize.width / kXSlices,
                                  imageSize.height / kYSlices);
        CALayer *layer = [CALayer layer];
        layer.frame = frame;
        layer.actions = [NSDictionary dictionaryWithObject:
                         [self animationForX:x Y:y imageSize:imageSize] 
                                                    forKey:@"opacity"]; 
        CGImageRef subimage = CGImageCreateWithImageInRect(drawnImage, frame);
        layer.contents = (id)subimage;
        CFRelease(subimage);
        [layers addObject:layer];
      }
    }
    for(CALayer *layer in layers) {
      [imageLayer addSublayer:layer];
      layer.opacity = 0.0f;
    }
    imageLayer.contents = nil;
  }
}

- (CGImageRef)scaleAndCropImage:(UIImage *)fullImage {
  CGSize imageSize = fullImage.size;
  CGFloat scale = 1.0f;
  CGImageRef subimage = NULL;
  if(imageSize.width > imageSize.height) {
    // image height is smallest
    scale = kMaxHeight / imageSize.height;
    CGFloat offsetX = ((scale * imageSize.width - kMaxWidth) / 2.0f) / scale;
    CGRect subRect = CGRectMake(offsetX, 0.0f, 
                                imageSize.width - (2.0f * offsetX), 
                                imageSize.height);
    subimage = CGImageCreateWithImageInRect([fullImage CGImage], subRect);
  } else {
    // image width is smallest
    scale = kMaxWidth / imageSize.width;
    CGFloat offsetY = ((scale * imageSize.height - kMaxHeight) / 2.0f) / scale;
    CGRect subRect = CGRectMake(0.0f, offsetY, imageSize.width, 
                                imageSize.height - (2.0f * offsetY));
    subimage = CGImageCreateWithImageInRect([fullImage CGImage], subRect);
  }
  // scale the image
  CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
  CGContextRef context = CGBitmapContextCreate(NULL, kMaxWidth, 
                                               kMaxHeight, 8, 0, colorSpace, 
                                               kCGImageAlphaPremultipliedFirst); 
  CGContextSetInterpolationQuality(context, kCGInterpolationHigh);
  CGRect rect = CGRectMake(0.0f, 0.0f, kMaxWidth, kMaxHeight);
  CGContextDrawImage(context, rect, subimage);
  CGContextFlush(context);
  // get the scaled image
  CGImageRef scaledImage = CGBitmapContextCreateImage(context);
  CGContextRelease (context);
  CGImageRelease(subimage);
  subimage = NULL;
  subimage = scaledImage;
  return subimage;
}

- (void)imagePickerController:(UIImagePickerController *)picker 
        didFinishPickingImage:(UIImage *)newImage 
                  editingInfo:(NSDictionary *)editingInfo {
  self.image = newImage; 
  drawnImage = [self scaleAndCropImage:self.image];
  imageLayer.contents = (id)drawnImage;
  [[picker parentViewController] dismissModalViewControllerAnimated:YES];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
  [[picker parentViewController] dismissModalViewControllerAnimated:YES];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
}

- (void)dealloc {
	[super dealloc];
}

@end
