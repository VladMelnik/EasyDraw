//
//  ViewController.m
//  Easy Draw
//
//  Created by Vlad Melnyk on 23.06.17.
//  Copyright © 2017 VM. All rights reserved.
//

#import "ViewController.h"
#import "XMLDictionary.h"

#define DOCUMENTS [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject]


@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];


}

#pragma mark - Data Parse

- (NSMutableArray*) parseLessonsFromXMLFileWithName:(NSString*) name{
    NSDictionary* result = nil;
    NSError* error = nil;
    
    
    NSString* path = [[NSBundle mainBundle] pathForResource:name ofType:@"xml"];
    NSString* xmlString = [NSString stringWithContentsOfFile:path
                                                    encoding:NSUTF8StringEncoding
                                                       error:&error];
    if (error){
        NSLog(@"Error with xml: %@", [error userInfo]);
    }
    
    
    result = [NSDictionary dictionaryWithXMLString:xmlString];
    if (result){
        NSLog(@"XML file parsed succeed");
        return [result valueForKey:@"lesson"];
    }else{
        NSLog(@"XML file parsed error");
        return nil;
    }
}

- (NSDictionary*) lessonFromArray:(NSArray*) array withNumber:(NSInteger) numbe{
    NSDictionary* lessonData = nil;
    lessonData = [array objectAtIndex:numbe];
    return lessonData;
}

#pragma mark - File Path

- (NSString*) pathToFileWithName:(NSString*) name{
    NSString* path = [DOCUMENTS stringByAppendingPathComponent:name];
    return path;
}

- (void) createFileWithPath:(NSString*) path andFileType:(FileType) clasification{
    switch (clasification) {
        case FileTypeDictionary:{
            NSDictionary* file = [[NSDictionary alloc] init];
            [file writeToFile:path atomically:YES];
            break;
        }
        case FileTypeArray:{
            NSArray* file = [[NSArray alloc] init];
            [file writeToFile:path atomically:YES];
            break;
        }
        case FileTypeString:{
            NSString* file = [[NSString alloc] init];
            [file writeToFile:path atomically:YES encoding:NSUnicodeStringEncoding error:nil];
            break;
        }
        default:
            break;
    }
    
}

- (id) getInformationFromFileWithPath:(NSString *)path andFileClasification:(FileType)clasification{
    switch (clasification) {
        case FileTypeDictionary:{
            NSMutableDictionary* file = [NSMutableDictionary dictionaryWithContentsOfFile:path];
            return file;
            break;
        }
        case FileTypeArray:{
            NSMutableArray* file = [NSMutableArray arrayWithContentsOfFile:path];
            return file;
            break;
        }
        case FileTypeString:{
            NSMutableString* file = [NSMutableString stringWithContentsOfFile:path encoding:NSUnicodeStringEncoding error:nil];
            return file;
            break;
        }
        default:
            break;
    }
    
}


- (NSString*) pathToLessonWithNumber:(NSString*) number{
    NSString* path = [[NSString alloc] init];
    path = [[NSBundle mainBundle] pathForResource:@"data_path" ofType:@"png"];
    
    path = [path stringByDeletingLastPathComponent];
    
    NSString* assetsComponent = @"assets";
    NSString* lessonComponent = [NSString stringWithFormat:@"lesson%@",number];

    
    path = [path stringByAppendingPathComponent:[NSString stringWithFormat:@"%@/%@",assetsComponent,lessonComponent]];
    return path;
}


- (NSString*) changeNumber:(NSInteger) number{
    if (number < 10){
       return [NSString stringWithFormat:@"0%ld",(long)number];
    }else{
        return [NSString stringWithFormat:@"%ld",(long)number];
    }
}



@end
