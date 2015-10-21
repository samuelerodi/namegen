//
//  MMatrix.h
//  namegen
//
//  Created by Samuele Rodi on 10/21/15.
//  Copyright © 2015 Samuele Rodi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MMatrix : NSObject

@property (nonatomic, weak) NSMutableArray* matrix;
@property (nonatomic) long dim;
@property (nonatomic, weak) NSArray* size;

- (void) initWithSize: (NSArray*) sz AndValue: (NSNumber*) val;
- (NSNumber *) getValueAtIndex: (NSArray  *) idx;
- (BOOL) setValue: (NSNumber *) val atIndex: (NSArray  *) idx;


@end
