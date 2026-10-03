package zendesk.p026ui.android.conversation.imagecell;

import kotlin.Metadata;
import kotlin.enums.EnumEntries;
import kotlin.enums.EnumEntriesKt;
import kotlin.jvm.internal.DefaultConstructorMarker;
import kotlin.jvm.internal.Intrinsics;

@Metadata(m17d1 = {"\u0000\f\n\u0002\u0018\u0002\n\u0002\u0010\u0010\n\u0002\b\u000b\b\u0086\u0081\u0002\u0018\u0000 \u000b2\b\u0012\u0004\u0012\u00020\u00000\u0001:\u0001\u000bB\u0007\b\u0002¢\u0006\u0002\u0010\u0002j\u0002\b\u0003j\u0002\b\u0004j\u0002\b\u0005j\u0002\b\u0006j\u0002\b\u0007j\u0002\b\bj\u0002\b\tj\u0002\b\n¨\u0006\f"}, m18d2 = {"Lzendesk/ui/android/conversation/imagecell/ImageCellDirection;", "", "(Ljava/lang/String;I)V", "INBOUND_SINGLE", "INBOUND_TOP", "INBOUND_MIDDLE", "INBOUND_BOTTOM", "OUTBOUND_SINGLE", "OUTBOUND_TOP", "OUTBOUND_MIDDLE", "OUTBOUND_BOTTOM", "Companion", "zendesk.ui_ui-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
public enum ImageCellDirection {
    INBOUND_SINGLE,
    INBOUND_TOP,
    INBOUND_MIDDLE,
    INBOUND_BOTTOM,
    OUTBOUND_SINGLE,
    OUTBOUND_TOP,
    OUTBOUND_MIDDLE,
    OUTBOUND_BOTTOM;

    private static final EnumEntries $ENTRIES = EnumEntriesKt.enumEntries(values());

    public static final Companion INSTANCE = new Companion(null);

    public static EnumEntries<ImageCellDirection> getEntries() {
        return $ENTRIES;
    }

    @Metadata(m17d1 = {"\u0000\u0016\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0002\b\u0002\n\u0002\u0010\u000b\n\u0002\u0018\u0002\n\u0000\b\u0080\u0003\u0018\u00002\u00020\u0001B\u0007\b\u0002¢\u0006\u0002\u0010\u0002J\n\u0010\u0003\u001a\u00020\u0004*\u00020\u0005¨\u0006\u0006"}, m18d2 = {"Lzendesk/ui/android/conversation/imagecell/ImageCellDirection$Companion;", "", "()V", "isInbound", "", "Lzendesk/ui/android/conversation/imagecell/ImageCellDirection;", "zendesk.ui_ui-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    public static final class Companion {
        public Companion(DefaultConstructorMarker defaultConstructorMarker) {
            this();
        }

        private Companion() {
        }

        public final boolean isInbound(ImageCellDirection imageCellDirection) {
            Intrinsics.checkNotNullParameter(imageCellDirection, "<this>");
            return imageCellDirection == ImageCellDirection.INBOUND_SINGLE || imageCellDirection == ImageCellDirection.INBOUND_TOP || imageCellDirection == ImageCellDirection.INBOUND_MIDDLE || imageCellDirection == ImageCellDirection.INBOUND_BOTTOM;
        }
    }
}
