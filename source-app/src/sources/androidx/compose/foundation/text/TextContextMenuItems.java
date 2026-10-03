package androidx.compose.foundation.text;

import android.R;
import androidx.compose.p002ui.res.StringResources_androidKt;
import androidx.compose.runtime.Composer;
import androidx.compose.runtime.ComposerKt;
import kotlin.Metadata;

@Metadata(d1 = {"\u0000\u001a\n\u0002\u0018\u0002\n\u0002\u0010\u0010\n\u0000\n\u0002\u0010\b\n\u0002\b\u0002\n\u0002\u0010\u000e\n\u0002\b\u0006\b\u0080\u0001\u0018\u00002\b\u0012\u0004\u0012\u00020\u00000\u0001B\u000f\b\u0002\u0012\u0006\u0010\u0002\u001a\u00020\u0003¢\u0006\u0002\u0010\u0004J\r\u0010\u0005\u001a\u00020\u0006H\u0007¢\u0006\u0002\u0010\u0007R\u000e\u0010\u0002\u001a\u00020\u0003X\u0082\u0004¢\u0006\u0002\n\u0000j\u0002\b\bj\u0002\b\tj\u0002\b\nj\u0002\b\u000b¨\u0006\f"}, d2 = {"Landroidx/compose/foundation/text/TextContextMenuItems;", "", "stringId", "", "(Ljava/lang/String;II)V", "resolvedString", "", "(Landroidx/compose/runtime/Composer;I)Ljava/lang/String;", "Cut", "Copy", "Paste", "SelectAll", "foundation_release"}, k = 1, mv = {1, 8, 0}, xi = 48)
public enum TextContextMenuItems {
    Cut(R.string.cut),
    Copy(R.string.copy),
    Paste(R.string.paste),
    SelectAll(R.string.selectAll);

    private final int stringId;

    TextContextMenuItems(int i) {
        this.stringId = i;
    }

    public final String resolvedString(Composer composer, int i) {
        ComposerKt.sourceInformationMarkerStart(composer, -309609081, "C(resolvedString)89@3128L24:ContextMenu.android.kt#423gt5");
        if (ComposerKt.isTraceInProgress()) {
            ComposerKt.traceEventStart(-309609081, i, -1, "androidx.compose.foundation.text.TextContextMenuItems.resolvedString (ContextMenu.android.kt:89)");
        }
        String strStringResource = StringResources_androidKt.stringResource(this.stringId, composer, 0);
        if (ComposerKt.isTraceInProgress()) {
            ComposerKt.traceEventEnd();
        }
        ComposerKt.sourceInformationMarkerEnd(composer);
        return strStringResource;
    }
}
