//
//  RBWelcomeViewController.m
//  RecipeBook
//
//  Created by Morgan Lieberthal on 1/8/16.
//  Copyright © 2016 Morgan Lieberthal. All rights reserved.
//

#import "RBWelcomeViewController.h"

@interface RBWelcomeViewController ()

@property(weak) IBOutlet NSTextField *welcomeMessageField;

- (IBAction)btnCreateARecipe:(id)sender;
- (IBAction)btnSearchOnlineForRecipes:(id)sender;
- (IBAction)btnConfigureRecipeBook:(id)sender;
- (IBAction)btnLoadRecipeBookFromFile:(id)sender;
- (IBAction)btnImportARecipe:(id)sender;

@end

@implementation RBWelcomeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do view setup here.
}

- (IBAction)btnCreateARecipe:(id)sender
{
    [NSAnimationContext beginGrouping];
    [[NSAnimationContext currentContext] setDuration:2.0];
    [[self.view animator] removeFromSuperview];
    [NSAnimationContext endGrouping];

    if (self.delegate && [self.delegate respondsToSelector:@selector(welcomeViewController:
                                                                    addNewRecipeFromSender:)]) {
        [self.delegate welcomeViewController:self addNewRecipeFromSender:sender];
    }
}

- (IBAction)btnSearchOnlineForRecipes:(id)sender
{
}

- (IBAction)btnConfigureRecipeBook:(id)sender
{
}

- (IBAction)btnLoadRecipeBookFromFile:(id)sender
{
}

- (IBAction)btnImportARecipe:(id)sender
{
}
@end
