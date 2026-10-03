package coil.compose;

import androidx.compose.p000ui.unit.Constraints;
import androidx.compose.runtime.Applier;
import androidx.compose.runtime.ComposablesKt;
import androidx.compose.runtime.Composer;
import androidx.compose.runtime.ComposerKt;
import androidx.compose.runtime.CompositionLocalMap;
import androidx.compose.runtime.RecomposeScopeImplKt;
import androidx.compose.runtime.ScopeUpdateScope;
import androidx.compose.runtime.Updater;
import androidx.compose.ui.Alignment;
import androidx.compose.ui.ComposedModifierKt;
import androidx.compose.ui.Modifier;
import androidx.compose.ui.draw.ClipKt;
import androidx.compose.ui.graphics.ColorFilter;
import androidx.compose.ui.graphics.drawscope.DrawScope;
import androidx.compose.ui.graphics.painter.Painter;
import androidx.compose.ui.layout.ContentScale;
import androidx.compose.ui.layout.IntrinsicMeasureScope;
import androidx.compose.ui.layout.Measurable;
import androidx.compose.ui.layout.MeasurePolicy;
import androidx.compose.ui.layout.MeasureResult;
import androidx.compose.ui.layout.MeasureScope;
import androidx.compose.ui.layout.Placeable;
import androidx.compose.ui.node.ComposeUiNode;
import androidx.constraintlayout.widget.ConstraintLayout;
import androidx.core.view.accessibility.AccessibilityEventCompat;
import coil.ImageLoader;
import coil.request.ImageRequest;
import com.facebook.devicerequests.internal.DeviceRequestsHelper;
import com.facebook.internal.ServerProtocol;
import java.util.List;
import java.util.Map;
import kotlin.Deprecated;
import kotlin.DeprecationLevel;
import kotlin.KotlinNothingValueException;
import kotlin.Metadata;
import kotlin.Unit;
import kotlin.jvm.functions.Function0;
import kotlin.jvm.functions.Function1;
import kotlin.jvm.functions.Function2;
import kotlin.jvm.internal.Intrinsics;

