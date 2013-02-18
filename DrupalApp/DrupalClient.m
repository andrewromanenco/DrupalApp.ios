//
//  DrupalClient.m
//  DrupalApp
//
//  Created by Andrew Romanenco on 2013-01-19.
//  Copyright (c) 2013 Andrew Romanenco. All rights reserved.
//

#import "DrupalClient.h"

#define _TIME_OUT_                  10

#define _OPERATION_NIL_             0
#define _OPERATION_INFO_            1
#define _OPERATION_LOGIN_           2
#define _OPERATION_LOGOUT_          3
#define _OPERATION_ONLINE_          40
#define _OPERATION_STATUS_          50
#define _OPERATION_UPDATES_         60
#define _OPERATION_LOGS_            70
#define _OPERATION_LOG_ITEM_        80

#define _MAKE_CALL_ \
    if ([responseHandler respondsToSelector:@selector(drupal_call_start)]) {    \
        [responseHandler drupal_call_start];                                    \
    }                                                                           \
    if (!connection) {                                                          \
        NSLog(@"*DrupalClient* connection not created");                        \
        [self connection:nil didFailWithError:nil];                             \
    }


@interface DrupalClient () {
    NSMutableData *_buffer;
    int _lastHttpStatus;
    int _currentCall;
}

- (NSMutableURLRequest*)getRequest:(NSString*)operation token:(BOOL)useToken params:(NSDictionary*)params;

- (void)processInfo:(NSDictionary*)result;
- (void)processLogin:(NSDictionary*)result;
- (void)processLogout;

- (void)processOnlineUsers:(NSDictionary*)result;
- (void)processSiteStatus:(NSDictionary*)result;
- (void)processSiteUpdates:(NSDictionary*)result;
- (void)processSiteLogs:(NSDictionary*)result;
- (void)processSiteLogEvent:(NSDictionary*)result;

- (void)displayAlert:(NSString*)message;
- (void)displayAlert:(NSString*)message title:(NSString*)title;

@end

@implementation DrupalClient

- (id)init:(NSString*)name url:(NSString*)url {
    self = [super init];
    if (self != nil) {
        self.address = url;
        self.name = name;
    }
    return self;
}

//
// Common REST calls handling
//

- (NSMutableURLRequest*)getRequest:(NSString*)operation token:(BOOL)useToken params:(NSDictionary*)params {
    NSString* url = [NSString stringWithFormat:@"%@%@", self.address, operation];
    NSLog(@"Calling: %@", url);
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    if (params||useToken) {
        [request setHTTPMethod:@"POST"];
        NSMutableString *body = [NSMutableString string];
        [body
         appendFormat:@"%@=%@",
         @"token",
         [self.token stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding]
         ];
        for (NSString *key in params) {
            [body
             appendFormat:@"&%@=%@",
             key,
             [[params objectForKey:key] stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding]
             ];
        }
        [request setHTTPBody:[body dataUsingEncoding:NSUTF8StringEncoding]];
    }
    _buffer = [NSMutableData data];
    return request;
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    _buffer = nil;
    if ([self.handler respondsToSelector:@selector(drupal_call_end)]) {
        [self.handler drupal_call_end];
    }
    if (error) {
        NSLog(@"*DrupalClient* Connection failed: %@", [error localizedDescription]);
        if ([self.handler respondsToSelector:@selector(drupal_networkError)]) {
            [self.handler drupal_networkError];
        } else {
            [self displayAlert:[error localizedDescription]];
        }
    } else {
        NSLog(@"*DrupalClient* connection object was not created");
        [self displayAlert:@"Please, report to support, tnx." title:@"FATAL: connection creation failed"];
    }
}

