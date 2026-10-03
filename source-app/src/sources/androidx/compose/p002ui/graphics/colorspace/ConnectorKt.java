package androidx.compose.p002ui.graphics.colorspace;

import androidx.collection.IntObjectMapKt;
import androidx.collection.MutableIntObjectMap;
import kotlin.Metadata;
import kotlin.jvm.internal.DefaultConstructorMarker;

@Metadata(d1 = {"\u0000\u001e\n\u0000\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0010\b\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0002\b\u0003\u001a+\u0010\u0005\u001a\u00020\u00062\u0006\u0010\u0007\u001a\u00020\u00062\u0006\u0010\b\u001a\u00020\u00062\u0006\u0010\t\u001a\u00020\nH\u0080\bø\u0001\u0000¢\u0006\u0004\b\u000b\u0010\f\"\u001a\u0010\u0000\u001a\b\u0012\u0004\u0012\u00020\u00020\u0001X\u0080\u0004¢\u0006\b\n\u0000\u001a\u0004\b\u0003\u0010\u0004\u0082\u0002\u0007\n\u0005\b¡\u001e0\u0001¨\u0006\r"}, d2 = {"Connectors", "Landroidx/collection/MutableIntObjectMap;", "Landroidx/compose/ui/graphics/colorspace/Connector;", "getConnectors", "()Landroidx/collection/MutableIntObjectMap;", "connectorKey", "", "src", "dst", "renderIntent", "Landroidx/compose/ui/graphics/colorspace/RenderIntent;", "connectorKey-YBCOT_4", "(III)I", "ui-graphics_release"}, k = 2, mv = {1, 8, 0}, xi = 48)
public final class ConnectorKt {
    private static final MutableIntObjectMap<Connector> Connectors;

    public static final int m5036connectorKeyYBCOT_4(int i, int i2, int i3) {
        return i | (i2 << 6) | (i3 << 12);
    }

    public static final MutableIntObjectMap<Connector> getConnectors() {
        return Connectors;
    }

    static {
        DefaultConstructorMarker defaultConstructorMarker = null;
        Connectors = IntObjectMapKt.mutableIntObjectMapOf(ColorSpaces.INSTANCE.getSrgb().getId() | (ColorSpaces.INSTANCE.getSrgb().getId() << 6) | (RenderIntent.INSTANCE.m5045getPerceptualuksYyKA() << 12), Connector.INSTANCE.identity$ui_graphics_release(ColorSpaces.INSTANCE.getSrgb()), ColorSpaces.INSTANCE.getSrgb().getId() | (ColorSpaces.INSTANCE.getOklab().getId() << 6) | (RenderIntent.INSTANCE.m5045getPerceptualuksYyKA() << 12), new Connector(ColorSpaces.INSTANCE.getSrgb(), ColorSpaces.INSTANCE.getOklab(), RenderIntent.INSTANCE.m5045getPerceptualuksYyKA(), defaultConstructorMarker), ColorSpaces.INSTANCE.getOklab().getId() | (ColorSpaces.INSTANCE.getSrgb().getId() << 6) | (RenderIntent.INSTANCE.m5045getPerceptualuksYyKA() << 12), new Connector(ColorSpaces.INSTANCE.getOklab(), ColorSpaces.INSTANCE.getSrgb(), RenderIntent.INSTANCE.m5045getPerceptualuksYyKA(), defaultConstructorMarker));
    }
}
