package androidx.compose.p002ui.layout;

import androidx.compose.p002ui.geometry.Offset;
import androidx.compose.p002ui.geometry.OffsetKt;
import androidx.compose.p002ui.geometry.Rect;
import androidx.compose.p002ui.node.NodeCoordinator;
import androidx.compose.ui.unit.IntSize;
import kotlin.Metadata;

@Metadata(d1 = {"\u0000\u0016\n\u0000\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0004\n\u0002\u0018\u0002\n\u0002\b\u0005\u001a\n\u0010\u0000\u001a\u00020\u0001*\u00020\u0002\u001a\n\u0010\u0003\u001a\u00020\u0001*\u00020\u0002\u001a\n\u0010\u0004\u001a\u00020\u0001*\u00020\u0002\u001a\n\u0010\u0005\u001a\u00020\u0002*\u00020\u0002\u001a\u000f\u0010\u0006\u001a\u00020\u0007*\u00020\u0002¢\u0006\u0002\u0010\b\u001a\u000f\u0010\t\u001a\u00020\u0007*\u00020\u0002¢\u0006\u0002\u0010\b\u001a\u000f\u0010\n\u001a\u00020\u0007*\u00020\u0002¢\u0006\u0002\u0010\b\u001a\u000f\u0010\u000b\u001a\u00020\u0007*\u00020\u0002¢\u0006\u0002\u0010\b¨\u0006\f"}, d2 = {"boundsInParent", "Landroidx/compose/ui/geometry/Rect;", "Landroidx/compose/ui/layout/LayoutCoordinates;", "boundsInRoot", "boundsInWindow", "findRootCoordinates", "positionInParent", "Landroidx/compose/ui/geometry/Offset;", "(Landroidx/compose/ui/layout/LayoutCoordinates;)J", "positionInRoot", "positionInWindow", "positionOnScreen", "ui_release"}, k = 2, mv = {1, 8, 0}, xi = 48)
public final class LayoutCoordinatesKt {
    public static final long positionInRoot(LayoutCoordinates layoutCoordinates) {
        return layoutCoordinates.mo6043localToRootMKHz9U(Offset.INSTANCE.m4362getZeroF1C5BW0());
    }

    public static final long positionInWindow(LayoutCoordinates layoutCoordinates) {
        return layoutCoordinates.mo6045localToWindowMKHz9U(Offset.INSTANCE.m4362getZeroF1C5BW0());
    }

    public static final long positionOnScreen(LayoutCoordinates layoutCoordinates) {
        return layoutCoordinates.mo6044localToScreenMKHz9U(Offset.INSTANCE.m4362getZeroF1C5BW0());
    }

    public static final Rect boundsInRoot(LayoutCoordinates layoutCoordinates) {
        return LayoutCoordinates.CC.localBoundingBoxOf$default(findRootCoordinates(layoutCoordinates), layoutCoordinates, false, 2, null);
    }