@Metadata(d1 = {"\u0000\u0086\u0001\n\u0000\n\u0002\u0010\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u000e\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u0007\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u000b\n\u0002\b\u0003\n\u0002\u0010\u0000\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0006\n\u0002\u0018\u0002\n\u0002\b\u0002\u001a\u0088\u0001\u0010\u0000\u001a\u00020\u00012\u0006\u0010\u0002\u001a\u00020\u00032\b\u0010\u0004\u001a\u0004\u0018\u00010\u00052\u0006\u0010\u0006\u001a\u00020\u00072\u0012\u0010\b\u001a\u000e\u0012\u0004\u0012\u00020\n\u0012\u0004\u0012\u00020\n0\t2\u0014\u0010\u000b\u001a\u0010\u0012\u0004\u0012\u00020\n\u0012\u0004\u0012\u00020\u0001\u0018\u00010\t2\u0006\u0010\f\u001a\u00020\r2\u0006\u0010\u000e\u001a\u00020\u000f2\u0006\u0010\u0010\u001a\u00020\u00112\b\u0010\u0012\u001a\u0004\u0018\u00010\u00132\u0006\u0010\u0014\u001a\u00020\u00152\u0006\u0010\u0016\u001a\u00020\u0017H\u0003ø\u0001\u0000¢\u0006\u0004\b\u0018\u0010\u0019\u001a\u009a\u0001\u0010\u0000\u001a\u00020\u00012\b\u0010\u001a\u001a\u0004\u0018\u00010\u001b2\b\u0010\u0004\u001a\u0004\u0018\u00010\u00052\u0006\u0010\u001c\u001a\u00020\u001d2\b\b\u0002\u0010\u0006\u001a\u00020\u00072\u0014\b\u0002\u0010\b\u001a\u000e\u0012\u0004\u0012\u00020\n\u0012\u0004\u0012\u00020\n0\t2\u0016\b\u0002\u0010\u000b\u001a\u0010\u0012\u0004\u0012\u00020\n\u0012\u0004\u0012\u00020\u0001\u0018\u00010\t2\b\b\u0002\u0010\f\u001a\u00020\r2\b\b\u0002\u0010\u000e\u001a\u00020\u000f2\b\b\u0002\u0010\u0010\u001a\u00020\u00112\n\b\u0002\u0010\u0012\u001a\u0004\u0018\u00010\u00132\b\b\u0002\u0010\u0014\u001a\u00020\u0015H\u0007ø\u0001\u0000¢\u0006\u0004\b\u001e\u0010\u001f\u001a®\u0001\u0010\u0000\u001a\u00020\u00012\b\u0010\u001a\u001a\u0004\u0018\u00010\u001b2\b\u0010\u0004\u001a\u0004\u0018\u00010\u00052\u0006\u0010\u001c\u001a\u00020\u001d2\b\b\u0002\u0010\u0006\u001a\u00020\u00072\u0014\b\u0002\u0010\b\u001a\u000e\u0012\u0004\u0012\u00020\n\u0012\u0004\u0012\u00020\n0\t2\u0016\b\u0002\u0010\u000b\u001a\u0010\u0012\u0004\u0012\u00020\n\u0012\u0004\u0012\u00020\u0001\u0018\u00010\t2\b\b\u0002\u0010\f\u001a\u00020\r2\b\b\u0002\u0010\u000e\u001a\u00020\u000f2\b\b\u0002\u0010\u0010\u001a\u00020\u00112\n\b\u0002\u0010\u0012\u001a\u0004\u0018\u00010\u00132\b\b\u0002\u0010\u0014\u001a\u00020\u00152\b\b\u0002\u0010\u0016\u001a\u00020\u00172\b\b\u0002\u0010 \u001a\u00020!H\u0007ø\u0001\u0000¢\u0006\u0004\b\"\u0010#\u001aØ\u0001\u0010\u0000\u001a\u00020\u00012\b\u0010\u001a\u001a\u0004\u0018\u00010\u001b2\b\u0010\u0004\u001a\u0004\u0018\u00010\u00052\u0006\u0010\u001c\u001a\u00020\u001d2\b\b\u0002\u0010\u0006\u001a\u00020\u00072\n\b\u0002\u0010$\u001a\u0004\u0018\u00010%2\n\b\u0002\u0010&\u001a\u0004\u0018\u00010%2\n\b\u0002\u0010'\u001a\u0004\u0018\u00010%2\u0016\b\u0002\u0010(\u001a\u0010\u0012\u0004\u0012\u00020)\u0012\u0004\u0012\u00020\u0001\u0018\u00010\t2\u0016\b\u0002\u0010*\u001a\u0010\u0012\u0004\u0012\u00020+\u0012\u0004\u0012\u00020\u0001\u0018\u00010\t2\u0016\b\u0002\u0010,\u001a\u0010\u0012\u0004\u0012\u00020-\u0012\u0004\u0012\u00020\u0001\u0018\u00010\t2\b\b\u0002\u0010\f\u001a\u00020\r2\b\b\u0002\u0010\u000e\u001a\u00020\u000f2\b\b\u0002\u0010\u0010\u001a\u00020\u00112\n\b\u0002\u0010\u0012\u001a\u0004\u0018\u00010\u00132\b\b\u0002\u0010\u0014\u001a\u00020\u0015H\u0007ø\u0001\u0000¢\u0006\u0004\b.\u0010/\u001aì\u0001\u0010\u0000\u001a\u00020\u00012\b\u0010\u001a\u001a\u0004\u0018\u00010\u001b2\b\u0010\u0004\u001a\u0004\u0018\u00010\u00052\u0006\u0010\u001c\u001a\u00020\u001d2\b\b\u0002\u0010\u0006\u001a\u00020\u00072\n\b\u0002\u0010$\u001a\u0004\u0018\u00010%2\n\b\u0002\u0010&\u001a\u0004\u0018\u00010%2\n\b\u0002\u0010'\u001a\u0004\u0018\u00010%2\u0016\b\u0002\u0010(\u001a\u0010\u0012\u0004\u0012\u00020)\u0012\u0004\u0012\u00020\u0001\u0018\u00010\t2\u0016\b\u0002\u0010*\u001a\u0010\u0012\u0004\u0012\u00020+\u0012\u0004\u0012\u00020\u0001\u0018\u00010\t2\u0016\b\u0002\u0010,\u001a\u0010\u0012\u0004\u0012\u00020-\u0012\u0004\u0012\u00020\u0001\u0018\u00010\t2\b\b\u0002\u0010\f\u001a\u00020\r2\b\b\u0002\u0010\u000e\u001a\u00020\u000f2\b\b\u0002\u0010\u0010\u001a\u00020\u00112\n\b\u0002\u0010\u0012\u001a\u0004\u0018\u00010\u00132\b\b\u0002\u0010\u0014\u001a\u00020\u00152\b\b\u0002\u0010\u0016\u001a\u00020\u00172\b\b\u0002\u0010 \u001a\u00020!H\u0007ø\u0001\u0000¢\u0006\u0004\b0\u00101\u001aQ\u00102\u001a\u00020\u00012\u0006\u0010\u0006\u001a\u00020\u00072\u0006\u00103\u001a\u0002042\b\u0010\u0004\u001a\u0004\u0018\u00010\u00052\u0006\u0010\f\u001a\u00020\r2\u0006\u0010\u000e\u001a\u00020\u000f2\u0006\u0010\u0010\u001a\u00020\u00112\b\u0010\u0012\u001a\u0004\u0018\u00010\u00132\u0006\u0010\u0016\u001a\u00020\u0017H\u0003¢\u0006\u0002\u00105\u0082\u0002\u0007\n\u0005\b¡\u001e0\u0001¨\u00066"}, d2 = {"AsyncImage", "", ServerProtocol.DIALOG_PARAM_STATE, "Lcoil/compose/AsyncImageState;", "contentDescription", "", "modifier", "Landroidx/compose/ui/Modifier;", "transform", "Lkotlin/Function1;", "Lcoil/compose/AsyncImagePainter$State;", "onState", "alignment", "Landroidx/compose/ui/Alignment;", "contentScale", "Landroidx/compose/ui/layout/ContentScale;", "alpha", "", "colorFilter", "Landroidx/compose/ui/graphics/ColorFilter;", "filterQuality", "Landroidx/compose/ui/graphics/FilterQuality;", "clipToBounds", "", "AsyncImage-76YX9Dk", "(Lcoil/compose/AsyncImageState;Ljava/lang/String;Landroidx/compose/ui/Modifier;Lkotlin/jvm/functions/Function1;Lkotlin/jvm/functions/Function1;Landroidx/compose/ui/Alignment;Landroidx/compose/ui/layout/ContentScale;FLandroidx/compose/ui/graphics/ColorFilter;IZLandroidx/compose/runtime/Composer;II)V", DeviceRequestsHelper.DEVICE_INFO_MODEL, "", "imageLoader", "Lcoil/ImageLoader;", "AsyncImage-MvsnxeU", "(Ljava/lang/Object;Ljava/lang/String;Lcoil/ImageLoader;Landroidx/compose/ui/Modifier;Lkotlin/jvm/functions/Function1;Lkotlin/jvm/functions/Function1;Landroidx/compose/ui/Alignment;Landroidx/compose/ui/layout/ContentScale;FLandroidx/compose/ui/graphics/ColorFilter;ILandroidx/compose/runtime/Composer;III)V", "modelEqualityDelegate", "Lcoil/compose/EqualityDelegate;", "AsyncImage-QgsmV_s", "(Ljava/lang/Object;Ljava/lang/String;Lcoil/ImageLoader;Landroidx/compose/ui/Modifier;Lkotlin/jvm/functions/Function1;Lkotlin/jvm/functions/Function1;Landroidx/compose/ui/Alignment;Landroidx/compose/ui/layout/ContentScale;FLandroidx/compose/ui/graphics/ColorFilter;IZLcoil/compose/EqualityDelegate;Landroidx/compose/runtime/Composer;III)V", "placeholder", "Landroidx/compose/ui/graphics/painter/Painter;", "error", "fallback", "onLoading", "Lcoil/compose/AsyncImagePainter$State$Loading;", "onSuccess", "Lcoil/compose/AsyncImagePainter$State$Success;", "onError", "Lcoil/compose/AsyncImagePainter$State$Error;", "AsyncImage-Q4Kwu38", "(Ljava/lang/Object;Ljava/lang/String;Lcoil/ImageLoader;Landroidx/compose/ui/Modifier;Landroidx/compose/ui/graphics/painter/Painter;Landroidx/compose/ui/graphics/painter/Painter;Landroidx/compose/ui/graphics/painter/Painter;Lkotlin/jvm/functions/Function1;Lkotlin/jvm/functions/Function1;Lkotlin/jvm/functions/Function1;Landroidx/compose/ui/Alignment;Landroidx/compose/ui/layout/ContentScale;FLandroidx/compose/ui/graphics/ColorFilter;ILandroidx/compose/runtime/Composer;III)V", "AsyncImage-J-FEaFM", "(Ljava/lang/Object;Ljava/lang/String;Lcoil/ImageLoader;Landroidx/compose/ui/Modifier;Landroidx/compose/ui/graphics/painter/Painter;Landroidx/compose/ui/graphics/painter/Painter;Landroidx/compose/ui/graphics/painter/Painter;Lkotlin/jvm/functions/Function1;Lkotlin/jvm/functions/Function1;Lkotlin/jvm/functions/Function1;Landroidx/compose/ui/Alignment;Landroidx/compose/ui/layout/ContentScale;FLandroidx/compose/ui/graphics/ColorFilter;IZLcoil/compose/EqualityDelegate;Landroidx/compose/runtime/Composer;III)V", "Content", "painter", "Lcoil/compose/AsyncImagePainter;", "(Landroidx/compose/ui/Modifier;Lcoil/compose/AsyncImagePainter;Ljava/lang/String;Landroidx/compose/ui/Alignment;Landroidx/compose/ui/layout/ContentScale;FLandroidx/compose/ui/graphics/ColorFilter;ZLandroidx/compose/runtime/Composer;I)V", "coil-compose-base_release"}, k = 2, mv = {1, 9, 0}, xi = ConstraintLayout.LayoutParams.Table.LAYOUT_CONSTRAINT_VERTICAL_CHAINSTYLE)
public final class AsyncImageKt {
    public static final void m2258AsyncImageJFEaFM(Object obj, String str, ImageLoader imageLoader, Modifier modifier, Painter painter, Painter painter2, Painter painter3, Function1<? super AsyncImagePainter.State.Loading, Unit> function1, Function1<? super AsyncImagePainter.State.Success, Unit> function2, Function1<? super AsyncImagePainter.State.Error, Unit> function3, Alignment alignment, ContentScale contentScale, float f, ColorFilter colorFilter, int i, boolean z, EqualityDelegate equalityDelegate, Composer composer, int i2, int i3, int i4) throws KotlinNothingValueException {
        composer.startReplaceableGroup(-1481548872);
        Modifier modifier2 = (i4 & 8) != 0 ? (Modifier) Modifier.Companion : modifier;
        Painter painter4 = (i4 & 16) != 0 ? null : painter;
        Painter painter5 = (i4 & 32) != 0 ? null : painter2;
        Painter painter6 = (i4 & 64) != 0 ? painter5 : painter3;
        Function1<? super AsyncImagePainter.State.Loading, Unit> function4 = (i4 & 128) != 0 ? null : function1;
        Function1<? super AsyncImagePainter.State.Success, Unit> function5 = (i4 & 256) != 0 ? null : function2;
        Function1<? super AsyncImagePainter.State.Error, Unit> function6 = (i4 & 512) != 0 ? null : function3;
        Alignment center = (i4 & 1024) != 0 ? Alignment.Companion.getCenter() : alignment;
        ContentScale fit = (i4 & 2048) != 0 ? ContentScale.Companion.getFit() : contentScale;
        float f2 = (i4 & 4096) != 0 ? 1.0f : f;
        ColorFilter colorFilter2 = (i4 & 8192) != 0 ? null : colorFilter;
        int i5 = (i4 & 16384) != 0 ? DrawScope.Companion.getDefaultFilterQuality-f-v9h1I() : i;
        boolean z2 = (i4 & 32768) != 0 ? true : z;
        EqualityDelegate defaultModelEqualityDelegate = (i4 & 65536) != 0 ? EqualityDelegateKt.getDefaultModelEqualityDelegate() : equalityDelegate;
        if (ComposerKt.isTraceInProgress()) {
            ComposerKt.traceEventStart(-1481548872, i2, i3, "coil.compose.AsyncImage (AsyncImage.kt:68)");
        }
        int i6 = i3 << 15;
        m2257AsyncImage76YX9Dk(new AsyncImageState(obj, defaultModelEqualityDelegate, imageLoader), str, modifier2, UtilsKt.transformOf(painter4, painter5, painter6), UtilsKt.onStateOf(function4, function5, function6), center, fit, f2, colorFilter2, i5, z2, composer, ((i2 >> 3) & 896) | (i2 & 112) | (458752 & i6) | (3670016 & i6) | (29360128 & i6) | (234881024 & i6) | (i6 & 1879048192), (i3 >> 15) & 14);
        if (ComposerKt.isTraceInProgress()) {
            ComposerKt.traceEventEnd();
        }
        composer.endReplaceableGroup();
    }

