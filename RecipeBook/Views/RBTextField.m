//
//  RBTextField.m
//  RecipeBook
//
//  Created by Morgan Lieberthal on 1/9/16.
//  Copyright © 2016 Morgan Lieberthal. All rights reserved.
//

#import "RBTextField.h"

@implementation RBTextField

- (void)awakeFromNib
{
    [self registerAsObserverForSelf];
}

- (void)registerAsObserverForSelf
{
    [self addObserver:self forKeyPath:@keypath(self, shouldBeEditing) options:0 context:nil];
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary<NSString *, id> *)change
                       context:(void *)context
{
    if ([keyPath isEqualToString:@keypath(self, shouldBeEditing)]) {
        [self reconsiderEditingStatus];
    }
    else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

- (void)reconsiderEditingStatus
{
    [self setBordered:self.shouldBeEditing];
    [self setEditable:self.shouldBeEditing];
    [self setEnabled:self.shouldBeEditing];
    [self setDrawsBackground:self.shouldBeEditing];
    [self setBezeled:self.shouldBeEditing];
}

@end
