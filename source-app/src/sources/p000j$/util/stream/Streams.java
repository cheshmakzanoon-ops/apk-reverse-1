package p000j$.util.stream;

abstract class Streams {
    static Runnable composeWithExceptions(final Runnable runnable, final Runnable runnable2) {
        return new Runnable() {
            @Override
            public void run() {
                try {
                    runnable.run();
                    runnable2.run();
                } catch (Throwable th) {
                    try {
                        runnable2.run();
                    } catch (Throwable th2) {
                        try {
                            th.addSuppressed(th2);
                        } catch (Throwable unused) {
                        }
                    }
                    throw th;
                }
            }
        };
    }
}
