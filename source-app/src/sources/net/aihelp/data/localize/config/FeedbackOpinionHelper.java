package net.aihelp.data.localize.config;

import android.util.SparseArray;
import net.aihelp.core.net.json.JsonHelper;
import org.json.JSONArray;
import org.json.JSONObject;

public enum FeedbackOpinionHelper {
    INSTANCE;

    private SparseArray<JSONArray> opinionArray = new SparseArray<>();

    FeedbackOpinionHelper() {
    }

    public SparseArray<JSONArray> getOpinionArray() {
        return this.opinionArray;
    }

    public void prepareDataSource(JSONArray jSONArray) {
        if (jSONArray != null) {
            int i = 0;
            while (i < jSONArray.length()) {
                try {
                    JSONObject jsonObject = JsonHelper.getJsonObject(jSONArray, i);
                    i++;
                    this.opinionArray.put(i, JsonHelper.getJsonArray(jsonObject, "satisfyList"));
                } catch (Exception e) {
                    e.printStackTrace();
                    return;
                }
            }
        }
    }
}
