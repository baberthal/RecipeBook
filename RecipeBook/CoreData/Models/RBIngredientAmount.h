//
//  RBIngredientAmount.h
//  RecipeBook
//
//  Created by Morgan Lieberthal on 1/6/16.
//  Copyright © 2016 Morgan Lieberthal. All rights reserved.
//

#import <CoreData/CoreData.h>
#import <Foundation/Foundation.h>

@class RBIngredient, RBRecipe;

typedef NS_ENUM(int64_t, RBIngredientUnit) {
    RBIngredientUnitVolumeTeaspoon,
    RBIngredientUnitVolumeTablespoon,
    RBIngredientUnitVolumeFluidOunce,
    RBIngredientUnitVolumeGill,
    RBIngredientUnitVolumeCup,
    RBIngredientUnitVolumePint,
    RBIngredientUnitVolumeQuart,
    RBIngredientUnitVolumeGallon,
    RBIngredientUnitVolumeMilliliter,
    RBIngredientUnitVolumeLiter,
    RBIngredientUnitVolumeDecileter,
    RBIngredientUnitMassPound,
    RBIngredientUnitMassOunce,
    RBIngredientUnitMassMilligram,
    RBIngredientUnitMassGram,
    RBIngredientUnitMassKilogram,
    RBIngredientUnitLengthMillimeter,
    RBIngredientUnitLengthMeter,
    RBIngredientUnitLengthInch,
    RBIngredientUnitLengthFoot
};

NS_ASSUME_NONNULL_BEGIN

@interface RBIngredientAmount : NSManagedObject

// Insert code here to declare functionality of your managed object subclass

@end

NS_ASSUME_NONNULL_END

#import "RBIngredientAmount+CoreDataProperties.h"
