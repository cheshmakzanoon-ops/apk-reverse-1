package androidx.compose.p002ui.graphics.layer;

import android.graphics.Bitmap;
import android.graphics.Canvas;
import android.graphics.Outline;
import android.graphics.RectF;
import android.os.Build;
import androidx.collection.MutableScatterSet;
import androidx.collection.ScatterSetKt;
import androidx.compose.p002ui.geometry.CornerRadiusKt;
import androidx.compose.p002ui.geometry.InlineClassHelperKt;
import androidx.compose.p002ui.geometry.Offset;
import androidx.compose.p002ui.geometry.Rect;
import androidx.compose.p002ui.geometry.RoundRectKt;
import androidx.compose.p002ui.geometry.Size;
import androidx.compose.p002ui.graphics.AndroidCanvas_androidKt;
import androidx.compose.p002ui.graphics.AndroidImageBitmap_androidKt;
import androidx.compose.p002ui.graphics.AndroidPaint_androidKt;
import androidx.compose.p002ui.graphics.AndroidPath;
import androidx.compose.p002ui.graphics.AndroidPath_androidKt;
import androidx.compose.p002ui.graphics.BlendMode;
import androidx.compose.p002ui.graphics.ClipOp;
import androidx.compose.p002ui.graphics.Color;
import androidx.compose.p002ui.graphics.ColorFilter;
import androidx.compose.p002ui.graphics.ImageBitmap;
import androidx.compose.p002ui.graphics.Paint;
import androidx.compose.p002ui.graphics.Path;
import androidx.compose.p002ui.graphics.RenderEffect;
import androidx.compose.p002ui.graphics.drawscope.DrawContext;
import androidx.compose.p002ui.graphics.drawscope.DrawContextKt;
import androidx.compose.p002ui.graphics.drawscope.DrawScope;
import androidx.compose.ui.unit.Density;
import androidx.compose.ui.unit.IntOffset;
import androidx.compose.ui.unit.IntSize;
import androidx.compose.ui.unit.IntSizeKt;
import androidx.compose.ui.unit.LayoutDirection;
import kotlin.Metadata;
import kotlin.ResultKt;
import kotlin.Unit;
import kotlin.coroutines.Continuation;
import kotlin.coroutines.intrinsics.IntrinsicsKt;
import kotlin.coroutines.jvm.internal.ContinuationImpl;
import kotlin.coroutines.jvm.internal.DebugMetadata;
import kotlin.jvm.functions.Function1;
import kotlin.jvm.functions.Function2;
import kotlin.jvm.internal.Intrinsics;
import zendesk.p005ui.android.BuildConfig;

