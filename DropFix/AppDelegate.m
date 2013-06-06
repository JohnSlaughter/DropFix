//
//  AppDelegate.m
//  DropFix
//
//  Created by John Slaughter on 6/6/13.
//  Copyright (c) 2013 Engineering & Science Computing - University of Notre Dame. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate

@synthesize window, fileWell;

- (void)dealloc
{
    [super dealloc];
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(fileWellChanged:) name:DragWellChangedNotification object:fileWell];
}

- (void)fileWellChanged:(NSNotification *)notification
{
    // xattr -d com.apple.FinderInfo /pathtofile

//    NSLog(@"Disk Image Name: %@", [[fileWell file] lastPathComponent]);
//    NSLog(@"Disk Image Path: %@", [[fileWell file] stringByResolvingSymlinksInPath]);
    
    NSTask *theTask = [[NSTask alloc] init];
	[theTask setLaunchPath: @"/usr/bin/xattr"];
	[theTask setArguments:[NSArray arrayWithObjects: @"-d", @"com.apple.Finder", [[fileWell file] stringByResolvingSymlinksInPath], nil]];
	
    NSPipe *thePipe = [NSPipe pipe];
	[theTask setStandardOutput: thePipe];
	[theTask setStandardError: thePipe];
    
	[theTask launch];
    
	NSData *rawData = [[thePipe fileHandleForReading] readDataToEndOfFile];
	NSString *rawString = [[NSString alloc] initWithData: rawData encoding: NSUTF8StringEncoding];
    
    NSAlert * alert = [NSAlert alertWithMessageText:@"Process Complete" defaultButton:@"OK" alternateButton:nil otherButton:nil informativeTextWithFormat:rawString];
    [alert runModal];
    
    [theTask release];
	[rawString release];

}


@end
