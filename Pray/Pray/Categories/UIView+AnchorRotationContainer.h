//
//  UIView+AnchorRotationContainer.h
//  VortexVault
//
//  Created by Jason YL on 10/02/12.
//  Copyright (c) 2013 All rights reserved.
//

#import "JXViewDefinitions.h"

/*-----------------------------------------------------------------------------------------------------*/
/*
 NOTE::
 unique view tags start countdown from 9999999
 */
#define AnchorViewContainerTag 9999999 

/*-----------------------------------------------------------------------------------------------------*/

@interface UIView (AnchorRotationContainer)

//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - CONTAINER LIFECYCLE
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
- (UIView *) rotationContainerForAnchorPoint:(CGPoint)anchorPoint;
- (UIView *) createRotationContainer;
- (void) removeRotationContainer;

//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - CONTAINER ADAPTATION
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)adaptContainerFrameToAnchorPoint:(CGPoint)anchorPoint;
- (BOOL)doesContainerCenterMatchAnchorPoint:(CGPoint)anchorPoint;
@end