-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSHTTPURLResponse *)httpResponse {
    _lastHttpStatus = [httpResponse statusCode];
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [_buffer appendData:data];
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection {
    if ([self.handler respondsToSelector:@selector(drupal_call_end)]) {
        [self.handler drupal_call_end];
    }
    NSLog(@"*RESTClient* Connection finished (%d)", _lastHttpStatus);
    if (_lastHttpStatus == 200) {
        NSError *jsonError = nil;
        //NSLog(@"\n\nResponse body: %@\n\n",
        //    [[NSString alloc] initWithData:_buffer encoding:NSUTF8StringEncoding]);
        NSDictionary *result = [NSJSONSerialization JSONObjectWithData:_buffer options:NSJSONReadingMutableContainers error:&jsonError];
        _buffer = nil;
        if (jsonError) {
            //site did not responded as expected, report as not found
            if ([self.handler respondsToSelector:@selector(drupal_notFound)]) {
                [self.handler drupal_notFound];
            } else {
                [self displayAlert:@"Site does not have service module installed or enabled"];
            }
        } else {
            //forward to processor
            if (_currentCall == _OPERATION_INFO_) {
                [self processInfo:result];
            } else if (_currentCall == _OPERATION_LOGIN_) {
                [self processLogin:result];
            } else if (_currentCall == _OPERATION_LOGOUT_) {
                [self processLogout];
            } else if (_currentCall == _OPERATION_ONLINE_) {
                [self processOnlineUsers:result];
            } else if (_currentCall == _OPERATION_STATUS_) {
                [self processSiteStatus:result];
            } else if (_currentCall == _OPERATION_UPDATES_) {
                [self processSiteUpdates:result];
            } else if (_currentCall == _OPERATION_LOGS_) {
                [self processSiteLogs:result];
            } else if (_currentCall == _OPERATION_LOG_ITEM_) {
                [self processSiteLogEvent:result];
            } else {
                //TODO Call Exception
                NSLog(@"Something wrong.");
            }
        }
    } else if (_lastHttpStatus == 401) { //access denied
        if ([self.handler respondsToSelector:@selector(drupal_unauthorized)]) {
            [self.handler drupal_unauthorized];
        } else {
            [self displayAlert:@"Access denied"];
        }
    } else if (_lastHttpStatus == 403) { //forbidded
        if ([self.handler respondsToSelector:@selector(drupal_forbidden)]) {
            [self.handler drupal_forbidden];
        } else {
            [self displayAlert:@"You don't have right for this operation"];
        }
    } else if (_lastHttpStatus == 404) { //Not found
        if ([self.handler respondsToSelector:@selector(drupal_notFound)]) {
            [self.handler drupal_notFound];
        } else {
            [self displayAlert:@"Resource not found"];
        }
    } else if ((_lastHttpStatus >= 400)&&(_lastHttpStatus <= 499)) {
        if ([self.handler respondsToSelector:@selector(drupal_fail:)]) {
            [self.handler drupal_fail:_lastHttpStatus];
        } else {
            [self displayAlert:[NSString stringWithFormat:@"Request failed with code: %d", _lastHttpStatus]];
        }
    } else if ((_lastHttpStatus >= 500)&&(_lastHttpStatus <= 599)) {
        if ([self.handler respondsToSelector:@selector(drupal_error:)]) {
            [self.handler drupal_error:_lastHttpStatus];
        } else {
            [self displayAlert:[NSString stringWithFormat:@"Server side error: %d", _lastHttpStatus]];
        }
    } else {
        [self displayAlert:[NSString stringWithFormat:@"Not implemented for %d", _lastHttpStatus]];
    }
}

//
// REST calls
//

- (void)getDrupalInfo:(id<DrupalResponseHandler>)responseHandler {
    self.handler = responseHandler;
    NSURLRequest *request = [self getRequest:@"drupalmd/info/" token:FALSE params:nil];
    NSURLConnection *connection=[[NSURLConnection alloc] initWithRequest:request delegate:self];
    _currentCall = _OPERATION_INFO_;
    _MAKE_CALL_
}

- (void)processInfo:(NSDictionary*)result {
    [self.handler drupal_info:result];
}

- (void)login:(id<DrupalResponseHandler>)responseHandler username:(NSString*)username password:(NSString*)password {
    self.handler = responseHandler;
    NSURLRequest *request = [self getRequest:@"drupalmd/auth/"
                                       token:FALSE
                                      params:@{@"username" : username, @"password": password}];
    NSURLConnection *connection=[[NSURLConnection alloc] initWithRequest:request delegate:self];
    _currentCall = _OPERATION_LOGIN_;
    _MAKE_CALL_
}

- (void)processLogin:(NSDictionary*)result {
    NSString *session_token = [result objectForKey:@"token"];
    self.token = session_token;
    [self.handler drupal_loggedIn];
}

- (void)logout:(id<DrupalResponseHandler>)responseHandler {
    self.handler = responseHandler;
    NSURLRequest *request = [self getRequest:@"drupalmd/logout/"
                                       token:TRUE
                                      params:nil];
    NSURLConnection *connection=[[NSURLConnection alloc] initWithRequest:request delegate:self];
    _currentCall = _OPERATION_LOGOUT_;
    _MAKE_CALL_
}

- (void)processLogout {
    self.token = nil;
    [self.handler drupal_loggedOut];
}

- (void)whoisonline:(id<DrupalResponseHandler>)responseHandler offset:(int)offset {
    self.handler = responseHandler;
    NSString *url = [NSString stringWithFormat:@"drupalmd/online/%d", offset];
    NSURLRequest *request = [self getRequest:url
                                       token:TRUE
                                      params:nil];
    NSURLConnection *connection=[[NSURLConnection alloc] initWithRequest:request delegate:self];
    _currentCall = _OPERATION_ONLINE_;
    _MAKE_CALL_
}

- (void)processOnlineUsers:(NSDictionary*)result {
    [self.handler drupal_online_users:result];
}

- (void)siteStatus:(id<DrupalResponseHandler>)responseHandler {
    self.handler = responseHandler;
    NSURLRequest *request = [self getRequest:@"drupalmd/status/"
                                       token:TRUE
                                      params:nil];
    NSURLConnection *connection=[[NSURLConnection alloc] initWithRequest:request delegate:self];
    _currentCall = _OPERATION_STATUS_;
    _MAKE_CALL_
}

- (void)processSiteStatus:(NSDictionary*)result {
    [self.handler drupal_status:result];
}

- (void)siteUpdates:(id<DrupalResponseHandler>)responseHandler {
    self.handler = responseHandler;
    NSURLRequest *request = [self getRequest:@"drupalmd/updates/"
                                       token:TRUE
                                      params:nil];
    NSURLConnection *connection=[[NSURLConnection alloc] initWithRequest:request delegate:self];
    _currentCall = _OPERATION_UPDATES_;
    _MAKE_CALL_
}

- (void)processSiteUpdates:(NSDictionary*)result {
    [self.handler drupal_updates:result];
}

- (void)siteLogs:(id<DrupalResponseHandler>)responseHandler offset:(int)offset {
    self.handler = responseHandler;
    NSString *url = [NSString stringWithFormat:@"drupalmd/log/%d", offset];
    NSURLRequest *request = [self getRequest:url
                                       token:TRUE
                                      params:nil];
    NSURLConnection *connection=[[NSURLConnection alloc] initWithRequest:request delegate:self];
    _currentCall = _OPERATION_LOGS_;
    _MAKE_CALL_
}

- (void)processSiteLogs:(NSDictionary*)result {
    [self.handler drupal_logs:result];
}

- (void)siteLogEvent:(id<DrupalResponseHandler>)responseHandler event:(int)event {
    self.handler = responseHandler;
    NSString *url = [NSString stringWithFormat:@"drupalmd/log/event/%d", event];
    NSURLRequest *request = [self getRequest:url
                                       token:TRUE
                                      params:nil];
    NSURLConnection *connection=[[NSURLConnection alloc] initWithRequest:request delegate:self];
    _currentCall = _OPERATION_LOG_ITEM_;
    _MAKE_CALL_
}

- (void)processSiteLogEvent:(NSDictionary*)result {
    [self.handler drupal_log_event:result];
}

//
// Utility code
//

- (void)displayAlert:(NSString*)message {
    [self displayAlert:message title:nil];
}

- (void)displayAlert:(NSString*)message title:(NSString*)title {
    
    [[[UIAlertView alloc]
      initWithTitle: title?title:@""
      message: message
      delegate: nil
      cancelButtonTitle: @"Ok"
      otherButtonTitles: nil] show];

}

- (NSString *)description {
    return [NSString stringWithFormat:@"DrupalClient; Name: %@; Address: %@; Authenticated: %@",
            self.name,
            self.address,
            self.token?@"YES":@"NO"
            ];
}

@end
