package net.aihelp.data.model.faq;

import android.text.TextUtils;

public class FaqContentEntity {
    private String faqContent;
    private String faqContentId;
    private String faqDisplayId;
    private String faqKeywords;
    private String faqMainId;
    private String faqNoHtmlContent;
    private String faqTitle;
    private String iconUrl;
    private int isHelpful;
    private long lastUpdateTime;
    private String searchTerm;
    private String secId;
    private String sectionName;
    private String similarQuestions;

    public FaqContentEntity() {
    }

    public FaqContentEntity(String str, String str2, String str3, String str4, String str5, String str6, String str7, int i, String str8) {
        this.secId = str;
        this.faqTitle = str2;
        this.faqKeywords = str3;
        this.faqMainId = str4;
        this.faqDisplayId = str5;
        this.faqContentId = str6;
        this.faqContent = str7;
        this.isHelpful = i;
        this.searchTerm = str8;
    }

    public String getIconUrl() {
        return this.iconUrl;
    }

    public void setIconUrl(String str) {
        this.iconUrl = str;
    }

    public String getSectionName() {
        return this.sectionName;
    }

    public void setSectionName(String str) {
        this.sectionName = str;
    }

    public String getFaqDisplayId() {
        return this.faqDisplayId;
    }

    public void setFaqDisplayId(String str) {
        this.faqDisplayId = str;
    }

    public String getFaqContentId() {
        return this.faqContentId;
    }

    public void setFaqContentId(String str) {
        this.faqContentId = str;
    }

    public int isHelpful() {
        return this.isHelpful;
    }

    public void setHelpful(int i) {
        this.isHelpful = i;
    }

    public String getSearchTerm() {
        return this.searchTerm;
    }

    public void setSearchTerm(String str) {
        this.searchTerm = str;
    }

    public void clearSearchTerms() {
        this.searchTerm = null;
    }

    public void updateSearchTerm(String str) {
        this.searchTerm = str;
    }

    public String getFaqNoHtmlContent() {
        return this.faqNoHtmlContent;
    }

    public void setFaqNoHtmlContent(String str) {
        this.faqNoHtmlContent = str;
    }

    public String getSecId() {
        return this.secId;
    }

    public void setSecId(String str) {
        this.secId = str;
    }

    public String getFaqTitle() {
        if (TextUtils.isEmpty(this.faqTitle)) {
            return "";
        }
        return this.faqTitle;
    }

    public void setFaqTitle(String str) {
        this.faqTitle = str;
    }

    public String getFaqMainId() {
        return this.faqMainId;
    }

    public void setFaqMainId(String str) {
        this.faqMainId = str;
    }

    public String getFaqContent() {
        return this.faqContent;
    }

    public void setFaqContent(String str) {
        this.faqContent = str;
    }

    public String getFaqKeywords() {
        return this.faqKeywords;
    }

    public void setFaqKeywords(String str) {
        this.faqKeywords = str;
    }

    public int getIsHelpful() {
        return this.isHelpful;
    }

    public void setIsHelpful(int i) {
        this.isHelpful = i;
    }

    public String getSimilarQuestions() {
        if (TextUtils.isEmpty(this.similarQuestions)) {
            return "";
        }
        return this.similarQuestions;
    }

    public void setSimilarQuestions(String str) {
        this.similarQuestions = str;
    }

    public void setLastUpdateTime(long j) {
        this.lastUpdateTime = j;
    }

    public long getLastUpdateTime() {
        return this.lastUpdateTime;
    }
}
