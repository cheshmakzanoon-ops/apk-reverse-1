package androidx.compose.foundation.text.input.internal;

import android.view.inputmethod.EditorInfo;
import androidx.activity.ComponentDialog$$ExternalSyntheticApiModelOutline0;
import kotlin.Metadata;
import kotlin.collections.CollectionsKt;
import kotlin.collections.SetsKt;

@Metadata(d1 = {"\u0000\u0018\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0002\b\u0002\n\u0002\u0010\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\bÃ\u0002\u0018\u00002\u00020\u0001B\u0007\b\u0002¢\u0006\u0002\u0010\u0002J\u0010\u0010\u0003\u001a\u00020\u00042\u0006\u0010\u0005\u001a\u00020\u0006H\u0007¨\u0006\u0007"}, d2 = {"Landroidx/compose/foundation/text/input/internal/EditorInfoApi34;", "", "()V", "setHandwritingGestures", "", "editorInfo", "Landroid/view/inputmethod/EditorInfo;", "foundation_release"}, k = 1, mv = {1, 8, 0}, xi = 48)
final class EditorInfoApi34 {
    public static final EditorInfoApi34 INSTANCE = new EditorInfoApi34();

    private EditorInfoApi34() {
    }

    public final void setHandwritingGestures(EditorInfo editorInfo) {
        editorInfo.setSupportedHandwritingGestures(CollectionsKt.listOf(new Class[]{ComponentDialog$$ExternalSyntheticApiModelOutline0.m34m(), ComponentDialog$$ExternalSyntheticApiModelOutline0.m$3(), ComponentDialog$$ExternalSyntheticApiModelOutline0.m$1(), ComponentDialog$$ExternalSyntheticApiModelOutline0.m$2(), ComponentDialog$$ExternalSyntheticApiModelOutline0.m$4(), ComponentDialog$$ExternalSyntheticApiModelOutline0.m$5(), ComponentDialog$$ExternalSyntheticApiModelOutline0.m$6()}));
        editorInfo.setSupportedHandwritingGesturePreviews(SetsKt.setOf(new Class[]{ComponentDialog$$ExternalSyntheticApiModelOutline0.m34m(), ComponentDialog$$ExternalSyntheticApiModelOutline0.m$3(), ComponentDialog$$ExternalSyntheticApiModelOutline0.m$1(), ComponentDialog$$ExternalSyntheticApiModelOutline0.m$2()}));
    }
}
