//
//  ASNDayView.h
//  ASNCalendarDemo
//
//  Created by AsanoYuki on 2014/07/09.
//  Copyright (c) 2014年 AsanoYuki. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, ASNDayTense) {
    ASNDayTenseCurrentMonthDay = 0,
    ASNDayTensePreviousMonthDay,
    ASNDayTenseNextMonthDay
};

@class ASNDayView;

@protocol ASNDayViewDelegate
@required
- (void)didSelectedDay:(ASNDayView *)tappedDay;

@end

@interface ASNDayView : UIView

@property (nonatomic, strong) NSDate *date;
@property (nonatomic, assign) ASNDayTense tense;

@property (nonatomic, weak)id<ASNDayViewDelegate> delegate;

@end
