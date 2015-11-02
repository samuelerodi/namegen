//
//  SMCDict.h
//  namegen
//
//  Created by Samuele Rodi on 10/19/15.
//  Copyright © 2015 Samuele Rodi. All rights reserved.
//

#import "MMatrix.h"

@interface SMCDict : NSObject <NSCoding>

@property (nonatomic) NSArray *alphabet;
@property (nonatomic) long alphaCount;
@property (nonatomic) MMatrix *smcTable;
@property (nonatomic) MMatrix *smcInitials;
@property (nonatomic) MMatrix *smcFinals;
@property (nonatomic) float smcAvgLength;
@property (nonatomic) float smcLenStDev;

- (void) createDictTableFromDict: (NSString*) dict;
- (NSArray*) openDictionary: (NSString*) dict;
- (NSString *) randomGeneratedName;
@end