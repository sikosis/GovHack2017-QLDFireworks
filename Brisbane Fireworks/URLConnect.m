//
//  URLConnect.m
//  Hospital Records
//
//  Created by xphil on 3/07/2014.
//  Copyright (c) 2014 Code Army. All rights reserved.
//

#import "URLConnect.h"

static NSMutableArray *sharedConnectionList = nil;

@implementation URLConnect

@synthesize request,completionBlock,internalConnection;

-(id)initWithRequest:(NSURLRequest *)req {
    self = [super init];
    if (self) {
        [self setRequest:req];
    }
    return self;
}

-(void)start {
    
    container = [[NSMutableData alloc]init];
    
    internalConnection = [[NSURLConnection alloc]initWithRequest:[self request] delegate:self startImmediately:YES];
    
    if(!sharedConnectionList)
        sharedConnectionList = [[NSMutableArray alloc] init];
    [sharedConnectionList addObject:self];
    
}


#pragma mark NSURLConnectionDelegate methods

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    
    [container appendData:data];
    
}

//If finish, return the data and the error nil
-(void)connectionDidFinishLoading:(NSURLConnection *)connection {
    
    if([self completionBlock])
        [self completionBlock](container,nil);
    
    [sharedConnectionList removeObject:self];
    
}

//If fail, return nil and an error
-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    
    if([self completionBlock])
        [self completionBlock](nil,error);
    
    [sharedConnectionList removeObject:self];
    
}


@end
