//
//  JMLPopupButton.m
//  RecipeBook
//
//  Created by Morgan Lieberthal on 1/7/16.
//  Copyright © 2016 Morgan Lieberthal. All rights reserved.
//

#import "JMLPopupButton.h"

@implementation JMLPopupButton

@synthesize popupCell = _popupCell;

- (void)awakeFromNib
{
    if (self.menu) {
        [self setUsesMenu:YES];
    }
}

- (void)setUsesMenu:(BOOL)usesMenu
{
    if (_popupCell == nil && usesMenu) {
        _popupCell = [[NSPopUpButtonCell alloc] initTextCell:@""];
        [_popupCell setPullsDown:YES];
        [_popupCell setPreferredEdge:NSMaxYEdge];
    }
    else if (_popupCell && !usesMenu) {
        _popupCell = nil;
    }
}

- (BOOL)usesMenu
{
    return (_popupCell != nil);
}

- (void)runPopUp:(NSEvent *)theEvent
{
    NSMenu *popupMenu = [self.menu copy];
    [popupMenu insertItemWithTitle:@"" action:NULL keyEquivalent:@"" atIndex:0];
    [_popupCell setMenu:popupMenu];

    [_popupCell performClickWithFrame:self.bounds inView:self];

    [self setNeedsDisplay:YES];
}

- (void)mouseDown:(NSEvent *)theEvent
{
    if (self.usesMenu) {
        [self runPopUp:theEvent];
    }
    else {
        [super mouseDown:theEvent];
    }
}

@end
