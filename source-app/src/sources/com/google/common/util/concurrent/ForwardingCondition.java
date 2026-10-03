package com.google.common.util.concurrent;

import java.util.Date;
import java.util.concurrent.TimeUnit;
import java.util.concurrent.locks.Condition;

@ElementTypesAreNonnullByDefault
abstract class ForwardingCondition implements Condition {
    abstract Condition delegate();

    ForwardingCondition() {
    }

    @Override
    public void await() throws InterruptedException {
        delegate().await();
    }

    @Override
    public boolean await(long j, TimeUnit timeUnit) throws InterruptedException {
        return delegate().await(j, timeUnit);
    }

    @Override
    public void awaitUninterruptibly() {
        delegate().awaitUninterruptibly();
    }

    @Override
    public long awaitNanos(long j) throws InterruptedException {
        return delegate().awaitNanos(j);
    }

    @Override
    public boolean awaitUntil(Date date) throws InterruptedException {
        return delegate().awaitUntil(date);
    }

    @Override
    public void signal() {
        delegate().signal();
    }

    @Override
    public void signalAll() {
        delegate().signalAll();
    }
}
