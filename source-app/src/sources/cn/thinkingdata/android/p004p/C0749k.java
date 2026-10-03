package cn.thinkingdata.android.p004p;

import android.content.SharedPreferences;
import java.util.concurrent.Future;
import org.json.JSONException;
import org.json.JSONObject;

public class C0749k extends AbstractC0739a<JSONObject> {
    public C0749k(Future<SharedPreferences> future) {
        super(future, "superProperties");
    }

    @Override
    public JSONObject mo674a() {
        return new JSONObject();
    }

    @Override
    public void mo675a(SharedPreferences.Editor editor, JSONObject jSONObject) {
        editor.putString(this.f238b, jSONObject == null ? null : jSONObject.toString());
        editor.apply();
    }

    @Override
    void mo676a(SharedPreferences sharedPreferences) {
        String string = sharedPreferences.getString(this.f238b, null);
        if (string == null) {
            m677a(mo674a());
            return;
        }
        try {
            this.f237a = new JSONObject(string);
        } catch (JSONException e) {
            e.printStackTrace();
        }
    }
}
