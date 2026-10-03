package coil.compose;

import android.content.Context;
import androidx.compose.p000ui.unit.Constraints;
import androidx.compose.p000ui.unit.IntSizeKt;
import androidx.compose.runtime.Composer;
import androidx.compose.runtime.ComposerKt;
import androidx.compose.runtime.CompositionLocal;
import androidx.compose.ui.Modifier;
import androidx.compose.ui.graphics.painter.Painter;
import androidx.compose.ui.layout.ContentScale;
import androidx.compose.ui.platform.AndroidCompositionLocals_androidKt;
import androidx.compose.ui.semantics.Role;
import androidx.compose.ui.semantics.SemanticsModifierKt;
import androidx.compose.ui.semantics.SemanticsPropertiesKt;
import androidx.compose.ui.semantics.SemanticsPropertyReceiver;
import androidx.constraintlayout.widget.ConstraintLayout;
import coil.request.ImageRequest;
import coil.request.NullRequestDataException;
import coil.size.Dimension;
import coil.size.Dimensions;
import coil.size.Scale;
import coil.size.Size;
import coil.size.SizeResolver;
import coil.size.SizeResolvers;
import com.facebook.appevents.internal.ViewHierarchyConstants;
import com.facebook.devicerequests.internal.DeviceRequestsHelper;
import kotlin.Metadata;
import kotlin.Unit;
import kotlin.jvm.functions.Function0;
import kotlin.jvm.functions.Function1;
import kotlin.jvm.internal.Intrinsics;
import kotlin.math.MathKt;
import kotlin.ranges.RangesKt;

@Metadata(d1 = {"\u0000\u008c\u0001\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0002\b\u0004\n\u0002\u0010\u000b\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0010\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u0000\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0010\u0007\n\u0002\b\u0007\n\u0002\u0018\u0002\n\u0002\u0010\u000e\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0003\u001aX\u0010\u000e\u001a\u0010\u0012\u0004\u0012\u00020\u0010\u0012\u0004\u0012\u00020\u0011\u0018\u00010\u000f2\u0014\u0010\u0012\u001a\u0010\u0012\u0004\u0012\u00020\u0013\u0012\u0004\u0012\u00020\u0011\u0018\u00010\u000f2\u0014\u0010\u0014\u001a\u0010\u0012\u0004\u0012\u00020\u0015\u0012\u0004\u0012\u00020\u0011\u0018\u00010\u000f2\u0014\u0010\u0016\u001a\u0010\u0012\u0004\u0012\u00020\u0017\u0012\u0004\u0012\u00020\u0011\u0018\u00010\u000fH\u0001\u001a\u0017\u0010\u0018\u001a\u00020\u00192\b\u0010\u001a\u001a\u0004\u0018\u00010\u001bH\u0001¢\u0006\u0002\u0010\u001c\u001a\u001f\u0010\u001d\u001a\u00020\u00192\b\u0010\u001a\u001a\u0004\u0018\u00010\u001b2\u0006\u0010\u001e\u001a\u00020\u001fH\u0001¢\u0006\u0002\u0010 \u001a2\u0010!\u001a\u000e\u0012\u0004\u0012\u00020\u0010\u0012\u0004\u0012\u00020\u00100\u000f2\b\u0010\"\u001a\u0004\u0018\u00010#2\b\u0010$\u001a\u0004\u0018\u00010#2\b\u0010%\u001a\u0004\u0018\u00010#H\u0001\u001a\u001e\u0010&\u001a\u00020'*\u00020\u00052\u0006\u0010(\u001a\u00020'H\u0000ø\u0001\u0000¢\u0006\u0004\b)\u0010*\u001a\u001e\u0010+\u001a\u00020'*\u00020\u00052\u0006\u0010,\u001a\u00020'H\u0000ø\u0001\u0000¢\u0006\u0004\b-\u0010*\u001a\u0016\u0010.\u001a\u00020/*\u00020/2\b\u0010.\u001a\u0004\u0018\u000100H\u0001\u001a\u001b\u00101\u001a\u00020'*\u00020'2\f\u00102\u001a\b\u0012\u0004\u0012\u00020'03H\u0080\b\u001a\u0016\u00104\u001a\u000205*\u00020\u000bH\u0000ø\u0001\u0000¢\u0006\u0004\b6\u00107\u001a\f\u00108\u001a\u000209*\u00020\u001fH\u0001\u001a\u0018\u0010:\u001a\u0004\u0018\u00010;*\u00020\u0005H\u0001ø\u0001\u0000¢\u0006\u0004\b<\u0010=\"\u0014\u0010\u0000\u001a\u00020\u0001X\u0080\u0004¢\u0006\b\n\u0000\u001a\u0004\b\u0002\u0010\u0003\"\u0016\u0010\u0004\u001a\u00020\u0005X\u0080\u0004¢\u0006\n\n\u0002\u0010\b\u001a\u0004\b\u0006\u0010\u0007\"\u0018\u0010\t\u001a\u00020\n*\u00020\u000b8@X\u0080\u0004¢\u0006\u0006\u001a\u0004\b\f\u0010\r\u0082\u0002\u0007\n\u0005\b¡\u001e0\u0001¨\u0006>"}, d2 = {"OriginalSizeResolver", "Lcoil/size/SizeResolver;", "getOriginalSizeResolver", "()Lcoil/size/SizeResolver;", "ZeroConstraints", "Landroidx/compose/ui/unit/Constraints;", "getZeroConstraints", "()J", "J", "isPositive", "", "Landroidx/compose/ui/geometry/Size;", "isPositive-uvyYCjk", "(J)Z", "onStateOf", "Lkotlin/Function1;", "Lcoil/compose/AsyncImagePainter$State;", "", "onLoading", "Lcoil/compose/AsyncImagePainter$State$Loading;", "onSuccess", "Lcoil/compose/AsyncImagePainter$State$Success;", "onError", "Lcoil/compose/AsyncImagePainter$State$Error;", "requestOf", "Lcoil/request/ImageRequest;", DeviceRequestsHelper.DEVICE_INFO_MODEL, "", "(Ljava/lang/Object;Landroidx/compose/runtime/Composer;I)Lcoil/request/ImageRequest;", "requestOfWithSizeResolver", "contentScale", "Landroidx/compose/ui/layout/ContentScale;", "(Ljava/lang/Object;Landroidx/compose/ui/layout/ContentScale;Landroidx/compose/runtime/Composer;I)Lcoil/request/ImageRequest;", "transformOf", "placeholder", "Landroidx/compose/ui/graphics/painter/Painter;", "error", "fallback", "constrainHeight", "", ViewHierarchyConstants.DIMENSION_HEIGHT_KEY, "constrainHeight-K40F9xA", "(JF)F", "constrainWidth", ViewHierarchyConstants.DIMENSION_WIDTH_KEY, "constrainWidth-K40F9xA", "contentDescription", "Landroidx/compose/ui/Modifier;", "", "takeOrElse", "block", "Lkotlin/Function0;", "toIntSize", "Landroidx/compose/ui/unit/IntSize;", "toIntSize-uvyYCjk", "(J)J", "toScale", "Lcoil/size/Scale;", "toSizeOrNull", "Lcoil/size/Size;", "toSizeOrNull-BRTryo0", "(J)Lcoil/size/Size;", "coil-compose-base_release"}, k = 2, mv = {1, 9, 0}, xi = ConstraintLayout.LayoutParams.Table.LAYOUT_CONSTRAINT_VERTICAL_CHAINSTYLE)
public final class UtilsKt {
    private static final long ZeroConstraints = Constraints.INSTANCE.m1776fixedJhjzzOo(0, 0);
    private static final SizeResolver OriginalSizeResolver = SizeResolvers.create(Size.ORIGINAL);

