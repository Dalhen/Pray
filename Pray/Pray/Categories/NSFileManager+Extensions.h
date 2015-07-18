//
//  NSFileManager+iCloud.h
//  VortexVault
//
//  Created by Jason YL on 10/02/12.
//  Copyright (c) 2013 All rights reserved.
//

/*-----------------------------------------------------------------------------------------------------*/

@interface NSFileManager (Extensions)

//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - directories
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
+ (NSURL *)cachesUrl;
+ (NSURL *)libraryUrl;
+ (NSURL *)applicationSupportUrl;
+ (NSURL *)documentsUrl;

+ (NSString *)cachesDirectory;
+ (NSString *)libraryDirectory;
+ (NSString *)applicationSupportDirectory;
+ (NSString *)documentsDirectory;

//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - skip backup
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
+ (BOOL)addSkipBackupAttributeToItemAtPath:(NSString*)path;

//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - utilities
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
+ (NSString *) standarizePath:(NSString *)path;

//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - fetching
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
+ (NSArray *) contentsAtPath:(NSString *)path;
+ (NSArray *) foldersAtPath:(NSString *)path
          includeSubfolders:(BOOL)includeSubfolders;
+ (NSArray *) filesAtPath:(NSString *)path
        includeSubfolders:(BOOL)includeSubfolders;
+ (NSArray *) contentsAtPath:(NSString *)path
           includeSubfolders:(BOOL)includeSubfolders;

// TODO
// return files of type
// return files with prefix
// return files with suffix
// return folders with prefix
// return folders with suffix
// return items with prefix
// return items with suffix

//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - check
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
+ (BOOL) pathIsValid: (NSString *)path;
+ (BOOL) pathExists: (NSString *)path;
+ (BOOL) itemExistsAtPath:(NSString *)path;

/*-----------------------------------------------------------------------------------------------------*/

+ (BOOL) isFolderPath:(NSString *)folderPath;
+ (BOOL) isFilePath:(NSString *)filePath;

/*-----------------------------------------------------------------------------------------------------*/

+ (BOOL) fileName:(NSString *)fileName
     existsAtPath:(NSString *)path
     orSubfolders:(BOOL)includeSubfolders;
+ (BOOL) folderName:(NSString *)folderName
       existsAtPath:(NSString *)path
       orSubfolders:(BOOL)includeSubfolders;
+ (BOOL) itemName:(NSString *)itemName
     existsAtPath:(NSString *)path
     orSubfolders:(BOOL)includeSubfolders;

//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - actions
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
+ (BOOL) createPath:(NSString *)path;
+ (BOOL) removeItemAtPath:(NSString *)path;

/*-----------------------------------------------------------------------------------------------------*/

+ (BOOL) renameItemAtPath:(NSString *)path
                   toName:(NSString *)newName;
+ (BOOL) copyItemFromPath:(NSString *)fromPath
                   toPath:(NSString *)toPath;
+ (BOOL) moveItemFromPath:(NSString *)fromPath
                   toPath:(NSString *)toPath;

/*-----------------------------------------------------------------------------------------------------*/

// TODO
// rename enumerate by (different types)
// rename random

//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - saving
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
+ (BOOL)savePngImage:(UIImage *)image
              toPath:(NSString *)path;
+ (BOOL)saveJpegImage:(UIImage *)image
          withQuality:(float)quality
               toPath:(NSString *)path;

// TODO
// save data to path
// save string to path

@end
