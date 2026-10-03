package net.aihelp.data.track;

import java.util.ArrayList;
import java.util.List;
import java.util.regex.Matcher;
import java.util.regex.Pattern;
import net.aihelp.data.track.data.TrackEntity;
import net.aihelp.data.track.data.TrackHelper;
import net.aihelp.data.track.data.TrackType;
import net.aihelp.p007ui.p009cs.util.TicketStatusTracker;
import org.json.JSONArray;
import org.json.JSONObject;

public class AIHelpEventTracker {
    public List<String> entranceTrackedEvents;
    public TrackEntity trackEntity;
    public JSONArray trackEventArray;

    private AIHelpEventTracker() {
        this.trackEventArray = new JSONArray();
        this.trackEntity = new TrackEntity("", "");
        this.entranceTrackedEvents = new ArrayList();
        this.trackEventArray = new JSONArray();
        this.trackEntity = new TrackEntity("", "");
        this.entranceTrackedEvents = new ArrayList();
    }

    public static AIHelpEventTracker getInstance() {
        return LazyHolder.HOLDER;
    }

    private static class LazyHolder {
        static final AIHelpEventTracker HOLDER = new AIHelpEventTracker();

        private LazyHolder() {
        }
    }

    public void setupTrackHandler(String str, String str2) {
        this.trackEventArray = new JSONArray();
        this.entranceTrackedEvents = new ArrayList();
        this.trackEntity = new TrackEntity(str, str2);
    }

    public JSONObject getExtendDataForLogin() {
        JSONObject jSONObject = new JSONObject();
        try {
            TrackEntity trackEntity = this.trackEntity;
            if (trackEntity != null) {
                jSONObject.put("entranceId", trackEntity.getEntranceId());
                jSONObject.put("activeId", this.trackEntity.getActiveId());
                jSONObject.put("faqMainId", this.trackEntity.getFaqMainId());
                jSONObject.put("faqContentId", this.trackEntity.getFaqContentId());
                jSONObject.put("sectionId", this.trackEntity.getSectionId());
            }
        } catch (Exception unused) {
        }
        return jSONObject;
    }

    public void setWhenMessageSent() {
        TrackEntity trackEntity = this.trackEntity;
        if (trackEntity != null) {
            trackEntity.setWhenMessageSent(System.currentTimeMillis());
        }
    }

    public void calculateDurationForWaiting() {
        if (this.trackEntity != null) {
            long jCurrentTimeMillis = System.currentTimeMillis() - this.trackEntity.getWhenMessageSent();
            if (jCurrentTimeMillis > 0) {
                JSONObject jSONObject = new JSONObject();
                TrackHelper.addTrackData(jSONObject, "stayTime", Long.valueOf(jCurrentTimeMillis));
                this.trackEventArray.put(TrackHelper.getCommonParams(54, this.trackEntity, jSONObject));
            }
        }
    }

    public void calculateDurationInCustomerService() {
        TrackEntity trackEntity = this.trackEntity;
        if (trackEntity != null) {
            trackEntity.calculateTotalCustomerServiceDuration();
        }
    }

    public void calculateDurationInAIHelp() {
        TrackEntity trackEntity = this.trackEntity;
        if (trackEntity != null) {
            if (trackEntity.getWhenAIHelpVisible() <= 0) {
                return;
            }
            long totalCustomerServiceDuration = this.trackEntity.getTotalCustomerServiceDuration();
            if (totalCustomerServiceDuration >= 1000) {
                JSONObject jSONObject = new JSONObject();
                TrackHelper.addTrackData(jSONObject, "stayTime", Long.valueOf(totalCustomerServiceDuration));
                this.trackEventArray.put(TrackHelper.getCommonParams(53, this.trackEntity, jSONObject));
            }
            long jCurrentTimeMillis = System.currentTimeMillis() - this.trackEntity.getWhenAIHelpVisible();
            if (jCurrentTimeMillis >= 1000) {
                JSONObject jSONObject2 = new JSONObject();
                TrackHelper.addTrackData(jSONObject2, "stayTime", Long.valueOf(jCurrentTimeMillis));
                this.trackEventArray.put(TrackHelper.getCommonParams(51, this.trackEntity, jSONObject2));
            }
            long j = jCurrentTimeMillis - totalCustomerServiceDuration;
            if (j >= 1000) {
                JSONObject jSONObject3 = new JSONObject();
                TrackHelper.addTrackData(jSONObject3, "stayTime", Long.valueOf(j));
                this.trackEventArray.put(TrackHelper.getCommonParams(52, this.trackEntity, jSONObject3));
            }
        }
        TrackHelper.syncTrack(this.trackEventArray);
    }

