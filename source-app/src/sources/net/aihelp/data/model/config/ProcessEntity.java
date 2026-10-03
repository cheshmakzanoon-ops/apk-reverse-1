package net.aihelp.data.model.config;

import java.util.ArrayList;
import java.util.List;
import org.json.JSONArray;

public class ProcessEntity {
    private boolean enableInteraction;
    private String entranceId;
    private String faqEntrances;
    private String faqId;
    private int intent;
    private String sectionId;
    private List<IntentEntity> smartIntentList = new ArrayList();
    private String smartIntentName;
    private String tags;
    private String trackActiveId;
    private String visitId;

    public String getTrackActiveId() {
        return this.trackActiveId;
    }

    public void setTrackActiveId(String str) {
        this.trackActiveId = str;
    }

    public int getIntent() {
        return this.intent;
    }

    public void setIntent(int i) {
        this.intent = i;
    }

    public String getVisitId() {
        return this.visitId;
    }

    public void setVisitId(String str) {
        this.visitId = str;
    }

    public String getFaqId() {
        return this.faqId;
    }

    public void setFaqId(String str) {
        this.faqId = str;
    }

    public String getSectionId() {
        return this.sectionId;
    }

    public void setSectionId(String str) {
        this.sectionId = str;
    }

    public String getTags() {
        return this.tags;
    }

    public void setTags(JSONArray jSONArray) {
        this.tags = getStringFromJsonArray(jSONArray);
    }

    public String getFaqEntrances() {
        return this.faqEntrances;
    }

    public void setFaqEntrances(JSONArray jSONArray) {
        this.faqEntrances = getStringFromJsonArray(jSONArray);
    }

    public boolean isEnableInteraction() {
        return this.enableInteraction;
    }

    public void setEnableInteraction(boolean z) {
        this.enableInteraction = z;
    }

    public String getSmartIntentName() {
        return this.smartIntentName;
    }

    public void setSmartIntentName(String str) {
        this.smartIntentName = str;
    }

    public List<IntentEntity> getSmartIntentList() {
        return this.smartIntentList;
    }

    public void setSmartIntentList(List<IntentEntity> list) {
        this.smartIntentList = list;
    }

    private String getStringFromJsonArray(JSONArray jSONArray) {
        StringBuilder sb = new StringBuilder();
        if (jSONArray != null) {
            for (int i = 0; i < jSONArray.length(); i++) {
                sb.append(jSONArray.optString(i));
                if (i != jSONArray.length() - 1) {
                    sb.append(",");
                }
            }
        }
        return sb.toString();
    }

    public String getEntranceId() {
        return this.entranceId;
    }

    public void setEntranceId(String str) {
        this.entranceId = str;
    }
}
