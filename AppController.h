//
//  AppController.h
//  MuCast
//
//  Created by oec on 2014/05/29.
//  Copyright (c) 2014年 oec. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "iTunes.h"
#import <Accounts/Accounts.h>
#import <Social/Social.h>


@interface AppController : NSObject
{
    IBOutlet NSMenu *statusMenu;
    NSStatusItem *statusItem;
    NSImage *statusImage;
    iTunesApplication *iTunesApp;
    NSString *twitterTimelineUsername;
    NSString *twitterGetTimelineStatus;
    NSArray *timelineStatuses;
    ACAccountStore *accountStore;
    ACAccountType *accountType;
    NSArray *accountArray;
    NSString *accessToken;
    NSString *accessTokenSecret;
    NSMenuItem *menuItem1;
    NSMenuItem *menuItems;
    NSMenu *menuAcc;
    NSInteger m;
    NSResponder *firstResponder;
}

- (IBAction)nowplayinglog:(id)sender;
- (IBAction)play:(id)sender;
- (IBAction)playNext:(id)sender;
- (IBAction)playLast:(id)sender;
- (void)press:(id)sender;
- (IBAction)comment:(id)sender;
- (BOOL)makeFirstResponder:(NSResponder *)responder;

@property (weak) IBOutlet NSMenu *mucast_menu;
@property (strong) IBOutlet NSTextField *commentField;
@property (weak) IBOutlet NSMenu *menuAccount;
@property ACAccountStore *accountStore;
@property (weak) IBOutlet NSMenuItem *subMenu;
@property (weak) IBOutlet NSTextField *textField;

@end