    public void checkedFAQInBot(int i, String str, String str2) {
        JSONObject jSONObject = new JSONObject();
        TrackHelper.addTrackData(jSONObject, "mainId", str);
        TrackHelper.addTrackData(jSONObject, "contentId", str2);
        TrackHelper.addTrackData(jSONObject, "ticketId", TicketStatusTracker.currentTicketId);
        this.trackEventArray.put(TrackHelper.getCommonParams(i == 1 ? TrackType.TRACK_FAQ_CHECKED_IN_RPA_BOT : TrackType.TRACK_FAQ_CHECKED_IN_ANSWER_BOT, this.trackEntity, jSONObject));
        TrackEntity trackEntity = this.trackEntity;
        if (trackEntity != null) {
            trackEntity.setFaqMainId(str);
            this.trackEntity.setFaqContentId(str2);
        }
    }

    public void checkedFAQ(String str, String str2, String str3) {
        JSONObject jSONObject = new JSONObject();
        TrackHelper.addTrackData(jSONObject, "mainId", str);
        TrackHelper.addTrackData(jSONObject, "contentId", str2);
        TrackHelper.addTrackData(jSONObject, "title", str3);
        this.trackEventArray.put(TrackHelper.getCommonParams(TrackType.TRACK_FAQ_CHECKED, this.trackEntity, jSONObject));
        TrackEntity trackEntity = this.trackEntity;
        if (trackEntity != null) {
            trackEntity.setFaqMainId(str);
            this.trackEntity.setFaqContentId(str2);
        }
    }

    public void markedHelpful(String str, String str2, String str3) {
        JSONObject jSONObject = new JSONObject();
        TrackHelper.addTrackData(jSONObject, "mainId", str);
        TrackHelper.addTrackData(jSONObject, "contentId", str2);
        TrackHelper.addTrackData(jSONObject, "title", str3);
        this.trackEventArray.put(TrackHelper.getCommonParams(TrackType.TRACK_FAQ_MARKED_HELPFUL, this.trackEntity, jSONObject));
    }

    public void markedUnhelpful(String str, String str2, String str3) {
        JSONObject jSONObject = new JSONObject();
        TrackHelper.addTrackData(jSONObject, "mainId", str);
        TrackHelper.addTrackData(jSONObject, "contentId", str2);
        TrackHelper.addTrackData(jSONObject, "title", str3);
        this.trackEventArray.put(TrackHelper.getCommonParams(TrackType.TRACK_FAQ_MARKED_UNHELPFUL, this.trackEntity, jSONObject));
    }

    public void submitSuggestion(String str, String str2, String str3, String str4) {
        JSONObject jSONObject = new JSONObject();
        TrackHelper.addTrackData(jSONObject, "mainId", str);
        TrackHelper.addTrackData(jSONObject, "contentId", str2);
        TrackHelper.addTrackData(jSONObject, "title", str3);
        TrackHelper.addTrackData(jSONObject, "feedback", str4);
        this.trackEventArray.put(TrackHelper.getCommonParams(TrackType.TRACK_FAQ_SUBMIT_SUGGESTION, this.trackEntity, jSONObject));
    }

    public void clickServiceEntranceInFaq(String str) {
        String str2 = String.format("%s-%s", Integer.valueOf(TrackType.TRACK_FAQ_CLICK_CUSTOMER_SERVICE), str);
        if (this.entranceTrackedEvents.contains(str2)) {
            return;
        }
        this.trackEventArray.put(TrackHelper.getCommonParams(TrackType.TRACK_FAQ_CLICK_CUSTOMER_SERVICE, this.trackEntity, new JSONObject[0]));
        this.entranceTrackedEvents.add(str2);
    }

    public void trackSearchQuery(String str) {
        JSONObject jSONObject = new JSONObject();
        TrackHelper.addTrackData(jSONObject, "content", str);
        this.trackEventArray.put(TrackHelper.getCommonParams(TrackType.TRACK_FAQ_SEARCH_CONTENT, this.trackEntity, jSONObject));
    }

    public void onFormClicked(String str) {
        JSONObject jSONObject = new JSONObject();
        TrackHelper.addTrackData(jSONObject, "formId", getFormIdFromUrl(str));
        this.trackEventArray.put(TrackHelper.getCommonParams(TrackType.TRACK_FORM_ACTION_CLICKED, this.trackEntity, jSONObject));
    }

    public void onFormSubmitted(String str) {
        JSONObject jSONObject = new JSONObject();
        TrackHelper.addTrackData(jSONObject, "formId", str);
        this.trackEventArray.put(TrackHelper.getCommonParams(TrackType.TRACK_FORM_ACTION_SUBMITTED, this.trackEntity, jSONObject));
    }

