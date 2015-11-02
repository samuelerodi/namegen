//
//  MMatrix.h
//  namegen
//
//  Created by Samuele Rodi on 10/21/15.
//  Copyright © 2015 Samuele Rodi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MMatrix : NSObject <NSCoding>

@property (nonatomic, strong) NSMutableArray* matrix;
@property (nonatomic) long dim;
@property (nonatomic, strong) NSArray* size;
@property (nonatomic) long len;
@property (nonatomic, strong) NSArray* step;

////Initialization
- (void) initWithSize: (NSArray*) sz;
- (void) initWithSize: (NSArray*) sz AndValue: (NSNumber*) val;

////Getter and Setter
- (id) getValuesAtIndex: (NSArray  *) idx;
- (BOOL) setValue: (NSNumber *) val atIndex: (NSArray  *) idx;

////Basic Math Operation
- (BOOL) addValue: (NSNumber *) val;
- (BOOL) addValue: (NSNumber *) val atIndex: (NSArray  *) idx;
- (BOOL) mulByValue: (NSNumber *) val;
- (BOOL) mulByValue: (NSNumber *) val atIndex: (NSArray  *) idx;
- (BOOL) divByValue: (NSNumber *) val;
- (BOOL) divByValue: (NSNumber *) val atIndex: (NSArray  *) idx;

- (float) sumOfElements;
- (float) sumOfElementsAtIndex: (NSArray  *) idx;

////Matrix Operations
- (float) vecDotProductWithMatrix: (MMatrix *) m;
- (void) dotSumWithMatrix: (MMatrix *) m;
- (void) dotMulWithMatrix: (MMatrix *) m;
- (void) dotDivByMatrix: (MMatrix *) m;
- (MMatrix *) dotSumMatrixA: (MMatrix *) m1 withMatrixB:(MMatrix *) m2;
- (MMatrix *) dotMulMatrixA: (MMatrix *) m1 withMatrixB:(MMatrix *) m2;
- (MMatrix *) dotDivMatrixA: (MMatrix *) m1 byMatrixB:(MMatrix *) m2;

////Tools
- (NSArray *) getIndexofElement: (long) number;
- (void) printMatrixAtIndex:(NSArray  *) idx;



@end
