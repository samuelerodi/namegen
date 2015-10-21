//
//  MMatrix.m
//  namegen
//
//  Created by Samuele Rodi on 10/21/15.
//  Copyright © 2015 Samuele Rodi. All rights reserved.
//

#import "MMatrix.h"

@implementation MMatrix

- (void) initWithSize: (NSArray*) sz AndValue: (NSNumber*) val {
    
    long dim=[sz count];
    long len=1;
    long d=0;
    NSMutableArray* cDim=[[NSMutableArray alloc] init];
    for (long ii=0; ii<dim; ii++) {
        if ([sz[ii] isKindOfClass:[NSNumber class]]) {
            d=[sz[ii] longValue];
            
            if (d<=0) {
                NSException *e = [NSException
                                  exceptionWithName:NSInvalidArgumentException
                                  reason:@"MMatrix: Matrix cannot be initialized with null or negative indexes"
                                  userInfo:nil];
                @throw e;
                return;
                
            }
            len=len * d;
            [cDim setObject:[NSNumber numberWithLong:d] atIndexedSubscript:ii];
        } else {
            NSException *e = [NSException
                              exceptionWithName:NSInvalidArgumentException
                              reason:@"MMatrix: incompatible data type to initialize matrix"
                              userInfo:nil];
            @throw e;
            return;
        }

    }
    
    NSMutableArray *temp=[[NSMutableArray alloc] initWithCapacity:len];
    
    for (long ii=0; ii<len; ii++) {
        [temp setObject: val atIndexedSubscript:ii];
    }

    self.matrix=temp;
    self.dim=(long)[cDim count];
    self.size=cDim;

//    NSNumber* n=[self getValueAtIndex:@[@0, @1, @0]];
//    [self setValue:@3 atIndex: @[@0, @1, @1]];
//    n=[self getValueAtIndex:@[@0, @1, @0]];
    
    
    return;
    
}

- (NSNumber *) getValueAtIndex: (NSArray  *) idx {
    long dim=[idx count];
    if (dim!=self.dim) {
        NSException *e = [NSException
                          exceptionWithName:NSRangeException
                          reason:@"MMatrix: Matrix does match input dimensions during get operation"
                          userInfo:nil];
        @throw e;
        return nil;
    }
    
    for (long ii=0; ii<dim; ii++) {
        if (![idx[ii] isKindOfClass:[NSNumber class]]) {
            NSException *e = [NSException
                              exceptionWithName:NSInvalidArgumentException
                              reason:@"MMatrix: incompatible data type as index during get operation"
                              userInfo:nil];
            @throw e;
            return nil;
        } else if ([idx[ii] longValue]>=[self.size[ii] longValue] || [idx[ii] longValue]<0){
            NSException *e = [NSException
                              exceptionWithName:NSRangeException
                              reason:@"MMatrix: index exceeds matrix dimensions during get operation"
                              userInfo:nil];
            @throw e;
            return nil;
        }
        
    }
    long indext=0;
    long accumulated=1;
    for (long ii=0; ii<self.dim; ii++) {
        indext=indext + [idx [ii] longValue] * accumulated;
        accumulated=accumulated * [self.size [ii] longValue];
    }
    
    return [self.matrix objectAtIndex:indext];
}


- (BOOL) setValue: (NSNumber *) val atIndex: (NSArray  *) idx  {
    long dim=[idx count];
    if (dim!=self.dim) {
        NSException *e = [NSException
                          exceptionWithName:NSRangeException
                          reason:@"MMatrix: Matrix does match input dimensions during set operation"
                          userInfo:nil];
        @throw e;
        return nil;
    }
    
    for (long ii=0; ii<dim; ii++) {
        if (![idx[ii] isKindOfClass:[NSNumber class]]) {
            NSException *e = [NSException
                              exceptionWithName:NSInvalidArgumentException
                              reason:@"MMatrix: incompatible data type as index during set operation"
                              userInfo:nil];
            @throw e;
            return FALSE;
        } else if ([idx[ii] longValue]>=[self.size[ii] longValue] || [idx[ii] longValue]<0){
            NSException *e = [NSException
                              exceptionWithName:NSRangeException
                              reason:@"MMatrix: index exceeds matrix dimensions during set operation"
                              userInfo:nil];
            @throw e;
            return FALSE;
        }
        
    }
    long indext=0;
    long accumulated=1;
    for (long ii=0; ii<self.dim; ii++) {
        indext=indext + [idx [ii] longValue] * accumulated;
        accumulated=accumulated * [self.size [ii] longValue];
    }
    
    [self.matrix setObject:val atIndexedSubscript:indext];
    return TRUE;
}



- (NSNumber *) sumOverIndex: (int) idx {
    
    
    return @3;
}

@end
