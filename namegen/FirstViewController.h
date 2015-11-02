//
//  FirstViewController.h
//  namegen
//
//  Created by Samuele Rodi on 10/16/15.
//  Copyright © 2015 Samuele Rodi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Model.h"
@interface FirstViewController : UIViewController
@property (nonatomic) BaseModel * model;


- (IBAction)generateRN:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UILabel *displayResult;




@end

