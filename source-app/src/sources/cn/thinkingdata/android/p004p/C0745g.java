package cn.thinkingdata.android.p004p;

import android.content.SharedPreferences;
import java.util.concurrent.Future;

public class C0745g extends AbstractC0739a<Boolean> {
    public C0745g(Future<SharedPreferences> future) {
        super(future, "optOutFlag");
    }

    @Override
    public void mo675a(SharedPreferences.Editor editor, Boolean bool) {
        editor.putBoolean(this.f238b, bool.booleanValue());
        editor.apply();
    }

    @Override
    protected void mo676a(SharedPreferences sharedPreferences) {
        this.f237a = Boolean.valueOf(sharedPreferences.getBoolean(this.f238b, false));
    }
}
