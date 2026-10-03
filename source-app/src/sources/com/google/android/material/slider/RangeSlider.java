package com.google.android.material.slider;

import android.content.Context;
import android.content.res.ColorStateList;
import android.content.res.TypedArray;
import android.graphics.drawable.Drawable;
import android.os.Parcel;
import android.os.Parcelable;
import android.util.AttributeSet;
import android.view.AbsSavedState;
import android.view.KeyEvent;
import android.view.MotionEvent;
import com.google.android.material.C0017R;
import com.google.android.material.internal.ThemeEnforcement;
import java.util.ArrayList;
import java.util.List;

public class RangeSlider extends BaseSlider<RangeSlider, OnChangeListener, OnSliderTouchListener> {
    private float minSeparation;
    private int separationUnit;

    @Override
    public void addOnChangeListener(BaseOnChangeListener baseOnChangeListener) {
        super.addOnChangeListener(baseOnChangeListener);
    }

    @Override
    public void addOnSliderTouchListener(BaseOnSliderTouchListener baseOnSliderTouchListener) {
        super.addOnSliderTouchListener(baseOnSliderTouchListener);
    }

    @Override
    public void clearOnChangeListeners() {
        super.clearOnChangeListeners();
    }

    @Override
    public void clearOnSliderTouchListeners() {
        super.clearOnSliderTouchListeners();
    }

    @Override
    public boolean dispatchHoverEvent(MotionEvent motionEvent) {
        return super.dispatchHoverEvent(motionEvent);
    }

    @Override
    public boolean dispatchKeyEvent(KeyEvent keyEvent) {
        return super.dispatchKeyEvent(keyEvent);
    }

    @Override
    public CharSequence getAccessibilityClassName() {
        return super.getAccessibilityClassName();
    }

    @Override
    public int getActiveThumbIndex() {
        return super.getActiveThumbIndex();
    }

    @Override
    public int getFocusedThumbIndex() {
        return super.getFocusedThumbIndex();
    }

    @Override
    public int getHaloRadius() {
        return super.getHaloRadius();
    }

    @Override
    public ColorStateList getHaloTintList() {
        return super.getHaloTintList();
    }

    @Override
    public int getLabelBehavior() {
        return super.getLabelBehavior();
    }

    @Override
    public float getStepSize() {
        return super.getStepSize();
    }

    @Override
    public float getThumbElevation() {
        return super.getThumbElevation();
    }

    @Override
    public int getThumbHeight() {
        return super.getThumbHeight();
    }

    @Override
    public int getThumbRadius() {
        return super.getThumbRadius();
    }

    @Override
    public ColorStateList getThumbStrokeColor() {
        return super.getThumbStrokeColor();
    }

    @Override
    public float getThumbStrokeWidth() {
        return super.getThumbStrokeWidth();
    }

    @Override
    public ColorStateList getThumbTintList() {
        return super.getThumbTintList();
    }

    @Override
    public int getThumbTrackGapSize() {
        return super.getThumbTrackGapSize();
    }

    @Override
    public int getThumbWidth() {
        return super.getThumbWidth();
    }

    @Override
    public int getTickActiveRadius() {
        return super.getTickActiveRadius();
    }

    @Override
    public ColorStateList getTickActiveTintList() {
        return super.getTickActiveTintList();
    }

    @Override
    public int getTickInactiveRadius() {
        return super.getTickInactiveRadius();
    }

    @Override
    public ColorStateList getTickInactiveTintList() {
        return super.getTickInactiveTintList();
    }

    @Override
    public ColorStateList getTickTintList() {
        return super.getTickTintList();
    }

    @Override
    public ColorStateList getTrackActiveTintList() {
        return super.getTrackActiveTintList();
    }

    @Override
    public int getTrackHeight() {
        return super.getTrackHeight();
    }

    @Override
    public ColorStateList getTrackInactiveTintList() {
        return super.getTrackInactiveTintList();
    }

    @Override
    public int getTrackInsideCornerSize() {
        return super.getTrackInsideCornerSize();
    }

    @Override
    public int getTrackSidePadding() {
        return super.getTrackSidePadding();
    }

    @Override
    public int getTrackStopIndicatorSize() {
        return super.getTrackStopIndicatorSize();
    }

    @Override
    public ColorStateList getTrackTintList() {
        return super.getTrackTintList();
    }

    @Override
    public int getTrackWidth() {
        return super.getTrackWidth();
    }

    @Override
    public float getValueFrom() {
        return super.getValueFrom();
    }

    @Override
    public float getValueTo() {
        return super.getValueTo();
    }

    @Override
    public boolean hasLabelFormatter() {
        return super.hasLabelFormatter();
    }

    @Override
    public boolean isTickVisible() {
        return super.isTickVisible();
    }

