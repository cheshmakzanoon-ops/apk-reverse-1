package zendesk.p026ui.android.conversation.avatar;

import android.net.Uri;
import kotlin.Metadata;
import kotlin.UByte$$ExternalSyntheticBackport0;
import kotlin.jvm.internal.DefaultConstructorMarker;
import kotlin.jvm.internal.Intrinsics;
import zendesk.ui.android.R;

@Metadata(m17d1 = {"\u00004\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u000b\n\u0000\n\u0002\u0010\b\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0017\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u000e\n\u0002\b\u0002\b\u0087\b\u0018\u00002\u00020\u0001:\u0001%B=\b\u0000\u0012\n\b\u0002\u0010\u0002\u001a\u0004\u0018\u00010\u0003\u0012\b\b\u0002\u0010\u0004\u001a\u00020\u0005\u0012\b\b\u0003\u0010\u0006\u001a\u00020\u0007\u0012\n\b\u0003\u0010\b\u001a\u0004\u0018\u00010\u0007\u0012\b\b\u0002\u0010\t\u001a\u00020\n¢\u0006\u0002\u0010\u000bJ\u000b\u0010\u0017\u001a\u0004\u0018\u00010\u0003HÆ\u0003J\t\u0010\u0018\u001a\u00020\u0005HÆ\u0003J\t\u0010\u0019\u001a\u00020\u0007HÆ\u0003J\u0010\u0010\u001a\u001a\u0004\u0018\u00010\u0007HÆ\u0003¢\u0006\u0002\u0010\u000fJ\t\u0010\u001b\u001a\u00020\nHÆ\u0003JD\u0010\u001c\u001a\u00020\u00002\n\b\u0002\u0010\u0002\u001a\u0004\u0018\u00010\u00032\b\b\u0002\u0010\u0004\u001a\u00020\u00052\b\b\u0003\u0010\u0006\u001a\u00020\u00072\n\b\u0003\u0010\b\u001a\u0004\u0018\u00010\u00072\b\b\u0002\u0010\t\u001a\u00020\nHÆ\u0001¢\u0006\u0002\u0010\u001dJ\u0013\u0010\u001e\u001a\u00020\u00052\b\u0010\u001f\u001a\u0004\u0018\u00010\u0001HÖ\u0003J\t\u0010 \u001a\u00020\u0007HÖ\u0001J\u0006\u0010!\u001a\u00020\"J\t\u0010#\u001a\u00020$HÖ\u0001R\u0011\u0010\u0006\u001a\u00020\u0007¢\u0006\b\n\u0000\u001a\u0004\b\f\u0010\rR\u0015\u0010\b\u001a\u0004\u0018\u00010\u0007¢\u0006\n\n\u0002\u0010\u0010\u001a\u0004\b\u000e\u0010\u000fR\u0011\u0010\t\u001a\u00020\n¢\u0006\b\n\u0000\u001a\u0004\b\u0011\u0010\u0012R\u0011\u0010\u0004\u001a\u00020\u0005¢\u0006\b\n\u0000\u001a\u0004\b\u0013\u0010\u0014R\u0013\u0010\u0002\u001a\u0004\u0018\u00010\u0003¢\u0006\b\n\u0000\u001a\u0004\b\u0015\u0010\u0016¨\u0006&"}, m18d2 = {"Lzendesk/ui/android/conversation/avatar/AvatarImageState;", "", "uri", "Landroid/net/Uri;", "shouldAnimate", "", "avatarSize", "", "backgroundColor", "mask", "Lzendesk/ui/android/conversation/avatar/AvatarMask;", "(Landroid/net/Uri;ZILjava/lang/Integer;Lzendesk/ui/android/conversation/avatar/AvatarMask;)V", "getAvatarSize", "()I", "getBackgroundColor", "()Ljava/lang/Integer;", "Ljava/lang/Integer;", "getMask", "()Lzendesk/ui/android/conversation/avatar/AvatarMask;", "getShouldAnimate", "()Z", "getUri", "()Landroid/net/Uri;", "component1", "component2", "component3", "component4", "component5", "copy", "(Landroid/net/Uri;ZILjava/lang/Integer;Lzendesk/ui/android/conversation/avatar/AvatarMask;)Lzendesk/ui/android/conversation/avatar/AvatarImageState;", "equals", "other", "hashCode", "toBuilder", "Lzendesk/ui/android/conversation/avatar/AvatarImageState$Builder;", "toString", "", "Builder", "zendesk.ui_ui-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
public final class AvatarImageState {
    public static final int $stable = 8;
    private final int avatarSize;
    private final Integer backgroundColor;
    private final AvatarMask mask;
    private final boolean shouldAnimate;
    private final Uri uri;

    public AvatarImageState() {
        this(null, false, 0, null, null, 31, null);
    }

    public static AvatarImageState copy$default(AvatarImageState avatarImageState, Uri uri, boolean z, int i, Integer num, AvatarMask avatarMask, int i2, Object obj) {
        if ((i2 & 1) != 0) {
            uri = avatarImageState.uri;
        }
        if ((i2 & 2) != 0) {
            z = avatarImageState.shouldAnimate;
        }
        boolean z2 = z;
        if ((i2 & 4) != 0) {
            i = avatarImageState.avatarSize;
        }
        int i3 = i;
        if ((i2 & 8) != 0) {
            num = avatarImageState.backgroundColor;
        }
        Integer num2 = num;
        if ((i2 & 16) != 0) {
            avatarMask = avatarImageState.mask;
        }
        return avatarImageState.copy(uri, z2, i3, num2, avatarMask);
    }

    public final Uri getUri() {
        return this.uri;
    }

    public final boolean getShouldAnimate() {
        return this.shouldAnimate;
    }

    public final int getAvatarSize() {
        return this.avatarSize;
    }

    public final Integer getBackgroundColor() {
        return this.backgroundColor;
    }

    public final AvatarMask getMask() {
        return this.mask;
    }

    public final AvatarImageState copy(Uri uri, boolean shouldAnimate, int avatarSize, Integer backgroundColor, AvatarMask mask) {
        Intrinsics.checkNotNullParameter(mask, "mask");
        return new AvatarImageState(uri, shouldAnimate, avatarSize, backgroundColor, mask);
    }

    public boolean equals(Object other) {
        if (this == other) {
            return true;
        }
        if (!(other instanceof AvatarImageState)) {
            return false;
        }
        AvatarImageState avatarImageState = (AvatarImageState) other;
        return Intrinsics.areEqual(this.uri, avatarImageState.uri) && this.shouldAnimate == avatarImageState.shouldAnimate && this.avatarSize == avatarImageState.avatarSize && Intrinsics.areEqual(this.backgroundColor, avatarImageState.backgroundColor) && this.mask == avatarImageState.mask;
    }

    public int hashCode() {
        Uri uri = this.uri;
        int iHashCode = (((((uri == null ? 0 : uri.hashCode()) * 31) + UByte$$ExternalSyntheticBackport0.m30m(this.shouldAnimate)) * 31) + this.avatarSize) * 31;
        Integer num = this.backgroundColor;
        return ((iHashCode + (num != null ? num.hashCode() : 0)) * 31) + this.mask.hashCode();
    }

    public String toString() {
        return "AvatarImageState(uri=" + this.uri + ", shouldAnimate=" + this.shouldAnimate + ", avatarSize=" + this.avatarSize + ", backgroundColor=" + this.backgroundColor + ", mask=" + this.mask + ')';
    }

    public AvatarImageState(Uri uri, boolean z, int i, Integer num, AvatarMask mask) {
        Intrinsics.checkNotNullParameter(mask, "mask");
        this.uri = uri;
        this.shouldAnimate = z;
        this.avatarSize = i;
        this.backgroundColor = num;
        this.mask = mask;
    }

    public final Uri getUri() {
        return this.uri;
    }

    public final boolean getShouldAnimate() {
        return this.shouldAnimate;
    }

    public AvatarImageState(Uri uri, boolean z, int i, Integer num, AvatarMask avatarMask, int i2, DefaultConstructorMarker defaultConstructorMarker) {
        this((i2 & 1) != 0 ? null : uri, (i2 & 2) != 0 ? true : z, (i2 & 4) != 0 ? R.dimen.zuia_avatar_image_size : i, (i2 & 8) == 0 ? num : null, (i2 & 16) != 0 ? AvatarMask.NONE : avatarMask);
    }

    public final int getAvatarSize() {
        return this.avatarSize;
    }

    public final Integer getBackgroundColor() {
        return this.backgroundColor;
    }

    public final AvatarMask getMask() {
        return this.mask;
    }

    public final Builder toBuilder() {
        return new Builder(this);
    }

    @Metadata(m17d1 = {"\u00000\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0010\b\n\u0002\b\u0005\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u000b\n\u0000\n\u0002\u0018\u0002\n\u0002\u0010\u000e\n\u0000\b\u0007\u0018\u00002\u00020\u0001B\u000f\b\u0010\u0012\u0006\u0010\u0002\u001a\u00020\u0003¢\u0006\u0002\u0010\u0004B\u0005¢\u0006\u0002\u0010\u0005J\u0017\u0010\u0006\u001a\u00020\u00002\n\b\u0001\u0010\u0006\u001a\u0004\u0018\u00010\u0007¢\u0006\u0002\u0010\bJ\u0010\u0010\t\u001a\u00020\u00002\b\b\u0001\u0010\n\u001a\u00020\u0007J\u0006\u0010\u000b\u001a\u00020\u0003J\u000e\u0010\f\u001a\u00020\u00002\u0006\u0010\f\u001a\u00020\rJ\u000e\u0010\u000e\u001a\u00020\u00002\u0006\u0010\u000e\u001a\u00020\u000fJ\u0010\u0010\u0010\u001a\u00020\u00002\b\u0010\u0010\u001a\u0004\u0018\u00010\u0011J\u0010\u0010\u0010\u001a\u00020\u00002\b\u0010\u0010\u001a\u0004\u0018\u00010\u0012R\u000e\u0010\u0002\u001a\u00020\u0003X\u0082\u000e¢\u0006\u0002\n\u0000¨\u0006\u0013"}, m18d2 = {"Lzendesk/ui/android/conversation/avatar/AvatarImageState$Builder;", "", "state", "Lzendesk/ui/android/conversation/avatar/AvatarImageState;", "(Lzendesk/ui/android/conversation/avatar/AvatarImageState;)V", "()V", "avatarSize", "", "(Ljava/lang/Integer;)Lzendesk/ui/android/conversation/avatar/AvatarImageState$Builder;", "backgroundColor", "color", "build", "mask", "Lzendesk/ui/android/conversation/avatar/AvatarMask;", "shouldAnimate", "", "uri", "Landroid/net/Uri;", "", "zendesk.ui_ui-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    public static final class Builder {
        public static final int $stable = 8;
        private AvatarImageState state;

        public Builder() {
            this.state = new AvatarImageState(null, false, 0, null, null, 31, null);
        }

        public Builder(AvatarImageState state) {
            this();
            Intrinsics.checkNotNullParameter(state, "state");
            this.state = state;
        }

        public final Builder uri(Uri uri) {
            this.state = AvatarImageState.copy$default(this.state, uri, false, 0, null, null, 30, null);
            return this;
        }

        public final Builder uri(String uri) {
            this.state = AvatarImageState.copy$default(this.state, uri != null ? Uri.parse(uri) : null, false, 0, null, null, 30, null);
            return this;
        }

        public final Builder shouldAnimate(boolean shouldAnimate) {
            this.state = AvatarImageState.copy$default(this.state, null, shouldAnimate, 0, null, null, 29, null);
            return this;
        }

        public final Builder avatarSize(Integer avatarSize) {
            this.state = AvatarImageState.copy$default(this.state, null, false, avatarSize != null ? avatarSize.intValue() : R.dimen.zuia_avatar_image_size, null, null, 27, null);
            return this;
        }

        public final Builder backgroundColor(int color) {
            this.state = AvatarImageState.copy$default(this.state, null, false, 0, Integer.valueOf(color), null, 23, null);
            return this;
        }

        public final Builder mask(AvatarMask mask) {
            Intrinsics.checkNotNullParameter(mask, "mask");
            this.state = AvatarImageState.copy$default(this.state, null, false, 0, null, mask, 15, null);
            return this;
        }

        public final AvatarImageState getState() {
            return this.state;
        }
    }
}
