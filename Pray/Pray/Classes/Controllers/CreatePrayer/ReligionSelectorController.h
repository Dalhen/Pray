//
//  ReligionSelectorController.h
//  Pray
//
//  Created by Jason LAPIERRE on 26/09/2015.
//  Copyright (c) 2015 Pray Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ReligionSelectorController <NSObject>

- (void)religionSelectedWithIndex:(NSInteger)index;

@end

@interface ReligionSelectorController : UIViewController {
    
}

@property(nonatomic, assign) id <ReligionSelectorController> delegate;

@end
