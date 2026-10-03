package androidx.compose.foundation.content;

import androidx.compose.p002ui.platform.ClipEntry;
import androidx.compose.p002ui.platform.ClipMetadata;
import kotlin.Metadata;
import kotlin.jvm.JvmInline;
import kotlin.jvm.internal.DefaultConstructorMarker;

@Metadata(d1 = {"\u0000$\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\f\b\u0007\u0018\u00002\u00020\u0001:\u0001\u0014B+\b\u0000\u0012\u0006\u0010\u0002\u001a\u00020\u0003\u0012\u0006\u0010\u0004\u001a\u00020\u0005\u0012\u0006\u0010\u0006\u001a\u00020\u0007\u0012\n\b\u0002\u0010\b\u001a\u0004\u0018\u00010\t¢\u0006\u0002\u0010\nR\u0011\u0010\u0002\u001a\u00020\u0003¢\u0006\b\n\u0000\u001a\u0004\b\u000b\u0010\fR\u0011\u0010\u0004\u001a\u00020\u0005¢\u0006\b\n\u0000\u001a\u0004\b\r\u0010\u000eR\u0013\u0010\b\u001a\u0004\u0018\u00010\t¢\u0006\b\n\u0000\u001a\u0004\b\u000f\u0010\u0010R\u0019\u0010\u0006\u001a\u00020\u0007ø\u0001\u0000ø\u0001\u0001¢\u0006\n\n\u0002\u0010\u0013\u001a\u0004\b\u0011\u0010\u0012\u0082\u0002\u000b\n\u0005\b¡\u001e0\u0001\n\u0002\b!¨\u0006\u0015"}, d2 = {"Landroidx/compose/foundation/content/TransferableContent;", "", "clipEntry", "Landroidx/compose/ui/platform/ClipEntry;", "clipMetadata", "Landroidx/compose/ui/platform/ClipMetadata;", "source", "Landroidx/compose/foundation/content/TransferableContent$Source;", "platformTransferableContent", "Landroidx/compose/foundation/content/PlatformTransferableContent;", "(Landroidx/compose/ui/platform/ClipEntry;Landroidx/compose/ui/platform/ClipMetadata;ILandroidx/compose/foundation/content/PlatformTransferableContent;Lkotlin/jvm/internal/DefaultConstructorMarker;)V", "getClipEntry", "()Landroidx/compose/ui/platform/ClipEntry;", "getClipMetadata", "()Landroidx/compose/ui/platform/ClipMetadata;", "getPlatformTransferableContent", "()Landroidx/compose/foundation/content/PlatformTransferableContent;", "getSource-kB6V9T0", "()I", "I", "Source", "foundation_release"}, k = 1, mv = {1, 8, 0}, xi = 48)
public final class TransferableContent {
    public static final int $stable = 8;
    private final ClipEntry clipEntry;
    private final ClipMetadata clipMetadata;
    private final PlatformTransferableContent platformTransferableContent;
    private final int source;

    public TransferableContent(ClipEntry clipEntry, ClipMetadata clipMetadata, int i, PlatformTransferableContent platformTransferableContent, DefaultConstructorMarker defaultConstructorMarker) {
        this(clipEntry, clipMetadata, i, platformTransferableContent);
    }

    private TransferableContent(ClipEntry clipEntry, ClipMetadata clipMetadata, int i, PlatformTransferableContent platformTransferableContent) {
        this.clipEntry = clipEntry;
        this.clipMetadata = clipMetadata;
        this.source = i;
        this.platformTransferableContent = platformTransferableContent;
    }

    public TransferableContent(ClipEntry clipEntry, ClipMetadata clipMetadata, int i, PlatformTransferableContent platformTransferableContent, int i2, DefaultConstructorMarker defaultConstructorMarker) {
        this(clipEntry, clipMetadata, i, (i2 & 8) != 0 ? null : platformTransferableContent, null);
    }

    public final ClipEntry getClipEntry() {
        return this.clipEntry;
    }

    public final ClipMetadata getClipMetadata() {
        return this.clipMetadata;
    }

    public final int getSource() {
        return this.source;
    }

    public final PlatformTransferableContent getPlatformTransferableContent() {
        return this.platformTransferableContent;
    }

