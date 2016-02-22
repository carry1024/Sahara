//
//  oneselfData.m
//  Sahara
//
//  Created by heng on 15/12/29.
//  Copyright © 2015年 bode. All rights reserved.
//

#import "oneselfData.h"

@implementation oneselfData
// 存储方式：key-value形式告诉系统要存储哪些属性；

- (void)encodeWithCoder:(NSCoder *)aCoder {
    
    
    
    [aCoder encodeObject:self.headImage forKey:@"headImage"];
    
    [aCoder encodeObject:self.name forKey:@"name"];
    
    [aCoder encodeObject:self.birthday forKey:@"birthday"];
    
    [aCoder encodeObject:self.sex forKey:@"sex"];
    
    [aCoder encodeObject:self.height forKey:@"height"];
    
    [aCoder encodeObject:self.weight forKey:@"weight"];
    
}



// 读取方式：根据存入数据key取数据

- (id)initWithCoder:(NSCoder *)aDecoder {
    
    if (self = [super init]) {
        
        self.headImage = [aDecoder decodeObjectForKey:@"headImage"];
        
        self.name = [aDecoder decodeObjectForKey:@"name"];
        
        self.birthday = [aDecoder decodeObjectForKey:@"birthday"];
        
        self.sex = [aDecoder decodeObjectForKey:@"sex"];
        
        self.height = [aDecoder decodeObjectForKey:@"height"];
        
        self.weight = [aDecoder decodeObjectForKey:@"weight"];
        
    }
    
    return self;
    
}
@end
