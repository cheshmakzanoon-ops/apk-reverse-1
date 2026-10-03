package net.aihelp.core.p004ui.glide.load.engine.cache;

import java.util.ArrayDeque;
import java.util.HashMap;
import java.util.Map;
import java.util.Queue;
import java.util.concurrent.locks.Lock;
import java.util.concurrent.locks.ReentrantLock;
import net.aihelp.core.p004ui.glide.load.Key;

final class DiskCacheWriteLocker {
    private final Map<Key, WriteLock> locks = new HashMap();
    private final WriteLockPool writeLockPool = new WriteLockPool();

    DiskCacheWriteLocker() {
    }

    void acquire(Key key) {
        WriteLock writeLockObtain;
        synchronized (this) {
            writeLockObtain = this.locks.get(key);
            if (writeLockObtain == null) {
                writeLockObtain = this.writeLockPool.obtain();
                this.locks.put(key, writeLockObtain);
            }
            writeLockObtain.interestedThreads++;
        }
        writeLockObtain.lock.lock();
    }

    void release(Key key) {
        WriteLock writeLock;
        synchronized (this) {
            writeLock = this.locks.get(key);
            if (writeLock != null && writeLock.interestedThreads > 0) {
                int i = writeLock.interestedThreads - 1;
                writeLock.interestedThreads = i;
                if (i == 0) {
                    WriteLock writeLockRemove = this.locks.remove(key);
                    if (!writeLockRemove.equals(writeLock)) {
                        throw new IllegalStateException("Removed the wrong lock, expected to remove: " + writeLock + ", but actually removed: " + writeLockRemove + ", key: " + key);
                    }
                    this.writeLockPool.offer(writeLockRemove);
                }
            }
            StringBuilder sb = new StringBuilder("Cannot release a lock that is not held, key: ");
            sb.append(key);
            sb.append(", interestedThreads: ");
            sb.append(writeLock == null ? 0 : writeLock.interestedThreads);
            throw new IllegalArgumentException(sb.toString());
        }
        writeLock.lock.unlock();
    }

    private static class WriteLock {
        int interestedThreads;
        final Lock lock;

        private WriteLock() {
            this.lock = new ReentrantLock();
        }
    }

    private static class WriteLockPool {
        private static final int MAX_POOL_SIZE = 10;
        private final Queue<WriteLock> pool;

        private WriteLockPool() {
            this.pool = new ArrayDeque();
        }

        WriteLock obtain() {
            WriteLock writeLockPoll;
            synchronized (this.pool) {
                writeLockPoll = this.pool.poll();
            }
            return writeLockPoll == null ? new WriteLock() : writeLockPoll;
        }

        void offer(WriteLock writeLock) {
            synchronized (this.pool) {
                if (this.pool.size() < 10) {
                    this.pool.offer(writeLock);
                }
            }
        }
    }
}