    @Deprecated(level = DeprecationLevel.HIDDEN, message = "Kept for binary compatibility.")
    public static final void m2260AsyncImageQ4Kwu38(Object obj, String str, ImageLoader imageLoader, Modifier modifier, Painter painter, Painter painter2, Painter painter3, Function1 function1, Function1 function2, Function1 function3, Alignment alignment, ContentScale contentScale, float f, ColorFilter colorFilter, int i, Composer composer, int i2, int i3, int i4) throws KotlinNothingValueException {
        composer.startReplaceableGroup(-245964807);
        Modifier modifier2 = (i4 & 8) != 0 ? (Modifier) Modifier.Companion : modifier;
        Painter painter4 = (i4 & 16) != 0 ? null : painter;
        Painter painter5 = (i4 & 32) != 0 ? null : painter2;
        Painter painter6 = (i4 & 64) != 0 ? painter5 : painter3;
        Function1 function4 = (i4 & 128) != 0 ? null : function1;
        Function1 function5 = (i4 & 256) != 0 ? null : function2;
        Function1 function6 = (i4 & 512) != 0 ? null : function3;
        Alignment center = (i4 & 1024) != 0 ? Alignment.Companion.getCenter() : alignment;
        ContentScale fit = (i4 & 2048) != 0 ? ContentScale.Companion.getFit() : contentScale;
        float f2 = (i4 & 4096) != 0 ? 1.0f : f;
        ColorFilter colorFilter2 = (i4 & 8192) != 0 ? null : colorFilter;
        int i5 = (i4 & 16384) != 0 ? DrawScope.Companion.getDefaultFilterQuality-f-v9h1I() : i;
        if (ComposerKt.isTraceInProgress()) {
            ComposerKt.traceEventStart(-245964807, i2, i3, "coil.compose.AsyncImage (AsyncImage.kt:101)");
        }
        int i6 = i3 << 15;
        m2257AsyncImage76YX9Dk(new AsyncImageState(obj, EqualityDelegateKt.getDefaultModelEqualityDelegate(), imageLoader), str, modifier2, UtilsKt.transformOf(painter4, painter5, painter6), UtilsKt.onStateOf(function4, function5, function6), center, fit, f2, colorFilter2, i5, true, composer, ((i2 >> 3) & 896) | (i2 & 112) | (458752 & i6) | (3670016 & i6) | (29360128 & i6) | (234881024 & i6) | (i6 & 1879048192), 6);
        if (ComposerKt.isTraceInProgress()) {
            ComposerKt.traceEventEnd();
        }
        composer.endReplaceableGroup();
    }

