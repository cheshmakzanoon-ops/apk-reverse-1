package coil.compose;

import androidx.compose.runtime.Composer;
import androidx.compose.runtime.ComposerKt;
import androidx.compose.ui.graphics.drawscope.DrawScope;
import androidx.compose.ui.graphics.painter.Painter;
import androidx.compose.ui.layout.ContentScale;
import androidx.constraintlayout.widget.ConstraintLayout;
import com.facebook.devicerequests.internal.DeviceRequestsHelper;
import kotlin.Deprecated;
import kotlin.DeprecationLevel;
import kotlin.KotlinNothingValueException;
import kotlin.Metadata;
import kotlin.Unit;
import kotlin.jvm.functions.Function1;

@Metadata(d1 = {"\u0000P\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u0000\n\u0000\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0005\u001a^\u0010\u0000\u001a\u00020\u00012\b\u0010\u0002\u001a\u0004\u0018\u00010\u00032\u0014\b\u0002\u0010\u0004\u001a\u000e\u0012\u0004\u0012\u00020\u0006\u0012\u0004\u0012\u00020\u00060\u00052\u0016\b\u0002\u0010\u0007\u001a\u0010\u0012\u0004\u0012\u00020\u0006\u0012\u0004\u0012\u00020\b\u0018\u00010\u00052\b\b\u0002\u0010\t\u001a\u00020\n2\b\b\u0002\u0010\u000b\u001a\u00020\fH\u0007ø\u0001\u0000¢\u0006\u0004\b\r\u0010\u000e\u001ah\u0010\u0000\u001a\u00020\u00012\b\u0010\u0002\u001a\u0004\u0018\u00010\u00032\u0014\b\u0002\u0010\u0004\u001a\u000e\u0012\u0004\u0012\u00020\u0006\u0012\u0004\u0012\u00020\u00060\u00052\u0016\b\u0002\u0010\u0007\u001a\u0010\u0012\u0004\u0012\u00020\u0006\u0012\u0004\u0012\u00020\b\u0018\u00010\u00052\b\b\u0002\u0010\t\u001a\u00020\n2\b\b\u0002\u0010\u000b\u001a\u00020\f2\b\b\u0002\u0010\u000f\u001a\u00020\u0010H\u0007ø\u0001\u0000¢\u0006\u0004\b\u0011\u0010\u0012\u001a\u009c\u0001\u0010\u0000\u001a\u00020\u00012\b\u0010\u0002\u001a\u0004\u0018\u00010\u00032\n\b\u0002\u0010\u0013\u001a\u0004\u0018\u00010\u00142\n\b\u0002\u0010\u0015\u001a\u0004\u0018\u00010\u00142\n\b\u0002\u0010\u0016\u001a\u0004\u0018\u00010\u00142\u0016\b\u0002\u0010\u0017\u001a\u0010\u0012\u0004\u0012\u00020\u0018\u0012\u0004\u0012\u00020\b\u0018\u00010\u00052\u0016\b\u0002\u0010\u0019\u001a\u0010\u0012\u0004\u0012\u00020\u001a\u0012\u0004\u0012\u00020\b\u0018\u00010\u00052\u0016\b\u0002\u0010\u001b\u001a\u0010\u0012\u0004\u0012\u00020\u001c\u0012\u0004\u0012\u00020\b\u0018\u00010\u00052\b\b\u0002\u0010\t\u001a\u00020\n2\b\b\u0002\u0010\u000b\u001a\u00020\fH\u0007ø\u0001\u0000¢\u0006\u0004\b\u001d\u0010\u001e\u001a¦\u0001\u0010\u0000\u001a\u00020\u00012\b\u0010\u0002\u001a\u0004\u0018\u00010\u00032\n\b\u0002\u0010\u0013\u001a\u0004\u0018\u00010\u00142\n\b\u0002\u0010\u0015\u001a\u0004\u0018\u00010\u00142\n\b\u0002\u0010\u0016\u001a\u0004\u0018\u00010\u00142\u0016\b\u0002\u0010\u0017\u001a\u0010\u0012\u0004\u0012\u00020\u0018\u0012\u0004\u0012\u00020\b\u0018\u00010\u00052\u0016\b\u0002\u0010\u0019\u001a\u0010\u0012\u0004\u0012\u00020\u001a\u0012\u0004\u0012\u00020\b\u0018\u00010\u00052\u0016\b\u0002\u0010\u001b\u001a\u0010\u0012\u0004\u0012\u00020\u001c\u0012\u0004\u0012\u00020\b\u0018\u00010\u00052\b\b\u0002\u0010\t\u001a\u00020\n2\b\b\u0002\u0010\u000b\u001a\u00020\f2\b\b\u0002\u0010\u000f\u001a\u00020\u0010H\u0007ø\u0001\u0000¢\u0006\u0004\b\u001f\u0010 \u0082\u0002\u0007\n\u0005\b¡\u001e0\u0001¨\u0006!"}, d2 = {"rememberAsyncImagePainter", "Lcoil/compose/AsyncImagePainter;", DeviceRequestsHelper.DEVICE_INFO_MODEL, "", "transform", "Lkotlin/Function1;", "Lcoil/compose/AsyncImagePainter$State;", "onState", "", "contentScale", "Landroidx/compose/ui/layout/ContentScale;", "filterQuality", "Landroidx/compose/ui/graphics/FilterQuality;", "rememberAsyncImagePainter-19ie5dc", "(Ljava/lang/Object;Lkotlin/jvm/functions/Function1;Lkotlin/jvm/functions/Function1;Landroidx/compose/ui/layout/ContentScale;ILandroidx/compose/runtime/Composer;II)Lcoil/compose/AsyncImagePainter;", "modelEqualityDelegate", "Lcoil/compose/EqualityDelegate;", "rememberAsyncImagePainter-EHKIwbg", "(Ljava/lang/Object;Lkotlin/jvm/functions/Function1;Lkotlin/jvm/functions/Function1;Landroidx/compose/ui/layout/ContentScale;ILcoil/compose/EqualityDelegate;Landroidx/compose/runtime/Composer;II)Lcoil/compose/AsyncImagePainter;", "placeholder", "Landroidx/compose/ui/graphics/painter/Painter;", "error", "fallback", "onLoading", "Lcoil/compose/AsyncImagePainter$State$Loading;", "onSuccess", "Lcoil/compose/AsyncImagePainter$State$Success;", "onError", "Lcoil/compose/AsyncImagePainter$State$Error;", "rememberAsyncImagePainter-MqR-F_0", "(Ljava/lang/Object;Landroidx/compose/ui/graphics/painter/Painter;Landroidx/compose/ui/graphics/painter/Painter;Landroidx/compose/ui/graphics/painter/Painter;Lkotlin/jvm/functions/Function1;Lkotlin/jvm/functions/Function1;Lkotlin/jvm/functions/Function1;Landroidx/compose/ui/layout/ContentScale;ILandroidx/compose/runtime/Composer;II)Lcoil/compose/AsyncImagePainter;", "rememberAsyncImagePainter-HtA5bXE", "(Ljava/lang/Object;Landroidx/compose/ui/graphics/painter/Painter;Landroidx/compose/ui/graphics/painter/Painter;Landroidx/compose/ui/graphics/painter/Painter;Lkotlin/jvm/functions/Function1;Lkotlin/jvm/functions/Function1;Lkotlin/jvm/functions/Function1;Landroidx/compose/ui/layout/ContentScale;ILcoil/compose/EqualityDelegate;Landroidx/compose/runtime/Composer;II)Lcoil/compose/AsyncImagePainter;", "coil-compose-singleton_release"}, k = 2, mv = {1, 9, 0}, xi = ConstraintLayout.LayoutParams.Table.LAYOUT_CONSTRAINT_VERTICAL_CHAINSTYLE)
public final class SingletonAsyncImagePainterKt {
    public static final AsyncImagePainter m2302rememberAsyncImagePainterHtA5bXE(Object obj, Painter painter, Painter painter2, Painter painter3, Function1<? super AsyncImagePainter.State.Loading, Unit> function1, Function1<? super AsyncImagePainter.State.Success, Unit> function2, Function1<? super AsyncImagePainter.State.Error, Unit> function3, ContentScale contentScale, int i, EqualityDelegate equalityDelegate, Composer composer, int i2, int i3) throws KotlinNothingValueException {
        composer.startReplaceableGroup(1445305568);
        Painter painter4 = (i3 & 2) != 0 ? null : painter;
        Painter painter5 = (i3 & 4) != 0 ? null : painter2;
        Painter painter6 = (i3 & 8) != 0 ? painter5 : painter3;
        Function1<? super AsyncImagePainter.State.Loading, Unit> function4 = (i3 & 16) != 0 ? null : function1;
        Function1<? super AsyncImagePainter.State.Success, Unit> function5 = (i3 & 32) != 0 ? null : function2;
        Function1<? super AsyncImagePainter.State.Error, Unit> function6 = (i3 & 64) != 0 ? null : function3;
        ContentScale fit = (i3 & 128) != 0 ? ContentScale.Companion.getFit() : contentScale;
        int i4 = (i3 & 256) != 0 ? DrawScope.Companion.getDefaultFilterQuality-f-v9h1I() : i;
        EqualityDelegate defaultModelEqualityDelegate = (i3 & 512) != 0 ? EqualityDelegateKt.getDefaultModelEqualityDelegate() : equalityDelegate;
        if (ComposerKt.isTraceInProgress()) {
            ComposerKt.traceEventStart(1445305568, i2, -1, "coil.compose.rememberAsyncImagePainter (SingletonAsyncImagePainter.kt:59)");
        }
        int i5 = i2 << 3;
        AsyncImagePainter asyncImagePainterM2270rememberAsyncImagePainter10Xjiaw = AsyncImagePainterKt.m2270rememberAsyncImagePainter10Xjiaw(obj, ImageLoaderProvidableCompositionLocal.getCurrent(LocalImageLoaderKt.getLocalImageLoader(), composer, 6), painter4, painter5, painter6, function4, function5, function6, fit, i4, defaultModelEqualityDelegate, composer, (458752 & i5) | 37448 | (3670016 & i5) | (29360128 & i5) | (234881024 & i5) | (i5 & 1879048192), (i2 >> 27) & 14, 0);
        if (ComposerKt.isTraceInProgress()) {
            ComposerKt.traceEventEnd();
        }
        composer.endReplaceableGroup();
        return asyncImagePainterM2270rememberAsyncImagePainter10Xjiaw;
    }

