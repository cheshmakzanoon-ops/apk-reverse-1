package net.aihelp.core.net.mqtt.hawtdispatch.internal.util;

import java.util.concurrent.CountDownLatch;
import net.aihelp.core.net.mqtt.hawtdispatch.DispatchQueue;
import net.aihelp.core.net.mqtt.hawtdispatch.Task;
import net.aihelp.core.net.mqtt.hawtdispatch.TaskWrapper;

public class QueueSupport {
    public static void dispatchApply(DispatchQueue dispatchQueue, int i, Runnable runnable) throws InterruptedException {
        dispatchApply(dispatchQueue, i, (Task) new TaskWrapper(runnable));
    }

    public static void dispatchApply(DispatchQueue dispatchQueue, int i, final Task task) throws InterruptedException {
        final CountDownLatch countDownLatch = new CountDownLatch(i);
        Task task2 = new Task() {
            @Override
            public void run() {
                try {
                    task.run();
                } finally {
                    countDownLatch.countDown();
                }
            }
        };
        for (int i2 = 0; i2 < i; i2++) {
            dispatchQueue.execute(task2);
        }
        countDownLatch.await();
    }
}
