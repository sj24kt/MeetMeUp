//
//  RootViewController.m
//  MeetMeUp
//
//  Created by Sherrie Jones on 3/23/15.
//  Copyright (c) 2015 Sherrie Jones. All rights reserved.
//

#import "RootViewController.h"

@interface RootViewController () <UITableViewDataSource, UITableViewDelegate>

@property NSMutableArray *meetupsArray;
@property (strong, nonatomic) IBOutlet UITableView *meetupTableView;
//MeetMeUpCell
//485d28c1da236b5e16e7070664a34

@end

@implementation RootViewController

#pragma mark - ViewLifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];

    [self getDataFromUrl:@"https://api.meetup.com/2/open_events.json?zip=80202&text=mobile&time=,1w&key=485d28c1da236b5e16e7070664a34"];
}

#pragma mark - Helper methods

- (void)getThumbnailsFromUrl:(NSString *)urlString {

    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        NSDictionary *result = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&connectionError];

        NSDictionary *resultDictionary = [result objectForKey:@"results"][0];
        NSDictionary *groupPhoto = [resultDictionary objectForKey:@"group_photo"];
        NSString *imageUrl = [groupPhoto objectForKey:@"meetup"];
        NSLog(@"%@", imageUrl);
    }];
}

- (void)getDataFromUrl:(NSString *)urlString {

    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        NSDictionary *resultsDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&connectionError];

        self.meetupsArray = [resultsDictionary objectForKey:@"results"];

        for (NSMutableDictionary *meetupDictionary in self.meetupsArray) {
            NSDictionary *group = [meetupDictionary objectForKey:@"group"];
            NSString *groupId = [[group objectForKey:@"id"] stringValue];
            NSString *groupUrl = [[@"https://api.meetup.com/2/groups?&sign=true&group_id=" stringByAppendingString: groupId] stringByAppendingString:@"&page=20&key=485d28c1da236b5e16e7070664a34"];
            [self getThumbnailsFromUrl:groupUrl];
            //[meetupDictionary setObject:[self getThumbnailsFromUrl:groupUrl] forKey:@"groupImage"];
        }

        [self.meetupTableView reloadData];
    }];
}

#pragma mark - UITableView methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.meetupsArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    NSDictionary *meeting = [self.meetupsArray objectAtIndex:indexPath.row];
    NSDictionary *venue = [meeting objectForKey:@"venue"];

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MeetMeUpCell"];

    cell.textLabel.text = [meeting objectForKey:@"name"];
    cell.detailTextLabel.text = [venue objectForKey:@"address_1"];
    //cell.imageView.image = [meeting objectForKey:@"groupImage"];

    return cell;
}





@end




















