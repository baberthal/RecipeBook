//
//  RBTableLineNumberRulerView.m
//  RecipeBook
//
//  Created by Morgan Lieberthal on 1/7/16.
//  Copyright © 2016 Morgan Lieberthal. All rights reserved.
//

#import "RBTableLineNumberRulerView.h"

#define DEFAULT_WIDTH 22.0
#define RULER_MARGIN 5.0

#define keypath(PATH) NSStringFromSelector(@selector(PATH))

@implementation RBTableLineNumberRulerView

@synthesize font = _font;
@synthesize textColor = _textColor;
@synthesize alternateTextColor = _alternateTextColor;
@synthesize backgroundColor = _backgroundColor;
@synthesize textAttributes = _textAttributes;
@synthesize rowCount = _rowCount;

- (instancetype)initWithTableView:(NSTableView *)tableView
             usingArrayController:(NSArrayController *)arrayController
{
    NSScrollView *scrollView = tableView.enclosingScrollView;
    self = [super initWithScrollView:scrollView orientation:NSVerticalRuler];

    if (!self) {
        return nil;
    }

    [self setClientView:tableView];
    _arrayController = arrayController;

    [arrayController addObserver:self
                      forKeyPath:keypath(arrangedObjects)
                         options:NSKeyValueObservingOptionNew
                         context:nil];

    _font = [NSFont labelFontOfSize:[NSFont systemFontSizeForControlSize:NSMiniControlSize]];
    _textColor = [NSColor colorWithCalibratedWhite:0.42 alpha:1.0];
    _alternateTextColor = [NSColor whiteColor];
    _textAttributes =
          @{NSFontAttributeName : self.font, NSForegroundColorAttributeName : _textColor};

    _rowCount = [[arrayController arrangedObjects] count];

    return self;
}

- (void)awakeFromNib
{
    [self setClientView:[[self scrollView] documentView]];
}

- (void)finalize
{
    [self.arrayController removeObserver:self forKeyPath:keypath(arrangedObjects)];
}

#pragma mark - KVO

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary<NSString *, id> *)change
                       context:(void *)context
{
    if ([keyPath isEqualToString:keypath(arrangedObjects)]) {
        NSUInteger newRowCount = [self.arrayController.arrangedObjects count];

        if ((int)log10(self.rowCount) != (int)log10(newRowCount)) {
            [self setRuleThickness:[self requiredThickness]];
        }

        self.rowCount = newRowCount;
        [self setNeedsDisplay:YES];
    }
}

#pragma mark - Overrides

- (CGFloat)requiredThickness
{
    NSUInteger lineCount = [self.arrayController.arrangedObjects count],
               digits = (unsigned)log10((lineCount < 1) ? 1 : lineCount) + 1;

    NSMutableString *sampleString = [NSMutableString string];
    NSSize stringSize;

    for (NSUInteger i = 0; i < digits; i++) {
        [sampleString appendString:@"8"];
    }

    stringSize = [sampleString sizeWithAttributes:[self textAttributes]];

    return ceil(MAX(DEFAULT_WIDTH, stringSize.width + RULER_MARGIN * 2));
}

- (void)drawHashMarksAndLabelsInRect:(NSRect)rect
{
    NSTableView *tableView = (NSTableView *)[self clientView];
    NSRect bounds = self.bounds;
    NSRect visibleRect = tableView.enclosingScrollView.documentVisibleRect;
    NSRange visibleRowRange = [tableView rowsInRect:visibleRect];
    CGFloat yInset = NSHeight(tableView.headerView.bounds);

    if (self.backgroundColor) {
        [self.backgroundColor set];
        NSRectFill(bounds);

        [[NSColor colorWithCalibratedWhite:0.58 alpha:1.0] set];
        [NSBezierPath strokeLineFromPoint:NSMakePoint(NSMaxX(bounds) - 0 / 5, NSMaxY(bounds))
                                  toPoint:NSMakePoint(NSMaxX(bounds) - 0.5, NSMaxY(bounds))];
    }

    for (NSUInteger row = visibleRowRange.location; NSLocationInRange(row, visibleRowRange);
         row++) {
        NSString *labelText = [NSString stringWithFormat:@"%lu", row + 1];
        NSSize stringSize = [labelText sizeWithAttributes:self.textAttributes];
        NSRect rowRect = [tableView rectOfRow:row];
        CGFloat yPos = yInset + NSMinY(rowRect) - NSMinY(visibleRect);

        [labelText drawInRect:NSMakeRect(NSWidth(bounds) - stringSize.width - RULER_MARGIN,
                                         yPos + (NSHeight(rowRect) - stringSize.height) / 2.0,
                                         NSWidth(bounds) - RULER_MARGIN * 2.0, NSHeight(rowRect))
               withAttributes:self.textAttributes];
    }
}

#pragma mark - NSCoding

#define FONT_CODING_KEY @"font"
#define TEXT_COLOR_CODING_KEY @"textColor"
#define ALT_TEXT_COLOR_CODING_KEY @"alternateTextColor"
#define BACKGROUND_COLOR_CODING_KEY @"backgroundColor"

- (instancetype)initWithCoder:(NSCoder *)coder
{
    if ((self = [super initWithCoder:coder]) != nil) {
        if ([coder allowsKeyedCoding]) {
            _font = [coder decodeObjectForKey:FONT_CODING_KEY];
            _textColor = [coder decodeObjectForKey:TEXT_COLOR_CODING_KEY];
            _alternateTextColor = [coder decodeObjectForKey:ALT_TEXT_COLOR_CODING_KEY];
            _backgroundColor = [coder decodeObjectForKey:BACKGROUND_COLOR_CODING_KEY];
        }
        else {
            _font = [coder decodeObject];
            _textColor = [coder decodeObject];
            _alternateTextColor = [coder decodeObject];
            _backgroundColor = [coder decodeObject];
        }
    }

    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [super encodeWithCoder:aCoder];

    if ([aCoder allowsKeyedCoding]) {
        [aCoder encodeObject:_font forKey:FONT_CODING_KEY];
        [aCoder encodeObject:_textColor forKey:TEXT_COLOR_CODING_KEY];
        [aCoder encodeObject:_alternateTextColor forKey:ALT_TEXT_COLOR_CODING_KEY];
        [aCoder encodeObject:_backgroundColor forKey:BACKGROUND_COLOR_CODING_KEY];
    }
    else {
        [aCoder encodeObject:_font];
        [aCoder encodeObject:_textColor];
        [aCoder encodeObject:_alternateTextColor];
        [aCoder encodeObject:_backgroundColor];
    }
}

@end
