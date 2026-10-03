package kotlinx.coroutines.tasks;

import com.google.android.gms.tasks.CancellationTokenSource;
import com.google.android.gms.tasks.OnCompleteListener;
import com.google.android.gms.tasks.RuntimeExecutionException;
import com.google.android.gms.tasks.Task;
import com.google.android.gms.tasks.TaskCompletionSource;
import java.util.concurrent.CancellationException;
import kotlin.Deprecated;
import kotlin.DeprecationLevel;
import kotlin.Metadata;
import kotlin.Result;
import kotlin.ResultKt;
import kotlin.Unit;
import kotlin.coroutines.Continuation;
import kotlin.coroutines.CoroutineContext;
import kotlin.coroutines.intrinsics.IntrinsicsKt;
import kotlin.coroutines.jvm.internal.DebugProbesKt;
import kotlin.jvm.functions.Function1;
import kotlin.jvm.functions.Function2;
import kotlin.sequences.Sequence;
import kotlinx.coroutines.CancellableContinuation;
import kotlinx.coroutines.CancellableContinuationImpl;
import kotlinx.coroutines.ChildHandle;
import kotlinx.coroutines.ChildJob;
import kotlinx.coroutines.CompletableDeferred;
import kotlinx.coroutines.CompletableDeferredKt;
import kotlinx.coroutines.Deferred;
import kotlinx.coroutines.DisposableHandle;
import kotlinx.coroutines.Job;
import kotlinx.coroutines.selects.SelectClause0;
import kotlinx.coroutines.selects.SelectClause1;

@Metadata(m17d1 = {"\u0000\u0018\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0006\u001a\u001c\u0010\u0000\u001a\b\u0012\u0004\u0012\u0002H\u00020\u0001\"\u0004\b\u0000\u0010\u0002*\b\u0012\u0004\u0012\u0002H\u00020\u0003\u001a\u001c\u0010\u0004\u001a\b\u0012\u0004\u0012\u0002H\u00020\u0003\"\u0004\b\u0000\u0010\u0002*\b\u0012\u0004\u0012\u0002H\u00020\u0001\u001a&\u0010\u0004\u001a\b\u0012\u0004\u0012\u0002H\u00020\u0003\"\u0004\b\u0000\u0010\u0002*\b\u0012\u0004\u0012\u0002H\u00020\u00012\u0006\u0010\u0005\u001a\u00020\u0006H\u0007\u001a(\u0010\u0007\u001a\b\u0012\u0004\u0012\u0002H\u00020\u0003\"\u0004\b\u0000\u0010\u0002*\b\u0012\u0004\u0012\u0002H\u00020\u00012\b\u0010\u0005\u001a\u0004\u0018\u00010\u0006H\u0002\u001a\u001e\u0010\b\u001a\u0002H\u0002\"\u0004\b\u0000\u0010\u0002*\b\u0012\u0004\u0012\u0002H\u00020\u0001H\u0086@¢\u0006\u0002\u0010\t\u001a&\u0010\b\u001a\u0002H\u0002\"\u0004\b\u0000\u0010\u0002*\b\u0012\u0004\u0012\u0002H\u00020\u00012\u0006\u0010\u0005\u001a\u00020\u0006H\u0087@¢\u0006\u0002\u0010\n\u001a(\u0010\u000b\u001a\u0002H\u0002\"\u0004\b\u0000\u0010\u0002*\b\u0012\u0004\u0012\u0002H\u00020\u00012\b\u0010\u0005\u001a\u0004\u0018\u00010\u0006H\u0082@¢\u0006\u0002\u0010\n¨\u0006\f"}, m18d2 = {"asTask", "Lcom/google/android/gms/tasks/Task;", "T", "Lkotlinx/coroutines/Deferred;", "asDeferred", "cancellationTokenSource", "Lcom/google/android/gms/tasks/CancellationTokenSource;", "asDeferredImpl", "await", "(Lcom/google/android/gms/tasks/Task;Lkotlin/coroutines/Continuation;)Ljava/lang/Object;", "(Lcom/google/android/gms/tasks/Task;Lcom/google/android/gms/tasks/CancellationTokenSource;Lkotlin/coroutines/Continuation;)Ljava/lang/Object;", "awaitImpl", "kotlinx-coroutines-play-services"}, m19k = 2, m20mv = {2, 0, 0}, m22xi = 48)
public final class TasksKt {
    public static final <T> Task<T> asTask(final Deferred<? extends T> deferred) {
        final CancellationTokenSource cancellationTokenSource = new CancellationTokenSource();
        final TaskCompletionSource taskCompletionSource = new TaskCompletionSource(cancellationTokenSource.getToken());
        deferred.invokeOnCompletion(new Function1() {
            @Override
            public final Object invoke(Object obj) {
                return TasksKt.asTask$lambda$0(cancellationTokenSource, deferred, taskCompletionSource, (Throwable) obj);
            }
        });
        return taskCompletionSource.getTask();
    }

