package androidx.compose.p002ui.draw;

import androidx.compose.p002ui.graphics.BlockGraphicsLayerModifier;
import androidx.compose.p002ui.graphics.Color;
import androidx.compose.p002ui.graphics.GraphicsLayerScope;
import androidx.compose.p002ui.graphics.Shape;
import androidx.compose.p002ui.node.ModifierNodeElement;
import androidx.compose.p002ui.platform.InspectorInfo;
import androidx.compose.ui.unit.Dp;
import kotlin.Metadata;
import kotlin.UByte$;
import kotlin.Unit;
import kotlin.jvm.functions.Function1;
import kotlin.jvm.internal.DefaultConstructorMarker;
import kotlin.jvm.internal.Intrinsics;

@Metadata(d1 = {"\u0000V\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u000b\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u001a\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0010\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0010\u0000\n\u0000\n\u0002\u0010\b\n\u0000\n\u0002\u0010\u000e\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0000\b\u0080\b\u0018\u00002\b\u0012\u0004\u0012\u00020\u00020\u0001B-\u0012\u0006\u0010\u0003\u001a\u00020\u0004\u0012\u0006\u0010\u0005\u001a\u00020\u0006\u0012\u0006\u0010\u0007\u001a\u00020\b\u0012\u0006\u0010\t\u001a\u00020\n\u0012\u0006\u0010\u000b\u001a\u00020\n¢\u0006\u0002\u0010\fJ\u0016\u0010\u0018\u001a\u00020\u0004HÆ\u0003ø\u0001\u0001ø\u0001\u0000¢\u0006\u0004\b\u0019\u0010\u0013J\t\u0010\u001a\u001a\u00020\u0006HÆ\u0003J\t\u0010\u001b\u001a\u00020\bHÆ\u0003J\u0016\u0010\u001c\u001a\u00020\nHÆ\u0003ø\u0001\u0001ø\u0001\u0000¢\u0006\u0004\b\u001d\u0010\u000eJ\u0016\u0010\u001e\u001a\u00020\nHÆ\u0003ø\u0001\u0001ø\u0001\u0000¢\u0006\u0004\b\u001f\u0010\u000eJE\u0010 \u001a\u00020\u00002\b\b\u0002\u0010\u0003\u001a\u00020\u00042\b\b\u0002\u0010\u0005\u001a\u00020\u00062\b\b\u0002\u0010\u0007\u001a\u00020\b2\b\b\u0002\u0010\t\u001a\u00020\n2\b\b\u0002\u0010\u000b\u001a\u00020\nHÆ\u0001ø\u0001\u0000¢\u0006\u0004\b!\u0010\"J\b\u0010#\u001a\u00020\u0002H\u0016J\u0019\u0010$\u001a\u0013\u0012\u0004\u0012\u00020&\u0012\u0004\u0012\u00020'0%¢\u0006\u0002\b(H\u0002J\u0013\u0010)\u001a\u00020\b2\b\u0010*\u001a\u0004\u0018\u00010+HÖ\u0003J\t\u0010,\u001a\u00020-HÖ\u0001J\t\u0010.\u001a\u00020/HÖ\u0001J\u0010\u00100\u001a\u00020'2\u0006\u00101\u001a\u00020\u0002H\u0016J\f\u00102\u001a\u00020'*\u000203H\u0016R\u0019\u0010\t\u001a\u00020\nø\u0001\u0000ø\u0001\u0001¢\u0006\n\n\u0002\u0010\u000f\u001a\u0004\b\r\u0010\u000eR\u0011\u0010\u0007\u001a\u00020\b¢\u0006\b\n\u0000\u001a\u0004\b\u0010\u0010\u0011R\u0019\u0010\u0003\u001a\u00020\u0004ø\u0001\u0000ø\u0001\u0001¢\u0006\n\n\u0002\u0010\u0014\u001a\u0004\b\u0012\u0010\u0013R\u0011\u0010\u0005\u001a\u00020\u0006¢\u0006\b\n\u0000\u001a\u0004\b\u0015\u0010\u0016R\u0019\u0010\u000b\u001a\u00020\nø\u0001\u0000ø\u0001\u0001¢\u0006\n\n\u0002\u0010\u000f\u001a\u0004\b\u0017\u0010\u000e\u0082\u0002\u000b\n\u0005\b¡\u001e0\u0001\n\u0002\b!¨\u00064"}, d2 = {"Landroidx/compose/ui/draw/ShadowGraphicsLayerElement;", "Landroidx/compose/ui/node/ModifierNodeElement;", "Landroidx/compose/ui/graphics/BlockGraphicsLayerModifier;", "elevation", "Landroidx/compose/ui/unit/Dp;", "shape", "Landroidx/compose/ui/graphics/Shape;", "clip", "", "ambientColor", "Landroidx/compose/ui/graphics/Color;", "spotColor", "(FLandroidx/compose/ui/graphics/Shape;ZJJLkotlin/jvm/internal/DefaultConstructorMarker;)V", "getAmbientColor-0d7_KjU", "()J", "J", "getClip", "()Z", "getElevation-D9Ej5fM", "()F", "F", "getShape", "()Landroidx/compose/ui/graphics/Shape;", "getSpotColor-0d7_KjU", "component1", "component1-D9Ej5fM", "component2", "component3", "component4", "component4-0d7_KjU", "component5", "component5-0d7_KjU", "copy", "copy-gNMxBKI", "(FLandroidx/compose/ui/graphics/Shape;ZJJ)Landroidx/compose/ui/draw/ShadowGraphicsLayerElement;", "create", "createBlock", "Lkotlin/Function1;", "Landroidx/compose/ui/graphics/GraphicsLayerScope;", "", "Lkotlin/ExtensionFunctionType;", "equals", "other", "", "hashCode", "", "toString", "", "update", "node", "inspectableProperties", "Landroidx/compose/ui/platform/InspectorInfo;", "ui_release"}, k = 1, mv = {1, 8, 0}, xi = 48)
public final class ShadowGraphicsLayerElement extends ModifierNodeElement<BlockGraphicsLayerModifier> {
    public static final int $stable = 0;
    private final long ambientColor;
    private final boolean clip;
    private final float elevation;
    private final Shape shape;
    private final long spotColor;

