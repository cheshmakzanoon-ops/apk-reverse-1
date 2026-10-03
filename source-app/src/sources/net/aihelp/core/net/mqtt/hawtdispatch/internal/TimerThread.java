package net.aihelp.core.net.mqtt.hawtdispatch.internal;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.LinkedList;
import java.util.Map;
import java.util.concurrent.TimeUnit;
import net.aihelp.core.net.mqtt.hawtdispatch.DispatchQueue;
import net.aihelp.core.net.mqtt.hawtdispatch.Task;
import net.aihelp.core.net.mqtt.hawtdispatch.internal.util.TimerHeap;

public final class TimerThread extends Thread {
    private final Object mutex = new Object();
    private ArrayList<TimerRequest> requests = new ArrayList<>();

    enum Type {
        RELATIVE,
        ABSOLUTE,
        SHUTDOWN
    }

    private static final class TimerRequest {
        DispatchQueue target;
        Task task;
        long time;
        Type type;
        TimeUnit unit;

        private TimerRequest() {
        }
    }

    public TimerThread(HawtDispatcher hawtDispatcher) {
        setName(hawtDispatcher.getLabel() + " timer");
        setDaemon(true);
    }

    public final void addAbsolute(Task task, DispatchQueue dispatchQueue, long j, TimeUnit timeUnit) {
        TimerRequest timerRequest = new TimerRequest();
        timerRequest.type = Type.ABSOLUTE;
        timerRequest.time = j;
        timerRequest.unit = timeUnit;
        timerRequest.task = task;
        timerRequest.target = dispatchQueue;
        add(timerRequest);
    }

    public final void addRelative(Task task, DispatchQueue dispatchQueue, long j, TimeUnit timeUnit) {
        TimerRequest timerRequest = new TimerRequest();
        timerRequest.type = Type.RELATIVE;
        timerRequest.time = j;
        timerRequest.unit = timeUnit;
        timerRequest.task = task;
        timerRequest.target = dispatchQueue;
        add(timerRequest);
    }

    public final void shutdown(Task task, DispatchQueue dispatchQueue) {
        TimerRequest timerRequest = new TimerRequest();
        timerRequest.type = Type.SHUTDOWN;
        timerRequest.target = dispatchQueue;
        timerRequest.task = task;
        add(timerRequest);
    }

    private void add(TimerRequest timerRequest) {
        synchronized (this.mutex) {
            this.requests.add(timerRequest);
            this.mutex.notify();
        }
    }

    @Override
    public void run() {
        ArrayList<TimerRequest> arrayList;
        TimerRequest next;
        final HashMap map = new HashMap();
        TimerHeap<TimerRequest> timerHeap = new TimerHeap<TimerRequest>() {
            @Override
            public final void execute(TimerRequest timerRequest) {
                LinkedList linkedList = (LinkedList) map.get(timerRequest.target);
                if (linkedList == null) {
                    linkedList = new LinkedList();
                    map.put(timerRequest.target, linkedList);
                }
                linkedList.add(timerRequest.task);
            }
        };
        ArrayList<TimerRequest> arrayList2 = new ArrayList<>();
        loop0: while (true) {
            try {
                synchronized (this.mutex) {
                    arrayList = this.requests;
                    this.requests = arrayList2;
                }
                if (!arrayList.isEmpty()) {
                    Iterator<TimerRequest> it = arrayList.iterator();
                    while (it.hasNext()) {
                        next = it.next();
                        int i = C05143.f71xe359fbaa[next.type.ordinal()];
                        if (i != 1) {
                            if (i != 2) {
                                if (i == 3) {
                                    break loop0;
                                }
                            } else {
                                timerHeap.addAbsolute(next, next.time, next.unit);
                            }
                        } else {
                            timerHeap.addRelative(next, next.time, next.unit);
                        }
                    }
                    arrayList.clear();
                }
                timerHeap.executeReadyTimers();
                if (!map.isEmpty()) {
                    for (Map.Entry entry : map.entrySet()) {
                        DispatchQueue dispatchQueue = (DispatchQueue) entry.getKey();
                        final LinkedList linkedList = (LinkedList) entry.getValue();
                        if (linkedList.size() > 1) {
                            dispatchQueue.execute(new Task() {
                                @Override
                                public void run() {
                                    Iterator it2 = linkedList.iterator();
                                    while (it2.hasNext()) {
                                        ((Task) it2.next()).run();
                                    }
                                }
                            });
                        } else {
                            dispatchQueue.execute((Task) linkedList.getFirst());
                        }
                    }
                    map.clear();
                }
                long jNanoTime = System.nanoTime();
                long jTimeToNext = timerHeap.timeToNext(TimeUnit.NANOSECONDS);
                if (jTimeToNext != 0) {
                    if (jTimeToNext <= 0 || jTimeToNext >= 1000) {
                        long j = jTimeToNext / 1000000;
                        int i2 = (int) (jTimeToNext % 1000000);
                        synchronized (this.mutex) {
                            if (this.requests.isEmpty()) {
                                if (jTimeToNext == -1) {
                                    this.mutex.wait();
                                } else {
                                    this.mutex.wait(j, i2);
                                }
                            }
                        }
                    } else {
                        while (System.nanoTime() - jNanoTime < jTimeToNext) {
                        }
                    }
                }
                arrayList2 = arrayList;
            } catch (InterruptedException unused) {
                return;
            }
        }
        for (TimerRequest timerRequest : timerHeap.clear()) {
            timerRequest.target.execute(timerRequest.task);
        }
        if (next.task != null) {
            next.task.run();
        }
    }

    static class C05143 {

        static final int[] f71xe359fbaa;

        static {
            int[] iArr = new int[Type.values().length];
            f71xe359fbaa = iArr;
            try {
                iArr[Type.RELATIVE.ordinal()] = 1;
            } catch (NoSuchFieldError unused) {
            }
            try {
                f71xe359fbaa[Type.ABSOLUTE.ordinal()] = 2;
            } catch (NoSuchFieldError unused2) {
            }
            try {
                f71xe359fbaa[Type.SHUTDOWN.ordinal()] = 3;
            } catch (NoSuchFieldError unused3) {
            }
        }
    }
}