@Metadata(d1 = {"\u0000â\u0001\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0010\u0007\n\u0002\b\u0005\n\u0002\u0018\u0002\n\u0002\b\u0006\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\t\n\u0002\u0018\u0002\n\u0002\u0010\u000b\n\u0002\b\b\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0010\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0005\n\u0002\u0018\u0002\n\u0002\b\u0004\n\u0002\u0018\u0002\n\u0002\b\u0004\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0010\t\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0005\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0010\b\n\u0000\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0004\n\u0002\u0018\u0002\n\u0002\b\u0011\n\u0002\u0018\u0002\n\u0002\b\n\n\u0002\u0018\u0002\n\u0002\b\u0004\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0002\b\u0012\n\u0002\u0018\u0002\n\u0002\b\u0015\n\u0002\u0018\u0002\n\u0002\b\r\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0002\b\u0003\u0018\u0000 º\u00012\u00020\u0001:\u0002º\u0001B\u0019\b\u0000\u0012\u0006\u0010\u0002\u001a\u00020\u0003\u0012\b\u0010\u0004\u001a\u0004\u0018\u00010\u0005¢\u0006\u0002\u0010\u0006J\u0012\u0010\u0088\u0001\u001a\u00020,2\u0007\u0010\u0089\u0001\u001a\u00020\u0000H\u0002J\t\u0010\u008a\u0001\u001a\u00020,H\u0002J\t\u0010\u008b\u0001\u001a\u00020,H\u0002J\u000f\u0010\u008c\u0001\u001a\u00020,H\u0000¢\u0006\u0003\b\u008d\u0001J$\u0010\u008e\u0001\u001a\u00020,2\b\u0010\u008f\u0001\u001a\u00030\u0090\u00012\t\u0010\u0091\u0001\u001a\u0004\u0018\u00010\u0000H\u0000¢\u0006\u0003\b\u0092\u0001J\u0019\u0010\u0093\u0001\u001a\u00020,2\b\u0010\u008f\u0001\u001a\u00030\u0090\u0001H\u0000¢\u0006\u0003\b\u0094\u0001J\u000f\u0010\u0095\u0001\u001a\u00020,H\u0001¢\u0006\u0003\b\u0096\u0001J\t\u0010\u0097\u0001\u001a\u00020\u0015H\u0002J\t\u0010\u0098\u0001\u001a\u00020QH\u0002J\t\u0010\u0099\u0001\u001a\u00020,H\u0002J\t\u0010\u009a\u0001\u001a\u00020,H\u0002JE\u0010\u009b\u0001\u001a\u00020,2\u0006\u00108\u001a\u0002092\u0006\u0010D\u001a\u00020E2\u0006\u0010u\u001a\u00020t2\u0018\u0010\u009c\u0001\u001a\u0013\u0012\u0004\u0012\u00020+\u0012\u0004\u0012\u00020,0*¢\u0006\u0002\b-ø\u0001\u0000¢\u0006\u0006\b\u009d\u0001\u0010\u009e\u0001J\t\u0010\u009f\u0001\u001a\u00020,H\u0002J\t\u0010 \u0001\u001a\u00020,H\u0002J\u000f\u0010¡\u0001\u001a\u00020,H\u0000¢\u0006\u0003\b¢\u0001J\t\u0010£\u0001\u001a\u00020,H\u0002J5\u0010¤\u0001\u001a\u0003H¥\u0001\"\u0005\b\u0000\u0010¥\u00012\u001b\u0010\u009c\u0001\u001a\u0016\u0012\u0004\u0012\u00020R\u0012\u0004\u0012\u00020i\u0012\u0005\u0012\u0003H¥\u00010¦\u0001H\u0082\b¢\u0006\u0003\u0010§\u0001J\u0010\u0010¨\u0001\u001a\u00020,2\u0007\u0010©\u0001\u001a\u00020KJ%\u0010ª\u0001\u001a\u00020,2\u0006\u0010~\u001a\u00020}2\u0006\u0010u\u001a\u00020tH\u0002ø\u0001\u0000¢\u0006\u0006\b«\u0001\u0010¬\u0001J'\u0010\u00ad\u0001\u001a\u00020,2\b\b\u0002\u0010~\u001a\u00020R2\b\b\u0002\u0010u\u001a\u00020iø\u0001\u0000¢\u0006\u0006\b®\u0001\u0010¬\u0001J2\u0010¯\u0001\u001a\u00020,2\b\b\u0002\u0010~\u001a\u00020R2\b\b\u0002\u0010u\u001a\u00020i2\t\b\u0002\u0010°\u0001\u001a\u00020\bø\u0001\u0000¢\u0006\u0006\b±\u0001\u0010²\u0001J\u0011\u0010³\u0001\u001a\u00030´\u0001H\u0086@¢\u0006\u0003\u0010µ\u0001J\u0013\u0010¶\u0001\u001a\u00020,2\b\u0010·\u0001\u001a\u00030¸\u0001H\u0002J\u0014\u0010¹\u0001\u001a\u0004\u0018\u00010\u00152\u0007\u0010©\u0001\u001a\u00020KH\u0002R$\u0010\t\u001a\u00020\b2\u0006\u0010\u0007\u001a\u00020\b8F@FX\u0086\u000e¢\u0006\f\u001a\u0004\b\n\u0010\u000b\"\u0004\b\f\u0010\rR*\u0010\u000f\u001a\u00020\u000e2\u0006\u0010\u0007\u001a\u00020\u000e8F@FX\u0086\u000eø\u0001\u0000ø\u0001\u0001¢\u0006\f\u001a\u0004\b\u0010\u0010\u0011\"\u0004\b\u0012\u0010\u0013R\u0010\u0010\u0014\u001a\u0004\u0018\u00010\u0015X\u0082\u000e¢\u0006\u0002\n\u0000R*\u0010\u0017\u001a\u00020\u00162\u0006\u0010\u0007\u001a\u00020\u00168F@FX\u0086\u000eø\u0001\u0000ø\u0001\u0001¢\u0006\f\u001a\u0004\b\u0018\u0010\u0019\"\u0004\b\u001a\u0010\u001bR$\u0010\u001c\u001a\u00020\b2\u0006\u0010\u0007\u001a\u00020\b8F@FX\u0086\u000e¢\u0006\f\u001a\u0004\b\u001d\u0010\u000b\"\u0004\b\u001e\u0010\rR\u000e\u0010\u001f\u001a\u00020 X\u0082\u0004¢\u0006\u0002\n\u0000R,\u0010\"\u001a\u00020!2\u0006\u0010\u0007\u001a\u00020!8F@FX\u0086\u000e¢\u0006\u0014\n\u0000\u0012\u0004\b#\u0010$\u001a\u0004\b%\u0010&\"\u0004\b'\u0010(R\u001f\u0010)\u001a\u0013\u0012\u0004\u0012\u00020+\u0012\u0004\u0012\u00020,0*¢\u0006\u0002\b-X\u0082\u0004¢\u0006\u0002\n\u0000R(\u0010/\u001a\u0004\u0018\u00010.2\b\u0010\u0007\u001a\u0004\u0018\u00010.8F@FX\u0086\u000e¢\u0006\f\u001a\u0004\b0\u00101\"\u0004\b2\u00103R*\u00105\u001a\u0002042\u0006\u0010\u0007\u001a\u0002048F@FX\u0086\u000eø\u0001\u0000ø\u0001\u0001¢\u0006\f\u001a\u0004\b6\u0010\u0019\"\u0004\b7\u0010\u001bR\u000e\u00108\u001a\u000209X\u0082\u000e¢\u0006\u0002\n\u0000R\u001f\u0010:\u001a\u0013\u0012\u0004\u0012\u00020+\u0012\u0004\u0012\u00020,0*¢\u0006\u0002\b-X\u0082\u000e¢\u0006\u0002\n\u0000R\u0014\u0010\u0002\u001a\u00020\u0003X\u0080\u0004¢\u0006\b\n\u0000\u001a\u0004\b;\u0010<R\u0010\u0010=\u001a\u0004\u0018\u00010>X\u0082\u000e¢\u0006\u0002\n\u0000R\u001e\u0010@\u001a\u00020!2\u0006\u0010?\u001a\u00020!@BX\u0086\u000e¢\u0006\b\n\u0000\u001a\u0004\b@\u0010&R\u0011\u0010A\u001a\u00020B8F¢\u0006\u0006\u001a\u0004\bC\u0010\u0011R\u0010\u0010\u0004\u001a\u0004\u0018\u00010\u0005X\u0082\u0004¢\u0006\u0002\n\u0000R\u000e\u0010D\u001a\u00020EX\u0082\u000e¢\u0006\u0002\n\u0000R\u0011\u0010F\u001a\u00020>8F¢\u0006\u0006\u001a\u0004\bG\u0010HR\u000e\u0010I\u001a\u00020!X\u0082\u000e¢\u0006\u0002\n\u0000R\u0010\u0010J\u001a\u0004\u0018\u00010KX\u0082\u000e¢\u0006\u0002\n\u0000R\u0011\u0010L\u001a\u00020B8F¢\u0006\u0006\u001a\u0004\bM\u0010\u0011R\u000e\u0010N\u001a\u00020OX\u0082\u000e¢\u0006\u0002\n\u0000R\u0010\u0010P\u001a\u0004\u0018\u00010QX\u0082\u000e¢\u0006\u0002\n\u0000R,\u0010S\u001a\u00020R2\u0006\u0010\u0007\u001a\u00020R@FX\u0086\u000eø\u0001\u0000ø\u0001\u0001¢\u0006\u0010\n\u0002\u0010V\u001a\u0004\bT\u0010\u0011\"\u0004\bU\u0010\u0013R(\u0010X\u001a\u0004\u0018\u00010W2\b\u0010\u0007\u001a\u0004\u0018\u00010W8F@FX\u0086\u000e¢\u0006\f\u001a\u0004\bY\u0010Z\"\u0004\b[\u0010\\R$\u0010]\u001a\u00020\b2\u0006\u0010\u0007\u001a\u00020\b8F@FX\u0086\u000e¢\u0006\f\u001a\u0004\b^\u0010\u000b\"\u0004\b_\u0010\rR$\u0010`\u001a\u00020\b2\u0006\u0010\u0007\u001a\u00020\b8F@FX\u0086\u000e¢\u0006\f\u001a\u0004\ba\u0010\u000b\"\u0004\bb\u0010\rR$\u0010c\u001a\u00020\b2\u0006\u0010\u0007\u001a\u00020\b8F@FX\u0086\u000e¢\u0006\f\u001a\u0004\bd\u0010\u000b\"\u0004\be\u0010\rR\u0010\u0010f\u001a\u0004\u0018\u00010KX\u0082\u000e¢\u0006\u0002\n\u0000R\u000e\u0010g\u001a\u00020\bX\u0082\u000e¢\u0006\u0002\n\u0000R\u0016\u0010h\u001a\u00020iX\u0082\u000eø\u0001\u0000ø\u0001\u0001¢\u0006\u0004\n\u0002\u0010VR\u0016\u0010j\u001a\u00020RX\u0082\u000eø\u0001\u0000ø\u0001\u0001¢\u0006\u0004\n\u0002\u0010VR$\u0010k\u001a\u00020\b2\u0006\u0010\u0007\u001a\u00020\b8F@FX\u0086\u000e¢\u0006\f\u001a\u0004\bl\u0010\u000b\"\u0004\bm\u0010\rR$\u0010n\u001a\u00020\b2\u0006\u0010\u0007\u001a\u00020\b8F@FX\u0086\u000e¢\u0006\f\u001a\u0004\bo\u0010\u000b\"\u0004\bp\u0010\rR$\u0010q\u001a\u00020\b2\u0006\u0010\u0007\u001a\u00020\b8F@FX\u0086\u000e¢\u0006\f\u001a\u0004\br\u0010\u000b\"\u0004\bs\u0010\rR,\u0010u\u001a\u00020t2\u0006\u0010\u0007\u001a\u00020t@BX\u0086\u000eø\u0001\u0000ø\u0001\u0001¢\u0006\u0010\n\u0002\u0010V\u001a\u0004\bv\u0010\u0011\"\u0004\bw\u0010\u0013R\u0010\u0010x\u001a\u0004\u0018\u00010yX\u0082\u000e¢\u0006\u0002\n\u0000R*\u0010z\u001a\u00020\u000e2\u0006\u0010\u0007\u001a\u00020\u000e8F@FX\u0086\u000eø\u0001\u0000ø\u0001\u0001¢\u0006\f\u001a\u0004\b{\u0010\u0011\"\u0004\b|\u0010\u0013R-\u0010~\u001a\u00020}2\u0006\u0010\u0007\u001a\u00020}@FX\u0086\u000eø\u0001\u0000ø\u0001\u0001¢\u0006\u0011\n\u0002\u0010V\u001a\u0004\b\u007f\u0010\u0011\"\u0005\b\u0080\u0001\u0010\u0013R'\u0010\u0081\u0001\u001a\u00020\b2\u0006\u0010\u0007\u001a\u00020\b8F@FX\u0086\u000e¢\u0006\u000e\u001a\u0005\b\u0082\u0001\u0010\u000b\"\u0005\b\u0083\u0001\u0010\rR'\u0010\u0084\u0001\u001a\u00020\b2\u0006\u0010\u0007\u001a\u00020\b8F@FX\u0086\u000e¢\u0006\u000e\u001a\u0005\b\u0085\u0001\u0010\u000b\"\u0005\b\u0086\u0001\u0010\rR\u000f\u0010\u0087\u0001\u001a\u00020!X\u0082\u000e¢\u0006\u0002\n\u0000\u0082\u0002\u000b\n\u0005\b¡\u001e0\u0001\n\u0002\b!¨\u0006»\u0001"}, d2 = {"Landroidx/compose/ui/graphics/layer/GraphicsLayer;", "", "impl", "Landroidx/compose/ui/graphics/layer/GraphicsLayerImpl;", "layerManager", "Landroidx/compose/ui/graphics/layer/LayerManager;", "(Landroidx/compose/ui/graphics/layer/GraphicsLayerImpl;Landroidx/compose/ui/graphics/layer/LayerManager;)V", "value", "", "alpha", "getAlpha", "()F", "setAlpha", "(F)V", "Landroidx/compose/ui/graphics/Color;", "ambientShadowColor", "getAmbientShadowColor-0d7_KjU", "()J", "setAmbientShadowColor-8_81llA", "(J)V", "androidOutline", "Landroid/graphics/Outline;", "Landroidx/compose/ui/graphics/BlendMode;", "blendMode", "getBlendMode-0nO6VwU", "()I", "setBlendMode-s9anfk8", "(I)V", "cameraDistance", "getCameraDistance", "setCameraDistance", "childDependenciesTracker", "Landroidx/compose/ui/graphics/layer/ChildLayerDependenciesTracker;", "", "clip", "getClip$annotations", "()V", "getClip", "()Z", "setClip", "(Z)V", "clipDrawBlock", "Lkotlin/Function1;", "Landroidx/compose/ui/graphics/drawscope/DrawScope;", "", "Lkotlin/ExtensionFunctionType;", "Landroidx/compose/ui/graphics/ColorFilter;", "colorFilter", "getColorFilter", "()Landroidx/compose/ui/graphics/ColorFilter;", "setColorFilter", "(Landroidx/compose/ui/graphics/ColorFilter;)V", "Landroidx/compose/ui/graphics/layer/CompositingStrategy;", "compositingStrategy", "getCompositingStrategy-ke2Ky5w", "setCompositingStrategy-Wpw9cng", "density", "Landroidx/compose/ui/unit/Density;", "drawBlock", "getImpl$ui_graphics_release", "()Landroidx/compose/ui/graphics/layer/GraphicsLayerImpl;", "internalOutline", "Landroidx/compose/ui/graphics/Outline;", "<set-?>", "isReleased", "layerId", "", "getLayerId", "layoutDirection", "Landroidx/compose/ui/unit/LayoutDirection;", "outline", "getOutline", "()Landroidx/compose/ui/graphics/Outline;", "outlineDirty", "outlinePath", "Landroidx/compose/ui/graphics/Path;", "ownerViewId", "getOwnerViewId", "parentLayerUsages", "", "pathBounds", "Landroid/graphics/RectF;", "Landroidx/compose/ui/geometry/Offset;", "pivotOffset", "getPivotOffset-F1C5BW0", "setPivotOffset-k-4lQ0M", "J", "Landroidx/compose/ui/graphics/RenderEffect;", "renderEffect", "getRenderEffect", "()Landroidx/compose/ui/graphics/RenderEffect;", "setRenderEffect", "(Landroidx/compose/ui/graphics/RenderEffect;)V", "rotationX", "getRotationX", "setRotationX", "rotationY", "getRotationY", "setRotationY", "rotationZ", "getRotationZ", "setRotationZ", "roundRectClipPath", "roundRectCornerRadius", "roundRectOutlineSize", "Landroidx/compose/ui/geometry/Size;", "roundRectOutlineTopLeft", "scaleX", "getScaleX", "setScaleX", "scaleY", "getScaleY", "setScaleY", "shadowElevation", "getShadowElevation", "setShadowElevation", "Landroidx/compose/ui/unit/IntSize;", "size", "getSize-YbymL2g", "setSize-ozmzZPI", "softwareLayerPaint", "Landroidx/compose/ui/graphics/Paint;", "spotShadowColor", "getSpotShadowColor-0d7_KjU", "setSpotShadowColor-8_81llA", "Landroidx/compose/ui/unit/IntOffset;", "topLeft", "getTopLeft-nOcc-ac", "setTopLeft--gyyYBs", "translationX", "getTranslationX", "setTranslationX", "translationY", "getTranslationY", "setTranslationY", "usePathForClip", "addSubLayer", "graphicsLayer", "configureOutlineAndClip", "discardContentIfReleasedAndHaveNoParentLayerUsages", "discardDisplayList", "discardDisplayList$ui_graphics_release", "draw", "canvas", "Landroidx/compose/ui/graphics/Canvas;", "parentLayer", "draw$ui_graphics_release", "drawForPersistence", "drawForPersistence$ui_graphics_release", "emulateTrimMemory", "emulateTrimMemory$ui_graphics_release", "obtainAndroidOutline", "obtainPathBounds", "onAddedToParentLayer", "onRemovedFromParentLayer", "record", "block", "record-mL-hObY", "(Landroidx/compose/ui/unit/Density;Landroidx/compose/ui/unit/LayoutDirection;JLkotlin/jvm/functions/Function1;)V", "recordInternal", "recreateDisplayListIfNeeded", BuildConfig.BUILD_TYPE, "release$ui_graphics_release", "resetOutlineParams", "resolveOutlinePosition", "T", "Lkotlin/Function2;", "(Lkotlin/jvm/functions/Function2;)Ljava/lang/Object;", "setPathOutline", "path", "setPosition", "setPosition-VbeCjmY", "(JJ)V", "setRectOutline", "setRectOutline-tz77jQw", "setRoundRectOutline", "cornerRadius", "setRoundRectOutline-TNW_H78", "(JJF)V", "toImageBitmap", "Landroidx/compose/ui/graphics/ImageBitmap;", "(Lkotlin/coroutines/Continuation;)Ljava/lang/Object;", "transformCanvas", "androidCanvas", "Landroid/graphics/Canvas;", "updatePathOutline", "Companion", "ui-graphics_release"}, k = 1, mv = {1, 8, 0}, xi = 48)
public final class GraphicsLayer {
    private static final LayerSnapshotImpl SnapshotImpl;
    private Outline androidOutline;
    private boolean clip;
    private final GraphicsLayerImpl impl;
    private androidx.compose.p002ui.graphics.Outline internalOutline;
    private boolean isReleased;
    private final LayerManager layerManager;
    private Path outlinePath;
    private int parentLayerUsages;
    private RectF pathBounds;
    private long pivotOffset;
    private Path roundRectClipPath;
    private float roundRectCornerRadius;
    private long size;
    private Paint softwareLayerPaint;
    private long topLeft;
    private boolean usePathForClip;
    private Density density = DrawContextKt.getDefaultDensity();
    private LayoutDirection layoutDirection = LayoutDirection.Ltr;
    private Function1<? super DrawScope, Unit> drawBlock = new Function1<DrawScope, Unit>() {
        public final void invoke(DrawScope drawScope) {
        }

        public Object invoke(Object obj) {
            invoke((DrawScope) obj);
            return Unit.INSTANCE;
        }
    };
    private final Function1<DrawScope, Unit> clipDrawBlock = new Function1<DrawScope, Unit>() {
        {
            super(1);
        }

        public Object invoke(Object obj) {
            invoke((DrawScope) obj);
            return Unit.INSTANCE;
        }

        public final void invoke(DrawScope drawScope) {
            Path path = this.this$0.outlinePath;
            if (!this.this$0.usePathForClip || !this.this$0.getClip() || path == null) {
                this.this$0.drawBlock.invoke(drawScope);
                return;
            }
            Function1 function1 = this.this$0.drawBlock;
            int iM4579getIntersectrtfAjoo = ClipOp.INSTANCE.m4579getIntersectrtfAjoo();
            DrawContext drawContext = drawScope.getDrawContext();
            long jMo5102getSizeNHjbRc = drawContext.mo5102getSizeNHjbRc();
            drawContext.getCanvas().save();
            try {
                drawContext.getTransform().mo5104clipPathmtrdDE(path, iM4579getIntersectrtfAjoo);
                function1.invoke(drawScope);
            } finally {
                drawContext.getCanvas().restore();
                drawContext.mo5103setSizeuvyYCjk(jMo5102getSizeNHjbRc);
            }
        }
    };
    private boolean outlineDirty = true;
    private long roundRectOutlineTopLeft = Offset.INSTANCE.m4362getZeroF1C5BW0();
    private long roundRectOutlineSize = Size.INSTANCE.m4423getUnspecifiedNHjbRc();
    private final ChildLayerDependenciesTracker childDependenciesTracker = new ChildLayerDependenciesTracker();