    public ShadowGraphicsLayerElement(float f, Shape shape, boolean z, long j, long j2, DefaultConstructorMarker defaultConstructorMarker) {
        this(f, shape, z, j, j2);
    }

    public static ShadowGraphicsLayerElement m4235copygNMxBKI$default(ShadowGraphicsLayerElement shadowGraphicsLayerElement, float f, Shape shape, boolean z, long j, long j2, int i, Object obj) {
        if ((i & 1) != 0) {
            f = shadowGraphicsLayerElement.elevation;
        }
        if ((i & 2) != 0) {
            shape = shadowGraphicsLayerElement.shape;
        }
        Shape shape2 = shape;
        if ((i & 4) != 0) {
            z = shadowGraphicsLayerElement.clip;
        }
        boolean z2 = z;
        if ((i & 8) != 0) {
            j = shadowGraphicsLayerElement.ambientColor;
        }
        long j3 = j;
        if ((i & 16) != 0) {
            j2 = shadowGraphicsLayerElement.spotColor;
        }
        return shadowGraphicsLayerElement.m4239copygNMxBKI(f, shape2, z2, j3, j2);
    }

    public final float getElevation() {
        return this.elevation;
    }

    public final Shape getShape() {
        return this.shape;
    }

    public final boolean getClip() {
        return this.clip;
    }

    public final long getAmbientColor() {
        return this.ambientColor;
    }

    public final long getSpotColor() {
        return this.spotColor;
    }

    public final ShadowGraphicsLayerElement m4239copygNMxBKI(float elevation, Shape shape, boolean clip, long ambientColor, long spotColor) {
        return new ShadowGraphicsLayerElement(elevation, shape, clip, ambientColor, spotColor, null);
    }

