package androidx.compose.foundation.text.input.internal;

import android.content.ClipDescription;
import android.view.DragEvent;
import androidx.autofill.HintConstants;
import androidx.compose.foundation.content.MediaType;
import androidx.compose.p002ui.draganddrop.DragAndDropEvent;
import androidx.compose.p002ui.draganddrop.DragAndDropModifierNode;
import androidx.compose.p002ui.draganddrop.DragAndDropNodeKt;
import androidx.compose.p002ui.draganddrop.DragAndDropTarget;
import androidx.compose.p002ui.draganddrop.DragAndDrop_androidKt;
import androidx.compose.p002ui.geometry.Offset;
import androidx.compose.p002ui.geometry.OffsetKt;
import androidx.compose.p002ui.platform.AndroidClipboardManager_androidKt;
import androidx.compose.p002ui.platform.ClipEntry;
import androidx.compose.p002ui.platform.ClipMetadata;
import java.util.Collection;
import java.util.Set;
import kotlin.Metadata;
import kotlin.Unit;
import kotlin.jvm.functions.Function0;
import kotlin.jvm.functions.Function1;
import kotlin.jvm.functions.Function2;
import kotlin.jvm.internal.Intrinsics;

@Metadata(d1 = {"\u0000J\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\u0010\"\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u000b\n\u0000\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0010\u0002\n\u0002\b\u0004\n\u0002\u0018\u0002\n\u0002\b\u0005\u001aÒ\u0002\u0010\u0000\u001a\u00020\u00012\u0012\u0010\u0002\u001a\u000e\u0012\n\u0012\b\u0012\u0004\u0012\u00020\u00050\u00040\u000326\u0010\u0006\u001a2\u0012\u0013\u0012\u00110\b¢\u0006\f\b\t\u0012\b\b\n\u0012\u0004\b\b(\u000b\u0012\u0013\u0012\u00110\f¢\u0006\f\b\t\u0012\b\b\n\u0012\u0004\b\b(\r\u0012\u0004\u0012\u00020\u000e0\u00072\u0012\u0010\u000f\u001a\u000e\u0012\u0004\u0012\u00020\u0011\u0012\u0004\u0012\u00020\u00120\u00102%\b\u0002\u0010\u0013\u001a\u001f\u0012\u0013\u0012\u00110\u0011¢\u0006\f\b\t\u0012\b\b\n\u0012\u0004\b\b(\u0014\u0012\u0004\u0012\u00020\u0012\u0018\u00010\u00102%\b\u0002\u0010\u0015\u001a\u001f\u0012\u0013\u0012\u00110\u0011¢\u0006\f\b\t\u0012\b\b\n\u0012\u0004\b\b(\u0014\u0012\u0004\u0012\u00020\u0012\u0018\u00010\u00102%\b\u0002\u0010\u0016\u001a\u001f\u0012\u0013\u0012\u00110\u0017¢\u0006\f\b\t\u0012\b\b\n\u0012\u0004\b\b(\u0018\u0012\u0004\u0012\u00020\u0012\u0018\u00010\u00102%\b\u0002\u0010\u0019\u001a\u001f\u0012\u0013\u0012\u00110\u0011¢\u0006\f\b\t\u0012\b\b\n\u0012\u0004\b\b(\u0014\u0012\u0004\u0012\u00020\u0012\u0018\u00010\u00102%\b\u0002\u0010\u001a\u001a\u001f\u0012\u0013\u0012\u00110\u0011¢\u0006\f\b\t\u0012\b\b\n\u0012\u0004\b\b(\u0014\u0012\u0004\u0012\u00020\u0012\u0018\u00010\u00102%\b\u0002\u0010\u001b\u001a\u001f\u0012\u0013\u0012\u00110\u0011¢\u0006\f\b\t\u0012\b\b\n\u0012\u0004\b\b(\u0014\u0012\u0004\u0012\u00020\u0012\u0018\u00010\u0010H\u0000¨\u0006\u001c"}, d2 = {"textFieldDragAndDropNode", "Landroidx/compose/ui/draganddrop/DragAndDropModifierNode;", "hintMediaTypes", "Lkotlin/Function0;", "", "Landroidx/compose/foundation/content/MediaType;", "onDrop", "Lkotlin/Function2;", "Landroidx/compose/ui/platform/ClipEntry;", "Lkotlin/ParameterName;", HintConstants.AUTOFILL_HINT_NAME, "clipEntry", "Landroidx/compose/ui/platform/ClipMetadata;", "clipMetadata", "", "dragAndDropRequestPermission", "Lkotlin/Function1;", "Landroidx/compose/ui/draganddrop/DragAndDropEvent;", "", "onStarted", "event", "onEntered", "onMoved", "Landroidx/compose/ui/geometry/Offset;", "position", "onChanged", "onExited", "onEnded", "foundation_release"}, k = 2, mv = {1, 8, 0}, xi = 48)
public final class TextFieldDragAndDropNode_androidKt {
    public static final DragAndDropModifierNode textFieldDragAndDropNode(final Function0<? extends Set<MediaType>> function0, final Function2<? super ClipEntry, ? super ClipMetadata, Boolean> function2, final Function1<? super DragAndDropEvent, Unit> function1, final Function1<? super DragAndDropEvent, Unit> function3, final Function1<? super DragAndDropEvent, Unit> function4, final Function1<? super Offset, Unit> function5, final Function1<? super DragAndDropEvent, Unit> function6, final Function1<? super DragAndDropEvent, Unit> function7, final Function1<? super DragAndDropEvent, Unit> function8) {
        return DragAndDropNodeKt.DragAndDropModifierNode(new Function1<DragAndDropEvent, Boolean>() {
            {
                super(1);
            }

            public final Boolean invoke(DragAndDropEvent dragAndDropEvent) {
                ClipDescription clipDescription = DragAndDrop_androidKt.toAndroidDragEvent(dragAndDropEvent).getClipDescription();
                Iterable<MediaType> iterable = (Iterable) function0.invoke();
                boolean z = false;
                if (!(iterable instanceof Collection) || !((Collection) iterable).isEmpty()) {
                    for (MediaType mediaType : iterable) {
                        if (Intrinsics.areEqual(mediaType, MediaType.INSTANCE.getAll()) || clipDescription.hasMimeType(mediaType.getRepresentation())) {
                            z = true;
                            break;
                        }
                    }
                }
                return Boolean.valueOf(z);
            }
        }, new DragAndDropTarget() {
            @Override
            public boolean onDrop(DragAndDropEvent event) {
                function1.invoke(event);
                return ((Boolean) function2.invoke(AndroidClipboardManager_androidKt.toClipEntry(DragAndDrop_androidKt.toAndroidDragEvent(event).getClipData()), AndroidClipboardManager_androidKt.toClipMetadata(DragAndDrop_androidKt.toAndroidDragEvent(event).getClipDescription()))).booleanValue();
            }

            @Override
            public void onStarted(DragAndDropEvent event) {
                Function1<DragAndDropEvent, Unit> function9 = function3;
                if (function9 != null) {
                    function9.invoke(event);
                    Unit unit = Unit.INSTANCE;
                }
            }

            @Override
            public void onEntered(DragAndDropEvent event) {
                Function1<DragAndDropEvent, Unit> function9 = function4;
                if (function9 != null) {
                    function9.invoke(event);
                    Unit unit = Unit.INSTANCE;
                }
            }

            @Override
            public void onMoved(DragAndDropEvent event) {
                DragEvent androidDragEvent = DragAndDrop_androidKt.toAndroidDragEvent(event);
                Function1<Offset, Unit> function9 = function5;
                if (function9 != null) {
                    function9.invoke(Offset.m4335boximpl(OffsetKt.Offset(androidDragEvent.getX(), androidDragEvent.getY())));
                    Unit unit = Unit.INSTANCE;
                }
            }

            @Override
            public void onExited(DragAndDropEvent event) {
                Function1<DragAndDropEvent, Unit> function9 = function7;
                if (function9 != null) {
                    function9.invoke(event);
                    Unit unit = Unit.INSTANCE;
                }
            }

            @Override
            public void onChanged(DragAndDropEvent event) {
                Function1<DragAndDropEvent, Unit> function9 = function6;
                if (function9 != null) {
                    function9.invoke(event);
                    Unit unit = Unit.INSTANCE;
                }
            }

            @Override
            public void onEnded(DragAndDropEvent event) {
                Function1<DragAndDropEvent, Unit> function9 = function8;
                if (function9 != null) {
                    function9.invoke(event);
                    Unit unit = Unit.INSTANCE;
                }
            }
        });
    }
}
