package net.aihelp.core.net.mqtt.hawtdispatch;

import java.io.InputStream;
import java.io.PrintWriter;
import java.io.StringWriter;
import java.util.ArrayList;
import java.util.Collections;
import java.util.HashSet;
import java.util.Iterator;
import java.util.Properties;
import java.util.concurrent.atomic.AtomicInteger;

public class BaseRetained implements Retained {
    static HashSet<String> CALLERS;
    private static final int MAX_TRACES = Integer.getInteger("org.fusesource.hawtdispatch.BaseRetained.MAX_TRACES", 100).intValue();
    private static final boolean TRACE;
    private volatile Task disposer;
    private final AtomicInteger retained = new AtomicInteger(1);
    private final ArrayList<String> traces;

    public BaseRetained() {
        this.traces = TRACE ? new ArrayList<>(MAX_TRACES + 1) : null;
    }

    static {
        boolean z = Boolean.getBoolean("org.fusesource.hawtdispatch.BaseRetained.TRACE");
        TRACE = z;
        CALLERS = new HashSet<>();
        if (z) {
            Properties properties = new Properties();
            InputStream resourceAsStream = BaseRetained.class.getResourceAsStream("BaseRetained.CALLERS");
            try {
                try {
                    properties.load(resourceAsStream);
                } catch (Throwable th) {
                    try {
                        resourceAsStream.close();
                    } catch (Exception unused) {
                    }
                    throw th;
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
            try {
                resourceAsStream.close();
            } catch (Exception unused2) {
            }
            Iterator it = Collections.list(properties.keys()).iterator();
            while (it.hasNext()) {
                CALLERS.add((String) it.next());
            }
        }
    }

    public final void setDisposer(Runnable runnable) {
        setDisposer((Task) new TaskWrapper(runnable));
    }

    public final void setDisposer(Task task) {
        this.disposer = task;
    }

    public final Task getDisposer() {
        return this.disposer;
    }

    @Override
    public final void retain() {
        if (TRACE) {
            synchronized (this.traces) {
                trace("retained", this.retained.incrementAndGet());
            }
            return;
        }
        this.retained.getAndIncrement();
    }

    @Override
    public final void release() {
        if (TRACE) {
            synchronized (this.traces) {
                int iDecrementAndGet = this.retained.decrementAndGet();
                trace("released", iDecrementAndGet);
                if (iDecrementAndGet == 0) {
                    dispose();
                    trace("disposed", iDecrementAndGet);
                }
            }
            return;
        }
        if (this.retained.decrementAndGet() == 0) {
            dispose();
        }
    }

    protected final void release(int i) {
        if (TRACE) {
            synchronized (this.traces) {
                int iAddAndGet = this.retained.addAndGet(-i);
                trace("released " + i, iAddAndGet);
                if (iAddAndGet == 0) {
                    trace("disposed", iAddAndGet);
                    dispose();
                }
            }
            return;
        }
        if (this.retained.addAndGet(-i) == 0) {
            dispose();
        }
    }

    protected final void assertRetained() {
        if (TRACE) {
            synchronized (this.traces) {
                if (this.retained.get() <= 0) {
                    throw new AssertionError(String.format("%s: Use of object not allowed after it has been released. %s", toString(), this.traces));
                }
            }
        }
    }

    @Override
    public final int retained() {
        return this.retained.get();
    }

    protected void dispose() {
        Task task = this.disposer;
        if (task != null) {
            task.run();
        }
    }

    private final void trace(final String str, final int i) {
        int size = this.traces.size();
        int i2 = MAX_TRACES;
        if (size < i2) {
            Exception exc = new Exception() {
                @Override
                public String toString() {
                    return "Trace " + (BaseRetained.this.traces.size() + 1) + ": " + str + ", counter: " + i + ", thread: " + Thread.currentThread().getName();
                }
            };
            if (squash(exc.getStackTrace()) == null) {
                StringWriter stringWriter = new StringWriter();
                exc.printStackTrace(new PrintWriter(stringWriter));
                this.traces.add("\n" + stringWriter);
                return;
            }
            return;
        }
        if (this.traces.size() == i2) {
            this.traces.add("MAX_TRACES reached... no more traces will be recorded.");
        }
    }

    private static String squash(StackTraceElement[] stackTraceElementArr) {
        if (stackTraceElementArr.length <= 2) {
            return null;
        }
        String str = stackTraceElementArr[2].getClassName() + "." + stackTraceElementArr[2].getMethodName();
        if (CALLERS.contains(str)) {
            return str;
        }
        return null;
    }
}