    @Override
    public boolean onKeyDown(int i, KeyEvent keyEvent) {
        return super.onKeyDown(i, keyEvent);
    }

    @Override
    public boolean onKeyUp(int i, KeyEvent keyEvent) {
        return super.onKeyUp(i, keyEvent);
    }

    @Override
    public boolean onTouchEvent(MotionEvent motionEvent) {
        return super.onTouchEvent(motionEvent);
    }

    @Override
    public void removeOnChangeListener(BaseOnChangeListener baseOnChangeListener) {
        super.removeOnChangeListener(baseOnChangeListener);
    }

    @Override
    public void removeOnSliderTouchListener(BaseOnSliderTouchListener baseOnSliderTouchListener) {
        super.removeOnSliderTouchListener(baseOnSliderTouchListener);
    }

    @Override
    public void setEnabled(boolean z) {
        super.setEnabled(z);
    }

    @Override
    public void setFocusedThumbIndex(int i) {
        super.setFocusedThumbIndex(i);
    }

    @Override
    public void setHaloRadius(int i) {
        super.setHaloRadius(i);
    }

    @Override
    public void setHaloRadiusResource(int i) {
        super.setHaloRadiusResource(i);
    }

    @Override
    public void setHaloTintList(ColorStateList colorStateList) {
        super.setHaloTintList(colorStateList);
    }

    @Override
    public void setLabelBehavior(int i) {
        super.setLabelBehavior(i);
    }

    @Override
    public void setLabelFormatter(LabelFormatter labelFormatter) {
        super.setLabelFormatter(labelFormatter);
    }

    @Override
    public void setStepSize(float f) {
        super.setStepSize(f);
    }

    @Override
    public void setThumbElevation(float f) {
        super.setThumbElevation(f);
    }

    @Override
    public void setThumbElevationResource(int i) {
        super.setThumbElevationResource(i);
    }

    @Override
    public void setThumbHeight(int i) {
        super.setThumbHeight(i);
    }

    @Override
    public void setThumbHeightResource(int i) {
        super.setThumbHeightResource(i);
    }

    @Override
    public void setThumbRadius(int i) {
        super.setThumbRadius(i);
    }

    @Override
    public void setThumbRadiusResource(int i) {
        super.setThumbRadiusResource(i);
    }

    @Override
    public void setThumbStrokeColor(ColorStateList colorStateList) {
        super.setThumbStrokeColor(colorStateList);
    }

    @Override
    public void setThumbStrokeColorResource(int i) {
        super.setThumbStrokeColorResource(i);
    }

    @Override
    public void setThumbStrokeWidth(float f) {
        super.setThumbStrokeWidth(f);
    }

    @Override
    public void setThumbStrokeWidthResource(int i) {
        super.setThumbStrokeWidthResource(i);
    }

    @Override
    public void setThumbTintList(ColorStateList colorStateList) {
        super.setThumbTintList(colorStateList);
    }

    @Override
    public void setThumbTrackGapSize(int i) {
        super.setThumbTrackGapSize(i);
    }

    @Override
    public void setThumbWidth(int i) {
        super.setThumbWidth(i);
    }

    @Override
    public void setThumbWidthResource(int i) {
        super.setThumbWidthResource(i);
    }

    @Override
    public void setTickActiveRadius(int i) {
        super.setTickActiveRadius(i);
    }

    @Override
    public void setTickActiveTintList(ColorStateList colorStateList) {
        super.setTickActiveTintList(colorStateList);
    }

    @Override
    public void setTickInactiveRadius(int i) {
        super.setTickInactiveRadius(i);
    }

    @Override
    public void setTickInactiveTintList(ColorStateList colorStateList) {
        super.setTickInactiveTintList(colorStateList);
    }

    @Override
    public void setTickTintList(ColorStateList colorStateList) {
        super.setTickTintList(colorStateList);
    }

    @Override
    public void setTickVisible(boolean z) {
        super.setTickVisible(z);
    }

    @Override
    public void setTrackActiveTintList(ColorStateList colorStateList) {
        super.setTrackActiveTintList(colorStateList);
    }

    @Override
    public void setTrackHeight(int i) {
        super.setTrackHeight(i);
    }

    @Override
    public void setTrackInactiveTintList(ColorStateList colorStateList) {
        super.setTrackInactiveTintList(colorStateList);
    }

    @Override
    public void setTrackInsideCornerSize(int i) {
        super.setTrackInsideCornerSize(i);
    }

    @Override
    public void setTrackStopIndicatorSize(int i) {
        super.setTrackStopIndicatorSize(i);
    }

    @Override
    public void setTrackTintList(ColorStateList colorStateList) {
        super.setTrackTintList(colorStateList);
    }

    @Override
    public void setValueFrom(float f) {
        super.setValueFrom(f);
    }

    @Override
    public void setValueTo(float f) {
        super.setValueTo(f);
    }

