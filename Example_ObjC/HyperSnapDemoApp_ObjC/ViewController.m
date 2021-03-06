//
//  ViewController.m
//  HyperSnapDemoApp_ObjC
//
//  Created by Srinija on 12/07/18.
//  Copyright © 2018 hyperverge. All rights reserved.
//

#import "ViewController.h"
@import HyperSnapSDK;


@interface ViewController ()
@property (weak, nonatomic) IBOutlet UILabel *resultLabel;

@end

@implementation ViewController


NSString* appId = @"";
NSString* appKey = @"";


- (void)viewDidLoad {
    [super viewDidLoad];
    //Initializes the SDK. Please set the 'appId' and 'appKey' provided by HyperVerge
    [HyperSnapSDKConfig initializeWithAppId:appId appKey:appKey region:RegionAsiaPacific];

}


- (IBAction)faceCaptureTapped:(UIButton *)sender {
    
    
        HVFaceConfig *faceConfig = [HVFaceConfig new];
    
        [HVFaceViewController start:self hvFaceConfig:faceConfig completionHandler:^(HVError* error,NSDictionary<NSString *,id> * _Nonnull result, NSDictionary<NSString *,NSString *> * _Nonnull headers,UIViewController* vcNew){
            if(error != nil){
                NSLog(@"Error Received: %@",  error.getErrorMessage);
            }else{
                NSLog(@"Results: %@", result);
            }
            [vcNew dismissViewControllerAnimated:true  completion:nil];
    
        }];
}


- (IBAction)documentCaptureTapped:(UIButton *)sender {
    HVDocConfig *docConfig = [HVDocConfig new];
    [docConfig setDocumentType:DocumentTypeCard];
    
    [HVDocsViewController start:self hvDocConfig:docConfig completionHandler:^(HVError* error,NSDictionary<NSString *,id> * _Nonnull result, UIViewController* vcNew){
        if(error != nil){
            NSLog(@"Error Received: %@",  error);
        }else{
            NSLog(@"Results: %@", result);
        }
        [vcNew dismissViewControllerAnimated:true  completion:nil];
        
    }];
}

//- (void)makeOCRAPICall:(NSString *)imageUri{
//
//    [HVNetworkHelper makeOCRCallWithEndpoint:@"https://apac-docs.hyperverge.co/v1.1/readNID" documentUri:imageUri parameters:NULL headers:NULL completionHandler:^(HVError* error,NSDictionary<NSString *,id> * _Nonnull result,NSDictionary<NSString *,id> * _Nonnull headers){
//        if(error != nil){
//            NSLog(@"Error Received: %@",  error.getErrorMessage);
//        }else{
//            NSLog(@"Results: %@", result);
//        }
//
//    }];
//}
//
//
//- (void)makeFacematchAPICall:(NSString *)imageUri{
//
//    [HVNetworkHelper makeFaceMatchCallWithEndpoint:@"https://apac-faceid.hyperverge.co/v1/photo/verifyPair" faceUri:imageUri documentUri:imageUri parameters:NULL headers:NULL completionHandler:^(HVError* error,NSDictionary<NSString *,id> * _Nonnull result,NSDictionary<NSString *,id> * _Nonnull headers){
//        if(error != nil){
//            NSLog(@"Error Received: %@",  error.getErrorMessage);
//        }else{
//            NSLog(@"Results: %@", result);
//        }
//
//    }];
//}

@end