    public static final Unit asTask$lambda$0(CancellationTokenSource cancellationTokenSource, Deferred deferred, TaskCompletionSource taskCompletionSource, Throwable th) {
        if (th instanceof CancellationException) {
            cancellationTokenSource.cancel();
            return Unit.INSTANCE;
        }
        Throwable completionExceptionOrNull = deferred.getCompletionExceptionOrNull();
        if (completionExceptionOrNull == null) {
            taskCompletionSource.setResult(deferred.getCompleted());
        } else {
            Exception exc = completionExceptionOrNull instanceof Exception ? (Exception) completionExceptionOrNull : null;
            if (exc == null) {
                exc = (Exception) new RuntimeExecutionException(completionExceptionOrNull);
            }
            taskCompletionSource.setException(exc);
        }
        return Unit.INSTANCE;
    }

    public static final <T> Deferred<T> asDeferred(Task<T> task) {
        return asDeferredImpl(task, null);
    }

    public static final <T> Deferred<T> asDeferred(Task<T> task, CancellationTokenSource cancellationTokenSource) {
        return asDeferredImpl(task, cancellationTokenSource);
    }

    private static final <T> Deferred<T> asDeferredImpl(Task<T> task, final CancellationTokenSource cancellationTokenSource) {
        final CompletableDeferred completableDeferredCompletableDeferred$default = CompletableDeferredKt.CompletableDeferred$default(null, 1, null);
        if (task.isComplete()) {
            Exception exception = task.getException();
            if (exception == null) {
                if (task.isCanceled()) {
                    Job.DefaultImpls.cancel$default((Job) completableDeferredCompletableDeferred$default, (CancellationException) null, 1, (Object) null);
                } else {
                    completableDeferredCompletableDeferred$default.complete(task.getResult());
                }
            } else {
                completableDeferredCompletableDeferred$default.completeExceptionally(exception);
            }
        } else {
            task.addOnCompleteListener(DirectExecutor.INSTANCE, new OnCompleteListener() {
                public final void onComplete(Task task2) {
                    TasksKt.asDeferredImpl$lambda$1(completableDeferredCompletableDeferred$default, task2);
                }
            });
        }
        if (cancellationTokenSource != null) {
            completableDeferredCompletableDeferred$default.invokeOnCompletion(new Function1() {
                @Override
                public final Object invoke(Object obj) {
                    return TasksKt.asDeferredImpl$lambda$2(cancellationTokenSource, (Throwable) obj);
                }
            });
        }
        return new Deferred<T>() {
            @Override
            public ChildHandle attachChild(ChildJob child) {
                return completableDeferredCompletableDeferred$default.attachChild(child);
            }

            @Override
            public Object await(Continuation<? super T> continuation) {
                return completableDeferredCompletableDeferred$default.await(continuation);
            }

            @Override
            @Deprecated(level = DeprecationLevel.HIDDEN, message = "Since 1.2.0, binary compatibility with versions <= 1.1.x")
            public void cancel() {
                completableDeferredCompletableDeferred$default.cancel();
            }

            @Override
            public void cancel(CancellationException cause) {
                completableDeferredCompletableDeferred$default.cancel(cause);
            }

            @Override
            @Deprecated(level = DeprecationLevel.HIDDEN, message = "Since 1.2.0, binary compatibility with versions <= 1.1.x")
            public boolean cancel(Throwable cause) {
                return completableDeferredCompletableDeferred$default.cancel(cause);
            }

            @Override
            public <R> R fold(R initial, Function2<? super R, ? super CoroutineContext.Element, ? extends R> operation) {
                return (R) completableDeferredCompletableDeferred$default.fold(initial, operation);
            }

            @Override
            public <E extends CoroutineContext.Element> E get(CoroutineContext.Key<E> key) {
                return (E) completableDeferredCompletableDeferred$default.get(key);
            }

            @Override
            public CancellationException getCancellationException() {
                return completableDeferredCompletableDeferred$default.getCancellationException();
            }

            @Override
            public Sequence<Job> getChildren() {
                return completableDeferredCompletableDeferred$default.getChildren();
            }

            @Override
            public T getCompleted() {
                return completableDeferredCompletableDeferred$default.getCompleted();
            }

            @Override
            public Throwable getCompletionExceptionOrNull() {
                return completableDeferredCompletableDeferred$default.getCompletionExceptionOrNull();
            }

            @Override
            public CoroutineContext.Key<?> getKey() {
                return completableDeferredCompletableDeferred$default.getKey();
            }

            @Override
            public SelectClause1<T> getOnAwait() {
                return completableDeferredCompletableDeferred$default.getOnAwait();
            }

            @Override
            public SelectClause0 getOnJoin() {
                return completableDeferredCompletableDeferred$default.getOnJoin();
            }

            @Override
            public Job getParent() {
                return completableDeferredCompletableDeferred$default.getParent();
            }

            @Override
            public DisposableHandle invokeOnCompletion(Function1<? super Throwable, Unit> handler) {
                return completableDeferredCompletableDeferred$default.invokeOnCompletion(handler);
            }

            @Override
            public DisposableHandle invokeOnCompletion(boolean onCancelling, boolean invokeImmediately, Function1<? super Throwable, Unit> handler) {
                return completableDeferredCompletableDeferred$default.invokeOnCompletion(onCancelling, invokeImmediately, handler);
            }

            @Override
            public boolean isActive() {
                return completableDeferredCompletableDeferred$default.isActive();
            }

            @Override
            public boolean isCancelled() {
                return completableDeferredCompletableDeferred$default.isCancelled();
            }

            @Override
            public boolean isCompleted() {
                return completableDeferredCompletableDeferred$default.isCompleted();
            }

            @Override
            public Object join(Continuation<? super Unit> continuation) {
                return completableDeferredCompletableDeferred$default.join(continuation);
            }

            @Override
            public CoroutineContext minusKey(CoroutineContext.Key<?> key) {
                return completableDeferredCompletableDeferred$default.minusKey(key);
            }

            @Override
            public CoroutineContext plus(CoroutineContext context) {
                return completableDeferredCompletableDeferred$default.plus(context);
            }

            @Override
            @Deprecated(level = DeprecationLevel.ERROR, message = "Operator '+' on two Job objects is meaningless. Job is a coroutine context element and `+` is a set-sum operator for coroutine contexts. The job to the right of `+` just replaces the job the left of `+`.")
            public Job plus(Job other) {
                return completableDeferredCompletableDeferred$default.plus(other);
            }

            @Override
            public boolean start() {
                return completableDeferredCompletableDeferred$default.start();
            }
        };
    }

