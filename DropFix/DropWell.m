//
//  DropWell.m
//  FileWell
//
//  Created by Chilton Webb on 8/26/11.
//  Copyright 2011 DevHQ. All rights reserved.
//

#import "DropWell.h"

NSString *DragWellChangedNotification = @"DragWellChangedNotification";

@implementation DropWell

@synthesize types;


- (void) awakeFromNib
{
    [self registerForDraggedTypes:[NSArray arrayWithObject:NSFilenamesPboardType]];
    [self setImageFrameStyle:NSImageFrameGrayBezel];

}

- (NSString *)file {
	return file;
}

// When we set the file, we also set the image which we get from the NSWorkspace:

- (void)setFile:(NSString *)newFile {
    
    // it's good practice to not do any work if nothing would change:
	if (newFile) {
		if ([newFile isEqualToString:file]) return;
		if (self.types && ![self.types containsObject:[[newFile pathExtension] lowercaseString]]) 
			return;
	}
    
	// live clean and let your works be seen:
	[file release];
	[image release];
	
	// copy the newFile into our instance variable:
	file = [newFile copyWithZone:[self zone]];
	
	// check if the file is nil or empty string:
	if (!file || [file isEqualToString:@""]) {
		image = nil;
	} else {
		// we have a file, now let's find the image for that file:
		image = [[[NSWorkspace sharedWorkspace] iconForFile:file] retain];
        [self setImageScaling:NSImageScaleNone];
		// returned as 32x32
	}
	
	// we'll need to redraw next event 
	// this is the approved Cocoa way of setting ourselves "dirty"
	[self setImage:image];

	[[NSNotificationCenter defaultCenter] postNotificationName:DragWellChangedNotification object:self];
}


#pragma mark DRAGGING DESTINATION PROTOCOL METHODS
// To add drag acceptance functionality to a control, implement these methods:

// this is called when the drag enters our view
// by returning NSDragOperationCopy

- (NSDragOperation) draggingEntered:sender {
    NSPasteboard   *pboard;
    
    last      = NSDragOperationNone;
    pboard    = [sender draggingPasteboard];
    //    [[self window] makeFirstResponder:self];
    //    [self setNeedsDisplay:YES];
    // we don't acept drags if we are the provider!!
    if ([sender draggingSource] == self) return NSDragOperationNone;
	
    if ([[pboard types] containsObject:NSFilenamesPboardType]) {
        NSString *fileName = [[pboard propertyListForType:NSFilenamesPboardType]objectAtIndex:0];
        if (self.types && ![self.types containsObject:[[fileName pathExtension] lowercaseString]]) 
            return NSDragOperationNone;
        
//        image = [[[NSWorkspace sharedWorkspace] iconForFile:[[pboard propertyListForType:NSFilenamesPboardType]objectAtIndex:0]]retain];   
//        if (image) {
//            [self setImage:image];
//        }

        // we'll copy or link depending on the intent of the dragging source:
        last = (unsigned int)[sender draggingSourceOperationMask]; 
    }
    return last;
}

// instead of constantly rechecking the pasteboard as the mouse moves inside the view
// we'll simply return the cached value that we set in 'last' in draggingEntered:

- (NSDragOperation) draggingUpdated:sender {
    return last;
}

// Because we're providing feedback by setting the file right when the user enters
// we'll need to undo that work if the user does not let go of the drag inside and exits instead:

- (void) draggingExited:sender
{
    // the user has exited -> clean up:     
    if ([sender draggingSource] != self)  {
        if (file == nil) {
            // then unset the file image we set in mouseEntered as feedback...
            [image release];
            image = nil;
            [self setNeedsDisplayInRect:[self bounds]];
        } 
        last = NSDragOperationNone;
    }
}

- (BOOL) prepareForDragOperation:sender {
    return YES;
}

- (BOOL) performDragOperation:(id <NSDraggingInfo>)sender {
    NSPasteboard   *pboard;
    pboard    = [sender draggingPasteboard];
    [self setFile:[[pboard propertyListForType:NSFilenamesPboardType]objectAtIndex:0]];
    return YES;
}

- (void)concludeDragOperation:(id <NSDraggingInfo>)sender {
    // we already did the work in draggingEntered!
    // You might notify some other object that the file is here
    last = NSDragOperationNone;
}

// this is good if you want to be able to drag out data even if the window is not frontmost
// the first click will do more than just bring the window to front:

- (BOOL)acceptsFirstMouse:(NSEvent *)theEvent {
    return YES;
}


@end
