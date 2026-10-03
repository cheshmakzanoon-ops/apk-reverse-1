package androidx.compose.p002ui.platform;

import android.content.ClipData;
import android.content.ClipDescription;
import android.content.ClipboardManager;
import android.content.Context;
import android.os.Build;
import androidx.compose.ui.text.AnnotatedString;
import kotlin.Metadata;
import kotlin.jvm.internal.Intrinsics;

@Metadata(d1 = {"\u0000<\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u000b\n\u0000\n\u0002\u0010\u0002\n\u0002\b\u0004\b\u0000\u0018\u00002\u00020\u0001B\u000f\b\u0010\u0012\u0006\u0010\u0002\u001a\u00020\u0003¢\u0006\u0002\u0010\u0004B\u000f\b\u0000\u0012\u0006\u0010\u0005\u001a\u00020\u0006¢\u0006\u0002\u0010\u0007J\n\u0010\f\u001a\u0004\u0018\u00010\rH\u0016J\n\u0010\u000e\u001a\u0004\u0018\u00010\u000fH\u0016J\b\u0010\u0010\u001a\u00020\u0011H\u0016J\u0012\u0010\u0012\u001a\u00020\u00132\b\u0010\u0014\u001a\u0004\u0018\u00010\rH\u0016J\u0010\u0010\u0015\u001a\u00020\u00132\u0006\u0010\u0016\u001a\u00020\u000fH\u0016R\u000e\u0010\u0005\u001a\u00020\u0006X\u0082\u0004¢\u0006\u0002\n\u0000R\u0018\u0010\b\u001a\u00060\u0006j\u0002`\t8VX\u0096\u0004¢\u0006\u0006\u001a\u0004\b\n\u0010\u000b¨\u0006\u0017"}, d2 = {"Landroidx/compose/ui/platform/AndroidClipboardManager;", "Landroidx/compose/ui/platform/ClipboardManager;", "context", "Landroid/content/Context;", "(Landroid/content/Context;)V", "clipboardManager", "Landroid/content/ClipboardManager;", "(Landroid/content/ClipboardManager;)V", "nativeClipboard", "Landroidx/compose/ui/platform/NativeClipboard;", "getNativeClipboard", "()Landroid/content/ClipboardManager;", "getClip", "Landroidx/compose/ui/platform/ClipEntry;", "getText", "Landroidx/compose/ui/text/AnnotatedString;", "hasText", "", "setClip", "", "clipEntry", "setText", "annotatedString", "ui_release"}, k = 1, mv = {1, 8, 0}, xi = 48)
public final class AndroidClipboardManager implements ClipboardManager {
    public static final int $stable = 8;
    private final ClipboardManager clipboardManager;

    public AndroidClipboardManager(ClipboardManager clipboardManager) {
        this.clipboardManager = clipboardManager;
    }

    public AndroidClipboardManager(Context context) {
        Object systemService = context.getSystemService("clipboard");
        Intrinsics.checkNotNull(systemService, "null cannot be cast to non-null type android.content.ClipboardManager");
        this((ClipboardManager) systemService);
    }

    @Override
    public void setText(AnnotatedString annotatedString) {
        this.clipboardManager.setPrimaryClip(ClipData.newPlainText("plain text", AndroidClipboardManager_androidKt.convertToCharSequence(annotatedString)));
    }

    @Override
    public AnnotatedString getText() {
        ClipData primaryClip = this.clipboardManager.getPrimaryClip();
        if (primaryClip == null || primaryClip.getItemCount() <= 0) {
            return null;
        }
        ClipData.Item itemAt = primaryClip.getItemAt(0);
        return AndroidClipboardManager_androidKt.convertToAnnotatedString(itemAt != null ? itemAt.getText() : null);
    }

    @Override
    public boolean hasText() {
        ClipDescription primaryClipDescription = this.clipboardManager.getPrimaryClipDescription();
        if (primaryClipDescription != null) {
            return primaryClipDescription.hasMimeType("text/*");
        }
        return false;
    }

    @Override
    public ClipEntry getClip() {
        ClipData primaryClip = this.clipboardManager.getPrimaryClip();
        if (primaryClip != null) {
            return new ClipEntry(primaryClip);
        }
        return null;
    }

    @Override
    public void setClip(ClipEntry clipEntry) {
        if (clipEntry == null) {
            if (Build.VERSION.SDK_INT >= 28) {
                Api28ClipboardManagerClipClear.clearPrimaryClip(this.clipboardManager);
                return;
            } else {
                this.clipboardManager.setPrimaryClip(ClipData.newPlainText("", ""));
                return;
            }
        }
        this.clipboardManager.setPrimaryClip(clipEntry.getClipData());
    }

    @Override
    public ClipboardManager getClipboardManager() {
        return this.clipboardManager;
    }
}
