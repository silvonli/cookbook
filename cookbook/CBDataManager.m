//
//  CBDataManager.m
//  cookbook
//
//  Created by silvon on 13-1-23.
//  Copyright (c) 2013年 silvon. All rights reserved.
//

#import "CBDataManager.h"
#import <CoreText/CoreText.h>

// 字体、行间距
#define TEXT_LINE_SPACING   10
#define CREATE_FONT         CTFontCreateWithName((CFStringRef)@"STHeitiSC-Light", 25, NULL)
#define TITLE_COLOR         [UIColor colorWithRed:160.0f/255.0f green:0.0f blue:0.0f alpha:1.0f]
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
    NSMutableAttributedString *attStr = [self genAttributedTitle:@"主料："];
    NSString * text = [[self getRecipe:name] valueForKey:@"ingredients"];
    [attStr appendAttributedString:[self genAttributedText:text]];
    return attStr;
}
- (NSAttributedString *)getRecipeSeasoning:(NSString *)name
{
    NSMutableAttributedString *attStr = [self genAttributedTitle:@"调料："];
    NSString *text = [[self getRecipe:name] valueForKey:@"seasoning"];
    [attStr appendAttributedString:[self genAttributedText:text]];
    return attStr;
}
- (NSAttributedString *)getRecipeOpration:(NSString *)name
{
    NSMutableAttributedString *attStr = [self genAttributedTitle:@"操作：\n"];
    NSString *text = [[self getRecipe:name] valueForKey:@"opration"];
    [attStr appendAttributedString:[self genAttributedText:text]];
    return attStr;
}
- (NSAttributedString *)getRecipeTips:(NSString *)name
{
    NSString *text = [[self getRecipe:name] valueForKey:@"tips"];
    if (text.length == 0)
    {
        return nil;
    }
    
    NSMutableAttributedString *attStr = [self genAttributedTitle:@"贴士：\n"];
    [attStr appendAttributedString:[self genAttributedText:text]];
    return attStr;
}


- (NSMutableAttributedString *) genAttributedTitle:(NSString *) title
{
    NSMutableAttributedString* attTitle = [[NSMutableAttributedString alloc] initWithString:title];
    CTFontRef font = CREATE_FONT;
    [attTitle addAttribute: (NSString *)kCTFontAttributeName
                   value: (__bridge id)font
                   range: NSMakeRange(0, [attTitle length])];
    CFRelease(font);
    
    [attTitle addAttribute:(NSString *)kCTForegroundColorAttributeName
                     value:(id)[TITLE_COLOR CGColor]
                     range:NSMakeRange(0, [attTitle length])];
    
    // 行间距
    CGFloat floatValue = TEXT_LINE_SPACING;
    CTParagraphStyleSetting paraStyles[2] =
    {
        {
            .spec = kCTParagraphStyleSpecifierMaximumLineSpacing,
            .valueSize = sizeof(CGFloat),
            .value = &floatValue
        },
        {
            .spec = kCTParagraphStyleSpecifierMinimumLineSpacing,
            .valueSize = sizeof(CGFloat),
            .value = &floatValue
        },
    };
    CTParagraphStyleRef aStyle = CTParagraphStyleCreate((const CTParagraphStyleSetting*) &paraStyles, 2);
    [attTitle addAttribute: (NSString*)kCTParagraphStyleAttributeName
                    value: (__bridge id)aStyle
                    range: NSMakeRange(0, [attTitle length])];
    CFRelease(aStyle);

    return attTitle;
}

- (NSAttributedString *) genAttributedText:(NSString *) text
{
    NSMutableAttributedString* attText = [[NSMutableAttributedString alloc] initWithString:text];
    CTFontRef font = CREATE_FONT;
    [attText addAttribute: (NSString *)kCTFontAttributeName
                   value: (__bridge id)font
                   range: NSMakeRange(0, [attText length])];
    CFRelease(font);
    
    // 行间距
    CGFloat floatValue = TEXT_LINE_SPACING;
    CTParagraphStyleSetting paraStyles[2] =
    {
        {
            .spec = kCTParagraphStyleSpecifierMaximumLineSpacing,
            .valueSize = sizeof(CGFloat),
            .value = &floatValue
        },
        {
            .spec = kCTParagraphStyleSpecifierMinimumLineSpacing,
            .valueSize = sizeof(CGFloat),
            .value = &floatValue
        },
    };
    CTParagraphStyleRef aStyle = CTParagraphStyleCreate((const CTParagraphStyleSetting*) &paraStyles, 2);
    [attText addAttribute: (NSString*)kCTParagraphStyleAttributeName
                           value: (__bridge id)aStyle
                           range: NSMakeRange(0, [attText length])];
    CFRelease(aStyle);
    
    return attText;
}
@end
