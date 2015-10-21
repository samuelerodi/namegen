//
//  SMCDict.m
//  namegen
//
//  Created by Samuele Rodi on 10/19/15.
//  Copyright © 2015 Samuele Rodi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SMCDict.h"
#import "MMatrix.h"

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

    
    float matrix [n] [n] [n];
    
    for (long cc=0; cc<n; cc++) {
        for (long rr=0; rr<n; rr++) {
            for (long hh=0; hh<n; hh++) {
                matrix[hh][rr][cc]=cc+rr+hh;
            }
        }
    }
    

    NSLog(@"%f, %f, %f", matrix[1][1][1], matrix[20][20][20], matrix[3][3][3]);
    //Create 3D statistical table for letter probability and init at 0
    MMatrix* table= [[MMatrix alloc] init];
    
    NSArray *sz = @[ @3, @3, @3];
    [table initWithSize:@[@21, @2, @2] AndValue:@0.5];
    [table initWithSize:sz AndValue:[NSNumber numberWithFloat:0.5]];
    //[table matrix3DOfSize:n andFloat:0];
    NSLog(@"%f", [table.matrix[1][1][1] floatValue] );

    //Compute Statistical Relevance of the Dictionary passed
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
    
   // NSLog(@"%f", [table.matrix[0][2][2] floatValue]);
    
}




@end

