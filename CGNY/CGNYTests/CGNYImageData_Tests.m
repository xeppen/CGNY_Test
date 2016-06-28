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
                                  @"media": @{
                                      @"m": @"https://farm8.staticflickr.com/7320/27886023321_d4f4c1075a_m.jpg"
                                      },
                                  @"published": @"2016-06-28T17:47:32Z",
                                  @"tags": @"cars different types of",
                                  @"title": @"DIFFERENT TYPES OF CARS"
                                  };
    
    CGNYImageData *testObject = [[CGNYImageData alloc] initWithDictionary:testDic];
    
    XCTAssertEqual(testObject.title, testDic[@"title"]);
    XCTAssertEqual(testObject.imgUrl, testDic[@"media"][@"m"]);
}


@end
