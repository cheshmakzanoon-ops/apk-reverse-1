package ru.mopsicus.mobileinput;

import org.json.JSONException;
import org.json.JSONObject;
import ru.mopsicus.common.Common;

public class KeyboardListener implements KeyboardObserver {
    private boolean isPreviousState = false;
    private Common common = new Common();

    @Override
    public void onKeyboardHeight(float f, int i, int i2, float f2, float f3, String str, String str2) {
        boolean z = i > 0;
        JSONObject jSONObject = new JSONObject();
        try {
            jSONObject.put("msg", Plugin.KEYBOARD_ACTION);
            jSONObject.put("show", z);
            jSONObject.put("height", f);
            jSONObject.put("lratio", f2);
            jSONObject.put("rratio", f3);
            jSONObject.put("extraMsg", str);
            jSONObject.put("id", str2);
        } catch (JSONException unused) {
        }
        this.isPreviousState = z;
        this.common.sendData(Plugin.name, jSONObject.toString());
    }
}
