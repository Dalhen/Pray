//
//  UIView+Utilities.h
//  VortexVault
//
//  Created by Jason YL on 10/02/12.
//  Copyright (c) 2013 All rights reserved.
//

#import "JXDirection.h"
#import "JXViewDefinitions.h"

@interface UIView (Utilities)

//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - alpha
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
-(void)hide;
-(void)show;
-(void)hideAnimated;
-(void)showAnimated;

//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - frame setting
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setOriginX:(float)originX;
- (void)setOriginY:(float)originY;
- (void)setOriginX:(float)originX
              andY:(float)originY;
- (void)setWidth:(float)width
       andHeight:(float)height;

/*-----------------------------------------------------------------------------------------------------*/

- (void)setCenterX:(float)centerX;
- (void)setCenterY:(float)centerY;
- (void)setCenterX:(float)centerX
              andY:(float)centerY;

/*-----------------------------------------------------------------------------------------------------*/

- (void)moveX:(float)xShift;
- (void)moveY:(float)yShift;
- (void)moveX:(float)xShift
         andY:(float)yShift;

/*-----------------------------------------------------------------------------------------------------*/

- (void)moveXAnimated:(float)xShift;
- (void)moveYAnimated:(float)yShift;
- (void)moveX:(float)xShift
 andYAnimated:(float)yShift;
- (void)setWidthAnimated:(float)width;
- (void)setHeightAnimated:(float)height;
- (void)setWidth:(float)width
andHeightAnimated:(float)height;

//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - rotation
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
- (void) rotateTo0;
- (void) rotateTo45;
- (void) rotateTo90;
- (void) rotateTo135;
- (void) rotateTo180;
- (void) rotateTo225;
- (void) rotateTo270;
- (void) rotateTo315;

/*-----------------------------------------------------------------------------------------------------*/

- (void) rotate45;
- (void) rotate90;
- (void) rotate135;
- (void) rotate180;
- (void) rotate225;
- (void) rotate270;
- (void) rotate315;
- (void) rotate360;

/*-----------------------------------------------------------------------------------------------------*/

- (void) rotateToAngle:(float)degrees;
- (void) rotateToAngle:(float)degrees
            fromAnchor:(kAnchor)anchor;
- (void) rotateToAngle:(float)degrees
       fromAnchorPoint:(CGPoint)point;

/*-----------------------------------------------------------------------------------------------------*/

- (void) rotate:(float)degrees;
- (void) rotate:(float)degrees
     fromAnchor:(kAnchor)anchor;
- (void) rotate:(float)degrees
fromAnchorPoint:(CGPoint)point;

/*-----------------------------------------------------------------------------------------------------*/

- (UIImage *)rotateImage:(UIImage *)image
                 degrees:(int)degrees;

//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - complex animations
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
- (void) deny;
- (void) flipWithView:(UIView *)toView
       usingDirection:(JXDirection)direction
           completion:(void(^)(BOOL finished))completionBlock;
- (void)rotateViewIndefinitely;
- (void)bounceIn;


//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - doppelganger
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
- (UIImageView *)getImageView;
- (UIImage *)getImage;
- (void)getImageAndAddToImageView:(UIImageView *)imageView;
- (void)getImageAndAddToButton:(UIButton *)button;
- (void)getBlurredImageAndAddToImageView:(UIImageView *)imageView;
- (void)getBlurredImageAndAddToButton:(UIButton *)button;


//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - layerEditing
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)addShadowWithColor:(UIColor *)shadowColor
                    offset:(CGSize)offset
                    radius:(float)radius
                andOpacity:(float)opacity;
- (void)addBorderWithColor:(UIColor *)borderColor
                  andWidth:(float)radius;
- (void)addRoundEdgesWithRadius:(float)radius;
- (void)maskWithImageNamed:(NSString *)imageName;

- (float)screenWidth;
- (float)screenHeight;

@end
