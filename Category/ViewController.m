//
//  ViewController.m
//  Category
//
//  Created by ZSW on 2020/3/19.
//  Copyright © 2020 ZSW. All rights reserved.
//

#import "ViewController.h"
#import "UIResponder+router.h"
#import "UIButton+EnlargeTouchArea.h"
#import "ResponderView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    ResponderView *view = [[NSBundle mainBundle] loadNibNamed:@"ResponderView" owner:nil options:nil].firstObject;
    view.frame = CGRectMake(0, 0, self.view.frame.size.width, 300);
    [self.view addSubview:view];
    
    UIButton *button = [UIButton new];
    button.frame = CGRectMake(50, 350, 100, 44);
    [button setTitle:@"扩大响应范围" forState:UIControlStateNormal];
    button.backgroundColor = [UIColor redColor];
    [button addTarget:self action:@selector(enlarge) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    [button setEnlargeEdgeWithTop:30 right:30 bottom:30 left:30];
}

#pragma mark -"UIResponder+router.h"
- (void)routerEventWithName:(NSString *)eventName userInfo:(NSDictionary *)userInfo {
    if ([eventName isEqualToString:@"buttonA"]) {
        NSLog(@"buttonA的方法");
    }else if ([eventName isEqualToString:@"buttonB"]) {
        NSLog(@"buttonB的方法");
    }
}

- (void)enlarge {
    NSLog(@"扩大响应范围");
}


@end
