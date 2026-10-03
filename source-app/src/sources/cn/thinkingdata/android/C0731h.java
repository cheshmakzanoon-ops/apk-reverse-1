package cn.thinkingdata.android;

import android.content.Context;
import android.content.SharedPreferences;
import java.util.concurrent.Callable;
import java.util.concurrent.Executor;
import java.util.concurrent.Executors;
import java.util.concurrent.Future;
import java.util.concurrent.FutureTask;

class C0731h {

    private final Executor f195a = Executors.newSingleThreadExecutor();

    private static class a implements Callable<SharedPreferences> {

        private final Context f196a;

        private final String f197b;

        public a(Context context, String str) {
            this.f196a = context;
            this.f197b = str;
        }

        @Override
        public SharedPreferences call() {
            return this.f196a.getSharedPreferences(this.f197b, 0);
        }
    }

    public Future<SharedPreferences> m527a(Context context, String str) {
        FutureTask futureTask = new FutureTask(new a(context, str));
        this.f195a.execute(futureTask);
        return futureTask;
    }
}
