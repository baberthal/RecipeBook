//
//  RBSaveOrEditButton.h
//  RecipeBook
//
//  Created by Morgan Lieberthal on 1/9/16.
//  Copyright © 2016 Morgan Lieberthal. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface RBSaveOrEditButton : NSButton

@property(nonatomic, assign) BOOL parentViewIsEditing;

@property(copy) IBInspectable NSString *titleWhenEditing;
@property(copy) IBInspectable NSString *titleWhenNotEditing;

@property SEL IBInspectable actionWhenEditing;
@property SEL IBInspectable actionWhenNotEditing;

@property(copy) IBInspectable NSString *keyEquivWhenEditing;
@property(copy) IBInspectable NSString *keyEquivWhenNotEditing;

@property NSUInteger keyEquivModifierMaskWhenEditing;
@property NSUInteger keyEquivModifierMaskWhenNotEditing;

@end
