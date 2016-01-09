//
//  JMLPopupButton.h
//  RecipeBook
//
//  Created by Morgan Lieberthal on 1/7/16.
//  Copyright © 2016 Morgan Lieberthal. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface JMLPopupButton : NSButton

@property(strong) IBInspectable NSPopUpButtonCell *popupCell;
@property(weak) IBOutlet NSMenu *popupMenu;
@property BOOL usesMenu;

@end
