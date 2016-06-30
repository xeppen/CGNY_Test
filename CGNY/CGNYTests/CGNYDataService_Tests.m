//
//  CGNYDataService_Tests.m
//  CGNY
//
//  Created by Sebastian Ljungberg on 30/06/16.
//  Copyright © 2016 Xeppen Productions. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <OCMock/OCMock.h>
#import "CGNYDataService.h"

@interface CGNYDataService_Tests : XCTestCase

@end

@implementation CGNYDataService_Tests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testSampleFetchOfPhotos {
    
    XCTestExpectation *fetchCompletionExpectation =
    [self expectationWithDescription:@"Successfully fetched photos!"];
    
    // Mock Session
    // Creates an NSURLSession instance that shall be used in the service.
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    id myMockedURLSession = OCMPartialMock(session);
    
    OCMStub([myMockedURLSession dataTaskWithRequest:[OCMArg any] completionHandler:[OCMArg any]]).andDo(^(NSInvocation *invocation){
        
        __block void (^completion)(NSData *data, NSURLResponse *response, NSError *error);
        
        // Get second argument
        [invocation getArgument:&completion atIndex:3];
        NSData *testData = [NSData dataWithContentsOfFile:[[NSBundle bundleForClass:[self class]] pathForResource:@"sampleFetchPhotos" ofType:@"json"]];
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
            completion(testData, nil, nil);
        });
    });
    
    // Mock class
    // Mocking the class to return our mocked session to be returned in our static method in the service.
    id myMockedSessionClass = OCMClassMock([NSURLSession class]);
    
    OCMStub([myMockedSessionClass sessionWithConfiguration: [OCMArg any]]).andReturn(myMockedURLSession);
    
    [CGNYDataService fetchImagesWithSearchString:@"" withCompletion:^(NSArray *imagesDataObjects, NSError *error) {
        if(imagesDataObjects.count == 20)
            [fetchCompletionExpectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:10 handler:^(NSError *error) {
        // Stop mocking
        [myMockedSessionClass stopMocking];
    }];
}

- (void)testSampleFetchError {
    
    XCTestExpectation *fetchCompletionExpectation =
    [self expectationWithDescription:@"Successfully handled network error!"];
    
    // Mock Session
    // Creates an NSURLSession instance that shall be used in the service.
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    id myMockedURLSession = OCMPartialMock(session);
    
    OCMStub([myMockedURLSession dataTaskWithRequest:[OCMArg any] completionHandler:[OCMArg any]]).andDo(^(NSInvocation *invocation){
        
        __block void (^completion)(NSData *data, NSURLResponse *response, NSError *error);
        
        // Get second argument
        [invocation getArgument:&completion atIndex:3];
        NSData *testData = [NSData dataWithContentsOfFile:[[NSBundle bundleForClass:[self class]] pathForResource:@"sampleFetchError" ofType:@"json"]];
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
            completion(testData, nil, nil);
        });
    });
    
    // Mock class
    // Mocking the class to return our mocked session to be returned in our static method in the service.
    id myMockedSessionClass = OCMClassMock([NSURLSession class]);
    
    OCMStub([myMockedSessionClass sessionWithConfiguration: [OCMArg any]]).andReturn(myMockedURLSession);
    
    [CGNYDataService fetchImagesWithSearchString:@"" withCompletion:^(NSArray *imagesDataObjects, NSError *error) {
        if(error)
            [fetchCompletionExpectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:10 handler:^(NSError *error) {
        // Stop mocking
        [myMockedSessionClass stopMocking];
    }];
}


@end
