//
//  Constant.h
//  LoanInfo
//
//  Created by Amit Mohol on 07/10/16.
//  Copyright © 2016 Stark Digital. All rights reserved.
//

#ifndef Constant_h
#define Constant_h


#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define IS_HEIGHT_GTE_568 [[UIScreen mainScreen ] bounds].size.height >= 568.0f
#define SCREEN_HIEGHT [[UIScreen mainScreen ] bounds].size.height
#define SCREEN_WIDTH [[UIScreen mainScreen ] bounds].size.width

#define IS_IPHONE_5 ( IS_IPHONE && IS_HEIGHT_GTE_568 )

#define KWidth      (IS_IPHONE ?(IS_IPHONE_5 ? 568:480):1024)//
#define KHieght     (IS_IPHONE ?320:768)

#define x_ratio     (IS_IPHONE ?(IS_IPHONE_5 ? 1.0:1.0):2.4)
#define y_ratio     (IS_IPHONE ?(IS_IPHONE_5 ? 1.0:0.8451):2.13)
#define THEME_COLOR [UIColor colorWithRed:(204.0/255.0) green:(153.0/255.0) blue:(1.0/255.0) alpha:1]

//#379BC8
//#define THEME_COLOR [UIColor colorWithRed:(55.0/255.0) green:(155.0/255.0) blue:(200.0/255.0) alpha:1]

//#define THEME_COLOR [UIColor colorWithRed:(55.0/255.0) green:(155.0/255.0) blue:(200.0/255.0) alpha:1]
#define RED_TAG 201
#define GREEN_TAG 202
#define BLUE_TAG 203
#define COLOR_TAG 204

#endif /* Constant_h */