    @Deprecated(level = DeprecationLevel.HIDDEN, message = "Kept for binary compatibility.")
    public static final AsyncImagePainter m2303rememberAsyncImagePainterMqRF_0(Object obj, Painter painter, Painter painter2, Painter painter3, Function1 function1, Function1 function2, Function1 function3, ContentScale contentScale, int i, Composer composer, int i2, int i3) throws KotlinNothingValueException {
        composer.startReplaceableGroup(533921043);
        Painter painter4 = (i3 & 2) != 0 ? null : painter;
        Painter painter5 = (i3 & 4) != 0 ? null : painter2;
        Painter painter6 = (i3 & 8) != 0 ? painter5 : painter3;
        Function1 function4 = (i3 & 16) != 0 ? null : function1;
        Function1 function5 = (i3 & 32) != 0 ? null : function2;
        Function1 function6 = (i3 & 64) != 0 ? null : function3;
        ContentScale fit = (i3 & 128) != 0 ? ContentScale.Companion.getFit() : contentScale;
        int i4 = (i3 & 256) != 0 ? DrawScope.Companion.getDefaultFilterQuality-f-v9h1I() : i;
        if (ComposerKt.isTraceInProgress()) {
            ComposerKt.traceEventStart(533921043, i2, -1, "coil.compose.rememberAsyncImagePainter (SingletonAsyncImagePainter.kt:86)");
        }
        int i5 = i2 << 3;
        AsyncImagePainter asyncImagePainterM2270rememberAsyncImagePainter10Xjiaw = AsyncImagePainterKt.m2270rememberAsyncImagePainter10Xjiaw(obj, ImageLoaderProvidableCompositionLocal.getCurrent(LocalImageLoaderKt.getLocalImageLoader(), composer, 6), painter4, painter5, painter6, function4, function5, function6, fit, i4, null, composer, (458752 & i5) | 37448 | (3670016 & i5) | (29360128 & i5) | (234881024 & i5) | (i5 & 1879048192), 0, 1024);
        if (ComposerKt.isTraceInProgress()) {
            ComposerKt.traceEventEnd();
        }
        composer.endReplaceableGroup();
        return asyncImagePainterM2270rememberAsyncImagePainter10Xjiaw;
    }

