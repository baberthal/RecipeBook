//
//  AppDelegate.m
//  RecipeBook
//
//  Created by Morgan Lieberthal on 1/6/16.
//  Copyright © 2016 Morgan Lieberthal. All rights reserved.
//

#import "AppDelegate.h"
#import "RBCoreDataManager.h"

@interface AppDelegate ()

@property(weak) IBOutlet NSWindow *window;
- (IBAction)saveAction:(id)sender;
@property(readonly) NSManagedObjectContext *managedObjectContext;

@end

@implementation AppDelegate

+ (void)initialize
{
    [DDLog addLogger:[DDASLLogger sharedInstance]];
    [DDLog addLogger:[DDTTYLogger sharedInstance]];
    [[DDTTYLogger sharedInstance] setColorsEnabled:YES];
#ifdef DEBUG
    NSColorList *solarized = [NSColorList colorListNamed:@"Solarized"];

    if (!solarized) {
        return;
    }

    NSColor *error = [solarized colorWithKey:@"red"];
    NSColor *warn = [solarized colorWithKey:@"orange"];
    NSColor *info = [solarized colorWithKey:@"green"];
    NSColor *debug = [solarized colorWithKey:@"violet"];
    NSColor *verbose = [solarized colorWithKey:@"cyan"];

    if (error) {
        [[DDTTYLogger sharedInstance] setForegroundColor:error
                                         backgroundColor:nil
                                                 forFlag:DDLogFlagError];
    }

    if (warn) {
        [[DDTTYLogger sharedInstance] setForegroundColor:warn
                                         backgroundColor:nil
                                                 forFlag:DDLogFlagWarning];
    }

    if (info) {
        [[DDTTYLogger sharedInstance] setForegroundColor:info
                                         backgroundColor:nil
                                                 forFlag:DDLogFlagInfo];
    }

    if (debug) {
        [[DDTTYLogger sharedInstance] setForegroundColor:debug
                                         backgroundColor:nil
                                                 forFlag:DDLogFlagDebug];
    }

    if (verbose) {
        [[DDTTYLogger sharedInstance] setForegroundColor:verbose
                                         backgroundColor:nil
                                                 forFlag:DDLogFlagVerbose];
    }

#endif
}

#pragma mark - Application Lifecycle Events

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
}

- (void)applicationWillTerminate:(NSNotification *)aNotification
{
    // Insert code here to tear down your application
}

#pragma mark - Properties

- (RBCoreDataManager *)coreDataStack
{
    return [RBCoreDataManager sharedManager];
}

- (NSManagedObjectContext *)managedObjectContext
{
    return self.coreDataStack.managedObjectContext;
}

#pragma mark - Core Data Saving and Undo support

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

- (NSUndoManager *)windowWillReturnUndoManager:(NSWindow *)window
{
    // Returns the NSUndoManager for the application. In this case, the manager returned is that of
    // the managed object context for the application.
    return [[self managedObjectContext] undoManager];
}

- (NSApplicationTerminateReply)applicationShouldTerminate:(NSApplication *)sender
{
    // Save changes in the application's managed object context before the application terminates.

    if (!self.managedObjectContext) {
        return NSTerminateNow;
    }

    if (![[self managedObjectContext] commitEditing]) {
        NSLog(@"%@:%@ unable to commit editing to terminate", [self class],
              NSStringFromSelector(_cmd));
        return NSTerminateCancel;
    }

    if (![[self managedObjectContext] hasChanges]) {
        return NSTerminateNow;
    }

    NSError *error = nil;
    if (![[self managedObjectContext] save:&error]) {

        // Customize this code block to include application-specific recovery steps.
        BOOL result = [sender presentError:error];
        if (result) {
            return NSTerminateCancel;
        }

        NSString *question =
              NSLocalizedString(@"Could not save changes while quitting. Quit anyway?",
                                @"Quit without saves error question message");
        NSString *info = NSLocalizedString(
              @"Quitting now will lose any changes you have made since the last successful save",
              @"Quit without saves error question info");
        NSString *quitButton = NSLocalizedString(@"Quit anyway", @"Quit anyway button title");
        NSString *cancelButton = NSLocalizedString(@"Cancel", @"Cancel button title");
        NSAlert *alert = [[NSAlert alloc] init];
        [alert setMessageText:question];
        [alert setInformativeText:info];
        [alert addButtonWithTitle:quitButton];
        [alert addButtonWithTitle:cancelButton];

        NSInteger answer = [alert runModal];

        if (answer == NSAlertFirstButtonReturn) {
            return NSTerminateCancel;
        }
    }

    return NSTerminateNow;
}

@end
