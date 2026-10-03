package net.aihelp.data.event;

import net.aihelp.core.util.bus.event.EventCenter;

public class UpdateTitleEvent extends EventCenter {
    public static final int CUSTOM_SERVICE = 1;
    public static final int HELP_CENTER = 0;
    private final String icon;
    private final String title;

    public UpdateTitleEvent(int i, String str, String str2) {
        super(i);
        this.icon = str;
        this.title = str2;
    }

    public UpdateTitleEvent(String str) {
        this.icon = "";
        this.title = str;
    }

    public String getIcon() {
        return this.icon;
    }

    public String getTitle() {
        return this.title;
    }
}