    @Override
    public boolean equals(Object other) {
        if (this == other) {
            return true;
        }
        if (!(other instanceof ShadowGraphicsLayerElement)) {
            return false;
        }
        ShadowGraphicsLayerElement shadowGraphicsLayerElement = (ShadowGraphicsLayerElement) other;
        return Dp.equals-impl0(this.elevation, shadowGraphicsLayerElement.elevation) && Intrinsics.areEqual(this.shape, shadowGraphicsLayerElement.shape) && this.clip == shadowGraphicsLayerElement.clip && Color.m4591equalsimpl0(this.ambientColor, shadowGraphicsLayerElement.ambientColor) && Color.m4591equalsimpl0(this.spotColor, shadowGraphicsLayerElement.spotColor);
    }

    @Override
    public int hashCode() {
        return (((((((Dp.hashCode-impl(this.elevation) * 31) + this.shape.hashCode()) * 31) + UByte$.ExternalSyntheticBackport0.m(this.clip)) * 31) + Color.m4597hashCodeimpl(this.ambientColor)) * 31) + Color.m4597hashCodeimpl(this.spotColor);
    }

    public String toString() {
        return "ShadowGraphicsLayerElement(elevation=" + ((Object) Dp.toString-impl(this.elevation)) + ", shape=" + this.shape + ", clip=" + this.clip + ", ambientColor=" + ((Object) Color.m4598toStringimpl(this.ambientColor)) + ", spotColor=" + ((Object) Color.m4598toStringimpl(this.spotColor)) + ')';
    }

    public final float m4241getElevationD9Ej5fM() {
        return this.elevation;
    }

    public final Shape getShape() {
        return this.shape;
    }

    public final boolean getClip() {
        return this.clip;
    }

    public final long m4240getAmbientColor0d7_KjU() {
        return this.ambientColor;
    }

    public final long m4242getSpotColor0d7_KjU() {
        return this.spotColor;
    }

    private ShadowGraphicsLayerElement(float f, Shape shape, boolean z, long j, long j2) {
        this.elevation = f;
        this.shape = shape;
        this.clip = z;
        this.ambientColor = j;
        this.spotColor = j2;
    }

    private final Function1<GraphicsLayerScope, Unit> createBlock() {
        return new Function1<GraphicsLayerScope, Unit>() {
            {
                super(1);
            }

            public Object invoke(Object obj) {
                invoke((GraphicsLayerScope) obj);
                return Unit.INSTANCE;
            }

            public final void invoke(GraphicsLayerScope graphicsLayerScope) {
                graphicsLayerScope.setShadowElevation(graphicsLayerScope.toPx-0680j_4(ShadowGraphicsLayerElement.this.m4241getElevationD9Ej5fM()));
                graphicsLayerScope.setShape(ShadowGraphicsLayerElement.this.getShape());
                graphicsLayerScope.setClip(ShadowGraphicsLayerElement.this.getClip());
                graphicsLayerScope.mo4761setAmbientShadowColor8_81llA(ShadowGraphicsLayerElement.this.m4240getAmbientColor0d7_KjU());
                graphicsLayerScope.mo4763setSpotShadowColor8_81llA(ShadowGraphicsLayerElement.this.m4242getSpotColor0d7_KjU());
            }
        };
    }

    @Override
    public BlockGraphicsLayerModifier getNode() {
        return new BlockGraphicsLayerModifier(createBlock());
    }

    @Override
    public void update(BlockGraphicsLayerModifier node) {
        node.setLayerBlock(createBlock());
        node.invalidateLayerBlock();
    }

    @Override
    public void inspectableProperties(InspectorInfo inspectorInfo) {
        inspectorInfo.setName("shadow");
        inspectorInfo.getProperties().set("elevation", Dp.box-impl(this.elevation));
        inspectorInfo.getProperties().set("shape", this.shape);
        inspectorInfo.getProperties().set("clip", Boolean.valueOf(this.clip));
        inspectorInfo.getProperties().set("ambientColor", Color.m4580boximpl(this.ambientColor));
        inspectorInfo.getProperties().set("spotColor", Color.m4580boximpl(this.spotColor));
    }
}
