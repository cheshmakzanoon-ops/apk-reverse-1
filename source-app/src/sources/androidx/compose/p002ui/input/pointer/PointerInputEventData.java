package androidx.compose.p002ui.input.pointer;

import androidx.compose.p002ui.geometry.Offset;
import androidx.compose.p002ui.graphics.Fields;
import java.util.ArrayList;
import java.util.List;
import kotlin.Metadata;
import kotlin.UByte$;
import kotlin.jvm.internal.DefaultConstructorMarker;
import kotlin.jvm.internal.Intrinsics;

@Metadata(d1 = {"\u0000J\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\t\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0010\u000b\n\u0000\n\u0002\u0010\u0007\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0010 \n\u0002\u0018\u0002\n\u0002\b,\n\u0002\u0010\b\n\u0000\n\u0002\u0010\u000e\n\u0000\b\u0080\b\u0018\u00002\u00020\u0001Bk\u0012\u0006\u0010\u0002\u001a\u00020\u0003\u0012\u0006\u0010\u0004\u001a\u00020\u0005\u0012\u0006\u0010\u0006\u001a\u00020\u0007\u0012\u0006\u0010\b\u001a\u00020\u0007\u0012\u0006\u0010\t\u001a\u00020\n\u0012\u0006\u0010\u000b\u001a\u00020\f\u0012\u0006\u0010\r\u001a\u00020\u000e\u0012\b\b\u0002\u0010\u000f\u001a\u00020\n\u0012\u000e\b\u0002\u0010\u0010\u001a\b\u0012\u0004\u0012\u00020\u00120\u0011\u0012\b\b\u0002\u0010\u0013\u001a\u00020\u0007\u0012\b\b\u0002\u0010\u0014\u001a\u00020\u0007¢\u0006\u0002\u0010\u0015J\u0016\u0010(\u001a\u00020\u0003HÆ\u0003ø\u0001\u0001ø\u0001\u0000¢\u0006\u0004\b)\u0010\u001cJ\u0016\u0010*\u001a\u00020\u0007HÆ\u0003ø\u0001\u0001ø\u0001\u0000¢\u0006\u0004\b+\u0010\u001cJ\u0016\u0010,\u001a\u00020\u0007HÆ\u0003ø\u0001\u0001ø\u0001\u0000¢\u0006\u0004\b-\u0010\u001cJ\t\u0010.\u001a\u00020\u0005HÆ\u0003J\u0016\u0010/\u001a\u00020\u0007HÆ\u0003ø\u0001\u0001ø\u0001\u0000¢\u0006\u0004\b0\u0010\u001cJ\u0016\u00101\u001a\u00020\u0007HÆ\u0003ø\u0001\u0001ø\u0001\u0000¢\u0006\u0004\b2\u0010\u001cJ\t\u00103\u001a\u00020\nHÆ\u0003J\t\u00104\u001a\u00020\fHÆ\u0003J\u0016\u00105\u001a\u00020\u000eHÆ\u0003ø\u0001\u0001ø\u0001\u0000¢\u0006\u0004\b6\u0010%J\t\u00107\u001a\u00020\nHÆ\u0003J\u000f\u00108\u001a\b\u0012\u0004\u0012\u00020\u00120\u0011HÆ\u0003J\u0087\u0001\u00109\u001a\u00020\u00002\b\b\u0002\u0010\u0002\u001a\u00020\u00032\b\b\u0002\u0010\u0004\u001a\u00020\u00052\b\b\u0002\u0010\u0006\u001a\u00020\u00072\b\b\u0002\u0010\b\u001a\u00020\u00072\b\b\u0002\u0010\t\u001a\u00020\n2\b\b\u0002\u0010\u000b\u001a\u00020\f2\b\b\u0002\u0010\r\u001a\u00020\u000e2\b\b\u0002\u0010\u000f\u001a\u00020\n2\u000e\b\u0002\u0010\u0010\u001a\b\u0012\u0004\u0012\u00020\u00120\u00112\b\b\u0002\u0010\u0013\u001a\u00020\u00072\b\b\u0002\u0010\u0014\u001a\u00020\u0007HÆ\u0001ø\u0001\u0000¢\u0006\u0004\b:\u0010;J\u0013\u0010<\u001a\u00020\n2\b\u0010=\u001a\u0004\u0018\u00010\u0001HÖ\u0003J\t\u0010>\u001a\u00020?HÖ\u0001J\t\u0010@\u001a\u00020AHÖ\u0001R\u0011\u0010\u000f\u001a\u00020\n¢\u0006\b\n\u0000\u001a\u0004\b\u0016\u0010\u0017R\u0011\u0010\t\u001a\u00020\n¢\u0006\b\n\u0000\u001a\u0004\b\u0018\u0010\u0017R\u0017\u0010\u0010\u001a\b\u0012\u0004\u0012\u00020\u00120\u0011¢\u0006\b\n\u0000\u001a\u0004\b\u0019\u0010\u001aR\u0019\u0010\u0002\u001a\u00020\u0003ø\u0001\u0000ø\u0001\u0001¢\u0006\n\n\u0002\u0010\u001d\u001a\u0004\b\u001b\u0010\u001cR\u0019\u0010\u0014\u001a\u00020\u0007ø\u0001\u0000ø\u0001\u0001¢\u0006\n\n\u0002\u0010\u001d\u001a\u0004\b\u001e\u0010\u001cR\u0019\u0010\b\u001a\u00020\u0007ø\u0001\u0000ø\u0001\u0001¢\u0006\n\n\u0002\u0010\u001d\u001a\u0004\b\u001f\u0010\u001cR\u0019\u0010\u0006\u001a\u00020\u0007ø\u0001\u0000ø\u0001\u0001¢\u0006\n\n\u0002\u0010\u001d\u001a\u0004\b \u0010\u001cR\u0011\u0010\u000b\u001a\u00020\f¢\u0006\b\n\u0000\u001a\u0004\b!\u0010\"R\u0019\u0010\u0013\u001a\u00020\u0007ø\u0001\u0000ø\u0001\u0001¢\u0006\n\n\u0002\u0010\u001d\u001a\u0004\b#\u0010\u001cR\u0019\u0010\r\u001a\u00020\u000eø\u0001\u0000ø\u0001\u0001¢\u0006\n\n\u0002\u0010&\u001a\u0004\b$\u0010%R\u0011\u0010\u0004\u001a\u00020\u0005¢\u0006\b\n\u0000\u001a\u0004\b'\u0010\u001c\u0082\u0002\u000b\n\u0005\b¡\u001e0\u0001\n\u0002\b!¨\u0006B"}, d2 = {"Landroidx/compose/ui/input/pointer/PointerInputEventData;", "", "id", "Landroidx/compose/ui/input/pointer/PointerId;", "uptime", "", "positionOnScreen", "Landroidx/compose/ui/geometry/Offset;", "position", "down", "", "pressure", "", "type", "Landroidx/compose/ui/input/pointer/PointerType;", "activeHover", "historical", "", "Landroidx/compose/ui/input/pointer/HistoricalChange;", "scrollDelta", "originalEventPosition", "(JJJJZFIZLjava/util/List;JJLkotlin/jvm/internal/DefaultConstructorMarker;)V", "getActiveHover", "()Z", "getDown", "getHistorical", "()Ljava/util/List;", "getId-J3iCeTQ", "()J", "J", "getOriginalEventPosition-F1C5BW0", "getPosition-F1C5BW0", "getPositionOnScreen-F1C5BW0", "getPressure", "()F", "getScrollDelta-F1C5BW0", "getType-T8wyACA", "()I", "I", "getUptime", "component1", "component1-J3iCeTQ", "component10", "component10-F1C5BW0", "component11", "component11-F1C5BW0", "component2", "component3", "component3-F1C5BW0", "component4", "component4-F1C5BW0", "component5", "component6", "component7", "component7-T8wyACA", "component8", "component9", "copy", "copy-rc8HELY", "(JJJJZFIZLjava/util/List;JJ)Landroidx/compose/ui/input/pointer/PointerInputEventData;", "equals", "other", "hashCode", "", "toString", "", "ui_release"}, k = 1, mv = {1, 8, 0}, xi = 48)
public final class PointerInputEventData {
    public static final int $stable = 8;
    private final boolean activeHover;
    private final boolean down;
    private final List<HistoricalChange> historical;
    private final long id;
    private final long originalEventPosition;
    private final long position;
    private final long positionOnScreen;
    private final float pressure;
    private final long scrollDelta;
    private final int type;
    private final long uptime;

