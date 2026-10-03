package cn.thinkingdata.android.p004p;

import android.content.SharedPreferences;
import java.util.concurrent.Future;

public class C0741c extends AbstractC0739a<Integer> {

    private final int f240d;

    public C0741c(Future<SharedPreferences> future, int i) {
        super(future, "flushBulkSize");
        this.f240d = i;
    }

    @Override
    public void mo675a(SharedPreferences.Editor editor, Integer num) {
        editor.putInt(this.f238b, num.intValue());
        editor.apply();
    }

    @Override
    void mo676a(SharedPreferences sharedPreferences) {
        this.f237a = Integer.valueOf(sharedPreferences.getInt(this.f238b, this.f240d));
    }
}
