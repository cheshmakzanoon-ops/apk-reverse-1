package com.google.common.util.concurrent;

import com.google.common.base.Preconditions;
import com.google.common.base.Supplier;
import j$.util.Objects;
import java.util.concurrent.Callable;
import java.util.concurrent.Executor;
import java.util.concurrent.Executors;
import java.util.concurrent.Future;
import java.util.concurrent.ScheduledExecutorService;
import java.util.concurrent.ScheduledFuture;
import java.util.concurrent.ThreadFactory;
import java.util.concurrent.TimeUnit;
import java.util.concurrent.TimeoutException;
import java.util.concurrent.locks.ReentrantLock;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.annotation.CheckForNull;

@ElementTypesAreNonnullByDefault
public abstract class AbstractScheduledService implements Service {
    private static final Logger logger = Logger.getLogger(AbstractScheduledService.class.getName());
    private final AbstractService delegate = new ServiceDelegate();

    interface Cancellable {
        void cancel(boolean z);

        boolean isCancelled();
    }

    protected abstract void runOneIteration() throws Exception;

    protected abstract Scheduler scheduler();

    protected void shutDown() throws Exception {
    }

    protected void startUp() throws Exception {
    }

    public static abstract class Scheduler {
        abstract Cancellable schedule(AbstractService abstractService, ScheduledExecutorService scheduledExecutorService, Runnable runnable);

        public static Scheduler newFixedDelaySchedule(final long j, final long j2, final TimeUnit timeUnit) {
            Preconditions.checkNotNull(timeUnit);
            Preconditions.checkArgument(j2 > 0, "delay must be > 0, found %s", j2);
            return new Scheduler() {
                {
                    super();
                }

                @Override
                public Cancellable schedule(AbstractService abstractService, ScheduledExecutorService scheduledExecutorService, Runnable runnable) {
                    return new FutureAsCancellable(scheduledExecutorService.scheduleWithFixedDelay(runnable, j, j2, timeUnit));
                }
            };
        }

        public static Scheduler newFixedRateSchedule(final long j, final long j2, final TimeUnit timeUnit) {
            Preconditions.checkNotNull(timeUnit);
            Preconditions.checkArgument(j2 > 0, "period must be > 0, found %s", j2);
            return new Scheduler() {
                {
                    super();
                }

                @Override
                public Cancellable schedule(AbstractService abstractService, ScheduledExecutorService scheduledExecutorService, Runnable runnable) {
                    return new FutureAsCancellable(scheduledExecutorService.scheduleAtFixedRate(runnable, j, j2, timeUnit));
                }
            };
        }

        private Scheduler() {
        }
    }

    private final class ServiceDelegate extends AbstractService {

        @CheckForNull
        private volatile ScheduledExecutorService executorService;
        private final ReentrantLock lock;

        @CheckForNull
        private volatile Cancellable runningTask;
        private final Runnable task;

        private ServiceDelegate() {
            this.lock = new ReentrantLock();
            this.task = new Task();
        }

        class Task implements Runnable {
            Task() {
            }

            @Override
            public void run() {
                ServiceDelegate.this.lock.lock();
                try {
                    if (((Cancellable) Objects.requireNonNull(ServiceDelegate.this.runningTask)).isCancelled()) {
                        ServiceDelegate.this.lock.unlock();
                        return;
                    }
                    AbstractScheduledService.this.runOneIteration();
                } catch (Throwable th) {
                    try {
                        try {
                            AbstractScheduledService.this.shutDown();
                        } catch (Exception e) {
                            AbstractScheduledService.logger.log(Level.WARNING, "Error while attempting to shut down the service after failure.", (Throwable) e);
                        }
                        ServiceDelegate.this.notifyFailed(th);
                        ((Cancellable) Objects.requireNonNull(ServiceDelegate.this.runningTask)).cancel(false);
                    } finally {
                        ServiceDelegate.this.lock.unlock();
                    }
                }
            }
        }

