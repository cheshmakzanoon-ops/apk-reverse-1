package cn.thinkingdata.android.p004p;

import android.content.SharedPreferences;
import java.util.concurrent.Future;

public class C0742d extends AbstractC0739a<Integer> {

    private final int f241d;

    public C0742d(Future<SharedPreferences> future, int i) {
        super(future, "flushInterval");
        this.f241d = i;
    }

    @Override
    public void mo675a(SharedPreferences.Editor editor, Integer num) {
        editor.putInt(this.f238b, num.intValue());
        editor.apply();
    }

    @Override
    void mo676a(SharedPreferences sharedPreferences) {
        this.f237a = Integer.valueOf(sharedPreferences.getInt(this.f238b, this.f241d));
    }
}
