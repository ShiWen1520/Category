//
//  ResponderView.m
//  Category
//
//  Created by ZSW on 2020/3/19.
//  Copyright © 2020 ZSW. All rights reserved.
//

#import "ResponderView.h"
#import "UIResponder+router.h"

@interface ResponderView ()

@property (weak, nonatomic) IBOutlet UIButton *buttonA;
@property (weak, nonatomic) IBOutlet UIButton *buttonB;

@end

@implementation ResponderView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (void)awakeFromNib {
    [super awakeFromNib];
}

- (IBAction)buttonA:(id)sender {
    
    [_buttonB setTitle:[NSString stringWithFormat:@"%u", arc4random() % 10000] forState:UIControlStateNormal];
    
    [self routerEventWithName:@"buttonA" userInfo:nil];
}
- (IBAction)buttonB:(id)sender {
    [self routerEventWithName:@"buttonB" userInfo:nil];
}

@end
