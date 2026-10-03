package net.aihelp.core.net.mqtt.util;

import java.util.ArrayList;

public abstract class ThreadLocalPool<T> {
    private final ThreadLocal<ThreadLocalPool<T>.Pool> objectsThreadLocal = new ThreadLocal<>();

    protected abstract T create();

    protected int maxPoolSizePerThread() {
        return 10;
    }

    class Pool {
        long hitCounter;
        long missCounter;
        final ArrayList<T> objects;

        Pool() {
            this.objects = new ArrayList<>(ThreadLocalPool.this.maxPoolSizePerThread());
        }
    }

    private ThreadLocalPool<T>.Pool getPool() {
        ThreadLocalPool<T>.Pool pool = this.objectsThreadLocal.get();
        if (pool != null) {
            return pool;
        }
        ThreadLocalPool<T>.Pool pool2 = new Pool();
        this.objectsThreadLocal.set(pool2);
        return pool2;
    }

    public T checkout() {
        ThreadLocalPool<T>.Pool pool = getPool();
        ArrayList<T> arrayList = pool.objects;
        if (!arrayList.isEmpty()) {
            pool.hitCounter++;
            return arrayList.remove(arrayList.size() - 1);
        }
        pool.missCounter++;
        return create();
    }

    public void checkin(T t) {
        ArrayList<T> arrayList = getPool().objects;
        if (arrayList.size() < maxPoolSizePerThread()) {
            arrayList.add(t);
        }
    }
}
