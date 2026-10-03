package net.aihelp.data.track.data;

public class TrackEntity {
    private final String activeId;
    private final String entranceId;
    private String faqContentId;
    private String faqMainId;
    private boolean isTracked;
    private String sectionId;
    private long totalCustomerServiceDuration;
    private long totalWaitingDuration;
    private long whenAIHelpVisible;
    private long whenCustomerServiceVisible;
    private long whenMessageSent;
    private long whenUserGetFeedback;

    public TrackEntity(String str, String str2) {
        this.entranceId = str;
        this.activeId = str2;
    }

    public String getEntranceId() {
        return this.entranceId;
    }

    public String getActiveId() {
        return this.activeId;
    }

    public boolean isTracked() {
        return this.isTracked;
    }

    public void setTracked(boolean z) {
        this.isTracked = z;
    }

    public long getWhenAIHelpVisible() {
        return this.whenAIHelpVisible;
    }

    public void setWhenAIHelpVisible(long j) {
        this.whenAIHelpVisible = j;
    }

    public long getWhenCustomerServiceVisible() {
        return this.whenCustomerServiceVisible;
    }

    public void setWhenCustomerServiceVisible(long j) {
        this.whenCustomerServiceVisible = j;
    }

    public long getTotalCustomerServiceDuration() {
        return this.totalCustomerServiceDuration;
    }

    public void calculateTotalCustomerServiceDuration() {
        this.totalCustomerServiceDuration += System.currentTimeMillis() - this.whenCustomerServiceVisible;
    }

    public String getFaqMainId() {
        return this.faqMainId;
    }

    public void setFaqMainId(String str) {
        this.faqMainId = str;
    }

    public String getFaqContentId() {
        return this.faqContentId;
    }

    public void setFaqContentId(String str) {
        this.faqContentId = str;
    }

    public String getSectionId() {
        return this.sectionId;
    }

    public void setSectionId(String str) {
        this.sectionId = str;
    }

    public long getWhenMessageSent() {
        return this.whenMessageSent;
    }

    public void setWhenMessageSent(long j) {
        this.whenMessageSent = j;
    }

    public long getWhenUserGetFeedback() {
        return this.whenUserGetFeedback;
    }

    public void setWhenUserGetFeedback(long j) {
        this.whenUserGetFeedback = j;
    }

    public long getTotalWaitingDuration() {
        return this.totalWaitingDuration;
    }

    public void setTotalWaitingDuration(long j) {
        this.totalWaitingDuration = j;
    }
}
