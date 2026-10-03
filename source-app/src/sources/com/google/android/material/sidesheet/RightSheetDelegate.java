package com.google.android.material.sidesheet;

import android.view.View;
import android.view.ViewGroup;
import androidx.coordinatorlayout.widget.CoordinatorLayout;

final class RightSheetDelegate extends SheetDelegate {
    final SideSheetBehavior<? extends View> sheetBehavior;

    @Override
    int getSheetEdge() {
        return 0;
    }

    @Override
    boolean isExpandingOutwards(float f) {
        return f < 0.0f;
    }

    RightSheetDelegate(SideSheetBehavior<? extends View> sideSheetBehavior) {
        this.sheetBehavior = sideSheetBehavior;
    }

    @Override
    int getHiddenOffset() {
        return this.sheetBehavior.getParentWidth();
    }

    @Override
    int getExpandedOffset() {
        return Math.max(0, (getHiddenOffset() - this.sheetBehavior.getChildWidth()) - this.sheetBehavior.getInnerMargin());
    }

    @Override
    boolean isReleasedCloseToInnerEdge(View view) {
        return view.getLeft() > (getHiddenOffset() + getExpandedOffset()) / 2;
    }

    @Override
    boolean isSwipeSignificant(float f, float f2) {
        return SheetUtils.isSwipeMostlyHorizontal(f, f2) && Math.abs(f) > ((float) this.sheetBehavior.getSignificantVelocityThreshold());
    }

    @Override
    boolean shouldHide(View view, float f) {
        return Math.abs(((float) view.getRight()) + (f * this.sheetBehavior.getHideFriction())) > this.sheetBehavior.getHideThreshold();
    }

    @Override
    <V extends View> int getOuterEdge(V v) {
        return v.getLeft() - this.sheetBehavior.getInnerMargin();
    }

    @Override
    float calculateSlideOffset(int i) {
        float hiddenOffset = getHiddenOffset();
        return (hiddenOffset - i) / (hiddenOffset - getExpandedOffset());
    }

    @Override
    void updateCoplanarSiblingLayoutParams(ViewGroup.MarginLayoutParams marginLayoutParams, int i, int i2) {
        int parentWidth = this.sheetBehavior.getParentWidth();
        if (i <= parentWidth) {
            marginLayoutParams.rightMargin = parentWidth - i;
        }
    }

    @Override
    void updateCoplanarSiblingAdjacentMargin(ViewGroup.MarginLayoutParams marginLayoutParams, int i) {
        marginLayoutParams.rightMargin = i;
    }

    @Override
    int getCoplanarSiblingAdjacentMargin(ViewGroup.MarginLayoutParams marginLayoutParams) {
        return marginLayoutParams.rightMargin;
    }

    @Override
    public int getParentInnerEdge(CoordinatorLayout coordinatorLayout) {
        return coordinatorLayout.getRight();
    }

    @Override
    int calculateInnerMargin(ViewGroup.MarginLayoutParams marginLayoutParams) {
        return marginLayoutParams.rightMargin;
    }

    @Override
    int getMinViewPositionHorizontal() {
        return getExpandedOffset();
    }

    @Override
    int getMaxViewPositionHorizontal() {
        return this.sheetBehavior.getParentWidth();
    }
}
