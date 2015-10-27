//
//  MMatrix.m
//  namegen
//
//  Created by Samuele Rodi on 10/21/15.
//  Copyright © 2015 Samuele Rodi. All rights reserved.
//

#import "MMatrix.h"


@implementation MMatrix

////Initialization
- (void) initWithSize: (NSArray*) sz {
    
    long dim=[sz count];
    long len=1;
    long d=0;
    NSMutableArray* cDim=[[NSMutableArray alloc] init];
    NSMutableArray* step=[[NSMutableArray alloc] init];
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
            [step setObject:[NSNumber numberWithLong:len] atIndexedSubscript:ii];
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
    self.dim=(long)[cDim count];
    self.size=[NSArray arrayWithArray:cDim];
    self.step=[NSArray arrayWithArray: step];
    self.len=len;
    
    return;
}

- (void) initWithSize: (NSArray*) sz AndValue: (NSNumber*) val {
    
    [self initWithSize:sz];
    NSMutableArray *temp=[[NSMutableArray alloc] initWithCapacity:self.len];
    for (long ii=0; ii<self.len; ii++) {
        [temp setObject: val atIndexedSubscript:ii];
    }
    self.matrix=[NSMutableArray arrayWithArray:temp];
    
    return;
    
}

////Getter and Setter
- (id) getValuesAtIndex: (NSArray  *) idx {
    NSArray* indexList=[self selectElementUsingIndex: idx];
    NSMutableArray* sz=[[NSMutableArray alloc] init];

    if ([indexList count]==1) {
        return [self.matrix objectAtIndex:[indexList[0] integerValue]];
    }
    for (int ii=0; ii<[idx count]; ii++) {
        if ([[idx objectAtIndex:ii] integerValue] ==-1){
            [sz addObject:[self.size objectAtIndex:ii]];
        }
    }

    return [self getObjectsforList:indexList withSize:sz];
}


- (BOOL) setValue: (NSNumber *) val atIndex: (NSArray  *) idx  {
    NSArray* indexList=[self selectElementUsingIndex: idx];
    [self setObject:val forList:indexList];
    return TRUE;
}


////Basic Math Operation
- (BOOL) addValue: (NSNumber *) val atIndex: (NSArray  *) idx  {
    NSArray* indexList=[self selectElementUsingIndex: idx];
    [self addValue: val forList:indexList];
    return TRUE;
}

- (BOOL) mulByValue: (NSNumber *) val atIndex: (NSArray  *) idx  {
    NSArray* indexList=[self selectElementUsingIndex: idx];
    [self mulValue: val forList:indexList];
    return TRUE;
}

- (BOOL) divByValue: (NSNumber *) val atIndex: (NSArray  *) idx  {
    float temp=1/[val floatValue];
    NSNumber* input=[NSNumber numberWithFloat:temp];
    NSArray* indexList=[self selectElementUsingIndex: idx];
    [self mulValue: input forList:indexList];
    return TRUE;
}


- (BOOL) addValue: (NSNumber *) val  {
    NSArray* indexList=[[NSArray alloc] init];
    [self addValue: val forList:indexList];
    return TRUE;
}

- (BOOL) mulByValue: (NSNumber *) val {
    NSArray* indexList=[[NSArray alloc] init];
    [self mulValue: val forList:indexList];
    return TRUE;
}

- (BOOL) divByValue: (NSNumber *) val  {
    float temp=1/[val floatValue];
    NSNumber* input=[NSNumber numberWithFloat:temp];
    NSArray* indexList=[[NSArray alloc] init];
    [self mulValue: input forList:indexList];
    return TRUE;
}


- (float) sumOfElements {
    NSArray* indexList=[[NSArray alloc] init];
    return  [self sumElementsInList:indexList];
}

- (float) sumOfElementsAtIndex: (NSArray  *) idx  {
    NSArray* indexList=[self selectElementUsingIndex: idx];
    return  [self sumElementsInList:indexList];
}



