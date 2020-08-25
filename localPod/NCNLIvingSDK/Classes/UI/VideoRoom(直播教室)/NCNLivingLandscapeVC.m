//
//  NCNLivingLandspaceVC.m
//  XYClassRoom
//
//  Created by 尹彦博 on 2020/4/23.
//  Copyright © 2020 newcloudnet. All rights reserved.
//

#import "NCNLivingLandscapeVC.h"

@interface NCNLivingLandscapeVC ()

@end

@implementation NCNLivingLandscapeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}


- (BOOL)shouldAutorotate {
    
    return false;
    
}
- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    
    
    return UIInterfaceOrientationLandscapeRight;
    
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    
    return UIInterfaceOrientationMaskLandscapeRight;
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