    public static final ImageRequest requestOf(Object obj, Composer composer, int i) {
        composer.startReplaceableGroup(1087186730);
        if (ComposerKt.isTraceInProgress()) {
            ComposerKt.traceEventStart(1087186730, i, -1, "coil.compose.requestOf (utils.kt:31)");
        }
        if (obj instanceof ImageRequest) {
            ImageRequest imageRequest = (ImageRequest) obj;
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventEnd();
            }
            composer.endReplaceableGroup();
            return imageRequest;
        }
        CompositionLocal localContext = AndroidCompositionLocals_androidKt.getLocalContext();
        ComposerKt.sourceInformationMarkerStart(composer, 2023513938, "CC:CompositionLocal.kt#9igjgp");
        Object objConsume = composer.consume(localContext);
        ComposerKt.sourceInformationMarkerEnd(composer);
        Context context = (Context) objConsume;
        composer.startReplaceableGroup(375474364);
        boolean zChanged = composer.changed(context) | composer.changed(obj);
        Object objRememberedValue = composer.rememberedValue();
        if (zChanged || objRememberedValue == Composer.Companion.getEmpty()) {
            objRememberedValue = new ImageRequest.Builder(context).data(obj).build();
            composer.updateRememberedValue(objRememberedValue);
        }
        ImageRequest imageRequest2 = (ImageRequest) objRememberedValue;
        composer.endReplaceableGroup();
        if (ComposerKt.isTraceInProgress()) {
            ComposerKt.traceEventEnd();
        }
        composer.endReplaceableGroup();
        return imageRequest2;
    }

    public static final ImageRequest requestOfWithSizeResolver(Object obj, ContentScale contentScale, Composer composer, int i) {
        ConstraintsSizeResolver constraintsSizeResolver;
        composer.startReplaceableGroup(1677680258);
        if (ComposerKt.isTraceInProgress()) {
            ComposerKt.traceEventStart(1677680258, i, -1, "coil.compose.requestOfWithSizeResolver (utils.kt:50)");
        }
        boolean z = obj instanceof ImageRequest;
        if (z) {
            ImageRequest imageRequest = (ImageRequest) obj;
            if (imageRequest.getDefined().getSizeResolver() != null) {
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                composer.endReplaceableGroup();
                return imageRequest;
            }
        }
        composer.startReplaceableGroup(-679565543);
        if (Intrinsics.areEqual(contentScale, ContentScale.Companion.getNone())) {
            constraintsSizeResolver = OriginalSizeResolver;
        } else {
            composer.startReplaceableGroup(-679565452);
            Object objRememberedValue = composer.rememberedValue();
            if (objRememberedValue == Composer.Companion.getEmpty()) {
                objRememberedValue = new ConstraintsSizeResolver();
                composer.updateRememberedValue(objRememberedValue);
            }
            composer.endReplaceableGroup();
            constraintsSizeResolver = (ConstraintsSizeResolver) objRememberedValue;
        }
        composer.endReplaceableGroup();
        if (z) {
            composer.startReplaceableGroup(-679565365);
            composer.startReplaceableGroup(-679565358);
            boolean zChanged = composer.changed(obj) | composer.changed(constraintsSizeResolver);
            Object objRememberedValue2 = composer.rememberedValue();
            if (zChanged || objRememberedValue2 == Composer.Companion.getEmpty()) {
                objRememberedValue2 = ImageRequest.newBuilder$default((ImageRequest) obj, null, 1, null).size(constraintsSizeResolver).build();
                composer.updateRememberedValue(objRememberedValue2);
            }
            ImageRequest imageRequest2 = (ImageRequest) objRememberedValue2;
            composer.endReplaceableGroup();
            composer.endReplaceableGroup();
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventEnd();
            }
            composer.endReplaceableGroup();
            return imageRequest2;
        }
        composer.startReplaceableGroup(-679565199);
        CompositionLocal localContext = AndroidCompositionLocals_androidKt.getLocalContext();
        ComposerKt.sourceInformationMarkerStart(composer, 2023513938, "CC:CompositionLocal.kt#9igjgp");
        Object objConsume = composer.consume(localContext);
        ComposerKt.sourceInformationMarkerEnd(composer);
        Context context = (Context) objConsume;
        composer.startReplaceableGroup(-679565153);
        boolean zChanged2 = composer.changed(context) | composer.changed(obj) | composer.changed(constraintsSizeResolver);
        Object objRememberedValue3 = composer.rememberedValue();
        if (zChanged2 || objRememberedValue3 == Composer.Companion.getEmpty()) {
            objRememberedValue3 = new ImageRequest.Builder(context).data(obj).size(constraintsSizeResolver).build();
            composer.updateRememberedValue(objRememberedValue3);
        }
        ImageRequest imageRequest3 = (ImageRequest) objRememberedValue3;
        composer.endReplaceableGroup();
        composer.endReplaceableGroup();
        if (ComposerKt.isTraceInProgress()) {
            ComposerKt.traceEventEnd();
        }
        composer.endReplaceableGroup();
        return imageRequest3;
    }

    public static final Function1<AsyncImagePainter.State, AsyncImagePainter.State> transformOf(final Painter painter, final Painter painter2, final Painter painter3) {
        if (painter != null || painter2 != null || painter3 != null) {
            return new Function1<AsyncImagePainter.State, AsyncImagePainter.State>() {
                {
                    super(1);
                }

                public final AsyncImagePainter.State invoke(AsyncImagePainter.State state) {
                    if (state instanceof AsyncImagePainter.State.Loading) {
                        Painter painter4 = painter;
                        AsyncImagePainter.State.Loading loadingCopy = (AsyncImagePainter.State.Loading) state;
                        if (painter4 != null) {
                            loadingCopy = loadingCopy.copy(painter4);
                        }
                        return loadingCopy;
                    }
                    if (!(state instanceof AsyncImagePainter.State.Error)) {
                        return state;
                    }
                    AsyncImagePainter.State.Error errorCopy$default = (AsyncImagePainter.State.Error) state;
                    if (errorCopy$default.getResult().getThrowable() instanceof NullRequestDataException) {
                        Painter painter5 = painter3;
                        if (painter5 != null) {
                            errorCopy$default = AsyncImagePainter.State.Error.copy$default(errorCopy$default, painter5, null, 2, null);
                        }
                    } else {
                        Painter painter6 = painter2;
                        if (painter6 != null) {
                            errorCopy$default = AsyncImagePainter.State.Error.copy$default(errorCopy$default, painter6, null, 2, null);
                        }
                    }
                    return errorCopy$default;
                }
            };
        }
        return AsyncImagePainter.INSTANCE.getDefaultTransform();
    }

    public static final Function1<AsyncImagePainter.State, Unit> onStateOf(final Function1<? super AsyncImagePainter.State.Loading, Unit> function1, final Function1<? super AsyncImagePainter.State.Success, Unit> function2, final Function1<? super AsyncImagePainter.State.Error, Unit> function3) {
        if (function1 == null && function2 == null && function3 == null) {
            return null;
        }
        return new Function1<AsyncImagePainter.State, Unit>() {
            {
                super(1);
            }

            public Object invoke(Object obj) {
                invoke((AsyncImagePainter.State) obj);
                return Unit.INSTANCE;
            }

            public final void invoke(AsyncImagePainter.State state) {
                if (state instanceof AsyncImagePainter.State.Loading) {
                    Function1<AsyncImagePainter.State.Loading, Unit> function4 = function1;
                    if (function4 != null) {
                        function4.invoke(state);
                        return;
                    }
                    return;
                }
                if (state instanceof AsyncImagePainter.State.Success) {
                    Function1<AsyncImagePainter.State.Success, Unit> function5 = function2;
                    if (function5 != null) {
                        function5.invoke(state);
                        return;
                    }
                    return;
                }
                if (!(state instanceof AsyncImagePainter.State.Error)) {
                    boolean z = state instanceof AsyncImagePainter.State.Empty;
                    return;
                }
                Function1<AsyncImagePainter.State.Error, Unit> function6 = function3;
                if (function6 != null) {
                    function6.invoke(state);
                }
            }
        };
    }

    public static final Modifier contentDescription(Modifier modifier, final String str) {
        return str != null ? SemanticsModifierKt.semantics$default(modifier, false, new Function1<SemanticsPropertyReceiver, Unit>() {
            {
                super(1);
            }

            public Object invoke(Object obj) {
                invoke((SemanticsPropertyReceiver) obj);
                return Unit.INSTANCE;
            }

            public final void invoke(SemanticsPropertyReceiver semanticsPropertyReceiver) {
                SemanticsPropertiesKt.setContentDescription(semanticsPropertyReceiver, str);
                SemanticsPropertiesKt.setRole-kuIjeqM(semanticsPropertyReceiver, Role.Companion.getImage-o7Vup1c());
            }
        }, 1, (Object) null) : modifier;
    }

    public static final Scale toScale(ContentScale contentScale) {
        return Intrinsics.areEqual(contentScale, ContentScale.Companion.getFit()) ? true : Intrinsics.areEqual(contentScale, ContentScale.Companion.getInside()) ? Scale.FIT : Scale.FILL;
    }

    public static final Size m2319toSizeOrNullBRTryo0(long j) {
        if (Constraints.m1770isZeroimpl(j)) {
            return null;
        }
        return new Size(Constraints.m1762getHasBoundedWidthimpl(j) ? Dimensions.Dimension(Constraints.m1766getMaxWidthimpl(j)) : Dimension.Undefined.INSTANCE, Constraints.m1761getHasBoundedHeightimpl(j) ? Dimensions.Dimension(Constraints.m1765getMaxHeightimpl(j)) : Dimension.Undefined.INSTANCE);
    }

    public static final float m2316constrainWidthK40F9xA(long j, float f) {
        return RangesKt.coerceIn(f, Constraints.m1768getMinWidthimpl(j), Constraints.m1766getMaxWidthimpl(j));
    }

    public static final float m2315constrainHeightK40F9xA(long j, float f) {
        return RangesKt.coerceIn(f, Constraints.m1767getMinHeightimpl(j), Constraints.m1765getMaxHeightimpl(j));
    }

    public static final float takeOrElse(float f, Function0<Float> function0) {
        return (Float.isInfinite(f) || Float.isNaN(f)) ? ((Number) function0.invoke()).floatValue() : f;
    }

    public static final long m2318toIntSizeuvyYCjk(long j) {
        return IntSizeKt.IntSize(MathKt.roundToInt(androidx.compose.ui.geometry.Size.getWidth-impl(j)), MathKt.roundToInt(androidx.compose.ui.geometry.Size.getHeight-impl(j)));
    }

    public static final boolean m2317isPositiveuvyYCjk(long j) {
        return ((double) androidx.compose.ui.geometry.Size.getWidth-impl(j)) >= 0.5d && ((double) androidx.compose.ui.geometry.Size.getHeight-impl(j)) >= 0.5d;
    }

    public static final long getZeroConstraints() {
        return ZeroConstraints;
    }

    public static final SizeResolver getOriginalSizeResolver() {
        return OriginalSizeResolver;
    }
}
