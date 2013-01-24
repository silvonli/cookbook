//
//  CBDataManager.m
//  cookbook
//
//  Created by silvon on 13-1-23.
//  Copyright (c) 2013年 silvon. All rights reserved.
//

#import "CBDataManager.h"

@interface CBDataManager ()

- (NSDictionary *)getRecipe:(NSString *)name;

@end

@implementation CBDataManager

static NSArray *recipes;

+ (CBDataManager *)sharedInstance
{
    static CBDataManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[CBDataManager alloc] init];
        
        // 其他初始化
        NSString *path = [[NSBundle mainBundle] pathForResource:@"data" ofType:@"plist"];
        recipes = [[NSArray alloc] initWithContentsOfFile:path];

    });
    return sharedInstance;
}

- (NSDictionary *)getRecipe:(NSString *)name
{
    NSDictionary * recipe =  nil;
    for (NSDictionary *obj in recipes)
    {
        if ([name isEqual:[obj valueForKey:@"name"]])
        {
            recipe = obj;
            break;
        }
    }
    return recipe;
}

- (NSArray *)getRecipesNameOfCategory:(CBRecipeCategory)category
{
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    for (NSDictionary *obj in recipes)
    {
        NSNumber *num = [obj valueForKey:@"category"];
        if ([num integerValue] & category)
        {
            [arr addObject:[obj valueForKey:@"name" ]];
        }
    }
    return arr;
}

- (NSString *)getRecipePicture:(NSString *)name
{
    return [[self getRecipe:name] valueForKey:@"picture"];
}
- (CBRecipeCategory)getRecipeCategory:(NSString *)name
{
    NSNumber* num = [[self getRecipe:name] valueForKey:@"category"];
    return [num integerValue];
}
- (NSString *)getRecipeIngredients:(NSString *)name
{
    return [[self getRecipe:name] valueForKey:@"ingredients"];
}
- (NSString *)getRecipeSeasoning:(NSString *)name
{
    return [[self getRecipe:name] valueForKey:@"seasoning"];
}
- (NSString *)getRecipeOpration:(NSString *)name
{
    return [[self getRecipe:name] valueForKey:@"opration"];
}
- (NSString *)getRecipeTips:(NSString *)name
{
    return [[self getRecipe:name] valueForKey:@"tips"];
}
@end
