//
//  SMCDict.h
//  namegen
//
//  Created by Samuele Rodi on 10/19/15.
//  Copyright © 2015 Samuele Rodi. All rights reserved.
//



@interface SMCDict : NSObject
@property (nonatomic) float matrix;

- (void) createDictTableFromDict: (NSString*) dict;
- (NSArray*) openDictionary: (NSString*) dict;
@end