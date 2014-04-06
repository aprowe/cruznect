//
//  FeaturedTVC.m
//  Cruznect
//
//  Created by Bruce•D•Su on 4/5/14.
//  Copyright (c) 2014 Cruznect. All rights reserved.
//

#import "FeaturedTVC.h"
#import "CruznectRequest.h"

#define kImageViewTag 11
#define kTitleTextLabelTag 22
#define kDetailTextViewTag 33

@interface FeaturedTVC ()
@property (strong, nonatomic) NSArray *featuredProjects;
@end

@implementation FeaturedTVC

- (void)refresh
{
    [self.refreshControl beginRefreshing];
    dispatch_queue_t fetchQ = dispatch_queue_create("Cruznect Fetch", NULL);
    dispatch_async(fetchQ, ^{
        self.featuredProjects =
		[CruznectRequest fetchFeaturedProjectsWithUserID:[[NSUserDefaults standardUserDefaults]
														  objectForKey:@"userID"]];
		dispatch_async(dispatch_get_main_queue(), ^{
			[self.tableView reloadData];
			[self.refreshControl endRefreshing];
		});
    });
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
	[self.refreshControl addTarget:self
                            action:@selector(refresh)
                  forControlEvents:UIControlEventValueChanged];
	if ([[NSUserDefaults standardUserDefaults] objectForKey:@"login"]) {
		[self refresh];
	}
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return [self.featuredProjects count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Project"
															forIndexPath:indexPath];
    
	NSDictionary *project = [self.featuredProjects objectAtIndex:indexPath.row];
	
	UIImageView *imageView = (UIImageView *)[cell viewWithTag:kImageViewTag];
	imageView.image = [CruznectRequest imageForProject:[project objectForKey:PROJECT_IMAGE]];
	UILabel *titleLabel = (UILabel *)[cell viewWithTag:kTitleTextLabelTag];
	titleLabel.text = [project objectForKey:PROJECT_NAME];
	UITextView *detailTextView = (UITextView *)[cell viewWithTag:kDetailTextViewTag];
	detailTextView.text = [project objectForKey:PROJECT_DESCRIPTION];
    
    return cell;
}

@end