    @Metadata(k = 3, mv = {1, 8, 0}, xi = 48)
    @DebugMetadata(c = "androidx.compose.ui.graphics.layer.GraphicsLayer", f = "AndroidGraphicsLayer.android.kt", i = {}, l = {864}, m = "toImageBitmap", n = {}, s = {})
    static final class C16201 extends ContinuationImpl {
        int label;
        Object result;

        C16201(Continuation<? super C16201> continuation) {
            super(continuation);
        }

        public final Object invokeSuspend(Object obj) {
            this.result = obj;
            this.label |= Integer.MIN_VALUE;
            return GraphicsLayer.this.toImageBitmap((Continuation) this);
        }
    }

    public static void getClip$annotations() {
    }

    public GraphicsLayer(GraphicsLayerImpl graphicsLayerImpl, LayerManager layerManager) {
        this.impl = graphicsLayerImpl;
        this.layerManager = layerManager;
        graphicsLayerImpl.setClip(false);
        this.topLeft = IntOffset.Companion.getZero-nOcc-ac();
        this.size = IntSize.Companion.getZero-YbymL2g();
        this.pivotOffset = Offset.INSTANCE.m4361getUnspecifiedF1C5BW0();
    }

    public final GraphicsLayerImpl getImpl() {
        return this.impl;
    }