////Matrix Operations
- (float) vecDotProductWithMatrix: (MMatrix *) m {
    [self checkMatrixDimensions:self with:m ];
    float result=0;
    for (long ii=0; ii<self.len; ii++) {
        result+=([[self.matrix objectAtIndex:ii]floatValue]*
                 [[m.matrix objectAtIndex:ii]floatValue]);
    }
    return result;
}



- (void) dotSumWithMatrix: (MMatrix *) m {
    [self checkMatrixDimensions:self with:m ];
    float result;
    for (long ii=0; ii<self.len; ii++) {
        result=[[self.matrix objectAtIndex:ii]floatValue]+[[m.matrix objectAtIndex:ii]floatValue];
        [self.matrix setObject:[NSNumber numberWithFloat:result] atIndexedSubscript:ii];
    }
    return;
}

- (void) dotMulWithMatrix: (MMatrix *) m {
    [self checkMatrixDimensions:self with:m ];
    float result;
    for (long ii=0; ii<self.len; ii++) {
        result=[[self.matrix objectAtIndex:ii]floatValue]*[[m.matrix objectAtIndex:ii]floatValue];
        [self.matrix setObject:[NSNumber numberWithFloat:result] atIndexedSubscript:ii];
    }
    return;
}

- (void) dotDivByMatrix: (MMatrix *) m {
    [self checkMatrixDimensions:self with:m ];
    float result;
    for (long ii=0; ii<self.len; ii++) {
        result=[[self.matrix objectAtIndex:ii]floatValue]/[[m.matrix objectAtIndex:ii]floatValue];
        [self.matrix setObject:[NSNumber numberWithFloat:result] atIndexedSubscript:ii];
    }
    return;
}


- (MMatrix *) dotSumMatrixA: (MMatrix *) m1 withMatrixB:(MMatrix *) m2 {
    [self checkMatrixDimensions:m1 with:m2 ];
    MMatrix *mout=[MMatrix alloc];
    [mout initWithSize:m1.size];
    mout.matrix= [[NSMutableArray alloc] initWithCapacity:m1.len];
    float result;
    for (long ii=0; ii<m1.len; ii++) {
        result=[[m1.matrix objectAtIndex:ii]floatValue]+[[m2.matrix objectAtIndex:ii]floatValue];
        [mout.matrix addObject:[NSNumber numberWithFloat:result]];
    }
    return mout;
}

- (MMatrix *) dotMulMatrixA: (MMatrix *) m1 withMatrixB:(MMatrix *) m2{
    [self checkMatrixDimensions:m1 with:m2 ];
    MMatrix *mout=[MMatrix alloc];
    [mout initWithSize:m1.size];
    mout.matrix= [[NSMutableArray alloc] initWithCapacity:m1.len];
    float result;
    for (long ii=0; ii<m1.len; ii++) {
        result=[[m1.matrix objectAtIndex:ii]floatValue]*[[m2.matrix objectAtIndex:ii]floatValue];
        [mout.matrix setObject:[NSNumber numberWithFloat:result] atIndexedSubscript:ii];
    }
    return mout;
}

- (MMatrix *) dotDivMatrixA: (MMatrix *) m1 byMatrixB:(MMatrix *) m2{
    [self checkMatrixDimensions:m1 with:m2 ];
    MMatrix *mout=[MMatrix alloc];
    [mout initWithSize:m1.size];
    mout.matrix= [[NSMutableArray alloc] initWithCapacity:m1.len];    
    float result;
    for (long ii=0; ii<m1.len; ii++) {
        result=[[m1.matrix objectAtIndex:ii]floatValue]/[[m2.matrix objectAtIndex:ii]floatValue];
        [mout.matrix setObject:[NSNumber numberWithFloat:result] atIndexedSubscript:ii];
    }
    return mout;
}

- (void) printMatrixAtIndex:(NSArray  *) idx  {
    NSArray* indexList=[self selectElementUsingIndex: idx];
    NSLog(@"\nMatrix at selected index:\n\n");
    float number;
    for (long ii=0; ii<[indexList count]; ii++) {
        number=[[self.matrix objectAtIndex:[[indexList objectAtIndex:ii] longValue]] floatValue];
        printf("%f\t", number);
    }
    return;
}