    public static final void m2261AsyncImageQgsmV_s(Object obj, String str, ImageLoader imageLoader, Modifier modifier, Function1<? super AsyncImagePainter.State, ? extends AsyncImagePainter.State> function1, Function1<? super AsyncImagePainter.State, Unit> function2, Alignment alignment, ContentScale contentScale, float f, ColorFilter colorFilter, int i, boolean z, EqualityDelegate equalityDelegate, Composer composer, int i2, int i3, int i4) throws KotlinNothingValueException {
        composer.startReplaceableGroup(2032051394);
        Modifier modifier2 = (i4 & 8) != 0 ? (Modifier) Modifier.Companion : modifier;
        Function1<? super AsyncImagePainter.State, ? extends AsyncImagePainter.State> defaultTransform = (i4 & 16) != 0 ? AsyncImagePainter.INSTANCE.getDefaultTransform() : function1;
        Function1<? super AsyncImagePainter.State, Unit> function3 = (i4 & 32) != 0 ? null : function2;
        Alignment center = (i4 & 64) != 0 ? Alignment.Companion.getCenter() : alignment;
        ContentScale fit = (i4 & 128) != 0 ? ContentScale.Companion.getFit() : contentScale;
        float f2 = (i4 & 256) != 0 ? 1.0f : f;
        ColorFilter colorFilter2 = (i4 & 512) != 0 ? null : colorFilter;
        int i5 = (i4 & 1024) != 0 ? DrawScope.Companion.getDefaultFilterQuality-f-v9h1I() : i;
        boolean z2 = (i4 & 2048) != 0 ? true : z;
        EqualityDelegate defaultModelEqualityDelegate = (i4 & 4096) != 0 ? EqualityDelegateKt.getDefaultModelEqualityDelegate() : equalityDelegate;
        if (ComposerKt.isTraceInProgress()) {
            ComposerKt.traceEventStart(2032051394, i2, i3, "coil.compose.AsyncImage (AsyncImage.kt:157)");
        }
        int i6 = i2 >> 3;
        m2257AsyncImage76YX9Dk(new AsyncImageState(obj, defaultModelEqualityDelegate, imageLoader), str, modifier2, defaultTransform, function3, center, fit, f2, colorFilter2, i5, z2, composer, (i6 & 234881024) | (i2 & 112) | (i6 & 896) | (i6 & 7168) | (57344 & i6) | (458752 & i6) | (3670016 & i6) | (29360128 & i6) | ((i3 << 27) & 1879048192), (i3 >> 3) & 14);
        if (ComposerKt.isTraceInProgress()) {
            ComposerKt.traceEventEnd();
        }
        composer.endReplaceableGroup();
    }

