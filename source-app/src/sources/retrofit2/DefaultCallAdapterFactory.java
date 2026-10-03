package retrofit2;

import j$.util.Objects;
import java.io.IOException;
import java.lang.annotation.Annotation;
import java.lang.reflect.ParameterizedType;
import java.lang.reflect.Type;
import java.util.concurrent.Executor;
import javax.annotation.Nullable;
import okhttp3.Request;
import okio.Timeout;

final class DefaultCallAdapterFactory extends CallAdapter.Factory {

    @Nullable
    private final Executor callbackExecutor;

    DefaultCallAdapterFactory(@Nullable Executor executor) {
        this.callbackExecutor = executor;
    }

    @Override
    @Nullable
    public CallAdapter<?, ?> get(Type type, Annotation[] annotationArr, Retrofit retrofit) {
        if (getRawType(type) != Call.class) {
            return null;
        }
        if (!(type instanceof ParameterizedType)) {
            throw new IllegalArgumentException("Call return type must be parameterized as Call<Foo> or Call<? extends Foo>");
        }
        final Type parameterUpperBound = Utils.getParameterUpperBound(0, (ParameterizedType) type);
        final Executor executor = Utils.isAnnotationPresent(annotationArr, SkipCallbackExecutor.class) ? null : this.callbackExecutor;
        return new CallAdapter<Object, Call<?>>() {
            @Override
            public Type responseType() {
                return parameterUpperBound;
            }

            @Override
            public Call<?> adapt(Call<Object> call) {
                return executor == null ? call : new ExecutorCallbackCall(executor, call);
            }
        };
    }

    static final class ExecutorCallbackCall<T> implements Call<T> {
        final Executor callbackExecutor;
        final Call<T> delegate;

        ExecutorCallbackCall(Executor executor, Call<T> call) {
            this.callbackExecutor = executor;
            this.delegate = call;
        }

        @Override
        public void enqueue(Callback<T> callback) {
            Objects.requireNonNull(callback, "callback == null");
            this.delegate.enqueue(new C09131(callback));
        }

        class C09131 implements Callback<T> {
            final Callback val$callback;

            C09131(Callback callback) {
                this.val$callback = callback;
            }

            @Override
            public void onResponse(Call<T> call, final Response<T> response) {
                Executor executor = ExecutorCallbackCall.this.callbackExecutor;
                final Callback callback = this.val$callback;
                executor.execute(new Runnable() {
                    @Override
                    public final void run() {
                        this.f$0.m197xddacc936(callback, response);
                    }
                });
            }

            void m197xddacc936(Callback callback, Response response) {
                if (ExecutorCallbackCall.this.delegate.isCanceled()) {
                    callback.onFailure(ExecutorCallbackCall.this, new IOException("Canceled"));
                } else {
                    callback.onResponse(ExecutorCallbackCall.this, response);
                }
            }

            void m196x714e864(Callback callback, Throwable th) {
                callback.onFailure(ExecutorCallbackCall.this, th);
            }

            @Override
            public void onFailure(Call<T> call, final Throwable th) {
                Executor executor = ExecutorCallbackCall.this.callbackExecutor;
                final Callback callback = this.val$callback;
                executor.execute(new Runnable() {
                    @Override
                    public final void run() {
                        this.f$0.m196x714e864(callback, th);
                    }
                });
            }
        }

        @Override
        public boolean isExecuted() {
            return this.delegate.isExecuted();
        }

        @Override
        public Response<T> execute() throws IOException {
            return this.delegate.execute();
        }

        @Override
        public void cancel() {
            this.delegate.cancel();
        }

        @Override
        public boolean isCanceled() {
            return this.delegate.isCanceled();
        }

        @Override
        public Call<T> clone() {
            return new ExecutorCallbackCall(this.callbackExecutor, this.delegate.clone());
        }

        @Override
        public Request request() {
            return this.delegate.request();
        }

        @Override
        public Timeout timeout() {
            return this.delegate.timeout();
        }
    }
}
