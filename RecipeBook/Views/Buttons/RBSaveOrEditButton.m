//
//  RBSaveOrEditButton.m
//  RecipeBook
//
//  Created by Morgan Lieberthal on 1/9/16.
//  Copyright © 2016 Morgan Lieberthal. All rights reserved.
//

#import "RBSaveOrEditButton.h"

@implementation RBSaveOrEditButton

#pragma mark - Properties

@synthesize parentViewIsEditing = _parentViewIsEditing;
@synthesize titleWhenEditing = _titleWhenEditing;
@synthesize titleWhenNotEditing = _titleWhenNotEditing;

- (NSString *)titleWhenNotEditing
{
    if (!_titleWhenNotEditing) {
        _titleWhenNotEditing = @"Edit";
    }

    return _titleWhenNotEditing;
}

- (void)setTitleWhenNotEditing:(NSString *)titleWhenNotEditing
{
    _titleWhenNotEditing = titleWhenNotEditing;
}

- (NSString *)titleWhenEditing
{
    if (!_titleWhenEditing) {
        _titleWhenEditing = @"Save";
    }

    return _titleWhenEditing;
}

- (void)setTitleWhenEditing:(NSString *)titleWhenEditing
{
    _titleWhenEditing = titleWhenEditing;
}

#pragma mark - Initialization / Deallocation

- (instancetype)initWithFrame:(NSRect)frameRect
{
    DDLogFunction();
    self = [super initWithFrame:frameRect];
    if (!self) {
        return nil;
    }

    [self registerAsObserverForSelf:self];

    return self;
}

- (void)awakeFromNib
{
    DDLogFunction();
    [self registerAsObserverForSelf:self];
}

- (void)dealloc
{
    [self removeObserver:self forKeyPath:@keypath(self, parentViewIsEditing)];
}

#pragma mark - KVO

- (void)registerAsObserverForSelf:(id)sender
{
    [self addObserver:self
           forKeyPath:@keypath(self, parentViewIsEditing)
              options:NSKeyValueObservingOptionNew
              context:nil];
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary<NSString *, id> *)change
                       context:(void *)context
{
    if ([keyPath isEqualToString:@keypath(self, parentViewIsEditing)]) {
        BOOL shouldChangeToEditingState = [[change valueForKey:NSKeyValueChangeNewKey] boolValue];
        [self changeToEditingState:shouldChangeToEditingState];
    }
    else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

#pragma mark - Methods

- (void)changeToEditingState:(BOOL)editState
{
    if (editState) {
        [self setAction:self.actionWhenEditing];
        [self setTitle:self.titleWhenEditing];
        [self setKeyEquivalent:self.keyEquivWhenEditing];
        [self setKeyEquivalentModifierMask:self.keyEquivModifierMaskWhenEditing];
    }
    else {
        [self setAction:self.actionWhenNotEditing];
        [self setTitle:self.titleWhenNotEditing];
        [self setKeyEquivalent:self.keyEquivWhenNotEditing];
        [self setKeyEquivalentModifierMask:self.keyEquivModifierMaskWhenNotEditing];
    }
}

@end
