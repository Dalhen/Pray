//
//  JXColorDefinitions.h
//
//
//  Created by Jason YL on 25/04/13.
//  Copyright (c) 2013 All rights reserved.
//

#define Colour_Clear                    [UIColor clearColor]
#define Colour_WhiteAlpha(opacity)      [UIColor colorWithWhite:1.0 alpha:opacity]
#define Colour_White                    [UIColor whiteColor]
#define Colour_Gray(shade)              [UIColor colorWithWhite:shade alpha:1.0]
#define Colour_DarkGray                 Colour_Gray(0.38)
#define Colour_LightBlue                [UIColor colorWithRed:0.224 green:0.369 blue:0.659 alpha:1.0]
#define Colour_DarkBlue                 [UIColor colorWithRed:0.118 green:0.227 blue:0.447 alpha:1.0]
#define Colour_BlackAlpha(opacity)      [UIColor colorWithWhite:0.0 alpha:opacity]
#define Colour_Black                    Colour_BlackAlpha(1.0)
#define Colour_Bronze                   [UIColor colorWithRed:0.624 green:0.553 blue:0.373 alpha:1.0]
#define Colour_Silver                   [UIColor colorWithRed:0.643 green:0.643 blue:0.643 alpha:1.0]
#define Colour_Gold                     [UIColor colorWithRed:1 green:0.745 blue:0 alpha:1.0]
#define Colour_Red                      [UIColor redColor]
#define Colour_MediumRed                Colour_255RGB(203,70,80)
#define Colour_Green                    [UIColor greenColor]
#define Colour_MediumGreen              Colour_255RGB(80,187,42)
#define Colour_Blue                     [UIColor blueColor]
#define Colour_Pink                     [UIColor colorWithRed:255/255 green:150/255 blue:255/255 alpha:1.0]
#define Colour_LightGray                [UIColor lightGrayColor]
#define Colour_Cyan                     [UIColor cyanColor]
#define Colour_Yellow                   [UIColor yellowColor]
#define Colour_Magenta                  [UIColor magentaColor]
#define Colour_Orange                   [UIColor orangeColor]
#define Colour_Purple                   [UIColor purpleColor]
#define Colour_Brown                    [UIColor brownColor]

#define Colour_FontBlack                Colour_255RGB(7,7,7)
#define Colour_FontGray                 Colour_255RGB(178,178,178)
#define Colour_FontRed                  Colour_255RGB(178,178,178)
#define Colour_FontLightForDarkButton   Colour_255RGB(215,214,214)
#define Colour_FontDarkForLightButton   Colour_255RGB(3,3,4)
#define Colour_GenericTitle             Colour_255RGB(154, 154, 154)


#define Colour_RGBA(r,g,b,a)             [UIColor colorWithRed:r green:g blue:b alpha:a]
#define Colour_RGB(r,g,b)                Colour_RGBA(r,g,b,1.0)
#define Colour_FixValue(x)               x/255.f
#define Colour_255RGBA(r,g,b,a)          [UIColor colorWithRed:Colour_FixValue(r) green:Colour_FixValue(g) blue:Colour_FixValue(b) alpha:a]
#define Colour_255RGB(r,g,b)             Colour_255RGBA(r,g,b,1.0)
#define Colour_ImageColor(imageName)     [UIColor colorWithPatternImage:[JXImageCache imageNamed:imageName]]


#define Colour_ChatBubbleIncoming          Colour_255RGB(235,60,86)
#define Colour_ChatBubbleOutgoing          Colour_255RGB(41,31,112)