    public final boolean getIsReleased() {
        return this.isReleased;
    }

    public final int m5272getCompositingStrategyke2Ky5w() {
        return this.impl.getCompositingStrategy();
    }

    public final void m5280setCompositingStrategyWpw9cng(int i) {
        if (CompositingStrategy.m5259equalsimpl0(this.impl.getCompositingStrategy(), i)) {
            return;
        }
        this.impl.mo5293setCompositingStrategyWpw9cng(i);
    }

    public final long getTopLeft() {
        return this.topLeft;
    }

    public final void m5285setTopLeftgyyYBs(long j) {
        if (IntOffset.equals-impl0(this.topLeft, j)) {
            return;
        }
        this.topLeft = j;
        m5266setPositionVbeCjmY(j, this.size);
    }

    public final long getSize() {
        return this.size;
    }

    private final void m5269setSizeozmzZPI(long j) {
        if (IntSize.equals-impl0(this.size, j)) {
            return;
        }
        this.size = j;
        m5266setPositionVbeCjmY(this.topLeft, j);
        if (this.roundRectOutlineSize == InlineClassHelperKt.UnspecifiedPackedFloats) {
            this.outlineDirty = true;
            configureOutlineAndClip();
        }
    }

    public final float getAlpha() {
        return this.impl.getAlpha();
    }

