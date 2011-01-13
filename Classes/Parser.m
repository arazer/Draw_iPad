//
//  Parser.m
//  Draw_iPad
//
//  Created by Dennis Hübner on 09.01.11.
//  Copyright 2011 huebys inventions. All rights reserved.
//

#import "Parser.h"
#import "ModuleNode.h"
#import "VariableNode.h"

@implementation Parser

@synthesize data;

- (id) init {
	return self;
}

- (void)parseFile:(NSString*) filePath {
	//replacement for constructor
	
	if ([self getFile:filePath]) {
		NSMutableArray* vcdArray = [self convertFileToMutableArray:filePath];
		if (vcdArray != nil) {
			[self makeTree:vcdArray];
		}else {
			NSLog(@"Array is empty.");
		}

		
	} else {
		NSLog(@"File not found. Aborting.");
	}

}

- (BOOL)getFile:(NSString*) filePath {
	//check existence of the file
	
	//not the best code..
	NSFileManager* fileExists = [[NSFileManager alloc] fileExistsAtPath:filePath];
	return fileExists;
}

- (NSMutableArray*)convertFileToMutableArray:(NSString*) filePath {

	NSLog(@"Pfad der Datei: %@", filePath);
	
	NSString* fileOut = [NSString stringWithContentsOfFile:filePath];
	
	NSArray* arrayFromFileWithLineIndex = [fileOut componentsSeparatedByString:@"\n"];
	NSMutableArray* finalArrayLineWords = [[NSMutableArray alloc] initWithCapacity:1];	
	
	for (int i = 0; i < [arrayFromFileWithLineIndex count]; i++) {
		NSString* string = [arrayFromFileWithLineIndex objectAtIndex:i];
	
		NSArray* stringConvertedInWordArray = [string componentsSeparatedByString:@" "]; 
		
		NSMutableArray* wordContainer = [[NSMutableArray alloc] initWithCapacity:1];
	
	
		for (int j = 0; j < [stringConvertedInWordArray count]; j++) {
			NSString* stringInArray = [stringConvertedInWordArray objectAtIndex:j];
			[wordContainer addObject:stringInArray];
		}
		[finalArrayLineWords addObject:wordContainer];
	}

	return finalArrayLineWords;
}

- (void)makeTree:(NSMutableArray*)vcdArray {
	//gets array and converts it into a tree structure
	
	data = [[NSMutableArray alloc] initWithCapacity:1];
	
	for (counterOne = 0; counterOne < [vcdArray count] ; counterOne++) {
		
		NSMutableArray* secondArray = [vcdArray objectAtIndex:counterOne];
	
		for (counterTwo = 0; counterTwo < [secondArray count]; counterTwo++) {
			NSString* string = [secondArray objectAtIndex:counterTwo];
			if ([string isEqual:@"$scope"]) {
				[self createHeadDatastructure:vcdArray :counterOne];
			}
		}
	}
}

- (void)createHeadDatastructure:(NSMutableArray*)vcdArray :(int) counterO {
	BOOL abort = NO;
	
	for (counterO; counterO < [vcdArray count]; counterO++) {
		
		NSMutableArray* textArray = [vcdArray objectAtIndex:counterO];

		for (int i = 0; i < [textArray count]; i++) {
			NSString* string = [textArray objectAtIndex:i];
			if ([string isEqual:@"$upscope"]) {
				abort = YES;
				break;
			}
			
			if ([string isEqual:@"module"]) {
				i++;
				[self addModToData:textArray :i++];
			}
			
			if ([string isEqual:@"$var"]) {
				i++;
				[self addVarToData:textArray :i];
				
			}
			
		}
		if (abort) {
			break;
		}
	}
	
}

- (void) addModToData:(NSMutableArray*)lineArray :(int) counter {
	//adding module to datastructure
	NSLog(@"%@",[lineArray objectAtIndex:counter]);
	
	ModuleNode* modNode = [[ModuleNode alloc] init];
	[modNode setName:[lineArray objectAtIndex:counter]];
	[modNode setVariables:[[NSMutableArray alloc] initWithCapacity:1]];
	[data addObject:modNode];
	
}

- (void) addVarToData:(NSMutableArray*)lineArray :(int) counter {
	//adding variable to datastructure
	//What if no module exists?!
	//This method only works in vcd format!
	
	ModuleNode* modNode = [data objectAtIndex:0];
	NSMutableArray* variablesArray = [modNode variables];
	
	VariableNode* varNode = [[VariableNode alloc] init];

	NSString* varType = [[NSString alloc] initWithFormat:@"%@%@",[lineArray objectAtIndex:counter], [lineArray objectAtIndex:counter+1]];
	
	counter++;
	counter++;
	
	NSString* varSymbol = [lineArray objectAtIndex:counter];
	
	counter++;
	
	NSString* varName = [lineArray objectAtIndex:counter];


	//not the best code..
	if (![[lineArray objectAtIndex:counter+1] isEqual:@"$end"]) {
		NSLog(@"%@", varName);
		counter++;
		NSString* varNumber = [[lineArray objectAtIndex:counter] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"[]"]];
		
		if ([varNode varArray] == nil) {
			[varNode setVarArray:[[NSMutableArray alloc] initWithCapacity:1]];
			NSMutableArray* varNumberArray = [varNode varArray];
			[varNumberArray addObject:varNumber];
		}
		
		NSMutableArray* varNumberArray = [varNode varArray];
		[varNumberArray addObject:varNumber];

		NSLog(@"%@", varNumber);
	}
	

	[varNode setVarName:varName];
	[varNode setType:varType];
	[varNode setSymbol:varSymbol];
	[varNode setSignals:[[NSMutableArray alloc] initWithCapacity:1]];

	[variablesArray addObject:varNode];
	
	
}

/*
- (CFTreeContext)getTree {
   return tree;
}
*/

@end
