#ifndef ios_util_taskexecutor_h
#define ios_util_taskexecutor_h

typedef void(^Task)();
typedef void(^SuccessTask)();
typedef void(^ErrorTask)(NSError *);

@interface TaskExecutor : NSObject

-(void)execute:(Task)task;
-(void)execute:(Task)task continuation:(Task)continuation;
-(void)execute:(Task)task success:(SuccessTask)success error:(ErrorTask)error;

-(void)execute:(Task)task continueInBackground:(Task)continuation;
-(void)execute:(Task)task continueInBackground:(Task)continuation success:(SuccessTask)success error:(ErrorTask)error;

-(void)execute:(Task)task continueOnMainThread:(Task)continuation;
-(void)execute:(Task)task continueOnMainThread:(Task)continuation success:(SuccessTask)success error:(ErrorTask)error;

@end

#endif
