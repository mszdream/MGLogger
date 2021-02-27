//
//  MGLoggerQueue.m
//  MGLogger
//
//  Created by msz on 2020/12/25.
//

#import "MGLoggerQueue.h"
#import <fmdb/FMDB.h>

@interface MGLoggerTableItem : NSObject
@property (nonatomic, assign) NSInteger id;
@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) NSString *class_name;

- (id<MGCaching>)getCachingObject;
@end
@implementation MGLoggerTableItem

- (id<MGCaching>)getCachingObject {
    Class<MGCaching> class = NSClassFromString(self.class_name);
    id<MGCaching> obj = [class mg_create: self.content];
    return obj;
}

@end

@interface MGLoggerQueue(structdb)
- (void)openSqlite;
@end

@interface MGLoggerQueue()
@property (nonatomic, strong) NSMutableArray *commands;

// 数据库相关
@property (nonatomic, strong) NSString *tbName;
@property (nonatomic, strong) FMDatabaseQueue *dbQueue;
@end

@implementation MGLoggerQueue

- (instancetype)init {
    self = [super init];
    if (self) {
        self.tbName = @"queue";
        [self openSqlite];
        
        self.commands = [NSMutableArray arrayWithCapacity:0];
    }
    
    return self;
}

- (NSInteger)count {
    __block NSInteger retCount = 0;
    [self.dbQueue inDatabase:^(FMDatabase * _Nonnull db) {
        if (![db open]) {
            return;
        }
        
        NSString *sql = [NSString stringWithFormat:@"select count(*) from %@", self.tbName];
        FMResultSet *result = [db executeQuery:sql];
        if ([result next]) {
            retCount = [result[0] integerValue];
        } else {
            NSLog(@"insert error: %@", db.lastError.description);
        }
        
        [db close];
    }];
    return retCount;
}

- (void)push:(id<MGCaching>)obj {
    if (obj == nil) {
        return;
    }
    
    [self.dbQueue inDatabase:^(FMDatabase * _Nonnull db) {
        if (![db open]) {
            return;
        }
        
        NSString *content = [obj mg_obj2Str];
        NSString *class_name = [obj mg_className];
        NSString *sql = [NSString stringWithFormat:@"insert into '%@'(content, class_name) values(?,?)", self.tbName];
        NSArray *value = @[content, class_name];
        BOOL result = [db executeUpdate:sql withArgumentsInArray:value];
        if (result) {
            NSLog(@"insert into: insert to table '%@' success", self.tbName);
        } else {
            NSLog(@"insert error: %@", db.lastError.description);
        }
        
        [db close];
    }];
}

- (id<MGCaching>)pop {
    __block id<MGCaching> obj = nil;
    
    [self.dbQueue inDatabase:^(FMDatabase * _Nonnull db) {
        if (![db open]) {
            return;
        }
        
        NSString *sql = [NSString stringWithFormat:@"select * from '%@' limit 1", self.tbName];
        FMResultSet *result = [db executeQuery:sql];
        NSMutableArray *array = [NSMutableArray array];
        if ([result next]) {
            MGLoggerTableItem *item = [[MGLoggerTableItem alloc] init];
            item.id = [result intForColumn:@"id"];
            item.content = [result stringForColumn:@"content"];
            item.class_name = [result stringForColumn:@"class_name"];
            [array addObject:item];
            
            obj = [item getCachingObject];
        }
        
        self.commands = array;
        
        [db close];
    }];
    
    return obj;
}

- (NSArray<id<MGCaching>> *)pop:(NSInteger)count {
    if (count <= 0) {
        return nil;
    }

    NSMutableArray<id<MGCaching>> *array = nil;
    [self.dbQueue inDatabase:^(FMDatabase * _Nonnull db) {
        if (![db open]) {
            return;
        }
        
        NSString *sql = [NSString stringWithFormat:@"select * from '%@' limit %ld", self.tbName, (long)count];
        FMResultSet *result = [db executeQuery:sql];
        NSMutableArray *array = [NSMutableArray array];
        while ([result next]) {
            MGLoggerTableItem *item = [[MGLoggerTableItem alloc] init];
            item.id = [result intForColumn:@"id"];
            item.content = [result stringForColumn:@"content"];
            item.class_name = [result stringForColumn:@"class_name"];
            [array addObject:item];
        }
        
        self.commands = array;
        
        [db close];
    }];
    
    if (self.commands.count > 0) {
        array = [NSMutableArray arrayWithCapacity:0];
        for (MGLoggerTableItem *item in self.commands) {
            id<MGCaching> obj = [item getCachingObject];
            [array addObject:obj];
        }
    }
    
    return array;
}

- (void)removeFromFront:(NSInteger)count {
    if (count <= 0) {
        return;
    }
    
    [self.dbQueue inDatabase:^(FMDatabase * _Nonnull db) {
        if (![db open]) {
            return;
        }
        
        NSString *sql = [NSString stringWithFormat:@"delete from %@ limit %ld", self.tbName, (long)count];
        BOOL result = [db executeUpdate:sql];
        if (result) {
            NSLog(@"delete items successful");
        } else {
            NSLog(@"delete error: %@", db.lastError.description);
        }
        
        [db close];
    }];
}

@end

#pragma --mark 构建数据库
@implementation MGLoggerQueue(structdb)
- (void)openSqlite {
    // 1.打开数据库(如果指定的数据库文件存在就直接打开，不存在就创建一个新的数据文件)
    // 参数1:需要打开的数据库文件路径(iOS中一般将数据库文件放到沙盒目录下的Documents下)
    NSString *nsPath = [NSString stringWithFormat:@"%@/Documents/mglogger_sqlite_db.db", NSHomeDirectory()];
    NSLog(@"sqlite path == %@",nsPath);
    
    FMDatabaseQueue *dbQueue = [FMDatabaseQueue databaseQueueWithPath:nsPath];
    self.dbQueue = dbQueue;
    [dbQueue inDatabase:^(FMDatabase * _Nonnull db) {
        if ([db open]) {
            NSLog(@"打开数据库成功");
            if (![self isExistTable:self.tbName andDb:db]) {
                [self creatTableInDb:db];
            }
        } else {
            NSLog(@"打开数据库失败");
        }
    }];
}

/**
 判断一张表是否已经存在
 @param tablename 表名
 */
- (BOOL)isExistTable:(NSString *)tablename andDb: (FMDatabase *)db {
    NSString *sql = [NSString stringWithFormat:@"SELECT COUNT(*) FROM sqlite_master where type= 'table' and name='%@';", tablename];
    FMResultSet *rs = [db executeQuery:sql];
    while([rs next]) {
        NSInteger count = [rs intForColumnIndex:0];
        if (count == 0) {
            return NO;
        } else {
            return YES;
        }
    }
    
    return NO;
}

- (void)creatTableInDb:(FMDatabase *)db {
    // 1.设计创建表的sql语句
    NSString *sql = [NSString stringWithFormat:@"\
                     CREATE TABLE IF NOT EXISTS %@(\
                     id INTEGER PRIMARY KEY AUTOINCREMENT, \
                     content 'text', \
                     class_name 'text');", self.tbName];
    // 2.执行
    BOOL result = [db executeUpdate:sql];
    // 3.判断执行结果
    if (result) {
        NSLog(@"创建表成功");
    } else {
        NSLog(@"创建表失败");
    }
}

@end
