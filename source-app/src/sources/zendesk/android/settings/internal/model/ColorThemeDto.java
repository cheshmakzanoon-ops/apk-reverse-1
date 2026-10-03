package zendesk.android.settings.internal.model;

import kotlin.Deprecated;
import kotlin.DeprecationLevel;
import kotlin.Metadata;
import kotlin.ReplaceWith;
import kotlin.jvm.JvmStatic;
import kotlin.jvm.internal.DefaultConstructorMarker;
import kotlin.jvm.internal.Intrinsics;
import kotlinx.serialization.KSerializer;
import kotlinx.serialization.SerialName;
import kotlinx.serialization.Serializable;
import kotlinx.serialization.descriptors.SerialDescriptor;
import kotlinx.serialization.encoding.CompositeEncoder;
import kotlinx.serialization.internal.PluginExceptionsKt;
import kotlinx.serialization.internal.SerializationConstructorMarker;

@Metadata(m17d1 = {"\u0000>\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0000\n\u0002\u0010\b\n\u0000\n\u0002\u0010\u000e\n\u0002\b\u0013\n\u0002\u0018\u0002\n\u0002\b?\n\u0002\u0010\u000b\n\u0002\b\u0004\n\u0002\u0010\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0004\b\u0081\b\u0018\u0000 f2\u00020\u0001:\u0002efBý\u0001\b\u0011\u0012\u0006\u0010\u0002\u001a\u00020\u0003\u0012\n\b\u0001\u0010\u0004\u001a\u0004\u0018\u00010\u0005\u0012\n\b\u0001\u0010\u0006\u001a\u0004\u0018\u00010\u0005\u0012\n\b\u0001\u0010\u0007\u001a\u0004\u0018\u00010\u0005\u0012\n\b\u0001\u0010\b\u001a\u0004\u0018\u00010\u0005\u0012\n\b\u0001\u0010\t\u001a\u0004\u0018\u00010\u0005\u0012\n\b\u0001\u0010\n\u001a\u0004\u0018\u00010\u0005\u0012\n\b\u0001\u0010\u000b\u001a\u0004\u0018\u00010\u0005\u0012\n\b\u0001\u0010\f\u001a\u0004\u0018\u00010\u0005\u0012\n\b\u0001\u0010\r\u001a\u0004\u0018\u00010\u0005\u0012\n\b\u0001\u0010\u000e\u001a\u0004\u0018\u00010\u0005\u0012\n\b\u0001\u0010\u000f\u001a\u0004\u0018\u00010\u0005\u0012\n\b\u0001\u0010\u0010\u001a\u0004\u0018\u00010\u0005\u0012\n\b\u0001\u0010\u0011\u001a\u0004\u0018\u00010\u0005\u0012\n\b\u0001\u0010\u0012\u001a\u0004\u0018\u00010\u0005\u0012\n\b\u0001\u0010\u0013\u001a\u0004\u0018\u00010\u0005\u0012\n\b\u0001\u0010\u0014\u001a\u0004\u0018\u00010\u0005\u0012\n\b\u0001\u0010\u0015\u001a\u0004\u0018\u00010\u0005\u0012\n\b\u0001\u0010\u0016\u001a\u0004\u0018\u00010\u0005\u0012\n\b\u0001\u0010\u0017\u001a\u0004\u0018\u00010\u0005\u0012\b\u0010\u0018\u001a\u0004\u0018\u00010\u0019¢\u0006\u0002\u0010\u001aB\u009d\u0001\u0012\u0006\u0010\u0004\u001a\u00020\u0005\u0012\u0006\u0010\u0006\u001a\u00020\u0005\u0012\u0006\u0010\u0007\u001a\u00020\u0005\u0012\u0006\u0010\b\u001a\u00020\u0005\u0012\u0006\u0010\t\u001a\u00020\u0005\u0012\u0006\u0010\n\u001a\u00020\u0005\u0012\u0006\u0010\u000b\u001a\u00020\u0005\u0012\u0006\u0010\f\u001a\u00020\u0005\u0012\u0006\u0010\r\u001a\u00020\u0005\u0012\u0006\u0010\u000e\u001a\u00020\u0005\u0012\u0006\u0010\u000f\u001a\u00020\u0005\u0012\u0006\u0010\u0010\u001a\u00020\u0005\u0012\u0006\u0010\u0011\u001a\u00020\u0005\u0012\u0006\u0010\u0012\u001a\u00020\u0005\u0012\u0006\u0010\u0013\u001a\u00020\u0005\u0012\u0006\u0010\u0014\u001a\u00020\u0005\u0012\u0006\u0010\u0015\u001a\u00020\u0005\u0012\u0006\u0010\u0016\u001a\u00020\u0005\u0012\u0006\u0010\u0017\u001a\u00020\u0005¢\u0006\u0002\u0010\u001bJ\t\u0010D\u001a\u00020\u0005HÆ\u0003J\t\u0010E\u001a\u00020\u0005HÆ\u0003J\t\u0010F\u001a\u00020\u0005HÆ\u0003J\t\u0010G\u001a\u00020\u0005HÆ\u0003J\t\u0010H\u001a\u00020\u0005HÆ\u0003J\t\u0010I\u001a\u00020\u0005HÆ\u0003J\t\u0010J\u001a\u00020\u0005HÆ\u0003J\t\u0010K\u001a\u00020\u0005HÆ\u0003J\t\u0010L\u001a\u00020\u0005HÆ\u0003J\t\u0010M\u001a\u00020\u0005HÆ\u0003J\t\u0010N\u001a\u00020\u0005HÆ\u0003J\t\u0010O\u001a\u00020\u0005HÆ\u0003J\t\u0010P\u001a\u00020\u0005HÆ\u0003J\t\u0010Q\u001a\u00020\u0005HÆ\u0003J\t\u0010R\u001a\u00020\u0005HÆ\u0003J\t\u0010S\u001a\u00020\u0005HÆ\u0003J\t\u0010T\u001a\u00020\u0005HÆ\u0003J\t\u0010U\u001a\u00020\u0005HÆ\u0003J\t\u0010V\u001a\u00020\u0005HÆ\u0003JÇ\u0001\u0010W\u001a\u00020\u00002\b\b\u0002\u0010\u0004\u001a\u00020\u00052\b\b\u0002\u0010\u0006\u001a\u00020\u00052\b\b\u0002\u0010\u0007\u001a\u00020\u00052\b\b\u0002\u0010\b\u001a\u00020\u00052\b\b\u0002\u0010\t\u001a\u00020\u00052\b\b\u0002\u0010\n\u001a\u00020\u00052\b\b\u0002\u0010\u000b\u001a\u00020\u00052\b\b\u0002\u0010\f\u001a\u00020\u00052\b\b\u0002\u0010\r\u001a\u00020\u00052\b\b\u0002\u0010\u000e\u001a\u00020\u00052\b\b\u0002\u0010\u000f\u001a\u00020\u00052\b\b\u0002\u0010\u0010\u001a\u00020\u00052\b\b\u0002\u0010\u0011\u001a\u00020\u00052\b\b\u0002\u0010\u0012\u001a\u00020\u00052\b\b\u0002\u0010\u0013\u001a\u00020\u00052\b\b\u0002\u0010\u0014\u001a\u00020\u00052\b\b\u0002\u0010\u0015\u001a\u00020\u00052\b\b\u0002\u0010\u0016\u001a\u00020\u00052\b\b\u0002\u0010\u0017\u001a\u00020\u0005HÆ\u0001J\u0013\u0010X\u001a\u00020Y2\b\u0010Z\u001a\u0004\u0018\u00010\u0001HÖ\u0003J\t\u0010[\u001a\u00020\u0003HÖ\u0001J\t\u0010\\\u001a\u00020\u0005HÖ\u0001J&\u0010]\u001a\u00020^2\u0006\u0010_\u001a\u00020\u00002\u0006\u0010`\u001a\u00020a2\u0006\u0010b\u001a\u00020cHÁ\u0001¢\u0006\u0002\bdR\u001c\u0010\u0016\u001a\u00020\u00058\u0006X\u0087\u0004¢\u0006\u000e\n\u0000\u0012\u0004\b\u001c\u0010\u001d\u001a\u0004\b\u001e\u0010\u001fR\u001c\u0010\t\u001a\u00020\u00058\u0006X\u0087\u0004¢\u0006\u000e\n\u0000\u0012\u0004\b \u0010\u001d\u001a\u0004\b!\u0010\u001fR\u001c\u0010\r\u001a\u00020\u00058\u0006X\u0087\u0004¢\u0006\u000e\n\u0000\u0012\u0004\b\"\u0010\u001d\u001a\u0004\b#\u0010\u001fR\u001c\u0010\u0012\u001a\u00020\u00058\u0006X\u0087\u0004¢\u0006\u000e\n\u0000\u0012\u0004\b$\u0010\u001d\u001a\u0004\b%\u0010\u001fR\u001c\u0010\u0014\u001a\u00020\u00058\u0006X\u0087\u0004¢\u0006\u000e\n\u0000\u0012\u0004\b&\u0010\u001d\u001a\u0004\b'\u0010\u001fR\u001c\u0010\u000f\u001a\u00020\u00058\u0006X\u0087\u0004¢\u0006\u000e\n\u0000\u0012\u0004\b(\u0010\u001d\u001a\u0004\b)\u0010\u001fR\u001c\u0010\u0015\u001a\u00020\u00058\u0006X\u0087\u0004¢\u0006\u000e\n\u0000\u0012\u0004\b*\u0010\u001d\u001a\u0004\b+\u0010\u001fR\u001c\u0010\u000b\u001a\u00020\u00058\u0006X\u0087\u0004¢\u0006\u000e\n\u0000\u0012\u0004\b,\u0010\u001d\u001a\u0004\b-\u0010\u001fR\u001c\u0010\u0007\u001a\u00020\u00058\u0006X\u0087\u0004¢\u0006\u000e\n\u0000\u0012\u0004\b.\u0010\u001d\u001a\u0004\b/\u0010\u001fR\u001c\u0010\u0010\u001a\u00020\u00058\u0006X\u0087\u0004¢\u0006\u000e\n\u0000\u0012\u0004\b0\u0010\u001d\u001a\u0004\b1\u0010\u001fR\u001c\u0010\u0017\u001a\u00020\u00058\u0006X\u0087\u0004¢\u0006\u000e\n\u0000\u0012\u0004\b2\u0010\u001d\u001a\u0004\b3\u0010\u001fR\u001c\u0010\n\u001a\u00020\u00058\u0006X\u0087\u0004¢\u0006\u000e\n\u0000\u0012\u0004\b4\u0010\u001d\u001a\u0004\b5\u0010\u001fR\u001c\u0010\u000e\u001a\u00020\u00058\u0006X\u0087\u0004¢\u0006\u000e\n\u0000\u0012\u0004\b6\u0010\u001d\u001a\u0004\b7\u0010\u001fR\u001c\u0010\u0013\u001a\u00020\u00058\u0006X\u0087\u0004¢\u0006\u000e\n\u0000\u0012\u0004\b8\u0010\u001d\u001a\u0004\b9\u0010\u001fR\u001c\u0010\b\u001a\u00020\u00058\u0006X\u0087\u0004¢\u0006\u000e\n\u0000\u0012\u0004\b:\u0010\u001d\u001a\u0004\b;\u0010\u001fR\u001c\u0010\u0006\u001a\u00020\u00058\u0006X\u0087\u0004¢\u0006\u000e\n\u0000\u0012\u0004\b<\u0010\u001d\u001a\u0004\b=\u0010\u001fR\u001c\u0010\u0004\u001a\u00020\u00058\u0006X\u0087\u0004¢\u0006\u000e\n\u0000\u0012\u0004\b>\u0010\u001d\u001a\u0004\b?\u0010\u001fR\u001c\u0010\u0011\u001a\u00020\u00058\u0006X\u0087\u0004¢\u0006\u000e\n\u0000\u0012\u0004\b@\u0010\u001d\u001a\u0004\bA\u0010\u001fR\u001c\u0010\f\u001a\u00020\u00058\u0006X\u0087\u0004¢\u0006\u000e\n\u0000\u0012\u0004\bB\u0010\u001d\u001a\u0004\bC\u0010\u001f¨\u0006g"}, m18d2 = {"Lzendesk/android/settings/internal/model/ColorThemeDto;", "", "seen1", "", "primaryColor", "", "onPrimaryColor", "messageColor", "onMessageColor", "actionColor", "onActionColor", "inboundMessageColor", "systemMessageColor", "backgroundColor", "onBackgroundColor", "elevatedColor", "notifyColor", "successColor", "dangerColor", "onDangerColor", "disabledColor", "iconColor", "actionBackgroundColor", "onActionBackgroundColor", "serializationConstructorMarker", "Lkotlinx/serialization/internal/SerializationConstructorMarker;", "(ILjava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Lkotlinx/serialization/internal/SerializationConstructorMarker;)V", "(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V", "getActionBackgroundColor$annotations", "()V", "getActionBackgroundColor", "()Ljava/lang/String;", "getActionColor$annotations", "getActionColor", "getBackgroundColor$annotations", "getBackgroundColor", "getDangerColor$annotations", "getDangerColor", "getDisabledColor$annotations", "getDisabledColor", "getElevatedColor$annotations", "getElevatedColor", "getIconColor$annotations", "getIconColor", "getInboundMessageColor$annotations", "getInboundMessageColor", "getMessageColor$annotations", "getMessageColor", "getNotifyColor$annotations", "getNotifyColor", "getOnActionBackgroundColor$annotations", "getOnActionBackgroundColor", "getOnActionColor$annotations", "getOnActionColor", "getOnBackgroundColor$annotations", "getOnBackgroundColor", "getOnDangerColor$annotations", "getOnDangerColor", "getOnMessageColor$annotations", "getOnMessageColor", "getOnPrimaryColor$annotations", "getOnPrimaryColor", "getPrimaryColor$annotations", "getPrimaryColor", "getSuccessColor$annotations", "getSuccessColor", "getSystemMessageColor$annotations", "getSystemMessageColor", "component1", "component10", "component11", "component12", "component13", "component14", "component15", "component16", "component17", "component18", "component19", "component2", "component3", "component4", "component5", "component6", "component7", "component8", "component9", "copy", "equals", "", "other", "hashCode", "toString", "write$Self", "", "self", "output", "Lkotlinx/serialization/encoding/CompositeEncoder;", "serialDesc", "Lkotlinx/serialization/descriptors/SerialDescriptor;", "write$Self$zendesk_zendesk_android", "$serializer", "Companion", "zendesk_zendesk-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
@Serializable
public final class ColorThemeDto {

    public static final Companion INSTANCE = new Companion(null);
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

    @SerialName("action_background_color")
    public static void getActionBackgroundColor$annotations() {
    }

    @SerialName("action_color")
    public static void getActionColor$annotations() {
    }

    @SerialName("background_color")
    public static void getBackgroundColor$annotations() {
    }

    @SerialName("danger_color")
    public static void getDangerColor$annotations() {
    }

    @SerialName("disabled_color")
    public static void getDisabledColor$annotations() {
    }

    @SerialName("elevated_color")
    public static void getElevatedColor$annotations() {
    }

    @SerialName("icon_color")
    public static void getIconColor$annotations() {
    }

    @SerialName("inbound_message_color")
    public static void getInboundMessageColor$annotations() {
    }

    @SerialName("message_color")
    public static void getMessageColor$annotations() {
    }

    @SerialName("notify_color")
    public static void getNotifyColor$annotations() {
    }

    @SerialName("on_action_background_color")
    public static void getOnActionBackgroundColor$annotations() {
    }

    @SerialName("on_action_color")
    public static void getOnActionColor$annotations() {
    }

    @SerialName("on_background_color")
    public static void getOnBackgroundColor$annotations() {
    }

    @SerialName("on_danger_color")
    public static void getOnDangerColor$annotations() {
    }

    @SerialName("on_message_color")
    public static void getOnMessageColor$annotations() {
    }

    @SerialName("on_primary_color")
    public static void getOnPrimaryColor$annotations() {
    }

    @SerialName("primary_color")
    public static void getPrimaryColor$annotations() {
    }

    @SerialName("success_color")
    public static void getSuccessColor$annotations() {
    }

    @SerialName("system_message_color")
    public static void getSystemMessageColor$annotations() {
    }

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

    public final ColorThemeDto copy(String primaryColor, String onPrimaryColor, String messageColor, String onMessageColor, String actionColor, String onActionColor, String inboundMessageColor, String systemMessageColor, String backgroundColor, String onBackgroundColor, String elevatedColor, String notifyColor, String successColor, String dangerColor, String onDangerColor, String disabledColor, String iconColor, String actionBackgroundColor, String onActionBackgroundColor) {
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
        return new ColorThemeDto(primaryColor, onPrimaryColor, messageColor, onMessageColor, actionColor, onActionColor, inboundMessageColor, systemMessageColor, backgroundColor, onBackgroundColor, elevatedColor, notifyColor, successColor, dangerColor, onDangerColor, disabledColor, iconColor, actionBackgroundColor, onActionBackgroundColor);
    }

    public boolean equals(Object other) {
        if (this == other) {
            return true;
        }
        if (!(other instanceof ColorThemeDto)) {
            return false;
        }
        ColorThemeDto colorThemeDto = (ColorThemeDto) other;
        return Intrinsics.areEqual(this.primaryColor, colorThemeDto.primaryColor) && Intrinsics.areEqual(this.onPrimaryColor, colorThemeDto.onPrimaryColor) && Intrinsics.areEqual(this.messageColor, colorThemeDto.messageColor) && Intrinsics.areEqual(this.onMessageColor, colorThemeDto.onMessageColor) && Intrinsics.areEqual(this.actionColor, colorThemeDto.actionColor) && Intrinsics.areEqual(this.onActionColor, colorThemeDto.onActionColor) && Intrinsics.areEqual(this.inboundMessageColor, colorThemeDto.inboundMessageColor) && Intrinsics.areEqual(this.systemMessageColor, colorThemeDto.systemMessageColor) && Intrinsics.areEqual(this.backgroundColor, colorThemeDto.backgroundColor) && Intrinsics.areEqual(this.onBackgroundColor, colorThemeDto.onBackgroundColor) && Intrinsics.areEqual(this.elevatedColor, colorThemeDto.elevatedColor) && Intrinsics.areEqual(this.notifyColor, colorThemeDto.notifyColor) && Intrinsics.areEqual(this.successColor, colorThemeDto.successColor) && Intrinsics.areEqual(this.dangerColor, colorThemeDto.dangerColor) && Intrinsics.areEqual(this.onDangerColor, colorThemeDto.onDangerColor) && Intrinsics.areEqual(this.disabledColor, colorThemeDto.disabledColor) && Intrinsics.areEqual(this.iconColor, colorThemeDto.iconColor) && Intrinsics.areEqual(this.actionBackgroundColor, colorThemeDto.actionBackgroundColor) && Intrinsics.areEqual(this.onActionBackgroundColor, colorThemeDto.onActionBackgroundColor);
    }

    public int hashCode() {
        return (((((((((((((((((((((((((((((((((((this.primaryColor.hashCode() * 31) + this.onPrimaryColor.hashCode()) * 31) + this.messageColor.hashCode()) * 31) + this.onMessageColor.hashCode()) * 31) + this.actionColor.hashCode()) * 31) + this.onActionColor.hashCode()) * 31) + this.inboundMessageColor.hashCode()) * 31) + this.systemMessageColor.hashCode()) * 31) + this.backgroundColor.hashCode()) * 31) + this.onBackgroundColor.hashCode()) * 31) + this.elevatedColor.hashCode()) * 31) + this.notifyColor.hashCode()) * 31) + this.successColor.hashCode()) * 31) + this.dangerColor.hashCode()) * 31) + this.onDangerColor.hashCode()) * 31) + this.disabledColor.hashCode()) * 31) + this.iconColor.hashCode()) * 31) + this.actionBackgroundColor.hashCode()) * 31) + this.onActionBackgroundColor.hashCode();
    }

    public String toString() {
        return "ColorThemeDto(primaryColor=" + this.primaryColor + ", onPrimaryColor=" + this.onPrimaryColor + ", messageColor=" + this.messageColor + ", onMessageColor=" + this.onMessageColor + ", actionColor=" + this.actionColor + ", onActionColor=" + this.onActionColor + ", inboundMessageColor=" + this.inboundMessageColor + ", systemMessageColor=" + this.systemMessageColor + ", backgroundColor=" + this.backgroundColor + ", onBackgroundColor=" + this.onBackgroundColor + ", elevatedColor=" + this.elevatedColor + ", notifyColor=" + this.notifyColor + ", successColor=" + this.successColor + ", dangerColor=" + this.dangerColor + ", onDangerColor=" + this.onDangerColor + ", disabledColor=" + this.disabledColor + ", iconColor=" + this.iconColor + ", actionBackgroundColor=" + this.actionBackgroundColor + ", onActionBackgroundColor=" + this.onActionBackgroundColor + ')';
    }

    @Metadata(m17d1 = {"\u0000\u0016\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\b\u0086\u0003\u0018\u00002\u00020\u0001B\u0007\b\u0002¢\u0006\u0002\u0010\u0002J\u000f\u0010\u0003\u001a\b\u0012\u0004\u0012\u00020\u00050\u0004HÆ\u0001¨\u0006\u0006"}, m18d2 = {"Lzendesk/android/settings/internal/model/ColorThemeDto$Companion;", "", "()V", "serializer", "Lkotlinx/serialization/KSerializer;", "Lzendesk/android/settings/internal/model/ColorThemeDto;", "zendesk_zendesk-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    public static final class Companion {
        public Companion(DefaultConstructorMarker defaultConstructorMarker) {
            this();
        }

        private Companion() {
        }

        public final KSerializer<ColorThemeDto> serializer() {
            return ColorThemeDto$$serializer.INSTANCE;
        }
    }

    @Deprecated(level = DeprecationLevel.HIDDEN, message = "This synthesized declaration should not be used directly", replaceWith = @ReplaceWith(expression = "", imports = {}))
    public ColorThemeDto(int i, @SerialName("primary_color") String str, @SerialName("on_primary_color") String str2, @SerialName("message_color") String str3, @SerialName("on_message_color") String str4, @SerialName("action_color") String str5, @SerialName("on_action_color") String str6, @SerialName("inbound_message_color") String str7, @SerialName("system_message_color") String str8, @SerialName("background_color") String str9, @SerialName("on_background_color") String str10, @SerialName("elevated_color") String str11, @SerialName("notify_color") String str12, @SerialName("success_color") String str13, @SerialName("danger_color") String str14, @SerialName("on_danger_color") String str15, @SerialName("disabled_color") String str16, @SerialName("icon_color") String str17, @SerialName("action_background_color") String str18, @SerialName("on_action_background_color") String str19, SerializationConstructorMarker serializationConstructorMarker) {
        if (524287 != (i & 524287)) {
            PluginExceptionsKt.throwMissingFieldException(i, 524287, ColorThemeDto$$serializer.INSTANCE.getDescriptor());
        }
        this.primaryColor = str;
        this.onPrimaryColor = str2;
        this.messageColor = str3;
        this.onMessageColor = str4;
        this.actionColor = str5;
        this.onActionColor = str6;
        this.inboundMessageColor = str7;
        this.systemMessageColor = str8;
        this.backgroundColor = str9;
        this.onBackgroundColor = str10;
        this.elevatedColor = str11;
        this.notifyColor = str12;
        this.successColor = str13;
        this.dangerColor = str14;
        this.onDangerColor = str15;
        this.disabledColor = str16;
        this.iconColor = str17;
        this.actionBackgroundColor = str18;
        this.onActionBackgroundColor = str19;
    }

    public ColorThemeDto(String primaryColor, String onPrimaryColor, String messageColor, String onMessageColor, String actionColor, String onActionColor, String inboundMessageColor, String systemMessageColor, String backgroundColor, String onBackgroundColor, String elevatedColor, String notifyColor, String successColor, String dangerColor, String onDangerColor, String disabledColor, String iconColor, String actionBackgroundColor, String onActionBackgroundColor) {
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

    @JvmStatic
    public static final void write$Self$zendesk_zendesk_android(ColorThemeDto self, CompositeEncoder output, SerialDescriptor serialDesc) {
        output.encodeStringElement(serialDesc, 0, self.primaryColor);
        output.encodeStringElement(serialDesc, 1, self.onPrimaryColor);
        output.encodeStringElement(serialDesc, 2, self.messageColor);
        output.encodeStringElement(serialDesc, 3, self.onMessageColor);
        output.encodeStringElement(serialDesc, 4, self.actionColor);
        output.encodeStringElement(serialDesc, 5, self.onActionColor);
        output.encodeStringElement(serialDesc, 6, self.inboundMessageColor);
        output.encodeStringElement(serialDesc, 7, self.systemMessageColor);
        output.encodeStringElement(serialDesc, 8, self.backgroundColor);
        output.encodeStringElement(serialDesc, 9, self.onBackgroundColor);
        output.encodeStringElement(serialDesc, 10, self.elevatedColor);
        output.encodeStringElement(serialDesc, 11, self.notifyColor);
        output.encodeStringElement(serialDesc, 12, self.successColor);
        output.encodeStringElement(serialDesc, 13, self.dangerColor);
        output.encodeStringElement(serialDesc, 14, self.onDangerColor);
        output.encodeStringElement(serialDesc, 15, self.disabledColor);
        output.encodeStringElement(serialDesc, 16, self.iconColor);
        output.encodeStringElement(serialDesc, 17, self.actionBackgroundColor);
        output.encodeStringElement(serialDesc, 18, self.onActionBackgroundColor);
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
