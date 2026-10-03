package net.aihelp.core.net.mqtt.hawtdispatch;

import java.util.Iterator;
import java.util.LinkedList;
import java.util.concurrent.Executor;

public class AggregatingExecutor implements Executor {
    final DispatchQueue queue;
    final CustomDispatchSource<Runnable, LinkedList<Runnable>> source;

    public AggregatingExecutor(DispatchQueue dispatchQueue) {
        this.queue = dispatchQueue;
        CustomDispatchSource<Runnable, LinkedList<Runnable>> customDispatchSourceCreateSource = Dispatch.createSource(EventAggregators.linkedList(), dispatchQueue);
        this.source = customDispatchSourceCreateSource;
        customDispatchSourceCreateSource.setEventHandler(new Task() {
            @Override
            public void run() {
                Iterator<Runnable> it = AggregatingExecutor.this.source.getData().iterator();
                while (it.hasNext()) {
                    try {
                        it.next().run();
                    } catch (Exception e) {
                        Thread threadCurrentThread = Thread.currentThread();
                        threadCurrentThread.getUncaughtExceptionHandler().uncaughtException(threadCurrentThread, e);
                    }
                }
            }
        });
        customDispatchSourceCreateSource.resume();
    }

    public void suspend() {
        this.source.suspend();
    }

    public void resume() {
        this.source.resume();
    }

    @Override
    public void execute(Runnable runnable) {
        if (Dispatch.getCurrentQueue() == null) {
            this.queue.execute((Task) new TaskWrapper(runnable));
        } else {
            this.source.merge(runnable);
        }
    }
}
