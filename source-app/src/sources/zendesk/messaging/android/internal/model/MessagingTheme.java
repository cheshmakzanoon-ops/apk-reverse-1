package zendesk.messaging.android.internal.model;

import android.content.Context;
import android.graphics.Color;
import androidx.core.content.ContextCompat;
import kotlin.Metadata;
import kotlin.jvm.internal.DefaultConstructorMarker;
import kotlin.jvm.internal.Intrinsics;
import zendesk.android.messaging.model.ColorTheme;
import zendesk.android.messaging.model.UserColors;
import zendesk.messaging.C1256R;

@Metadata(m17d1 = {"\u0000\"\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0000\n\u0002\u0010\b\n\u0002\b<\n\u0002\u0010\u000b\n\u0002\b\u0003\n\u0002\u0010\u000e\n\u0002\b\u0002\b\u0080\b\u0018\u0000 E2\u00020\u0001:\u0001EBÃ\u0001\u0012\b\b\u0001\u0010\u0002\u001a\u00020\u0003\u0012\b\b\u0001\u0010\u0004\u001a\u00020\u0003\u0012\b\b\u0001\u0010\u0005\u001a\u00020\u0003\u0012\b\b\u0001\u0010\u0006\u001a\u00020\u0003\u0012\b\b\u0001\u0010\u0007\u001a\u00020\u0003\u0012\b\b\u0001\u0010\b\u001a\u00020\u0003\u0012\b\b\u0001\u0010\t\u001a\u00020\u0003\u0012\b\b\u0001\u0010\n\u001a\u00020\u0003\u0012\b\b\u0001\u0010\u000b\u001a\u00020\u0003\u0012\b\b\u0001\u0010\f\u001a\u00020\u0003\u0012\b\b\u0001\u0010\r\u001a\u00020\u0003\u0012\b\b\u0001\u0010\u000e\u001a\u00020\u0003\u0012\b\b\u0001\u0010\u000f\u001a\u00020\u0003\u0012\b\b\u0001\u0010\u0010\u001a\u00020\u0003\u0012\b\b\u0001\u0010\u0011\u001a\u00020\u0003\u0012\b\b\u0001\u0010\u0012\u001a\u00020\u0003\u0012\b\b\u0001\u0010\u0013\u001a\u00020\u0003\u0012\b\b\u0001\u0010\u0014\u001a\u00020\u0003\u0012\b\b\u0001\u0010\u0015\u001a\u00020\u0003¢\u0006\u0002\u0010\u0016J\t\u0010+\u001a\u00020\u0003HÆ\u0003J\t\u0010,\u001a\u00020\u0003HÆ\u0003J\t\u0010-\u001a\u00020\u0003HÆ\u0003J\t\u0010.\u001a\u00020\u0003HÆ\u0003J\t\u0010/\u001a\u00020\u0003HÆ\u0003J\t\u00100\u001a\u00020\u0003HÆ\u0003J\t\u00101\u001a\u00020\u0003HÆ\u0003J\t\u00102\u001a\u00020\u0003HÆ\u0003J\t\u00103\u001a\u00020\u0003HÆ\u0003J\t\u00104\u001a\u00020\u0003HÆ\u0003J\t\u00105\u001a\u00020\u0003HÆ\u0003J\t\u00106\u001a\u00020\u0003HÆ\u0003J\t\u00107\u001a\u00020\u0003HÆ\u0003J\t\u00108\u001a\u00020\u0003HÆ\u0003J\t\u00109\u001a\u00020\u0003HÆ\u0003J\t\u0010:\u001a\u00020\u0003HÆ\u0003J\t\u0010;\u001a\u00020\u0003HÆ\u0003J\t\u0010<\u001a\u00020\u0003HÆ\u0003J\t\u0010=\u001a\u00020\u0003HÆ\u0003JÇ\u0001\u0010>\u001a\u00020\u00002\b\b\u0003\u0010\u0002\u001a\u00020\u00032\b\b\u0003\u0010\u0004\u001a\u00020\u00032\b\b\u0003\u0010\u0005\u001a\u00020\u00032\b\b\u0003\u0010\u0006\u001a\u00020\u00032\b\b\u0003\u0010\u0007\u001a\u00020\u00032\b\b\u0003\u0010\b\u001a\u00020\u00032\b\b\u0003\u0010\t\u001a\u00020\u00032\b\b\u0003\u0010\n\u001a\u00020\u00032\b\b\u0003\u0010\u000b\u001a\u00020\u00032\b\b\u0003\u0010\f\u001a\u00020\u00032\b\b\u0003\u0010\r\u001a\u00020\u00032\b\b\u0003\u0010\u000e\u001a\u00020\u00032\b\b\u0003\u0010\u000f\u001a\u00020\u00032\b\b\u0003\u0010\u0010\u001a\u00020\u00032\b\b\u0003\u0010\u0011\u001a\u00020\u00032\b\b\u0003\u0010\u0012\u001a\u00020\u00032\b\b\u0003\u0010\u0013\u001a\u00020\u00032\b\b\u0003\u0010\u0014\u001a\u00020\u00032\b\b\u0003\u0010\u0015\u001a\u00020\u0003HÆ\u0001J\u0013\u0010?\u001a\u00020@2\b\u0010A\u001a\u0004\u0018\u00010\u0001HÖ\u0003J\t\u0010B\u001a\u00020\u0003HÖ\u0001J\t\u0010C\u001a\u00020DHÖ\u0001R\u0011\u0010\u0014\u001a\u00020\u0003¢\u0006\b\n\u0000\u001a\u0004\b\u0017\u0010\u0018R\u0011\u0010\u0007\u001a\u00020\u0003¢\u0006\b\n\u0000\u001a\u0004\b\u0019\u0010\u0018R\u0011\u0010\u000b\u001a\u00020\u0003¢\u0006\b\n\u0000\u001a\u0004\b\u001a\u0010\u0018R\u0011\u0010\u0010\u001a\u00020\u0003¢\u0006\b\n\u0000\u001a\u0004\b\u001b\u0010\u0018R\u0011\u0010\u0012\u001a\u00020\u0003¢\u0006\b\n\u0000\u001a\u0004\b\u001c\u0010\u0018R\u0011\u0010\r\u001a\u00020\u0003¢\u0006\b\n\u0000\u001a\u0004\b\u001d\u0010\u0018R\u0011\u0010\u0013\u001a\u00020\u0003¢\u0006\b\n\u0000\u001a\u0004\b\u001e\u0010\u0018R\u0011\u0010\t\u001a\u00020\u0003¢\u0006\b\n\u0000\u001a\u0004\b\u001f\u0010\u0018R\u0011\u0010\u0005\u001a\u00020\u0003¢\u0006\b\n\u0000\u001a\u0004\b \u0010\u0018R\u0011\u0010\u000e\u001a\u00020\u0003¢\u0006\b\n\u0000\u001a\u0004\b!\u0010\u0018R\u0011\u0010\u0015\u001a\u00020\u0003¢\u0006\b\n\u0000\u001a\u0004\b\"\u0010\u0018R\u0011\u0010\b\u001a\u00020\u0003¢\u0006\b\n\u0000\u001a\u0004\b#\u0010\u0018R\u0011\u0010\f\u001a\u00020\u0003¢\u0006\b\n\u0000\u001a\u0004\b$\u0010\u0018R\u0011\u0010\u0011\u001a\u00020\u0003¢\u0006\b\n\u0000\u001a\u0004\b%\u0010\u0018R\u0011\u0010\u0006\u001a\u00020\u0003¢\u0006\b\n\u0000\u001a\u0004\b&\u0010\u0018R\u0011\u0010\u0004\u001a\u00020\u0003¢\u0006\b\n\u0000\u001a\u0004\b'\u0010\u0018R\u0011\u0010\u0002\u001a\u00020\u0003¢\u0006\b\n\u0000\u001a\u0004\b(\u0010\u0018R\u0011\u0010\u000f\u001a\u00020\u0003¢\u0006\b\n\u0000\u001a\u0004\b)\u0010\u0018R\u0011\u0010\n\u001a\u00020\u0003¢\u0006\b\n\u0000\u001a\u0004\b*\u0010\u0018¨\u0006F"}, m18d2 = {"Lzendesk/messaging/android/internal/model/MessagingTheme;", "", "primaryColor", "", "onPrimaryColor", "messageColor", "onMessageColor", "actionColor", "onActionColor", "inboundMessageColor", "systemMessageColor", "backgroundColor", "onBackgroundColor", "elevatedColor", "notifyColor", "successColor", "dangerColor", "onDangerColor", "disabledColor", "iconColor", "actionBackgroundColor", "onActionBackgroundColor", "(IIIIIIIIIIIIIIIIIII)V", "getActionBackgroundColor", "()I", "getActionColor", "getBackgroundColor", "getDangerColor", "getDisabledColor", "getElevatedColor", "getIconColor", "getInboundMessageColor", "getMessageColor", "getNotifyColor", "getOnActionBackgroundColor", "getOnActionColor", "getOnBackgroundColor", "getOnDangerColor", "getOnMessageColor", "getOnPrimaryColor", "getPrimaryColor", "getSuccessColor", "getSystemMessageColor", "component1", "component10", "component11", "component12", "component13", "component14", "component15", "component16", "component17", "component18", "component19", "component2", "component3", "component4", "component5", "component6", "component7", "component8", "component9", "copy", "equals", "", "other", "hashCode", "toString", "", "Companion", "zendesk.messaging_messaging-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
public final class MessagingTheme {
    private final int actionBackgroundColor;
    private final int actionColor;
    private final int backgroundColor;
    private final int dangerColor;
    private final int disabledColor;
    private final int elevatedColor;
    private final int iconColor;
    private final int inboundMessageColor;
    private final int messageColor;
    private final int notifyColor;
    private final int onActionBackgroundColor;
    private final int onActionColor;
    private final int onBackgroundColor;
    private final int onDangerColor;
    private final int onMessageColor;
    private final int onPrimaryColor;
    private final int primaryColor;
    private final int successColor;
    private final int systemMessageColor;

    public static final Companion INSTANCE = new Companion(null);
    private static int defaultColour = 0;
    private static final MessagingTheme DEFAULT = new MessagingTheme(0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);

    public final int getPrimaryColor() {
        return this.primaryColor;
    }

    public final int getOnBackgroundColor() {
        return this.onBackgroundColor;
    }

    public final int getElevatedColor() {
        return this.elevatedColor;
    }

    public final int getNotifyColor() {
        return this.notifyColor;
    }

    public final int getSuccessColor() {
        return this.successColor;
    }

    public final int getDangerColor() {
        return this.dangerColor;
    }

    public final int getOnDangerColor() {
        return this.onDangerColor;
    }

    public final int getDisabledColor() {
        return this.disabledColor;
    }

    public final int getIconColor() {
        return this.iconColor;
    }

    public final int getActionBackgroundColor() {
        return this.actionBackgroundColor;
    }

    public final int getOnActionBackgroundColor() {
        return this.onActionBackgroundColor;
    }

    public final int getOnPrimaryColor() {
        return this.onPrimaryColor;
    }

    public final int getMessageColor() {
        return this.messageColor;
    }

    public final int getOnMessageColor() {
        return this.onMessageColor;
    }

    public final int getActionColor() {
        return this.actionColor;
    }

    public final int getOnActionColor() {
        return this.onActionColor;
    }

    public final int getInboundMessageColor() {
        return this.inboundMessageColor;
    }

    public final int getSystemMessageColor() {
        return this.systemMessageColor;
    }

    public final int getBackgroundColor() {
        return this.backgroundColor;
    }

    public final MessagingTheme copy(int primaryColor, int onPrimaryColor, int messageColor, int onMessageColor, int actionColor, int onActionColor, int inboundMessageColor, int systemMessageColor, int backgroundColor, int onBackgroundColor, int elevatedColor, int notifyColor, int successColor, int dangerColor, int onDangerColor, int disabledColor, int iconColor, int actionBackgroundColor, int onActionBackgroundColor) {
        return new MessagingTheme(primaryColor, onPrimaryColor, messageColor, onMessageColor, actionColor, onActionColor, inboundMessageColor, systemMessageColor, backgroundColor, onBackgroundColor, elevatedColor, notifyColor, successColor, dangerColor, onDangerColor, disabledColor, iconColor, actionBackgroundColor, onActionBackgroundColor);
    }

    public boolean equals(Object other) {
        if (this == other) {
            return true;
        }
        if (!(other instanceof MessagingTheme)) {
            return false;
        }
        MessagingTheme messagingTheme = (MessagingTheme) other;
        return this.primaryColor == messagingTheme.primaryColor && this.onPrimaryColor == messagingTheme.onPrimaryColor && this.messageColor == messagingTheme.messageColor && this.onMessageColor == messagingTheme.onMessageColor && this.actionColor == messagingTheme.actionColor && this.onActionColor == messagingTheme.onActionColor && this.inboundMessageColor == messagingTheme.inboundMessageColor && this.systemMessageColor == messagingTheme.systemMessageColor && this.backgroundColor == messagingTheme.backgroundColor && this.onBackgroundColor == messagingTheme.onBackgroundColor && this.elevatedColor == messagingTheme.elevatedColor && this.notifyColor == messagingTheme.notifyColor && this.successColor == messagingTheme.successColor && this.dangerColor == messagingTheme.dangerColor && this.onDangerColor == messagingTheme.onDangerColor && this.disabledColor == messagingTheme.disabledColor && this.iconColor == messagingTheme.iconColor && this.actionBackgroundColor == messagingTheme.actionBackgroundColor && this.onActionBackgroundColor == messagingTheme.onActionBackgroundColor;
    }

    public int hashCode() {
        return (((((((((((((((((((((((((((((((((((this.primaryColor * 31) + this.onPrimaryColor) * 31) + this.messageColor) * 31) + this.onMessageColor) * 31) + this.actionColor) * 31) + this.onActionColor) * 31) + this.inboundMessageColor) * 31) + this.systemMessageColor) * 31) + this.backgroundColor) * 31) + this.onBackgroundColor) * 31) + this.elevatedColor) * 31) + this.notifyColor) * 31) + this.successColor) * 31) + this.dangerColor) * 31) + this.onDangerColor) * 31) + this.disabledColor) * 31) + this.iconColor) * 31) + this.actionBackgroundColor) * 31) + this.onActionBackgroundColor;
    }

    public String toString() {
        return "MessagingTheme(primaryColor=" + this.primaryColor + ", onPrimaryColor=" + this.onPrimaryColor + ", messageColor=" + this.messageColor + ", onMessageColor=" + this.onMessageColor + ", actionColor=" + this.actionColor + ", onActionColor=" + this.onActionColor + ", inboundMessageColor=" + this.inboundMessageColor + ", systemMessageColor=" + this.systemMessageColor + ", backgroundColor=" + this.backgroundColor + ", onBackgroundColor=" + this.onBackgroundColor + ", elevatedColor=" + this.elevatedColor + ", notifyColor=" + this.notifyColor + ", successColor=" + this.successColor + ", dangerColor=" + this.dangerColor + ", onDangerColor=" + this.onDangerColor + ", disabledColor=" + this.disabledColor + ", iconColor=" + this.iconColor + ", actionBackgroundColor=" + this.actionBackgroundColor + ", onActionBackgroundColor=" + this.onActionBackgroundColor + ')';
    }

    public MessagingTheme(int i, int i2, int i3, int i4, int i5, int i6, int i7, int i8, int i9, int i10, int i11, int i12, int i13, int i14, int i15, int i16, int i17, int i18, int i19) {
        this.primaryColor = i;
        this.onPrimaryColor = i2;
        this.messageColor = i3;
        this.onMessageColor = i4;
        this.actionColor = i5;
        this.onActionColor = i6;
        this.inboundMessageColor = i7;
        this.systemMessageColor = i8;
        this.backgroundColor = i9;
        this.onBackgroundColor = i10;
        this.elevatedColor = i11;
        this.notifyColor = i12;
        this.successColor = i13;
        this.dangerColor = i14;
        this.onDangerColor = i15;
        this.disabledColor = i16;
        this.iconColor = i17;
        this.actionBackgroundColor = i18;
        this.onActionBackgroundColor = i19;
    }

    public final int getPrimaryColor() {
        return this.primaryColor;
    }

    public final int getOnPrimaryColor() {
        return this.onPrimaryColor;
    }

    public final int getMessageColor() {
        return this.messageColor;
    }

    public final int getOnMessageColor() {
        return this.onMessageColor;
    }

    public final int getActionColor() {
        return this.actionColor;
    }

    public final int getOnActionColor() {
        return this.onActionColor;
    }

    public final int getInboundMessageColor() {
        return this.inboundMessageColor;
    }

    public final int getSystemMessageColor() {
        return this.systemMessageColor;
    }

    public final int getBackgroundColor() {
        return this.backgroundColor;
    }

    public final int getOnBackgroundColor() {
        return this.onBackgroundColor;
    }

    public final int getElevatedColor() {
        return this.elevatedColor;
    }

    public final int getNotifyColor() {
        return this.notifyColor;
    }

    public final int getSuccessColor() {
        return this.successColor;
    }

    public final int getDangerColor() {
        return this.dangerColor;
    }

    public final int getOnDangerColor() {
        return this.onDangerColor;
    }

    public final int getDisabledColor() {
        return this.disabledColor;
    }

    public final int getIconColor() {
        return this.iconColor;
    }

    public final int getActionBackgroundColor() {
        return this.actionBackgroundColor;
    }

    public final int getOnActionBackgroundColor() {
        return this.onActionBackgroundColor;
    }

    @Metadata(m17d1 = {"\u00008\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0010\b\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0010\u000e\n\u0002\b\u0002\b\u0086\u0003\u0018\u00002\u00020\u0001B\u0007\b\u0002¢\u0006\u0002\u0010\u0002J\u001e\u0010\t\u001a\u00020\u00042\u0006\u0010\n\u001a\u00020\u000b2\u0006\u0010\f\u001a\u00020\r2\u0006\u0010\u000e\u001a\u00020\u000fJ \u0010\u0010\u001a\u00020\b2\u0006\u0010\n\u001a\u00020\u000b2\u0006\u0010\u0011\u001a\u00020\u00122\u0006\u0010\u0013\u001a\u00020\bH\u0003R\u0011\u0010\u0003\u001a\u00020\u0004¢\u0006\b\n\u0000\u001a\u0004\b\u0005\u0010\u0006R\u000e\u0010\u0007\u001a\u00020\bX\u0082\u000e¢\u0006\u0002\n\u0000¨\u0006\u0014"}, m18d2 = {"Lzendesk/messaging/android/internal/model/MessagingTheme$Companion;", "", "()V", "DEFAULT", "Lzendesk/messaging/android/internal/model/MessagingTheme;", "getDEFAULT", "()Lzendesk/messaging/android/internal/model/MessagingTheme;", "defaultColour", "", "from", "context", "Landroid/content/Context;", "colorTheme", "Lzendesk/android/messaging/model/ColorTheme;", "userColors", "Lzendesk/android/messaging/model/UserColors;", "parseColor", "colorCode", "", "defaultColorResId", "zendesk.messaging_messaging-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    public static final class Companion {
        public Companion(DefaultConstructorMarker defaultConstructorMarker) {
            this();
        }

        private Companion() {
        }

        public final MessagingTheme getDEFAULT() {
            return MessagingTheme.DEFAULT;
        }

        public final MessagingTheme from(Context context, ColorTheme colorTheme, UserColors userColors) {
            Intrinsics.checkNotNullParameter(context, "context");
            Intrinsics.checkNotNullParameter(colorTheme, "colorTheme");
            Intrinsics.checkNotNullParameter(userColors, "userColors");
            int color = parseColor(context, colorTheme.getPrimaryColor(), C1256R.color.zma_color_primary);
            Integer onPrimary = userColors.getOnPrimary();
            int iIntValue = onPrimary != null ? onPrimary.intValue() : parseColor(context, colorTheme.getOnPrimaryColor(), C1256R.color.zma_color_on_primary);
            int color2 = parseColor(context, colorTheme.getMessageColor(), C1256R.color.zma_color_message);
            Integer onMessage = userColors.getOnMessage();
            int iIntValue2 = onMessage != null ? onMessage.intValue() : parseColor(context, colorTheme.getOnMessageColor(), C1256R.color.zma_color_on_message);
            int color3 = parseColor(context, colorTheme.getActionColor(), C1256R.color.zma_color_action);
            Integer onAction = userColors.getOnAction();
            return new MessagingTheme(color, iIntValue, color2, iIntValue2, color3, onAction != null ? onAction.intValue() : parseColor(context, colorTheme.getOnActionColor(), C1256R.color.zma_color_on_action), parseColor(context, colorTheme.getInboundMessageColor(), C1256R.color.zma_color_inbound_message), parseColor(context, colorTheme.getSystemMessageColor(), C1256R.color.zma_color_system_message), parseColor(context, colorTheme.getBackgroundColor(), C1256R.color.zma_color_background), parseColor(context, colorTheme.getOnBackgroundColor(), C1256R.color.zma_color_on_background), parseColor(context, colorTheme.getElevatedColor(), C1256R.color.zma_color_elevated), parseColor(context, colorTheme.getNotifyColor(), C1256R.color.zma_color_notify), parseColor(context, colorTheme.getSuccessColor(), C1256R.color.zma_color_success), parseColor(context, colorTheme.getDangerColor(), C1256R.color.zma_color_danger), parseColor(context, colorTheme.getOnDangerColor(), C1256R.color.zma_color_on_danger), parseColor(context, colorTheme.getDisabledColor(), C1256R.color.zma_color_disabled), parseColor(context, colorTheme.getIconColor(), C1256R.color.zma_color_icon_color_default), parseColor(context, colorTheme.getActionBackgroundColor(), C1256R.color.zma_color_action_background), parseColor(context, colorTheme.getOnActionBackgroundColor(), C1256R.color.zma_color_on_action_background));
        }

        private final int parseColor(Context context, String colorCode, int defaultColorResId) {
            try {
                return Color.parseColor(colorCode);
            } catch (IllegalArgumentException unused) {
                return ContextCompat.getColor(context, defaultColorResId);
            } catch (StringIndexOutOfBoundsException unused2) {
                return ContextCompat.getColor(context, defaultColorResId);
            }
        }
    }
}
