//
//  DropWell.h
//  FileWell
//
//  Created by Chilton Webb on 8/26/11.
//  Copyright 2011 DevHQ. All rights reserved.
//

#import <Cocoa/Cocoa.h>

extern NSString *DragWellChangedNotification;

@interface DropWell : NSImageView {
    NSImage *image;		// the image displayed in the well and dragged by the user
    NSString *file;		// the file that the user will drag out
    unsigned int last;	// for optimizing the draggingUpdated: method
	NSArray *types;
    
}

@property (nonatomic, retain) NSArray *types;
// if you want to programmatically set a file into the well:
@property (nonatomic, retain) NSString *file;

@end