////Tools
- (NSArray *) getIndexofElement: (long) number {
    NSArray *outv;
    NSMutableArray *index=[[NSMutableArray alloc] initWithCapacity: self.dim];
    for (int ii=0; ii<self.dim; ii++) {
        [index setObject:[NSNumber numberWithLong:0] atIndexedSubscript:ii];
    }
    if (number>=self.len || number < 0) {
        NSException *e = [NSException
                          exceptionWithName:NSRangeException
                          reason:@"MMatrix: index exceeds matrix dimensions during getIndexOfElement"
                          userInfo:nil];
        @throw e;
    }
    long idx, division, modulo;
    long residual=number;
    
    for (long ii=0; ii<self.dim; ii++) {
        idx=self.dim-ii-1;
        division=residual / [self.step[idx] longValue];
        modulo=residual % [self.step[idx] longValue];
        residual=modulo;
        [index setObject:[NSNumber numberWithLong:division] atIndexedSubscript:idx];
    }
    
    outv=index;
    return outv;
}

//PRIVATE METHOD


- (NSArray *) selectElementUsingIndex: (NSArray *) idx {
    long dim=[idx count];
    long multi= 1;
    NSMutableArray *indexList=[[NSMutableArray alloc] init];
    NSMutableArray *span=[[NSMutableArray alloc] init];
    
    
    if (dim!=self.dim) {
        NSException *e = [NSException
                          exceptionWithName:NSRangeException
                          reason:@"MMatrix: Matrix does match input dimensions in selectElementUsingIndex"
                          userInfo:nil];
        @throw e;
        return nil;
    }
    
    for (long ii=0; ii<dim; ii++) {
        if (![idx[ii] isKindOfClass:[NSNumber class]]) {
            NSException *e = [NSException
                              exceptionWithName:NSInvalidArgumentException
                              reason:@"MMatrix: incompatible data type as index in selectElementUsingIndex"
                              userInfo:nil];
            @throw e;
            return nil;
        } else if ([idx[ii] longValue]>=[self.size[ii] longValue] ||
                   ([idx[ii] longValue]<0 && [idx[ii] longValue]!=-1)){
            NSException *e = [NSException
                              exceptionWithName:NSRangeException
                              reason:@"MMatrix: index exceeds matrix dimension in selectElementUsingIndex"
                              userInfo:nil];
            @throw e;
            return nil;
        } else if ([idx [ii] longValue]==-1){

            multi=multi * [self.size [ii] longValue];
            [span addObject:[NSNumber numberWithLong:ii]];
        
        }
        
    }
    
    
    NSMutableArray *temp= [NSMutableArray arrayWithArray: idx];
    NSMutableArray *subidx;
    
    if ([span count]==self.dim) {
        return indexList;
    }
    
    for (long ii=0; ii<multi; ii++) {
        subidx=[NSMutableArray arrayWithArray:[self getSubIndexofElement:ii withSpan:span]];
        for (int nn=0; nn<[span count]; nn++) {
            [temp setObject:[subidx objectAtIndex: nn] atIndexedSubscript:[[span objectAtIndex:nn] integerValue]];
        }
        
        [indexList addObject:[self vecMulv1:temp v2:self.step]];
    }
    
    return indexList;
}

- (NSArray *) getSubIndexofElement: (long) number withSpan: (NSArray *)span{

    long dim=[span count];
    long  newSize [dim];
    long step [dim];
    long len=1;
    
    long idx;
    long division;
    long modulo;
    long residual=number;
    NSMutableArray *index=[[NSMutableArray alloc] initWithCapacity: dim];
    
    for (int ii=0; ii<dim; ii++) {
        newSize[ii]=[[self.size objectAtIndex:[span[ii] longValue]] longValue];
        [index setObject:[NSNumber numberWithLong:0] atIndexedSubscript:ii];
        step[ii]=len;
        len=len*newSize[ii];
    }
    
    
    if (number>=len || number < 0) {
        NSException *e = [NSException
                          exceptionWithName:NSRangeException
                          reason:@"MMatrix: index exceeds matrix dimensions during getIndexOfElement"
                          userInfo:nil];
        @throw e;
    }
    

    for (long ii=0; ii<dim; ii++) {
        idx=dim-ii-1;
        division=residual / step[idx];
        modulo=residual % step[idx];
        residual=modulo;
        [index setObject:[NSNumber numberWithLong:division] atIndexedSubscript:idx];
    }
    
    return index;
}

