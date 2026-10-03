package androidx.compose.foundation.gestures;

import androidx.collection.MutableObjectFloatMap;
import kotlin.Metadata;

@Metadata(d1 = {"\u0000$\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u0000\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0010\u0002\n\u0000\n\u0002\u0010\u0007\n\u0002\b\u0002\b\u0007\u0018\u0000*\u0004\b\u0000\u0010\u00012\u00020\u0002B\u0005¢\u0006\u0002\u0010\u0003J\u001a\u0010\b\u001a\u00020\t*\u00028\u00002\u0006\u0010\n\u001a\u00020\u000bH\u0086\u0004¢\u0006\u0002\u0010\fR\u001a\u0010\u0004\u001a\b\u0012\u0004\u0012\u00028\u00000\u0005X\u0080\u0004¢\u0006\b\n\u0000\u001a\u0004\b\u0006\u0010\u0007¨\u0006\r"}, d2 = {"Landroidx/compose/foundation/gestures/DraggableAnchorsConfig;", "T", "", "()V", "anchors", "Landroidx/collection/MutableObjectFloatMap;", "getAnchors$foundation_release", "()Landroidx/collection/MutableObjectFloatMap;", "at", "", "position", "", "(Ljava/lang/Object;F)V", "foundation_release"}, k = 1, mv = {1, 8, 0}, xi = 48)
public final class DraggableAnchorsConfig<T> {
    public static final int $stable = 8;
    private final MutableObjectFloatMap<T> anchors = new MutableObjectFloatMap<>(0, 1, null);

    public final MutableObjectFloatMap<T> getAnchors$foundation_release() {
        return this.anchors;
    }

    public final void m82at(T t, float f) {
        this.anchors.set(t, f);
    }
}
