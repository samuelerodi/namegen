//
//  SMCDict.m
//  namegen
//
//  Created by Samuele Rodi on 10/19/15.
//  Copyright © 2015 Samuele Rodi. All rights reserved.
//
#include <stdlib.h>
#import <Foundation/Foundation.h>
#import "SMCDict.h"


@implementation SMCDict

- (void) initWithAlphabet: (NSArray *) alphabet{
    if (alphabet==nil) {
        self.alphabet=[NSArray arrayWithObjects:@"a",@"b",@"c",@"d",@"e",@"f",@"g",@"h",@"i",
                           @"j",@"k",@"l",@"m",@"n",@"o",@"p",@"q",@"r",
                           @"s",@"t",@"u",@"v",@"w",@"x",@"y",@"z", nil];
    } else {
        self.alphabet=alphabet;
    }
    
    self.alphaCount=[self.alphabet count];
    NSNumber *n=[NSNumber numberWithLong:self.alphaCount];
    NSNumber *nd=[NSNumber numberWithLong:self.alphaCount+1];
    
    //Create 3D statistical table for letter probability and init at 0
    self.smcTable= [[MMatrix alloc] init];
    [self.smcTable initWithSize:@[n, n, nd] AndValue:@0];
    
    self.smcInitials= [[MMatrix alloc] init];
    [self.smcInitials initWithSize:@[n] AndValue:@0];
    
    self.smcFinals= [[MMatrix alloc] init];
    [self.smcFinals initWithSize:@[n] AndValue:@0];

    
    self.smcAvgLength=0;

    
}

- (NSArray*) openDictionary: (NSString*) dict {
    
    NSString* path = [[NSBundle mainBundle] pathForResource:dict
                                                     ofType:@"txt"];
        
    //pull the content from the file into memory
    NSData* data = [NSData dataWithContentsOfFile:path];
    //convert the bytes from the file into a string
    NSString* string = [[NSString alloc] initWithBytes:[data bytes]
                                                length:[data length]
                                                encoding:NSUTF8StringEncoding];
    
    //split the string around newline characters to create an array
    NSString* delimiter = @"\n";
    NSArray* items = [string componentsSeparatedByString:delimiter];

    return items;
}

- (void) createDictTableFromDict: (NSString*) dict {
    
    if (self.alphabet==nil) {
        [self initWithAlphabet:nil];
    }
    
    //Compute Statistical Relevance of the Dictionary passed
    NSArray* items=[self openDictionary:dict];
    long n_ItemsInDict=0;
    long str_len;
    char first, last, current, prev, pprev;

    NSNumber *idx, *cc, *rr, *hh;
    NSNumber *secIdx=[NSNumber numberWithLong:self.alphaCount];
    
    for (NSString *item in items) {
        str_len=[item length]-1;
        
        if (str_len>1) {
            n_ItemsInDict++;
            self.smcAvgLength+=str_len;

            first=[item characterAtIndex:0];
            idx=[NSNumber numberWithLong:[self findIndexInAlphabetOfChar:first]];
            [self.smcInitials addValue:@1 atIndex:@[idx]];
            
            last=[item characterAtIndex:str_len-1];
            idx=[NSNumber numberWithLong:[self findIndexInAlphabetOfChar:last]];
            [self.smcFinals addValue:@1 atIndex:@[idx]];
            
            for (int ii=1; ii<str_len; ii++) {
                current=[item characterAtIndex:ii];
                cc=[NSNumber numberWithLong:[self findIndexInAlphabetOfChar:current]];

                prev=[item characterAtIndex:ii-1];
                rr=[NSNumber numberWithLong:[self findIndexInAlphabetOfChar:prev]];
                
                if (ii>1) {
                    pprev=[item characterAtIndex:ii-2];
                    hh=[NSNumber numberWithLong:[self findIndexInAlphabetOfChar:pprev]];
                    [self.smcTable addValue:@1 atIndex:@[cc,rr,hh]];
                    
                } else {
                    [self.smcTable addValue:@1 atIndex:@[cc,rr,secIdx]];
                }
  
            }
            
        }
    }
    
    NSNumber *summ;
    for (int h=0; h<=[secIdx integerValue]; h++) {
        for (int r=0; r<self.alphaCount; r++) {
            rr=[NSNumber numberWithInt:r];
            hh=[NSNumber numberWithInt:h];
            summ=[NSNumber numberWithFloat:[self.smcTable sumOfElementsAtIndex:@[@-1, rr, hh]]];
            [self.smcTable divByValue:summ atIndex:@[@-1, rr, hh]];
        }
    }
    
    [self.smcInitials divByValue:[NSNumber numberWithLong:n_ItemsInDict]];
    [self.smcFinals   divByValue:[NSNumber numberWithLong:n_ItemsInDict]];
    self.smcAvgLength=self.smcAvgLength/n_ItemsInDict;
    
    
    
    float test;
    test=[self.smcTable sumOfElementsAtIndex:@[@-1, @3, @4]];
    [self.smcFinals printMatrixAtIndex:@[@-1]];
    test=[self.smcInitials sumOfElementsAtIndex:@[@-1]];
    test=[self.smcFinals sumOfElementsAtIndex:@[@-1]];
    [self.smcTable printMatrixAtIndex:@[@-1, @4, @2]];
    
    
    NSString *testname = [self randomGeneratedName];
    
    
    for (int ii=0; ii<20; ii++) {
        testname = [self randomGeneratedName];
        NSLog(@"%@", testname);
    }
    NSLog(@"\nAverage Length: %f" , self.smcAvgLength);

    
}

