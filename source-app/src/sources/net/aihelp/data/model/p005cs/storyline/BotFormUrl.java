package net.aihelp.data.model.p005cs.storyline;

public class BotFormUrl {
    private String formAddress;
    private String formTitle;
    private String formType;

    public BotFormUrl(String str, String str2, String str3) {
        this.formTitle = str;
        this.formAddress = str2;
        this.formType = str3;
    }

    public String getFormTitle() {
        return this.formTitle;
    }

    public void setFormTitle(String str) {
        this.formTitle = str;
    }

    public String getFormAddress() {
        return this.formAddress;
    }

    public void setFormAddress(String str) {
        this.formAddress = str;
    }

    public String getFormType() {
        return this.formType;
    }

    public void setFormType(String str) {
        this.formType = str;
    }
}
