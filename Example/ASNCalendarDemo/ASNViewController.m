//
//  ASNViewController.m
//  ASNCalendarDemo
//
//  Created by AsanoYuki on 2014/07/08.
//  Copyright (c) 2014年 AsanoYuki. All rights reserved.
//

#import "ASNViewController.h"

@interface ASNViewController ()

@end

@implementation ASNViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    ASNCalendar *calendar = [[ASNCalendar alloc] initWithFrame:CGRectMake(0, 80, 320, 303)];
    calendar.delegate = self;
    [self.view addSubview:calendar];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - ASNCalendarDelegate

- (void)calendar:(ASNCalendar *)calendar didSelectedDay:(ASNDayView *)tappedDay
{
    NSLog(@"%@ Tapped!", tappedDay.date);
}

@end