- (long) findIndexInAlphabetOfChar: (char) element{
    long idx;
    NSString *str=[NSString stringWithFormat:@"%c" , element];
    if([self.alphabet containsObject:str])
    {
        idx = [self.alphabet indexOfObject: str];
        return idx;
    } else {
        NSException *e = [NSException
                          exceptionWithName:NSRangeException
                          reason:@"SMCDict: character not found in alphabet during findIndexInAlphabetOfChar"
                          userInfo:nil];
        @throw e;
        
        return 0;
    }

}

- (NSString *) randomGeneratedName {
    NSMutableString *output=[[NSMutableString alloc] init];
    int len= arc4random_uniform((int) self.smcAvgLength)+2;
    MMatrix *buildVector=[[MMatrix alloc ] init];
    NSNumber *idx, *rr, *hh;
    NSNumber *secIdx=[NSNumber numberWithLong:self.alphaCount];
    char first, last, current, prev, pprev;
    float ran;
    
    for (int ii=0; ii<len; ii++) {
        ran = ((float)rand() / RAND_MAX);
        switch (ii) {
            case 0:
                buildVector=self.smcInitials;
                break;
            case 1:
                prev=[output characterAtIndex:ii-1];
                rr=[NSNumber numberWithLong:[self findIndexInAlphabetOfChar:prev]];
                buildVector=[self.smcTable getValuesAtIndex:@[@-1, rr ,secIdx]];
                break;
            default:
                pprev=[output characterAtIndex:ii-2];
                hh=[NSNumber numberWithLong:[self findIndexInAlphabetOfChar:pprev]];
                prev=[output characterAtIndex:ii-1];
                rr=[NSNumber numberWithLong:[self findIndexInAlphabetOfChar:prev]];
                buildVector= [self.smcTable getValuesAtIndex:@[@-1, rr, hh]];
                break;
        }
        if (ii==len-1) {
            [buildVector dotMulWithMatrix:self.smcFinals];
        }
        
        buildVector=[self cumulativeDistributionOf:buildVector];
        current =[[self.alphabet objectAtIndex:[self findIndexOfProbability:ran
                                                                 inVector:buildVector.matrix]] characterAtIndex:0];
        [output appendString:[NSString stringWithFormat:@"%c", current ]];
        
        
    }

    

    
    
    return output;
}

- (long) findIndexOfProbability: (float) number inVector: (NSArray *) vec {
    for (long ii=0; ii<[vec count]; ii++) {
        if (number<=[[vec objectAtIndex:ii] floatValue]) {
            return ii;
        }
    }
    if (number<=1)
        return ([vec count] -1);
    else
        return -1;
}

- (MMatrix *) cumulativeDistributionOf: (MMatrix *) vector {
    MMatrix* output=[[MMatrix alloc] init];
    [output initWithSize:vector.size];
    output.matrix=[NSMutableArray arrayWithArray: vector.matrix];
    NSNumber *summ=[NSNumber numberWithFloat:[output sumOfElements]];
    [output divByValue:summ];
    
    for (long ii=1; ii<output.len; ii++) {
        summ=[NSNumber numberWithFloat: ([[output.matrix objectAtIndex:(ii-1)] floatValue] +
              [[output.matrix objectAtIndex:(ii)] floatValue] )];
        [output.matrix setObject:summ  atIndexedSubscript:ii];
    }
    
    return output;
}


@end

