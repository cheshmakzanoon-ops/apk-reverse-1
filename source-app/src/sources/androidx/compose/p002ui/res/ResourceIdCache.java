package androidx.compose.p002ui.res;

import android.content.res.Resources;
import android.util.TypedValue;
import androidx.collection.MutableIntObjectMap;
import kotlin.Metadata;
import kotlin.Unit;

@Metadata(d1 = {"\u0000*\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\b\n\u0000\b\u0000\u0018\u00002\u00020\u0001B\u0005¢\u0006\u0002\u0010\u0002J\u0006\u0010\u0006\u001a\u00020\u0007J\u0018\u0010\b\u001a\u00020\u00052\u0006\u0010\t\u001a\u00020\n2\b\b\u0001\u0010\u000b\u001a\u00020\fR\u0014\u0010\u0003\u001a\b\u0012\u0004\u0012\u00020\u00050\u0004X\u0082\u0004¢\u0006\u0002\n\u0000¨\u0006\r"}, d2 = {"Landroidx/compose/ui/res/ResourceIdCache;", "", "()V", "resIdPathMap", "Landroidx/collection/MutableIntObjectMap;", "Landroid/util/TypedValue;", "clear", "", "resolveResourcePath", "res", "Landroid/content/res/Resources;", "id", "", "ui_release"}, k = 1, mv = {1, 8, 0}, xi = 48)
public final class ResourceIdCache {
    public static final int $stable = 8;
    private final MutableIntObjectMap<TypedValue> resIdPathMap = new MutableIntObjectMap<>(0, 1, null);

    public final TypedValue resolveResourcePath(Resources res, int id) {
        TypedValue typedValue;
        synchronized (this) {
            typedValue = this.resIdPathMap.get(id);
            if (typedValue == null) {
                typedValue = new TypedValue();
                res.getValue(id, typedValue, true);
                this.resIdPathMap.put(id, typedValue);
            }
        }
        return typedValue;
    }

    public final void clear() {
        synchronized (this) {
            this.resIdPathMap.clear();
            Unit unit = Unit.INSTANCE;
        }
    }
}
