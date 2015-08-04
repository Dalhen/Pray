//
//  UIView+Utilities.m
//  VortexVault
//
//  Created by Jason YL on 10/02/12.
//  Copyright (c) 2013 All rights reserved.
//

#import "UIView+Utilities.h"
#import "UIView+AnchorRotationContainer.h"
#import <QuartzCore/QuartzCore.h>
#import <CoreImage/CoreImage.h>

@implementation UIView (Utilities)

//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - alpha
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
-(void)hide
{
    self.alpha = 0;
}

-(void)show
{
    self.alpha = 1;
}

-(void)hideAnimated
{
    [UIView animateWithDuration:0.3
                     animations:^{
                         [self hide];
                     }];
}

-(void)showAnimated
{
    [UIView animateWithDuration:0.3
                     animations:^{
                         [self show];
                     }];
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - frame setting
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setOriginX:(float)originX
{
    CGRect frame = self.frame;
    frame.origin.x = originX;
    self.frame = frame;
}

- (void)setOriginY:(float)originY
{
    CGRect frame = self.frame;
    frame.origin.y = originY;
    self.frame = frame;
}

- (void)setOriginX:(float)originX
              andY:(float)originY
{
    CGRect frame = self.frame;
    frame.origin.x = originX;
    frame.origin.y = originY;
    self.frame = frame;
}

- (void)setWidth:(float)width
       andHeight:(float)height
{
    CGRect frame = self.frame;
    frame.size.width = width;
    frame.size.height = height;
    self.frame = frame;
}

/*-----------------------------------------------------------------------------------------------------*/

- (void)setCenterX:(float)centerX
{
    CGPoint center = self.center;
    center.x = centerX;
    self.center = center;
}

- (void)setCenterY:(float)centerY
{
    CGPoint center = self.center;
    center.y = centerY;
    self.center = center;
}

- (void)setCenterX:(float)centerX
              andY:(float)centerY
{
    CGPoint center = self.center;
    center.x = centerX;
    center.y = centerY;
    self.center = center;
}

/*-----------------------------------------------------------------------------------------------------*/

- (void)moveX:(float)xShift
{
    CGPoint center = self.center;
    center.x += xShift;
    self.center = center;
}

- (void)moveY:(float)yShift
{
    CGPoint center = self.center;
    center.y += yShift;
    self.center = center;
}

- (void)moveX:(float)xShift
         andY:(float)yShift
{
    CGPoint center = self.center;
    center.x += xShift;
    center.y += yShift;
    self.center = center;
}

/*-----------------------------------------------------------------------------------------------------*/

- (void)moveXAnimated:(float)xShift
{
    [UIView animateWithDuration:0.3
                     animations:^{
                         [self moveX:xShift];
                     }];
}

- (void)moveYAnimated:(float)yShift
{
    [UIView animateWithDuration:0.3
                     animations:^{
                         [self moveY:yShift];
                     }];
}

- (void)moveX:(float)xShift
 andYAnimated:(float)yShift
{
    [UIView animateWithDuration:0.3
                     animations:^{
                         [self moveX:xShift
                                andY:yShift];
                     }];
}

- (void)setWidthAnimated:(float)width
{
    [UIView animateWithDuration:0.3
                     animations:^{
                         [self setWidth:width];
                     }];
}

- (void)setHeightAnimated:(float)width
{
    [UIView animateWithDuration:0.3
                     animations:^{
                         [self setHeight:width];
                     }];
}

- (void)setWidth:(float)width
andHeightAnimated:(float)height
{
    [UIView animateWithDuration:0.3
                     animations:^{
                         [self setWidth:width
                              andHeight:height];
                     }];
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - rotation
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
- (void) rotateTo0
{
    [self rotateToAngle:0];
}

- (void) rotateTo45
{
    [self rotateToAngle:45];
}

- (void) rotateTo90
{
    [self rotateToAngle:90];
}

- (void) rotateTo135
{
    [self rotateToAngle:135];
}

- (void) rotateTo180
{
    [self rotateToAngle:180];
}

- (void) rotateTo225
{
    [self rotateToAngle:225];
}

- (void) rotateTo270
{
    [self rotateToAngle:270];
}

- (void) rotateTo315
{
    [self rotateToAngle:315];
}

/*-----------------------------------------------------------------------------------------------------*/

- (void) rotate45
{
    [self rotate:45];
}

- (void) rotate90
{
    [self rotate:90];
}

- (void) rotate135
{
    [self rotate:135];
}

- (void) rotate180
{
    [self rotate:180];
}

- (void) rotate225
{
    [self rotate:225];
}

- (void) rotate270
{
    [self rotate:270];
}

- (void) rotate315
{
    [self rotate:315];
}

- (void) rotate360
{
    [self rotate:360];
}

/*-----------------------------------------------------------------------------------------------------*/

- (void) rotateToAngle:(float)degrees
{
    self.transform = CGAffineTransformMakeRotation(Degrees2Radians(degrees));
}

- (void) rotateToAngle:(float)degrees
            fromAnchor:(kAnchor)anchor
{
    CGPoint anchorPoint = [self pointForAnchor:anchor
                                        inView:self];
    [self rotateToAngle:degrees
        fromAnchorPoint:anchorPoint];
}

- (void) rotateToAngle:(float)degrees
       fromAnchorPoint:(CGPoint)point
{
    UIView *containerView = [self rotationContainerForAnchorPoint:point];
    [containerView rotateToAngle:degrees];
}

/*-----------------------------------------------------------------------------------------------------*/

- (void) rotate:(float)degrees
{
    float currentRotation = ViewCurrentRadianRotation(self);
    float rotationRadianValue = Degrees2Radians(degrees);
    self.transform = CGAffineTransformMakeRotation(currentRotation+rotationRadianValue);
}

- (void) rotate:(float)degrees
     fromAnchor:(kAnchor)anchor
{
    CGPoint anchorPoint = [self pointForAnchor:anchor
                                        inView:self];
    [self rotate:degrees
 fromAnchorPoint:anchorPoint];
}

- (void) rotate:(float)degrees
fromAnchorPoint:(CGPoint)point
{
    UIView *containerView = [self rotationContainerForAnchorPoint:point];
    [containerView rotate:degrees];

}

/*-----------------------------------------------------------------------------------------------------*/

- (UIImage *)rotateImage:(UIImage *)image
                 degrees:(int)degrees
{
    float scale = 1.0;
    if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)] == YES && [[UIScreen mainScreen] scale] == 2.00) {
        scale  = 2.0;
    }
    
    UIView *rotatedViewBox = [[UIView alloc] initWithFrame:CGRectMake(0,0,image.size.width*scale, image.size.height*scale)];
    CGAffineTransform t = CGAffineTransformMakeRotation(Degrees2Radians(degrees));
    rotatedViewBox.transform = t;
    CGSize rotatedSize = rotatedViewBox.frame.size;
    
    UIGraphicsBeginImageContext(rotatedSize);
    CGContextRef bitmap = UIGraphicsGetCurrentContext();
    
    CGContextTranslateCTM(bitmap, rotatedSize.width/2, rotatedSize.height/2);
    CGContextRotateCTM(bitmap, Degrees2Radians(degrees));
    
    CGContextScaleCTM(bitmap, scale, -scale);
    CGContextDrawImage(bitmap, CGRectMake(-image.size.width / 2, -image.size.height / 2, image.size.width, image.size.height), [image CGImage]);
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - complex animations
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)deny
{
    [self.layer removeAllAnimations];
    [self shakeHorizontallyNumberOfTimes:5
                           originalFrame:self.frame
                                  isLeft:NO];
}

