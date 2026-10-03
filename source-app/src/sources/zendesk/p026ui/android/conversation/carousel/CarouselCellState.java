package zendesk.p026ui.android.conversation.carousel;

import java.util.List;
import kotlin.Metadata;
import kotlin.collections.CollectionsKt;
import kotlin.jvm.internal.DefaultConstructorMarker;
import kotlin.jvm.internal.Intrinsics;
import zendesk.p026ui.android.conversation.avatar.AvatarImageState;

@Metadata(m17d1 = {"\u00006\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0000\n\u0002\u0010 \n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\f\n\u0002\u0010\u000b\n\u0002\b\u0002\n\u0002\u0010\b\n\u0000\n\u0002\u0010\u000e\n\u0000\b\u0087\b\u0018\u00002\u00020\u0001B+\u0012\u000e\b\u0002\u0010\u0002\u001a\b\u0012\u0004\u0012\u00020\u00040\u0003\u0012\n\b\u0002\u0010\u0005\u001a\u0004\u0018\u00010\u0006\u0012\b\b\u0002\u0010\u0007\u001a\u00020\b¢\u0006\u0002\u0010\tJ\u000f\u0010\u0010\u001a\b\u0012\u0004\u0012\u00020\u00040\u0003HÆ\u0003J\u000b\u0010\u0011\u001a\u0004\u0018\u00010\u0006HÆ\u0003J\t\u0010\u0012\u001a\u00020\bHÆ\u0003J/\u0010\u0013\u001a\u00020\u00002\u000e\b\u0002\u0010\u0002\u001a\b\u0012\u0004\u0012\u00020\u00040\u00032\n\b\u0002\u0010\u0005\u001a\u0004\u0018\u00010\u00062\b\b\u0002\u0010\u0007\u001a\u00020\bHÆ\u0001J\u0013\u0010\u0014\u001a\u00020\u00152\b\u0010\u0016\u001a\u0004\u0018\u00010\u0001HÖ\u0003J\t\u0010\u0017\u001a\u00020\u0018HÖ\u0001J\t\u0010\u0019\u001a\u00020\u001aHÖ\u0001R\u0013\u0010\u0005\u001a\u0004\u0018\u00010\u0006¢\u0006\b\n\u0000\u001a\u0004\b\n\u0010\u000bR\u0017\u0010\u0002\u001a\b\u0012\u0004\u0012\u00020\u00040\u0003¢\u0006\b\n\u0000\u001a\u0004\b\f\u0010\rR\u0011\u0010\u0007\u001a\u00020\b¢\u0006\b\n\u0000\u001a\u0004\b\u000e\u0010\u000f¨\u0006\u001b"}, m18d2 = {"Lzendesk/ui/android/conversation/carousel/CarouselCellState;", "", "cellData", "", "Lzendesk/ui/android/conversation/carousel/CarouselCellData;", "avatarImageState", "Lzendesk/ui/android/conversation/avatar/AvatarImageState;", "rendering", "Lzendesk/ui/android/conversation/carousel/CarouselRendering;", "(Ljava/util/List;Lzendesk/ui/android/conversation/avatar/AvatarImageState;Lzendesk/ui/android/conversation/carousel/CarouselRendering;)V", "getAvatarImageState", "()Lzendesk/ui/android/conversation/avatar/AvatarImageState;", "getCellData", "()Ljava/util/List;", "getRendering", "()Lzendesk/ui/android/conversation/carousel/CarouselRendering;", "component1", "component2", "component3", "copy", "equals", "", "other", "hashCode", "", "toString", "", "zendesk.ui_ui-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
public final class CarouselCellState {
    public static final int $stable = 8;
    private final AvatarImageState avatarImageState;
    private final List<CarouselCellData> cellData;
    private final CarouselRendering rendering;

    public CarouselCellState() {
        this(null, null, null, 7, null);
    }

    public static CarouselCellState copy$default(CarouselCellState carouselCellState, List list, AvatarImageState avatarImageState, CarouselRendering carouselRendering, int i, Object obj) {
        if ((i & 1) != 0) {
            list = carouselCellState.cellData;
        }
        if ((i & 2) != 0) {
            avatarImageState = carouselCellState.avatarImageState;
        }
        if ((i & 4) != 0) {
            carouselRendering = carouselCellState.rendering;
        }
        return carouselCellState.copy(list, avatarImageState, carouselRendering);
    }

    public final List<CarouselCellData> component1() {
        return this.cellData;
    }

    public final AvatarImageState getAvatarImageState() {
        return this.avatarImageState;
    }

    public final CarouselRendering getRendering() {
        return this.rendering;
    }

    public final CarouselCellState copy(List<? extends CarouselCellData> cellData, AvatarImageState avatarImageState, CarouselRendering rendering) {
        Intrinsics.checkNotNullParameter(cellData, "cellData");
        Intrinsics.checkNotNullParameter(rendering, "rendering");
        return new CarouselCellState(cellData, avatarImageState, rendering);
    }

    public boolean equals(Object other) {
        if (this == other) {
            return true;
        }
        if (!(other instanceof CarouselCellState)) {
            return false;
        }
        CarouselCellState carouselCellState = (CarouselCellState) other;
        return Intrinsics.areEqual(this.cellData, carouselCellState.cellData) && Intrinsics.areEqual(this.avatarImageState, carouselCellState.avatarImageState) && Intrinsics.areEqual(this.rendering, carouselCellState.rendering);
    }

    public int hashCode() {
        int iHashCode = this.cellData.hashCode() * 31;
        AvatarImageState avatarImageState = this.avatarImageState;
        return ((iHashCode + (avatarImageState == null ? 0 : avatarImageState.hashCode())) * 31) + this.rendering.hashCode();
    }

    public String toString() {
        return "CarouselCellState(cellData=" + this.cellData + ", avatarImageState=" + this.avatarImageState + ", rendering=" + this.rendering + ')';
    }

    public CarouselCellState(List<? extends CarouselCellData> cellData, AvatarImageState avatarImageState, CarouselRendering rendering) {
        Intrinsics.checkNotNullParameter(cellData, "cellData");
        Intrinsics.checkNotNullParameter(rendering, "rendering");
        this.cellData = cellData;
        this.avatarImageState = avatarImageState;
        this.rendering = rendering;
    }

    public CarouselCellState(List list, AvatarImageState avatarImageState, CarouselRendering carouselRendering, int i, DefaultConstructorMarker defaultConstructorMarker) {
        this((i & 1) != 0 ? CollectionsKt.emptyList() : list, (i & 2) != 0 ? null : avatarImageState, (i & 4) != 0 ? new CarouselRendering(0, 0, 0, 0, 0, 0, 0, 0, 0, false, 0, 0, 4095, null) : carouselRendering);
    }

    public final List<CarouselCellData> getCellData() {
        return this.cellData;
    }

    public final AvatarImageState getAvatarImageState() {
        return this.avatarImageState;
    }

    public final CarouselRendering getRendering() {
        return this.rendering;
    }
}
