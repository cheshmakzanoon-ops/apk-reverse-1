package net.aihelp.data.model.p005cs.storyline;

public class BotUrl {
    private String urlAddress;
    private String urlTitle;

    public BotUrl(String str, String str2) {
        this.urlTitle = str;
        this.urlAddress = str2;
    }

    public String getUrlTitle() {
        return this.urlTitle;
    }

    public void setUrlTitle(String str) {
        this.urlTitle = str;
    }

    public String getUrlAddress() {
        return this.urlAddress;
    }

    public void setUrlAddress(String str) {
        this.urlAddress = str;
    }
}