    public static final void asDeferredImpl$lambda$1(CompletableDeferred completableDeferred, Task task) {
        Exception exception = task.getException();
        if (exception == null) {
            if (task.isCanceled()) {
                Job.DefaultImpls.cancel$default((Job) completableDeferred, (CancellationException) null, 1, (Object) null);
                return;
            } else {
                completableDeferred.complete(task.getResult());
                return;
            }
        }
        completableDeferred.completeExceptionally(exception);
    }

    public static final Unit asDeferredImpl$lambda$2(CancellationTokenSource cancellationTokenSource, Throwable th) {
        cancellationTokenSource.cancel();
        return Unit.INSTANCE;
    }

    public static final <T> Object await(Task<T> task, Continuation<? super T> continuation) {
        return awaitImpl(task, null, continuation);
    }

    public static final <T> Object await(Task<T> task, CancellationTokenSource cancellationTokenSource, Continuation<? super T> continuation) {
        return awaitImpl(task, cancellationTokenSource, continuation);
    }

    public static final <T> Object awaitImpl(Task<T> task, final CancellationTokenSource cancellationTokenSource, Continuation<? super T> continuation) throws Exception {
        if (task.isComplete()) {
            Exception exception = task.getException();
            if (exception == null) {
                if (task.isCanceled()) {
                    throw new CancellationException("Task " + task + " was cancelled normally.");
                }
                return task.getResult();
            }
            throw exception;
        }
        CancellableContinuationImpl cancellableContinuationImpl = new CancellableContinuationImpl(IntrinsicsKt.intercepted(continuation), 1);
        cancellableContinuationImpl.initCancellability();
        final CancellableContinuationImpl cancellableContinuationImpl2 = cancellableContinuationImpl;
        task.addOnCompleteListener(DirectExecutor.INSTANCE, new OnCompleteListener() {
            public final void onComplete(Task<T> task2) {
                Exception exception2 = task2.getException();
                if (exception2 == null) {
                    if (task2.isCanceled()) {
                        CancellableContinuation.DefaultImpls.cancel$default(cancellableContinuationImpl2, null, 1, null);
                        return;
                    }
                    Continuation continuation2 = cancellableContinuationImpl2;
                    Result.Companion companion = Result.INSTANCE;
                    continuation2.resumeWith(Result.m296constructorimpl(task2.getResult()));
                    return;
                }
                Continuation continuation3 = cancellableContinuationImpl2;
                Result.Companion companion2 = Result.INSTANCE;
                continuation3.resumeWith(Result.m296constructorimpl(ResultKt.createFailure(exception2)));
            }
        });
        if (cancellationTokenSource != null) {
            cancellableContinuationImpl2.invokeOnCancellation(new Function1<Throwable, Unit>() {
                @Override
                public Unit invoke(Throwable th) {
                    invoke2(th);
                    return Unit.INSTANCE;
                }

                public final void invoke2(Throwable th) {
                    cancellationTokenSource.cancel();
                }
            });
        }
        Object result = cancellableContinuationImpl.getResult();
        if (result == IntrinsicsKt.getCOROUTINE_SUSPENDED()) {
            DebugProbesKt.probeCoroutineSuspended(continuation);
        }
        return result;
    }
}