- (void) flipWithView:(UIView *)toView
       usingDirection:(JXDirection)direction
           completion:(void(^)(BOOL finished))completionBlock
{
    self.layer.doubleSided = NO;
	toView.layer.doubleSided = NO;
    
    toView.hidden = YES;
    toView.frame = self.frame;
    [self.superview insertSubview:toView
                         belowSubview:self];
    
    self.layer.zPosition = self.layer.bounds.size.width / 2;
	toView.layer.zPosition = toView.layer.bounds.size.width / 2;
    
	CATransform3D transform = CATransform3DIdentity;
    transform.m34 = -1.0f/500.0f;
    
    CATransform3D rotation;
    switch (direction) {
        case JXDirection_Left: {
            rotation = CATransform3DRotate(transform, -0.999 * M_PI, 0.0f, 1.0f, 0.0f);
            break;
        }
        case JXDirection_Right:{
            rotation = CATransform3DRotate(transform, 0.999 * M_PI, 0.0f, 1.0f, 0.0f);
            break;
        }
        case JXDirection_Up:{
            rotation = CATransform3DRotate(transform, -0.999 * M_PI, 1.0f, 0.0f, 0.0f);
            break;
        }
        case JXDirection_Down:{
            rotation = CATransform3DRotate(transform, 0.999 * M_PI, 1.0f, 0.0f, 0.0f);
            break;
        }
        default:
            printFailPointAndAbort;
            break;
    }
    
    CATransform3D selfTransform = rotation;
	CATransform3D toViewTransform = CATransform3DInvert(rotation);
    
    toView.layer.transform = toViewTransform;
	self.hidden = NO;
	toView.hidden = NO;
	
	CATransform3D firstToTransform = selfTransform;
    CATransform3D secondToTransform = CATransform3DIdentity;
    
    [UIView animateWithDuration:0.75
                     animations:^(void){
                         self.layer.transform = firstToTransform;
                         toView.layer.transform = secondToTransform;
                     }
                     completion:^(BOOL finished) {
						 self.hidden = YES;
						 toView.hidden = NO;
						 if (completionBlock)
							 completionBlock(finished);
					 }];
}