    public static final AsyncImagePainter m2301rememberAsyncImagePainterEHKIwbg(Object obj, Function1<? super AsyncImagePainter.State, ? extends AsyncImagePainter.State> function1, Function1<? super AsyncImagePainter.State, Unit> function2, ContentScale contentScale, int i, EqualityDelegate equalityDelegate, Composer composer, int i2, int i3) throws KotlinNothingValueException {
        composer.startReplaceableGroup(236159766);
        Function1<? super AsyncImagePainter.State, ? extends AsyncImagePainter.State> defaultTransform = (i3 & 2) != 0 ? AsyncImagePainter.INSTANCE.getDefaultTransform() : function1;
        Function1<? super AsyncImagePainter.State, Unit> function3 = (i3 & 4) != 0 ? null : function2;
        ContentScale fit = (i3 & 8) != 0 ? ContentScale.Companion.getFit() : contentScale;
        int i4 = (i3 & 16) != 0 ? DrawScope.Companion.getDefaultFilterQuality-f-v9h1I() : i;
        EqualityDelegate defaultModelEqualityDelegate = (i3 & 32) != 0 ? EqualityDelegateKt.getDefaultModelEqualityDelegate() : equalityDelegate;
        if (ComposerKt.isTraceInProgress()) {
            ComposerKt.traceEventStart(236159766, i2, -1, "coil.compose.rememberAsyncImagePainter (SingletonAsyncImagePainter.kt:133)");
        }
        int i5 = i2 << 3;
        AsyncImagePainter asyncImagePainterM2269rememberAsyncImagePainter0YpotYA = AsyncImagePainterKt.m2269rememberAsyncImagePainter0YpotYA(obj, ImageLoaderProvidableCompositionLocal.getCurrent(LocalImageLoaderKt.getLocalImageLoader(), composer, 6), defaultTransform, function3, fit, i4, defaultModelEqualityDelegate, composer, (i5 & 896) | 72 | (i5 & 7168) | (57344 & i5) | (458752 & i5) | (i5 & 3670016), 0);
        if (ComposerKt.isTraceInProgress()) {
            ComposerKt.traceEventEnd();
        }
        composer.endReplaceableGroup();
        return asyncImagePainterM2269rememberAsyncImagePainter0YpotYA;
    }

