//
//  SourceViewController.m
//  Hello Worlds
//
//  Created by Vladimir Smirnov on 5/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SourceViewController.h"
#import "CodeViewController.h"

@interface SourceViewController ()
{
    NSString *Path;
    NSArray *Contents;
    NSFileManager *FileManager;
}

@end

@implementation SourceViewController

- (id) initWithPath: (NSString *) withPath
{
    Path = withPath;
    
    if (![self title])
    {
        [self setTitle:@"He11o Worlds"];
    }
    
    FileManager = [NSFileManager defaultManager];
    Contents = [FileManager contentsOfDirectoryAtPath:Path error:nil];
    
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:nil action:nil];
    [[self navigationItem] setBackBarButtonItem:backButton];
    
    [[[self navigationController] navigationBar] setBackgroundColor:[UIColor blackColor]];
        
    return [self initWithNibName:nil bundle:nil];
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
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [Contents count];
}

- (NSString *) FilesInSingularOrPlural:(int) Quantity
{
    if (Quantity == 1) return @"1 file";
    
    return [NSString stringWithFormat:@"%i files", Quantity];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)Cell forRowAtIndexPath:(NSIndexPath *)indexPath 
{
        if ([indexPath row] % 2) [Cell setBackgroundColor:UIColorFromRGB(0x636571)];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *ContentsItem = [Contents objectAtIndex:[indexPath row]]; 
    NSString *ContentsItemPath = [NSString stringWithFormat:@"%@/%@",Path,ContentsItem];
    
    UITableViewCell *Cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:nil];
    
    BOOL IsDir;
    
    [FileManager fileExistsAtPath:ContentsItemPath isDirectory:(&IsDir)];
    
    if (IsDir)
    {
        NSArray *SubContents = [FileManager contentsOfDirectoryAtPath:ContentsItemPath error:nil];
        
        [Cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
        [[Cell textLabel] setText:ContentsItem];
        [[Cell detailTextLabel] setText:[NSString stringWithFormat:@"%@: %@",[self FilesInSingularOrPlural:[SubContents count]], [[SubContents componentsJoinedByString:@", "] lowercaseString]]];      
    }
    else 
    {
        [[Cell textLabel] setText:[ContentsItem lowercaseString]];
        
        NSInteger FileSize = [[[[NSFileManager defaultManager] attributesOfItemAtPath:ContentsItemPath error:nil] objectForKey:@"NSFileSize"] intValue];
        NSString *FileLanguage = [[[ContentsItem componentsSeparatedByString:@"."] objectAtIndex:0] uppercaseString];
        
        [[Cell detailTextLabel] setText:[NSString stringWithFormat:@"%i bytes in %@ language", FileSize, FileLanguage]];
    }
    
    [[Cell textLabel] setTextColor:UIColorFromRGB(0xDCC175)];
    [[Cell detailTextLabel] setTextColor:UIColorFromRGB(0x9FD0EC)];
    
    return Cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [[tableView cellForRowAtIndexPath:indexPath] setSelected:NO animated:YES];
    
    NSString *ContentsItem = [Contents objectAtIndex:[indexPath row]]; 
    NSString *ContentsItemPath = [NSString stringWithFormat:@"%@/%@",Path,ContentsItem];
    
    BOOL IsDir;
    
    [FileManager fileExistsAtPath:ContentsItemPath isDirectory:(&IsDir)];
    
    if (IsDir)
    {
        SourceViewController *NewSourceView = [[SourceViewController alloc] initWithPath:ContentsItemPath];
        NSArray *SubContents = [FileManager contentsOfDirectoryAtPath:ContentsItemPath error:nil];
        [NewSourceView setTitle:[NSString stringWithFormat:@"%@ - %@",ContentsItem,[self FilesInSingularOrPlural:[SubContents count]]]];
        [[self navigationController] pushViewController:NewSourceView animated:YES];
    }
    else 
    {
        CodeViewController *CodeView = [[CodeViewController alloc] initWithPath:ContentsItemPath];
        NSInteger FileSize = [[[[NSFileManager defaultManager] attributesOfItemAtPath:ContentsItemPath error:nil] objectForKey:@"NSFileSize"] intValue];
        [CodeView setTitle:[NSString stringWithFormat:@"%@ - %i bytes",ContentsItem,FileSize]];
        [[self navigationController] pushViewController:CodeView animated:YES];
    }
    
}

@end
