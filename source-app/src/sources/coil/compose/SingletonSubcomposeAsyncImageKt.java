package coil.compose;

import androidx.compose.runtime.Composer;
import androidx.compose.runtime.ComposerKt;
import androidx.compose.ui.Alignment;
import androidx.compose.ui.Modifier;
import androidx.compose.ui.graphics.ColorFilter;
import androidx.compose.ui.graphics.drawscope.DrawScope;
import androidx.compose.ui.layout.ContentScale;
import androidx.constraintlayout.widget.ConstraintLayout;
import androidx.profileinstaller.ProfileVerifier;
import com.facebook.GraphResponse;
import com.facebook.devicerequests.internal.DeviceRequestsHelper;
import kotlin.Deprecated;
import kotlin.DeprecationLevel;
import kotlin.KotlinNothingValueException;
import kotlin.Metadata;
import kotlin.Unit;
import kotlin.jvm.functions.Function1;
import kotlin.jvm.functions.Function3;
import kotlin.jvm.functions.Function4;

@Metadata(d1 = {"\u0000z\n\u0000\n\u0002\u0010\u0002\n\u0000\n\u0002\u0010\u0000\n\u0000\n\u0002\u0010\u000e\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u0007\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0010\u000b\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\b\u001a°\u0001\u0010\u0000\u001a\u00020\u00012\b\u0010\u0002\u001a\u0004\u0018\u00010\u00032\b\u0010\u0004\u001a\u0004\u0018\u00010\u00052\b\b\u0002\u0010\u0006\u001a\u00020\u00072\u0014\b\u0002\u0010\b\u001a\u000e\u0012\u0004\u0012\u00020\n\u0012\u0004\u0012\u00020\n0\t2\u0016\b\u0002\u0010\u000b\u001a\u0010\u0012\u0004\u0012\u00020\n\u0012\u0004\u0012\u00020\u0001\u0018\u00010\t2\b\b\u0002\u0010\f\u001a\u00020\r2\b\b\u0002\u0010\u000e\u001a\u00020\u000f2\b\b\u0002\u0010\u0010\u001a\u00020\u00112\n\b\u0002\u0010\u0012\u001a\u0004\u0018\u00010\u00132\b\b\u0002\u0010\u0014\u001a\u00020\u00152\u001c\u0010\u0016\u001a\u0018\u0012\u0004\u0012\u00020\u0017\u0012\u0004\u0012\u00020\u00010\t¢\u0006\u0002\b\u0018¢\u0006\u0002\b\u0019H\u0007ø\u0001\u0000¢\u0006\u0004\b\u001a\u0010\u001b\u001aÄ\u0001\u0010\u0000\u001a\u00020\u00012\b\u0010\u0002\u001a\u0004\u0018\u00010\u00032\b\u0010\u0004\u001a\u0004\u0018\u00010\u00052\b\b\u0002\u0010\u0006\u001a\u00020\u00072\u0014\b\u0002\u0010\b\u001a\u000e\u0012\u0004\u0012\u00020\n\u0012\u0004\u0012\u00020\n0\t2\u0016\b\u0002\u0010\u000b\u001a\u0010\u0012\u0004\u0012\u00020\n\u0012\u0004\u0012\u00020\u0001\u0018\u00010\t2\b\b\u0002\u0010\f\u001a\u00020\r2\b\b\u0002\u0010\u000e\u001a\u00020\u000f2\b\b\u0002\u0010\u0010\u001a\u00020\u00112\n\b\u0002\u0010\u0012\u001a\u0004\u0018\u00010\u00132\b\b\u0002\u0010\u0014\u001a\u00020\u00152\b\b\u0002\u0010\u001c\u001a\u00020\u001d2\b\b\u0002\u0010\u001e\u001a\u00020\u001f2\u001c\u0010\u0016\u001a\u0018\u0012\u0004\u0012\u00020\u0017\u0012\u0004\u0012\u00020\u00010\t¢\u0006\u0002\b\u0018¢\u0006\u0002\b\u0019H\u0007ø\u0001\u0000¢\u0006\u0004\b \u0010!\u001aÎ\u0002\u0010\u0000\u001a\u00020\u00012\b\u0010\u0002\u001a\u0004\u0018\u00010\u00032\b\u0010\u0004\u001a\u0004\u0018\u00010\u00052\b\b\u0002\u0010\u0006\u001a\u00020\u00072\u0014\b\u0002\u0010\b\u001a\u000e\u0012\u0004\u0012\u00020\n\u0012\u0004\u0012\u00020\n0\t2&\b\u0002\u0010\"\u001a \u0012\u0004\u0012\u00020\u0017\u0012\u0004\u0012\u00020$\u0012\u0004\u0012\u00020\u0001\u0018\u00010#¢\u0006\u0002\b\u0018¢\u0006\u0002\b\u00192&\b\u0002\u0010%\u001a \u0012\u0004\u0012\u00020\u0017\u0012\u0004\u0012\u00020&\u0012\u0004\u0012\u00020\u0001\u0018\u00010#¢\u0006\u0002\b\u0018¢\u0006\u0002\b\u00192&\b\u0002\u0010'\u001a \u0012\u0004\u0012\u00020\u0017\u0012\u0004\u0012\u00020(\u0012\u0004\u0012\u00020\u0001\u0018\u00010#¢\u0006\u0002\b\u0018¢\u0006\u0002\b\u00192\u0016\b\u0002\u0010)\u001a\u0010\u0012\u0004\u0012\u00020$\u0012\u0004\u0012\u00020\u0001\u0018\u00010\t2\u0016\b\u0002\u0010*\u001a\u0010\u0012\u0004\u0012\u00020&\u0012\u0004\u0012\u00020\u0001\u0018\u00010\t2\u0016\b\u0002\u0010+\u001a\u0010\u0012\u0004\u0012\u00020(\u0012\u0004\u0012\u00020\u0001\u0018\u00010\t2\b\b\u0002\u0010\f\u001a\u00020\r2\b\b\u0002\u0010\u000e\u001a\u00020\u000f2\b\b\u0002\u0010\u0010\u001a\u00020\u00112\n\b\u0002\u0010\u0012\u001a\u0004\u0018\u00010\u00132\b\b\u0002\u0010\u0014\u001a\u00020\u00152\b\b\u0002\u0010\u001c\u001a\u00020\u001d2\b\b\u0002\u0010\u001e\u001a\u00020\u001fH\u0007ø\u0001\u0000¢\u0006\u0004\b,\u0010-\u001a¤\u0002\u0010\u0000\u001a\u00020\u00012\b\u0010\u0002\u001a\u0004\u0018\u00010\u00032\b\u0010\u0004\u001a\u0004\u0018\u00010\u00052\b\b\u0002\u0010\u0006\u001a\u00020\u00072&\b\u0002\u0010\"\u001a \u0012\u0004\u0012\u00020\u0017\u0012\u0004\u0012\u00020$\u0012\u0004\u0012\u00020\u0001\u0018\u00010#¢\u0006\u0002\b\u0018¢\u0006\u0002\b\u00192&\b\u0002\u0010%\u001a \u0012\u0004\u0012\u00020\u0017\u0012\u0004\u0012\u00020&\u0012\u0004\u0012\u00020\u0001\u0018\u00010#¢\u0006\u0002\b\u0018¢\u0006\u0002\b\u00192&\b\u0002\u0010'\u001a \u0012\u0004\u0012\u00020\u0017\u0012\u0004\u0012\u00020(\u0012\u0004\u0012\u00020\u0001\u0018\u00010#¢\u0006\u0002\b\u0018¢\u0006\u0002\b\u00192\u0016\b\u0002\u0010)\u001a\u0010\u0012\u0004\u0012\u00020$\u0012\u0004\u0012\u00020\u0001\u0018\u00010\t2\u0016\b\u0002\u0010*\u001a\u0010\u0012\u0004\u0012\u00020&\u0012\u0004\u0012\u00020\u0001\u0018\u00010\t2\u0016\b\u0002\u0010+\u001a\u0010\u0012\u0004\u0012\u00020(\u0012\u0004\u0012\u00020\u0001\u0018\u00010\t2\b\b\u0002\u0010\f\u001a\u00020\r2\b\b\u0002\u0010\u000e\u001a\u00020\u000f2\b\b\u0002\u0010\u0010\u001a\u00020\u00112\n\b\u0002\u0010\u0012\u001a\u0004\u0018\u00010\u00132\b\b\u0002\u0010\u0014\u001a\u00020\u0015H\u0007ø\u0001\u0000¢\u0006\u0004\b.\u0010/\u0082\u0002\u0007\n\u0005\b¡\u001e0\u0001¨\u00060"}, d2 = {"SubcomposeAsyncImage", "", DeviceRequestsHelper.DEVICE_INFO_MODEL, "", "contentDescription", "", "modifier", "Landroidx/compose/ui/Modifier;", "transform", "Lkotlin/Function1;", "Lcoil/compose/AsyncImagePainter$State;", "onState", "alignment", "Landroidx/compose/ui/Alignment;", "contentScale", "Landroidx/compose/ui/layout/ContentScale;", "alpha", "", "colorFilter", "Landroidx/compose/ui/graphics/ColorFilter;", "filterQuality", "Landroidx/compose/ui/graphics/FilterQuality;", "content", "Lcoil/compose/SubcomposeAsyncImageScope;", "Landroidx/compose/runtime/Composable;", "Lkotlin/ExtensionFunctionType;", "SubcomposeAsyncImage-10Xjiaw", "(Ljava/lang/Object;Ljava/lang/String;Landroidx/compose/ui/Modifier;Lkotlin/jvm/functions/Function1;Lkotlin/jvm/functions/Function1;Landroidx/compose/ui/Alignment;Landroidx/compose/ui/layout/ContentScale;FLandroidx/compose/ui/graphics/ColorFilter;ILkotlin/jvm/functions/Function3;Landroidx/compose/runtime/Composer;III)V", "clipToBounds", "", "modelEqualityDelegate", "Lcoil/compose/EqualityDelegate;", "SubcomposeAsyncImage-OsCPg7o", "(Ljava/lang/Object;Ljava/lang/String;Landroidx/compose/ui/Modifier;Lkotlin/jvm/functions/Function1;Lkotlin/jvm/functions/Function1;Landroidx/compose/ui/Alignment;Landroidx/compose/ui/layout/ContentScale;FLandroidx/compose/ui/graphics/ColorFilter;IZLcoil/compose/EqualityDelegate;Lkotlin/jvm/functions/Function3;Landroidx/compose/runtime/Composer;III)V", "loading", "Lkotlin/Function2;", "Lcoil/compose/AsyncImagePainter$State$Loading;", GraphResponse.SUCCESS_KEY, "Lcoil/compose/AsyncImagePainter$State$Success;", "error", "Lcoil/compose/AsyncImagePainter$State$Error;", "onLoading", "onSuccess", "onError", "SubcomposeAsyncImage-J-FEaFM", "(Ljava/lang/Object;Ljava/lang/String;Landroidx/compose/ui/Modifier;Lkotlin/jvm/functions/Function1;Lkotlin/jvm/functions/Function4;Lkotlin/jvm/functions/Function4;Lkotlin/jvm/functions/Function4;Lkotlin/jvm/functions/Function1;Lkotlin/jvm/functions/Function1;Lkotlin/jvm/functions/Function1;Landroidx/compose/ui/Alignment;Landroidx/compose/ui/layout/ContentScale;FLandroidx/compose/ui/graphics/ColorFilter;IZLcoil/compose/EqualityDelegate;Landroidx/compose/runtime/Composer;III)V", "SubcomposeAsyncImage-ylYTKUw", "(Ljava/lang/Object;Ljava/lang/String;Landroidx/compose/ui/Modifier;Lkotlin/jvm/functions/Function4;Lkotlin/jvm/functions/Function4;Lkotlin/jvm/functions/Function4;Lkotlin/jvm/functions/Function1;Lkotlin/jvm/functions/Function1;Lkotlin/jvm/functions/Function1;Landroidx/compose/ui/Alignment;Landroidx/compose/ui/layout/ContentScale;FLandroidx/compose/ui/graphics/ColorFilter;ILandroidx/compose/runtime/Composer;III)V", "coil-compose-singleton_release"}, k = 2, mv = {1, 9, 0}, xi = ConstraintLayout.LayoutParams.Table.LAYOUT_CONSTRAINT_VERTICAL_CHAINSTYLE)
public final class SingletonSubcomposeAsyncImageKt {
    public static final void m2305SubcomposeAsyncImageJFEaFM(Object obj, String str, Modifier modifier, Function1<? super AsyncImagePainter.State, ? extends AsyncImagePainter.State> function1, Function4<? super SubcomposeAsyncImageScope, ? super AsyncImagePainter.State.Loading, ? super Composer, ? super Integer, Unit> function4, Function4<? super SubcomposeAsyncImageScope, ? super AsyncImagePainter.State.Success, ? super Composer, ? super Integer, Unit> function5, Function4<? super SubcomposeAsyncImageScope, ? super AsyncImagePainter.State.Error, ? super Composer, ? super Integer, Unit> function6, Function1<? super AsyncImagePainter.State.Loading, Unit> function2, Function1<? super AsyncImagePainter.State.Success, Unit> function3, Function1<? super AsyncImagePainter.State.Error, Unit> function7, Alignment alignment, ContentScale contentScale, float f, ColorFilter colorFilter, int i, boolean z, EqualityDelegate equalityDelegate, Composer composer, int i2, int i3, int i4) throws KotlinNothingValueException {
        composer.startReplaceableGroup(1925822313);
        Modifier modifier2 = (i4 & 4) != 0 ? (Modifier) Modifier.Companion : modifier;
        Function1<? super AsyncImagePainter.State, ? extends AsyncImagePainter.State> defaultTransform = (i4 & 8) != 0 ? AsyncImagePainter.INSTANCE.getDefaultTransform() : function1;
        Function4<? super SubcomposeAsyncImageScope, ? super AsyncImagePainter.State.Loading, ? super Composer, ? super Integer, Unit> function8 = (i4 & 16) != 0 ? null : function4;
        Function4<? super SubcomposeAsyncImageScope, ? super AsyncImagePainter.State.Success, ? super Composer, ? super Integer, Unit> function9 = (i4 & 32) != 0 ? null : function5;
        Function4<? super SubcomposeAsyncImageScope, ? super AsyncImagePainter.State.Error, ? super Composer, ? super Integer, Unit> function10 = (i4 & 64) != 0 ? null : function6;
        Function1<? super AsyncImagePainter.State.Loading, Unit> function11 = (i4 & 128) != 0 ? null : function2;
        Function1<? super AsyncImagePainter.State.Success, Unit> function12 = (i4 & 256) != 0 ? null : function3;
        Function1<? super AsyncImagePainter.State.Error, Unit> function13 = (i4 & 512) != 0 ? null : function7;
        Alignment center = (i4 & 1024) != 0 ? Alignment.Companion.getCenter() : alignment;
        ContentScale fit = (i4 & 2048) != 0 ? ContentScale.Companion.getFit() : contentScale;
        float f2 = (i4 & 4096) != 0 ? 1.0f : f;
        ColorFilter colorFilter2 = (i4 & 8192) != 0 ? null : colorFilter;
        int i5 = (i4 & 16384) != 0 ? DrawScope.Companion.getDefaultFilterQuality-f-v9h1I() : i;
        boolean z2 = (32768 & i4) != 0 ? true : z;
        EqualityDelegate defaultModelEqualityDelegate = (i4 & 65536) != 0 ? EqualityDelegateKt.getDefaultModelEqualityDelegate() : equalityDelegate;
        if (ComposerKt.isTraceInProgress()) {
            ComposerKt.traceEventStart(1925822313, i2, i3, "coil.compose.SubcomposeAsyncImage (SingletonSubcomposeAsyncImage.kt:66)");
        }
        int i6 = i2 << 3;
        int i7 = i3 << 3;
        SubcomposeAsyncImageKt.m2310SubcomposeAsyncImageTCQMD7g(obj, str, ImageLoaderProvidableCompositionLocal.getCurrent(LocalImageLoaderKt.getLocalImageLoader(), composer, 6), modifier2, defaultTransform, function8, function9, function10, function11, function12, function13, center, fit, f2, colorFilter2, i5, z2, defaultModelEqualityDelegate, composer, (i2 & 112) | 520 | (i6 & 7168) | (i6 & 57344) | (i6 & 458752) | (i6 & 3670016) | (i6 & 29360128) | (i6 & 234881024) | (i6 & 1879048192), ((i2 >> 27) & 14) | (i7 & 112) | (i7 & 896) | (i7 & 7168) | (i7 & 57344) | (i7 & 458752) | (i7 & 3670016) | (i7 & 29360128), 0);
        if (ComposerKt.isTraceInProgress()) {
            ComposerKt.traceEventEnd();
        }
        composer.endReplaceableGroup();
    }

