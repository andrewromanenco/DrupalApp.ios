//
//  DrupalClient.h
//  DrupalApp
//
//  Created by Andrew Romanenco on 2013-01-19.
//  Copyright (c) 2013 Andrew Romanenco. All rights reserved.
//

#import <Foundation/Foundation.h>


// Protocol for response handler
@protocol DrupalResponseHandler <NSObject>

@optional

// *** Handlers ***

// DrupalApi presents
// (service -> version)
- (void)drupal_info:(NSDictionary*)info;

// Logged in
- (void)drupal_loggedIn;

// Logged out
- (void)drupal_loggedOut;

// *** Service handlers ***

// Who is online
- (void)drupal_online_users:(NSDictionary*)users;

// Site status
- (void)drupal_status:(NSDictionary*)data;

// Site updates
- (void)drupal_updates:(NSDictionary*)data;

// Site logs
- (void)drupal_logs:(NSDictionary*)data;

// Singe site event
- (void)drupal_log_event:(NSDictionary*)data;

// *** Error handlers ***

// Network error, was not able to connect
- (void)drupal_networkError;

// 401
- (void)drupal_unauthorized;

// 403
- (void)drupal_forbidden;

// 404
- (void)drupal_notFound;

// Is called if no handler for 4*
- (void)drupal_fail:(NSInteger)status;

// 5*
- (void)drupal_error:(NSInteger)status;

// exec just before starting call
- (void)drupal_call_start;

// exec right after call is done
- (void)drupal_call_end;

@end



// Class for DrupalMD module api access
// Has to be initialized with name (i.e. "My site")site URL (i.e. https://www.somesite.com/ )
@interface DrupalClient : NSObject

@property (strong) NSString *name;
@property (strong) NSString *address;
@property (strong) NSString *token;
@property (strong, readonly) NSString *username;
@property (weak) id<DrupalResponseHandler> handler;

// Create drupal api point
- (id)init:(NSString*)name url:(NSString*)url;

// Get available services from web site
- (void)getDrupalInfo:(id<DrupalResponseHandler>)handler;

// Check if site has old module
//- (void)hasOldDrupalModule;

// Open user session, token will be stored in DrupalClient instance
- (void)login:(id<DrupalResponseHandler>)responseHandler username:(NSString*)username password:(NSString*)password;

// Logout
- (void)logout:(id<DrupalResponseHandler>)handler;

//
// Services
//

// Online users
- (void)whoisonline:(id<DrupalResponseHandler>)handler offset:(int)offset;

// Get site status
- (void)siteStatus:(id<DrupalResponseHandler>)handler;

// Available site updates
- (void)siteUpdates:(id<DrupalResponseHandler>)handler;

// View drupal log messages
- (void)siteLogs:(id<DrupalResponseHandler>)handler offset:(int)offset;

// View drupal log messages
- (void)siteLogEvent:(id<DrupalResponseHandler>)handler event:(int)event;

@end