-(void)bounceIn
{
    self.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.01, 0.01);
    [UIView animateWithDuration:0.3 animations:^(void) {
        //Initial
    } completion:^(BOOL fin) {
        [UIView animateWithDuration:0.3 animations:^(void) {
            self.transform = CGAffineTransformMakeScale(1.1, 1.1);
            
        } completion:^(BOOL fin) {
            //Shrink
            [UIView animateWithDuration:0.3 animations:^(void) {
                self.transform = CGAffineTransformMakeScale(0.9, 0.9);
            } completion:^(BOOL fin) {
                [UIView animateWithDuration:0.3 animations:^(void) {
                    self.transform = CGAffineTransformMakeScale(1.05, 1.05);
                } completion:^(BOOL fin) {
                    [UIView animateWithDuration:0.3 animations:^(void) {
                        self.transform = CGAffineTransformMakeScale(1.0, 1.0);
                    }];
                }];
            }];
        }];
    }];
    
}

- (void)rotateViewIndefinitely
{
    CABasicAnimation *rotation;
    rotation = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    rotation.fromValue = [NSNumber numberWithFloat:0];
    rotation.toValue = [NSNumber numberWithFloat:(2*M_PI)];
    rotation.duration = 2.0;
    rotation.repeatCount = HUGE_VALF;
    [self.layer addAnimation:rotation
                      forKey:@"Spin"];
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - private
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
-(void)shakeHorizontallyNumberOfTimes:(int)count
                        originalFrame:(CGRect)frame
                               isLeft:(BOOL)isLeft
{
    int xShift = 0;
    if (count != 0)
        {
        if (isLeft)
            {
            xShift = 5;
            }
        else
            {
            xShift = -5;
            }
        }
    
    CGRect newFrame = frame;
    newFrame.origin.x = frame.origin.x+xShift;
    [UIView animateWithDuration:0.1
                     animations:^{
                         self.frame = newFrame;
                     }
                     completion:^(BOOL finished){
                         if (count > 0)
                             {
                             int newCount = count - 1;
                             [self shakeHorizontallyNumberOfTimes:newCount
                                                    originalFrame:frame
                                                           isLeft:!isLeft];
                             }
                     }];
}

- (CGPoint) pointForAnchor:(kAnchor)anchor
                    inView:(UIView *)view
{
    return [self pointForAnchor:anchor
                        inFrame:[view frame]];
}

- (CGPoint) pointForAnchor:(kAnchor)anchor
                   inFrame:(CGRect)frame
{
    CGPoint returnPoint = CGPointZero;
    switch (anchor) {
        case kAnchorTopLeft:
            returnPoint = CGPointMake(frame.origin.x,
                                      frame.origin.y);
            break;
        case kAnchorTopCenter:
            returnPoint = CGPointMake((frame.origin.x+frame.size.width)/2,
                                      frame.origin.y);
            break;
        case kAnchorTopRight:
            returnPoint = CGPointMake(frame.origin.x+frame.size.width,
                                      frame.origin.y);
            break;
        case kAnchorLeft:
            returnPoint = CGPointMake(frame.origin.x,
                                      (frame.origin.y+frame.size.height)/2);
            break;
        case kAnchorCenter:
            returnPoint = CGPointMake((frame.origin.x+frame.size.width)/2,
                                      (frame.origin.y+frame.size.height)/2);
            break;
        case kAnchorRight:
            returnPoint = CGPointMake(frame.origin.x+frame.size.width,
                                      (frame.origin.y+frame.size.height)/2);
            break;
        case kAnchorBottomLeft:
            returnPoint = CGPointMake(frame.origin.x,
                                      frame.origin.y+frame.size.height);
            break;
        case kAnchorBottomCenter:
            returnPoint = CGPointMake((frame.origin.x+frame.size.width)/2,
                                      frame.origin.y+frame.size.height);
            break;
        case kAnchorBottomRight:
            returnPoint = CGPointMake(frame.origin.x+frame.size.width,
                                      frame.origin.y+frame.size.height);
            break;
        default:
            printFailPoint;
            break;
    }
    return returnPoint;
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - doppelganger
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
- (UIImageView *) getImageView
{
    UIImageView *imageView = [[UIImageView alloc] initWithImage: [self getImage]];
    [imageView setFrame:self.frame];
    
    return imageView;
}

- (UIImage *) getImage
{
    CGSize size = self.bounds.size;
    UIGraphicsBeginImageContextWithOptions(size, self.opaque, 0.0);
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

- (void)getImageAndAddToImageView:(UIImageView *)imageView
{
    __block UIImage *image = [self getImage];
    [imageView hide];
    imageView.image = image;
    [imageView showAnimated];
}

- (void)getImageAndAddToButton:(UIButton *)button
{
    UIImage *image = [self getImage];
    [button hide];
    [button setImage:image forState:UIControlStateNormal];
    [button showAnimated];
}

- (void)getBlurredImageAndAddToImageView:(UIImageView *)imageView
{
    __block UIImage *image = [self getImage];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        CIImage *inputImage = [[CIImage alloc] initWithImage:image];
        CIFilter *blurFilter = [CIFilter filterWithName:@"CIGaussianBlur"];
        [blurFilter setDefaults];
        [blurFilter setValue:inputImage
                      forKey:@"inputImage"];
        [blurFilter setValue:@(3.0)
                      forKey:@"inputRadius"];
        
        CIImage *outputImage = [blurFilter valueForKey: @"outputImage"];
        CIContext *context = [CIContext contextWithOptions:nil];
        CGImageRef cgimage = [context createCGImage:outputImage
                                        fromRect:outputImage.extent];
        image = [UIImage imageWithCGImage:cgimage];
        CGImageRelease(cgimage);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            imageView.image = image;
        });
    });
}