    @Deprecated(level = DeprecationLevel.HIDDEN, message = "Kept for binary compatibility.")
    public static final void m2307SubcomposeAsyncImageylYTKUw(Object obj, String str, Modifier modifier, Function4 function4, Function4 function5, Function4 function6, Function1 function1, Function1 function2, Function1 function3, Alignment alignment, ContentScale contentScale, float f, ColorFilter colorFilter, int i, Composer composer, int i2, int i3, int i4) throws KotlinNothingValueException {
        composer.startReplaceableGroup(1047090393);
        Modifier modifier2 = (i4 & 4) != 0 ? (Modifier) Modifier.Companion : modifier;
        Function4 function7 = (i4 & 8) != 0 ? null : function4;
        Function4 function8 = (i4 & 16) != 0 ? null : function5;
        Function4 function9 = (i4 & 32) != 0 ? null : function6;
        Function1 function10 = (i4 & 64) != 0 ? null : function1;
        Function1 function11 = (i4 & 128) != 0 ? null : function2;
        Function1 function12 = (i4 & 256) != 0 ? null : function3;
        Alignment center = (i4 & 512) != 0 ? Alignment.Companion.getCenter() : alignment;
        ContentScale fit = (i4 & 1024) != 0 ? ContentScale.Companion.getFit() : contentScale;
        float f2 = (i4 & 2048) != 0 ? 1.0f : f;
        ColorFilter colorFilter2 = (i4 & 4096) != 0 ? null : colorFilter;
        int i5 = (i4 & 8192) != 0 ? DrawScope.Companion.getDefaultFilterQuality-f-v9h1I() : i;
        if (ComposerKt.isTraceInProgress()) {
            ComposerKt.traceEventStart(1047090393, i2, i3, "coil.compose.SubcomposeAsyncImage (SingletonSubcomposeAsyncImage.kt:105)");
        }
        int i6 = i2 << 6;
        int i7 = i3 << 6;
        SubcomposeAsyncImageKt.m2310SubcomposeAsyncImageTCQMD7g(obj, str, ImageLoaderProvidableCompositionLocal.getCurrent(LocalImageLoaderKt.getLocalImageLoader(), composer, 6), modifier2, AsyncImagePainter.INSTANCE.getDefaultTransform(), function7, function8, function9, function10, function11, function12, center, fit, f2, colorFilter2, i5, false, null, composer, ((i2 << 3) & 7168) | (i2 & 112) | 520 | (i6 & 458752) | (i6 & 3670016) | (i6 & 29360128) | (i6 & 234881024) | (i6 & 1879048192), ((i2 >> 24) & 126) | (i7 & 896) | (i7 & 7168) | (57344 & i7) | (i7 & 458752), ProfileVerifier.CompilationStatus.f97xf2722a21);
        if (ComposerKt.isTraceInProgress()) {
            ComposerKt.traceEventEnd();
        }
        composer.endReplaceableGroup();
    }

