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
    [self signalSwitch];
}

- (void)signalSwitch {
    RACSubject *google = [RACSubject subject];
    RACSubject *baidu = [RACSubject subject];
    RACSubject *signalOfSignal = [RACSubject subject];
    
    RACSignal *switchSignal = [signalOfSignal switchToLatest];
    
    [[switchSignal map:^id _Nullable(id  _Nullable value) {
        return [NSString stringWithFormat:@"https://www.%@.com",value];
    }] subscribeNext:^(id  _Nullable x) {
        NSLog(@"%@",x);
    }];
    
    [signalOfSignal sendNext:baidu];
    [baidu sendNext:@"baidu"];
    [google sendNext:@"google"];
    NSLog(@"--------seperator line--------");
    [signalOfSignal sendNext:google];
    [baidu sendNext:@"baidu"];
    [google sendNext:@"google"];
}

- (void)uppercaseString {
    //    RACSequence *sequence = [@[@"you", @"are", @"beautiful"] rac_sequence];
    //    RACSignal *signal =  sequence.signal;
    //    RACSignal *capitalizedSignal = [signal map:^id(NSString * value) {
    //        return [value capitalizedString];
    //        }];
    //    [signal subscribeNext:^(NSString * x) {
    //        NSLog(@"signal --- %@", x);
    //        }];
    //    [capitalizedSignal subscribeNext:^(NSString * x) {
    //        NSLog(@"capitalizedSignal --- %@", x);
    //        }];
    
    [[[@[@"you", @"are", @"beautiful"] rac_sequence].signal
      map:^id(NSString * value) {
          NSLog(@"signal --- %@", value);
          return [value capitalizedString];
      }] subscribeNext:^(id x) {
          NSLog(@"capitalizedSignal --- %@", x);
      }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
