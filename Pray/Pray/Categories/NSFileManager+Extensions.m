//
//  NSFileManager+iCloud.m
//  VortexVault
//
//  Created by Jason YL on 10/02/12.
//  Copyright (c) 2013 All rights reserved.
//

/*-----------------------------------------------------------------------------------------------------*/

#import "NSFileManager+Extensions.h"
#import <sys/xattr.h>

/*-----------------------------------------------------------------------------------------------------*/

@implementation NSFileManager (Extensions)

//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - directories
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
+ (NSURL *)cachesUrl
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSCachesDirectory inDomains:NSUserDomainMask] lastObject];
}

+ (NSURL *)libraryUrl
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSLibraryDirectory inDomains:NSUserDomainMask] lastObject];
}

+ (NSURL *)applicationSupportUrl
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSApplicationSupportDirectory inDomains:NSUserDomainMask] lastObject];
}

+ (NSURL *)documentsUrl
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

+ (NSString *)cachesDirectory
{
    return [[self cachesUrl] path];
}

+ (NSString *)libraryDirectory
{
    return [[self libraryUrl] path];
}

+ (NSString *)applicationSupportDirectory
{
    return [[self applicationSupportUrl] path];
}

+ (NSString *)documentsDirectory
{
    return [[self documentsUrl] path];
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - skip backup
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
+ (BOOL)addSkipBackupAttributeToItemAtPath:(NSString*)path
{
    u_int8_t attrValue = 1;
    int result = setxattr( [path fileSystemRepresentation], "com.apple.MobileBackup", &attrValue, 1, 0, 0);
    return result == 0;
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - utilities
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
+ (NSString *) standarizePath: (NSString *)path
{
    return [path stringByStandardizingPath];
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - fetching
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
+ (NSArray *)  contentsAtPath: (NSString *)path
{
    if (![self isFolderPath:path])
        {
        return nil;
        }
    
    NSError *error = nil;
    NSArray *contentsAtPath = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:path error:&error];
    if (error)
        {
        printFail(@"can't get contents for path -> \"%@\"", path);
        return nil;
        }
    return contentsAtPath;
}

+ (NSArray *) foldersAtPath: (NSString *)path
          includeSubfolders:  (BOOL)includeSubfolders
{
    NSArray *contentsAtPath = [self contentsAtPath:path];
    NSMutableArray *folderPaths = [NSMutableArray array];
    for (int i = 0; i < [contentsAtPath count]; i++)
        {
        NSString *path = [contentsAtPath objectAtIndex:i];
        if ([self isFolderPath:path])
            {
            [folderPaths addObject:path];
            
            if (includeSubfolders)
                {
                NSArray *subFolderFolderPaths = [self foldersAtPath:path
                                                  includeSubfolders:YES];
                [folderPaths addObjectsFromArray:subFolderFolderPaths];
                }
            
            }
        }
    
    if ([folderPaths count] == 0)
        {
        return nil;
        }
    
    return folderPaths;
}

+ (NSArray *)  filesAtPath: (NSString *)path
         includeSubfolders: (BOOL)includeSubfolders
{
    NSArray *contentsAtPath = [self contentsAtPath:path];
    NSMutableArray *filePaths = [NSMutableArray array];
    
    for (int i = 0; i < [contentsAtPath count]; i++)
        {
        NSString *path = [contentsAtPath objectAtIndex:i];
        if ([self isFilePath:path])
            {
            [filePaths addObject:path];
            }
        else if (includeSubfolders)
            {
            NSArray *subFolderFilePaths = [self filesAtPath:path
                                          includeSubfolders:YES];
            [filePaths addObjectsFromArray:subFolderFilePaths];
            }
        }
    
    if ([filePaths count] == 0)
        {
        return nil;
        }
    
    return filePaths;
}

+ (NSArray *) contentsAtPath:  (NSString *)path
           includeSubfolders:  (BOOL)includeSubfolders
{
    NSMutableArray *contentsAtPath = [NSMutableArray arrayWithArray:[self contentsAtPath:path]];
    
    if (!includeSubfolders)
        {
        return contentsAtPath;
        }
    
    for (int i = 0; i < [contentsAtPath count]; i++)
        {
        NSString *path = [contentsAtPath objectAtIndex:i];
        if ([self isFolderPath:path])
            {
                NSArray *subFolderFolderPaths = [self contentsAtPath:path
                                                   includeSubfolders:YES];
                [contentsAtPath addObjectsFromArray:subFolderFolderPaths];
            }
        }
    
    if ([contentsAtPath count] == 0)
        {
        return nil;
        }
    
    return contentsAtPath;
    
}
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - checks
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
+ (BOOL) pathIsValid: (NSString *)path
{
    if ([self itemExistsAtPath:path] || [self pathExists:path])
        {
        return YES;
        }
    return NO;
}

+ (BOOL) pathExists: (NSString *)path
{
    if (![[path pathExtension] isEqualToString:@""])
        {
        path = [path stringByDeletingLastPathComponent];
        }
    return [self itemExistsAtPath:path];
}

+ (BOOL) itemExistsAtPath: (NSString *)path
{
    return [[NSFileManager defaultManager] fileExistsAtPath:path];
}

/*-----------------------------------------------------------------------------------------------------*/

+ (BOOL) isFolderPath: (NSString *)folderPath
{
    return ![folderPath pathExtension].isValidString;
}

+ (BOOL) isFilePath: (NSString *)filePath
{
    return [filePath pathExtension].isValidString;
}

/*-----------------------------------------------------------------------------------------------------*/

+ (BOOL) fileName: (NSString *)fileName
     existsAtPath: (NSString *)path
     orSubfolders: (BOOL)includeSubfolders
{
    NSArray *filesAtPath = [self filesAtPath:path
                           includeSubfolders:includeSubfolders];
    for (int i = 0; i < [filesAtPath count]; i++)
        {
        NSString *path = [filesAtPath objectAtIndex:i];
        NSString *subPathFileName = [[path stringByDeletingPathExtension] lastPathComponent];
        if ([subPathFileName isEqualToString:fileName])
            {
            return YES;
            }
        }
    
    return NO;
}

+ (BOOL) folderName: (NSString *)folderName
       existsAtPath: (NSString *)path
       orSubfolders: (BOOL)includeSubfolders
{
    NSArray *foldersAtPath = [self foldersAtPath:path
                               includeSubfolders:YES];
    for (int i = 0; i < [foldersAtPath count]; i++)
        {
        NSString *path = [foldersAtPath objectAtIndex:i];
        NSString *subPathFolderName = [path lastPathComponent];
        if ([subPathFolderName isEqualToString:folderName])
            {
            return YES;
            }
        }
    
    return NO;
}

+ (BOOL) itemName: (NSString *)itemName
     existsAtPath: (NSString *)path
     orSubfolders: (BOOL)includeSubfolders
{
    NSArray *contentsAtPath = [self contentsAtPath:path
                                 includeSubfolders:includeSubfolders];
    for (int i = 0; i < [contentsAtPath count]; i++)
        {
        NSString *path = [contentsAtPath objectAtIndex:i];
        if ([self isFilePath:path])
            {
            NSString *subPathFileName = [[path stringByDeletingPathExtension] lastPathComponent];
            if ([subPathFileName isEqualToString:itemName])
                {
                return YES;
                }
            }
        else
            {
            NSString *subPathFolderName = [path lastPathComponent];
            if ([subPathFolderName isEqualToString:itemName])
                {
                return YES;
                }
            }
        }
    return NO;
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - actions
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
+ (BOOL) createPath: (NSString *)path
{
    if ([self pathIsValid:path])
        {
        return YES;
        }
    
    if ([self isFilePath:path])
        {
        path = [path stringByDeletingLastPathComponent];
        }
    
    NSError *error = nil;
    BOOL result = [[NSFileManager defaultManager] createDirectoryAtPath:path
                                            withIntermediateDirectories:YES
                                                             attributes:nil
                                                                  error:&error];
    
    if (error)
        {
        printFail(@"can't create path -> \"%@\"", path);
        printErrorAndAbort(error);
        return NO;
        }
    
    return result;
}

+ (BOOL) removeItemAtPath: (NSString *)path
{
    if ([self pathIsValid:path])
        {
        NSError *error = nil;
        BOOL result = [[NSFileManager defaultManager] removeItemAtPath:path
                                                                 error:&error];
        
        if (error)
            {
            printFail(@"can't remove item at path -> \"%@\"", path);
            printErrorAndAbort(error);
            return NO;
            }
        
        return result;
        }
    
    return NO;
}

/*-----------------------------------------------------------------------------------------------------*/

+ (BOOL) renameItemAtPath: (NSString *)path
                   toName: (NSString *)newName
{
    if ([self itemExistsAtPath:path])
        {
        
        NSString *extension = [path pathExtension];
        NSString *directoryPath = [path stringByDeletingLastPathComponent];
        NSString *newPath = [directoryPath stringByAppendingPathComponent:newName];
        
        if (extension)
            {
            newPath = [newPath stringByAppendingFormat:@".%@", extension];
            }
        
        NSError *error = nil;
        BOOL result = [[NSFileManager defaultManager] moveItemAtPath:path
                                                              toPath:newPath
                                                               error:&error];
        
        if (error)
            {
            printFail(@"can't rename item at path ->\n        \"%@\"\nto path ->\n        \"%@\"", path, newPath);
            printErrorAndAbort(error);
            return NO;
            }
        
        return result;
        }
    
    printFail(@"can't rename item at path-> \"%@\"\n", path);
    return NO;
}


+ (BOOL) copyItemFromPath: (NSString *)fromPath
                   toPath: (NSString *)toPath
{
    if ([self itemExistsAtPath:fromPath])
        {
        
        if ([self pathIsValid:toPath])
            {
            NSError *error = nil;
            BOOL result = [[NSFileManager defaultManager] copyItemAtPath:fromPath
                                                                  toPath:toPath
                                                                   error:&error];
            
            if (error)
                {
                printFail(@"can't copy item at path ->\n        \"%@\"\nto path ->\n        \"%@\"", fromPath, toPath);
                printErrorAndAbort(error);
                return NO;
                }
            
            return result;
            }
        
        printFail(@"destination path is not valid -> \"%@\"", toPath);
        return NO;
        }
    
    printFail(@"origin path is not valid -> \"%@\"", fromPath);
    return NO;
}


+ (BOOL) moveItemFromPath: (NSString *)fromPath
                   toPath: (NSString *)toPath
{
    if ([self itemExistsAtPath:fromPath])
        {
        
        if ([self pathIsValid:toPath])
            {
            NSError *error = nil;
            BOOL result = [[NSFileManager defaultManager] moveItemAtPath:fromPath
                                                                  toPath:toPath
                                                                   error:&error];
            
            if (error)
                {
                printFail(@"can't move item at path ->\n        \"%@\"\nto path ->\n        \"%@\"", fromPath, toPath);
                printErrorAndAbort(error);
                return NO;
                }
            
            return result;
            }
        
        printFail(@"destination path is not valid -> \"%@\"", toPath);
        return NO;
        }
    
    printFail(@"origin path is not valid -> \"%@\"", fromPath);
    return NO;
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - saving
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
+ (BOOL)savePngImage:(UIImage *)image
              toPath:(NSString *)path
{
    if ([self createPath:path])
        {
        NSData *data = UIImagePNGRepresentation(image);
        [data writeToFile:path
               atomically:YES];
        return YES;
        }
    
    return NO;
}

+ (BOOL)saveJpegImage:(UIImage *)image
          withQuality:(float)quality
               toPath:(NSString *)path
{
    if (quality < 0.0)
        {
        printImportant(@"quality cannot be less than 0.0, setting to minimum");
        quality = 0.0;
        }
    else if (quality > 1.0)
        {
        printImportant(@"quality cannot be more than 1.0, setting to maximum");
        quality = 1.0;
        }
    
    if ([self createPath:path])
        {
        NSData *data = UIImageJPEGRepresentation(image, quality);
        [data writeToFile:path
               atomically:YES];
        return YES;
        }
    
    return NO;
}

@end
