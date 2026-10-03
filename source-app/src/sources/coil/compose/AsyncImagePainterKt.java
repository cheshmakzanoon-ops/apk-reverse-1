package coil.compose;

import android.graphics.drawable.Drawable;
import android.view.View;
import androidx.compose.runtime.Composer;
import androidx.compose.runtime.ComposerKt;
import androidx.compose.runtime.CompositionLocal;
import androidx.compose.ui.graphics.ImageBitmap;
import androidx.compose.ui.graphics.drawscope.DrawScope;
import androidx.compose.ui.graphics.painter.Painter;
import androidx.compose.ui.graphics.vector.ImageVector;
import androidx.compose.ui.layout.ContentScale;
import androidx.compose.ui.platform.InspectionModeKt;
import androidx.constraintlayout.widget.ConstraintLayout;
import coil.ImageLoader;
import coil.request.ImageRequest;
import coil.size.Dimension;
import coil.size.Dimensions;
import coil.size.Size;
import coil.target.Target;
import coil.transition.TransitionTarget;
import com.facebook.devicerequests.internal.DeviceRequestsHelper;
import com.facebook.internal.ServerProtocol;
import kotlin.Deprecated;
import kotlin.DeprecationLevel;
import kotlin.KotlinNothingValueException;
import kotlin.Metadata;
import kotlin.Unit;
import kotlin.jvm.functions.Function1;
import kotlin.math.MathKt;

