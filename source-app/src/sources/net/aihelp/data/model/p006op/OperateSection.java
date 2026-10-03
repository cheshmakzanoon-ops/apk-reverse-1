package net.aihelp.data.model.p006op;

public class OperateSection implements Comparable<OperateSection> {

    private String f101id;
    private int order;
    private String title;

    public OperateSection(String str, String str2) {
        this.f101id = str;
        this.title = str2;
    }

    public OperateSection(String str, String str2, int i) {
        this.f101id = str;
        this.title = str2;
        this.order = i;
    }

    public String getId() {
        return this.f101id;
    }

    public String getTitle() {
        return this.title;
    }

    @Override
    public int compareTo(OperateSection operateSection) {
        return this.order - operateSection.order;
    }
}
