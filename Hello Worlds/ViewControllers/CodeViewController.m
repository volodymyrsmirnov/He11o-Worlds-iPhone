//
//  CodeViewController.m
//  Hello Worlds
//
//  Created by Vladimir Smirnov on 5/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CodeViewController.h"
#import "TSMiniWebBrowser.h"

@interface CodeViewController ()
{
    NSString *Path;
    NSString *Code;
    NSString *Language;
    
    NSDictionary *Links;
}

@end

@implementation CodeViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    return self;
}

- (id) initWithPath: (NSString *) withPath
{
    Path = withPath;
    Code = [NSString stringWithContentsOfFile:Path encoding:NSUTF8StringEncoding error:nil];
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:nil action:nil];
    [[self navigationItem] setBackBarButtonItem:backButton];
    
    NSArray *PathComponents = [Path componentsSeparatedByString:@"/"];
    Language = [[[[PathComponents objectAtIndex:[PathComponents count]-1] componentsSeparatedByString:@"."] objectAtIndex:0] lowercaseString];
    
    NSString *LinksPath = [[NSBundle mainBundle] pathForResource:@"Links" ofType:@"plist"]; 
    NSData *LinksData = [NSData dataWithContentsOfFile:LinksPath];
    
    Links = (NSDictionary*)[NSPropertyListSerialization propertyListFromData:LinksData mutabilityOption:NSPropertyListMutableContainersAndLeaves format:nil errorDescription:nil];
    
    return [self initWithStyle:UITableViewStyleGrouped];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
        
    [[self tableView] setBounces:NO];    
    [[self tableView] setBackgroundColor:UIColorFromRGB(0x565863)];
    [[self tableView] setSeparatorStyle:UITableViewCellSeparatorStyleNone];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)Cell forRowAtIndexPath:(NSIndexPath *)indexPath 
{
    [Cell setBackgroundColor:UIColorFromRGB(0x383A3F)];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [[tableView cellForRowAtIndexPath:indexPath] setSelected:NO animated:YES];
    if ([indexPath section] == 1)
    {
        TSMiniWebBrowser *WebBrowser = [[TSMiniWebBrowser alloc] initWithUrl:[NSURL URLWithString:[Links objectForKey:Language]]];
        [[self navigationController] pushViewController:WebBrowser animated:YES];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([indexPath section] == 0) return 330;
    return 44;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *Cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    
    if ([indexPath section] == 0)
    {
        UIScrollView *ScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(5, 5, 290, 320)];
        [ScrollView setBounces:NO];
        [ScrollView setContentSize:CGSizeMake(1000, 1000)];
        
        UITextView *TextView = [[UITextView alloc] initWithFrame: CGRectMake(0, 0, 1000, 1000)];
        [TextView setEditable:NO];        
        [TextView setBackgroundColor:[UIColor clearColor]];
        [TextView setFont:[UIFont fontWithName:@"Courier" size:14]];
        [TextView setText:Code];
        [TextView setScrollEnabled:YES];
        [TextView setTextColor:UIColorFromRGB(0xE0E1E3)];
         
        [ScrollView addSubview:TextView];
        
        [[Cell contentView] addSubview:ScrollView];
        [Cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    else
    {
        [[Cell textLabel] setTextAlignment:UITextAlignmentCenter];
        [[Cell textLabel] setText:[NSString stringWithFormat:@"About %@ language",Language]];
        [Cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
        [[Cell textLabel] setTextColor:UIColorFromRGB(0xDCC175)];
    }
    
    return Cell;
}

@end
