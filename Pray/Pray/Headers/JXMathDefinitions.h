//
//  JXMathDefinitions.h
//
//
//  Created by Jason YL on 25/04/13.
//  Copyright (c) 2013 All rights reserved.
//
#define Math_Radians(degrees)        ((degrees / 180.0) * M_PI)
#define Math_Sigmoid(x, slope)       (powf(x, slope) / (powf(x, slope) + powf(1.0 - x, slope)))
#define Math_Bound(min, value, max)   MIN(max, MAX(value, min))