//JGReadWriteLock.h
#import <Foundation/Foundation.h>
#import <pthread.h>
 
@interface JGReadWriteLock : NSObject <NSLocking> {
	pthread_rwlock_t lock;
}
 
- (void) lockForWriting;
- (BOOL) tryLock;
- (BOOL) tryLockForWriting;
 
@end
