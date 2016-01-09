//
//  RBWelcomeViewController.h
//  RecipeBook
//
//  Created by Morgan Lieberthal on 1/8/16.
//  Copyright © 2016 Morgan Lieberthal. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@protocol RBWelcomeViewControllerDelegate;

@interface RBWelcomeViewController : NSViewController

@property(weak) IBOutlet id<RBWelcomeViewControllerDelegate> delegate;

@end

@protocol RBWelcomeViewControllerDelegate <NSObject>

- (void)welcomeViewController:(RBWelcomeViewController *)welcomeController
       addNewRecipeFromSender:(id)sender;

@end