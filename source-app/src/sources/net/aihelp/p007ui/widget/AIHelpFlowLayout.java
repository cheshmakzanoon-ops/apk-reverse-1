package net.aihelp.p007ui.widget;

import android.content.Context;
import android.content.res.TypedArray;
import android.text.TextUtils;
import android.util.AttributeSet;
import android.view.View;
import android.view.ViewGroup;
import android.widget.TextView;
import java.lang.reflect.Array;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;
import net.aihelp.common.CustomConfig;
import net.aihelp.data.model.rpa.step.RPAStep;
import net.aihelp.utils.ResResolver;
import net.aihelp.utils.Styles;

public class AIHelpFlowLayout extends ViewGroup {
    List<View> childList;
    List<Integer> lineNumList;
    private int lineSpacing;
    private final Context mContext;
    private OnLabelClickedListener mListener;
    private int usefulWidth;

    public interface OnLabelClickedListener {
        void onLabelClicked(RPAStep.Action action);
    }

    public AIHelpFlowLayout(Context context) {
        this(context, null);
    }

    public AIHelpFlowLayout(Context context, AttributeSet attributeSet) {
        this(context, attributeSet, 0);
    }

    public AIHelpFlowLayout(Context context, AttributeSet attributeSet, int i) {
        super(context, attributeSet, i);
        this.lineSpacing = 0;
        this.childList = new ArrayList();
        this.lineNumList = new ArrayList();
        this.mContext = context;
        int[] styleable = ResResolver.getStyleable("aihelp_flow_layout");
        if (styleable != null) {
            TypedArray typedArrayObtainStyledAttributes = getContext().obtainStyledAttributes(styleable);
            this.lineSpacing = typedArrayObtainStyledAttributes.getColor(ResResolver.getStyleableFieldIndex("aihelp_flow_layout", "aihelp_flow_layout_lineSpacing"), Styles.dpToPx(context, 12.0f));
            typedArrayObtainStyledAttributes.recycle();
        }
    }

    public void setOnLabelClickedListener(OnLabelClickedListener onLabelClickedListener) {
        this.mListener = onLabelClickedListener;
    }

    @Override
    protected void onMeasure(int i, int i2) {
        View view;
        int i3;
        int i4;
        int paddingLeft = getPaddingLeft();
        int paddingRight = getPaddingRight();
        int paddingTop = getPaddingTop();
        int paddingBottom = getPaddingBottom();
        int size = View.MeasureSpec.getSize(i);
        int mode = View.MeasureSpec.getMode(i2);
        int size2 = View.MeasureSpec.getSize(i2);
        int i5 = paddingLeft + paddingRight;
        int i6 = paddingTop;
        int i7 = i5;
        int i8 = 0;
        for (int i9 = 0; i9 < getChildCount(); i9++) {
            View childAt = getChildAt(i9);
            if (childAt.getVisibility() != 8) {
                ViewGroup.LayoutParams layoutParams = childAt.getLayoutParams();
                if (layoutParams instanceof ViewGroup.MarginLayoutParams) {
                    view = childAt;
                    measureChildWithMargins(childAt, i, 0, i2, i6);
                    ViewGroup.MarginLayoutParams marginLayoutParams = (ViewGroup.MarginLayoutParams) layoutParams;
                    int i10 = marginLayoutParams.leftMargin + marginLayoutParams.rightMargin;
                    i3 = i10;
                    i4 = marginLayoutParams.topMargin + marginLayoutParams.bottomMargin;
                } else {
                    view = childAt;
                    measureChild(view, i, i2);
                    i3 = 0;
                    i4 = 0;
                }
                int measuredWidth = i3 + view.getMeasuredWidth();
                int measuredHeight = i4 + view.getMeasuredHeight();
                if (i7 + measuredWidth > size) {
                    i6 += i8 + this.lineSpacing;
                    i7 = i5;
                    i8 = 0;
                }
                if (measuredHeight > i8) {
                    i8 = measuredHeight;
                }
                i7 += measuredWidth;
            }
        }
        if (mode != 1073741824) {
            size2 = i6 + i8 + paddingBottom;
        }
        setMeasuredDimension(size, size2);
    }

