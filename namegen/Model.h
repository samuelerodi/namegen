//
//  Model.h
//  namegen
//
//  Created by Samuele Rodi on 10/16/15.
//  Copyright © 2015 Samuele Rodi. All rights reserved.
//

#import "SMCDict.h"

@interface BaseModel : NSObject 

@property NSString *firstName;
@property NSString *lastName;
@property (nonatomic) SMCDict *smcDict;

- (void)sayHello;
- (NSString *) generate;

@end