    public static final void m2306SubcomposeAsyncImageOsCPg7o(Object obj, String str, Modifier modifier, Function1<? super AsyncImagePainter.State, ? extends AsyncImagePainter.State> function1, Function1<? super AsyncImagePainter.State, Unit> function2, Alignment alignment, ContentScale contentScale, float f, ColorFilter colorFilter, int i, boolean z, EqualityDelegate equalityDelegate, Function3<? super SubcomposeAsyncImageScope, ? super Composer, ? super Integer, Unit> function3, Composer composer, int i2, int i3, int i4) throws KotlinNothingValueException {
        composer.startReplaceableGroup(241832818);
        Modifier modifier2 = (i4 & 4) != 0 ? (Modifier) Modifier.Companion : modifier;
        Function1<? super AsyncImagePainter.State, ? extends AsyncImagePainter.State> defaultTransform = (i4 & 8) != 0 ? AsyncImagePainter.INSTANCE.getDefaultTransform() : function1;
        Function1<? super AsyncImagePainter.State, Unit> function4 = (i4 & 16) != 0 ? null : function2;
        Alignment center = (i4 & 32) != 0 ? Alignment.Companion.getCenter() : alignment;
        ContentScale fit = (i4 & 64) != 0 ? ContentScale.Companion.getFit() : contentScale;
        float f2 = (i4 & 128) != 0 ? 1.0f : f;
        ColorFilter colorFilter2 = (i4 & 256) != 0 ? null : colorFilter;
        int i5 = (i4 & 512) != 0 ? DrawScope.Companion.getDefaultFilterQuality-f-v9h1I() : i;
        boolean z2 = (i4 & 1024) != 0 ? true : z;
        EqualityDelegate defaultModelEqualityDelegate = (i4 & 2048) != 0 ? EqualityDelegateKt.getDefaultModelEqualityDelegate() : equalityDelegate;
        if (ComposerKt.isTraceInProgress()) {
            ComposerKt.traceEventStart(241832818, i2, i3, "coil.compose.SubcomposeAsyncImage (SingletonSubcomposeAsyncImage.kt:166)");
        }
        int i6 = i2 << 3;
        int i7 = i3 << 3;
        SubcomposeAsyncImageKt.m2308SubcomposeAsyncImageFSyRiR8(obj, str, ImageLoaderProvidableCompositionLocal.getCurrent(LocalImageLoaderKt.getLocalImageLoader(), composer, 6), modifier2, defaultTransform, function4, center, fit, f2, colorFilter2, i5, z2, defaultModelEqualityDelegate, function3, composer, (i2 & 112) | 520 | (i6 & 7168) | (57344 & i6) | (458752 & i6) | (3670016 & i6) | (29360128 & i6) | (234881024 & i6) | (i6 & 1879048192), ((i2 >> 27) & 14) | (i7 & 112) | (i7 & 896) | (i7 & 7168), 0);
        if (ComposerKt.isTraceInProgress()) {
            ComposerKt.traceEventEnd();
        }
        composer.endReplaceableGroup();
    }

