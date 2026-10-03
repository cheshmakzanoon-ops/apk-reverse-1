package cn.thinkingdata.android.p004p;

import android.content.SharedPreferences;
import java.util.UUID;
import java.util.concurrent.Future;

public class C0748j extends AbstractC0739a<String> {
    public C0748j(Future<SharedPreferences> future) {
        super(future, "randomID");
    }

    @Override
    public String mo674a() {
        return UUID.randomUUID().toString();
    }
}
