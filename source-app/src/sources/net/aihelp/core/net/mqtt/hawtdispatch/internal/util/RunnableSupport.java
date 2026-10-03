package net.aihelp.core.net.mqtt.hawtdispatch.internal.util;

import java.util.concurrent.atomic.AtomicInteger;
import net.aihelp.core.net.mqtt.hawtdispatch.DispatchQueue;
import net.aihelp.core.net.mqtt.hawtdispatch.Task;
import net.aihelp.core.net.mqtt.hawtdispatch.TaskWrapper;

public class RunnableSupport {
    private static Task NO_OP = new Task() {
        @Override
        public void run() {
        }

        public String toString() {
            return "{}";
        }
    };

    public static Task runNoop() {
        return NO_OP;
    }

    public static Task runOnceAfter(Runnable runnable, int i) {
        return runOnceAfter((Task) new TaskWrapper(runnable), i);
    }

    public static Task runOnceAfter(final Task task, int i) {
        if (task == null) {
            return NO_OP;
        }
        if (i == 0) {
            task.run();
            return NO_OP;
        }
        if (i == 1) {
            return task;
        }
        final AtomicInteger atomicInteger = new AtomicInteger(i);
        return new Task() {
            @Override
            public void run() {
                if (atomicInteger.decrementAndGet() == 0) {
                    task.run();
                }
            }

            public String toString() {
                return "{" + task + "}";
            }
        };
    }

    public static Task runAfter(Runnable runnable, int i) {
        return runAfter((Task) new TaskWrapper(runnable), i);
    }

    public static Task runAfter(final Task task, int i) {
        if (i <= 0 || task == null) {
            return NO_OP;
        }
        if (i == 1) {
            return task;
        }
        final AtomicInteger atomicInteger = new AtomicInteger(i);
        return new Task() {
            @Override
            public void run() {
                if (atomicInteger.decrementAndGet() <= 0) {
                    task.run();
                }
            }

            public String toString() {
                return "{" + task + "}";
            }
        };
    }

    public static Task runOnceAfter(DispatchQueue dispatchQueue, Runnable runnable, int i) {
        return runOnceAfter(dispatchQueue, (Task) new TaskWrapper(runnable), i);
    }

    public static Task runOnceAfter(final DispatchQueue dispatchQueue, final Task task, int i) {
        if (i <= 0 || task == null) {
            return NO_OP;
        }
        final AtomicInteger atomicInteger = new AtomicInteger(i);
        return new Task() {
            @Override
            public void run() {
                if (atomicInteger.decrementAndGet() == 0) {
                    dispatchQueue.execute(task);
                }
            }

            public String toString() {
                return "{" + task + "}";
            }
        };
    }

    public static Task runAfter(DispatchQueue dispatchQueue, Runnable runnable, int i) {
        return runAfter(dispatchQueue, (Task) new TaskWrapper(runnable), i);
    }

    public static Task runAfter(final DispatchQueue dispatchQueue, final Task task, int i) {
        if (i <= 0 || task == null) {
            return NO_OP;
        }
        final AtomicInteger atomicInteger = new AtomicInteger(i);
        return new Task() {
            @Override
            public void run() {
                if (atomicInteger.decrementAndGet() <= 0) {
                    dispatchQueue.execute(task);
                }
            }

            public String toString() {
                return "{" + task.toString() + "}";
            }
        };
    }
}
