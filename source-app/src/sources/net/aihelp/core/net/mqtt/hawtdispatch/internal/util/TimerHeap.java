package net.aihelp.core.net.mqtt.hawtdispatch.internal.util;

import java.util.ArrayList;
import java.util.Iterator;
import java.util.LinkedList;
import java.util.List;
import java.util.TreeMap;
import java.util.concurrent.TimeUnit;

public abstract class TimerHeap<V> {
    private final TreeMap<Long, LinkedList<V>> timers = new TreeMap<>();
    private final TimeUnit resolution = TimeUnit.NANOSECONDS;
    private int size = 0;

    public abstract void execute(V v);

    public final void addAbsolute(V v, long j, TimeUnit timeUnit) {
        long jNanoTime = System.nanoTime();
        TimeUnit timeUnit2 = this.resolution;
        addInternal(v, jNanoTime + timeUnit2.convert(timeUnit2.convert(j, timeUnit), timeUnit));
    }

    public final void addRelative(V v, long j, TimeUnit timeUnit) {
        addInternal(v, System.nanoTime() + this.resolution.convert(j, timeUnit));
    }

    private void addInternal(V v, long j) {
        LinkedList<V> linkedList = new LinkedList<>();
        linkedList.add(v);
        LinkedList<V> linkedListPut = this.timers.put(Long.valueOf(j), linkedList);
        if (linkedListPut != null) {
            linkedList.addAll(linkedListPut);
        }
        this.size++;
    }

    public int size() {
        return this.size;
    }

    public final long timeToNext(TimeUnit timeUnit) {
        if (this.timers.isEmpty()) {
            return -1L;
        }
        return timeUnit.convert(Math.max(0L, this.timers.firstKey().longValue() - System.nanoTime()), this.resolution);
    }

    public final void executeReadyTimers() {
        if (this.timers.isEmpty()) {
            return;
        }
        long jNanoTime = System.nanoTime();
        long jLongValue = this.timers.firstKey().longValue();
        if (jLongValue > jNanoTime) {
            return;
        }
        LinkedList linkedList = new LinkedList();
        while (jLongValue <= jNanoTime) {
            linkedList.addAll(this.timers.remove(Long.valueOf(jLongValue)));
            if (this.timers.isEmpty()) {
                break;
            } else {
                jLongValue = this.timers.firstKey().longValue();
            }
        }
        Iterator it = linkedList.iterator();
        while (it.hasNext()) {
            try {
                execute(it.next());
                this.size--;
            } catch (Throwable th) {
                Thread threadCurrentThread = Thread.currentThread();
                threadCurrentThread.getUncaughtExceptionHandler().uncaughtException(threadCurrentThread, th);
            }
        }
    }

    public List<V> clear() {
        ArrayList arrayList = new ArrayList(size());
        Iterator<LinkedList<V>> it = this.timers.values().iterator();
        while (it.hasNext()) {
            arrayList.addAll(it.next());
        }
        this.timers.clear();
        return arrayList;
    }
}