    @Deprecated(level = DeprecationLevel.HIDDEN, message = "Kept for binary compatibility.")
    public static final AsyncImagePainter m2300rememberAsyncImagePainter19ie5dc(Object obj, Function1 function1, Function1 function2, ContentScale contentScale, int i, Composer composer, int i2, int i3) throws KotlinNothingValueException {
        composer.startReplaceableGroup(-1494234083);
        Function1 defaultTransform = (i3 & 2) != 0 ? AsyncImagePainter.INSTANCE.getDefaultTransform() : function1;
        Function1 function3 = (i3 & 4) != 0 ? null : function2;
        ContentScale fit = (i3 & 8) != 0 ? ContentScale.Companion.getFit() : contentScale;
        int i4 = (i3 & 16) != 0 ? DrawScope.Companion.getDefaultFilterQuality-f-v9h1I() : i;
        if (ComposerKt.isTraceInProgress()) {
            ComposerKt.traceEventStart(-1494234083, i2, -1, "coil.compose.rememberAsyncImagePainter (SingletonAsyncImagePainter.kt:152)");
        }
        int i5 = i2 << 3;
        AsyncImagePainter asyncImagePainterM2269rememberAsyncImagePainter0YpotYA = AsyncImagePainterKt.m2269rememberAsyncImagePainter0YpotYA(obj, ImageLoaderProvidableCompositionLocal.getCurrent(LocalImageLoaderKt.getLocalImageLoader(), composer, 6), defaultTransform, function3, fit, i4, null, composer, (i5 & 896) | 72 | (i5 & 7168) | (57344 & i5) | (i5 & 458752), 64);
        if (ComposerKt.isTraceInProgress()) {
            ComposerKt.traceEventEnd();
        }
        composer.endReplaceableGroup();
        return asyncImagePainterM2269rememberAsyncImagePainter0YpotYA;
    }
}