@Metadata(d1 = {"\u0000\u0085\u0001\n\u0000\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0010\u0000\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0005\n\u0002\u0010\u0001\n\u0000\n\u0002\u0010\u000e\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0003*\u0001\u0001\u001aT\u0010\u0003\u001a\u00020\u00042\u0006\u0010\u0005\u001a\u00020\u00062\u0012\u0010\u0007\u001a\u000e\u0012\u0004\u0012\u00020\t\u0012\u0004\u0012\u00020\t0\b2\u0014\u0010\n\u001a\u0010\u0012\u0004\u0012\u00020\t\u0012\u0004\u0012\u00020\u000b\u0018\u00010\b2\u0006\u0010\f\u001a\u00020\r2\u0006\u0010\u000e\u001a\u00020\u000fH\u0003ø\u0001\u0000¢\u0006\u0004\b\u0010\u0010\u0011\u001af\u0010\u0003\u001a\u00020\u00042\b\u0010\u0012\u001a\u0004\u0018\u00010\u00132\u0006\u0010\u0014\u001a\u00020\u00152\u0014\b\u0002\u0010\u0007\u001a\u000e\u0012\u0004\u0012\u00020\t\u0012\u0004\u0012\u00020\t0\b2\u0016\b\u0002\u0010\n\u001a\u0010\u0012\u0004\u0012\u00020\t\u0012\u0004\u0012\u00020\u000b\u0018\u00010\b2\b\b\u0002\u0010\f\u001a\u00020\r2\b\b\u0002\u0010\u000e\u001a\u00020\u000fH\u0007ø\u0001\u0000¢\u0006\u0004\b\u0016\u0010\u0017\u001ap\u0010\u0003\u001a\u00020\u00042\b\u0010\u0012\u001a\u0004\u0018\u00010\u00132\u0006\u0010\u0014\u001a\u00020\u00152\u0014\b\u0002\u0010\u0007\u001a\u000e\u0012\u0004\u0012\u00020\t\u0012\u0004\u0012\u00020\t0\b2\u0016\b\u0002\u0010\n\u001a\u0010\u0012\u0004\u0012\u00020\t\u0012\u0004\u0012\u00020\u000b\u0018\u00010\b2\b\b\u0002\u0010\f\u001a\u00020\r2\b\b\u0002\u0010\u000e\u001a\u00020\u000f2\b\b\u0002\u0010\u0018\u001a\u00020\u0019H\u0007ø\u0001\u0000¢\u0006\u0004\b\u001a\u0010\u001b\u001a¤\u0001\u0010\u0003\u001a\u00020\u00042\b\u0010\u0012\u001a\u0004\u0018\u00010\u00132\u0006\u0010\u0014\u001a\u00020\u00152\n\b\u0002\u0010\u001c\u001a\u0004\u0018\u00010\u001d2\n\b\u0002\u0010\u001e\u001a\u0004\u0018\u00010\u001d2\n\b\u0002\u0010\u001f\u001a\u0004\u0018\u00010\u001d2\u0016\b\u0002\u0010 \u001a\u0010\u0012\u0004\u0012\u00020!\u0012\u0004\u0012\u00020\u000b\u0018\u00010\b2\u0016\b\u0002\u0010\"\u001a\u0010\u0012\u0004\u0012\u00020#\u0012\u0004\u0012\u00020\u000b\u0018\u00010\b2\u0016\b\u0002\u0010$\u001a\u0010\u0012\u0004\u0012\u00020%\u0012\u0004\u0012\u00020\u000b\u0018\u00010\b2\b\b\u0002\u0010\f\u001a\u00020\r2\b\b\u0002\u0010\u000e\u001a\u00020\u000fH\u0007ø\u0001\u0000¢\u0006\u0004\b&\u0010'\u001a®\u0001\u0010\u0003\u001a\u00020\u00042\b\u0010\u0012\u001a\u0004\u0018\u00010\u00132\u0006\u0010\u0014\u001a\u00020\u00152\n\b\u0002\u0010\u001c\u001a\u0004\u0018\u00010\u001d2\n\b\u0002\u0010\u001e\u001a\u0004\u0018\u00010\u001d2\n\b\u0002\u0010\u001f\u001a\u0004\u0018\u00010\u001d2\u0016\b\u0002\u0010 \u001a\u0010\u0012\u0004\u0012\u00020!\u0012\u0004\u0012\u00020\u000b\u0018\u00010\b2\u0016\b\u0002\u0010\"\u001a\u0010\u0012\u0004\u0012\u00020#\u0012\u0004\u0012\u00020\u000b\u0018\u00010\b2\u0016\b\u0002\u0010$\u001a\u0010\u0012\u0004\u0012\u00020%\u0012\u0004\u0012\u00020\u000b\u0018\u00010\b2\b\b\u0002\u0010\f\u001a\u00020\r2\b\b\u0002\u0010\u000e\u001a\u00020\u000f2\b\b\u0002\u0010\u0018\u001a\u00020\u0019H\u0007ø\u0001\u0000¢\u0006\u0004\b(\u0010)\u001a\u001a\u0010*\u001a\u00020+2\u0006\u0010,\u001a\u00020-2\b\b\u0002\u0010.\u001a\u00020-H\u0002\u001a\u0010\u0010/\u001a\u00020\u000b2\u0006\u00100\u001a\u000201H\u0002\u001a\u0018\u00102\u001a\u0004\u0018\u000103*\u000204H\u0002ø\u0001\u0000¢\u0006\u0004\b5\u00106\"\u0010\u0010\u0000\u001a\u00020\u0001X\u0082\u0004¢\u0006\u0004\n\u0002\u0010\u0002\u0082\u0002\u0007\n\u0005\b¡\u001e0\u0001¨\u00067"}, d2 = {"fakeTransitionTarget", "coil/compose/AsyncImagePainterKt$fakeTransitionTarget$1", "Lcoil/compose/AsyncImagePainterKt$fakeTransitionTarget$1;", "rememberAsyncImagePainter", "Lcoil/compose/AsyncImagePainter;", ServerProtocol.DIALOG_PARAM_STATE, "Lcoil/compose/AsyncImageState;", "transform", "Lkotlin/Function1;", "Lcoil/compose/AsyncImagePainter$State;", "onState", "", "contentScale", "Landroidx/compose/ui/layout/ContentScale;", "filterQuality", "Landroidx/compose/ui/graphics/FilterQuality;", "rememberAsyncImagePainter-GSdzBsE", "(Lcoil/compose/AsyncImageState;Lkotlin/jvm/functions/Function1;Lkotlin/jvm/functions/Function1;Landroidx/compose/ui/layout/ContentScale;ILandroidx/compose/runtime/Composer;I)Lcoil/compose/AsyncImagePainter;", DeviceRequestsHelper.DEVICE_INFO_MODEL, "", "imageLoader", "Lcoil/ImageLoader;", "rememberAsyncImagePainter-5jETZwI", "(Ljava/lang/Object;Lcoil/ImageLoader;Lkotlin/jvm/functions/Function1;Lkotlin/jvm/functions/Function1;Landroidx/compose/ui/layout/ContentScale;ILandroidx/compose/runtime/Composer;II)Lcoil/compose/AsyncImagePainter;", "modelEqualityDelegate", "Lcoil/compose/EqualityDelegate;", "rememberAsyncImagePainter-0YpotYA", "(Ljava/lang/Object;Lcoil/ImageLoader;Lkotlin/jvm/functions/Function1;Lkotlin/jvm/functions/Function1;Landroidx/compose/ui/layout/ContentScale;ILcoil/compose/EqualityDelegate;Landroidx/compose/runtime/Composer;II)Lcoil/compose/AsyncImagePainter;", "placeholder", "Landroidx/compose/ui/graphics/painter/Painter;", "error", "fallback", "onLoading", "Lcoil/compose/AsyncImagePainter$State$Loading;", "onSuccess", "Lcoil/compose/AsyncImagePainter$State$Success;", "onError", "Lcoil/compose/AsyncImagePainter$State$Error;", "rememberAsyncImagePainter-3HmZ8SU", "(Ljava/lang/Object;Lcoil/ImageLoader;Landroidx/compose/ui/graphics/painter/Painter;Landroidx/compose/ui/graphics/painter/Painter;Landroidx/compose/ui/graphics/painter/Painter;Lkotlin/jvm/functions/Function1;Lkotlin/jvm/functions/Function1;Lkotlin/jvm/functions/Function1;Landroidx/compose/ui/layout/ContentScale;ILandroidx/compose/runtime/Composer;II)Lcoil/compose/AsyncImagePainter;", "rememberAsyncImagePainter-10Xjiaw", "(Ljava/lang/Object;Lcoil/ImageLoader;Landroidx/compose/ui/graphics/painter/Painter;Landroidx/compose/ui/graphics/painter/Painter;Landroidx/compose/ui/graphics/painter/Painter;Lkotlin/jvm/functions/Function1;Lkotlin/jvm/functions/Function1;Lkotlin/jvm/functions/Function1;Landroidx/compose/ui/layout/ContentScale;ILcoil/compose/EqualityDelegate;Landroidx/compose/runtime/Composer;III)Lcoil/compose/AsyncImagePainter;", "unsupportedData", "", "name", "", "description", "validateRequest", "request", "Lcoil/request/ImageRequest;", "toSizeOrNull", "Lcoil/size/Size;", "Landroidx/compose/ui/geometry/Size;", "toSizeOrNull-uvyYCjk", "(J)Lcoil/size/Size;", "coil-compose-base_release"}, k = 2, mv = {1, 9, 0}, xi = ConstraintLayout.LayoutParams.Table.LAYOUT_CONSTRAINT_VERTICAL_CHAINSTYLE)
public final class AsyncImagePainterKt {
    private static final AsyncImagePainterKt$fakeTransitionTarget$1 fakeTransitionTarget = new TransitionTarget() {
        @Override
        public Drawable getDrawable() {
            return null;
        }

        @Override
        public void onError(Drawable drawable) {
            Target.CC.$default$onError(this, drawable);
        }

        @Override
        public void onStart(Drawable drawable) {
            Target.CC.$default$onStart(this, drawable);
        }

        @Override
        public void onSuccess(Drawable drawable) {
            Target.CC.$default$onSuccess(this, drawable);
        }

        @Override
        public View getView() {
            return (View) m2275getView();
        }

        public Void m2275getView() {
            throw new UnsupportedOperationException();
        }
    };

