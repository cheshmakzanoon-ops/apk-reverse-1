package com.sdkmanager.notify;

import java.util.Date;

public class LocalNotification {
    String activityClassName;
    public String title = "";
    public String body = "";
    public boolean playSound = false;
    public int iconResourceId = 0;
    public String pushType = "0";
    public boolean hasAction = true;
    public String playerMark = "";
    public String gameUid = "";
    public String pushId = "";
    public Date fireDate = new Date();

    public LocalNotification(String str) {
        this.activityClassName = str;
    }
}
