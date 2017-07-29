//
//  URLConnect.h
//  Hospital Records
//
//  Created by xphil on 3/07/2014.
//  Copyright (c) 2014 Code Army. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface URLConnect : NSObject <NSURLConnectionDelegate,NSURLConnectionDataDelegate> {
    NSURLConnection *internalConnection;
    NSMutableData *container;
}

-(id)initWithRequest:(NSURLRequest *)req;

@property (nonatomic,copy) NSURLConnection *internalConnection;
@property (nonatomic,copy) NSURLRequest *request;
@property (nonatomic,copy) void (^completionBlock) (id obj, NSError *err);

-(void)start;

@end
