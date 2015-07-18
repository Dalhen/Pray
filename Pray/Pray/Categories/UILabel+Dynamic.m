//
//  UILabel+Dynamic.m
//  VortexVault
//
//  Created by Jason YL on 10/02/12.
//  Copyright (c) 2013 All rights reserved.
//

#import "UILabel+DynamicHeight.h"
#import "UIView+Layout.h"


@implementation UILabel (Dynamic)

+ (double) getSizeWithText:(NSString *)text andWidth:(double)width forFont:(UIFont *)font {
	CGSize maximumSize = CGSizeMake(width, NSIntegerMax);	
	CGSize dynamicSize = [text sizeWithFont:font constrainedToSize:maximumSize lineBreakMode:NSLineBreakByWordWrapping];
	return dynamicSize.height;	
}
	
- (double) setText:(NSString *)text withWidth:(double)width {
	double requiredHeight = [UILabel getSizeWithText:text andWidth:width forFont:[self font]];
	CGRect sizedFrame = self.frame;
	sizedFrame.size.height = requiredHeight;

	[self setLineBreakMode:NSLineBreakByWordWrapping];
	[self setNumberOfLines:100];
	self.frame = sizedFrame;
	[self setText:text];
	
	return requiredHeight;
}

- (void)alignTop {
    CGSize fontSize = [self.text sizeWithFont:self.font];
	
    double finalHeight = fontSize.height * self.numberOfLines;
    double finalWidth = self.frame.size.width;
		
    CGSize theStringSize = [self.text sizeWithFont:self.font 
								 constrainedToSize:CGSizeMake(finalWidth, finalHeight) lineBreakMode:self.lineBreakMode];

    int newLinesToPad = (finalHeight  - theStringSize.height) / fontSize.height;
	
    for(int i=1; i< newLinesToPad; i++) {
        self.text = [self.text stringByAppendingString:@"\n"];
    }
}

- (void)alignBottom {
    CGSize fontSize = [self.text sizeWithFont:self.font];
	
    double finalHeight = fontSize.height * self.numberOfLines;
    double finalWidth = self.frame.size.width;
	
    CGSize theStringSize = [self.text sizeWithFont:self.font 
								 constrainedToSize:CGSizeMake(finalWidth, finalHeight) lineBreakMode:self.lineBreakMode];
	
    int newLinesToPad = (finalHeight  - theStringSize.height) / fontSize.height;
	
    for(int i=1; i< newLinesToPad; i++) {
        self.text = [NSString stringWithFormat:@"\n%@",self.text];
    }
}

- (void)resize {
	CGSize size = [self.text sizeWithFont:self.font constrainedToSize:CGSizeMake(NSIntegerMax, NSIntegerMax)];
	[self setSize:size];
}

- (void)resizeToWidth {
	CGSize size = [self.text sizeWithFont:self.font constrainedToSize:CGSizeMake(self.frame.size.width, NSIntegerMax)];
	[self setSize:size];
}

- (void)sizeTextToFitWidth:(CGFloat)aWidth fontName:(NSString *)aFontName fontSize:(CGFloat)aFontSize {
    [self setFont:[UIFont fontWithName:aFontName size:aFontSize]];
    BOOL tooBig = FALSE;
    
    do {
        [self resize];            
        tooBig = self.size.width > aWidth;
        
        if(tooBig) {
            aFontSize -= 0.5;
            [self setFont:[UIFont fontWithName:aFontName size:aFontSize]];
        }
    } while(tooBig);
}

@end
