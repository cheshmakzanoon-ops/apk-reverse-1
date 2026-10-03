package net.aihelp.core.p004ui.glide.load.engine.bitmap_recycle;

import java.util.Queue;
import net.aihelp.core.p004ui.glide.load.engine.bitmap_recycle.Poolable;
import net.aihelp.core.p004ui.glide.util.Util;

abstract class BaseKeyPool<T extends Poolable> {
    private static final int MAX_SIZE = 20;
    private final Queue<T> keyPool = Util.createQueue(20);

    protected abstract T create();

    BaseKeyPool() {
    }

    protected T get() {
        T tPoll = this.keyPool.poll();
        return tPoll == null ? (T) create() : tPoll;
    }

    public void offer(T t) {
        if (this.keyPool.size() < 20) {
            this.keyPool.offer(t);
        }
    }
}
