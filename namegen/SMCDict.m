//
//  SMCDict.m
//  namegen
//
//  Created by Samuele Rodi on 10/19/15.
//  Copyright © 2015 Samuele Rodi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SMCDict.h"

@implementation SMCDict 

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
    NSArray* alphabet=[NSArray arrayWithObjects:@"a",@"b",@"c",@"d",@"e",@"f",@"g",@"h",@"i",
                                            @"j",@"k",@"l",@"m",@"n",@"o",@"p",@"q",@"r",
                                            @"s",@"t",@"u",@"v",@"w",@"x",@"y",@"z", nil];

    long n=[alphabet count];
    NSMutableArray *table=[self matrix3DOfSize:n andFloat:0];
    
    
    NSArray* items=[self openDictionary:dict];
    
    long str_len;
    char first;
    char last;
    char second;
    
    for (NSString *item in items) {
        str_len=[item length]-1;
        
        if (str_len>0) {
            first=[item characterAtIndex:0];
            last=[item characterAtIndex:str_len-1];
            
            if (str_len>1)
                second=[item characterAtIndex:1];
        
        }

        
    }
    
    NSLog(@"%f", [table[0][2][2] floatValue]);
    
}

- (NSMutableArray*) matrix2DOfSize: (long) size andFloat: (float) value;
    {
        NSNumber *n=[NSNumber numberWithInteger:size];
        NSMutableArray *cc=[[NSMutableArray alloc] initWithCapacity:[n longValue]];
        NSMutableArray *table=[[NSMutableArray alloc] initWithCapacity:[n longValue]];

        for (long ii=0; ii<=[n longValue]; ii++) {
            [cc setObject:[NSNumber numberWithFloat:value] atIndexedSubscript:ii];
        }

        for (long ii=0; ii<=[n longValue]; ii++) {
            [table setObject:cc atIndexedSubscript:ii];
        }
        return table;
}
       
- (NSMutableArray*) matrix3DOfSize: (long) size andFloat: (float) value;
{
        NSNumber *n=[NSNumber numberWithInteger:size];
        NSMutableArray *cc=[[NSMutableArray alloc] initWithCapacity:[n longValue]];
        NSMutableArray *rr=[[NSMutableArray alloc] initWithCapacity:[n longValue]];
        NSMutableArray *table=[[NSMutableArray alloc] initWithCapacity:[n longValue]];
    
        for (long ii=0; ii<=[n longValue]; ii++) {
            [cc setObject:[NSNumber numberWithFloat:value] atIndexedSubscript:ii];
        }
        for (long ii=0; ii<=[n longValue]; ii++) {
            [rr setObject:cc atIndexedSubscript:ii];
        }
        for (long ii=0; ii<=[n longValue]; ii++) {
            [table setObject:rr atIndexedSubscript:ii];
        }
            return table;
}


@end