    public RangeSlider(Context context) {
        this(context, null);
    }

    public RangeSlider(Context context, AttributeSet attributeSet) {
        this(context, attributeSet, C0017R.attr.sliderStyle);
    }

    public RangeSlider(Context context, AttributeSet attributeSet, int i) {
        super(context, attributeSet, i);
        TypedArray typedArrayObtainStyledAttributes = ThemeEnforcement.obtainStyledAttributes(context, attributeSet, C0017R.styleable.RangeSlider, i, DEF_STYLE_RES, new int[0]);
        if (typedArrayObtainStyledAttributes.hasValue(C0017R.styleable.RangeSlider_values)) {
            setValues(convertToFloat(typedArrayObtainStyledAttributes.getResources().obtainTypedArray(typedArrayObtainStyledAttributes.getResourceId(C0017R.styleable.RangeSlider_values, 0))));
        }
        this.minSeparation = typedArrayObtainStyledAttributes.getDimension(C0017R.styleable.RangeSlider_minSeparation, 0.0f);
        typedArrayObtainStyledAttributes.recycle();
    }

    public interface OnChangeListener extends BaseOnChangeListener<RangeSlider> {
        void onValueChange(RangeSlider rangeSlider, float f, boolean z);

        public final class CC {
        }
    }

    public interface OnSliderTouchListener extends BaseOnSliderTouchListener<RangeSlider> {
        void onStartTrackingTouch(RangeSlider rangeSlider);

        void onStopTrackingTouch(RangeSlider rangeSlider);

        public final class CC {
        }
    }

    @Override
    public void setValues(Float... fArr) {
        super.setValues(fArr);
    }

    @Override
    public void setValues(List<Float> list) {
        super.setValues(list);
    }

    @Override
    public List<Float> getValues() {
        return super.getValues();
    }

    @Override
    public void setCustomThumbDrawable(int i) {
        super.setCustomThumbDrawable(i);
    }

    @Override
    public void setCustomThumbDrawable(Drawable drawable) {
        super.setCustomThumbDrawable(drawable);
    }

    @Override
    public void setCustomThumbDrawablesForValues(int... iArr) {
        super.setCustomThumbDrawablesForValues(iArr);
    }

    @Override
    public void setCustomThumbDrawablesForValues(Drawable... drawableArr) {
        super.setCustomThumbDrawablesForValues(drawableArr);
    }

    private static List<Float> convertToFloat(TypedArray typedArray) {
        ArrayList arrayList = new ArrayList();
        for (int i = 0; i < typedArray.length(); i++) {
            arrayList.add(Float.valueOf(typedArray.getFloat(i, -1.0f)));
        }
        return arrayList;
    }

    @Override
    public float getMinSeparation() {
        return this.minSeparation;
    }

    public void setMinSeparation(float f) {
        this.minSeparation = f;
        this.separationUnit = 0;
        setSeparationUnit(0);
    }

    public void setMinSeparationValue(float f) {
        this.minSeparation = f;
        this.separationUnit = 1;
        setSeparationUnit(1);
    }

    @Override
    public Parcelable onSaveInstanceState() {
        RangeSliderState rangeSliderState = new RangeSliderState(super.onSaveInstanceState());
        rangeSliderState.minSeparation = this.minSeparation;
        rangeSliderState.separationUnit = this.separationUnit;
        return rangeSliderState;
    }

    @Override
    protected void onRestoreInstanceState(Parcelable parcelable) {
        RangeSliderState rangeSliderState = (RangeSliderState) parcelable;
        super.onRestoreInstanceState(rangeSliderState.getSuperState());
        this.minSeparation = rangeSliderState.minSeparation;
        int i = rangeSliderState.separationUnit;
        this.separationUnit = i;
        setSeparationUnit(i);
    }

    static class RangeSliderState extends AbsSavedState {
        public static final Parcelable.Creator<RangeSliderState> CREATOR = new Parcelable.Creator<RangeSliderState>() {
            @Override
            public RangeSliderState createFromParcel(Parcel parcel) {
                return new RangeSliderState(parcel);
            }

            @Override
            public RangeSliderState[] newArray(int i) {
                return new RangeSliderState[i];
            }
        };
        private float minSeparation;
        private int separationUnit;

        RangeSliderState(Parcelable parcelable) {
            super(parcelable);
        }

        private RangeSliderState(Parcel parcel) {
            super(parcel.readParcelable(RangeSliderState.class.getClassLoader()));
            this.minSeparation = parcel.readFloat();
            this.separationUnit = parcel.readInt();
        }

        @Override
        public void writeToParcel(Parcel parcel, int i) {
            super.writeToParcel(parcel, i);
            parcel.writeFloat(this.minSeparation);
            parcel.writeInt(this.separationUnit);
        }
    }
}
