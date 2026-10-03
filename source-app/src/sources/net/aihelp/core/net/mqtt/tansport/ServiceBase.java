package net.aihelp.core.net.mqtt.tansport;

import java.util.Iterator;
import java.util.LinkedList;
import net.aihelp.core.net.mqtt.hawtdispatch.DispatchQueue;
import net.aihelp.core.net.mqtt.hawtdispatch.Task;
import net.aihelp.core.net.mqtt.hawtdispatch.TaskWrapper;

public abstract class ServiceBase {
    public static final State CREATED = new State();
    public static final State STARTED = new State() {
        @Override
        public boolean isStarted() {
            return true;
        }
    };
    public static final State STOPPED = new State();
    protected State _serviceState = CREATED;

    public static class STARTING extends CallbackSupport {
        @Override
        public boolean isStarting() {
            return true;
        }
    }

    public static class STOPPING extends CallbackSupport {
    }

    protected abstract void _start(Task task);

    protected abstract void _stop(Task task);

    public abstract DispatchQueue getDispatchQueue();

    public static class State {
        public boolean isStarted() {
            return false;
        }

        public boolean isStarting() {
            return false;
        }

        public String toString() {
            return getClass().getSimpleName();
        }
    }

    static class CallbackSupport extends State {
        LinkedList<Task> callbacks = new LinkedList<>();

        CallbackSupport() {
        }

        void add(Task task) {
            if (task != null) {
                this.callbacks.add(task);
            }
        }

        void done() {
            Iterator<Task> it = this.callbacks.iterator();
            while (it.hasNext()) {
                it.next().run();
            }
        }
    }

    public final void start(Runnable runnable) {
        start((Task) new TaskWrapper(runnable));
    }

    public final void start(final Task task) {
        getDispatchQueue().execute(new Task() {
            @Override
            public void run() {
                if (ServiceBase.this._serviceState == ServiceBase.CREATED || ServiceBase.this._serviceState == ServiceBase.STOPPED) {
                    final STARTING starting = new STARTING();
                    starting.add(task);
                    ServiceBase.this._serviceState = starting;
                    ServiceBase.this._start(new Task() {
                        @Override
                        public void run() {
                            ServiceBase.this._serviceState = ServiceBase.STARTED;
                            starting.done();
                        }
                    });
                    return;
                }
                if (ServiceBase.this._serviceState instanceof STARTING) {
                    ((STARTING) ServiceBase.this._serviceState).add(task);
                    return;
                }
                if (ServiceBase.this._serviceState == ServiceBase.STARTED) {
                    Task task2 = task;
                    if (task2 != null) {
                        task2.run();
                        return;
                    }
                    return;
                }
                Task task3 = task;
                if (task3 != null) {
                    task3.run();
                }
                ServiceBase.this.error("start should not be called from state: " + ServiceBase.this._serviceState);
            }
        });
    }

    public final void stop(Runnable runnable) {
        stop((Task) new TaskWrapper(runnable));
    }

    public final void stop(final Task task) {
        getDispatchQueue().execute(new Task() {
            @Override
            public void run() {
                if (ServiceBase.this._serviceState == ServiceBase.STARTED) {
                    final STOPPING stopping = new STOPPING();
                    stopping.add(task);
                    ServiceBase.this._serviceState = stopping;
                    ServiceBase.this._stop(new Task() {
                        @Override
                        public void run() {
                            ServiceBase.this._serviceState = ServiceBase.STOPPED;
                            stopping.done();
                        }
                    });
                    return;
                }
                if (ServiceBase.this._serviceState instanceof STOPPING) {
                    ((STOPPING) ServiceBase.this._serviceState).add(task);
                    return;
                }
                if (ServiceBase.this._serviceState == ServiceBase.STOPPED) {
                    Task task2 = task;
                    if (task2 != null) {
                        task2.run();
                        return;
                    }
                    return;
                }
                Task task3 = task;
                if (task3 != null) {
                    task3.run();
                }
                ServiceBase.this.error("stop should not be called from state: " + ServiceBase.this._serviceState);
            }
        });
    }

    public void error(String str) {
        try {
            throw new AssertionError(str);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    protected State getServiceState() {
        return this._serviceState;
    }
}