    @Deprecated(level = DeprecationLevel.HIDDEN, message = "Kept for binary compatibility.")
    public static final void m2304SubcomposeAsyncImage10Xjiaw(Object obj, String str, Modifier modifier, Function1 function1, Function1 function2, Alignment alignment, ContentScale contentScale, float f, ColorFilter colorFilter, int i, Function3 function3, Composer composer, int i2, int i3, int i4) throws KotlinNothingValueException {
        composer.startReplaceableGroup(1571662781);
        Modifier modifier2 = (i4 & 4) != 0 ? (Modifier) Modifier.Companion : modifier;
        Function1 defaultTransform = (i4 & 8) != 0 ? AsyncImagePainter.INSTANCE.getDefaultTransform() : function1;
        Function1 function4 = (i4 & 16) != 0 ? null : function2;
        Alignment center = (i4 & 32) != 0 ? Alignment.Companion.getCenter() : alignment;
        ContentScale fit = (i4 & 64) != 0 ? ContentScale.Companion.getFit() : contentScale;
        float f2 = (i4 & 128) != 0 ? 1.0f : f;
        ColorFilter colorFilter2 = (i4 & 256) != 0 ? null : colorFilter;
        int i5 = (i4 & 512) != 0 ? DrawScope.Companion.getDefaultFilterQuality-f-v9h1I() : i;
        if (ComposerKt.isTraceInProgress()) {
            ComposerKt.traceEventStart(1571662781, i2, i3, "coil.compose.SubcomposeAsyncImage (SingletonSubcomposeAsyncImage.kt:198)");
        }
        int i6 = i2 << 3;
        SubcomposeAsyncImageKt.m2308SubcomposeAsyncImageFSyRiR8(obj, str, ImageLoaderProvidableCompositionLocal.getCurrent(LocalImageLoaderKt.getLocalImageLoader(), composer, 6), modifier2, defaultTransform, function4, center, fit, f2, colorFilter2, i5, false, null, function3, composer, (i2 & 112) | 520 | (i6 & 7168) | (57344 & i6) | (458752 & i6) | (3670016 & i6) | (29360128 & i6) | (234881024 & i6) | (i6 & 1879048192), ((i2 >> 27) & 14) | ((i3 << 9) & 7168), 6144);
        if (ComposerKt.isTraceInProgress()) {
            ComposerKt.traceEventEnd();
        }
        composer.endReplaceableGroup();
    }
}
