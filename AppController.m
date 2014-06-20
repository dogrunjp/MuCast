//
//  AppController.m
//  MuCast
//
//  Created by oec on 2014/05/29.
//  Copyright (c) 2014年 oec. All rights reserved.
//

#import "AppController.h"
#import "iTunes.h"
#import <Accounts/Accounts.h>
#import <Social/Social.h>

@implementation AppController
@synthesize accountStore;

- (void)awakeFromNib{
    statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength];
    
    [statusItem setTitle:@""];
    [statusItem setHighlightMode:YES];
    [statusItem setImage:[NSImage imageNamed:@"icon_mucast_18"]];
    [statusItem setMenu:statusMenu];
    
    iTunesApp = [SBApplication applicationWithBundleIdentifier:@"com.apple.itunes"];
    
    m = 0;
    accountStore = [[ACAccountStore alloc] init];
    accountType = [accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
    accountArray = [accountStore accountsWithAccountType:accountType];

    [accountStore
     requestAccessToAccountsWithType:accountType
     options:nil
     completion:^(BOOL granted, NSError *error) {
         if (granted) {
             //NSArray *accountArray = [accountStore accountsWithAccountType:accountType];
             menuAcc = [[NSMenu alloc]init];
             
             int i;
             for (i=0; i < [accountArray count]; i++) {
                 if (i == 0) {
                     menuItems = [menuAcc insertItemWithTitle:[[accountArray objectAtIndex:i] username]
                                                                   action:@selector(press:)
                                                            keyEquivalent:@"" atIndex:i];
                  [menuItems setTarget:self];
                  [menuItems setState:NSOnState];
                  [menuItems setRepresentedObject:accountArray];
                 }
                 else{
                  menuItems = [menuAcc insertItemWithTitle:[[accountArray objectAtIndex:i] username] action:@selector(press:) keyEquivalent:@"" atIndex:i];
                  [menuItems setTarget:self];
                  [menuItems setState:NSOffState];
                  [menuItems setRepresentedObject:accountArray];
                 }

             }
             
             //NSMenuItemのsetSubmenuメソッドの引数がNSMenu
             [_subMenu setSubmenu:menuAcc];
             [menuAcc setAutoenablesItems:NO];
             [_subMenu setEnabled:YES];
             
         }
     }];

    if([iTunesApp isRunning])
    {
        if (iTunesEPlSPlaying == [iTunesApp playerState])
             {
                 [menuItem1 setTitle:@"停止する"];
             }
        else if(iTunesEPlSPaused == [iTunesApp playerState])
            {
                [menuItem1 setTitle:@"再生"];
            }
    }
}

- (IBAction)nowplayinglog:(id)sender {
    //iTunesApp = [SBApplication applicationWithBundleIdentifier:@"com.apple.itunes"];
    NSString *currentTrackName = [iTunesApp.currentTrack name];
    NSString *currentTrackArtist = [iTunesApp.currentTrack artist];
    NSString *nowplaying = [NSString stringWithFormat:@"#nowplaying %@ - %@", currentTrackName, currentTrackArtist];
   
    [accountStore
     requestAccessToAccountsWithType:accountType
     options:nil
     completion:^(BOOL granted, NSError *error) {
         if (granted) {
             //NSArray *accountArray = [accountStore accountsWithAccountType:accountType];
             if (accountArray.count > 0) {
                 NSURL *url = [NSURL URLWithString:@"https://api.twitter.com/1.1/statuses/update.json"];
                 NSDictionary *params = [NSDictionary dictionaryWithObject:nowplaying forKey:@"status"];
                 //NSDictionary* params = @{@"screen_name" : [[accountArray objectAtIndex:1] username],
                 //                         @"count" : @"60" };
                 
                 SLRequest *request = [SLRequest requestForServiceType:SLServiceTypeTwitter
                                                         requestMethod:SLRequestMethodPOST
                                                                   URL:url
                                                            parameters:params];
                 [request setAccount:[accountArray objectAtIndex:m]];
                 [request performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {
                     NSLog(@"responseData=%@: %@", [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding], [[accountArray objectAtIndex:m]username]);
                 }];
             }
         }
     }];
}


- (IBAction)play:(id)sender {
    [iTunesApp playpause];
    if (iTunesEPlSPlaying == [iTunesApp playerState])
    {
        [menuItem1 setTitle:@"停止する"];
    }
    else if(iTunesEPlSPaused == [iTunesApp playerState])
    {
        [menuItem1 setTitle:@"再生"];
    }
}

- (IBAction)playNext:(id)sender {
    [iTunesApp nextTrack];
}

- (IBAction)playLast:(id)sender {
    [iTunesApp previousTrack];
}

- (void)press:(id)sender
{
    NSMenuItem *mi = (NSMenuItem*)sender;
    m = [[[mi parentItem] submenu] indexOfItem:mi];
    NSLog(@"%ld",(long)m);
    [menuItems setState:NSOffState];
    //[mi setState:NSOnState];
    for(NSMenuItem *mis in menuAcc.itemArray){
        [mis setState:NSOffState];
    }
    [sender setState:NSOnState];
}


@end