    public final void setAlpha(float f) {
        if (this.impl.getAlpha() == f) {
            return;
        }
        this.impl.setAlpha(f);
    }

    public final int m5271getBlendMode0nO6VwU() {
        return this.impl.getBlendMode();
    }

    public final void m5279setBlendModes9anfk8(int i) {
        if (BlendMode.m4501equalsimpl0(this.impl.getBlendMode(), i)) {
            return;
        }
        this.impl.mo5292setBlendModes9anfk8(i);
    }

    public final ColorFilter getColorFilter() {
        return this.impl.getColorFilter();
    }

    public final void setColorFilter(ColorFilter colorFilter) {
        if (Intrinsics.areEqual(this.impl.getColorFilter(), colorFilter)) {
            return;
        }
        this.impl.setColorFilter(colorFilter);
    }

    public final long getPivotOffset() {
        return this.pivotOffset;
    }

    public final void m5281setPivotOffsetk4lQ0M(long j) {
        if (Offset.m4343equalsimpl0(this.pivotOffset, j)) {
            return;
        }
        this.pivotOffset = j;
        this.impl.mo5295setPivotOffsetk4lQ0M(j);
    }

    public final float getScaleX() {
        return this.impl.getScaleX();
    }

    public final void setScaleX(float f) {
        if (this.impl.getScaleX() == f) {
            return;
        }
        this.impl.setScaleX(f);
    }

    public final float getScaleY() {
        return this.impl.getScaleY();
    }

    public final void setScaleY(float f) {
        if (this.impl.getScaleY() == f) {
            return;
        }
        this.impl.setScaleY(f);
    }

    public final float getTranslationX() {
        return this.impl.getTranslationX();
    }

    public final void setTranslationX(float f) {
        if (this.impl.getTranslationX() == f) {
            return;
        }
        this.impl.setTranslationX(f);
    }

    public final float getTranslationY() {
        return this.impl.getTranslationY();
    }

    public final void setTranslationY(float f) {
        if (this.impl.getTranslationY() == f) {
            return;
        }
        this.impl.setTranslationY(f);
    }

    public final float getShadowElevation() {
        return this.impl.getShadowElevation();
    }

    public final void setShadowElevation(float f) {
        if (this.impl.getShadowElevation() == f) {
            return;
        }
        this.impl.setShadowElevation(f);
        this.outlineDirty = true;
        configureOutlineAndClip();
    }

    public final float getRotationX() {
        return this.impl.getRotationX();
    }

    public final void setRotationX(float f) {
        if (this.impl.getRotationX() == f) {
            return;
        }
        this.impl.setRotationX(f);
    }

    public static void m5268setRoundRectOutlineTNW_H78$default(GraphicsLayer graphicsLayer, long j, long j2, float f, int i, Object obj) {
        if ((i & 1) != 0) {
            j = Offset.INSTANCE.m4362getZeroF1C5BW0();
        }
        long j3 = j;
        if ((i & 2) != 0) {
            j2 = Size.INSTANCE.m4423getUnspecifiedNHjbRc();
        }
        long j4 = j2;
        if ((i & 4) != 0) {
            f = 0.0f;
        }
        graphicsLayer.m5283setRoundRectOutlineTNW_H78(j3, j4, f);
    }

    public final float getRotationY() {
        return this.impl.getRotationY();
    }

    public final void setRotationY(float f) {
        if (this.impl.getRotationY() == f) {
            return;
        }
        this.impl.setRotationY(f);
    }

    public final float getRotationZ() {
        return this.impl.getRotationZ();
    }

    public final void setRotationZ(float f) {
        if (this.impl.getRotationZ() == f) {
            return;
        }
        this.impl.setRotationZ(f);
    }

    public static void m5267setRectOutlinetz77jQw$default(GraphicsLayer graphicsLayer, long j, long j2, int i, Object obj) {
        if ((i & 1) != 0) {
            j = Offset.INSTANCE.m4362getZeroF1C5BW0();
        }
        if ((i & 2) != 0) {
            j2 = Size.INSTANCE.m4423getUnspecifiedNHjbRc();
        }
        graphicsLayer.m5282setRectOutlinetz77jQw(j, j2);
    }

    public final float getCameraDistance() {
        return this.impl.getCameraDistance();
    }

    public final void setCameraDistance(float f) {
        if (this.impl.getCameraDistance() == f) {
            return;
        }
        this.impl.setCameraDistance(f);
    }

    public final boolean getClip() {
        return this.clip;
    }

    public final void setClip(boolean z) {
        if (this.clip != z) {
            this.clip = z;
            this.outlineDirty = true;
            configureOutlineAndClip();
        }
    }

    public final RenderEffect getRenderEffect() {
        return this.impl.getRenderEffect();
    }

    public final void setRenderEffect(RenderEffect renderEffect) {
        if (Intrinsics.areEqual(this.impl.getRenderEffect(), renderEffect)) {
            return;
        }
        this.impl.setRenderEffect(renderEffect);
    }

    private final void m5266setPositionVbeCjmY(long topLeft, long size) {
        this.impl.mo5296setPositionH0pRuoY(IntOffset.getX-impl(topLeft), IntOffset.getY-impl(topLeft), size);
    }

    public final void m5277recordmLhObY(Density density, LayoutDirection layoutDirection, long size, Function1<? super DrawScope, Unit> block) {
        m5269setSizeozmzZPI(size);
        this.density = density;
        this.layoutDirection = layoutDirection;
        this.drawBlock = block;
        this.impl.setInvalidated(true);
        recordInternal();
    }