    @Metadata(d1 = {"\u0000\"\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0000\n\u0002\u0010\b\n\u0002\b\u0003\n\u0002\u0010\u000b\n\u0002\b\u0006\n\u0002\u0010\u000e\n\u0002\b\u0004\b\u0087@\u0018\u0000 \u00112\u00020\u0001:\u0001\u0011B\u0011\b\u0000\u0012\u0006\u0010\u0002\u001a\u00020\u0003¢\u0006\u0004\b\u0004\u0010\u0005J\u001a\u0010\u0006\u001a\u00020\u00072\b\u0010\b\u001a\u0004\u0018\u00010\u0001HÖ\u0003¢\u0006\u0004\b\t\u0010\nJ\u0010\u0010\u000b\u001a\u00020\u0003HÖ\u0001¢\u0006\u0004\b\f\u0010\u0005J\u000f\u0010\r\u001a\u00020\u000eH\u0016¢\u0006\u0004\b\u000f\u0010\u0010R\u000e\u0010\u0002\u001a\u00020\u0003X\u0082\u0004¢\u0006\u0002\n\u0000\u0088\u0001\u0002\u0092\u0001\u00020\u0003¨\u0006\u0012"}, d2 = {"Landroidx/compose/foundation/content/TransferableContent$Source;", "", "value", "", "constructor-impl", "(I)I", "equals", "", "other", "equals-impl", "(ILjava/lang/Object;)Z", "hashCode", "hashCode-impl", "toString", "", "toString-impl", "(I)Ljava/lang/String;", "Companion", "foundation_release"}, k = 1, mv = {1, 8, 0}, xi = 48)
    @JvmInline
    public static final class Source {
        private final int value;

        public static final Companion INSTANCE = new Companion(null);
        private static final int Keyboard = m631constructorimpl(0);
        private static final int DragAndDrop = m631constructorimpl(1);
        private static final int Clipboard = m631constructorimpl(2);

        public static final Source m630boximpl(int i) {
            return new Source(i);
        }

        public static int m631constructorimpl(int i) {
            return i;
        }

        public static boolean m632equalsimpl(int i, Object obj) {
            return (obj instanceof Source) && i == ((Source) obj).getValue();
        }

        public static final boolean m633equalsimpl0(int i, int i2) {
            return i == i2;
        }

        public static int m634hashCodeimpl(int i) {
            return i;
        }

        public boolean equals(Object obj) {
            return m632equalsimpl(this.value, obj);
        }

        public int hashCode() {
            return m634hashCodeimpl(this.value);
        }

        public final int getValue() {
            return this.value;
        }

        private Source(int i) {
            this.value = i;
        }

        @Metadata(d1 = {"\u0000\u0014\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\b\b\u0086\u0003\u0018\u00002\u00020\u0001B\u0007\b\u0002¢\u0006\u0002\u0010\u0002R\u0019\u0010\u0003\u001a\u00020\u0004ø\u0001\u0000ø\u0001\u0001¢\u0006\n\n\u0002\u0010\u0007\u001a\u0004\b\u0005\u0010\u0006R\u0019\u0010\b\u001a\u00020\u0004ø\u0001\u0000ø\u0001\u0001¢\u0006\n\n\u0002\u0010\u0007\u001a\u0004\b\t\u0010\u0006R\u0019\u0010\n\u001a\u00020\u0004ø\u0001\u0000ø\u0001\u0001¢\u0006\n\n\u0002\u0010\u0007\u001a\u0004\b\u000b\u0010\u0006\u0082\u0002\u000b\n\u0005\b¡\u001e0\u0001\n\u0002\b!¨\u0006\f"}, d2 = {"Landroidx/compose/foundation/content/TransferableContent$Source$Companion;", "", "()V", "Clipboard", "Landroidx/compose/foundation/content/TransferableContent$Source;", "getClipboard-kB6V9T0", "()I", "I", "DragAndDrop", "getDragAndDrop-kB6V9T0", "Keyboard", "getKeyboard-kB6V9T0", "foundation_release"}, k = 1, mv = {1, 8, 0}, xi = 48)
        public static final class Companion {
            public Companion(DefaultConstructorMarker defaultConstructorMarker) {
                this();
            }

            private Companion() {
            }

            public final int m639getKeyboardkB6V9T0() {
                return Source.Keyboard;
            }

            public final int m638getDragAndDropkB6V9T0() {
                return Source.DragAndDrop;
            }

            public final int m637getClipboardkB6V9T0() {
                return Source.Clipboard;
            }
        }

        public String toString() {
            return m635toStringimpl(this.value);
        }

        public static String m635toStringimpl(int i) {
            if (m633equalsimpl0(i, Keyboard)) {
                return "Source.Keyboard";
            }
            if (m633equalsimpl0(i, DragAndDrop)) {
                return "Source.DragAndDrop";
            }
            if (m633equalsimpl0(i, Clipboard)) {
                return "Source.Clipboard";
            }
            return "Invalid (" + i + ')';
        }
    }
}