        @Override
        protected final void doStart() {
            this.executorService = MoreExecutors.renamingDecorator(AbstractScheduledService.this.executor(), new Supplier<String>() {
                @Override
                public String get() {
                    String strServiceName = AbstractScheduledService.this.serviceName();
                    String strValueOf = String.valueOf(ServiceDelegate.this.state());
                    StringBuilder sb = new StringBuilder(String.valueOf(strServiceName).length() + 1 + String.valueOf(strValueOf).length());
                    sb.append(strServiceName);
                    sb.append(" ");
                    sb.append(strValueOf);
                    return sb.toString();
                }
            });
            this.executorService.execute(new Runnable() {
                @Override
                public void run() {
                    ServiceDelegate.this.lock.lock();
                    try {
                        AbstractScheduledService.this.startUp();
                        ServiceDelegate serviceDelegate = ServiceDelegate.this;
                        serviceDelegate.runningTask = AbstractScheduledService.this.scheduler().schedule(AbstractScheduledService.this.delegate, ServiceDelegate.this.executorService, ServiceDelegate.this.task);
                        ServiceDelegate.this.notifyStarted();
                    } catch (Throwable th) {
                        try {
                            ServiceDelegate.this.notifyFailed(th);
                            if (ServiceDelegate.this.runningTask != null) {
                                ServiceDelegate.this.runningTask.cancel(false);
                            }
                        } finally {
                            ServiceDelegate.this.lock.unlock();
                        }
                    }
                }
            });
        }

        @Override
        protected final void doStop() {
            Objects.requireNonNull(this.runningTask);
            Objects.requireNonNull(this.executorService);
            this.runningTask.cancel(false);
            this.executorService.execute(new Runnable() {
                @Override
                public void run() {
                    try {
                        ServiceDelegate.this.lock.lock();
                        try {
                            if (ServiceDelegate.this.state() != Service.State.STOPPING) {
                                ServiceDelegate.this.lock.unlock();
                                return;
                            }
                            AbstractScheduledService.this.shutDown();
                            ServiceDelegate.this.lock.unlock();
                            ServiceDelegate.this.notifyStopped();
                        } catch (Throwable th) {
                            ServiceDelegate.this.lock.unlock();
                            throw th;
                        }
                    } catch (Throwable th2) {
                        ServiceDelegate.this.notifyFailed(th2);
                    }
                }
            });
        }

        @Override
        public String toString() {
            return AbstractScheduledService.this.toString();
        }
    }

    protected AbstractScheduledService() {
    }

    protected ScheduledExecutorService executor() {
        final ScheduledExecutorService scheduledExecutorServiceNewSingleThreadScheduledExecutor = Executors.newSingleThreadScheduledExecutor(new ThreadFactory() {
            @Override
            public Thread newThread(Runnable runnable) {
                return MoreExecutors.newThread(AbstractScheduledService.this.serviceName(), runnable);
            }
        });
        addListener(new Service.Listener(this) {
            @Override
            public void terminated(Service.State state) {
                scheduledExecutorServiceNewSingleThreadScheduledExecutor.shutdown();
            }

            @Override
            public void failed(Service.State state, Throwable th) {
                scheduledExecutorServiceNewSingleThreadScheduledExecutor.shutdown();
            }
        }, MoreExecutors.directExecutor());
        return scheduledExecutorServiceNewSingleThreadScheduledExecutor;
    }

    protected String serviceName() {
        return getClass().getSimpleName();
    }

    public String toString() {
        String strServiceName = serviceName();
        String strValueOf = String.valueOf(state());
        StringBuilder sb = new StringBuilder(String.valueOf(strServiceName).length() + 3 + String.valueOf(strValueOf).length());
        sb.append(strServiceName);
        sb.append(" [");
        sb.append(strValueOf);
        sb.append("]");
        return sb.toString();
    }

    @Override
    public final boolean isRunning() {
        return this.delegate.isRunning();
    }

    @Override
    public final Service.State state() {
        return this.delegate.state();
    }

    @Override
    public final void addListener(Service.Listener listener, Executor executor) {
        this.delegate.addListener(listener, executor);
    }

    @Override
    public final Throwable failureCause() {
        return this.delegate.failureCause();
    }

    @Override
    public final Service startAsync() {
        this.delegate.startAsync();
        return this;
    }

    @Override
    public final Service stopAsync() {
        this.delegate.stopAsync();
        return this;
    }

    @Override
    public final void awaitRunning() {
        this.delegate.awaitRunning();
    }

    @Override
    public final void awaitRunning(long j, TimeUnit timeUnit) throws TimeoutException {
        this.delegate.awaitRunning(j, timeUnit);
    }

    @Override
    public final void awaitTerminated() {
        this.delegate.awaitTerminated();
    }

