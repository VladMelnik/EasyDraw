//
//  AppDelegate.h
//  Easy Draw
//
//  Created by Vlad Melnyk on 23.06.17.
//  Copyright © 2017 VM. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>





@interface AppDelegate : UIResponder <UIApplicationDelegate>



@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong) NSPersistentContainer *persistentContainer;

- (void)saveContext;


@end

