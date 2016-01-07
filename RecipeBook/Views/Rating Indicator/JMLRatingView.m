//
//  JMLRatingControl.m
//  RecipeBook
//
//  Created by Morgan Lieberthal on 1/7/16.
//  Copyright © 2016 Morgan Lieberthal. All rights reserved.
//

#import "JMLRatingView.h"

static NSString *const kDefaultFullStarImageName = @"ic_star";
static NSString *const kDefaultHalfStarImageName = @"ic_star_half";
static NSString *const kDefaultEmptyStarImageName = @"ic_star_border";

@interface JMLRatingView ()

- (void)commonSetup;
- (void)handleClickAtLocation:(CGPoint)location;
- (void)notifyDelegate;

@end

@implementation JMLRatingView

@synthesize rate = _rate;
@synthesize alignment = _alignment;
@synthesize padding = _padding;
@synthesize editable = _editable;
@synthesize fullStarImage = _fullStarImage;
@synthesize emptyStarImage = _emptyStarImage;
@synthesize delegate = _delegate;

#pragma mark - Initializers

- (instancetype)initWithFrame:(NSRect)frameRect
{
    return [self initWithFrame:frameRect
                      fullStar:[NSImage imageNamed:kDefaultFullStarImageName]
                      halfStar:[NSImage imageNamed:kDefaultHalfStarImageName]
                     emptyStar:[NSImage imageNamed:kDefaultEmptyStarImageName]];
}

- (instancetype)initWithFrame:(NSRect)frameRect
                     fullStar:(NSImage *)fullStarImg
                     halfStar:(NSImage *)halfStarImg
                    emptyStar:(NSImage *)emptyStarImg
{
    self = [super initWithFrame:frameRect];
    if (self) {
        _fullStarImage = fullStarImg;
        _halfStarImage = halfStarImg;
        _emptyStarImage = emptyStarImg;

        [self commonSetup];
    }

    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        _fullStarImage = [NSImage imageNamed:kDefaultFullStarImageName];
        _halfStarImage = [NSImage imageNamed:kDefaultHalfStarImageName];
        _emptyStarImage = [NSImage imageNamed:kDefaultEmptyStarImageName];

        [self commonSetup];
    }

    return self;
}

- (void)dealloc
{
    _fullStarImage = nil;
    _emptyStarImage = nil;
    _halfStarImage = nil;
}

- (void)commonSetup
{
    _padding = 4;
    _numStars = 5;
    self.alignment = JMLRatingViewAlignmentLeft;
    self.editable = NO;
}

- (void)drawRect:(NSRect)dirtyRect
{
    CGFloat xOrigin = self.bounds.size.width - _numStars * _fullStarImage.size.width -
                      (_numStars - 1) * _padding;

    switch (_alignment) {
    case JMLRatingViewAlignmentLeft: {
        _origin = CGPointMake(0, 0);
        break;
    }

    case JMLRatingViewAlignmentCenter: {
        _origin = CGPointMake(xOrigin / 2, 0);
        break;
    }

    case JMLRatingViewAlignmentRight: {
        _origin = CGPointMake(xOrigin, 0);
        break;
    }
    }

    float x = _origin.x;
    for (int i = 0; i < _numStars; i++) {
        [_emptyStarImage drawAtPoint:CGPointMake(x, _origin.y)
                            fromRect:NSZeroRect
                           operation:NSCompositeCopy
                            fraction:1.0];
        x += _fullStarImage.size.width + _padding;
    }

    float floor = floorf(_rate);
    x = _origin.x;
    for (int i = 0; i < floor; i++) {
        [_fullStarImage drawAtPoint:CGPointMake(x, _origin.y)
                           fromRect:NSZeroRect
                          operation:NSCompositeCopy
                           fraction:1.0];
        x += _fullStarImage.size.width + _padding;
    }

    if (_numStars - floor > 0.01) {
        NSRectClip(CGRectMake(x, _origin.y, _fullStarImage.size.width * (_rate - floor),
                              _fullStarImage.size.height));
        [_fullStarImage drawAtPoint:CGPointMake(x, _origin.y)
                           fromRect:NSZeroRect
                          operation:NSCompositeCopy
                           fraction:1.0];
    }
}

- (void)setRate:(CGFloat)rate
{
    _rate = rate;
    [self setNeedsDisplay:YES];
    [self notifyDelegate];
}

- (void)setAlignment:(JMLRatingViewAlignment)alignment
{
    _alignment = alignment;
    [self setNeedsLayout:YES];
}

- (void)setEditable:(BOOL)editable
{
    _editable = editable;
}

- (void)setFullStarImage:(NSImage *)fullStarImage
{
    if (fullStarImage != _fullStarImage) {
        _fullStarImage = nil;
        _fullStarImage = fullStarImage;
        [self setNeedsDisplay:YES];
    }
}

- (void)setEmptyStarImage:(NSImage *)emptyStarImage
{
    if (emptyStarImage != _emptyStarImage) {
        _emptyStarImage = nil;
        _emptyStarImage = emptyStarImage;
        [self setNeedsDisplay:YES];
    }
}

- (void)setHalfStarImage:(NSImage *)halfStarImage
{
    if (halfStarImage != _halfStarImage) {
        _halfStarImage = nil;
        _halfStarImage = halfStarImage;
        [self setNeedsDisplay:YES];
    }
}

- (void)handleClickAtLocation:(CGPoint)location
{
    for (int i = (int)_numStars - 1; i > -1; i--) {
        if (location.x > _origin.x + i * (_fullStarImage.size.width + _padding) - _padding / 2.) {
            self.rate = i + 1;
            return;
        }
    }

    self.rate = 0;
}

- (void)notifyDelegate
{
    if (self.delegate &&
        [self.delegate respondsToSelector:@selector(ratingControl:changedToNewRating:)]) {
        [self.delegate performSelector:@selector(ratingControl:changedToNewRating:)
                            withObject:self
                            withObject:[NSNumber numberWithFloat:self.rate]];
    }
}

@end
