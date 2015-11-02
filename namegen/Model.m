//
//  Model.m
//  namegen
//
//  Created by Samuele Rodi on 10/16/15.
//  Copyright © 2015 Samuele Rodi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Accelerate/Accelerate.h>
#import "Model.h"

@import Accelerate;



@implementation BaseModel

- (void)sayHello {
    
    NSString* path=@"engDict";
    
    
    [self loadDictionary];
    if (self.smcDict==nil) {
        SMCDict* trial = [[SMCDict alloc] init];
        [trial createDictTableFromDict:path];
        self.smcDict=trial;
        [self saveDictionary];
    }
    

    

    
    float test;
    test=[self.smcDict.smcTable sumOfElementsAtIndex:@[@-1, @3, @4]];
    [self.smcDict.smcFinals printMatrixAtIndex:@[@-1]];
    test=[self.smcDict.smcInitials sumOfElementsAtIndex:@[@-1]];
    test=[self.smcDict.smcFinals sumOfElementsAtIndex:@[@-1]];
    [self.smcDict.smcTable printMatrixAtIndex:@[@-1, @4, @2]];
    
    
    NSString *testname = [self.smcDict randomGeneratedName];
    
    
    for (int ii=0; ii<20; ii++) {
        testname = [self.smcDict randomGeneratedName];
        NSLog(@"%@", testname);
    }
    NSLog(@"\nAverage Length: %f" , self.smcDict.smcAvgLength);
    
    return;
}

- (NSString *) generate {
 return [self.smcDict randomGeneratedName];
}


#pragma  mark Storing Procedures

- (void) saveDictionary {
    if (self.smcDict != nil) {
        NSData *archivedData = [NSKeyedArchiver archivedDataWithRootObject:self.smcDict];
        [[NSUserDefaults standardUserDefaults] setObject:archivedData forKey:@"smcDict"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }

}

- (void)loadDictionary {
    NSData *archivedData = [[NSUserDefaults standardUserDefaults] objectForKey:@"smcDict"];
    self.smcDict = [NSKeyedUnarchiver unarchiveObjectWithData:archivedData];
}




@end