    @Override
    protected void onLayout(boolean z, int i, int i2, int i3, int i4) {
        int i5;
        int i6;
        int i7;
        int i8;
        int i9;
        int i10;
        int i11;
        int i12;
        int i13;
        int i14;
        int i15;
        int i16;
        int i17;
        int i18;
        int paddingLeft = getPaddingLeft();
        int paddingRight = getPaddingRight();
        int paddingTop = getPaddingTop();
        int i19 = i3 - i;
        this.usefulWidth = (i19 - paddingLeft) - paddingRight;
        int i20 = paddingRight + paddingLeft;
        this.lineNumList.clear();
        int i21 = paddingLeft;
        int i22 = i20;
        int i23 = 0;
        int i24 = 0;
        int i25 = 0;
        while (i23 < getChildCount()) {
            View childAt = getChildAt(i23);
            if (childAt.getVisibility() == 8) {
                i20 = i20;
                i23 = i23;
            } else {
                int measuredWidth = childAt.getMeasuredWidth();
                int measuredHeight = childAt.getMeasuredHeight();
                ViewGroup.LayoutParams layoutParams = childAt.getLayoutParams();
                boolean z2 = layoutParams instanceof ViewGroup.MarginLayoutParams;
                if (z2) {
                    ViewGroup.MarginLayoutParams marginLayoutParams = (ViewGroup.MarginLayoutParams) layoutParams;
                    int i26 = marginLayoutParams.leftMargin + marginLayoutParams.rightMargin;
                    int i27 = marginLayoutParams.topMargin + marginLayoutParams.bottomMargin;
                    int i28 = marginLayoutParams.leftMargin + i21;
                    i6 = marginLayoutParams.topMargin + paddingTop;
                    int i29 = marginLayoutParams.leftMargin + i21 + measuredWidth;
                    i7 = marginLayoutParams.topMargin + paddingTop + measuredHeight;
                    i10 = i27;
                    i8 = i28;
                    i5 = i29;
                    i9 = i26;
                } else {
                    i5 = i21 + measuredWidth;
                    i6 = paddingTop;
                    i7 = paddingTop + measuredHeight;
                    i8 = i21;
                    i9 = 0;
                    i10 = 0;
                }
                int i30 = i9 + measuredWidth;
                int i31 = i8;
                int i32 = i10 + measuredHeight;
                int i33 = i5;
                if (i22 + i30 > i19) {
                    this.lineNumList.add(Integer.valueOf(i24));
                    paddingTop += i25 + this.lineSpacing;
                    if (z2) {
                        ViewGroup.MarginLayoutParams marginLayoutParams2 = (ViewGroup.MarginLayoutParams) layoutParams;
                        i11 = marginLayoutParams2.leftMargin + paddingLeft;
                        int i34 = paddingTop + marginLayoutParams2.topMargin;
                        i18 = marginLayoutParams2.leftMargin + paddingLeft + measuredWidth;
                        int i35 = marginLayoutParams2.topMargin + paddingTop + measuredHeight;
                        i15 = i20;
                        i16 = paddingLeft;
                        i13 = i34;
                        i14 = i35;
                        i17 = 0;
                        i12 = 0;
                    } else {
                        int i36 = paddingTop + measuredHeight;
                        i15 = i20;
                        i16 = paddingLeft;
                        i13 = paddingTop;
                        i18 = paddingLeft + measuredWidth;
                        i14 = i36;
                        i17 = 0;
                        i12 = 0;
                        i11 = i16;
                    }
                } else {
                    i11 = i31;
                    i12 = i25;
                    i13 = i6;
                    i14 = i7;
                    i15 = i22;
                    i16 = i21;
                    i17 = i24;
                    i18 = i33;
                }
                childAt.layout(i11, i13, i18, i14);
                i24 = i17 + 1;
                if (i32 > i12) {
                    i12 = i32;
                }
                i21 = i16 + i30;
                i22 = i15 + i30;
                i25 = i12;
            }
            i23++;
            i20 = i20;
        }
        this.lineNumList.add(Integer.valueOf(i24));
    }

