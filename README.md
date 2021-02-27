# MGLogger

This library is mainly used to facilitate manual log management and support data caching

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

### code
1>、Initialize the logger with following code
~~~
#import <MGLogger/MGLogger.h>
...
[MGLogger mg_startWithConfig:^(MGConfig * _Nonnull config) {
    // Detection interval when there are no elements in the queue
    config.detectionInterval = 10.0f;
    // Maximum number of records returned at one time
    config.maxReturnCount = 10;
    // Log processing block
    // param: items:Batch data returned at one time
    // return: Whether the returned current data is deleted from the cache, YES:deleted，otherwise will not to be deleted
    config.runBlock = ^BOOL(NSArray<id<MGCaching>> * _Nonnull items) {
        NSLog(@"arrObjs = %@", items);
        return YES;
    };
}];
...
~~~

2>、Add the following code where you need to collect logs
~~~
#import <MGLogger/MGLogger.h>
...
mgLog(@"1");
...
~~~
3>、The parameter description about the mgLog macro  
The parameter is an object that implements MGCaching protocol，The NSString and NSMutableString types have implemented this protocol. In this library, so you can use it directly. If you use other type objects as parameters, this type must to implement this protocol

## Requirements

## Installation

MGLogger is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

pod 'MGLogger'

## Author

mszdream, mszdream@126.com

## License

MGLogger is available under the MIT license. See the LICENSE file for more info.
