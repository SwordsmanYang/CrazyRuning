//
//  ViewController.m
//  哈哈哈
//
//  Created by ChangQing Yang on 2016/11/23.
//  Copyright © 2016年 ChangQing Yang. All rights reserved.
//

#import "ViewController.h"
#import <HealthKit/HealthKit.h>

@interface ViewController ()

@property (nonatomic, strong)HKHealthStore *healthStore;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
     self.healthStore = [[HKHealthStore alloc] init];
}

- (IBAction)crazyRuning:(UIButton *)sender {
    
    UIButton *btn = sender;
    btn.selected = YES;
    HKQuantityType *stepCountType = [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierStepCount];
    NSSet *writeDataTypes = [NSSet setWithObjects:stepCountType,  nil];
    
    [self.healthStore requestAuthorizationToShareTypes:writeDataTypes readTypes:writeDataTypes completion:^(BOOL success, NSError *error) {
        
        if (!success) {
            //失败了
            return;
        }
    }];
    
    //数据看类型为步数.
    HKQuantityType *quantityTypeIdentifier = [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierStepCount];
    
    //表示步数的数据单位的数量
    HKQuantity *quantity = [HKQuantity quantityWithUnit:[HKUnit countUnit] doubleValue:10000];
    
    //数量样本.
    HKQuantitySample *temperatureSample = [HKQuantitySample quantitySampleWithType:quantityTypeIdentifier quantity:quantity startDate:[NSDate date] endDate:[NSDate date] metadata:nil];
    
    //保存
    [self.healthStore saveObject:temperatureSample withCompletion:^(BOOL success, NSError *error) {
        if (success) {
            //保存成功
        }else {
            //保存失败
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
