package net.aihelp.data.model.faq;

public class FaqListEntity implements Comparable<FaqListEntity> {
    public static final int FAQ_DISPLAY_HOT_TOPICS = 6;
    public static final int FAQ_DISPLAY_NOTIFICATION = 5;
    public static final int FAQ_DISPLAY_QUESTION_LIST = 3;
    public static final int FAQ_DISPLAY_SEARCH = 4;
    public static final int FAQ_DISPLAY_SECTION = 1;
    public static final int FAQ_DISPLAY_SUB_SECTION = 2;
    private int displayType;
    private String iconUrl;

    private String f100id;
    private boolean isHidden;
    private int order;
    private String query;
    private String sectionName;
    private String title;

    public FaqListEntity(int i, String str, String str2) {
        this.displayType = i;
        this.f100id = str;
        this.title = str2;
    }

    public FaqListEntity(int i, String str, String str2, String str3) {
        this.displayType = i;
        this.f100id = str;
        this.title = str2;
        this.query = str3;
    }

    public FaqListEntity(int i, String str, String str2, String str3, String str4) {
        this.displayType = i;
        this.f100id = str;
        this.title = str2;
        this.query = str3;
        this.iconUrl = str4;
    }

    public boolean isHidden() {
        return this.isHidden;
    }

    public void setHidden(boolean z) {
        this.isHidden = z;
    }

    public String getSectionName() {
        return this.sectionName;
    }

    public void setSectionName(String str) {
        this.sectionName = str;
    }

    public int getDisplayType() {
        return this.displayType;
    }

    public void setDisplayType(int i) {
        this.displayType = i;
    }

    public String getId() {
        return this.f100id;
    }

    public void setId(String str) {
        this.f100id = str;
    }

    public String getTitle() {
        return this.title;
    }

    public void setTitle(String str) {
        this.title = str;
    }

    public String getQuery() {
        return this.query;
    }

    public void setQuery(String str) {
        this.query = str;
    }

    public int getOrder() {
        return this.order;
    }

    public void setOrder(int i) {
        this.order = i;
    }

    public String getIconUrl() {
        return this.iconUrl;
    }

    public void setIconUrl(String str) {
        this.iconUrl = str;
    }

    public String toString() {
        return "FaqListEntity{displayType=" + this.displayType + ", id='" + this.f100id + "', title='" + this.title + "', query='" + this.query + "', order=" + this.order + ", iconUrl='" + this.iconUrl + "', sectionTitle='" + this.sectionName + "'}";
    }

    @Override
    public int compareTo(FaqListEntity faqListEntity) {
        return this.order - faqListEntity.order;
    }
}