    private final void recordInternal() {
        ChildLayerDependenciesTracker childLayerDependenciesTracker = this.childDependenciesTracker;
        childLayerDependenciesTracker.oldDependency = childLayerDependenciesTracker.dependency;
        MutableScatterSet mutableScatterSet = childLayerDependenciesTracker.dependenciesSet;
        if (mutableScatterSet != null && mutableScatterSet.isNotEmpty()) {
            MutableScatterSet mutableScatterSetMutableScatterSetOf = childLayerDependenciesTracker.oldDependenciesSet;
            if (mutableScatterSetMutableScatterSetOf == null) {
                mutableScatterSetMutableScatterSetOf = ScatterSetKt.mutableScatterSetOf();
                childLayerDependenciesTracker.oldDependenciesSet = mutableScatterSetMutableScatterSetOf;
            }
            mutableScatterSetMutableScatterSetOf.addAll(mutableScatterSet);
            mutableScatterSet.clear();
        }
        childLayerDependenciesTracker.trackingInProgress = true;
        this.impl.record(this.density, this.layoutDirection, this, this.clipDrawBlock);
        childLayerDependenciesTracker.trackingInProgress = false;
        GraphicsLayer graphicsLayer = childLayerDependenciesTracker.oldDependency;
        if (graphicsLayer != null) {
            graphicsLayer.onRemovedFromParentLayer();
        }
        MutableScatterSet mutableScatterSet2 = childLayerDependenciesTracker.oldDependenciesSet;
        if (mutableScatterSet2 == null || !mutableScatterSet2.isNotEmpty()) {
            return;
        }
        MutableScatterSet mutableScatterSet3 = mutableScatterSet2;
        Object[] objArr = mutableScatterSet3.elements;
        long[] jArr = mutableScatterSet3.metadata;
        int length = jArr.length - 2;
        if (length >= 0) {
            int i = 0;
            while (true) {
                long j = jArr[i];
                if ((((~j) << 7) & j & (-9187201950435737472L)) == -9187201950435737472L) {
                    if (i != length) {
                        break;
                        break;
                    }
                    i++;
                } else {
                    int i2 = 8 - ((~(i - length)) >>> 31);
                    for (int i3 = 0; i3 < i2; i3++) {
                        if ((255 & j) < 128) {
                            ((GraphicsLayer) objArr[(i << 3) + i3]).onRemovedFromParentLayer();
                        }
                        j >>= 8;
                    }
                    if (i2 != 8) {
                        break;
                    } else if (i != length) {
                        break;
                    } else {
                        i++;
                    }
                }
            }
        }
        mutableScatterSet2.clear();
    }

    private final void addSubLayer(GraphicsLayer graphicsLayer) {
        if (this.childDependenciesTracker.onDependencyAdded(graphicsLayer)) {
            graphicsLayer.onAddedToParentLayer();
        }
    }

    private final void transformCanvas(Canvas androidCanvas) {
        float f = IntOffset.getX-impl(this.topLeft);
        float f2 = IntOffset.getY-impl(this.topLeft);
        float f3 = IntOffset.getX-impl(this.topLeft) + IntSize.getWidth-impl(this.size);
        float f4 = IntOffset.getY-impl(this.topLeft) + IntSize.getHeight-impl(this.size);
        float alpha = getAlpha();
        ColorFilter colorFilter = getColorFilter();
        int iM5271getBlendMode0nO6VwU = m5271getBlendMode0nO6VwU();
        if (alpha < 1.0f || !BlendMode.m4501equalsimpl0(iM5271getBlendMode0nO6VwU, BlendMode.INSTANCE.m4532getSrcOver0nO6VwU()) || colorFilter != null || CompositingStrategy.m5259equalsimpl0(m5272getCompositingStrategyke2Ky5w(), CompositingStrategy.INSTANCE.m5265getOffscreenke2Ky5w())) {
            Paint Paint = this.softwareLayerPaint;
            if (Paint == null) {
                Paint = AndroidPaint_androidKt.Paint();
                this.softwareLayerPaint = Paint;
            }
            Paint.setAlpha(alpha);
            Paint.mo4466setBlendModes9anfk8(iM5271getBlendMode0nO6VwU);
            Paint.setColorFilter(colorFilter);
            androidCanvas.saveLayer(f, f2, f3, f4, Paint.getInternalPaint());
        } else {
            androidCanvas.save();
        }
        androidCanvas.translate(f, f2);
        androidCanvas.concat(this.impl.calculateMatrix());
    }

    public final void drawForPersistence$ui_graphics_release(androidx.compose.p002ui.graphics.Canvas canvas) {
        if (AndroidCanvas_androidKt.getNativeCanvas(canvas).isHardwareAccelerated()) {
            recreateDisplayListIfNeeded();
            this.impl.draw(canvas);
        }
    }

    private final void recreateDisplayListIfNeeded() {
        if (this.impl.getHasDisplayList()) {
            return;
        }
        try {
            recordInternal();
        } catch (Throwable unused) {
        }
    }

    public final void draw$ui_graphics_release(androidx.compose.p002ui.graphics.Canvas canvas, GraphicsLayer parentLayer) {
        if (this.isReleased) {
            return;
        }
        configureOutlineAndClip();
        recreateDisplayListIfNeeded();
        boolean z = getShadowElevation() > 0.0f;
        if (z) {
            canvas.enableZ();
        }
        Canvas nativeCanvas = AndroidCanvas_androidKt.getNativeCanvas(canvas);
        boolean zIsHardwareAccelerated = nativeCanvas.isHardwareAccelerated();
        if (!zIsHardwareAccelerated) {
            nativeCanvas.save();
            transformCanvas(nativeCanvas);
        }
        boolean z2 = !zIsHardwareAccelerated && this.clip;
        if (z2) {
            canvas.save();
            androidx.compose.p002ui.graphics.Outline outline = getOutline();
            if (outline instanceof androidx.compose.ui.graphics.Outline.Rectangle) {
                androidx.compose.p002ui.graphics.Canvas.CC.m4564clipRectmtrdDE$default(canvas, outline.getRect(), 0, 2, null);
            } else if (outline instanceof androidx.compose.ui.graphics.Outline.Rounded) {
                Path Path = this.roundRectClipPath;
                if (Path != null) {
                    Path.rewind();
                } else {
                    Path = AndroidPath_androidKt.Path();
                    this.roundRectClipPath = Path;
                }
                Path.CC.addRoundRect$default(Path, ((androidx.compose.ui.graphics.Outline.Rounded) outline).getRoundRect(), null, 2, null);
                androidx.compose.p002ui.graphics.Canvas.CC.m4562clipPathmtrdDE$default(canvas, Path, 0, 2, null);
            } else if (outline instanceof androidx.compose.ui.graphics.Outline.Generic) {
                androidx.compose.p002ui.graphics.Canvas.CC.m4562clipPathmtrdDE$default(canvas, ((androidx.compose.ui.graphics.Outline.Generic) outline).getPath(), 0, 2, null);
            }
        }
        if (parentLayer != null) {
            parentLayer.addSubLayer(this);
        }
        this.impl.draw(canvas);
        if (z2) {
            canvas.restore();
        }
        if (z) {
            canvas.disableZ();
        }
        if (zIsHardwareAccelerated) {
            return;
        }
        nativeCanvas.restore();
    }

