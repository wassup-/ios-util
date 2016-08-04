#import "TaskExecutor.h"

@implementation TaskExecutor

-(void)execute:(Task)task {

}

-(void)execute:(Task)task continuation:(Task)continuation {

}

-(void)execute:(Task)task continuation:(Task)continuation {

}

-(void)execute:(Task)task continueInBackground:(Task)continuation success:(Task)success error:(Task)error {
  [self execute: task
   continuation: ^{
                   dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),
                                  continuation);
                 }
        success: success
          error: error];
}

-(void)execute:(Task)task continueOnMainThread:(Task)continuation success:(Task)success error:(Task)error {
  [self execute: task
   continuation: ^{
                   dispatch_async(dispatch_get_main_queue(),
                                  continuation);
                 }
        success: success
          error: error];
}


@end
