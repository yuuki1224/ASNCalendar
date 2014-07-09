//
//  ASNCalendar.h
//  ASNCalendarDemo
//
//  Created by AsanoYuki on 2014/07/09.
//  Copyright (c) 2014年 AsanoYuki. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASNMonthView.h"

@class ASNCalendar, ASNDayView;

@protocol ASNCalendarDelegate
@optional
- (void)calendar:(ASNCalendar *)calendar didSelectedDay:(ASNDayView *)tappedDay;

@end

@interface ASNCalendar : UIView <UIScrollViewDelegate, ASNMonthViewDelegate>

@property (nonatomic, weak)id<ASNCalendarDelegate> delegate;

@end
