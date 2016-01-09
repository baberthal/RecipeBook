//
//  RBTableLineNumberRulerView.h
//  RecipeBook
//
//  Created by Morgan Lieberthal on 1/7/16.
//  Copyright © 2016 Morgan Lieberthal. All rights reserved.
//

#import <Cocoa/Cocoa.h>

IB_DESIGNABLE
@interface RBTableLineNumberRulerView : NSRulerView

@property(strong) IBOutlet NSArrayController *arrayController;

@property(strong) IBInspectable NSFont *font;
@property(strong) IBInspectable NSColor *textColor;
@property(strong) IBInspectable NSColor *alternateTextColor;
@property(strong) IBInspectable NSColor *backgroundColor;
@property(strong) IBInspectable NSDictionary *textAttributes;
@property(assign) NSUInteger rowCount;

- (instancetype)initWithTableView:(NSTableView *)tableView
             usingArrayController:(NSArrayController *)arrayController;

@end
