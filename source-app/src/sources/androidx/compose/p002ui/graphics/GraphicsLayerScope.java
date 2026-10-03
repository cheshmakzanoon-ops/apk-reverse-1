package androidx.compose.p002ui.graphics;

import androidx.compose.p002ui.geometry.Rect;
import androidx.compose.p002ui.geometry.Size;
import androidx.compose.p002ui.layout.PlacementScopeMarker;
import androidx.compose.ui.unit.Density;
import androidx.compose.ui.unit.DpRect;
import androidx.compose.ui.unit.FontScaling;
import kotlin.Metadata;

@Metadata(d1 = {"\u0000J\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u0007\n\u0002\b\u0005\n\u0002\u0018\u0002\n\u0002\b\b\n\u0002\u0010\u000b\n\u0002\b\u0007\n\u0002\u0018\u0002\n\u0002\b\u0005\n\u0002\u0018\u0002\n\u0002\b\u0018\n\u0002\u0018\u0002\n\u0002\b\u0005\n\u0002\u0018\u0002\n\u0002\b\u0005\n\u0002\u0018\u0002\n\u0002\b\t\bg\u0018\u00002\u00020\u0001R\u0018\u0010\u0002\u001a\u00020\u0003X¦\u000e¢\u0006\f\u001a\u0004\b\u0004\u0010\u0005\"\u0004\b\u0006\u0010\u0007R*\u0010\b\u001a\u00020\t2\u0006\u0010\b\u001a\u00020\t8V@VX\u0096\u000eø\u0001\u0000ø\u0001\u0001¢\u0006\f\u001a\u0004\b\n\u0010\u000b\"\u0004\b\f\u0010\rR\u0018\u0010\u000e\u001a\u00020\u0003X¦\u000e¢\u0006\f\u001a\u0004\b\u000f\u0010\u0005\"\u0004\b\u0010\u0010\u0007R \u0010\u0011\u001a\u00020\u00128fX¦\u000e¢\u0006\u0012\u0012\u0004\b\u0013\u0010\u0014\u001a\u0004\b\u0015\u0010\u0016\"\u0004\b\u0017\u0010\u0018R*\u0010\u0019\u001a\u00020\u001a2\u0006\u0010\u0019\u001a\u00020\u001a8V@VX\u0096\u000eø\u0001\u0000ø\u0001\u0001¢\u0006\f\u001a\u0004\b\u001b\u0010\u001c\"\u0004\b\u001d\u0010\u001eR(\u0010!\u001a\u0004\u0018\u00010 2\b\u0010\u001f\u001a\u0004\u0018\u00010 8V@VX\u0096\u000e¢\u0006\f\u001a\u0004\b\"\u0010#\"\u0004\b$\u0010%R\u0018\u0010&\u001a\u00020\u0003X¦\u000e¢\u0006\f\u001a\u0004\b'\u0010\u0005\"\u0004\b(\u0010\u0007R\u0018\u0010)\u001a\u00020\u0003X¦\u000e¢\u0006\f\u001a\u0004\b*\u0010\u0005\"\u0004\b+\u0010\u0007R\u0018\u0010,\u001a\u00020\u0003X¦\u000e¢\u0006\f\u001a\u0004\b-\u0010\u0005\"\u0004\b.\u0010\u0007R\u0018\u0010/\u001a\u00020\u0003X¦\u000e¢\u0006\f\u001a\u0004\b0\u0010\u0005\"\u0004\b1\u0010\u0007R\u0018\u00102\u001a\u00020\u0003X¦\u000e¢\u0006\f\u001a\u0004\b3\u0010\u0005\"\u0004\b4\u0010\u0007R\u0018\u00105\u001a\u00020\u0003X¦\u000e¢\u0006\f\u001a\u0004\b6\u0010\u0005\"\u0004\b7\u0010\u0007R\u0018\u00108\u001a\u000209X¦\u000e¢\u0006\f\u001a\u0004\b:\u0010;\"\u0004\b<\u0010=R\u001a\u0010>\u001a\u00020?8VX\u0096\u0004ø\u0001\u0000ø\u0001\u0001¢\u0006\u0006\u001a\u0004\b@\u0010\u000bR*\u0010A\u001a\u00020\t2\u0006\u0010A\u001a\u00020\t8V@VX\u0096\u000eø\u0001\u0000ø\u0001\u0001¢\u0006\f\u001a\u0004\bB\u0010\u000b\"\u0004\bC\u0010\rR\u001e\u0010D\u001a\u00020EX¦\u000eø\u0001\u0000ø\u0001\u0001¢\u0006\f\u001a\u0004\bF\u0010\u000b\"\u0004\bG\u0010\rR\u0018\u0010H\u001a\u00020\u0003X¦\u000e¢\u0006\f\u001a\u0004\bI\u0010\u0005\"\u0004\bJ\u0010\u0007R\u0018\u0010K\u001a\u00020\u0003X¦\u000e¢\u0006\f\u001a\u0004\bL\u0010\u0005\"\u0004\bM\u0010\u0007ø\u0001\u0002\u0082\u0002\u0011\n\u0005\b¡\u001e0\u0001\n\u0002\b!\n\u0004\b!0\u0001¨\u0006NÀ\u0006\u0003"}, d2 = {"Landroidx/compose/ui/graphics/GraphicsLayerScope;", "Landroidx/compose/ui/unit/Density;", "alpha", "", "getAlpha", "()F", "setAlpha", "(F)V", "ambientShadowColor", "Landroidx/compose/ui/graphics/Color;", "getAmbientShadowColor-0d7_KjU", "()J", "setAmbientShadowColor-8_81llA", "(J)V", "cameraDistance", "getCameraDistance", "setCameraDistance", "clip", "", "getClip$annotations", "()V", "getClip", "()Z", "setClip", "(Z)V", "compositingStrategy", "Landroidx/compose/ui/graphics/CompositingStrategy;", "getCompositingStrategy--NrFUSI", "()I", "setCompositingStrategy-aDBOjCE", "(I)V", "<anonymous parameter 0>", "Landroidx/compose/ui/graphics/RenderEffect;", "renderEffect", "getRenderEffect", "()Landroidx/compose/ui/graphics/RenderEffect;", "setRenderEffect", "(Landroidx/compose/ui/graphics/RenderEffect;)V", "rotationX", "getRotationX", "setRotationX", "rotationY", "getRotationY", "setRotationY", "rotationZ", "getRotationZ", "setRotationZ", "scaleX", "getScaleX", "setScaleX", "scaleY", "getScaleY", "setScaleY", "shadowElevation", "getShadowElevation", "setShadowElevation", "shape", "Landroidx/compose/ui/graphics/Shape;", "getShape", "()Landroidx/compose/ui/graphics/Shape;", "setShape", "(Landroidx/compose/ui/graphics/Shape;)V", "size", "Landroidx/compose/ui/geometry/Size;", "getSize-NH-jbRc", "spotShadowColor", "getSpotShadowColor-0d7_KjU", "setSpotShadowColor-8_81llA", "transformOrigin", "Landroidx/compose/ui/graphics/TransformOrigin;", "getTransformOrigin-SzJe1aQ", "setTransformOrigin-__ExYCQ", "translationX", "getTranslationX", "setTranslationX", "translationY", "getTranslationY", "setTranslationY", "ui_release"}, k = 1, mv = {1, 8, 0}, xi = 48)
@PlacementScopeMarker
public interface GraphicsLayerScope extends Density {
    float getAlpha();

