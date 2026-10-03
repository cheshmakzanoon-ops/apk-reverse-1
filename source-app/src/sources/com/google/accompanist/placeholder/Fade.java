package com.google.accompanist.placeholder;

import androidx.compose.animation.core.InfiniteRepeatableSpec;
import androidx.compose.ui.graphics.Brush;
import androidx.compose.ui.graphics.Color;
import androidx.compose.ui.graphics.SolidColor;
import androidx.constraintlayout.widget.ConstraintLayout;
import kotlin.Metadata;
import kotlin.jvm.internal.DefaultConstructorMarker;
import kotlin.jvm.internal.Intrinsics;

@Metadata(d1 = {"\u0000J\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\u0010\u0007\n\u0002\b\u0004\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\n\n\u0002\u0010\u000b\n\u0000\n\u0002\u0010\u0000\n\u0000\n\u0002\u0010\b\n\u0000\n\u0002\u0010\u000e\n\u0000\b\u0082\b\u0018\u00002\u00020\u0001B\u001e\u0012\u0006\u0010\u0002\u001a\u00020\u0003\u0012\f\u0010\u0004\u001a\b\u0012\u0004\u0012\u00020\u00060\u0005ø\u0001\u0000¢\u0006\u0002\u0010\u0007J\u0010\u0010\r\u001a\u00020\u00062\u0006\u0010\u000e\u001a\u00020\u0006H\u0016J%\u0010\n\u001a\u00020\u000f2\u0006\u0010\u000e\u001a\u00020\u00062\u0006\u0010\u0010\u001a\u00020\u0011H\u0016ø\u0001\u0001ø\u0001\u0000¢\u0006\u0004\b\u0012\u0010\u0013J\u0019\u0010\u0014\u001a\u00020\u0003HÂ\u0003ø\u0001\u0002ø\u0001\u0001ø\u0001\u0000¢\u0006\u0004\b\u0015\u0010\u0016J\u000f\u0010\u0017\u001a\b\u0012\u0004\u0012\u00020\u00060\u0005HÆ\u0003J0\u0010\u0018\u001a\u00020\u00002\b\b\u0002\u0010\u0002\u001a\u00020\u00032\u000e\b\u0002\u0010\u0004\u001a\b\u0012\u0004\u0012\u00020\u00060\u0005HÆ\u0001ø\u0001\u0001ø\u0001\u0000¢\u0006\u0004\b\u0019\u0010\u001aJ\u0013\u0010\u001b\u001a\u00020\u001c2\b\u0010\u001d\u001a\u0004\u0018\u00010\u001eHÖ\u0003J\t\u0010\u001f\u001a\u00020 HÖ\u0001J\t\u0010!\u001a\u00020\"HÖ\u0001R\u001a\u0010\u0004\u001a\b\u0012\u0004\u0012\u00020\u00060\u0005X\u0096\u0004¢\u0006\b\n\u0000\u001a\u0004\b\b\u0010\tR\u000e\u0010\n\u001a\u00020\u000bX\u0082\u0004¢\u0006\u0002\n\u0000R\u0019\u0010\u0002\u001a\u00020\u0003X\u0082\u0004ø\u0001\u0000ø\u0001\u0001ø\u0001\u0002¢\u0006\u0004\n\u0002\u0010\f\u0082\u0002\u000f\n\u0002\b\u0019\n\u0005\b¡\u001e0\u0001\n\u0002\b!¨\u0006#"}, d2 = {"Lcom/google/accompanist/placeholder/Fade;", "Lcom/google/accompanist/placeholder/PlaceholderHighlight;", "highlightColor", "Landroidx/compose/ui/graphics/Color;", "animationSpec", "Landroidx/compose/animation/core/InfiniteRepeatableSpec;", "", "(JLandroidx/compose/animation/core/InfiniteRepeatableSpec;Lkotlin/jvm/internal/DefaultConstructorMarker;)V", "getAnimationSpec", "()Landroidx/compose/animation/core/InfiniteRepeatableSpec;", "brush", "Landroidx/compose/ui/graphics/SolidColor;", "J", "alpha", "progress", "Landroidx/compose/ui/graphics/Brush;", "size", "Landroidx/compose/ui/geometry/Size;", "brush-d16Qtg0", "(FJ)Landroidx/compose/ui/graphics/Brush;", "component1", "component1-0d7_KjU", "()J", "component2", "copy", "copy-DxMtmZc", "(JLandroidx/compose/animation/core/InfiniteRepeatableSpec;)Lcom/google/accompanist/placeholder/Fade;", "equals", "", "other", "", "hashCode", "", "toString", "", "placeholder_release"}, k = 1, mv = {1, 8, 0}, xi = ConstraintLayout.LayoutParams.Table.LAYOUT_CONSTRAINT_VERTICAL_CHAINSTYLE)
final class Fade implements PlaceholderHighlight {
    private final InfiniteRepeatableSpec<Float> animationSpec;
    private final SolidColor brush;
    private final long highlightColor;

    public Fade(long j, InfiniteRepeatableSpec infiniteRepeatableSpec, DefaultConstructorMarker defaultConstructorMarker) {
        this(j, infiniteRepeatableSpec);
    }

    private final long getHighlightColor() {
        return this.highlightColor;
    }

    public static Fade m2587copyDxMtmZc$default(Fade fade, long j, InfiniteRepeatableSpec infiniteRepeatableSpec, int i, Object obj) {
        if ((i & 1) != 0) {
            j = fade.highlightColor;
        }
        if ((i & 2) != 0) {
            infiniteRepeatableSpec = fade.getAnimationSpec();
        }
        return fade.m2589copyDxMtmZc(j, infiniteRepeatableSpec);
    }

    @Override
    public float alpha(float progress) {
        return progress;
    }

    public final InfiniteRepeatableSpec<Float> component2() {
        return getAnimationSpec();
    }

    public final Fade m2589copyDxMtmZc(long highlightColor, InfiniteRepeatableSpec<Float> animationSpec) {
        Intrinsics.checkNotNullParameter(animationSpec, "animationSpec");
        return new Fade(highlightColor, animationSpec, null);
    }

    public boolean equals(Object other) {
        if (this == other) {
            return true;
        }
        if (!(other instanceof Fade)) {
            return false;
        }
        Fade fade = (Fade) other;
        return Color.equals-impl0(this.highlightColor, fade.highlightColor) && Intrinsics.areEqual(getAnimationSpec(), fade.getAnimationSpec());
    }

    public int hashCode() {
        return (Color.hashCode-impl(this.highlightColor) * 31) + getAnimationSpec().hashCode();
    }

    public String toString() {
        return "Fade(highlightColor=" + ((Object) Color.toString-impl(this.highlightColor)) + ", animationSpec=" + getAnimationSpec() + ')';
    }

    private Fade(long j, InfiniteRepeatableSpec<Float> infiniteRepeatableSpec) {
        this.highlightColor = j;
        this.animationSpec = infiniteRepeatableSpec;
        this.brush = new SolidColor(j, (DefaultConstructorMarker) null);
    }

    @Override
    public InfiniteRepeatableSpec<Float> getAnimationSpec() {
        return this.animationSpec;
    }

    @Override
    public Brush mo2588brushd16Qtg0(float progress, long size) {
        return this.brush;
    }
}
