//
//  CBDataManager.m
//  cookbook
//
//  Created by silvon on 13-1-23.
//  Copyright (c) 2013年 silvon. All rights reserved.
//

#import "CBDataManager.h"
#import <CoreText/CoreText.h>

// 标题字体、字号、段间距
#define TEXT_FONT_NAME               @"STHeitiSC-Light"
#define TEXT_FONT_SIZE               34
#define TEXT_PARAGRAPH_SPACING       20.0
#define TEXT_PARAGRAPH_SPACINGBEFORE 0.0

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
- (NSAttributedString *)getRecipeIngredients:(NSString *)name
{
    NSMutableAttributedString* str = [[NSMutableAttributedString alloc] initWithString:[[self getRecipe:name] valueForKey:@"ingredients"]];
    // font
    CTFontRef ctFont = CTFontCreateWithName((CFStringRef)TEXT_FONT_NAME, TEXT_FONT_SIZE, NULL);
    [str addAttribute: (NSString *)kCTFontAttributeName
                     value: (__bridge id)ctFont
                     range: NSMakeRange(0, [str length])];
    CFRelease(ctFont);
    // 对齐
    CTTextAlignment alignment = kCTTextAlignmentLeft;
    CGFloat floatValue = TEXT_PARAGRAPH_SPACING;
    CGFloat fSpaceBefore = TEXT_PARAGRAPH_SPACINGBEFORE;
    CTParagraphStyleSetting paraStyles[3] =
    {
        {
            .spec = kCTParagraphStyleSpecifierAlignment,
            .valueSize = sizeof(CTTextAlignment),
            .value = &alignment
        },
        {
            .spec = kCTParagraphStyleSpecifierParagraphSpacing,
            .valueSize = sizeof(CGFloat),
            .value = &floatValue
        },
        {
            .spec = kCTParagraphStyleSpecifierParagraphSpacingBefore,
            .valueSize = sizeof(CGFloat),
            .value = &fSpaceBefore
        },
    };
    CTParagraphStyleRef aStyle = CTParagraphStyleCreate((const CTParagraphStyleSetting*) &paraStyles, 3);
    [str addAttribute: (NSString*)kCTParagraphStyleAttributeName
                     value: (__bridge id)aStyle
                     range: NSMakeRange(0, [str length])];
    CFRelease(aStyle);
    
    return str;
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