    public PointerInputEventData(long j, long j2, long j3, long j4, boolean z, float f, int i, boolean z2, List list, long j5, long j6, DefaultConstructorMarker defaultConstructorMarker) {
        this(j, j2, j3, j4, z, f, i, z2, list, j5, j6);
    }

    public final long getId() {
        return this.id;
    }

    public final long getScrollDelta() {
        return this.scrollDelta;
    }

    public final long getOriginalEventPosition() {
        return this.originalEventPosition;
    }

    public final long getUptime() {
        return this.uptime;
    }

    public final long getPositionOnScreen() {
        return this.positionOnScreen;
    }

    public final long getPosition() {
        return this.position;
    }

    public final boolean getDown() {
        return this.down;
    }

    public final float getPressure() {
        return this.pressure;
    }

    public final int getType() {
        return this.type;
    }

    public final boolean getActiveHover() {
        return this.activeHover;
    }

    public final List<HistoricalChange> component9() {
        return this.historical;
    }

    public final PointerInputEventData m5860copyrc8HELY(long id, long uptime, long positionOnScreen, long position, boolean down, float pressure, int type, boolean activeHover, List<HistoricalChange> historical, long scrollDelta, long originalEventPosition) {
        return new PointerInputEventData(id, uptime, positionOnScreen, position, down, pressure, type, activeHover, historical, scrollDelta, originalEventPosition, null);
    }

