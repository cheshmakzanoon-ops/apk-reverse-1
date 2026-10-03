package net.aihelp.data.localize.data;

import android.text.TextUtils;
import j$.util.concurrent.ConcurrentHashMap;
import java.util.Map;
import net.aihelp.core.net.json.JsonHelper;
import net.aihelp.data.localize.util.LocalizeUtil;
import net.aihelp.utils.FileUtil;
import org.json.JSONArray;
import org.json.JSONObject;

public enum LocaleStringHelper {
    INSTANCE;

    private final Map<String, String> stringMap = new ConcurrentHashMap();

    LocaleStringHelper() {
    }

    public void reset() {
        this.stringMap.clear();
    }

    public void prepareDataSource() {
        try {
            String contentFromFile = FileUtil.getContentFromFile(LocalizeUtil.getFileLocation(1005));
            if (TextUtils.isEmpty(contentFromFile)) {
                return;
            }
            JSONArray jSONArray = new JSONArray(contentFromFile);
            for (int i = 0; i < jSONArray.length(); i++) {
                JSONObject jsonObject = JsonHelper.getJsonObject(jSONArray, i);
                this.stringMap.put(jsonObject.optString("code"), jsonObject.optString("value"));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public String getString(String str) {
        return this.stringMap.get(str);
    }
}
