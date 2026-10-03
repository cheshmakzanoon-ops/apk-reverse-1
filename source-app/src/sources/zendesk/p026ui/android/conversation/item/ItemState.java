package zendesk.p026ui.android.conversation.item;

import kotlin.Metadata;
import kotlin.jvm.internal.DefaultConstructorMarker;
import kotlin.jvm.internal.Intrinsics;

@Metadata(m17d1 = {"\u0000.\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\b\n\u0002\b\u0011\n\u0002\u0010\u000b\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u000e\n\u0002\b\u0002\b\u0087\b\u0018\u00002\u00020\u0001:\u0001\u001eB-\b\u0000\u0012\f\b\u0002\u0010\u0002\u001a\u0006\u0012\u0002\b\u00030\u0003\u0012\n\b\u0003\u0010\u0004\u001a\u0004\u0018\u00010\u0005\u0012\n\b\u0003\u0010\u0006\u001a\u0004\u0018\u00010\u0005¢\u0006\u0002\u0010\u0007J\u0012\u0010\u000e\u001a\u0006\u0012\u0002\b\u00030\u0003HÀ\u0003¢\u0006\u0002\b\u000fJ\u0012\u0010\u0010\u001a\u0004\u0018\u00010\u0005HÀ\u0003¢\u0006\u0004\b\u0011\u0010\u000bJ\u0012\u0010\u0012\u001a\u0004\u0018\u00010\u0005HÀ\u0003¢\u0006\u0004\b\u0013\u0010\u000bJ4\u0010\u0014\u001a\u00020\u00002\f\b\u0002\u0010\u0002\u001a\u0006\u0012\u0002\b\u00030\u00032\n\b\u0003\u0010\u0004\u001a\u0004\u0018\u00010\u00052\n\b\u0003\u0010\u0006\u001a\u0004\u0018\u00010\u0005HÆ\u0001¢\u0006\u0002\u0010\u0015J\u0013\u0010\u0016\u001a\u00020\u00172\b\u0010\u0018\u001a\u0004\u0018\u00010\u0001HÖ\u0003J\t\u0010\u0019\u001a\u00020\u0005HÖ\u0001J\u0006\u0010\u001a\u001a\u00020\u001bJ\t\u0010\u001c\u001a\u00020\u001dHÖ\u0001R\u0018\u0010\u0002\u001a\u0006\u0012\u0002\b\u00030\u0003X\u0080\u0004¢\u0006\b\n\u0000\u001a\u0004\b\b\u0010\tR\u0018\u0010\u0006\u001a\u0004\u0018\u00010\u0005X\u0080\u0004¢\u0006\n\n\u0002\u0010\f\u001a\u0004\b\n\u0010\u000bR\u0018\u0010\u0004\u001a\u0004\u0018\u00010\u0005X\u0080\u0004¢\u0006\n\n\u0002\u0010\f\u001a\u0004\b\r\u0010\u000b¨\u0006\u001f"}, m18d2 = {"Lzendesk/ui/android/conversation/item/ItemState;", "", "item", "Lzendesk/ui/android/conversation/item/Item;", "titleColor", "", "pressedColor", "(Lzendesk/ui/android/conversation/item/Item;Ljava/lang/Integer;Ljava/lang/Integer;)V", "getItem$zendesk_ui_ui_android", "()Lzendesk/ui/android/conversation/item/Item;", "getPressedColor$zendesk_ui_ui_android", "()Ljava/lang/Integer;", "Ljava/lang/Integer;", "getTitleColor$zendesk_ui_ui_android", "component1", "component1$zendesk_ui_ui_android", "component2", "component2$zendesk_ui_ui_android", "component3", "component3$zendesk_ui_ui_android", "copy", "(Lzendesk/ui/android/conversation/item/Item;Ljava/lang/Integer;Ljava/lang/Integer;)Lzendesk/ui/android/conversation/item/ItemState;", "equals", "", "other", "hashCode", "toBuilder", "Lzendesk/ui/android/conversation/item/ItemState$Builder;", "toString", "", "Builder", "zendesk.ui_ui-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
public final class ItemState {
    public static final int $stable = 8;
    private final Item<?> item;
    private final Integer pressedColor;
    private final Integer titleColor;

    public ItemState() {
        this(null, null, null, 7, null);
    }

    public static ItemState copy$default(ItemState itemState, Item item, Integer num, Integer num2, int i, Object obj) {
        if ((i & 1) != 0) {
            item = itemState.item;
        }
        if ((i & 2) != 0) {
            num = itemState.titleColor;
        }
        if ((i & 4) != 0) {
            num2 = itemState.pressedColor;
        }
        return itemState.copy(item, num, num2);
    }

    public final Item<?> component1$zendesk_ui_ui_android() {
        return this.item;
    }

    public final Integer getTitleColor() {
        return this.titleColor;
    }

    public final Integer getPressedColor() {
        return this.pressedColor;
    }

    public final ItemState copy(Item<?> item, Integer titleColor, Integer pressedColor) {
        Intrinsics.checkNotNullParameter(item, "item");
        return new ItemState(item, titleColor, pressedColor);
    }

    public boolean equals(Object other) {
        if (this == other) {
            return true;
        }
        if (!(other instanceof ItemState)) {
            return false;
        }
        ItemState itemState = (ItemState) other;
        return Intrinsics.areEqual(this.item, itemState.item) && Intrinsics.areEqual(this.titleColor, itemState.titleColor) && Intrinsics.areEqual(this.pressedColor, itemState.pressedColor);
    }

    public int hashCode() {
        int iHashCode = this.item.hashCode() * 31;
        Integer num = this.titleColor;
        int iHashCode2 = (iHashCode + (num == null ? 0 : num.hashCode())) * 31;
        Integer num2 = this.pressedColor;
        return iHashCode2 + (num2 != null ? num2.hashCode() : 0);
    }

    public String toString() {
        return "ItemState(item=" + this.item + ", titleColor=" + this.titleColor + ", pressedColor=" + this.pressedColor + ')';
    }

    public ItemState(Item<?> item, Integer num, Integer num2) {
        Intrinsics.checkNotNullParameter(item, "item");
        this.item = item;
        this.titleColor = num;
        this.pressedColor = num2;
    }

    public ItemState(Item item, Integer num, Integer num2, int i, DefaultConstructorMarker defaultConstructorMarker) {
        this((i & 1) != 0 ? new Item(null, null, null, null, null, 31, null) : item, (i & 2) != 0 ? null : num, (i & 4) != 0 ? null : num2);
    }

    public final Item<?> getItem$zendesk_ui_ui_android() {
        return this.item;
    }

    public final Integer getTitleColor$zendesk_ui_ui_android() {
        return this.titleColor;
    }

    public final Integer getPressedColor$zendesk_ui_ui_android() {
        return this.pressedColor;
    }

    public final Builder toBuilder() {
        return new Builder(this);
    }

    @Metadata(m17d1 = {"\u0000\"\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0004\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0010\b\n\u0002\b\u0002\b\u0007\u0018\u00002\u00020\u0001B\u000f\b\u0010\u0012\u0006\u0010\u0002\u001a\u00020\u0003¢\u0006\u0002\u0010\u0004B\u0005¢\u0006\u0002\u0010\u0005J\u0006\u0010\u0006\u001a\u00020\u0003J\u0012\u0010\u0007\u001a\u00020\u00002\n\u0010\u0007\u001a\u0006\u0012\u0002\b\u00030\bJ\u0010\u0010\t\u001a\u00020\u00002\b\b\u0001\u0010\n\u001a\u00020\u000bJ\u0010\u0010\f\u001a\u00020\u00002\b\b\u0001\u0010\n\u001a\u00020\u000bR\u000e\u0010\u0002\u001a\u00020\u0003X\u0082\u000e¢\u0006\u0002\n\u0000¨\u0006\r"}, m18d2 = {"Lzendesk/ui/android/conversation/item/ItemState$Builder;", "", "state", "Lzendesk/ui/android/conversation/item/ItemState;", "(Lzendesk/ui/android/conversation/item/ItemState;)V", "()V", "build", "item", "Lzendesk/ui/android/conversation/item/Item;", "pressedColor", "color", "", "titleColor", "zendesk.ui_ui-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    public static final class Builder {
        public static final int $stable = 8;
        private ItemState state;

        public Builder() {
            this.state = new ItemState(null, null, null, 7, null);
        }

        public Builder(ItemState state) {
            this();
            Intrinsics.checkNotNullParameter(state, "state");
            this.state = state;
        }

        public final Builder item(Item<?> item) {
            Intrinsics.checkNotNullParameter(item, "item");
            this.state = ItemState.copy$default(this.state, item, null, null, 6, null);
            return this;
        }

        public final Builder titleColor(int color) {
            this.state = ItemState.copy$default(this.state, null, Integer.valueOf(color), null, 5, null);
            return this;
        }

        public final Builder pressedColor(int color) {
            this.state = ItemState.copy$default(this.state, null, null, Integer.valueOf(color), 3, null);
            return this;
        }

        public final ItemState getState() {
            return this.state;
        }
    }
}
