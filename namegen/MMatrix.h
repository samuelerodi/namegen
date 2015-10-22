//
//  MMatrix.h
//  namegen
//
//  Created by Samuele Rodi on 10/21/15.
//  Copyright © 2015 Samuele Rodi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MMatrix : NSObject

@property (nonatomic, strong) NSMutableArray* matrix;
@property (nonatomic) long dim;
@property (nonatomic, strong) NSArray* size;
@property (nonatomic) long len;
@property (nonatomic, strong) NSArray* step;


- (void) initWithSize: (NSArray*) sz;
- (void) initWithSize: (NSArray*) sz AndValue: (NSNumber*) val;
- (id) getValuesAtIndex: (NSArray  *) idx;
- (BOOL) setValue: (NSNumber *) val atIndex: (NSArray  *) idx;
- (BOOL) addValue: (NSNumber *) val atIndex: (NSArray  *) idx;
- (BOOL) mulValue: (NSNumber *) val atIndex: (NSArray  *) idx;
- (BOOL) divValue: (NSNumber *) val atIndex: (NSArray  *) idx;
- (NSArray *) getIndexofElement: (long) number;

@end