    public boolean equals(Object other) {
        if (this == other) {
            return true;
        }
        if (!(other instanceof PointerInputEventData)) {
            return false;
        }
        PointerInputEventData pointerInputEventData = (PointerInputEventData) other;
        return PointerId.m5828equalsimpl0(this.id, pointerInputEventData.id) && this.uptime == pointerInputEventData.uptime && Offset.m4343equalsimpl0(this.positionOnScreen, pointerInputEventData.positionOnScreen) && Offset.m4343equalsimpl0(this.position, pointerInputEventData.position) && this.down == pointerInputEventData.down && Float.compare(this.pressure, pointerInputEventData.pressure) == 0 && PointerType.m5919equalsimpl0(this.type, pointerInputEventData.type) && this.activeHover == pointerInputEventData.activeHover && Intrinsics.areEqual(this.historical, pointerInputEventData.historical) && Offset.m4343equalsimpl0(this.scrollDelta, pointerInputEventData.scrollDelta) && Offset.m4343equalsimpl0(this.originalEventPosition, pointerInputEventData.originalEventPosition);
    }

    public int hashCode() {
        return (((((((((((((((((((PointerId.m5829hashCodeimpl(this.id) * 31) + UByte$.ExternalSyntheticBackport0.m(this.uptime)) * 31) + Offset.m4348hashCodeimpl(this.positionOnScreen)) * 31) + Offset.m4348hashCodeimpl(this.position)) * 31) + UByte$.ExternalSyntheticBackport0.m(this.down)) * 31) + Float.floatToIntBits(this.pressure)) * 31) + PointerType.m5920hashCodeimpl(this.type)) * 31) + UByte$.ExternalSyntheticBackport0.m(this.activeHover)) * 31) + this.historical.hashCode()) * 31) + Offset.m4348hashCodeimpl(this.scrollDelta)) * 31) + Offset.m4348hashCodeimpl(this.originalEventPosition);
    }

    public String toString() {
        return "PointerInputEventData(id=" + ((Object) PointerId.m5830toStringimpl(this.id)) + ", uptime=" + this.uptime + ", positionOnScreen=" + ((Object) Offset.m4354toStringimpl(this.positionOnScreen)) + ", position=" + ((Object) Offset.m4354toStringimpl(this.position)) + ", down=" + this.down + ", pressure=" + this.pressure + ", type=" + ((Object) PointerType.m5921toStringimpl(this.type)) + ", activeHover=" + this.activeHover + ", historical=" + this.historical + ", scrollDelta=" + ((Object) Offset.m4354toStringimpl(this.scrollDelta)) + ", originalEventPosition=" + ((Object) Offset.m4354toStringimpl(this.originalEventPosition)) + ')';
    }

    private PointerInputEventData(long j, long j2, long j3, long j4, boolean z, float f, int i, boolean z2, List<HistoricalChange> list, long j5, long j6) {
        this.id = j;
        this.uptime = j2;
        this.positionOnScreen = j3;
        this.position = j4;
        this.down = z;
        this.pressure = f;
        this.type = i;
        this.activeHover = z2;
        this.historical = list;
        this.scrollDelta = j5;
        this.originalEventPosition = j6;
    }

    public final long m5861getIdJ3iCeTQ() {
        return this.id;
    }

    public final long getUptime() {
        return this.uptime;
    }

    public final long m5864getPositionOnScreenF1C5BW0() {
        return this.positionOnScreen;
    }

    public final long m5863getPositionF1C5BW0() {
        return this.position;
    }

    public final boolean getDown() {
        return this.down;
    }

    public final float getPressure() {
        return this.pressure;
    }

    public final int m5866getTypeT8wyACA() {
        return this.type;
    }

    public final boolean getActiveHover() {
        return this.activeHover;
    }

    public PointerInputEventData(long j, long j2, long j3, long j4, boolean z, float f, int i, boolean z2, List list, long j5, long j6, int i2, DefaultConstructorMarker defaultConstructorMarker) {
        this(j, j2, j3, j4, z, f, i, (i2 & Fields.SpotShadowColor) != 0 ? false : z2, (i2 & Fields.RotationX) != 0 ? new ArrayList() : list, (i2 & Fields.RotationY) != 0 ? Offset.INSTANCE.m4362getZeroF1C5BW0() : j5, (i2 & Fields.RotationZ) != 0 ? Offset.INSTANCE.m4362getZeroF1C5BW0() : j6, null);
    }

    public final List<HistoricalChange> getHistorical() {
        return this.historical;
    }

    public final long m5865getScrollDeltaF1C5BW0() {
        return this.scrollDelta;
    }

    public final long m5862getOriginalEventPositionF1C5BW0() {
        return this.originalEventPosition;
    }
}
