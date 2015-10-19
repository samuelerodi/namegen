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
    SMCDict* trial = [[SMCDict alloc] init];
    [trial createDictTableFromDict:path];
    return;
}
@end