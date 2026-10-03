package cn.thinkingdata.android.p004p;

import android.content.SharedPreferences;
import cn.thinkingdata.android.utils.C0766q;
import java.util.concurrent.Future;

public class C0747i extends AbstractC0739a<String> {
    public C0747i(Future<SharedPreferences> future) {
        super(future, "randomDeviceID");
    }

    @Override
    public String mo674a() {
        return C0766q.m731a(16);
    }

    @Override
    public void mo675a(SharedPreferences.Editor editor, String str) {
        editor.putString(this.f238b, str);
        editor.apply();
    }

    @Override
    public void mo676a(SharedPreferences sharedPreferences) {
        this.f237a = sharedPreferences.getString(this.f238b, "");
    }
}