    @Deprecated(level = DeprecationLevel.HIDDEN, message = "Kept for binary compatibility.")
    public static final void m2259AsyncImageMvsnxeU(Object obj, String str, ImageLoader imageLoader, Modifier modifier, Function1 function1, Function1 function2, Alignment alignment, ContentScale contentScale, float f, ColorFilter colorFilter, int i, Composer composer, int i2, int i3, int i4) throws KotlinNothingValueException {
        composer.startReplaceableGroup(-2030202961);
        Modifier modifier2 = (i4 & 8) != 0 ? (Modifier) Modifier.Companion : modifier;
        Function1 defaultTransform = (i4 & 16) != 0 ? AsyncImagePainter.INSTANCE.getDefaultTransform() : function1;
        Function1 function3 = (i4 & 32) != 0 ? null : function2;
        Alignment center = (i4 & 64) != 0 ? Alignment.Companion.getCenter() : alignment;
        ContentScale fit = (i4 & 128) != 0 ? ContentScale.Companion.getFit() : contentScale;
        float f2 = (i4 & 256) != 0 ? 1.0f : f;
        ColorFilter colorFilter2 = (i4 & 512) != 0 ? null : colorFilter;
        int i5 = (i4 & 1024) != 0 ? DrawScope.Companion.getDefaultFilterQuality-f-v9h1I() : i;
        if (ComposerKt.isTraceInProgress()) {
            ComposerKt.traceEventStart(-2030202961, i2, i3, "coil.compose.AsyncImage (AsyncImage.kt:186)");
        }
        int i6 = i2 >> 3;
        m2257AsyncImage76YX9Dk(new AsyncImageState(obj, EqualityDelegateKt.getDefaultModelEqualityDelegate(), imageLoader), str, modifier2, defaultTransform, function3, center, fit, f2, colorFilter2, i5, true, composer, (i6 & 234881024) | (i2 & 112) | (i6 & 896) | (i6 & 7168) | (57344 & i6) | (458752 & i6) | (3670016 & i6) | (29360128 & i6) | ((i3 << 27) & 1879048192), 6);
        if (ComposerKt.isTraceInProgress()) {
            ComposerKt.traceEventEnd();
        }
        composer.endReplaceableGroup();
    }

