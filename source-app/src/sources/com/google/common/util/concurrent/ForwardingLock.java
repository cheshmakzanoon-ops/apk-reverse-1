package com.google.common.util.concurrent;

import java.util.concurrent.TimeUnit;
import java.util.concurrent.locks.Condition;
import java.util.concurrent.locks.Lock;

@ElementTypesAreNonnullByDefault
abstract class ForwardingLock implements Lock {
    abstract Lock delegate();

    ForwardingLock() {
    }

    @Override
    public void lock() {
        delegate().lock();
    }

    @Override
    public void lockInterruptibly() throws InterruptedException {
        delegate().lockInterruptibly();
    }

    @Override
    public boolean tryLock() {
        return delegate().tryLock();
    }

    @Override
    public boolean tryLock(long j, TimeUnit timeUnit) throws InterruptedException {
        return delegate().tryLock(j, timeUnit);
    }

    @Override
    public void unlock() {
        delegate().unlock();
    }

    @Override
    public Condition newCondition() {
        return delegate().newCondition();
    }
}
