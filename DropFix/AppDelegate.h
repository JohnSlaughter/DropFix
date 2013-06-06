//
//  AppDelegate.h
//  DropFix
//
//  Created by John Slaughter on 6/6/13.
//  Copyright (c) 2013 Engineering & Science Computing - University of Notre Dame. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "DropWell.h"

@interface AppDelegate : NSObject <NSApplicationDelegate> {
    NSWindow *window;
    IBOutlet DropWell *fileWell;
}

@property (assign) IBOutlet NSWindow *window;
@property (nonatomic, retain) IBOutlet DropWell *fileWell;
@end
