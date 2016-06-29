//
//  CGNYImageData_Tests.m
//  CGNY
//
//  Created by Sebastian Ljungberg on 28/06/16.
//  Copyright © 2016 Xeppen Productions. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "CGNYImageData.h"

@interface CGNYImageData_Tests : XCTestCase

@end

@implementation CGNYImageData_Tests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testInitWithDictionary {
    NSDictionary *testDic = @{
                              @"farm": @8,
                              @"id": @27350153084,
                              @"owner": @"41049565@N08",
                              @"secret":  @"ab7a31df59",
                              @"server":  @"7289",
                              @"title": @"SEAT 850 E (1966) - ALTAYA"
                              };
    
    CGNYImageData *testObject = [[CGNYImageData alloc] initWithDictionary:testDic];
    
    XCTAssertEqual(testObject.title, testDic[@"title"]);
    XCTAssertTrue([testObject.imgUrl isEqualToString:@"https://farm8.staticflickr.com/7289/27350153084_ab7a31df59.jpg"]);
}


@end
