//
//  CBDataManager.h
//  cookbook
//
//  Created by silvon on 13-1-23.
//  Copyright (c) 2013年 silvon. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef enum CBRecipeCategory: NSUInteger
{
    CBRecipeCategoryNone    = 0,
    CBRecipeCategoryShuCai  = 1 << 0,
    CBRecipeCategoryPaiGu   = 1 << 1,
    CBRecipeCategoryZhuRou  = 1 << 2,
    CBRecipeCategoryJiRou   = 1 << 3,
    CBRecipeCategoryNiuYang = 1 << 4,
    CBRecipeCategoryYuXia   = 1 << 5,
    CBRecipeCategoryAll     = 0xffff,
    
} CBRecipeCategory;


#define dataManager [CBDataManager sharedInstance]

@interface CBDataManager : NSObject

+ (CBDataManager *)sharedInstance;


- (NSArray *)getRecipesNameOfCategory:(CBRecipeCategory)category;

- (NSString *)getRecipePicture:(NSString *)name;
- (CBRecipeCategory)getRecipeCategory:(NSString *)name;
- (NSAttributedString *)getRecipeIngredients:(NSString *)name;
- (NSString *)getRecipeSeasoning:(NSString *)name;
- (NSString *)getRecipeOpration:(NSString *)name;
- (NSString *)getRecipeTips:(NSString *)name;

@end
