//
//  JXViewDefinitions.h
//
//
//  Created by Jason YL on 25/04/13.
//  Copyright (c) 2013 All rights reserved.
//

/*-----------------------------------------------------------------------------------------------------*/

typedef enum
{
    kAnchorTopLeft,
    kAnchorTopCenter,
    kAnchorTopRight,
    
    kAnchorLeft,
    kAnchorCenter,
    kAnchorRight,
    
    kAnchorBottomLeft,
    kAnchorBottomCenter,
    kAnchorBottomRight,
    
} kAnchor;

/*-----------------------------------------------------------------------------------------------------*/

// 2*M_PI <> 2*Pi = full circle
// M_PI <>  Pi = half circle
// M_PI_2 <> Pi/2 = quarter circle
// M_PI_4 <> Pi/2 = 1/8 circle
#define Degrees2Radians(angle) (angle/180.0*M_PI)
#define ViewCurrentRadianRotation(UIView) atan2f(UIView.transform.b, UIView.transform.a)

/*-----------------------------------------------------------------------------------------------------*/


#define kSmallPadding       5.0
#define kPadding            10.0
#define kLargePadding       20.0

#define kWidth                                                    ([[UIScreen mainScreen] bounds].size.width)
#define kHeight                                                   ([[UIScreen mainScreen] bounds].size.height)
