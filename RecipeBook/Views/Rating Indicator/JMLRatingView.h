//
//  JMLRatingControl.h
//  RecipeBook
//
//  Created by Morgan Lieberthal on 1/7/16.
//  Copyright © 2016 Morgan Lieberthal. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@protocol JMLRatingViewDelegate;

typedef NS_ENUM(NSUInteger, JMLRatingViewAlignment) {
    JMLRatingViewAlignmentLeft,
    JMLRatingViewAlignmentCenter,
    JMLRatingViewAlignmentRight
};

IB_DESIGNABLE
@interface JMLRatingView : NSView
{
    NSImage *_emptyStarImage;
    NSImage *_fullStarImage;
    NSImage *_halfStarImage;
    CGPoint _origin;
    NSInteger _numStars;
}

@property(nonatomic, assign) IBInspectable JMLRatingViewAlignment alignment;
@property(nonatomic, assign) CGFloat rate;
@property(nonatomic, assign) CGFloat padding;
@property(nonatomic, assign) IBInspectable BOOL editable;
@property(nonatomic, retain) IBInspectable NSImage *fullStarImage;
@property(nonatomic, retain) IBInspectable NSImage *emptyStarImage;
@property(nonatomic, retain) IBInspectable NSImage *halfStarImage;
@property(nonatomic, assign) IBOutlet id<JMLRatingViewDelegate> delegate;

- (instancetype)initWithFrame:(NSRect)frameRect;
- (instancetype)initWithFrame:(NSRect)frameRect
                     fullStar:(NSImage *)fullStarImg
                     halfStar:(NSImage *)halfStarImg
                    emptyStar:(NSImage *)emptyStarImg;

@end

@protocol JMLRatingViewDelegate <NSObject>

- (void)ratingControl:(JMLRatingView *)control changedToNewRating:(NSNumber *)rating;

@end