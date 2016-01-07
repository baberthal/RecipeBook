//
//  RBCoreDataStack.m
//  RecipeBook
//
//  Created by Morgan Lieberthal on 1/6/16.
//  Copyright © 2016 Morgan Lieberthal. All rights reserved.
//

#import "RBCoreDataManager.h"
#import "RBFavorite.h"

@implementation RBCoreDataManager

#pragma mark - Singleton

+ (instancetype)sharedManager
{
    static RBCoreDataManager *_sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedManager = [[RBCoreDataManager alloc] init];
    });

    return _sharedManager;
}

#pragma mark - Core Data stack

@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize managedObjectContext = _managedObjectContext;

- (NSURL *)applicationDocumentsDirectory
{
    // The directory the application uses to store the Core Data store file. This code uses a
    // directory named "org.jmorgan.RecipeBook" in the user's Application Support directory.
    NSURL *appSupportURL =
          [[[NSFileManager defaultManager] URLsForDirectory:NSApplicationSupportDirectory
                                                  inDomains:NSUserDomainMask] lastObject];
    return [appSupportURL URLByAppendingPathComponent:@"org.jmorgan.RecipeBook"];
}

- (NSManagedObjectModel *)managedObjectModel
{
    // The managed object model for the application. It is a fatal error for the application not to
    // be able to find and load its model.
    if (_managedObjectModel) {
        return _managedObjectModel;
    }

    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"RecipeBook" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    // The persistent store coordinator for the application. This implementation creates and returns
    // a coordinator, having added the store for the application to it. (The directory for the store
    // is created, if necessary.)
    if (_persistentStoreCoordinator) {
        return _persistentStoreCoordinator;
    }

    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSURL *applicationDocumentsDirectory = [self applicationDocumentsDirectory];
    BOOL shouldFail = NO;
    NSError *error = nil;
    NSString *failureReason =
          @"There was an error creating or loading the application's saved data.";

    // Make sure the application files directory is there
    NSDictionary *properties =
          [applicationDocumentsDirectory resourceValuesForKeys:@[ NSURLIsDirectoryKey ]
                                                         error:&error];
    if (properties) {
        if (![properties[NSURLIsDirectoryKey] boolValue]) {
            failureReason = [NSString
                  stringWithFormat:
                        @"Expected a folder to store application data, found a file (%@).",
                        [applicationDocumentsDirectory path]];
            shouldFail = YES;
        }
    }
    else if ([error code] == NSFileReadNoSuchFileError) {
        error = nil;
        [fileManager createDirectoryAtPath:[applicationDocumentsDirectory path]
               withIntermediateDirectories:YES
                                attributes:nil
                                     error:&error];
    }

    if (!shouldFail && !error) {
        NSPersistentStoreCoordinator *coordinator = [[NSPersistentStoreCoordinator alloc]
              initWithManagedObjectModel:[self managedObjectModel]];
        NSURL *url = [applicationDocumentsDirectory
              URLByAppendingPathComponent:@"OSXCoreDataObjC.storedata"];
        if (![coordinator addPersistentStoreWithType:NSXMLStoreType
                                       configuration:nil
                                                 URL:url
                                             options:nil
                                               error:&error]) {
            coordinator = nil;
        }
        _persistentStoreCoordinator = coordinator;
    }

    if (shouldFail || error) {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        if (error) {
            dict[NSUnderlyingErrorKey] = error;
        }
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        [[NSApplication sharedApplication] presentError:error];
    }
    return _persistentStoreCoordinator;
}

- (NSManagedObjectContext *)managedObjectContext
{
    // Returns the managed object context for the application (which is already bound to the
    // persistent store coordinator for the application.)
    if (_managedObjectContext) {
        return _managedObjectContext;
    }

    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _managedObjectContext =
          [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];

    return _managedObjectContext;
}

- (IBAction)saveAction:(id)sender
{
    // Performs the save action for the application, which is to send the save: message to the
    // application's managed object context. Any encountered errors are presented to the user.
    if (![[self managedObjectContext] commitEditing]) {
        NSLog(@"%@:%@ unable to commit editing before saving", [self class],
              NSStringFromSelector(_cmd));
    }

    NSError *error = nil;
    if ([[self managedObjectContext] hasChanges] && ![[self managedObjectContext] save:&error]) {
        [[NSApplication sharedApplication] presentError:error];
    }
}

#pragma mark - Properties
@synthesize favorites = _favorites;

- (NSArray<RBFavorite *> *)favorites
{
    if (_favorites) {
        return _favorites;
    }

    @synchronized(self)
    {
        NSMutableArray<RBFavorite *> *items = [NSMutableArray array];

        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Favorite"];
        NSError *error;

        NSArray<RBFavorite *> *results =
              [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];

        if (error) {
            DDLogError(@"Error fetching favorites: %@\n%@", error.localizedDescription,
                       error.userInfo);
        }
        else {
            NSSortDescriptor *sortDescriptor =
                  [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES];
            [items addObjectsFromArray:[results sortedArrayUsingDescriptors:@[ sortDescriptor ]]];
        }

        _favorites = [items copy];
    }

    return _favorites;
}

@end