    public static final AsyncImagePainter m2270rememberAsyncImagePainter10Xjiaw(Object obj, ImageLoader imageLoader, Painter painter, Painter painter2, Painter painter3, Function1<? super AsyncImagePainter.State.Loading, Unit> function1, Function1<? super AsyncImagePainter.State.Success, Unit> function2, Function1<? super AsyncImagePainter.State.Error, Unit> function3, ContentScale contentScale, int i, EqualityDelegate equalityDelegate, Composer composer, int i2, int i3, int i4) throws KotlinNothingValueException {
        composer.startReplaceableGroup(-79978785);
        Painter painter4 = (i4 & 4) != 0 ? null : painter;
        Painter painter5 = (i4 & 8) != 0 ? null : painter2;
        Painter painter6 = (i4 & 16) != 0 ? painter5 : painter3;
        Function1<? super AsyncImagePainter.State.Loading, Unit> function4 = (i4 & 32) != 0 ? null : function1;
        Function1<? super AsyncImagePainter.State.Success, Unit> function5 = (i4 & 64) != 0 ? null : function2;
        Function1<? super AsyncImagePainter.State.Error, Unit> function6 = (i4 & 128) == 0 ? function3 : null;
        ContentScale fit = (i4 & 256) != 0 ? ContentScale.Companion.getFit() : contentScale;
        int i5 = (i4 & 512) != 0 ? DrawScope.Companion.getDefaultFilterQuality-f-v9h1I() : i;
        EqualityDelegate defaultModelEqualityDelegate = (i4 & 1024) != 0 ? EqualityDelegateKt.getDefaultModelEqualityDelegate() : equalityDelegate;
        if (ComposerKt.isTraceInProgress()) {
            ComposerKt.traceEventStart(-79978785, i2, i3, "coil.compose.rememberAsyncImagePainter (AsyncImagePainter.kt:100)");
        }
        AsyncImagePainter asyncImagePainterM2273rememberAsyncImagePainterGSdzBsE = m2273rememberAsyncImagePainterGSdzBsE(new AsyncImageState(obj, defaultModelEqualityDelegate, imageLoader), UtilsKt.transformOf(painter4, painter5, painter6), UtilsKt.onStateOf(function4, function5, function6), fit, i5, composer, (i2 >> 15) & 64512);
        if (ComposerKt.isTraceInProgress()) {
            ComposerKt.traceEventEnd();
        }
        composer.endReplaceableGroup();
        return asyncImagePainterM2273rememberAsyncImagePainterGSdzBsE;
    }

