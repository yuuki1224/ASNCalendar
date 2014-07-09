//
//  ASNMonthView.h
//  ASNCalendarDemo
//
//  Created by AsanoYuki on 2014/07/09.
//  Copyright (c) 2014年 AsanoYuki. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASNDayView.h"

@class ASNMonthView;

@protocol ASNMonthViewDelegate
@required
- (void)month:(ASNMonthView *)month didSelectedDay:(ASNDayView *)tappedDay;

@end

@interface ASNMonthView : UIView <ASNDayViewDelegate>

@property (nonatomic, weak)id<ASNMonthViewDelegate> delegate;

@property (nonatomic, strong) NSDateComponents *monthComponents;

@end
