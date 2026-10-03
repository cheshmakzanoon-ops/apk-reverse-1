package cn.thinkingdata.android.p004p;

import android.content.SharedPreferences;
import java.util.concurrent.ExecutionException;
import java.util.concurrent.Future;

public abstract class AbstractC0739a<T> {

    protected T f237a;

    final String f238b;

    private final Future<SharedPreferences> f239c;

    AbstractC0739a(Future<SharedPreferences> future, String str) {
        this.f239c = future;
        this.f238b = str;
    }

    private SharedPreferences.Editor m673c() {
        SharedPreferences sharedPreferences;
        try {
            sharedPreferences = this.f239c.get();
        } catch (InterruptedException e) {
            e.printStackTrace();
            sharedPreferences = null;
        } catch (ExecutionException e2) {
            e2.printStackTrace();
            sharedPreferences = null;
        }
        if (sharedPreferences != null) {
            return sharedPreferences.edit();
        }
        return null;
    }

    T mo674a() {
        return null;
    }

    void mo675a(SharedPreferences.Editor editor, T t) {
        editor.putString(this.f238b, (String) t);
        editor.apply();
    }

    void mo676a(SharedPreferences sharedPreferences) {
        T t = (T) sharedPreferences.getString(this.f238b, null);
        if (t == null) {
            m677a(mo674a());
        } else {
            this.f237a = t;
        }
    }

    public void m677a(T t) {
        this.f237a = t;
        synchronized (this.f239c) {
            SharedPreferences.Editor editorM673c = m673c();
            if (editorM673c != null) {
                mo675a(editorM673c, this.f237a);
            }
        }
    }

    public T m678b() {
        SharedPreferences sharedPreferences;
        if (this.f237a == null) {
            synchronized (this.f239c) {
                try {
                    try {
                        sharedPreferences = this.f239c.get();
                    } catch (InterruptedException e) {
                        e.printStackTrace();
                        sharedPreferences = null;
                    }
                } catch (ExecutionException e2) {
                    e2.printStackTrace();
                    sharedPreferences = null;
                }
                if (sharedPreferences != null) {
                    mo676a(sharedPreferences);
                }
            }
        }
        return this.f237a;
    }
}