    @Deprecated(level = DeprecationLevel.HIDDEN, message = "Kept for binary compatibility.")
    public static final AsyncImagePainter m2271rememberAsyncImagePainter3HmZ8SU(Object obj, ImageLoader imageLoader, Painter painter, Painter painter2, Painter painter3, Function1 function1, Function1 function2, Function1 function3, ContentScale contentScale, int i, Composer composer, int i2, int i3) throws KotlinNothingValueException {
        composer.startReplaceableGroup(2140758544);
        Painter painter4 = (i3 & 4) != 0 ? null : painter;
        Painter painter5 = (i3 & 8) != 0 ? null : painter2;
        Painter painter6 = (i3 & 16) != 0 ? painter5 : painter3;
        Function1 function4 = (i3 & 32) != 0 ? null : function1;
        Function1 function5 = (i3 & 64) != 0 ? null : function2;
        Function1 function6 = (i3 & 128) == 0 ? function3 : null;
        ContentScale fit = (i3 & 256) != 0 ? ContentScale.Companion.getFit() : contentScale;
        int i4 = (i3 & 512) != 0 ? DrawScope.Companion.getDefaultFilterQuality-f-v9h1I() : i;
        if (ComposerKt.isTraceInProgress()) {
            ComposerKt.traceEventStart(2140758544, i2, -1, "coil.compose.rememberAsyncImagePainter (AsyncImagePainter.kt:122)");
        }
        AsyncImagePainter asyncImagePainterM2273rememberAsyncImagePainterGSdzBsE = m2273rememberAsyncImagePainterGSdzBsE(new AsyncImageState(obj, EqualityDelegateKt.getDefaultModelEqualityDelegate(), imageLoader), UtilsKt.transformOf(painter4, painter5, painter6), UtilsKt.onStateOf(function4, function5, function6), fit, i4, composer, (i2 >> 15) & 64512);
        if (ComposerKt.isTraceInProgress()) {
            ComposerKt.traceEventEnd();
        }
        composer.endReplaceableGroup();
        return asyncImagePainterM2273rememberAsyncImagePainterGSdzBsE;
    }