- (void) checkMatrixDimensions: (MMatrix *) m1 with: (MMatrix *) m2 {
    if (m1.dim!=m2.dim) {
        NSException *e = [NSException
                          exceptionWithName:NSRangeException
                          reason:@"MMatrix: Matrix dimensions does not match in dotMulMatrixA withMatrixB"
                          userInfo:nil];
        @throw e;
        return;
    }
    for (int ii=0; ii<m1.dim; ii++) {
        if ([[m1.size objectAtIndex:ii] longValue]!=[[m2.size objectAtIndex:ii] longValue]) {
            NSException *e = [NSException
                              exceptionWithName:NSRangeException
                              reason:@"MMatrix: Matrixes have different size in dotMulMatrixA withMatrixB"
                              userInfo:nil];
            @throw e;
            return;
        }
    }
    return;
}


- (void) mulValue: (NSNumber *) val forList:(NSArray *) list {
    float temp;
    if ([list count]==0) {
        for (long ii=0; ii<self.len; ii++) {
            temp=[[self.matrix objectAtIndex:ii] floatValue]*[val floatValue];
            [self.matrix setObject:[NSNumber numberWithFloat:temp] atIndexedSubscript:ii];
        }
    } else {
        for(NSNumber *element in list){
            temp=[[self.matrix objectAtIndex:[element longValue]] floatValue]*[val floatValue];
            [self.matrix setObject:[NSNumber numberWithFloat:temp]
                atIndexedSubscript:[element longValue]];
        }
    }
    return;
}



- (void) addValue: (NSNumber *) val forList:(NSArray *) list {
    float temp;
    if ([list count]==0) {
        for (long ii=0; ii<self.len; ii++) {
            temp=[[self.matrix objectAtIndex:ii] floatValue] +[val floatValue];
            [self.matrix setObject:[NSNumber numberWithFloat:temp] atIndexedSubscript:ii];
        }
    } else {
        for(NSNumber *element in list){
            temp=[[self.matrix objectAtIndex:[element longValue]] floatValue] +[val floatValue];
            [self.matrix setObject:[NSNumber numberWithFloat:temp]
                atIndexedSubscript:[element longValue]];
        }
    }
    return;
}

- (float) sumElementsInList:(NSArray *) list {
    float temp=0;
    if ([list count]==0) {
        for (NSNumber *element in self.matrix) {
            temp+=[element floatValue];
        }
    } else {
        for(NSNumber *element in list){
            temp+=[[self.matrix objectAtIndex:[element longValue]] floatValue];
        }
    }
    return temp;
}



- (NSNumber *) vecMulv1:(NSArray *) array1 v2: (NSArray *) array2 {
    float result=0;
    for (int ii=0; ii<[array1 count]; ii++) {
        result=result+ [array1[ii] floatValue] * [array2[ii] floatValue];
    }
    
    return [NSNumber numberWithFloat:result];
}

- (void) setObject: (NSNumber *) val forList:(NSArray *) list {
    
    if ([list count]==0) {
        for (long ii=0; ii<self.len; ii++) {
            [self.matrix setObject:val atIndexedSubscript:ii];
        }
    } else {
        for(NSNumber *element in list){
            [self.matrix setObject:val atIndexedSubscript:[element longValue]];
        }
    }
    return;
}


- (MMatrix *) getObjectsforList:(NSArray *) list withSize:(NSArray *) sz{
    MMatrix *outM=[MMatrix alloc];
    NSMutableArray *temp=[[NSMutableArray alloc] init];
    
    if ([list count]==0) {
        temp=self.matrix;
    } else {
        for(NSNumber *element in list){
            [temp addObject:[self.matrix objectAtIndex:[element integerValue]]];
        }
    }
    [outM initWithSize:sz];
    [outM setMatrix:[NSMutableArray arrayWithArray: temp]];
    
    return outM;
}



@end
