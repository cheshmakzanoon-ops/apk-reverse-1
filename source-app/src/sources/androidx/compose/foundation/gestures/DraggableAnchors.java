package androidx.compose.foundation.gestures;

import androidx.autofill.HintConstants;
import kotlin.Metadata;
import kotlin.Unit;
import kotlin.jvm.functions.Function2;

@Metadata(d1 = {"\u00006\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u0000\n\u0000\n\u0002\u0010\b\n\u0002\b\u0004\n\u0002\u0010\u0007\n\u0002\b\u0002\n\u0002\u0010\u000b\n\u0002\b\u0002\n\u0002\u0010\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\n\bg\u0018\u0000*\u0004\b\u0000\u0010\u00012\u00020\u0002J\u0017\u0010\u0007\u001a\u0004\u0018\u00018\u00002\u0006\u0010\b\u001a\u00020\tH&¢\u0006\u0002\u0010\nJ\u001f\u0010\u0007\u001a\u0004\u0018\u00018\u00002\u0006\u0010\b\u001a\u00020\t2\u0006\u0010\u000b\u001a\u00020\fH&¢\u0006\u0002\u0010\rJ@\u0010\u000e\u001a\u00020\u000f26\u0010\u0010\u001a2\u0012\u0013\u0012\u00118\u0000¢\u0006\f\b\u0012\u0012\b\b\u0013\u0012\u0004\b\b(\u0014\u0012\u0013\u0012\u00110\t¢\u0006\f\b\u0012\u0012\b\b\u0013\u0012\u0004\b\b(\b\u0012\u0004\u0012\u00020\u000f0\u0011H&J\u0015\u0010\u0015\u001a\u00020\f2\u0006\u0010\u0016\u001a\u00028\u0000H&¢\u0006\u0002\u0010\u0017J\b\u0010\u0018\u001a\u00020\tH&J\b\u0010\u0019\u001a\u00020\tH&J\u0015\u0010\u001a\u001a\u00020\t2\u0006\u0010\u0016\u001a\u00028\u0000H&¢\u0006\u0002\u0010\u001bR\u0012\u0010\u0003\u001a\u00020\u0004X¦\u0004¢\u0006\u0006\u001a\u0004\b\u0005\u0010\u0006ø\u0001\u0000\u0082\u0002\u0006\n\u0004\b!0\u0001¨\u0006\u001cÀ\u0006\u0001"}, d2 = {"Landroidx/compose/foundation/gestures/DraggableAnchors;", "T", "", "size", "", "getSize", "()I", "closestAnchor", "position", "", "(F)Ljava/lang/Object;", "searchUpwards", "", "(FZ)Ljava/lang/Object;", "forEach", "", "block", "Lkotlin/Function2;", "Lkotlin/ParameterName;", HintConstants.AUTOFILL_HINT_NAME, "anchor", "hasAnchorFor", "value", "(Ljava/lang/Object;)Z", "maxAnchor", "minAnchor", "positionOf", "(Ljava/lang/Object;)F", "foundation_release"}, k = 1, mv = {1, 8, 0}, xi = 48)
public interface DraggableAnchors<T> {
    T closestAnchor(float position);

    T closestAnchor(float position, boolean searchUpwards);

    void forEach(Function2<? super T, ? super Float, Unit> block);

    int getSize();

    boolean hasAnchorFor(T value);

    float maxAnchor();

    float minAnchor();

    float positionOf(T value);
}
