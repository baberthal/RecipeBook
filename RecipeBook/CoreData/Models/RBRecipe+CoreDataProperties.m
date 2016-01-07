//
//  RBRecipe+CoreDataProperties.m
//  RecipeBook
//
//  Created by Morgan Lieberthal on 1/6/16.
//  Copyright © 2016 Morgan Lieberthal. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "RBRecipe+CoreDataProperties.h"

@implementation RBRecipe (CoreDataProperties)

@dynamic recipeDescription;
@dynamic stars;
@dynamic recipeGroup;
@dynamic ingredientAmounts;
@dynamic steps;

@end
