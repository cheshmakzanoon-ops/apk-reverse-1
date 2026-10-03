package zendesk.android.messaging.model;

import kotlin.Metadata;
import kotlin.jvm.internal.Intrinsics;

@Metadata(m17d1 = {"\u0000\"\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0000\n\u0002\u0010\u000e\n\u0002\b<\n\u0002\u0010\u000b\n\u0002\b\u0002\n\u0002\u0010\b\n\u0002\b\u0002\b\u0086\b\u0018\u00002\u00020\u0001B\u009d\u0001\u0012\u0006\u0010\u0002\u001a\u00020\u0003\u0012\u0006\u0010\u0004\u001a\u00020\u0003\u0012\u0006\u0010\u0005\u001a\u00020\u0003\u0012\u0006\u0010\u0006\u001a\u00020\u0003\u0012\u0006\u0010\u0007\u001a\u00020\u0003\u0012\u0006\u0010\b\u001a\u00020\u0003\u0012\u0006\u0010\t\u001a\u00020\u0003\u0012\u0006\u0010\n\u001a\u00020\u0003\u0012\u0006\u0010\u000b\u001a\u00020\u0003\u0012\u0006\u0010\f\u001a\u00020\u0003\u0012\u0006\u0010\r\u001a\u00020\u0003\u0012\u0006\u0010\u000e\u001a\u00020\u0003\u0012\u0006\u0010\u000f\u001a\u00020\u0003\u0012\u0006\u0010\u0010\u001a\u00020\u0003\u0012\u0006\u0010\u0011\u001a\u00020\u0003\u0012\u0006\u0010\u0012\u001a\u00020\u0003\u0012\u0006\u0010\u0013\u001a\u00020\u0003\u0012\u0006\u0010\u0014\u001a\u00020\u0003\u0012\u0006\u0010\u0015\u001a\u00020\u0003¢\u0006\u0002\u0010\u0016J\t\u0010+\u001a\u00020\u0003HÆ\u0003J\t\u0010,\u001a\u00020\u0003HÆ\u0003J\t\u0010-\u001a\u00020\u0003HÆ\u0003J\t\u0010.\u001a\u00020\u0003HÆ\u0003J\t\u0010/\u001a\u00020\u0003HÆ\u0003J\t\u00100\u001a\u00020\u0003HÆ\u0003J\t\u00101\u001a\u00020\u0003HÆ\u0003J\t\u00102\u001a\u00020\u0003HÆ\u0003J\t\u00103\u001a\u00020\u0003HÆ\u0003J\t\u00104\u001a\u00020\u0003HÆ\u0003J\t\u00105\u001a\u00020\u0003HÆ\u0003J\t\u00106\u001a\u00020\u0003HÆ\u0003J\t\u00107\u001a\u00020\u0003HÆ\u0003J\t\u00108\u001a\u00020\u0003HÆ\u0003J\t\u00109\u001a\u00020\u0003HÆ\u0003J\t\u0010:\u001a\u00020\u0003HÆ\u0003J\t\u0010;\u001a\u00020\u0003HÆ\u0003J\t\u0010<\u001a\u00020\u0003HÆ\u0003J\t\u0010=\u001a\u00020\u0003HÆ\u0003JÇ\u0001\u0010>\u001a\u00020\u00002\b\b\u0002\u0010\u0002\u001a\u00020\u00032\b\b\u0002\u0010\u0004\u001a\u00020\u00032\b\b\u0002\u0010\u0005\u001a\u00020\u00032\b\b\u0002\u0010\u0006\u001a\u00020\u00032\b\b\u0002\u0010\u0007\u001a\u00020\u00032\b\b\u0002\u0010\b\u001a\u00020\u00032\b\b\u0002\u0010\t\u001a\u00020\u00032\b\b\u0002\u0010\n\u001a\u00020\u00032\b\b\u0002\u0010\u000b\u001a\u00020\u00032\b\b\u0002\u0010\f\u001a\u00020\u00032\b\b\u0002\u0010\r\u001a\u00020\u00032\b\b\u0002\u0010\u000e\u001a\u00020\u00032\b\b\u0002\u0010\u000f\u001a\u00020\u00032\b\b\u0002\u0010\u0010\u001a\u00020\u00032\b\b\u0002\u0010\u0011\u001a\u00020\u00032\b\b\u0002\u0010\u0012\u001a\u00020\u00032\b\b\u0002\u0010\u0013\u001a\u00020\u00032\b\b\u0002\u0010\u0014\u001a\u00020\u00032\b\b\u0002\u0010\u0015\u001a\u00020\u0003HÆ\u0001J\u0013\u0010?\u001a\u00020@2\b\u0010A\u001a\u0004\u0018\u00010\u0001HÖ\u0003J\t\u0010B\u001a\u00020CHÖ\u0001J\t\u0010D\u001a\u00020\u0003HÖ\u0001R\u0011\u0010\u0014\u001a\u00020\u0003¢\u0006\b\n\u0000\u001a\u0004\b\u0017\u0010\u0018R\u0011\u0010\u0007\u001a\u00020\u0003¢\u0006\b\n\u0000\u001a\u0004\b\u0019\u0010\u0018R\u0011\u0010\u000b\u001a\u00020\u0003¢\u0006\b\n\u0000\u001a\u0004\b\u001a\u0010\u0018R\u0011\u0010\u0010\u001a\u00020\u0003¢\u0006\b\n\u0000\u001a\u0004\b\u001b\u0010\u0018R\u0011\u0010\u0012\u001a\u00020\u0003¢\u0006\b\n\u0000\u001a\u0004\b\u001c\u0010\u0018R\u0011\u0010\r\u001a\u00020\u0003¢\u0006\b\n\u0000\u001a\u0004\b\u001d\u0010\u0018R\u0011\u0010\u0013\u001a\u00020\u0003¢\u0006\b\n\u0000\u001a\u0004\b\u001e\u0010\u0018R\u0011\u0010\t\u001a\u00020\u0003¢\u0006\b\n\u0000\u001a\u0004\b\u001f\u0010\u0018R\u0011\u0010\u0005\u001a\u00020\u0003¢\u0006\b\n\u0000\u001a\u0004\b \u0010\u0018R\u0011\u0010\u000e\u001a\u00020\u0003¢\u0006\b\n\u0000\u001a\u0004\b!\u0010\u0018R\u0011\u0010\u0015\u001a\u00020\u0003¢\u0006\b\n\u0000\u001a\u0004\b\"\u0010\u0018R\u0011\u0010\b\u001a\u00020\u0003¢\u0006\b\n\u0000\u001a\u0004\b#\u0010\u0018R\u0011\u0010\f\u001a\u00020\u0003¢\u0006\b\n\u0000\u001a\u0004\b$\u0010\u0018R\u0011\u0010\u0011\u001a\u00020\u0003¢\u0006\b\n\u0000\u001a\u0004\b%\u0010\u0018R\u0011\u0010\u0006\u001a\u00020\u0003¢\u0006\b\n\u0000\u001a\u0004\b&\u0010\u0018R\u0011\u0010\u0004\u001a\u00020\u0003¢\u0006\b\n\u0000\u001a\u0004\b'\u0010\u0018R\u0011\u0010\u0002\u001a\u00020\u0003¢\u0006\b\n\u0000\u001a\u0004\b(\u0010\u0018R\u0011\u0010\u000f\u001a\u00020\u0003¢\u0006\b\n\u0000\u001a\u0004\b)\u0010\u0018R\u0011\u0010\n\u001a\u00020\u0003¢\u0006\b\n\u0000\u001a\u0004\b*\u0010\u0018¨\u0006E"}, m18d2 = {"Lzendesk/android/messaging/model/ColorTheme;", "", "primaryColor", "", "onPrimaryColor", "messageColor", "onMessageColor", "actionColor", "onActionColor", "inboundMessageColor", "systemMessageColor", "backgroundColor", "onBackgroundColor", "elevatedColor", "notifyColor", "successColor", "dangerColor", "onDangerColor", "disabledColor", "iconColor", "actionBackgroundColor", "onActionBackgroundColor", "(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V", "getActionBackgroundColor", "()Ljava/lang/String;", "getActionColor", "getBackgroundColor", "getDangerColor", "getDisabledColor", "getElevatedColor", "getIconColor", "getInboundMessageColor", "getMessageColor", "getNotifyColor", "getOnActionBackgroundColor", "getOnActionColor", "getOnBackgroundColor", "getOnDangerColor", "getOnMessageColor", "getOnPrimaryColor", "getPrimaryColor", "getSuccessColor", "getSystemMessageColor", "component1", "component10", "component11", "component12", "component13", "component14", "component15", "component16", "component17", "component18", "component19", "component2", "component3", "component4", "component5", "component6", "component7", "component8", "component9", "copy", "equals", "", "other", "hashCode", "", "toString", "zendesk_zendesk-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
public final class ColorTheme {
    private final String actionBackgroundColor;
    private final String actionColor;
    private final String backgroundColor;
    private final String dangerColor;
    private final String disabledColor;
    private final String elevatedColor;
    private final String iconColor;
    private final String inboundMessageColor;
    private final String messageColor;
    private final String notifyColor;
    private final String onActionBackgroundColor;
    private final String onActionColor;
    private final String onBackgroundColor;
    private final String onDangerColor;
    private final String onMessageColor;
    private final String onPrimaryColor;
    private final String primaryColor;
    private final String successColor;
    private final String systemMessageColor;

    public final String getPrimaryColor() {
        return this.primaryColor;
    }

    public final String getOnBackgroundColor() {
        return this.onBackgroundColor;
    }

    public final String getElevatedColor() {
        return this.elevatedColor;
    }

    public final String getNotifyColor() {
        return this.notifyColor;
    }

    public final String getSuccessColor() {
        return this.successColor;
    }

    public final String getDangerColor() {
        return this.dangerColor;
    }

    public final String getOnDangerColor() {
        return this.onDangerColor;
    }

    public final String getDisabledColor() {
        return this.disabledColor;
    }

    public final String getIconColor() {
        return this.iconColor;
    }

    public final String getActionBackgroundColor() {
        return this.actionBackgroundColor;
    }

    public final String getOnActionBackgroundColor() {
        return this.onActionBackgroundColor;
    }

    public final String getOnPrimaryColor() {
        return this.onPrimaryColor;
    }

    public final String getMessageColor() {
        return this.messageColor;
    }

    public final String getOnMessageColor() {
        return this.onMessageColor;
    }

    public final String getActionColor() {
        return this.actionColor;
    }

    public final String getOnActionColor() {
        return this.onActionColor;
    }

    public final String getInboundMessageColor() {
        return this.inboundMessageColor;
    }

    public final String getSystemMessageColor() {
        return this.systemMessageColor;
    }

    public final String getBackgroundColor() {
        return this.backgroundColor;
    }

    public final ColorTheme copy(String primaryColor, String onPrimaryColor, String messageColor, String onMessageColor, String actionColor, String onActionColor, String inboundMessageColor, String systemMessageColor, String backgroundColor, String onBackgroundColor, String elevatedColor, String notifyColor, String successColor, String dangerColor, String onDangerColor, String disabledColor, String iconColor, String actionBackgroundColor, String onActionBackgroundColor) {
        Intrinsics.checkNotNullParameter(primaryColor, "primaryColor");
        Intrinsics.checkNotNullParameter(onPrimaryColor, "onPrimaryColor");
        Intrinsics.checkNotNullParameter(messageColor, "messageColor");
        Intrinsics.checkNotNullParameter(onMessageColor, "onMessageColor");
        Intrinsics.checkNotNullParameter(actionColor, "actionColor");
        Intrinsics.checkNotNullParameter(onActionColor, "onActionColor");
        Intrinsics.checkNotNullParameter(inboundMessageColor, "inboundMessageColor");
        Intrinsics.checkNotNullParameter(systemMessageColor, "systemMessageColor");
        Intrinsics.checkNotNullParameter(backgroundColor, "backgroundColor");
        Intrinsics.checkNotNullParameter(onBackgroundColor, "onBackgroundColor");
        Intrinsics.checkNotNullParameter(elevatedColor, "elevatedColor");
        Intrinsics.checkNotNullParameter(notifyColor, "notifyColor");
        Intrinsics.checkNotNullParameter(successColor, "successColor");
        Intrinsics.checkNotNullParameter(dangerColor, "dangerColor");
        Intrinsics.checkNotNullParameter(onDangerColor, "onDangerColor");
        Intrinsics.checkNotNullParameter(disabledColor, "disabledColor");
        Intrinsics.checkNotNullParameter(iconColor, "iconColor");
        Intrinsics.checkNotNullParameter(actionBackgroundColor, "actionBackgroundColor");
        Intrinsics.checkNotNullParameter(onActionBackgroundColor, "onActionBackgroundColor");
        return new ColorTheme(primaryColor, onPrimaryColor, messageColor, onMessageColor, actionColor, onActionColor, inboundMessageColor, systemMessageColor, backgroundColor, onBackgroundColor, elevatedColor, notifyColor, successColor, dangerColor, onDangerColor, disabledColor, iconColor, actionBackgroundColor, onActionBackgroundColor);
    }

    public boolean equals(Object other) {
        if (this == other) {
            return true;
        }
        if (!(other instanceof ColorTheme)) {
            return false;
        }
        ColorTheme colorTheme = (ColorTheme) other;
        return Intrinsics.areEqual(this.primaryColor, colorTheme.primaryColor) && Intrinsics.areEqual(this.onPrimaryColor, colorTheme.onPrimaryColor) && Intrinsics.areEqual(this.messageColor, colorTheme.messageColor) && Intrinsics.areEqual(this.onMessageColor, colorTheme.onMessageColor) && Intrinsics.areEqual(this.actionColor, colorTheme.actionColor) && Intrinsics.areEqual(this.onActionColor, colorTheme.onActionColor) && Intrinsics.areEqual(this.inboundMessageColor, colorTheme.inboundMessageColor) && Intrinsics.areEqual(this.systemMessageColor, colorTheme.systemMessageColor) && Intrinsics.areEqual(this.backgroundColor, colorTheme.backgroundColor) && Intrinsics.areEqual(this.onBackgroundColor, colorTheme.onBackgroundColor) && Intrinsics.areEqual(this.elevatedColor, colorTheme.elevatedColor) && Intrinsics.areEqual(this.notifyColor, colorTheme.notifyColor) && Intrinsics.areEqual(this.successColor, colorTheme.successColor) && Intrinsics.areEqual(this.dangerColor, colorTheme.dangerColor) && Intrinsics.areEqual(this.onDangerColor, colorTheme.onDangerColor) && Intrinsics.areEqual(this.disabledColor, colorTheme.disabledColor) && Intrinsics.areEqual(this.iconColor, colorTheme.iconColor) && Intrinsics.areEqual(this.actionBackgroundColor, colorTheme.actionBackgroundColor) && Intrinsics.areEqual(this.onActionBackgroundColor, colorTheme.onActionBackgroundColor);
    }

    public int hashCode() {
        return (((((((((((((((((((((((((((((((((((this.primaryColor.hashCode() * 31) + this.onPrimaryColor.hashCode()) * 31) + this.messageColor.hashCode()) * 31) + this.onMessageColor.hashCode()) * 31) + this.actionColor.hashCode()) * 31) + this.onActionColor.hashCode()) * 31) + this.inboundMessageColor.hashCode()) * 31) + this.systemMessageColor.hashCode()) * 31) + this.backgroundColor.hashCode()) * 31) + this.onBackgroundColor.hashCode()) * 31) + this.elevatedColor.hashCode()) * 31) + this.notifyColor.hashCode()) * 31) + this.successColor.hashCode()) * 31) + this.dangerColor.hashCode()) * 31) + this.onDangerColor.hashCode()) * 31) + this.disabledColor.hashCode()) * 31) + this.iconColor.hashCode()) * 31) + this.actionBackgroundColor.hashCode()) * 31) + this.onActionBackgroundColor.hashCode();
    }

    public String toString() {
        return "ColorTheme(primaryColor=" + this.primaryColor + ", onPrimaryColor=" + this.onPrimaryColor + ", messageColor=" + this.messageColor + ", onMessageColor=" + this.onMessageColor + ", actionColor=" + this.actionColor + ", onActionColor=" + this.onActionColor + ", inboundMessageColor=" + this.inboundMessageColor + ", systemMessageColor=" + this.systemMessageColor + ", backgroundColor=" + this.backgroundColor + ", onBackgroundColor=" + this.onBackgroundColor + ", elevatedColor=" + this.elevatedColor + ", notifyColor=" + this.notifyColor + ", successColor=" + this.successColor + ", dangerColor=" + this.dangerColor + ", onDangerColor=" + this.onDangerColor + ", disabledColor=" + this.disabledColor + ", iconColor=" + this.iconColor + ", actionBackgroundColor=" + this.actionBackgroundColor + ", onActionBackgroundColor=" + this.onActionBackgroundColor + ')';
    }

    public ColorTheme(String primaryColor, String onPrimaryColor, String messageColor, String onMessageColor, String actionColor, String onActionColor, String inboundMessageColor, String systemMessageColor, String backgroundColor, String onBackgroundColor, String elevatedColor, String notifyColor, String successColor, String dangerColor, String onDangerColor, String disabledColor, String iconColor, String actionBackgroundColor, String onActionBackgroundColor) {
        Intrinsics.checkNotNullParameter(primaryColor, "primaryColor");
        Intrinsics.checkNotNullParameter(onPrimaryColor, "onPrimaryColor");
        Intrinsics.checkNotNullParameter(messageColor, "messageColor");
        Intrinsics.checkNotNullParameter(onMessageColor, "onMessageColor");
        Intrinsics.checkNotNullParameter(actionColor, "actionColor");
        Intrinsics.checkNotNullParameter(onActionColor, "onActionColor");
        Intrinsics.checkNotNullParameter(inboundMessageColor, "inboundMessageColor");
        Intrinsics.checkNotNullParameter(systemMessageColor, "systemMessageColor");
        Intrinsics.checkNotNullParameter(backgroundColor, "backgroundColor");
        Intrinsics.checkNotNullParameter(onBackgroundColor, "onBackgroundColor");
        Intrinsics.checkNotNullParameter(elevatedColor, "elevatedColor");
        Intrinsics.checkNotNullParameter(notifyColor, "notifyColor");
        Intrinsics.checkNotNullParameter(successColor, "successColor");
        Intrinsics.checkNotNullParameter(dangerColor, "dangerColor");
        Intrinsics.checkNotNullParameter(onDangerColor, "onDangerColor");
        Intrinsics.checkNotNullParameter(disabledColor, "disabledColor");
        Intrinsics.checkNotNullParameter(iconColor, "iconColor");
        Intrinsics.checkNotNullParameter(actionBackgroundColor, "actionBackgroundColor");
        Intrinsics.checkNotNullParameter(onActionBackgroundColor, "onActionBackgroundColor");
        this.primaryColor = primaryColor;
        this.onPrimaryColor = onPrimaryColor;
        this.messageColor = messageColor;
        this.onMessageColor = onMessageColor;
        this.actionColor = actionColor;
        this.onActionColor = onActionColor;
        this.inboundMessageColor = inboundMessageColor;
        this.systemMessageColor = systemMessageColor;
        this.backgroundColor = backgroundColor;
        this.onBackgroundColor = onBackgroundColor;
        this.elevatedColor = elevatedColor;
        this.notifyColor = notifyColor;
        this.successColor = successColor;
        this.dangerColor = dangerColor;
        this.onDangerColor = onDangerColor;
        this.disabledColor = disabledColor;
        this.iconColor = iconColor;
        this.actionBackgroundColor = actionBackgroundColor;
        this.onActionBackgroundColor = onActionBackgroundColor;
    }

    public final String getPrimaryColor() {
        return this.primaryColor;
    }

    public final String getOnPrimaryColor() {
        return this.onPrimaryColor;
    }

    public final String getMessageColor() {
        return this.messageColor;
    }

    public final String getOnMessageColor() {
        return this.onMessageColor;
    }

    public final String getActionColor() {
        return this.actionColor;
    }

    public final String getOnActionColor() {
        return this.onActionColor;
    }

    public final String getInboundMessageColor() {
        return this.inboundMessageColor;
    }

    public final String getSystemMessageColor() {
        return this.systemMessageColor;
    }

    public final String getBackgroundColor() {
        return this.backgroundColor;
    }

    public final String getOnBackgroundColor() {
        return this.onBackgroundColor;
    }

    public final String getElevatedColor() {
        return this.elevatedColor;
    }

    public final String getNotifyColor() {
        return this.notifyColor;
    }

    public final String getSuccessColor() {
        return this.successColor;
    }

    public final String getDangerColor() {
        return this.dangerColor;
    }

    public final String getOnDangerColor() {
        return this.onDangerColor;
    }

    public final String getDisabledColor() {
        return this.disabledColor;
    }

    public final String getIconColor() {
        return this.iconColor;
    }

    public final String getActionBackgroundColor() {
        return this.actionBackgroundColor;
    }

    public final String getOnActionBackgroundColor() {
        return this.onActionBackgroundColor;
    }
}
