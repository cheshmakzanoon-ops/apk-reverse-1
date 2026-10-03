package net.aihelp.data.model.config;

import java.util.List;

public class IntentEntity {
    private int intentId;
    private List<IntentEntity> intentList;
    private String intentName;

    public int getIntentId() {
        return this.intentId;
    }

    public void setIntentId(int i) {
        this.intentId = i;
    }

    public String getIntentName() {
        return this.intentName;
    }

    public void setIntentName(String str) {
        this.intentName = str;
    }

    public List<IntentEntity> getIntentList() {
        return this.intentList;
    }

    public void setIntentList(List<IntentEntity> list) {
        this.intentList = list;
    }
}
