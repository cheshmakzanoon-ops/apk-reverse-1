package net.aihelp.data.model.p005cs.storyline;

public class BotBillEntity {
    private boolean isChecked = false;
    private String originJson;

    public BotBillEntity(String str) {
        this.originJson = str;
    }

    public boolean isChecked() {
        return this.isChecked;
    }

    public void setChecked(boolean z) {
        this.isChecked = z;
    }

    public String getOriginJson() {
        return this.originJson;
    }

    public void setOriginJson(String str) {
        this.originJson = str;
    }
}
