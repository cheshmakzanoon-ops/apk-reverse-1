package net.aihelp.data.model.p006op;

public class OperateArticle {
    private String faqContent;
    private String faqContentId;
    private String faqImageUrl;
    private String faqMainId;
    private String faqTitle;
    private String faqUpdateDate;
    private boolean isFaqUnread;
    private String sectionId;

    public String getFaqTitle() {
        return this.faqTitle;
    }

    public void setFaqTitle(String str) {
        this.faqTitle = str;
    }

    public String getFaqContent() {
        return this.faqContent;
    }

    public void setFaqContent(String str) {
        this.faqContent = str;
    }

    public String getFaqImageUrl() {
        return this.faqImageUrl;
    }

    public void setFaqImageUrl(String str) {
        this.faqImageUrl = str;
    }

    public String getFaqUpdateDate() {
        return this.faqUpdateDate;
    }

    public void setFaqUpdateDate(String str) {
        this.faqUpdateDate = str;
    }

    public boolean isFaqUnread() {
        return this.isFaqUnread;
    }

    public void setFaqUnread(boolean z) {
        this.isFaqUnread = z;
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
}