    public static final Rect boundsInWindow(LayoutCoordinates layoutCoordinates) {
        LayoutCoordinates layoutCoordinatesFindRootCoordinates = findRootCoordinates(layoutCoordinates);
        float f = IntSize.getWidth-impl(layoutCoordinatesFindRootCoordinates.mo6040getSizeYbymL2g());
        float f2 = IntSize.getHeight-impl(layoutCoordinatesFindRootCoordinates.mo6040getSizeYbymL2g());
        Rect rectBoundsInRoot = boundsInRoot(layoutCoordinates);
        float left = rectBoundsInRoot.getLeft();
        if (left < 0.0f) {
            left = 0.0f;
        }
        if (left > f) {
            left = f;
        }
        float top = rectBoundsInRoot.getTop();
        if (top < 0.0f) {
            top = 0.0f;
        }
        if (top > f2) {
            top = f2;
        }
        float right = rectBoundsInRoot.getRight();
        if (right < 0.0f) {
            right = 0.0f;
        }
        if (right <= f) {
            f = right;
        }
        float bottom = rectBoundsInRoot.getBottom();
        float f3 = bottom >= 0.0f ? bottom : 0.0f;
        if (f3 <= f2) {
            f2 = f3;
        }
        if (left == f || top == f2) {
            return Rect.INSTANCE.getZero();
        }
        long jMo6045localToWindowMKHz9U = layoutCoordinatesFindRootCoordinates.mo6045localToWindowMKHz9U(OffsetKt.Offset(left, top));
        long jMo6045localToWindowMKHz9U2 = layoutCoordinatesFindRootCoordinates.mo6045localToWindowMKHz9U(OffsetKt.Offset(f, top));
        long jMo6045localToWindowMKHz9U3 = layoutCoordinatesFindRootCoordinates.mo6045localToWindowMKHz9U(OffsetKt.Offset(f, f2));
        long jMo6045localToWindowMKHz9U4 = layoutCoordinatesFindRootCoordinates.mo6045localToWindowMKHz9U(OffsetKt.Offset(left, f2));
        float fM4346getXimpl = Offset.m4346getXimpl(jMo6045localToWindowMKHz9U);
        float fM4346getXimpl2 = Offset.m4346getXimpl(jMo6045localToWindowMKHz9U2);
        float fM4346getXimpl3 = Offset.m4346getXimpl(jMo6045localToWindowMKHz9U4);
        float fM4346getXimpl4 = Offset.m4346getXimpl(jMo6045localToWindowMKHz9U3);
        float fMin = Math.min(fM4346getXimpl, Math.min(fM4346getXimpl2, Math.min(fM4346getXimpl3, fM4346getXimpl4)));
        float fMax = Math.max(fM4346getXimpl, Math.max(fM4346getXimpl2, Math.max(fM4346getXimpl3, fM4346getXimpl4)));
        float fM4347getYimpl = Offset.m4347getYimpl(jMo6045localToWindowMKHz9U);
        float fM4347getYimpl2 = Offset.m4347getYimpl(jMo6045localToWindowMKHz9U2);
        float fM4347getYimpl3 = Offset.m4347getYimpl(jMo6045localToWindowMKHz9U4);
        float fM4347getYimpl4 = Offset.m4347getYimpl(jMo6045localToWindowMKHz9U3);
        return new Rect(fMin, Math.min(fM4347getYimpl, Math.min(fM4347getYimpl2, Math.min(fM4347getYimpl3, fM4347getYimpl4))), fMax, Math.max(fM4347getYimpl, Math.max(fM4347getYimpl2, Math.max(fM4347getYimpl3, fM4347getYimpl4))));
    }

    public static final long positionInParent(LayoutCoordinates layoutCoordinates) {
        LayoutCoordinates parentLayoutCoordinates = layoutCoordinates.getParentLayoutCoordinates();
        return parentLayoutCoordinates != null ? parentLayoutCoordinates.mo6041localPositionOfR5De75A(layoutCoordinates, Offset.INSTANCE.m4362getZeroF1C5BW0()) : Offset.INSTANCE.m4362getZeroF1C5BW0();
    }

    public static final Rect boundsInParent(LayoutCoordinates layoutCoordinates) {
        Rect rectLocalBoundingBoxOf$default;
        LayoutCoordinates parentLayoutCoordinates = layoutCoordinates.getParentLayoutCoordinates();
        return (parentLayoutCoordinates == null || (rectLocalBoundingBoxOf$default = LayoutCoordinates.CC.localBoundingBoxOf$default(parentLayoutCoordinates, layoutCoordinates, false, 2, null)) == null) ? new Rect(0.0f, 0.0f, IntSize.getWidth-impl(layoutCoordinates.mo6040getSizeYbymL2g()), IntSize.getHeight-impl(layoutCoordinates.mo6040getSizeYbymL2g())) : rectLocalBoundingBoxOf$default;
    }

    public static final LayoutCoordinates findRootCoordinates(LayoutCoordinates layoutCoordinates) {
        LayoutCoordinates layoutCoordinates2;
        LayoutCoordinates parentLayoutCoordinates = layoutCoordinates.getParentLayoutCoordinates();
        while (true) {
            LayoutCoordinates layoutCoordinates3 = parentLayoutCoordinates;
            layoutCoordinates2 = layoutCoordinates;
            layoutCoordinates = layoutCoordinates3;
            if (layoutCoordinates == null) {
                break;
            }
            parentLayoutCoordinates = layoutCoordinates.getParentLayoutCoordinates();
        }
        NodeCoordinator nodeCoordinator = layoutCoordinates2 instanceof NodeCoordinator ? (NodeCoordinator) layoutCoordinates2 : null;
        if (nodeCoordinator == null) {
            return layoutCoordinates2;
        }
        NodeCoordinator wrappedBy = nodeCoordinator.getWrappedBy();
        while (true) {
            NodeCoordinator nodeCoordinator2 = wrappedBy;
            NodeCoordinator nodeCoordinator3 = nodeCoordinator;
            nodeCoordinator = nodeCoordinator2;
            if (nodeCoordinator != null) {
                wrappedBy = nodeCoordinator.getWrappedBy();
            } else {
                return nodeCoordinator3;
            }
        }
    }
}
