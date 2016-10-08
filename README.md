# SDWebServiceManager
SDWebServiceManager is an easy way to implement synchronous request to web server using NSURLSession for iOS.

## Installation

Just drag SDWebServiceManager.h and SDWebServiceManager.m files in your application from the project.
The purpose of this Web service manager is to show how we can create our own custom calendar with minimum code.

## Features
•	Synchronous request using semaphore.
•	Single method can be use for GET/POST method.
•	Basic Authentication.
•	Facebook Post.
•	Twitter Post.

## Basic usage
You have to follow the below steps:
•	Only Copy this header and implementation file in your application.

•	All methods are class methods so don’t need to create any instance of SDWebServiceManager class.

•	Pass your URL string with parameters for GET method, you don’t need to pass data Dictionary if you are calling GET method.

•	GET is default method, you can avoid passing it if you want to use GET method.


## Implementation

### Ex.  Basic Auth Call .

    [SDWebServiceManager initWithWebServiceJSON:loginDict onCompletion:^(id dataDict,NSError *error,BOOL success){

            if(!error){
                if (dataDict!=nil || dataDict) {
                    NSLog(@"%@",dataDict);
                }
            }else
                NSLog(@"%@",error.localizedDescription);
        }];

### Ex.  POST Method

    NSDictionary *tokenDict = [[NSDictionary alloc] initWithObjectsAndKeys:@"value",@"key",NULL];

    NSDictionary *resultDataDict = [SDWebServiceManager sendSynchronousRequestWithUrl:@"urlstring" Method:@"POST" andData:tokenDict];
    NSLog(@"result = %@",resultDataDict);



### Ex. Get Method

    NSDictionary *resultData = [SDWebServiceManager sendSynchronousRequestWithUrl:@"urlstring" Method:nil andData:nil];
    NSLog(@"result = %@",resultData);


## Requirements
•	iOS8 or higher
•	Automatic Reference Counting (ARC)

## Author
	Stark digital Media Services Pvt. Ltd.

## License
SDCalendar is released under the MIT license. See the LICENSE file for more info.

