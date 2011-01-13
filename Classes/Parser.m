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
			//NSString* stringInArray = [stringConvertedInWordArray objectAtIndex:j];
			[wordContainer addObject:[stringConvertedInWordArray objectAtIndex:j]];
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
				//i++;
				[self addModToData:textArray :i+1];
			}
			
			if ([string isEqual:@"$var"]) {
				//i++;
				[self addVarToData:textArray :i+1];
				
			}
			
		}
		if (abort) {
			break;
		}
	}
	[self allOut];
	
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
	
	NSString* varType = [[NSString alloc] initWithFormat:@"%@%@",[lineArray objectAtIndex:counter], [lineArray objectAtIndex:counter+1]];
	
	counter++;
	counter++;
	
	NSString* varSymbol = [lineArray objectAtIndex:counter];
	
	counter++;
	
	NSString* varName = [lineArray objectAtIndex:counter];


	//if variable is an array variable
	if (![[lineArray objectAtIndex:counter+1] isEqual:@"$end"]) {
		
		counter++;
		
		NSString* varNumber = [[lineArray objectAtIndex:counter] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"[]"]];
		
		int indexBehindActual = [variablesArray count] - 1; 
		VariableNode* variableBehindActual = [variablesArray objectAtIndex:indexBehindActual];
		
		if ([[variableBehindActual varName] isEqual:varName]) {
			
			//here if there is the same variable as it was before
						
			NSMutableArray* varArray = [variableBehindActual varArray];
			
			VariableNode* varNode = [[VariableNode alloc] init];
			
			[varNode setVarName:[[NSString alloc] initWithFormat:@"%@%@", varName, varNumber]];
			[varNode setSymbol:varSymbol];
			[varNode setSignals:[[NSMutableArray alloc] initWithCapacity:1]];
			
			[varArray addObject:varNode];
				
		} else {
			
			//here if theres a new array variable
			
			VariableNode* varNode = [[VariableNode alloc] init];
			
			[varNode setVarName:[[NSString alloc] initWithFormat:@"%@", varName]];
			[varNode setType:varType];
			
			VariableNode* varArrayNode = [[VariableNode alloc] init];
			
			[varArrayNode setVarName:[[NSString alloc] initWithFormat:@"%@%@", varName, varNumber]];
			[varArrayNode setSymbol:varSymbol];
			[varArrayNode setSignals:[[NSMutableArray alloc] initWithCapacity:1]];
			
			//might be strange, but there is no other way, i think
			[varNode setVarArray:[[NSMutableArray alloc] initWithCapacity:1]];
			NSMutableArray* varArray = [varNode varArray];
			
			[varArray addObject:varArrayNode];
			[variablesArray addObject:varNode];

		}
		
	} else {
		
		VariableNode* varNode = [[VariableNode alloc] init];

		[varNode setVarName:varName];
		[varNode setType:varType];
		[varNode setSymbol:varSymbol];
		[varNode setSignals:[[NSMutableArray alloc] initWithCapacity:1]];

		[variablesArray addObject:varNode];
	
	}
}

- (void)allOut {
	ModuleNode* modules = [data objectAtIndex:0];
	NSMutableArray* variables = [modules variables];
	VariableNode* var = [variables objectAtIndex:2];
	NSLog(@"%@",[var varName]);
	NSMutableArray* mutA = [var varArray];
	int c = [mutA count];
	
	VariableNode* varNodeInArray = [mutA objectAtIndex:1];
	
	NSLog(@"Name: %@ und Symbol: %@",[varNodeInArray varName], [varNodeInArray symbol]);
	NSLog(@"%d",c);
	
	
	
	
	
	
	
	
	
	
}

@end