    public void update(List<RPAStep.Action> list, boolean z) {
        if (list != null) {
            removeAllViews();
            for (final RPAStep.Action action : list) {
                if (action != null && !TextUtils.isEmpty(action.getContent())) {
                    ViewGroup.MarginLayoutParams marginLayoutParams = new ViewGroup.MarginLayoutParams(-2, -2);
                    marginLayoutParams.setMargins(0, 0, dpToPx(12.0f), 0);
                    TextView textView = new TextView(getContext());
                    textView.setBackground(Styles.getDrawable(Styles.getColorWithAlpha(CustomConfig.CommonSetting.textColor, 0.1d), 3));
                    Styles.reRenderTextView(textView, action.getContent());
                    textView.setTextSize(2, 13.0f);
                    textView.setPadding(dpToPx(6.0f), dpToPx(4.0f), dpToPx(6.0f), dpToPx(4.0f));
                    textView.setOnClickListener(new View.OnClickListener() {
                        @Override
                        public void onClick(View view) {
                            if (AIHelpFlowLayout.this.mListener != null) {
                                AIHelpFlowLayout.this.mListener.onLabelClicked(action);
                            }
                        }
                    });
                    addView(textView, marginLayoutParams);
                }
            }
        }
        if (z) {
            relayoutToCompressAndAlign();
        }
    }

    public void relayoutToCompress() {
        post(new Runnable() {
            @Override
            public void run() {
                AIHelpFlowLayout.this.compress();
            }
        });
    }

    public void compress() {
        int childCount = getChildCount();
        if (childCount == 0) {
            return;
        }
        int i = 0;
        for (int i2 = 0; i2 < childCount; i2++) {
            if (!(getChildAt(i2) instanceof BlankView)) {
                i++;
            }
        }
        View[] viewArr = new View[i];
        int[] iArr = new int[i];
        int i3 = 0;
        for (int i4 = 0; i4 < childCount; i4++) {
            View childAt = getChildAt(i4);
            if (!(childAt instanceof BlankView)) {
                viewArr[i3] = childAt;
                ViewGroup.LayoutParams layoutParams = childAt.getLayoutParams();
                int measuredWidth = childAt.getMeasuredWidth();
                if (layoutParams instanceof ViewGroup.MarginLayoutParams) {
                    ViewGroup.MarginLayoutParams marginLayoutParams = (ViewGroup.MarginLayoutParams) layoutParams;
                    iArr[i3] = marginLayoutParams.leftMargin + measuredWidth + marginLayoutParams.rightMargin;
                } else {
                    iArr[i3] = measuredWidth;
                }
                i3++;
            }
        }
        int[] iArr2 = new int[i];
        for (int i5 = 0; i5 < i; i5++) {
            iArr2[i5] = Math.min(iArr[i5], this.usefulWidth);
        }
        sortToCompress(viewArr, iArr2);
        removeAllViews();
        Iterator<View> it = this.childList.iterator();
        while (it.hasNext()) {
            addView(it.next());
        }
        this.childList.clear();
    }

    private void sortToCompress(View[] viewArr, int[] iArr) {
        int length = viewArr.length;
        int i = length + 1;
        int[][] iArr2 = (int[][]) Array.newInstance((Class<?>) Integer.TYPE, i, this.usefulWidth + 1);
        for (int i2 = 0; i2 < i; i2++) {
            for (int i3 = 0; i3 < this.usefulWidth; i3++) {
                iArr2[i2][i3] = 0;
            }
        }
        boolean[] zArr = new boolean[length];
        for (int i4 = 0; i4 < length; i4++) {
            zArr[i4] = false;
        }
        for (int i5 = 1; i5 <= length; i5++) {
            int i6 = i5 - 1;
            for (int i7 = iArr[i6]; i7 <= this.usefulWidth; i7++) {
                int[] iArr3 = iArr2[i5];
                int[] iArr4 = iArr2[i6];
                int i8 = iArr4[i7];
                int i9 = iArr[i6];
                iArr3[i7] = Math.max(i8, iArr4[i7 - i9] + i9);
            }
        }
        int i10 = this.usefulWidth;
        for (int i11 = length; i11 > 0; i11--) {
            int i12 = i11 - 1;
            int i13 = iArr[i12];
            if (i10 < i13) {
                break;
            }
            if (iArr2[i11][i10] == iArr2[i12][i10 - i13] + i13) {
                zArr[i12] = true;
                i10 -= i13;
            }
        }
        int i14 = length;
        for (int i15 = 0; i15 < length; i15++) {
            if (zArr[i15]) {
                this.childList.add(viewArr[i15]);
                i14--;
            }
        }
        if (i14 == 0) {
            return;
        }
        View[] viewArr2 = new View[i14];
        int[] iArr5 = new int[i14];
        int i16 = 0;
        for (int i17 = 0; i17 < length; i17++) {
            if (!zArr[i17]) {
                viewArr2[i16] = viewArr[i17];
                iArr5[i16] = iArr[i17];
                i16++;
            }
        }
        sortToCompress(viewArr2, iArr5);
    }