    private final void onAddedToParentLayer() {
        this.parentLayerUsages++;
    }

    private final void onRemovedFromParentLayer() {
        this.parentLayerUsages--;
        discardContentIfReleasedAndHaveNoParentLayerUsages();
    }

    private final RectF obtainPathBounds() {
        RectF rectF = this.pathBounds;
        if (rectF != null) {
            return rectF;
        }
        RectF rectF2 = new RectF();
        this.pathBounds = rectF2;
        return rectF2;
    }

    private final void configureOutlineAndClip() {
        if (this.outlineDirty) {
            Outline outline = null;
            if (!this.clip && getShadowElevation() <= 0.0f) {
                this.impl.setClip(false);
                this.impl.mo5294setOutlineO0kMr_c(null, IntSize.Companion.getZero-YbymL2g());
            } else {
                Path path = this.outlinePath;
                if (path != null) {
                    RectF rectFObtainPathBounds = obtainPathBounds();
                    if (path instanceof AndroidPath) {
                        ((AndroidPath) path).getInternalPath().computeBounds(rectFObtainPathBounds, false);
                        Outline outlineUpdatePathOutline = updatePathOutline(path);
                        if (outlineUpdatePathOutline != null) {
                            outlineUpdatePathOutline.setAlpha(getAlpha());
                            outline = outlineUpdatePathOutline;
                        }
                        this.impl.mo5294setOutlineO0kMr_c(outline, IntSizeKt.IntSize(Math.round(rectFObtainPathBounds.width()), Math.round(rectFObtainPathBounds.height())));
                        if (this.usePathForClip && this.clip) {
                            this.impl.setClip(false);
                            this.impl.discardDisplayList();
                        } else {
                            this.impl.setClip(this.clip);
                        }
                    } else {
                        throw new UnsupportedOperationException("Unable to obtain android.graphics.Path");
                    }
                } else {
                    this.impl.setClip(this.clip);
                    Size.INSTANCE.m4424getZeroNHjbRc();
                    Outline outlineObtainAndroidOutline = obtainAndroidOutline();
                    long j = IntSizeKt.toSize-ozmzZPI(this.size);
                    long j2 = this.roundRectOutlineTopLeft;
                    long j3 = this.roundRectOutlineSize;
                    long j4 = j3 == InlineClassHelperKt.UnspecifiedPackedFloats ? j : j3;
                    outlineObtainAndroidOutline.setRoundRect(Math.round(Offset.m4346getXimpl(j2)), Math.round(Offset.m4347getYimpl(j2)), Math.round(Offset.m4346getXimpl(j2) + Size.m4415getWidthimpl(j4)), Math.round(Offset.m4347getYimpl(j2) + Size.m4412getHeightimpl(j4)), this.roundRectCornerRadius);
                    outlineObtainAndroidOutline.setAlpha(getAlpha());
                    this.impl.mo5294setOutlineO0kMr_c(outlineObtainAndroidOutline, IntSizeKt.roundToIntSize-uvyYCjk(j4));
                }
            }
        }
        this.outlineDirty = false;
    }

    private final <T> T resolveOutlinePosition(Function2<? super Offset, ? super Size, ? extends T> block) {
        long j = IntSizeKt.toSize-ozmzZPI(this.size);
        long j2 = this.roundRectOutlineTopLeft;
        long j3 = this.roundRectOutlineSize;
        if (j3 != InlineClassHelperKt.UnspecifiedPackedFloats) {
            j = j3;
        }
        return (T) block.invoke(Offset.m4335boximpl(j2), Size.m4403boximpl(j));
    }

    private final Outline updatePathOutline(Path path) {
        Outline outlineObtainAndroidOutline;
        if (Build.VERSION.SDK_INT > 28 || path.isConvex()) {
            outlineObtainAndroidOutline = obtainAndroidOutline();
            if (Build.VERSION.SDK_INT >= 30) {
                OutlineVerificationHelper.INSTANCE.setPath(outlineObtainAndroidOutline, path);
            } else if (path instanceof AndroidPath) {
                outlineObtainAndroidOutline.setConvexPath(((AndroidPath) path).getInternalPath());
            } else {
                throw new UnsupportedOperationException("Unable to obtain android.graphics.Path");
            }
            this.usePathForClip = !outlineObtainAndroidOutline.canClip();
        } else {
            Outline outline = this.androidOutline;
            if (outline != null) {
                outline.setEmpty();
            }
            this.usePathForClip = true;
            this.impl.setInvalidated(true);
            outlineObtainAndroidOutline = null;
        }
        this.outlinePath = path;
        return outlineObtainAndroidOutline;
    }

    private final Outline obtainAndroidOutline() {
        Outline outline = this.androidOutline;
        if (outline != null) {
            return outline;
        }
        Outline outline2 = new Outline();
        this.androidOutline = outline2;
        return outline2;
    }

    public final void release$ui_graphics_release() {
        if (this.isReleased) {
            return;
        }
        this.isReleased = true;
        discardContentIfReleasedAndHaveNoParentLayerUsages();
    }

    private final void discardContentIfReleasedAndHaveNoParentLayerUsages() {
        if (this.isReleased && this.parentLayerUsages == 0) {
            LayerManager layerManager = this.layerManager;
            if (layerManager != null) {
                layerManager.release(this);
            } else {
                discardDisplayList$ui_graphics_release();
            }
        }
    }

    public final void discardDisplayList$ui_graphics_release() {
        ChildLayerDependenciesTracker childLayerDependenciesTracker = this.childDependenciesTracker;
        GraphicsLayer graphicsLayer = childLayerDependenciesTracker.dependency;
        if (graphicsLayer != null) {
            graphicsLayer.onRemovedFromParentLayer();
            childLayerDependenciesTracker.dependency = null;
        }
        MutableScatterSet mutableScatterSet = childLayerDependenciesTracker.dependenciesSet;
        if (mutableScatterSet != null) {
            MutableScatterSet mutableScatterSet2 = mutableScatterSet;
            Object[] objArr = mutableScatterSet2.elements;
            long[] jArr = mutableScatterSet2.metadata;
            int length = jArr.length - 2;
            if (length >= 0) {
                int i = 0;
                while (true) {
                    long j = jArr[i];
                    if ((((~j) << 7) & j & (-9187201950435737472L)) == -9187201950435737472L) {
                        if (i != length) {
                            break;
                            break;
                        }
                        i++;
                    } else {
                        int i2 = 8 - ((~(i - length)) >>> 31);
                        for (int i3 = 0; i3 < i2; i3++) {
                            if ((255 & j) < 128) {
                                ((GraphicsLayer) objArr[(i << 3) + i3]).onRemovedFromParentLayer();
                            }
                            j >>= 8;
                        }
                        if (i2 != 8) {
                            break;
                        } else if (i != length) {
                            break;
                        } else {
                            i++;
                        }
                    }
                }
            }
            mutableScatterSet.clear();
        }
        this.impl.discardDisplayList();
    }