- (void)getBlurredImageAndAddToButton:(UIButton *)button
{
    __block UIImage *image = [self getImage];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        CIImage *inputImage = [[CIImage alloc] initWithImage:image];
        CIFilter *blurFilter = [CIFilter filterWithName:@"CIGaussianBlur"];
        [blurFilter setDefaults];
        [blurFilter setValue:inputImage
                      forKey:@"inputImage"];
        [blurFilter setValue:@(3.0)
                      forKey:@"inputRadius"];
        
        CIImage *outputImage = [blurFilter valueForKey: @"outputImage"];
        CIContext *context = [CIContext contextWithOptions:nil];
        CGImageRef cgimage = [context createCGImage:outputImage
                                           fromRect:outputImage.extent];
        image = [UIImage imageWithCGImage:cgimage];
        CGImageRelease(cgimage);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [button setBackgroundImage:image forState:UIControlStateNormal];
        });
    });
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - layer editing
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
- (void) addShadowWithColor:(UIColor *)shadowColor
                     offset:(CGSize)offset
                     radius:(float)radius
                 andOpacity:(float)opacity
{
    self.layer.shadowColor = shadowColor.CGColor;
    self.layer.shadowOffset = offset;
    self.layer.shadowRadius = radius;
    self.layer.shadowOpacity = opacity;
}

- (void) addBorderWithColor:(UIColor *)borderColor
                   andWidth:(float)radius
{
    self.layer.borderColor = borderColor.CGColor;
    self.layer.borderWidth = radius;
}

- (void) addRoundEdgesWithRadius:(float)radius
{
    self.layer.cornerRadius = radius;
    self.layer.masksToBounds = YES;
}

- (void)maskWithImageNamed:(NSString *)imageName
{
    CALayer *mask = [CALayer layer];
    UIImage *maskImage = [UIImage imageNamed:imageName];
    mask.contents = (id)[maskImage CGImage];
    mask.frame = CGRectMake(0, 0, maskImage.size.width, maskImage.size.height);
    self.layer.mask = mask;
    self.layer.masksToBounds = YES;
}

- (float)screenWidth {
    return [[UIScreen mainScreen] bounds].size.width;
}

- (float)screenHeight {
    return [[UIScreen mainScreen] bounds].size.height;
}

@end