    private String getFormIdFromUrl(String str) {
        Matcher matcher = Pattern.compile("(?<=(formId=))((?!&).)*").matcher(str);
        if (matcher.find()) {
            return matcher.group();
        }
        return "";
    }

    public void clickSearch() {
        String str = String.format("%s", 101);
        if (this.entranceTrackedEvents.contains(str)) {
            return;
        }
        this.trackEventArray.put(TrackHelper.getCommonParams(101, this.trackEntity, new JSONObject[0]));
        this.entranceTrackedEvents.add(str);
    }

    public void clickNotification(String str, String str2, String str3) {
        clickSomeFaq(102, str, str2, str3);
    }

    public void clickHotTopic(String str, String str2, String str3) {
        clickSomeFaq(103, str, str2, str3);
    }

    public void clickFaq(String str, String str2, String str3) {
        clickSomeFaq(TrackType.TRACK_ENTRANCE_CLICK_FAQ, str, str2, str3);
    }

    public void clickSection(String str, String str2) {
        String str3 = String.format("%s-%s", 104, str);
        if (!this.entranceTrackedEvents.contains(str3)) {
            JSONObject jSONObject = new JSONObject();
            TrackHelper.addTrackData(jSONObject, "sectionId", str);
            TrackHelper.addTrackData(jSONObject, "title", str2);
            this.trackEventArray.put(TrackHelper.getCommonParams(104, this.trackEntity, jSONObject));
            this.entranceTrackedEvents.add(str3);
        }
        TrackEntity trackEntity = this.trackEntity;
        if (trackEntity != null) {
            trackEntity.setSectionId(str);
        }
    }

    private void clickSomeFaq(int i, String str, String str2, String str3) {
        String str4 = String.format("%s-%s", Integer.valueOf(i), str2);
        if (this.entranceTrackedEvents.contains(str4)) {
            return;
        }
        JSONObject jSONObject = new JSONObject();
        TrackHelper.addTrackData(jSONObject, "mainId", str);
        TrackHelper.addTrackData(jSONObject, "contentId", str2);
        TrackHelper.addTrackData(jSONObject, "title", str3);
        this.trackEventArray.put(TrackHelper.getCommonParams(i, this.trackEntity, jSONObject));
        this.entranceTrackedEvents.add(str4);
    }

    public void clickServiceEntrance(String str) {
        showCustomerService(false);
        String str2 = String.format("%s", Integer.valueOf(TrackType.TRACK_ENTRANCE_CLICK_CUSTOMER_SERVICE));
        if (!this.entranceTrackedEvents.contains(str2)) {
            this.trackEventArray.put(TrackHelper.getCommonParams(TrackType.TRACK_ENTRANCE_CLICK_CUSTOMER_SERVICE, this.trackEntity, new JSONObject[0]));
            this.entranceTrackedEvents.add(str2);
        }
        clickServiceEntranceInFaq(str);
    }

    public void showAIHelp() {
        this.trackEntity.setWhenAIHelpVisible(System.currentTimeMillis());
        this.trackEventArray.put(TrackHelper.getCommonParams(1, this.trackEntity, new JSONObject[0]));
    }

    public void showHelpCenter() {
        this.trackEventArray.put(TrackHelper.getCommonParams(2, this.trackEntity, new JSONObject[0]));
    }

    public void showCustomerService(boolean z) {
        this.trackEntity.setWhenCustomerServiceVisible(System.currentTimeMillis());
        if (z || !this.trackEntity.isTracked()) {
            this.trackEventArray.put(TrackHelper.getCommonParams(3, this.trackEntity, new JSONObject[0]));
            this.trackEntity.setTracked(true);
        }
    }

    public void selectSmartIntent(String str) {
        JSONObject jSONObject = new JSONObject();
        TrackHelper.addTrackData(jSONObject, "intentId", str);
        TrackHelper.addTrackData(jSONObject, "ticketId", TicketStatusTracker.currentTicketId);
        this.trackEventArray.put(TrackHelper.getCommonParams(201, this.trackEntity, jSONObject));
    }

    public void onUserInput() {
        if (!TicketStatusTracker.isTicketActive || TicketStatusTracker.isTicketServingByAnswerBot()) {
            JSONObject jSONObject = new JSONObject();
            TrackHelper.addTrackData(jSONObject, "ticketId", TicketStatusTracker.currentTicketId);
            this.trackEventArray.put(TrackHelper.getCommonParams(202, this.trackEntity, jSONObject));
        }
    }

    public void onAnswerBotSelected() {
        JSONObject jSONObject = new JSONObject();
        TrackHelper.addTrackData(jSONObject, "ticketId", TicketStatusTracker.currentTicketId);
        this.trackEventArray.put(TrackHelper.getCommonParams(204, this.trackEntity, jSONObject));
    }
}
