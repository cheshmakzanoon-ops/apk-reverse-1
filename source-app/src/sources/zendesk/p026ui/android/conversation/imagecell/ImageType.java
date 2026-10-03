package zendesk.p026ui.android.conversation.imagecell;

import kotlin.Metadata;
import kotlin.enums.EnumEntries;
import kotlin.enums.EnumEntriesKt;
import kotlin.jvm.internal.DefaultConstructorMarker;
import kotlin.jvm.internal.Intrinsics;

@Metadata(m17d1 = {"\u0000\u0012\n\u0002\u0018\u0002\n\u0002\u0010\u0010\n\u0000\n\u0002\u0010\u000e\n\u0002\b\u000b\b\u0086\u0081\u0002\u0018\u0000 \r2\b\u0012\u0004\u0012\u00020\u00000\u0001:\u0001\rB\u000f\b\u0002\u0012\u0006\u0010\u0002\u001a\u00020\u0003¢\u0006\u0002\u0010\u0004R\u0014\u0010\u0002\u001a\u00020\u0003X\u0080\u0004¢\u0006\b\n\u0000\u001a\u0004\b\u0005\u0010\u0006j\u0002\b\u0007j\u0002\b\bj\u0002\b\tj\u0002\b\nj\u0002\b\u000bj\u0002\b\f¨\u0006\u000e"}, m18d2 = {"Lzendesk/ui/android/conversation/imagecell/ImageType;", "", "value", "", "(Ljava/lang/String;ILjava/lang/String;)V", "getValue$zendesk_ui_ui_android", "()Ljava/lang/String;", "JPEG", "JPG", "PNG", "GIF", "WEBP", "SVG", "Companion", "zendesk.ui_ui-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
public enum ImageType {
    JPEG("image/jpeg"),
    JPG("image/jpg"),
    PNG("image/png"),
    GIF("image/gif"),
    WEBP("image/webp"),
    SVG("image/svg+xml");

    private final String value;
    private static final EnumEntries $ENTRIES = EnumEntriesKt.enumEntries(values());

    public static final Companion INSTANCE = new Companion(null);

    public static EnumEntries<ImageType> getEntries() {
        return $ENTRIES;
    }

    ImageType(String str) {
        this.value = str;
    }

    public final String getValue() {
        return this.value;
    }

    @Metadata(m17d1 = {"\u0000\u0018\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0002\b\u0002\n\u0002\u0010\u000b\n\u0000\n\u0002\u0010\u000e\n\u0000\b\u0086\u0003\u0018\u00002\u00020\u0001B\u0007\b\u0002¢\u0006\u0002\u0010\u0002J\u0010\u0010\u0003\u001a\u00020\u00042\b\u0010\u0005\u001a\u0004\u0018\u00010\u0006¨\u0006\u0007"}, m18d2 = {"Lzendesk/ui/android/conversation/imagecell/ImageType$Companion;", "", "()V", "isSupported", "", "value", "", "zendesk.ui_ui-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    public static final class Companion {
        public Companion(DefaultConstructorMarker defaultConstructorMarker) {
            this();
        }

        private Companion() {
        }

        public final boolean isSupported(String value) {
            for (ImageType imageType : ImageType.values()) {
                if (Intrinsics.areEqual(imageType.getValue(), value)) {
                    return true;
                }
            }
            return false;
        }
    }
}