    public static final void m2257AsyncImage76YX9Dk(final AsyncImageState asyncImageState, final String str, final Modifier modifier, final Function1<? super AsyncImagePainter.State, ? extends AsyncImagePainter.State> function1, final Function1<? super AsyncImagePainter.State, Unit> function2, final Alignment alignment, final ContentScale contentScale, final float f, final ColorFilter colorFilter, final int i, final boolean z, Composer composer, final int i2, final int i3) throws KotlinNothingValueException {
        int i4;
        int i5;
        Composer composerStartRestartGroup = composer.startRestartGroup(-421592773);
        if ((i2 & 14) == 0) {
            i4 = (composerStartRestartGroup.changed(asyncImageState) ? 4 : 2) | i2;
        } else {
            i4 = i2;
        }
        if ((i2 & 112) == 0) {
            i4 |= composerStartRestartGroup.changed(str) ? 32 : 16;
        }
        if ((i2 & 896) == 0) {
            i4 |= composerStartRestartGroup.changed(modifier) ? 256 : 128;
        }
        if ((i2 & 7168) == 0) {
            i4 |= composerStartRestartGroup.changedInstance(function1) ? 2048 : 1024;
        }
        if ((i2 & 57344) == 0) {
            i4 |= composerStartRestartGroup.changedInstance(function2) ? 16384 : 8192;
        }
        if ((i2 & 458752) == 0) {
            i4 |= composerStartRestartGroup.changed(alignment) ? 131072 : 65536;
        }
        if ((i2 & 3670016) == 0) {
            i4 |= composerStartRestartGroup.changed(contentScale) ? 1048576 : 524288;
        }
        if ((i2 & 29360128) == 0) {
            i4 |= composerStartRestartGroup.changed(f) ? 8388608 : 4194304;
        }
        if ((234881024 & i2) == 0) {
            i4 |= composerStartRestartGroup.changed(colorFilter) ? AccessibilityEventCompat.TYPE_VIEW_TARGETED_BY_SCROLL : 33554432;
        }
        if ((i2 & 1879048192) == 0) {
            i4 |= composerStartRestartGroup.changed(i) ? 536870912 : 268435456;
        }
        if ((i3 & 14) == 0) {
            i5 = i3 | (composerStartRestartGroup.changed(z) ? 4 : 2);
        } else {
            i5 = i3;
        }
        if ((i4 & 1533916891) != 306783378 || (i5 & 11) != 2 || !composerStartRestartGroup.getSkipping()) {
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventStart(-421592773, i4, i5, "coil.compose.AsyncImage (AsyncImage.kt:213)");
            }
            ImageRequest imageRequestRequestOfWithSizeResolver = UtilsKt.requestOfWithSizeResolver(asyncImageState.getModel(), contentScale, composerStartRestartGroup, ((i4 >> 15) & 112) | 8);
            int i6 = i4 >> 3;
            int i7 = (i6 & 896) | 72 | (i6 & 7168);
            int i8 = i4 >> 6;
            int i9 = i8 & 57344;
            int i10 = i5;
            int i11 = i4;
            AsyncImagePainter asyncImagePainterM2269rememberAsyncImagePainter0YpotYA = AsyncImagePainterKt.m2269rememberAsyncImagePainter0YpotYA(imageRequestRequestOfWithSizeResolver, asyncImageState.getImageLoader(), function1, function2, contentScale, i, asyncImageState.getModelEqualityDelegate(), composerStartRestartGroup, i7 | i9 | ((i4 >> 12) & 458752), 0);
            Modifier sizeResolver = imageRequestRequestOfWithSizeResolver.getSizeResolver();
            Content(sizeResolver instanceof ConstraintsSizeResolver ? modifier.then(sizeResolver) : modifier, asyncImagePainterM2269rememberAsyncImagePainter0YpotYA, str, alignment, contentScale, f, colorFilter, z, composerStartRestartGroup, ((i11 << 3) & 896) | (i8 & 7168) | i9 | (i8 & 458752) | (i8 & 3670016) | ((i10 << 21) & 29360128));
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventEnd();
            }
        } else {
            composerStartRestartGroup.skipToGroupEnd();
        }
        ScopeUpdateScope scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
        if (scopeUpdateScopeEndRestartGroup != null) {
            scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                {
                    super(2);
                }

                public Object invoke(Object obj, Object obj2) throws KotlinNothingValueException {
                    invoke((Composer) obj, ((Number) obj2).intValue());
                    return Unit.INSTANCE;
                }

                public final void invoke(Composer composer2, int i12) throws KotlinNothingValueException {
                    AsyncImageKt.m2257AsyncImage76YX9Dk(asyncImageState, str, modifier, function1, function2, alignment, contentScale, f, colorFilter, i, z, composer2, RecomposeScopeImplKt.updateChangedFlags(i2 | 1), RecomposeScopeImplKt.updateChangedFlags(i3));
                }
            });
        }
    }

    public static final void Content(final Modifier modifier, final AsyncImagePainter asyncImagePainter, final String str, final Alignment alignment, final ContentScale contentScale, final float f, final ColorFilter colorFilter, final boolean z, Composer composer, final int i) {
        int i2;
        Composer composerStartRestartGroup = composer.startRestartGroup(777774312);
        if ((i & 14) == 0) {
            i2 = (composerStartRestartGroup.changed(modifier) ? 4 : 2) | i;
        } else {
            i2 = i;
        }
        if ((i & 112) == 0) {
            i2 |= composerStartRestartGroup.changed(asyncImagePainter) ? 32 : 16;
        }
        if ((i & 896) == 0) {
            i2 |= composerStartRestartGroup.changed(str) ? 256 : 128;
        }
        if ((i & 7168) == 0) {
            i2 |= composerStartRestartGroup.changed(alignment) ? 2048 : 1024;
        }
        if ((57344 & i) == 0) {
            i2 |= composerStartRestartGroup.changed(contentScale) ? 16384 : 8192;
        }
        if ((458752 & i) == 0) {
            i2 |= composerStartRestartGroup.changed(f) ? 131072 : 65536;
        }
        if ((3670016 & i) == 0) {
            i2 |= composerStartRestartGroup.changed(colorFilter) ? 1048576 : 524288;
        }
        if ((29360128 & i) == 0) {
            i2 |= composerStartRestartGroup.changed(z) ? 8388608 : 4194304;
        }
        if ((23967451 & i2) != 4793490 || !composerStartRestartGroup.getSkipping()) {
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventStart(777774312, i2, -1, "coil.compose.Content (AsyncImage.kt:259)");
            }
            Modifier modifierContentDescription = UtilsKt.contentDescription(modifier, str);
            if (z) {
                modifierContentDescription = ClipKt.clipToBounds(modifierContentDescription);
            }
            Modifier modifierThen = modifierContentDescription.then(new ContentPainterElement(asyncImagePainter, alignment, contentScale, f, colorFilter));
            C07752 c07752 = new MeasurePolicy() {
                public int maxIntrinsicHeight(IntrinsicMeasureScope intrinsicMeasureScope, List list, int i3) {
                    return MeasurePolicy.-CC.$default$maxIntrinsicHeight(this, intrinsicMeasureScope, list, i3);
                }

                public int maxIntrinsicWidth(IntrinsicMeasureScope intrinsicMeasureScope, List list, int i3) {
                    return MeasurePolicy.-CC.$default$maxIntrinsicWidth(this, intrinsicMeasureScope, list, i3);
                }

                public int minIntrinsicHeight(IntrinsicMeasureScope intrinsicMeasureScope, List list, int i3) {
                    return MeasurePolicy.-CC.$default$minIntrinsicHeight(this, intrinsicMeasureScope, list, i3);
                }

                public int minIntrinsicWidth(IntrinsicMeasureScope intrinsicMeasureScope, List list, int i3) {
                    return MeasurePolicy.-CC.$default$minIntrinsicWidth(this, intrinsicMeasureScope, list, i3);
                }

                public final MeasureResult m2263measure3p2s80s(MeasureScope measureScope, List<? extends Measurable> list, long j) {
                    return MeasureScope.-CC.layout$default(measureScope, Constraints.m1768getMinWidthimpl(j), Constraints.m1767getMinHeightimpl(j), (Map) null, new Function1<Placeable.PlacementScope, Unit>() {
                        public final void invoke(Placeable.PlacementScope placementScope) {
                        }

                        public Object invoke(Object obj) {
                            invoke((Placeable.PlacementScope) obj);
                            return Unit.INSTANCE;
                        }
                    }, 4, (Object) null);
                }
            };
            composerStartRestartGroup.startReplaceableGroup(544976794);
            ComposerKt.sourceInformation(composerStartRestartGroup, "CC(Layout)P(1)123@4784L23,126@4935L385:Layout.kt#80mrfh");
            int currentCompositeKeyHash = ComposablesKt.getCurrentCompositeKeyHash(composerStartRestartGroup, 0);
            Modifier modifierMaterializeModifier = ComposedModifierKt.materializeModifier(composerStartRestartGroup, modifierThen);
            CompositionLocalMap currentCompositionLocalMap = composerStartRestartGroup.getCurrentCompositionLocalMap();
            final Function0 constructor = ComposeUiNode.Companion.getConstructor();
            composerStartRestartGroup.startReplaceableGroup(1405779621);
            ComposerKt.sourceInformation(composerStartRestartGroup, "CC(ReusableComposeNode):Composables.kt#9igjgp");
            if (!(composerStartRestartGroup.getApplier() instanceof Applier)) {
                ComposablesKt.invalidApplier();
            }
            composerStartRestartGroup.startReusableNode();
            if (composerStartRestartGroup.getInserting()) {
                composerStartRestartGroup.createNode(new Function0<ComposeUiNode>() {
                    {
                        super(0);
                    }

                    public final ComposeUiNode invoke() {
                        return constructor.invoke();
                    }
                });
            } else {
                composerStartRestartGroup.useNode();
            }
            Composer composer2 = Updater.constructor-impl(composerStartRestartGroup);
            Updater.set-impl(composer2, c07752, ComposeUiNode.Companion.getSetMeasurePolicy());
            Updater.set-impl(composer2, currentCompositionLocalMap, ComposeUiNode.Companion.getSetResolvedCompositionLocals());
            Updater.set-impl(composer2, modifierMaterializeModifier, ComposeUiNode.Companion.getSetModifier());
            Function2 setCompositeKeyHash = ComposeUiNode.Companion.getSetCompositeKeyHash();
            if (composer2.getInserting() || !Intrinsics.areEqual(composer2.rememberedValue(), Integer.valueOf(currentCompositeKeyHash))) {
                composer2.updateRememberedValue(Integer.valueOf(currentCompositeKeyHash));
                composer2.apply(Integer.valueOf(currentCompositeKeyHash), setCompositeKeyHash);
            }
            composerStartRestartGroup.endNode();
            composerStartRestartGroup.endReplaceableGroup();
            composerStartRestartGroup.endReplaceableGroup();
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventEnd();
            }
        } else {
            composerStartRestartGroup.skipToGroupEnd();
        }
        ScopeUpdateScope scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
        if (scopeUpdateScopeEndRestartGroup != null) {
            scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                {
                    super(2);
                }

                public Object invoke(Object obj, Object obj2) {
                    invoke((Composer) obj, ((Number) obj2).intValue());
                    return Unit.INSTANCE;
                }

                public final void invoke(Composer composer3, int i3) {
                    AsyncImageKt.Content(modifier, asyncImagePainter, str, alignment, contentScale, f, colorFilter, z, composer3, RecomposeScopeImplKt.updateChangedFlags(i | 1));
                }
            });
        }
    }
}
