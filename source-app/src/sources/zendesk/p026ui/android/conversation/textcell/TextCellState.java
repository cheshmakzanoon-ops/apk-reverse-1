package zendesk.p026ui.android.conversation.textcell;

import java.util.List;
import kotlin.Metadata;
import kotlin.UByte$$ExternalSyntheticBackport0;
import kotlin.jvm.internal.DefaultConstructorMarker;
import kotlin.jvm.internal.Intrinsics;
import zendesk.p026ui.android.conversation.actionbutton.ActionButton;
import zendesk.p026ui.android.internal.ContextualMenuOption;

@Metadata(m17d1 = {"\u00006\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0000\n\u0002\u0010\u000e\n\u0000\n\u0002\u0010 \n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u000b\n\u0000\n\u0002\u0010\b\n\u0002\b?\n\u0002\u0018\u0002\n\u0002\b\u0003\b\u0087\b\u0018\u00002\u00020\u0001:\u0001NB·\u0001\b\u0000\u0012\b\b\u0002\u0010\u0002\u001a\u00020\u0003\u0012\u0010\b\u0002\u0010\u0004\u001a\n\u0012\u0004\u0012\u00020\u0006\u0018\u00010\u0005\u0012\u0010\b\u0002\u0010\u0007\u001a\n\u0012\u0004\u0012\u00020\b\u0018\u00010\u0005\u0012\b\b\u0002\u0010\t\u001a\u00020\n\u0012\n\b\u0003\u0010\u000b\u001a\u0004\u0018\u00010\f\u0012\n\b\u0003\u0010\r\u001a\u0004\u0018\u00010\f\u0012\n\b\u0003\u0010\u000e\u001a\u0004\u0018\u00010\f\u0012\n\b\u0003\u0010\u000f\u001a\u0004\u0018\u00010\f\u0012\n\b\u0003\u0010\u0010\u001a\u0004\u0018\u00010\f\u0012\n\b\u0003\u0010\u0011\u001a\u0004\u0018\u00010\f\u0012\n\b\u0003\u0010\u0012\u001a\u0004\u0018\u00010\f\u0012\n\b\u0003\u0010\u0013\u001a\u0004\u0018\u00010\f\u0012\n\b\u0003\u0010\u0014\u001a\u0004\u0018\u00010\f\u0012\n\b\u0003\u0010\u0015\u001a\u0004\u0018\u00010\f¢\u0006\u0002\u0010\u0016J\u000e\u0010*\u001a\u00020\u0003HÀ\u0003¢\u0006\u0002\b+J\u0012\u0010,\u001a\u0004\u0018\u00010\fHÀ\u0003¢\u0006\u0004\b-\u0010\u0018J\u0012\u0010.\u001a\u0004\u0018\u00010\fHÀ\u0003¢\u0006\u0004\b/\u0010\u0018J\u0012\u00100\u001a\u0004\u0018\u00010\fHÀ\u0003¢\u0006\u0004\b1\u0010\u0018J\u0012\u00102\u001a\u0004\u0018\u00010\fHÀ\u0003¢\u0006\u0004\b3\u0010\u0018J\u0012\u00104\u001a\u0004\u0018\u00010\fHÀ\u0003¢\u0006\u0004\b5\u0010\u0018J\u0016\u00106\u001a\n\u0012\u0004\u0012\u00020\u0006\u0018\u00010\u0005HÀ\u0003¢\u0006\u0002\b7J\u0016\u00108\u001a\n\u0012\u0004\u0012\u00020\b\u0018\u00010\u0005HÀ\u0003¢\u0006\u0002\b9J\u000e\u0010:\u001a\u00020\nHÀ\u0003¢\u0006\u0002\b;J\u0012\u0010<\u001a\u0004\u0018\u00010\fHÀ\u0003¢\u0006\u0004\b=\u0010\u0018J\u0012\u0010>\u001a\u0004\u0018\u00010\fHÀ\u0003¢\u0006\u0004\b?\u0010\u0018J\u0012\u0010@\u001a\u0004\u0018\u00010\fHÀ\u0003¢\u0006\u0004\bA\u0010\u0018J\u0012\u0010B\u001a\u0004\u0018\u00010\fHÀ\u0003¢\u0006\u0004\bC\u0010\u0018J\u0012\u0010D\u001a\u0004\u0018\u00010\fHÀ\u0003¢\u0006\u0004\bE\u0010\u0018J¾\u0001\u0010F\u001a\u00020\u00002\b\b\u0002\u0010\u0002\u001a\u00020\u00032\u0010\b\u0002\u0010\u0004\u001a\n\u0012\u0004\u0012\u00020\u0006\u0018\u00010\u00052\u0010\b\u0002\u0010\u0007\u001a\n\u0012\u0004\u0012\u00020\b\u0018\u00010\u00052\b\b\u0002\u0010\t\u001a\u00020\n2\n\b\u0003\u0010\u000b\u001a\u0004\u0018\u00010\f2\n\b\u0003\u0010\r\u001a\u0004\u0018\u00010\f2\n\b\u0003\u0010\u000e\u001a\u0004\u0018\u00010\f2\n\b\u0003\u0010\u000f\u001a\u0004\u0018\u00010\f2\n\b\u0003\u0010\u0010\u001a\u0004\u0018\u00010\f2\n\b\u0003\u0010\u0011\u001a\u0004\u0018\u00010\f2\n\b\u0003\u0010\u0012\u001a\u0004\u0018\u00010\f2\n\b\u0003\u0010\u0013\u001a\u0004\u0018\u00010\f2\n\b\u0003\u0010\u0014\u001a\u0004\u0018\u00010\f2\n\b\u0003\u0010\u0015\u001a\u0004\u0018\u00010\fHÆ\u0001¢\u0006\u0002\u0010GJ\u0013\u0010H\u001a\u00020\n2\b\u0010I\u001a\u0004\u0018\u00010\u0001HÖ\u0003J\t\u0010J\u001a\u00020\fHÖ\u0001J\u0006\u0010K\u001a\u00020LJ\t\u0010M\u001a\u00020\u0003HÖ\u0001R\u0018\u0010\u0012\u001a\u0004\u0018\u00010\fX\u0080\u0004¢\u0006\n\n\u0002\u0010\u0019\u001a\u0004\b\u0017\u0010\u0018R\u0018\u0010\u0013\u001a\u0004\u0018\u00010\fX\u0080\u0004¢\u0006\n\n\u0002\u0010\u0019\u001a\u0004\b\u001a\u0010\u0018R\u001c\u0010\u0004\u001a\n\u0012\u0004\u0012\u00020\u0006\u0018\u00010\u0005X\u0080\u0004¢\u0006\b\n\u0000\u001a\u0004\b\u001b\u0010\u001cR\u0018\u0010\u000e\u001a\u0004\u0018\u00010\fX\u0080\u0004¢\u0006\n\n\u0002\u0010\u0019\u001a\u0004\b\u001d\u0010\u0018R\u0018\u0010\r\u001a\u0004\u0018\u00010\fX\u0080\u0004¢\u0006\n\n\u0002\u0010\u0019\u001a\u0004\b\u001e\u0010\u0018R\u0018\u0010\u000b\u001a\u0004\u0018\u00010\fX\u0080\u0004¢\u0006\n\n\u0002\u0010\u0019\u001a\u0004\b\u001f\u0010\u0018R\u0014\u0010\t\u001a\u00020\nX\u0080\u0004¢\u0006\b\n\u0000\u001a\u0004\b \u0010!R\u0018\u0010\u0010\u001a\u0004\u0018\u00010\fX\u0080\u0004¢\u0006\n\n\u0002\u0010\u0019\u001a\u0004\b\"\u0010\u0018R\u0018\u0010\u0011\u001a\u0004\u0018\u00010\fX\u0080\u0004¢\u0006\n\n\u0002\u0010\u0019\u001a\u0004\b#\u0010\u0018R\u001c\u0010\u0007\u001a\n\u0012\u0004\u0012\u00020\b\u0018\u00010\u0005X\u0080\u0004¢\u0006\b\n\u0000\u001a\u0004\b$\u0010\u001cR\u0018\u0010\u0014\u001a\u0004\u0018\u00010\fX\u0080\u0004¢\u0006\n\n\u0002\u0010\u0019\u001a\u0004\b%\u0010\u0018R\u0018\u0010\u0015\u001a\u0004\u0018\u00010\fX\u0080\u0004¢\u0006\n\n\u0002\u0010\u0019\u001a\u0004\b&\u0010\u0018R\u0014\u0010\u0002\u001a\u00020\u0003X\u0080\u0004¢\u0006\b\n\u0000\u001a\u0004\b'\u0010(R\u0018\u0010\u000f\u001a\u0004\u0018\u00010\fX\u0080\u0004¢\u0006\n\n\u0002\u0010\u0019\u001a\u0004\b)\u0010\u0018¨\u0006O"}, m18d2 = {"Lzendesk/ui/android/conversation/textcell/TextCellState;", "", "messageText", "", "actions", "", "Lzendesk/ui/android/conversation/actionbutton/ActionButton;", "contextualMenuOptions", "Lzendesk/ui/android/internal/ContextualMenuOption;", "aiGenerated", "", "aiDisclaimerTextColor", "", "aiDisclaimerImageColor", "aiDisclaimerBorderColor", "textColor", "backgroundColor", "backgroundDrawable", "actionColor", "actionTextColor", "disabledColor", "disabledTextColor", "(Ljava/lang/String;Ljava/util/List;Ljava/util/List;ZLjava/lang/Integer;Ljava/lang/Integer;Ljava/lang/Integer;Ljava/lang/Integer;Ljava/lang/Integer;Ljava/lang/Integer;Ljava/lang/Integer;Ljava/lang/Integer;Ljava/lang/Integer;Ljava/lang/Integer;)V", "getActionColor$zendesk_ui_ui_android", "()Ljava/lang/Integer;", "Ljava/lang/Integer;", "getActionTextColor$zendesk_ui_ui_android", "getActions$zendesk_ui_ui_android", "()Ljava/util/List;", "getAiDisclaimerBorderColor$zendesk_ui_ui_android", "getAiDisclaimerImageColor$zendesk_ui_ui_android", "getAiDisclaimerTextColor$zendesk_ui_ui_android", "getAiGenerated$zendesk_ui_ui_android", "()Z", "getBackgroundColor$zendesk_ui_ui_android", "getBackgroundDrawable$zendesk_ui_ui_android", "getContextualMenuOptions$zendesk_ui_ui_android", "getDisabledColor$zendesk_ui_ui_android", "getDisabledTextColor$zendesk_ui_ui_android", "getMessageText$zendesk_ui_ui_android", "()Ljava/lang/String;", "getTextColor$zendesk_ui_ui_android", "component1", "component1$zendesk_ui_ui_android", "component10", "component10$zendesk_ui_ui_android", "component11", "component11$zendesk_ui_ui_android", "component12", "component12$zendesk_ui_ui_android", "component13", "component13$zendesk_ui_ui_android", "component14", "component14$zendesk_ui_ui_android", "component2", "component2$zendesk_ui_ui_android", "component3", "component3$zendesk_ui_ui_android", "component4", "component4$zendesk_ui_ui_android", "component5", "component5$zendesk_ui_ui_android", "component6", "component6$zendesk_ui_ui_android", "component7", "component7$zendesk_ui_ui_android", "component8", "component8$zendesk_ui_ui_android", "component9", "component9$zendesk_ui_ui_android", "copy", "(Ljava/lang/String;Ljava/util/List;Ljava/util/List;ZLjava/lang/Integer;Ljava/lang/Integer;Ljava/lang/Integer;Ljava/lang/Integer;Ljava/lang/Integer;Ljava/lang/Integer;Ljava/lang/Integer;Ljava/lang/Integer;Ljava/lang/Integer;Ljava/lang/Integer;)Lzendesk/ui/android/conversation/textcell/TextCellState;", "equals", "other", "hashCode", "toBuilder", "Lzendesk/ui/android/conversation/textcell/TextCellState$Builder;", "toString", "Builder", "zendesk.ui_ui-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
public final class TextCellState {
    public static final int $stable = 8;
    private final Integer actionColor;
    private final Integer actionTextColor;
    private final List<ActionButton> actions;
    private final Integer aiDisclaimerBorderColor;
    private final Integer aiDisclaimerImageColor;
    private final Integer aiDisclaimerTextColor;
    private final boolean aiGenerated;
    private final Integer backgroundColor;
    private final Integer backgroundDrawable;
    private final List<ContextualMenuOption> contextualMenuOptions;
    private final Integer disabledColor;
    private final Integer disabledTextColor;
    private final String messageText;
    private final Integer textColor;

    public TextCellState() {
        this(null, null, null, false, null, null, null, null, null, null, null, null, null, null, 16383, null);
    }

    public static TextCellState copy$default(TextCellState textCellState, String str, List list, List list2, boolean z, Integer num, Integer num2, Integer num3, Integer num4, Integer num5, Integer num6, Integer num7, Integer num8, Integer num9, Integer num10, int i, Object obj) {
        return textCellState.copy((i & 1) != 0 ? textCellState.messageText : str, (i & 2) != 0 ? textCellState.actions : list, (i & 4) != 0 ? textCellState.contextualMenuOptions : list2, (i & 8) != 0 ? textCellState.aiGenerated : z, (i & 16) != 0 ? textCellState.aiDisclaimerTextColor : num, (i & 32) != 0 ? textCellState.aiDisclaimerImageColor : num2, (i & 64) != 0 ? textCellState.aiDisclaimerBorderColor : num3, (i & 128) != 0 ? textCellState.textColor : num4, (i & 256) != 0 ? textCellState.backgroundColor : num5, (i & 512) != 0 ? textCellState.backgroundDrawable : num6, (i & 1024) != 0 ? textCellState.actionColor : num7, (i & 2048) != 0 ? textCellState.actionTextColor : num8, (i & 4096) != 0 ? textCellState.disabledColor : num9, (i & 8192) != 0 ? textCellState.disabledTextColor : num10);
    }

    public final String getMessageText() {
        return this.messageText;
    }

    public final Integer getBackgroundDrawable() {
        return this.backgroundDrawable;
    }

    public final Integer getActionColor() {
        return this.actionColor;
    }

    public final Integer getActionTextColor() {
        return this.actionTextColor;
    }

    public final Integer getDisabledColor() {
        return this.disabledColor;
    }

    public final Integer getDisabledTextColor() {
        return this.disabledTextColor;
    }

    public final List<ActionButton> component2$zendesk_ui_ui_android() {
        return this.actions;
    }

    public final List<ContextualMenuOption> component3$zendesk_ui_ui_android() {
        return this.contextualMenuOptions;
    }

    public final boolean getAiGenerated() {
        return this.aiGenerated;
    }

    public final Integer getAiDisclaimerTextColor() {
        return this.aiDisclaimerTextColor;
    }

    public final Integer getAiDisclaimerImageColor() {
        return this.aiDisclaimerImageColor;
    }

    public final Integer getAiDisclaimerBorderColor() {
        return this.aiDisclaimerBorderColor;
    }

    public final Integer getTextColor() {
        return this.textColor;
    }

    public final Integer getBackgroundColor() {
        return this.backgroundColor;
    }

    public final TextCellState copy(String messageText, List<ActionButton> actions, List<ContextualMenuOption> contextualMenuOptions, boolean aiGenerated, Integer aiDisclaimerTextColor, Integer aiDisclaimerImageColor, Integer aiDisclaimerBorderColor, Integer textColor, Integer backgroundColor, Integer backgroundDrawable, Integer actionColor, Integer actionTextColor, Integer disabledColor, Integer disabledTextColor) {
        Intrinsics.checkNotNullParameter(messageText, "messageText");
        return new TextCellState(messageText, actions, contextualMenuOptions, aiGenerated, aiDisclaimerTextColor, aiDisclaimerImageColor, aiDisclaimerBorderColor, textColor, backgroundColor, backgroundDrawable, actionColor, actionTextColor, disabledColor, disabledTextColor);
    }

    public boolean equals(Object other) {
        if (this == other) {
            return true;
        }
        if (!(other instanceof TextCellState)) {
            return false;
        }
        TextCellState textCellState = (TextCellState) other;
        return Intrinsics.areEqual(this.messageText, textCellState.messageText) && Intrinsics.areEqual(this.actions, textCellState.actions) && Intrinsics.areEqual(this.contextualMenuOptions, textCellState.contextualMenuOptions) && this.aiGenerated == textCellState.aiGenerated && Intrinsics.areEqual(this.aiDisclaimerTextColor, textCellState.aiDisclaimerTextColor) && Intrinsics.areEqual(this.aiDisclaimerImageColor, textCellState.aiDisclaimerImageColor) && Intrinsics.areEqual(this.aiDisclaimerBorderColor, textCellState.aiDisclaimerBorderColor) && Intrinsics.areEqual(this.textColor, textCellState.textColor) && Intrinsics.areEqual(this.backgroundColor, textCellState.backgroundColor) && Intrinsics.areEqual(this.backgroundDrawable, textCellState.backgroundDrawable) && Intrinsics.areEqual(this.actionColor, textCellState.actionColor) && Intrinsics.areEqual(this.actionTextColor, textCellState.actionTextColor) && Intrinsics.areEqual(this.disabledColor, textCellState.disabledColor) && Intrinsics.areEqual(this.disabledTextColor, textCellState.disabledTextColor);
    }

    public int hashCode() {
        int iHashCode = this.messageText.hashCode() * 31;
        List<ActionButton> list = this.actions;
        int iHashCode2 = (iHashCode + (list == null ? 0 : list.hashCode())) * 31;
        List<ContextualMenuOption> list2 = this.contextualMenuOptions;
        int iHashCode3 = (((iHashCode2 + (list2 == null ? 0 : list2.hashCode())) * 31) + UByte$$ExternalSyntheticBackport0.m30m(this.aiGenerated)) * 31;
        Integer num = this.aiDisclaimerTextColor;
        int iHashCode4 = (iHashCode3 + (num == null ? 0 : num.hashCode())) * 31;
        Integer num2 = this.aiDisclaimerImageColor;
        int iHashCode5 = (iHashCode4 + (num2 == null ? 0 : num2.hashCode())) * 31;
        Integer num3 = this.aiDisclaimerBorderColor;
        int iHashCode6 = (iHashCode5 + (num3 == null ? 0 : num3.hashCode())) * 31;
        Integer num4 = this.textColor;
        int iHashCode7 = (iHashCode6 + (num4 == null ? 0 : num4.hashCode())) * 31;
        Integer num5 = this.backgroundColor;
        int iHashCode8 = (iHashCode7 + (num5 == null ? 0 : num5.hashCode())) * 31;
        Integer num6 = this.backgroundDrawable;
        int iHashCode9 = (iHashCode8 + (num6 == null ? 0 : num6.hashCode())) * 31;
        Integer num7 = this.actionColor;
        int iHashCode10 = (iHashCode9 + (num7 == null ? 0 : num7.hashCode())) * 31;
        Integer num8 = this.actionTextColor;
        int iHashCode11 = (iHashCode10 + (num8 == null ? 0 : num8.hashCode())) * 31;
        Integer num9 = this.disabledColor;
        int iHashCode12 = (iHashCode11 + (num9 == null ? 0 : num9.hashCode())) * 31;
        Integer num10 = this.disabledTextColor;
        return iHashCode12 + (num10 != null ? num10.hashCode() : 0);
    }

    public String toString() {
        return "TextCellState(messageText=" + this.messageText + ", actions=" + this.actions + ", contextualMenuOptions=" + this.contextualMenuOptions + ", aiGenerated=" + this.aiGenerated + ", aiDisclaimerTextColor=" + this.aiDisclaimerTextColor + ", aiDisclaimerImageColor=" + this.aiDisclaimerImageColor + ", aiDisclaimerBorderColor=" + this.aiDisclaimerBorderColor + ", textColor=" + this.textColor + ", backgroundColor=" + this.backgroundColor + ", backgroundDrawable=" + this.backgroundDrawable + ", actionColor=" + this.actionColor + ", actionTextColor=" + this.actionTextColor + ", disabledColor=" + this.disabledColor + ", disabledTextColor=" + this.disabledTextColor + ')';
    }

    public TextCellState(String messageText, List<ActionButton> list, List<ContextualMenuOption> list2, boolean z, Integer num, Integer num2, Integer num3, Integer num4, Integer num5, Integer num6, Integer num7, Integer num8, Integer num9, Integer num10) {
        Intrinsics.checkNotNullParameter(messageText, "messageText");
        this.messageText = messageText;
        this.actions = list;
        this.contextualMenuOptions = list2;
        this.aiGenerated = z;
        this.aiDisclaimerTextColor = num;
        this.aiDisclaimerImageColor = num2;
        this.aiDisclaimerBorderColor = num3;
        this.textColor = num4;
        this.backgroundColor = num5;
        this.backgroundDrawable = num6;
        this.actionColor = num7;
        this.actionTextColor = num8;
        this.disabledColor = num9;
        this.disabledTextColor = num10;
    }

    public TextCellState(String str, List list, List list2, boolean z, Integer num, Integer num2, Integer num3, Integer num4, Integer num5, Integer num6, Integer num7, Integer num8, Integer num9, Integer num10, int i, DefaultConstructorMarker defaultConstructorMarker) {
        this((i & 1) != 0 ? "" : str, (i & 2) != 0 ? null : list, (i & 4) != 0 ? null : list2, (i & 8) != 0 ? false : z, (i & 16) != 0 ? null : num, (i & 32) != 0 ? null : num2, (i & 64) != 0 ? null : num3, (i & 128) != 0 ? null : num4, (i & 256) != 0 ? null : num5, (i & 512) != 0 ? null : num6, (i & 1024) != 0 ? null : num7, (i & 2048) != 0 ? null : num8, (i & 4096) != 0 ? null : num9, (i & 8192) == 0 ? num10 : null);
    }

    public final String getMessageText$zendesk_ui_ui_android() {
        return this.messageText;
    }

    public final List<ActionButton> getActions$zendesk_ui_ui_android() {
        return this.actions;
    }

    public final List<ContextualMenuOption> getContextualMenuOptions$zendesk_ui_ui_android() {
        return this.contextualMenuOptions;
    }

    public final boolean getAiGenerated$zendesk_ui_ui_android() {
        return this.aiGenerated;
    }

    public final Integer getAiDisclaimerTextColor$zendesk_ui_ui_android() {
        return this.aiDisclaimerTextColor;
    }

    public final Integer getAiDisclaimerImageColor$zendesk_ui_ui_android() {
        return this.aiDisclaimerImageColor;
    }

    public final Integer getAiDisclaimerBorderColor$zendesk_ui_ui_android() {
        return this.aiDisclaimerBorderColor;
    }

    public final Integer getTextColor$zendesk_ui_ui_android() {
        return this.textColor;
    }

    public final Integer getBackgroundColor$zendesk_ui_ui_android() {
        return this.backgroundColor;
    }

    public final Integer getBackgroundDrawable$zendesk_ui_ui_android() {
        return this.backgroundDrawable;
    }

    public final Integer getActionColor$zendesk_ui_ui_android() {
        return this.actionColor;
    }

    public final Integer getActionTextColor$zendesk_ui_ui_android() {
        return this.actionTextColor;
    }

    public final Integer getDisabledColor$zendesk_ui_ui_android() {
        return this.disabledColor;
    }

    public final Integer getDisabledTextColor$zendesk_ui_ui_android() {
        return this.disabledTextColor;
    }

    public final Builder toBuilder() {
        return new Builder(this);
    }

    @Metadata(m17d1 = {"\u0000:\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0004\n\u0002\u0010\b\n\u0000\n\u0002\u0010 \n\u0002\u0018\u0002\n\u0002\b\u0004\n\u0002\u0010\u000b\n\u0002\b\u0007\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u000e\n\u0002\b\u0002\b\u0007\u0018\u00002\u00020\u0001B\u000f\b\u0010\u0012\u0006\u0010\u0002\u001a\u00020\u0003¢\u0006\u0002\u0010\u0004B\u0005¢\u0006\u0002\u0010\u0005J\u0010\u0010\u0006\u001a\u00020\u00002\b\b\u0001\u0010\u0007\u001a\u00020\bJ\u0014\u0010\t\u001a\u00020\u00002\f\u0010\t\u001a\b\u0012\u0004\u0012\u00020\u000b0\nJ\u0010\u0010\f\u001a\u00020\u00002\b\b\u0001\u0010\u0007\u001a\u00020\bJ\u0010\u0010\r\u001a\u00020\u00002\b\b\u0001\u0010\u0007\u001a\u00020\bJ\u0010\u0010\u000e\u001a\u00020\u00002\b\b\u0001\u0010\u0007\u001a\u00020\bJ\u000e\u0010\u000f\u001a\u00020\u00002\u0006\u0010\u000f\u001a\u00020\u0010J\u0010\u0010\u0011\u001a\u00020\u00002\b\b\u0001\u0010\u0007\u001a\u00020\bJ\u0017\u0010\u0012\u001a\u00020\u00002\n\b\u0001\u0010\u0013\u001a\u0004\u0018\u00010\b¢\u0006\u0002\u0010\u0014J\u0006\u0010\u0015\u001a\u00020\u0003J\u0014\u0010\u0016\u001a\u00020\u00002\f\u0010\u0017\u001a\b\u0012\u0004\u0012\u00020\u00180\nJ\u000e\u0010\u0019\u001a\u00020\u00002\u0006\u0010\u0019\u001a\u00020\u001aJ\u0010\u0010\u001b\u001a\u00020\u00002\b\b\u0001\u0010\u0007\u001a\u00020\bR\u000e\u0010\u0002\u001a\u00020\u0003X\u0082\u000e¢\u0006\u0002\n\u0000¨\u0006\u001c"}, m18d2 = {"Lzendesk/ui/android/conversation/textcell/TextCellState$Builder;", "", "state", "Lzendesk/ui/android/conversation/textcell/TextCellState;", "(Lzendesk/ui/android/conversation/textcell/TextCellState;)V", "()V", "actionTextColor", "color", "", "actions", "", "Lzendesk/ui/android/conversation/actionbutton/ActionButton;", "aiDisclaimerBorderColor", "aiDisclaimerImageColor", "aiDisclaimerTextColor", "aiGenerated", "", "backgroundColor", "backgroundDrawable", "drawable", "(Ljava/lang/Integer;)Lzendesk/ui/android/conversation/textcell/TextCellState$Builder;", "build", "contextualMenuOptions", "menuOptions", "Lzendesk/ui/android/internal/ContextualMenuOption;", "messageText", "", "textColor", "zendesk.ui_ui-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    public static final class Builder {
        public static final int $stable = 8;
        private TextCellState state;

        public Builder() {
            this.state = new TextCellState(null, null, null, false, null, null, null, null, null, null, null, null, null, null, 16383, null);
        }

        public Builder(TextCellState state) {
            this();
            Intrinsics.checkNotNullParameter(state, "state");
            this.state = state;
        }

        public final Builder messageText(String messageText) {
            Intrinsics.checkNotNullParameter(messageText, "messageText");
            this.state = TextCellState.copy$default(this.state, messageText, null, null, false, null, null, null, null, null, null, null, null, null, null, 16382, null);
            return this;
        }

        public final Builder aiGenerated(boolean aiGenerated) {
            this.state = TextCellState.copy$default(this.state, null, null, null, aiGenerated, null, null, null, null, null, null, null, null, null, null, 16375, null);
            return this;
        }

        public final Builder aiDisclaimerTextColor(int color) {
            this.state = TextCellState.copy$default(this.state, null, null, null, false, Integer.valueOf(color), null, null, null, null, null, null, null, null, null, 16367, null);
            return this;
        }

        public final Builder aiDisclaimerImageColor(int color) {
            this.state = TextCellState.copy$default(this.state, null, null, null, false, null, Integer.valueOf(color), null, null, null, null, null, null, null, null, 16351, null);
            return this;
        }

        public final Builder aiDisclaimerBorderColor(int color) {
            this.state = TextCellState.copy$default(this.state, null, null, null, false, null, null, Integer.valueOf(color), null, null, null, null, null, null, null, 16319, null);
            return this;
        }

        public final Builder textColor(int color) {
            this.state = TextCellState.copy$default(this.state, null, null, null, false, null, null, null, Integer.valueOf(color), null, null, null, null, null, null, 16255, null);
            return this;
        }

        public final Builder backgroundColor(int color) {
            this.state = TextCellState.copy$default(this.state, null, null, null, false, null, null, null, null, Integer.valueOf(color), null, null, null, null, null, 16127, null);
            return this;
        }

        public final Builder backgroundDrawable(Integer drawable) {
            this.state = TextCellState.copy$default(this.state, null, null, null, false, null, null, null, null, null, drawable, null, null, null, null, 15871, null);
            return this;
        }

        public final Builder actions(List<ActionButton> actions) {
            Intrinsics.checkNotNullParameter(actions, "actions");
            this.state = TextCellState.copy$default(this.state, null, actions, null, false, null, null, null, null, null, null, null, null, null, null, 16381, null);
            return this;
        }

        public final Builder actionTextColor(int color) {
            this.state = TextCellState.copy$default(this.state, null, null, null, false, null, null, null, null, null, null, null, Integer.valueOf(color), null, null, 14335, null);
            return this;
        }

        public final Builder contextualMenuOptions(List<ContextualMenuOption> menuOptions) {
            Intrinsics.checkNotNullParameter(menuOptions, "menuOptions");
            this.state = TextCellState.copy$default(this.state, null, null, menuOptions, false, null, null, null, null, null, null, null, null, null, null, 16379, null);
            return this;
        }

        public final TextCellState getState() {
            return this.state;
        }
    }
}
