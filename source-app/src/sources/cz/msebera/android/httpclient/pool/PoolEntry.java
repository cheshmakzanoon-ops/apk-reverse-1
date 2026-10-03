package cz.msebera.android.httpclient.pool;

import cz.msebera.android.httpclient.util.Args;
import java.util.concurrent.TimeUnit;
import kotlin.jvm.internal.LongCompanionObject;

public abstract class PoolEntry<T, C> {
    private final C conn;
    private final long created;
    private long expiry;

    private final String f27id;
    private final T route;
    private volatile Object state;
    private long updated;
    private final long validUnit;

    public abstract void close();

    public abstract boolean isClosed();

    public PoolEntry(String str, T t, C c, long j, TimeUnit timeUnit) {
        Args.notNull(t, "Route");
        Args.notNull(c, "Connection");
        Args.notNull(timeUnit, "Time unit");
        this.f27id = str;
        this.route = t;
        this.conn = c;
        long jCurrentTimeMillis = System.currentTimeMillis();
        this.created = jCurrentTimeMillis;
        if (j > 0) {
            this.validUnit = jCurrentTimeMillis + timeUnit.toMillis(j);
        } else {
            this.validUnit = LongCompanionObject.MAX_VALUE;
        }
        this.expiry = this.validUnit;
    }

    public PoolEntry(String str, T t, C c) {
        this(str, t, c, 0L, TimeUnit.MILLISECONDS);
    }

    public String getId() {
        return this.f27id;
    }

    public T getRoute() {
        return this.route;
    }

    public C getConnection() {
        return this.conn;
    }

    public long getCreated() {
        return this.created;
    }

    public long getValidUnit() {
        return this.validUnit;
    }

    public Object getState() {
        return this.state;
    }

    public void setState(Object obj) {
        this.state = obj;
    }

    public synchronized long getUpdated() {
        return this.updated;
    }

    public synchronized long getExpiry() {
        return this.expiry;
    }

    public synchronized void updateExpiry(long j, TimeUnit timeUnit) {
        Args.notNull(timeUnit, "Time unit");
        long jCurrentTimeMillis = System.currentTimeMillis();
        this.updated = jCurrentTimeMillis;
        this.expiry = Math.min(j > 0 ? jCurrentTimeMillis + timeUnit.toMillis(j) : LongCompanionObject.MAX_VALUE, this.validUnit);
    }

    public synchronized boolean isExpired(long j) {
        return j >= this.expiry;
    }

    public String toString() {
        return "[id:" + this.f27id + "][route:" + this.route + "][state:" + this.state + "]";
    }
}