    @Override
    public final void awaitTerminated(long j, TimeUnit timeUnit) throws TimeoutException {
        this.delegate.awaitTerminated(j, timeUnit);
    }

    private static final class FutureAsCancellable implements Cancellable {
        private final Future<?> delegate;

        FutureAsCancellable(Future<?> future) {
            this.delegate = future;
        }

        @Override
        public void cancel(boolean z) {
            this.delegate.cancel(z);
        }

        @Override
        public boolean isCancelled() {
            return this.delegate.isCancelled();
        }
    }

    public static abstract class CustomScheduler extends Scheduler {
        protected abstract Schedule getNextSchedule() throws Exception;

        public CustomScheduler() {
            super();
        }

        private final class ReschedulableCallable implements Callable<Void> {

            @CheckForNull
            private SupplantableFuture cancellationDelegate;
            private final ScheduledExecutorService executor;
            private final ReentrantLock lock = new ReentrantLock();
            private final AbstractService service;
            private final Runnable wrappedRunnable;

            ReschedulableCallable(AbstractService abstractService, ScheduledExecutorService scheduledExecutorService, Runnable runnable) {
                this.wrappedRunnable = runnable;
                this.executor = scheduledExecutorService;
                this.service = abstractService;
            }

            @Override
            @CheckForNull
            public Void call() throws Exception {
                this.wrappedRunnable.run();
                reschedule();
                return null;
            }

            public Cancellable reschedule() {
                Cancellable futureAsCancellable;
                try {
                    Schedule nextSchedule = CustomScheduler.this.getNextSchedule();
                    this.lock.lock();
                    try {
                        futureAsCancellable = initializeOrUpdateCancellationDelegate(nextSchedule);
                        this.lock.unlock();
                        th = null;
                    } catch (Throwable th) {
                        th = th;
                        try {
                            futureAsCancellable = new FutureAsCancellable(Futures.immediateCancelledFuture());
                            this.lock.unlock();
                        } catch (Throwable th2) {
                            this.lock.unlock();
                            throw th2;
                        }
                    }
                    if (th != null) {
                        this.service.notifyFailed(th);
                    }
                    return futureAsCancellable;
                } catch (Throwable th3) {
                    this.service.notifyFailed(th3);
                    return new FutureAsCancellable(Futures.immediateCancelledFuture());
                }
            }

            private Cancellable initializeOrUpdateCancellationDelegate(Schedule schedule) {
                SupplantableFuture supplantableFuture = this.cancellationDelegate;
                if (supplantableFuture == null) {
                    SupplantableFuture supplantableFuture2 = new SupplantableFuture(this.lock, submitToExecutor(schedule));
                    this.cancellationDelegate = supplantableFuture2;
                    return supplantableFuture2;
                }
                if (!supplantableFuture.currentFuture.isCancelled()) {
                    this.cancellationDelegate.currentFuture = submitToExecutor(schedule);
                }
                return this.cancellationDelegate;
            }

            private ScheduledFuture<Void> submitToExecutor(Schedule schedule) {
                return this.executor.schedule(this, schedule.delay, schedule.unit);
            }
        }

        private static final class SupplantableFuture implements Cancellable {
            private Future<Void> currentFuture;
            private final ReentrantLock lock;

            SupplantableFuture(ReentrantLock reentrantLock, Future<Void> future) {
                this.lock = reentrantLock;
                this.currentFuture = future;
            }

            @Override
            public void cancel(boolean z) {
                this.lock.lock();
                try {
                    this.currentFuture.cancel(z);
                } finally {
                    this.lock.unlock();
                }
            }

            @Override
            public boolean isCancelled() {
                this.lock.lock();
                try {
                    return this.currentFuture.isCancelled();
                } finally {
                    this.lock.unlock();
                }
            }
        }

        @Override
        final Cancellable schedule(AbstractService abstractService, ScheduledExecutorService scheduledExecutorService, Runnable runnable) {
            return new ReschedulableCallable(abstractService, scheduledExecutorService, runnable).reschedule();
        }

        protected static final class Schedule {
            private final long delay;
            private final TimeUnit unit;

            public Schedule(long j, TimeUnit timeUnit) {
                this.delay = j;
                this.unit = (TimeUnit) Preconditions.checkNotNull(timeUnit);
            }
        }
    }
}