    long mo4756getAmbientShadowColor0d7_KjU();

    float getCameraDistance();

    boolean getClip();

    int mo4757getCompositingStrategyNrFUSI();

    RenderEffect getRenderEffect();

    float getRotationX();

    float getRotationY();

    float getRotationZ();

    float getScaleX();

    float getScaleY();

    float getShadowElevation();

    Shape getShape();

    long mo4758getSizeNHjbRc();

    long mo4759getSpotShadowColor0d7_KjU();

    long mo4760getTransformOriginSzJe1aQ();

    float getTranslationX();

    float getTranslationY();

    void setAlpha(float f);

    void mo4761setAmbientShadowColor8_81llA(long j);

    void setCameraDistance(float f);

    void setClip(boolean z);

    void mo4762setCompositingStrategyaDBOjCE(int i);

    void setRenderEffect(RenderEffect renderEffect);

    void setRotationX(float f);

    void setRotationY(float f);

    void setRotationZ(float f);

    void setScaleX(float f);

    void setScaleY(float f);

    void setShadowElevation(float f);

    void setShape(Shape shape);

    void mo4763setSpotShadowColor8_81llA(long j);

    void mo4764setTransformOrigin__ExYCQ(long j);

    void setTranslationX(float f);

    void setTranslationY(float f);

    public final class CC {
        public static RenderEffect $default$getRenderEffect(GraphicsLayerScope _this) {
            return null;
        }

        public static void m4769$default$setAmbientShadowColor8_81llA(GraphicsLayerScope _this, long j) {
        }

        public static void m4770$default$setCompositingStrategyaDBOjCE(GraphicsLayerScope _this, int i) {
        }

        public static void $default$setRenderEffect(GraphicsLayerScope _this, RenderEffect renderEffect) {
        }

        public static void m4771$default$setSpotShadowColor8_81llA(GraphicsLayerScope _this, long j) {
        }

        public static long m4765$default$getAmbientShadowColor0d7_KjU(GraphicsLayerScope _this) {
            return GraphicsLayerScopeKt.getDefaultShadowColor();
        }

        public static long m4768$default$getSpotShadowColor0d7_KjU(GraphicsLayerScope _this) {
            return GraphicsLayerScopeKt.getDefaultShadowColor();
        }

        public static int m4766$default$getCompositingStrategyNrFUSI(GraphicsLayerScope _this) {
            return CompositingStrategy.INSTANCE.m4679getAutoNrFUSI();
        }

        public static long m4767$default$getSizeNHjbRc(GraphicsLayerScope _this) {
            return Size.INSTANCE.m4423getUnspecifiedNHjbRc();
        }
    }

    @Metadata(k = 3, mv = {1, 8, 0}, xi = 48)
    public static final class DefaultImpls {
        public static void getClip$annotations() {
        }

