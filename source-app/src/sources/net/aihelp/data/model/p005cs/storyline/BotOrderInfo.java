package net.aihelp.data.model.p005cs.storyline;

public class BotOrderInfo {

    private String f99id;
    private String name;
    private String type;
    private String url;

    public BotOrderInfo(String str, String str2, String str3, String str4) {
        this.f99id = str;
        this.type = str2;
        this.name = str3;
        this.url = str4;
    }

    public String getId() {
        return this.f99id;
    }

    public void setId(String str) {
        this.f99id = str;
    }

    public String getType() {
        return this.type;
    }

    public void setType(String str) {
        this.type = str;
    }

    public String getName() {
        return this.name;
    }

    public void setName(String str) {
        this.name = str;
    }

    public String getUrl() {
        return this.url;
    }

    public void setUrl(String str) {
        this.url = str;
    }
}