    public static final AsyncImagePainter m2269rememberAsyncImagePainter0YpotYA(Object obj, ImageLoader imageLoader, Function1<? super AsyncImagePainter.State, ? extends AsyncImagePainter.State> function1, Function1<? super AsyncImagePainter.State, Unit> function2, ContentScale contentScale, int i, EqualityDelegate equalityDelegate, Composer composer, int i2, int i3) throws KotlinNothingValueException {
        composer.startReplaceableGroup(1645646697);
        Function1<? super AsyncImagePainter.State, ? extends AsyncImagePainter.State> defaultTransform = (i3 & 4) != 0 ? AsyncImagePainter.INSTANCE.getDefaultTransform() : function1;
        Function1<? super AsyncImagePainter.State, Unit> function3 = (i3 & 8) != 0 ? null : function2;
        ContentScale fit = (i3 & 16) != 0 ? ContentScale.Companion.getFit() : contentScale;
        int i4 = (i3 & 32) != 0 ? DrawScope.Companion.getDefaultFilterQuality-f-v9h1I() : i;
        EqualityDelegate defaultModelEqualityDelegate = (i3 & 64) != 0 ? EqualityDelegateKt.getDefaultModelEqualityDelegate() : equalityDelegate;
        if (ComposerKt.isTraceInProgress()) {
            ComposerKt.traceEventStart(1645646697, i2, -1, "coil.compose.rememberAsyncImagePainter (AsyncImagePainter.kt:166)");
        }
        AsyncImagePainter asyncImagePainterM2273rememberAsyncImagePainterGSdzBsE = m2273rememberAsyncImagePainterGSdzBsE(new AsyncImageState(obj, defaultModelEqualityDelegate, imageLoader), defaultTransform, function3, fit, i4, composer, (i2 >> 3) & 65520);
        if (ComposerKt.isTraceInProgress()) {
            ComposerKt.traceEventEnd();
        }
        composer.endReplaceableGroup();
        return asyncImagePainterM2273rememberAsyncImagePainterGSdzBsE;
    }

    @Deprecated(level = DeprecationLevel.HIDDEN, message = "Kept for binary compatibility.")
    public static final AsyncImagePainter m2272rememberAsyncImagePainter5jETZwI(Object obj, ImageLoader imageLoader, Function1 function1, Function1 function2, ContentScale contentScale, int i, Composer composer, int i2, int i3) throws KotlinNothingValueException {
        composer.startReplaceableGroup(-2020614074);
        Function1 defaultTransform = (i3 & 4) != 0 ? AsyncImagePainter.INSTANCE.getDefaultTransform() : function1;
        Function1 function3 = (i3 & 8) != 0 ? null : function2;
        ContentScale fit = (i3 & 16) != 0 ? ContentScale.Companion.getFit() : contentScale;
        int i4 = (i3 & 32) != 0 ? DrawScope.Companion.getDefaultFilterQuality-f-v9h1I() : i;
        if (ComposerKt.isTraceInProgress()) {
            ComposerKt.traceEventStart(-2020614074, i2, -1, "coil.compose.rememberAsyncImagePainter (AsyncImagePainter.kt:184)");
        }
        AsyncImagePainter asyncImagePainterM2273rememberAsyncImagePainterGSdzBsE = m2273rememberAsyncImagePainterGSdzBsE(new AsyncImageState(obj, EqualityDelegateKt.getDefaultModelEqualityDelegate(), imageLoader), defaultTransform, function3, fit, i4, composer, (i2 >> 3) & 65520);
        if (ComposerKt.isTraceInProgress()) {
            ComposerKt.traceEventEnd();
        }
        composer.endReplaceableGroup();
        return asyncImagePainterM2273rememberAsyncImagePainterGSdzBsE;
    }

