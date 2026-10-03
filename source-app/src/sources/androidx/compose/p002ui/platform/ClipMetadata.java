package androidx.compose.p002ui.platform;

import android.content.ClipDescription;
import kotlin.Metadata;

@Metadata(d1 = {"\u0000\u0012\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0004\b\u0007\u0018\u00002\u00020\u0001B\r\u0012\u0006\u0010\u0002\u001a\u00020\u0003¢\u0006\u0002\u0010\u0004R\u0011\u0010\u0002\u001a\u00020\u0003¢\u0006\b\n\u0000\u001a\u0004\b\u0005\u0010\u0006¨\u0006\u0007"}, d2 = {"Landroidx/compose/ui/platform/ClipMetadata;", "", "clipDescription", "Landroid/content/ClipDescription;", "(Landroid/content/ClipDescription;)V", "getClipDescription", "()Landroid/content/ClipDescription;", "ui_release"}, k = 1, mv = {1, 8, 0}, xi = 48)
public final class ClipMetadata {
    public static final int $stable = 8;
    private final ClipDescription clipDescription;

    public ClipMetadata(ClipDescription clipDescription) {
        this.clipDescription = clipDescription;
    }

    public final ClipDescription getClipDescription() {
        return this.clipDescription;
    }
}
