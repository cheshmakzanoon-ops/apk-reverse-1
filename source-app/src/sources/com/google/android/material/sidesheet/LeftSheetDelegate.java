package com.google.android.material.sidesheet;

import android.view.View;
import android.view.ViewGroup;
import androidx.coordinatorlayout.widget.CoordinatorLayout;

final class LeftSheetDelegate extends SheetDelegate {
    final SideSheetBehavior<? extends View> sheetBehavior;

    @Override
    int getSheetEdge() {
        return 1;
    }

    @Override
    boolean isExpandingOutwards(float f) {
        return f > 0.0f;
    }

    LeftSheetDelegate(SideSheetBehavior<? extends View> sideSheetBehavior) {
        this.sheetBehavior = sideSheetBehavior;
    }

    @Override
    int getHiddenOffset() {
        return (-this.sheetBehavior.getChildWidth()) - this.sheetBehavior.getInnerMargin();
    }

    @Override
    int getExpandedOffset() {
        return Math.max(0, this.sheetBehavior.getParentInnerEdge() + this.sheetBehavior.getInnerMargin());
    }

    @Override
    boolean isReleasedCloseToInnerEdge(View view) {
        return view.getRight() < (getExpandedOffset() - getHiddenOffset()) / 2;
    }

    @Override
    boolean isSwipeSignificant(float f, float f2) {
        return SheetUtils.isSwipeMostlyHorizontal(f, f2) && Math.abs(f) > ((float) this.sheetBehavior.getSignificantVelocityThreshold());
    }

    @Override
    boolean shouldHide(View view, float f) {
        return Math.abs(((float) view.getLeft()) + (f * this.sheetBehavior.getHideFriction())) > this.sheetBehavior.getHideThreshold();
    }

    @Override
    <V extends View> int getOuterEdge(V v) {
        return v.getRight() + this.sheetBehavior.getInnerMargin();
    }

    @Override
    float calculateSlideOffset(int i) {
        float hiddenOffset = getHiddenOffset();
        return (i - hiddenOffset) / (getExpandedOffset() - hiddenOffset);
    }

    @Override
    void updateCoplanarSiblingLayoutParams(ViewGroup.MarginLayoutParams marginLayoutParams, int i, int i2) {
        if (i <= this.sheetBehavior.getParentWidth()) {
            marginLayoutParams.leftMargin = i2;
        }
    }

    @Override
    void updateCoplanarSiblingAdjacentMargin(ViewGroup.MarginLayoutParams marginLayoutParams, int i) {
        marginLayoutParams.leftMargin = i;
    }

    @Override
    int getCoplanarSiblingAdjacentMargin(ViewGroup.MarginLayoutParams marginLayoutParams) {
        return marginLayoutParams.leftMargin;
    }

    @Override
    public int getParentInnerEdge(CoordinatorLayout coordinatorLayout) {
        return coordinatorLayout.getLeft();
    }

    @Override
    int calculateInnerMargin(ViewGroup.MarginLayoutParams marginLayoutParams) {
        return marginLayoutParams.leftMargin;
    }

    @Override
    int getMinViewPositionHorizontal() {
        return -this.sheetBehavior.getChildWidth();
    }

    @Override
    int getMaxViewPositionHorizontal() {
        return this.sheetBehavior.getInnerMargin();
    }
}
