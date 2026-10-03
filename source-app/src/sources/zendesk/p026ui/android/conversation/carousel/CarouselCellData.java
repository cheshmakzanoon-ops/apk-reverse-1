package zendesk.p026ui.android.conversation.carousel;

import java.util.List;
import kotlin.Metadata;
import kotlin.collections.CollectionsKt;
import kotlin.jvm.internal.DefaultConstructorMarker;
import kotlin.jvm.internal.Intrinsics;
import zendesk.p026ui.android.conversation.avatar.AvatarImageState;

@Metadata(m17d1 = {"\u0000\u001c\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0005\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\b7\u0018\u00002\u00020\u0001:\u0002\u0007\bB\u000f\b\u0002\u0012\u0006\u0010\u0002\u001a\u00020\u0003¢\u0006\u0002\u0010\u0004R\u0011\u0010\u0002\u001a\u00020\u0003¢\u0006\b\n\u0000\u001a\u0004\b\u0005\u0010\u0006\u0082\u0001\u0002\t\n¨\u0006\u000b"}, m18d2 = {"Lzendesk/ui/android/conversation/carousel/CarouselCellData;", "", "carouselViewType", "Lzendesk/ui/android/conversation/carousel/CarouselViewType;", "(Lzendesk/ui/android/conversation/carousel/CarouselViewType;)V", "getCarouselViewType", "()Lzendesk/ui/android/conversation/carousel/CarouselViewType;", "Avatar", "Item", "Lzendesk/ui/android/conversation/carousel/CarouselCellData$Avatar;", "Lzendesk/ui/android/conversation/carousel/CarouselCellData$Item;", "zendesk.ui_ui-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
public abstract class CarouselCellData {
    public static final int $stable = 0;
    private final CarouselViewType carouselViewType;

    public CarouselCellData(CarouselViewType carouselViewType, DefaultConstructorMarker defaultConstructorMarker) {
        this(carouselViewType);
    }

    private CarouselCellData(CarouselViewType carouselViewType) {
        this.carouselViewType = carouselViewType;
    }

    public final CarouselViewType getCarouselViewType() {
        return this.carouselViewType;
    }

    @Metadata(m17d1 = {"\u00002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u000e\n\u0002\b\u0004\n\u0002\u0010 \n\u0002\u0018\u0002\n\u0002\b\u000f\n\u0002\u0010\u000b\n\u0000\n\u0002\u0010\u0000\n\u0000\n\u0002\u0010\b\n\u0002\b\u0002\b\u0087\b\u0018\u00002\u00020\u0001BA\u0012\u0006\u0010\u0002\u001a\u00020\u0003\u0012\n\b\u0002\u0010\u0004\u001a\u0004\u0018\u00010\u0003\u0012\n\b\u0002\u0010\u0005\u001a\u0004\u0018\u00010\u0003\u0012\n\b\u0002\u0010\u0006\u001a\u0004\u0018\u00010\u0003\u0012\u000e\b\u0002\u0010\u0007\u001a\b\u0012\u0004\u0012\u00020\t0\b¢\u0006\u0002\u0010\nJ\t\u0010\u0012\u001a\u00020\u0003HÆ\u0003J\u000b\u0010\u0013\u001a\u0004\u0018\u00010\u0003HÆ\u0003J\u000b\u0010\u0014\u001a\u0004\u0018\u00010\u0003HÆ\u0003J\u000b\u0010\u0015\u001a\u0004\u0018\u00010\u0003HÆ\u0003J\u000f\u0010\u0016\u001a\b\u0012\u0004\u0012\u00020\t0\bHÆ\u0003JG\u0010\u0017\u001a\u00020\u00002\b\b\u0002\u0010\u0002\u001a\u00020\u00032\n\b\u0002\u0010\u0004\u001a\u0004\u0018\u00010\u00032\n\b\u0002\u0010\u0005\u001a\u0004\u0018\u00010\u00032\n\b\u0002\u0010\u0006\u001a\u0004\u0018\u00010\u00032\u000e\b\u0002\u0010\u0007\u001a\b\u0012\u0004\u0012\u00020\t0\bHÆ\u0001J\u0013\u0010\u0018\u001a\u00020\u00192\b\u0010\u001a\u001a\u0004\u0018\u00010\u001bHÖ\u0003J\t\u0010\u001c\u001a\u00020\u001dHÖ\u0001J\t\u0010\u001e\u001a\u00020\u0003HÖ\u0001R\u0017\u0010\u0007\u001a\b\u0012\u0004\u0012\u00020\t0\b¢\u0006\b\n\u0000\u001a\u0004\b\u000b\u0010\fR\u0013\u0010\u0004\u001a\u0004\u0018\u00010\u0003¢\u0006\b\n\u0000\u001a\u0004\b\r\u0010\u000eR\u0013\u0010\u0006\u001a\u0004\u0018\u00010\u0003¢\u0006\b\n\u0000\u001a\u0004\b\u000f\u0010\u000eR\u0013\u0010\u0005\u001a\u0004\u0018\u00010\u0003¢\u0006\b\n\u0000\u001a\u0004\b\u0010\u0010\u000eR\u0011\u0010\u0002\u001a\u00020\u0003¢\u0006\b\n\u0000\u001a\u0004\b\u0011\u0010\u000e¨\u0006\u001f"}, m18d2 = {"Lzendesk/ui/android/conversation/carousel/CarouselCellData$Item;", "Lzendesk/ui/android/conversation/carousel/CarouselCellData;", "title", "", "description", "mediaUrl", "mediaType", "actions", "", "Lzendesk/ui/android/conversation/carousel/CarouselAction;", "(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/util/List;)V", "getActions", "()Ljava/util/List;", "getDescription", "()Ljava/lang/String;", "getMediaType", "getMediaUrl", "getTitle", "component1", "component2", "component3", "component4", "component5", "copy", "equals", "", "other", "", "hashCode", "", "toString", "zendesk.ui_ui-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    public static final class Item extends CarouselCellData {
        public static final int $stable = 8;
        private final List<CarouselAction> actions;
        private final String description;
        private final String mediaType;
        private final String mediaUrl;
        private final String title;

        public static Item copy$default(Item item, String str, String str2, String str3, String str4, List list, int i, Object obj) {
            if ((i & 1) != 0) {
                str = item.title;
            }
            if ((i & 2) != 0) {
                str2 = item.description;
            }
            String str5 = str2;
            if ((i & 4) != 0) {
                str3 = item.mediaUrl;
            }
            String str6 = str3;
            if ((i & 8) != 0) {
                str4 = item.mediaType;
            }
            String str7 = str4;
            if ((i & 16) != 0) {
                list = item.actions;
            }
            return item.copy(str, str5, str6, str7, list);
        }

        public final String getTitle() {
            return this.title;
        }

        public final String getDescription() {
            return this.description;
        }

        public final String getMediaUrl() {
            return this.mediaUrl;
        }

        public final String getMediaType() {
            return this.mediaType;
        }

        public final List<CarouselAction> component5() {
            return this.actions;
        }

        public final Item copy(String title, String description, String mediaUrl, String mediaType, List<? extends CarouselAction> actions) {
            Intrinsics.checkNotNullParameter(title, "title");
            Intrinsics.checkNotNullParameter(actions, "actions");
            return new Item(title, description, mediaUrl, mediaType, actions);
        }

        public boolean equals(Object other) {
            if (this == other) {
                return true;
            }
            if (!(other instanceof Item)) {
                return false;
            }
            Item item = (Item) other;
            return Intrinsics.areEqual(this.title, item.title) && Intrinsics.areEqual(this.description, item.description) && Intrinsics.areEqual(this.mediaUrl, item.mediaUrl) && Intrinsics.areEqual(this.mediaType, item.mediaType) && Intrinsics.areEqual(this.actions, item.actions);
        }

        public int hashCode() {
            int iHashCode = this.title.hashCode() * 31;
            String str = this.description;
            int iHashCode2 = (iHashCode + (str == null ? 0 : str.hashCode())) * 31;
            String str2 = this.mediaUrl;
            int iHashCode3 = (iHashCode2 + (str2 == null ? 0 : str2.hashCode())) * 31;
            String str3 = this.mediaType;
            return ((iHashCode3 + (str3 != null ? str3.hashCode() : 0)) * 31) + this.actions.hashCode();
        }

        public String toString() {
            return "Item(title=" + this.title + ", description=" + this.description + ", mediaUrl=" + this.mediaUrl + ", mediaType=" + this.mediaType + ", actions=" + this.actions + ')';
        }

        public final String getTitle() {
            return this.title;
        }

        public final String getDescription() {
            return this.description;
        }

        public final String getMediaUrl() {
            return this.mediaUrl;
        }

        public final String getMediaType() {
            return this.mediaType;
        }

        public Item(String str, String str2, String str3, String str4, List list, int i, DefaultConstructorMarker defaultConstructorMarker) {
            this(str, (i & 2) != 0 ? null : str2, (i & 4) != 0 ? null : str3, (i & 8) != 0 ? null : str4, (i & 16) != 0 ? CollectionsKt.emptyList() : list);
        }

        public final List<CarouselAction> getActions() {
            return this.actions;
        }

        public Item(String title, String str, String str2, String str3, List<? extends CarouselAction> actions) {
            super(CarouselViewType.ITEM, null);
            Intrinsics.checkNotNullParameter(title, "title");
            Intrinsics.checkNotNullParameter(actions, "actions");
            this.title = title;
            this.description = str;
            this.mediaUrl = str2;
            this.mediaType = str3;
            this.actions = actions;
        }
    }

    @Metadata(m17d1 = {"\u0000*\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0006\n\u0002\u0010\u000b\n\u0000\n\u0002\u0010\u0000\n\u0000\n\u0002\u0010\b\n\u0000\n\u0002\u0010\u000e\n\u0000\b\u0087\b\u0018\u00002\u00020\u0001B\u000f\u0012\b\u0010\u0002\u001a\u0004\u0018\u00010\u0003¢\u0006\u0002\u0010\u0004J\u000b\u0010\u0007\u001a\u0004\u0018\u00010\u0003HÆ\u0003J\u0015\u0010\b\u001a\u00020\u00002\n\b\u0002\u0010\u0002\u001a\u0004\u0018\u00010\u0003HÆ\u0001J\u0013\u0010\t\u001a\u00020\n2\b\u0010\u000b\u001a\u0004\u0018\u00010\fHÖ\u0003J\t\u0010\r\u001a\u00020\u000eHÖ\u0001J\t\u0010\u000f\u001a\u00020\u0010HÖ\u0001R\u0013\u0010\u0002\u001a\u0004\u0018\u00010\u0003¢\u0006\b\n\u0000\u001a\u0004\b\u0005\u0010\u0006¨\u0006\u0011"}, m18d2 = {"Lzendesk/ui/android/conversation/carousel/CarouselCellData$Avatar;", "Lzendesk/ui/android/conversation/carousel/CarouselCellData;", "avatarImageState", "Lzendesk/ui/android/conversation/avatar/AvatarImageState;", "(Lzendesk/ui/android/conversation/avatar/AvatarImageState;)V", "getAvatarImageState", "()Lzendesk/ui/android/conversation/avatar/AvatarImageState;", "component1", "copy", "equals", "", "other", "", "hashCode", "", "toString", "", "zendesk.ui_ui-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    public static final class Avatar extends CarouselCellData {
        public static final int $stable = 8;
        private final AvatarImageState avatarImageState;

        public static Avatar copy$default(Avatar avatar, AvatarImageState avatarImageState, int i, Object obj) {
            if ((i & 1) != 0) {
                avatarImageState = avatar.avatarImageState;
            }
            return avatar.copy(avatarImageState);
        }

        public final AvatarImageState getAvatarImageState() {
            return this.avatarImageState;
        }

        public final Avatar copy(AvatarImageState avatarImageState) {
            return new Avatar(avatarImageState);
        }

        public boolean equals(Object other) {
            if (this == other) {
                return true;
            }
            return (other instanceof Avatar) && Intrinsics.areEqual(this.avatarImageState, ((Avatar) other).avatarImageState);
        }

        public int hashCode() {
            AvatarImageState avatarImageState = this.avatarImageState;
            if (avatarImageState == null) {
                return 0;
            }
            return avatarImageState.hashCode();
        }

        public String toString() {
            return "Avatar(avatarImageState=" + this.avatarImageState + ')';
        }

        public final AvatarImageState getAvatarImageState() {
            return this.avatarImageState;
        }

        public Avatar(AvatarImageState avatarImageState) {
            super(CarouselViewType.AVATAR, null);
            this.avatarImageState = avatarImageState;
        }
    }
}