    public final void emulateTrimMemory$ui_graphics_release() {
        this.impl.discardDisplayList();
    }

    public final long getLayerId() {
        return this.impl.getLayerId();
    }

    public final long getOwnerViewId() {
        return this.impl.getOwnerId();
    }

    public final androidx.compose.p002ui.graphics.Outline getOutline() {
        androidx.compose.ui.graphics.Outline.Rectangle rectangle;
        androidx.compose.p002ui.graphics.Outline outline = this.internalOutline;
        Path path = this.outlinePath;
        if (outline != null) {
            return outline;
        }
        if (path != null) {
            androidx.compose.ui.graphics.Outline.Generic generic = new androidx.compose.ui.graphics.Outline.Generic(path);
            this.internalOutline = generic;
            return generic;
        }
        long j = IntSizeKt.toSize-ozmzZPI(this.size);
        long j2 = this.roundRectOutlineTopLeft;
        long j3 = this.roundRectOutlineSize;
        if (j3 != InlineClassHelperKt.UnspecifiedPackedFloats) {
            j = j3;
        }
        float fM4346getXimpl = Offset.m4346getXimpl(j2);
        float fM4347getYimpl = Offset.m4347getYimpl(j2);
        float fM4415getWidthimpl = fM4346getXimpl + Size.m4415getWidthimpl(j);
        float fM4412getHeightimpl = fM4347getYimpl + Size.m4412getHeightimpl(j);
        float f = this.roundRectCornerRadius;
        if (f > 0.0f) {
            rectangle = new androidx.compose.ui.graphics.Outline.Rounded(RoundRectKt.m4400RoundRectgG7oq9Y(fM4346getXimpl, fM4347getYimpl, fM4415getWidthimpl, fM4412getHeightimpl, CornerRadiusKt.CornerRadius$default(f, 0.0f, 2, null)));
        } else {
            rectangle = new androidx.compose.ui.graphics.Outline.Rectangle(new Rect(fM4346getXimpl, fM4347getYimpl, fM4415getWidthimpl, fM4412getHeightimpl));
        }
        this.internalOutline = rectangle;
        return rectangle;
    }

    private final void resetOutlineParams() {
        this.internalOutline = null;
        this.outlinePath = null;
        this.roundRectOutlineSize = Size.INSTANCE.m4423getUnspecifiedNHjbRc();
        this.roundRectOutlineTopLeft = Offset.INSTANCE.m4362getZeroF1C5BW0();
        this.roundRectCornerRadius = 0.0f;
        this.outlineDirty = true;
        this.usePathForClip = false;
    }

    public final void setPathOutline(Path path) {
        resetOutlineParams();
        this.outlinePath = path;
        configureOutlineAndClip();
    }

    public final void m5283setRoundRectOutlineTNW_H78(long topLeft, long size, float cornerRadius) {
        if (Offset.m4343equalsimpl0(this.roundRectOutlineTopLeft, topLeft) && Size.m4411equalsimpl0(this.roundRectOutlineSize, size) && this.roundRectCornerRadius == cornerRadius && this.outlinePath == null) {
            return;
        }
        resetOutlineParams();
        this.roundRectOutlineTopLeft = topLeft;
        this.roundRectOutlineSize = size;
        this.roundRectCornerRadius = cornerRadius;
        configureOutlineAndClip();
    }

    public final void m5282setRectOutlinetz77jQw(long topLeft, long size) {
        m5283setRoundRectOutlineTNW_H78(topLeft, size, 0.0f);
    }

    public final long m5270getAmbientShadowColor0d7_KjU() {
        return this.impl.getAmbientShadowColor();
    }

    public final void m5278setAmbientShadowColor8_81llA(long j) {
        if (Color.m4591equalsimpl0(j, this.impl.getAmbientShadowColor())) {
            return;
        }
        this.impl.mo5291setAmbientShadowColor8_81llA(j);
    }

    public final long m5275getSpotShadowColor0d7_KjU() {
        return this.impl.getSpotShadowColor();
    }

    public final void m5284setSpotShadowColor8_81llA(long j) {
        if (Color.m4591equalsimpl0(j, this.impl.getSpotShadowColor())) {
            return;
        }
        this.impl.mo5297setSpotShadowColor8_81llA(j);
    }

    public final Object toImageBitmap(Continuation<? super ImageBitmap> continuation) {
        C16201 c16201;
        if (continuation instanceof C16201) {
            c16201 = (C16201) continuation;
            if ((c16201.label & Integer.MIN_VALUE) != 0) {
                c16201.label -= Integer.MIN_VALUE;
            } else {
                c16201 = new C16201(continuation);
            }
        } else {
            c16201 = new C16201(continuation);
        }
        Object bitmap = c16201.result;
        Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
        int i = c16201.label;
        if (i == 0) {
            ResultKt.throwOnFailure(bitmap);
            LayerSnapshotImpl layerSnapshotImpl = SnapshotImpl;
            c16201.label = 1;
            bitmap = layerSnapshotImpl.toBitmap(this, c16201);
            if (bitmap == coroutine_suspended) {
                return coroutine_suspended;
            }
        } else {
            if (i != 1) {
                throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
            }
            ResultKt.throwOnFailure(bitmap);
        }
        return AndroidImageBitmap_androidKt.asImageBitmap((Bitmap) bitmap);
    }

    static {
        LayerSnapshotV21 layerSnapshotV21;
        if (LayerManager.INSTANCE.isRobolectric()) {
            layerSnapshotV21 = LayerSnapshotV21.INSTANCE;
        } else if (Build.VERSION.SDK_INT >= 28) {
            layerSnapshotV21 = LayerSnapshotV28.INSTANCE;
        } else if (SurfaceUtils.INSTANCE.isLockHardwareCanvasAvailable()) {
            layerSnapshotV21 = LayerSnapshotV22.INSTANCE;
        } else {
            layerSnapshotV21 = LayerSnapshotV21.INSTANCE;
        }
        SnapshotImpl = layerSnapshotV21;
    }
}
