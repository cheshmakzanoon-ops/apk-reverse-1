package androidx.compose.foundation.content.internal;

import android.app.Activity;
import android.content.ClipData;
import android.content.Context;
import android.content.ContextWrapper;
import android.net.Uri;
import android.os.Build;
import android.view.View;
import androidx.compose.p002ui.draganddrop.DragAndDropEvent;
import androidx.compose.p002ui.draganddrop.DragAndDrop_androidKt;
import androidx.compose.p002ui.node.DelegatableNode;
import androidx.compose.p002ui.node.DelegatableNode_androidKt;
import androidx.core.view.DragAndDropPermissionsCompat;
import kotlin.Metadata;
import kotlin.jvm.internal.Intrinsics;

@Metadata(d1 = {"\u0000(\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u000b\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\u001a\u0012\u0010\u0000\u001a\u0004\u0018\u00010\u00012\u0006\u0010\u0002\u001a\u00020\u0003H\u0002\u001a\f\u0010\u0004\u001a\u00020\u0005*\u00020\u0006H\u0002\u001a\u0014\u0010\u0007\u001a\u00020\b*\u00020\t2\u0006\u0010\n\u001a\u00020\u000bH\u0000¨\u0006\f"}, d2 = {"tryGetActivity", "Landroid/app/Activity;", "view", "Landroid/view/View;", "containsContentUri", "", "Landroid/content/ClipData;", "dragAndDropRequestPermission", "", "Landroidx/compose/ui/node/DelegatableNode;", "event", "Landroidx/compose/ui/draganddrop/DragAndDropEvent;", "foundation_release"}, k = 2, mv = {1, 8, 0}, xi = 48)
public final class DragAndDropRequestPermission_androidKt {
    public static final void dragAndDropRequestPermission(DelegatableNode delegatableNode, DragAndDropEvent dragAndDropEvent) {
        Activity activityTryGetActivity;
        if (Build.VERSION.SDK_INT >= 24 && containsContentUri(DragAndDrop_androidKt.toAndroidDragEvent(dragAndDropEvent).getClipData()) && delegatableNode.getNode().getIsAttached() && (activityTryGetActivity = tryGetActivity(DelegatableNode_androidKt.requireView(delegatableNode))) != null) {
            DragAndDropPermissionsCompat.request(activityTryGetActivity, DragAndDrop_androidKt.toAndroidDragEvent(dragAndDropEvent));
        }
    }

    private static final boolean containsContentUri(ClipData clipData) {
        int itemCount = clipData.getItemCount();
        for (int i = 0; i < itemCount; i++) {
            Uri uri = clipData.getItemAt(i).getUri();
            if (uri != null && Intrinsics.areEqual(uri.getScheme(), "content")) {
                return true;
            }
        }
        return false;
    }

    private static final Activity tryGetActivity(View view) {
        for (Context context = view.getContext(); context instanceof ContextWrapper; context = ((ContextWrapper) context).getBaseContext()) {
            if (context instanceof Activity) {
                return (Activity) context;
            }
        }
        return null;
    }
}
