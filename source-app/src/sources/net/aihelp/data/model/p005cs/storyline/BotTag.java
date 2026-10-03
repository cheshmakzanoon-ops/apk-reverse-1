package net.aihelp.data.model.p005cs.storyline;

import net.aihelp.core.net.json.Jsonable;
import org.json.JSONObject;

public class BotTag implements Jsonable {
    private int tagId;
    private String tagName;

    public BotTag(int i, String str) {
        this.tagId = i;
        this.tagName = str;
    }

    public int getTagId() {
        return this.tagId;
    }

    public void setTagId(int i) {
        this.tagId = i;
    }

    public String getTagName() {
        return this.tagName;
    }

    public void setTagName(String str) {
        this.tagName = str;
    }

    @Override
    public JSONObject toJsonObject() {
        JSONObject jSONObject = new JSONObject();
        try {
            jSONObject.put("id", this.tagId);
            jSONObject.put("name", this.tagName);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return jSONObject;
    }
}