    public void relayoutToAlign() {
        post(new Runnable() {
            @Override
            public void run() {
                AIHelpFlowLayout.this.align();
            }
        });
    }

    public void align() {
        int i;
        int childCount = getChildCount();
        if (childCount == 0) {
            return;
        }
        int i2 = 0;
        for (int i3 = 0; i3 < childCount; i3++) {
            if (!(getChildAt(i3) instanceof BlankView)) {
                i2++;
            }
        }
        View[] viewArr = new View[i2];
        int[] iArr = new int[i2];
        int i4 = 0;
        for (int i5 = 0; i5 < childCount; i5++) {
            View childAt = getChildAt(i5);
            if (!(childAt instanceof BlankView)) {
                viewArr[i4] = childAt;
                ViewGroup.LayoutParams layoutParams = childAt.getLayoutParams();
                int measuredWidth = childAt.getMeasuredWidth();
                if (layoutParams instanceof ViewGroup.MarginLayoutParams) {
                    ViewGroup.MarginLayoutParams marginLayoutParams = (ViewGroup.MarginLayoutParams) layoutParams;
                    iArr[i4] = marginLayoutParams.leftMargin + measuredWidth + marginLayoutParams.rightMargin;
                } else {
                    iArr[i4] = measuredWidth;
                }
                i4++;
            }
        }
        removeAllViews();
        int i6 = 0;
        int i7 = 0;
        int i8 = 0;
        while (i6 < i2) {
            int i9 = iArr[i6];
            int i10 = i8 + i9;
            int i11 = this.usefulWidth;
            if (i10 > i11) {
                int i12 = i11 - i8;
                int i13 = i6 - 1;
                int i14 = i13 - i7;
                if (i14 >= 0) {
                    if (i14 > 0) {
                        ViewGroup.MarginLayoutParams marginLayoutParams2 = new ViewGroup.MarginLayoutParams(i12 / i14, 0);
                        while (i7 < i13) {
                            addView(viewArr[i7]);
                            addView(new BlankView(this.mContext), marginLayoutParams2);
                            i7++;
                        }
                    }
                    addView(viewArr[i13]);
                    i = i6 - 1;
                } else {
                    addView(viewArr[i6]);
                    i = i6;
                    i6++;
                }
                i8 = 0;
                int i15 = i;
                i7 = i6;
                i6 = i15;
            } else {
                i8 += i9;
            }
            i6++;
        }
        while (i7 < i2) {
            addView(viewArr[i7]);
            i7++;
        }
    }

    public void relayoutToCompressAndAlign() {
        post(new Runnable() {
            @Override
            public void run() {
                AIHelpFlowLayout.this.compress();
                AIHelpFlowLayout.this.align();
            }
        });
    }

    public void specifyLines(final int i) {
        post(new Runnable() {
            @Override
            public void run() {
                int size = i;
                if (size > AIHelpFlowLayout.this.lineNumList.size()) {
                    size = AIHelpFlowLayout.this.lineNumList.size();
                }
                int iIntValue = 0;
                for (int i2 = 0; i2 < size; i2++) {
                    iIntValue += AIHelpFlowLayout.this.lineNumList.get(i2).intValue();
                }
                ArrayList arrayList = new ArrayList();
                for (int i3 = 0; i3 < iIntValue; i3++) {
                    arrayList.add(AIHelpFlowLayout.this.getChildAt(i3));
                }
                AIHelpFlowLayout.this.removeAllViews();
                Iterator it = arrayList.iterator();
                while (it.hasNext()) {
                    AIHelpFlowLayout.this.addView((View) it.next());
                }
            }
        });
    }

    @Override
    protected ViewGroup.LayoutParams generateLayoutParams(ViewGroup.LayoutParams layoutParams) {
        return new ViewGroup.MarginLayoutParams(layoutParams);
    }

    @Override
    public ViewGroup.LayoutParams generateLayoutParams(AttributeSet attributeSet) {
        return new ViewGroup.MarginLayoutParams(getContext(), attributeSet);
    }

    @Override
    protected ViewGroup.LayoutParams generateDefaultLayoutParams() {
        return new ViewGroup.MarginLayoutParams(super.generateDefaultLayoutParams());
    }

    static class BlankView extends View {
        public BlankView(Context context) {
            super(context);
        }
    }

    public int dpToPx(float f) {
        return (int) (f * getContext().getResources().getDisplayMetrics().density);
    }
}
