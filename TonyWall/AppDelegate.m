//
//  AppDelegate.m
//  TonyWall
//
//  Created by 王卓 on 2018/4/17.
//  Copyright © 2018年 王卓. All rights reserved.
//

#import "AppDelegate.h"


#define IMAGE_PATCH  @"IMAGE_PATCH"
@interface AppDelegate ()

@property (weak) IBOutlet NSWindow *window;
@property (weak) IBOutlet NSMenu *shareMenu;
@property (weak) IBOutlet NSImageView *imageView;

@property (nonatomic ,strong) NSStatusItem *items;
@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    
    self.window.styleMask = NSWindowStyleMaskBorderless;
    [self.window setRestorable:NO];
    NSRect frame = [NSScreen mainScreen].frame;
    [self.window setFrame:frame display:YES];
    [self.window makeKeyWindow];
    [self.window setLevel:kCGDesktopWindowLevel-1];

    
    NSStatusBar *statusBar = [NSStatusBar systemStatusBar];
    NSStatusItem *item = [statusBar statusItemWithLength:NSSquareStatusItemLength];
//    item.button.image =[NSImage imageNamed:NSImageNameTouchBarQuickLookTemplate];
    item.button.image = [NSImage imageNamed:@"menuImage"];
    item.menu = self.shareMenu;
    self.items = item;
    
    //The window is unaffected by Exposé; it stays visible and stationary, like the desktop window.
    [self.window setCollectionBehavior:NSWindowCollectionBehaviorStationary];
    
    NSURL *fileUrl = [NSURL URLWithString:[[NSUserDefaults standardUserDefaults] objectForKey:@"IMAGE_PATCH"]];
    NSImage *image = [[NSImage alloc]initWithContentsOfURL:fileUrl];

    if (image !=nil && image.size.width>0) {
        //open file
        self.imageView.image = image;
    }

    // Insert code here to initialize your application
}
- (void)readLocationImageSource{
    
    NSLock *lock = [[NSLock alloc]init];
    [lock lock];
    
    NSOpenPanel *openPanel = [NSOpenPanel openPanel];
    [openPanel setPrompt: @"打开"];

    openPanel.allowedFileTypes = [NSArray arrayWithObjects: @"jpeg", @"png",@"jpg",@"gif",@"webp",nil];
    [openPanel setCanChooseFiles:YES];
    [openPanel setCanChooseDirectories:YES];
    [openPanel setCanCreateDirectories:YES];
    NSInteger i = [openPanel runModal];
    if (i == NSModalResponseOK) {
        NSURL *url = openPanel.URL;
        if (!url) {
            return;
        }else{
            //open file
            NSURL *fileUrl = [[openPanel URLs] objectAtIndex:0];
            [[NSUserDefaults standardUserDefaults] setValue:fileUrl.absoluteString forKey:@"IMAGE_PATCH"];
            NSImage *image = [[NSImage alloc]initWithContentsOfURL:fileUrl];
            self.imageView.image = image;
        }
    }
    
    [lock unlock];

}
- (IBAction)chooseLocationImage:(id)sender {

    [self readLocationImageSource];

}
- (IBAction)quitAction:(id)sender {
    [[NSApplication sharedApplication] terminate:self];
}
-(void)applicationWillTerminate:(NSNotification *)notification{
    NSStatusBar *statusBar = [NSStatusBar systemStatusBar];
    [statusBar removeStatusItem:self.items];
}

@end