        @Deprecated
        public static int m4795roundToPxR2X_6o(GraphicsLayerScope graphicsLayerScope, long j) {
            return Density.-CC.$default$roundToPx--R2X_6o(graphicsLayerScope, j);
        }

        @Deprecated
        public static int m4796roundToPx0680j_4(GraphicsLayerScope graphicsLayerScope, float f) {
            return Density.-CC.$default$roundToPx-0680j_4(graphicsLayerScope, f);
        }

        @Deprecated
        public static float m4800toDpGaN1DYA(GraphicsLayerScope graphicsLayerScope, long j) {
            return FontScaling.-CC.$default$toDp-GaN1DYA(graphicsLayerScope, j);
        }

        @Deprecated
        public static float m4801toDpu2uoSUM(GraphicsLayerScope graphicsLayerScope, float f) {
            return Density.-CC.$default$toDp-u2uoSUM(graphicsLayerScope, f);
        }

        @Deprecated
        public static float m4802toDpu2uoSUM(GraphicsLayerScope graphicsLayerScope, int i) {
            return Density.-CC.$default$toDp-u2uoSUM(graphicsLayerScope, i);
        }

        @Deprecated
        public static long m4803toDpSizekrfVVM(GraphicsLayerScope graphicsLayerScope, long j) {
            return Density.-CC.$default$toDpSize-k-rfVVM(graphicsLayerScope, j);
        }

        @Deprecated
        public static float m4804toPxR2X_6o(GraphicsLayerScope graphicsLayerScope, long j) {
            return Density.-CC.$default$toPx--R2X_6o(graphicsLayerScope, j);
        }

        @Deprecated
        public static float m4805toPx0680j_4(GraphicsLayerScope graphicsLayerScope, float f) {
            return Density.-CC.$default$toPx-0680j_4(graphicsLayerScope, f);
        }

        @Deprecated
        public static Rect toRect(GraphicsLayerScope graphicsLayerScope, DpRect dpRect) {
            return Density.-CC.$default$toRect(graphicsLayerScope, dpRect);
        }

        @Deprecated
        public static long m4806toSizeXkaWNTQ(GraphicsLayerScope graphicsLayerScope, long j) {
            return Density.-CC.$default$toSize-XkaWNTQ(graphicsLayerScope, j);
        }

        @Deprecated
        public static long m4807toSp0xMU5do(GraphicsLayerScope graphicsLayerScope, float f) {
            return FontScaling.-CC.$default$toSp-0xMU5do(graphicsLayerScope, f);
        }

        @Deprecated
        public static long m4808toSpkPz2Gy4(GraphicsLayerScope graphicsLayerScope, float f) {
            return Density.-CC.$default$toSp-kPz2Gy4(graphicsLayerScope, f);
        }

        @Deprecated
        public static long m4809toSpkPz2Gy4(GraphicsLayerScope graphicsLayerScope, int i) {
            return Density.-CC.$default$toSp-kPz2Gy4(graphicsLayerScope, i);
        }

        @Deprecated
        public static long m4791getAmbientShadowColor0d7_KjU(GraphicsLayerScope graphicsLayerScope) {
            return CC.m4765$default$getAmbientShadowColor0d7_KjU(graphicsLayerScope);
        }

        @Deprecated
        public static void m4797setAmbientShadowColor8_81llA(GraphicsLayerScope graphicsLayerScope, long j) {
            CC.m4769$default$setAmbientShadowColor8_81llA(graphicsLayerScope, j);
        }

        @Deprecated
        public static long m4794getSpotShadowColor0d7_KjU(GraphicsLayerScope graphicsLayerScope) {
            return CC.m4768$default$getSpotShadowColor0d7_KjU(graphicsLayerScope);
        }

        @Deprecated
        public static void m4799setSpotShadowColor8_81llA(GraphicsLayerScope graphicsLayerScope, long j) {
            CC.m4771$default$setSpotShadowColor8_81llA(graphicsLayerScope, j);
        }

        @Deprecated
        public static RenderEffect getRenderEffect(GraphicsLayerScope graphicsLayerScope) {
            return CC.$default$getRenderEffect(graphicsLayerScope);
        }

        @Deprecated
        public static void setRenderEffect(GraphicsLayerScope graphicsLayerScope, RenderEffect renderEffect) {
            CC.$default$setRenderEffect(graphicsLayerScope, renderEffect);
        }

        @Deprecated
        public static int m4792getCompositingStrategyNrFUSI(GraphicsLayerScope graphicsLayerScope) {
            return CC.m4766$default$getCompositingStrategyNrFUSI(graphicsLayerScope);
        }

        @Deprecated
        public static void m4798setCompositingStrategyaDBOjCE(GraphicsLayerScope graphicsLayerScope, int i) {
            CC.m4770$default$setCompositingStrategyaDBOjCE(graphicsLayerScope, i);
        }

        @Deprecated
        public static long m4793getSizeNHjbRc(GraphicsLayerScope graphicsLayerScope) {
            return CC.m4767$default$getSizeNHjbRc(graphicsLayerScope);
        }
    }
}
