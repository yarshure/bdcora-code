/***
 * Excerpted from "Core Animation for Mac OS X and the iPhone",
 * published by The Pragmatic Bookshelf.
 * Copyrights apply to this code. It may not be used to create training material, 
 * courses, books, articles, and the like. Contact us if you are in doubt.
 * We make no guarantees that this code is fit for any purpose. 
 * Visit http://www.pragmaticprogrammer.com/titles/bdcora for more book information.
***/
//
//  OpenGLLayer.m
//  OpenGLLayer
//
//  Created by Bill Dudney on 11/30/07.
//  Copyright 2007 Gala Factory. All rights reserved.
//

#import "OpenGLLayer.h"
#import <OpenGL/OpenGL.h>
#import <GLUT/GLUT.h>

@interface OpenGLLayer (Private)
- (void)drawCube;
@end

@implementation OpenGLLayer

@synthesize animate, localContext;

- (id)init {
  self = [super init];
  self.animate = YES;
  self.asynchronous = YES;
  return self;
}

- (BOOL)canDrawInCGLContext:(CGLContextObj)glContext
                pixelFormat:(CGLPixelFormatObj)pixelFormat
               forLayerTime:(CFTimeInterval)timeInterval
                displayTime:(const CVTimeStamp *)timeStamp {
  if(NO == self.animate) {
    previousTime = 0.0;
  }
  return self.animate;
}

- (void)drawInCGLContext:(CGLContextObj)glContext 
             pixelFormat:(CGLPixelFormatObj)pixelFormat 
            forLayerTime:(CFTimeInterval)interval 
             displayTime:(const CVTimeStamp *)timeStamp {
  glClearColor(0.0f, 0.0f, 0.0f, 0.0f);
  glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
  glEnable(GL_DEPTH_TEST);
  glHint(GL_LINE_SMOOTH_HINT, GL_NICEST);
  glHint(GL_POLYGON_SMOOTH_HINT, GL_NICEST);
  if(previousTime == 0) {
    previousTime = interval;
  }
  rotation += 15.0 * (interval - previousTime);
  glLoadIdentity();
  GLdouble comp = 1.0f/sqrt(3.0f);
  glRotatef(rotation, comp, comp, comp);
  [self drawCube];
  glFlush();
  previousTime = interval;
  glDisable(GL_DEPTH_TEST);
  glHint(GL_LINE_SMOOTH_HINT, GL_DONT_CARE);
  glHint(GL_POLYGON_SMOOTH_HINT, GL_DONT_CARE);
}

- (void)releaseCGLPixelFormat:(CGLPixelFormatObj)pixelFormat {
  CGLDestroyPixelFormat(pixelFormat);
}

- (CGLPixelFormatObj)copyCGLPixelFormatForDisplayMask:(uint32_t)mask {
  CGLPixelFormatAttribute attribs[] =
  {
    kCGLPFAAccelerated,
    kCGLPFADoubleBuffer,
    kCGLPFAColorSize, 24,
    kCGLPFADepthSize, 16,
    0
  };
  
  CGLPixelFormatObj pixelFormatObj = NULL;
  GLint numPixelFormats = 0;
  
  CGLChoosePixelFormat(attribs, &pixelFormatObj, &numPixelFormats);
  return pixelFormatObj;
}

@end

GLfloat cube_vertices [8][3] = {
{-1.0, -1.0, 1.0},  // 2    0
{1.0, -1.0, 1.0},   // 1    1
{1.0, 1.0, 1.0},    // 0    2
{-1.0, 1.0, 1.0},   // 3    3
{-1.0, 1.0, -1.0},  // 7    4
{1.0, 1.0, -1.0},   // 4    5
{-1.0, -1.0, -1.0}, // 6    6
{1.0, -1.0, -1.0}   // 5    7
};

GLfloat cube_face_colors [6][3] = {
{0.4f, 1.0f, 0.4f}, // flora
{0.0f, 0.0f, 1.0f}, // blueberry
{0.4f, 0.8f, 1.0f}, // sky
{1.0f, 0.8f, 0.4f}, // cantelopue
{1.0f, 1.0f, 0.4f}, // blubble gum
{0.5f, 0.0f, 0.25}  // marron
};

GLint num_faces = 6;

short cube_faces [6][4] = {
{3, 0, 1, 2}, // +Z
{0, 3, 4, 6}, // -X
{2, 1, 7, 5}, // +X
{3, 2, 5, 4}, // +Y
{1, 0, 6, 7}, // -Y
{5, 7, 6, 4}  // -Z
};

@implementation OpenGLLayer (Private)

- (void)drawCube {
	long f, i;
  GLdouble fSize = 0.50f;
  glBegin (GL_QUADS);
  for (f = 0; f < num_faces; f++) {
    glColor3f(cube_face_colors[f][0], 
              cube_face_colors[f][1], 
              cube_face_colors[f][2]);
    for (i = 0; i < 4; i++) {
      glVertex3f(cube_vertices[cube_faces[f][i]][0] * fSize, 
                 cube_vertices[cube_faces[f][i]][1] * fSize, 
                 cube_vertices[cube_faces[f][i]][2] * fSize);
    }
  }
  glEnd ();
  glColor3f (0.0, 0.0, 0.0);
  for (f = 0; f < num_faces; f++) {
    glBegin (GL_LINE_LOOP);
    for (i = 0; i < 4; i++)
      glVertex3f(cube_vertices[cube_faces[f][i]][0] * fSize, 
                 cube_vertices[cube_faces[f][i]][1] * fSize, 
                 cube_vertices[cube_faces[f][i]][2] * fSize);
    glEnd ();
  }
}    

@end
