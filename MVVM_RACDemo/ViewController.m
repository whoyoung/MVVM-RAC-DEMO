//
//  ViewController.m
//  MVVM_RACDemo
//
//  Created by 杨虎 on 2018/4/17.
//  Copyright © 2018年 杨虎. All rights reserved.
//

#import "ViewController.h"
#import <ReactiveObjC/ReactiveObjC.h>
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    RACSequence *sequence = [@[@"you", @"are", @"beautiful"] rac_sequence];
    RACSignal *signal =  sequence.signal;
    RACSignal *capitalizedSignal = [signal map:^id(NSString * value) {
        return [value capitalizedString];
        }];
    [signal subscribeNext:^(NSString * x) {
        NSLog(@"signal --- %@", x);
        }];
    [capitalizedSignal subscribeNext:^(NSString * x) {
        NSLog(@"capitalizedSignal --- %@", x);
        }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
