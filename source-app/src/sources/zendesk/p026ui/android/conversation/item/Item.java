package zendesk.p026ui.android.conversation.item;

import java.util.UUID;
import kotlin.Metadata;
import kotlin.jvm.internal.DefaultConstructorMarker;
import kotlin.jvm.internal.Intrinsics;

@Metadata(m17d1 = {"\u0000$\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u0000\n\u0000\n\u0002\u0010\u000e\n\u0002\b\u0002\n\u0002\u0010\b\n\u0002\b\u0015\n\u0002\u0010\u000b\n\u0002\b\u0004\b\u0087\b\u0018\u0000*\u0004\b\u0000\u0010\u00012\u00020\u0002B=\u0012\b\b\u0002\u0010\u0003\u001a\u00020\u0004\u0012\b\b\u0002\u0010\u0005\u001a\u00020\u0004\u0012\n\b\u0003\u0010\u0006\u001a\u0004\u0018\u00010\u0007\u0012\n\b\u0002\u0010\b\u001a\u0004\u0018\u00010\u0004\u0012\n\b\u0002\u0010\t\u001a\u0004\u0018\u00018\u0000¢\u0006\u0002\u0010\nJ\t\u0010\u0015\u001a\u00020\u0004HÆ\u0003J\t\u0010\u0016\u001a\u00020\u0004HÆ\u0003J\u0010\u0010\u0017\u001a\u0004\u0018\u00010\u0007HÆ\u0003¢\u0006\u0002\u0010\u0010J\u000b\u0010\u0018\u001a\u0004\u0018\u00010\u0004HÆ\u0003J\u0010\u0010\u0019\u001a\u0004\u0018\u00018\u0000HÆ\u0003¢\u0006\u0002\u0010\u0013JL\u0010\u001a\u001a\b\u0012\u0004\u0012\u00028\u00000\u00002\b\b\u0002\u0010\u0003\u001a\u00020\u00042\b\b\u0002\u0010\u0005\u001a\u00020\u00042\n\b\u0003\u0010\u0006\u001a\u0004\u0018\u00010\u00072\n\b\u0002\u0010\b\u001a\u0004\u0018\u00010\u00042\n\b\u0002\u0010\t\u001a\u0004\u0018\u00018\u0000HÆ\u0001¢\u0006\u0002\u0010\u001bJ\u0013\u0010\u001c\u001a\u00020\u001d2\b\u0010\u001e\u001a\u0004\u0018\u00010\u0002HÖ\u0003J\t\u0010\u001f\u001a\u00020\u0007HÖ\u0001J\t\u0010 \u001a\u00020\u0004HÖ\u0001R\u0011\u0010\u0003\u001a\u00020\u0004¢\u0006\b\n\u0000\u001a\u0004\b\u000b\u0010\fR\u0013\u0010\b\u001a\u0004\u0018\u00010\u0004¢\u0006\b\n\u0000\u001a\u0004\b\r\u0010\fR\u0011\u0010\u0005\u001a\u00020\u0004¢\u0006\b\n\u0000\u001a\u0004\b\u000e\u0010\fR\u0015\u0010\u0006\u001a\u0004\u0018\u00010\u0007¢\u0006\n\n\u0002\u0010\u0011\u001a\u0004\b\u000f\u0010\u0010R\u0015\u0010\t\u001a\u0004\u0018\u00018\u0000¢\u0006\n\n\u0002\u0010\u0014\u001a\u0004\b\u0012\u0010\u0013¨\u0006!"}, m18d2 = {"Lzendesk/ui/android/conversation/item/Item;", "T", "", "id", "", "title", "titleColor", "", "subtitle", "value", "(Ljava/lang/String;Ljava/lang/String;Ljava/lang/Integer;Ljava/lang/String;Ljava/lang/Object;)V", "getId", "()Ljava/lang/String;", "getSubtitle", "getTitle", "getTitleColor", "()Ljava/lang/Integer;", "Ljava/lang/Integer;", "getValue", "()Ljava/lang/Object;", "Ljava/lang/Object;", "component1", "component2", "component3", "component4", "component5", "copy", "(Ljava/lang/String;Ljava/lang/String;Ljava/lang/Integer;Ljava/lang/String;Ljava/lang/Object;)Lzendesk/ui/android/conversation/item/Item;", "equals", "", "other", "hashCode", "toString", "zendesk.ui_ui-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
public final class Item<T> {
    public static final int $stable = 0;
    private final String id;
    private final String subtitle;
    private final String title;
    private final Integer titleColor;
    private final T value;

    public Item() {
        this(null, null, null, null, null, 31, null);
    }

    public static Item copy$default(Item item, String str, String str2, Integer num, String str3, Object obj, int i, Object obj2) {
        if ((i & 1) != 0) {
            str = item.id;
        }
        if ((i & 2) != 0) {
            str2 = item.title;
        }
        String str4 = str2;
        if ((i & 4) != 0) {
            num = item.titleColor;
        }
        Integer num2 = num;
        if ((i & 8) != 0) {
            str3 = item.subtitle;
        }
        String str5 = str3;
        if ((i & 16) != 0) {
            obj = item.value;
        }
        return item.copy(str, str4, num2, str5, obj);
    }

    public final String getId() {
        return this.id;
    }

    public final String getTitle() {
        return this.title;
    }

    public final Integer getTitleColor() {
        return this.titleColor;
    }

    public final String getSubtitle() {
        return this.subtitle;
    }

    public final T component5() {
        return this.value;
    }

    public final Item<T> copy(String id, String title, Integer titleColor, String subtitle, T value) {
        Intrinsics.checkNotNullParameter(id, "id");
        Intrinsics.checkNotNullParameter(title, "title");
        return new Item<>(id, title, titleColor, subtitle, value);
    }

    public boolean equals(Object other) {
        if (this == other) {
            return true;
        }
        if (!(other instanceof Item)) {
            return false;
        }
        Item item = (Item) other;
        return Intrinsics.areEqual(this.id, item.id) && Intrinsics.areEqual(this.title, item.title) && Intrinsics.areEqual(this.titleColor, item.titleColor) && Intrinsics.areEqual(this.subtitle, item.subtitle) && Intrinsics.areEqual(this.value, item.value);
    }

    public int hashCode() {
        int iHashCode = ((this.id.hashCode() * 31) + this.title.hashCode()) * 31;
        Integer num = this.titleColor;
        int iHashCode2 = (iHashCode + (num == null ? 0 : num.hashCode())) * 31;
        String str = this.subtitle;
        int iHashCode3 = (iHashCode2 + (str == null ? 0 : str.hashCode())) * 31;
        T t = this.value;
        return iHashCode3 + (t != null ? t.hashCode() : 0);
    }

    public String toString() {
        return "Item(id=" + this.id + ", title=" + this.title + ", titleColor=" + this.titleColor + ", subtitle=" + this.subtitle + ", value=" + this.value + ')';
    }

    public Item(String id, String title, Integer num, String str, T t) {
        Intrinsics.checkNotNullParameter(id, "id");
        Intrinsics.checkNotNullParameter(title, "title");
        this.id = id;
        this.title = title;
        this.titleColor = num;
        this.subtitle = str;
        this.value = t;
    }

    public Item(String str, String str2, Integer num, String str3, Object obj, int i, DefaultConstructorMarker defaultConstructorMarker) {
        if ((i & 1) != 0) {
            str = UUID.randomUUID().toString();
            Intrinsics.checkNotNullExpressionValue(str, "toString(...)");
        }
        this(str, (i & 2) != 0 ? "" : str2, (i & 4) != 0 ? null : num, (i & 8) != 0 ? null : str3, (i & 16) != 0 ? null : obj);
    }

    public final String getId() {
        return this.id;
    }

    public final String getTitle() {
        return this.title;
    }

    public final Integer getTitleColor() {
        return this.titleColor;
    }

    public final String getSubtitle() {
        return this.subtitle;
    }

    public final T getValue() {
        return this.value;
    }
}