    private static final AsyncImagePainter m2273rememberAsyncImagePainterGSdzBsE(AsyncImageState asyncImageState, Function1<? super AsyncImagePainter.State, ? extends AsyncImagePainter.State> function1, Function1<? super AsyncImagePainter.State, Unit> function2, ContentScale contentScale, int i, Composer composer, int i2) throws KotlinNothingValueException {
        composer.startReplaceableGroup(952940650);
        if (ComposerKt.isTraceInProgress()) {
            ComposerKt.traceEventStart(952940650, i2, -1, "coil.compose.rememberAsyncImagePainter (AsyncImagePainter.kt:199)");
        }
        ImageRequest imageRequestRequestOf = UtilsKt.requestOf(asyncImageState.getModel(), composer, 8);
        validateRequest(imageRequestRequestOf);
        composer.startReplaceableGroup(294038899);
        Object objRememberedValue = composer.rememberedValue();
        if (objRememberedValue == Composer.Companion.getEmpty()) {
            objRememberedValue = new AsyncImagePainter(imageRequestRequestOf, asyncImageState.getImageLoader());
            composer.updateRememberedValue(objRememberedValue);
        }
        AsyncImagePainter asyncImagePainter = (AsyncImagePainter) objRememberedValue;
        composer.endReplaceableGroup();
        asyncImagePainter.setTransform$coil_compose_base_release(function1);
        asyncImagePainter.setOnState$coil_compose_base_release(function2);
        asyncImagePainter.setContentScale$coil_compose_base_release(contentScale);
        asyncImagePainter.m2266setFilterQualityvDHp3xo$coil_compose_base_release(i);
        CompositionLocal localInspectionMode = InspectionModeKt.getLocalInspectionMode();
        ComposerKt.sourceInformationMarkerStart(composer, 2023513938, "CC:CompositionLocal.kt#9igjgp");
        Object objConsume = composer.consume(localInspectionMode);
        ComposerKt.sourceInformationMarkerEnd(composer);
        asyncImagePainter.setPreview$coil_compose_base_release(((Boolean) objConsume).booleanValue());
        asyncImagePainter.setImageLoader$coil_compose_base_release(asyncImageState.getImageLoader());
        asyncImagePainter.setRequest$coil_compose_base_release(imageRequestRequestOf);
        asyncImagePainter.onRemembered();
        if (ComposerKt.isTraceInProgress()) {
            ComposerKt.traceEventEnd();
        }
        composer.endReplaceableGroup();
        return asyncImagePainter;
    }

    private static final void validateRequest(ImageRequest imageRequest) throws KotlinNothingValueException {
        Object data = imageRequest.getData();
        if (data instanceof ImageRequest.Builder) {
            unsupportedData("ImageRequest.Builder", "Did you forget to call ImageRequest.Builder.build()?");
            throw new KotlinNothingValueException();
        }
        if (data instanceof ImageBitmap) {
            unsupportedData$default("ImageBitmap", null, 2, null);
            throw new KotlinNothingValueException();
        }
        if (data instanceof ImageVector) {
            unsupportedData$default("ImageVector", null, 2, null);
            throw new KotlinNothingValueException();
        }
        if (data instanceof Painter) {
            unsupportedData$default("Painter", null, 2, null);
            throw new KotlinNothingValueException();
        }
        if (imageRequest.getTarget() != null) {
            throw new IllegalArgumentException("request.target must be null.".toString());
        }
    }

    static Void unsupportedData$default(String str, String str2, int i, Object obj) {
        if ((i & 2) != 0) {
            str2 = "If you wish to display this " + str + ", use androidx.compose.foundation.Image.";
        }
        return unsupportedData(str, str2);
    }

    private static final Void unsupportedData(String str, String str2) {
        throw new IllegalArgumentException("Unsupported type: " + str + ". " + str2);
    }

    public static final Size m2274toSizeOrNulluvyYCjk(long j) {
        if (j == androidx.compose.ui.geometry.Size.Companion.getUnspecified-NH-jbRc()) {
            return Size.ORIGINAL;
        }
        if (!UtilsKt.m2317isPositiveuvyYCjk(j)) {
            return null;
        }
        float f = androidx.compose.ui.geometry.Size.getWidth-impl(j);
        Dimension Dimension = (Float.isInfinite(f) || Float.isNaN(f)) ? Dimension.Undefined.INSTANCE : Dimensions.Dimension(MathKt.roundToInt(androidx.compose.ui.geometry.Size.getWidth-impl(j)));
        float f2 = androidx.compose.ui.geometry.Size.getHeight-impl(j);
        return new Size(Dimension, (Float.isInfinite(f2) || Float.isNaN(f2)) ? Dimension.Undefined.INSTANCE : Dimensions.Dimension(MathKt.roundToInt(androidx.compose.ui.geometry.Size.getHeight-impl(j))));
    }
}
