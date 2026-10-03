package zendesk.p026ui.android.internal;

import android.content.Context;
import android.content.res.ColorStateList;
import android.graphics.Rect;
import android.graphics.drawable.Drawable;
import android.graphics.drawable.GradientDrawable;
import android.graphics.drawable.StateListDrawable;
import android.view.TouchDelegate;
import android.view.View;
import android.view.ViewTreeObserver;
import android.view.accessibility.AccessibilityNodeInfo;
import android.view.inputmethod.InputMethodManager;
import android.widget.PopupMenu;
import androidx.core.content.ContextCompat;
import com.google.android.material.R;
import com.google.android.material.shape.MaterialShapeDrawable;
import com.google.android.material.textfield.MaterialAutoCompleteTextView;
import java.util.List;
import kotlin.Lazy;
import kotlin.LazyKt;
import kotlin.Metadata;
import kotlin.Unit;
import kotlin.jvm.functions.Function0;
import kotlin.jvm.internal.Intrinsics;

@Metadata(m17d1 = {"\u0000R\n\u0000\n\u0002\u0010\u0007\n\u0000\n\u0002\u0010\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\b\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010 \n\u0002\u0018\u0002\n\u0002\b\b\n\u0002\u0018\u0002\n\u0002\b\u0004\n\u0002\u0018\u0002\n\u0002\b\u0006\n\u0002\u0018\u0002\n\u0002\b\u0002\u001a2\u0010\u0002\u001a\u00020\u0003*\u00020\u00042\b\b\u0002\u0010\u0005\u001a\u00020\u00062\u0006\u0010\u0007\u001a\u00020\u00062\b\b\u0003\u0010\b\u001a\u00020\u00062\b\b\u0002\u0010\t\u001a\u00020\nH\u0000\u001a(\u0010\u000b\u001a\u00020\f*\u00020\u00042\b\b\u0002\u0010\u0005\u001a\u00020\u00062\u0006\u0010\u0007\u001a\u00020\u00062\b\b\u0003\u0010\b\u001a\u00020\u0006H\u0000\u001a2\u0010\r\u001a\u00020\u0003*\u00020\u00042\b\b\u0002\u0010\u0005\u001a\u00020\u00062\u0006\u0010\u0007\u001a\u00020\u00062\b\b\u0003\u0010\b\u001a\u00020\u00062\b\b\u0002\u0010\t\u001a\u00020\nH\u0000\u001a\u001c\u0010\u000e\u001a\u00020\u000f*\u00020\u00042\u000e\u0010\u0010\u001a\n\u0012\u0004\u0012\u00020\u0012\u0018\u00010\u0011H\u0000\u001a<\u0010\u0013\u001a\u00020\u0003*\u00020\u00042\u0006\u0010\u0014\u001a\u00020\u00042\b\b\u0003\u0010\u0015\u001a\u00020\u00062\b\b\u0003\u0010\u0016\u001a\u00020\u00062\b\b\u0003\u0010\u0017\u001a\u00020\u00062\b\b\u0003\u0010\u0018\u001a\u00020\u0006H\u0000\u001a\f\u0010\u0019\u001a\u00020\u0003*\u00020\u0004H\u0000\u001a&\u0010\u001a\u001a\b\u0012\u0004\u0012\u0002H\u001c0\u001b\"\b\b\u0000\u0010\u001c*\u00020\u0004*\u00020\u00042\b\b\u0001\u0010\u001d\u001a\u00020\u0006H\u0000\u001a\u0018\u0010\u001e\u001a\u00020\u0003*\u00020\u00042\f\u0010\u001f\u001a\b\u0012\u0004\u0012\u00020\u00030 \u001a4\u0010!\u001a\u00020\u0003*\u00020\u00042\b\b\u0003\u0010\"\u001a\u00020\u00062\b\b\u0003\u0010#\u001a\u00020\u00012\b\b\u0003\u0010$\u001a\u00020\u00012\b\b\u0003\u0010%\u001a\u00020\u0006H\u0000\u001a\f\u0010&\u001a\u00020\u0003*\u00020'H\u0000\u001a\f\u0010(\u001a\u00020\u0003*\u00020\u0004H\u0002\"\u000e\u0010\u0000\u001a\u00020\u0001X\u0086T¢\u0006\u0002\n\u0000¨\u0006)"}, m18d2 = {"KEYBOARD_HEIGHT_RATIO", "", "addAccessibilityFocusedState", "", "Landroid/view/View;", "focusedDrawableId", "", "strokeDimenId", "strokeColor", "defaultDrawable", "Landroid/graphics/drawable/Drawable;", "addBorderToDrawable", "Landroid/graphics/drawable/GradientDrawable;", "addFocusedState", "createCellContextualMenu", "Landroid/widget/PopupMenu;", "options", "", "Lzendesk/ui/android/internal/ContextualMenuOption;", "expandTouchArea", "parent", "extraPaddingTop", "extraPaddingBottom", "extraPaddingStart", "extraPaddingEnd", "focusAndShowKeyboard", "lazyViewById", "Lkotlin/Lazy;", "T", "viewId", "onKeyboardShown", "performAction", "Lkotlin/Function0;", "outlinedBoxBackground", "borderColor", "borderRadius", "borderWidth", "backgroundColor", "requestLayoutOnKeyBoardShown", "Lcom/google/android/material/textfield/MaterialAutoCompleteTextView;", "showKeyboardNow", "zendesk.ui_ui-android"}, m19k = 2, m20mv = {1, 9, 0}, m22xi = 48)
public final class ViewKt {
    public static final float KEYBOARD_HEIGHT_RATIO = 0.15f;

    public static void outlinedBoxBackground$default(View view, int i, float f, float f2, int i2, int i3, Object obj) {
        if ((i3 & 1) != 0) {
            Context context = view.getContext();
            Intrinsics.checkNotNullExpressionValue(context, "getContext(...)");
            i = ColorExtKt.adjustAlpha(ColorExtKt.resolveColorAttr(context, R.attr.colorOnSurface), 0.12f);
        }
        if ((i3 & 2) != 0) {
            f = view.getResources().getDimension(zendesk.ui.android.R.dimen.zuia_message_cell_radius);
        }
        if ((i3 & 4) != 0) {
            f2 = view.getResources().getDimension(zendesk.ui.android.R.dimen.zuia_divider_size);
        }
        if ((i3 & 8) != 0) {
            i2 = ContextCompat.getColor(view.getContext(), zendesk.ui.android.R.color.zuia_color_transparent);
        }
        outlinedBoxBackground(view, i, f, f2, i2);
    }

    public static final void outlinedBoxBackground(View view, int i, float f, float f2, int i2) {
        Intrinsics.checkNotNullParameter(view, "<this>");
        MaterialShapeDrawable materialShapeDrawableCreateWithElevationOverlay = MaterialShapeDrawable.createWithElevationOverlay(view.getContext());
        materialShapeDrawableCreateWithElevationOverlay.setFillColor(ColorStateList.valueOf(i2));
        materialShapeDrawableCreateWithElevationOverlay.setStrokeWidth(f2);
        materialShapeDrawableCreateWithElevationOverlay.setStrokeColor(ColorStateList.valueOf(i));
        materialShapeDrawableCreateWithElevationOverlay.setCornerSize(f);
        view.setBackground((Drawable) materialShapeDrawableCreateWithElevationOverlay);
    }

    public static final void focusAndShowKeyboard(final View view) {
        Intrinsics.checkNotNullParameter(view, "<this>");
        view.requestFocus();
        if (view.hasWindowFocus()) {
            showKeyboardNow(view);
        } else {
            view.getViewTreeObserver().addOnWindowFocusChangeListener(new ViewTreeObserver.OnWindowFocusChangeListener() {
                @Override
                public void onWindowFocusChanged(boolean hasFocus) {
                    if (hasFocus) {
                        view.getViewTreeObserver().removeOnWindowFocusChangeListener(this);
                        ViewKt.showKeyboardNow(view);
                    }
                }
            });
        }
    }

    public static final void requestLayoutOnKeyBoardShown(final MaterialAutoCompleteTextView materialAutoCompleteTextView) {
        Intrinsics.checkNotNullParameter(materialAutoCompleteTextView, "<this>");
        materialAutoCompleteTextView.getViewTreeObserver().addOnGlobalLayoutListener(new ViewTreeObserver.OnGlobalLayoutListener() {
            @Override
            public void onGlobalLayout() {
                View view = materialAutoCompleteTextView;
                final MaterialAutoCompleteTextView materialAutoCompleteTextView2 = materialAutoCompleteTextView;
                ViewKt.onKeyboardShown(view, new Function0<Unit>() {
                    {
                        super(0);
                    }

                    @Override
                    public Unit invoke() {
                        invoke2();
                        return Unit.INSTANCE;
                    }

                    public final void invoke2() {
                        if (materialAutoCompleteTextView2.isPopupShowing()) {
                            materialAutoCompleteTextView2.requestLayout();
                        }
                        materialAutoCompleteTextView2.getViewTreeObserver().removeOnGlobalLayoutListener(this);
                    }
                });
            }
        });
    }

    public static final void showKeyboardNow(final View view) {
        if (view.isFocused()) {
            view.post(new Runnable() {
                @Override
                public final void run() {
                    ViewKt.showKeyboardNow$lambda$1(view);
                }
            });
        }
    }

    public static final void showKeyboardNow$lambda$1(View this_showKeyboardNow) {
        Intrinsics.checkNotNullParameter(this_showKeyboardNow, "$this_showKeyboardNow");
        Object systemService = this_showKeyboardNow.getContext().getSystemService("input_method");
        Intrinsics.checkNotNull(systemService, "null cannot be cast to non-null type android.view.inputmethod.InputMethodManager");
        ((InputMethodManager) systemService).showSoftInput(this_showKeyboardNow, 1);
    }

    public static final <T extends View> Lazy<T> lazyViewById(final View view, final int i) {
        Intrinsics.checkNotNullParameter(view, "<this>");
        return LazyKt.lazy(new Function0<T>() {
            {
                super(0);
            }

            @Override
            public final View invoke() {
                return view.findViewById(i);
            }
        });
    }

    public static final void onKeyboardShown(View view, Function0<Unit> performAction) {
        Intrinsics.checkNotNullParameter(view, "<this>");
        Intrinsics.checkNotNullParameter(performAction, "performAction");
        Rect rect = new Rect();
        view.getWindowVisibleDisplayFrame(rect);
        int height = view.getRootView().getHeight();
        if (height - rect.bottom > height * 0.15f) {
            performAction.invoke();
        }
    }

    public static void expandTouchArea$default(View view, View view2, int i, int i2, int i3, int i4, int i5, Object obj) {
        if ((i5 & 2) != 0) {
            i = view.getResources().getDimensionPixelSize(zendesk.ui.android.R.dimen.zuia_default_expanded_touch_area);
        }
        int i6 = i;
        if ((i5 & 4) != 0) {
            i2 = view.getResources().getDimensionPixelSize(zendesk.ui.android.R.dimen.zuia_default_expanded_touch_area);
        }
        int i7 = i2;
        if ((i5 & 8) != 0) {
            i3 = view.getResources().getDimensionPixelSize(zendesk.ui.android.R.dimen.zuia_default_expanded_touch_area);
        }
        int i8 = i3;
        if ((i5 & 16) != 0) {
            i4 = view.getResources().getDimensionPixelSize(zendesk.ui.android.R.dimen.zuia_default_expanded_touch_area);
        }
        expandTouchArea(view, view2, i6, i7, i8, i4);
    }

    public static final void expandTouchArea(final View view, final View parent, final int i, final int i2, final int i3, final int i4) {
        Intrinsics.checkNotNullParameter(view, "<this>");
        Intrinsics.checkNotNullParameter(parent, "parent");
        parent.post(new Runnable() {
            @Override
            public final void run() {
                ViewKt.expandTouchArea$lambda$2(view, i, i3, i4, i2, parent);
            }
        });
    }

    public static final void expandTouchArea$lambda$2(View this_expandTouchArea, int i, int i2, int i3, int i4, View parent) {
        Intrinsics.checkNotNullParameter(this_expandTouchArea, "$this_expandTouchArea");
        Intrinsics.checkNotNullParameter(parent, "$parent");
        Rect rect = new Rect();
        this_expandTouchArea.getHitRect(rect);
        rect.top -= i;
        rect.left -= i2;
        rect.right += i3;
        rect.bottom += i4;
        parent.setTouchDelegate(new TouchDelegate(rect, this_expandTouchArea));
    }

    public static void addFocusedState$default(View view, int i, int i2, int i3, Drawable drawable, int i4, Object obj) {
        if ((i4 & 1) != 0) {
            i = 0;
        }
        if ((i4 & 4) != 0) {
            i3 = 0;
        }
        if ((i4 & 8) != 0) {
            drawable = view.getBackground();
            Intrinsics.checkNotNullExpressionValue(drawable, "getBackground(...)");
        }
        addFocusedState(view, i, i2, i3, drawable);
    }

    public static final void addFocusedState(View view, int i, int i2, int i3, Drawable defaultDrawable) {
        Intrinsics.checkNotNullParameter(view, "<this>");
        Intrinsics.checkNotNullParameter(defaultDrawable, "defaultDrawable");
        StateListDrawable stateListDrawable = new StateListDrawable();
        Drawable drawable = ContextCompat.getDrawable(view.getContext(), i);
        Intrinsics.checkNotNull(drawable, "null cannot be cast to non-null type android.graphics.drawable.GradientDrawable");
        GradientDrawable gradientDrawable = (GradientDrawable) drawable;
        gradientDrawable.mutate();
        gradientDrawable.setStroke(view.getResources().getDimensionPixelSize(i2), i3);
        stateListDrawable.addState(new int[]{android.R.attr.state_focused}, gradientDrawable);
        stateListDrawable.addState(new int[0], defaultDrawable);
        view.setBackground(stateListDrawable);
    }

    public static GradientDrawable addBorderToDrawable$default(View view, int i, int i2, int i3, int i4, Object obj) {
        if ((i4 & 1) != 0) {
            i = 0;
        }
        if ((i4 & 4) != 0) {
            i3 = 0;
        }
        return addBorderToDrawable(view, i, i2, i3);
    }

    public static final GradientDrawable addBorderToDrawable(View view, int i, int i2, int i3) {
        Intrinsics.checkNotNullParameter(view, "<this>");
        Drawable drawable = ContextCompat.getDrawable(view.getContext(), i);
        Intrinsics.checkNotNull(drawable, "null cannot be cast to non-null type android.graphics.drawable.GradientDrawable");
        GradientDrawable gradientDrawable = (GradientDrawable) drawable;
        gradientDrawable.mutate();
        gradientDrawable.setStroke(view.getResources().getDimensionPixelSize(i2), i3);
        return gradientDrawable;
    }

    public static void addAccessibilityFocusedState$default(View view, int i, int i2, int i3, Drawable drawable, int i4, Object obj) {
        if ((i4 & 1) != 0) {
            i = 0;
        }
        if ((i4 & 4) != 0) {
            i3 = 0;
        }
        if ((i4 & 8) != 0) {
            drawable = view.getBackground();
            Intrinsics.checkNotNullExpressionValue(drawable, "getBackground(...)");
        }
        addAccessibilityFocusedState(view, i, i2, i3, drawable);
    }

    public static final void addAccessibilityFocusedState(final View view, final int i, final int i2, final int i3, final Drawable defaultDrawable) {
        Intrinsics.checkNotNullParameter(view, "<this>");
        Intrinsics.checkNotNullParameter(defaultDrawable, "defaultDrawable");
        view.setAccessibilityDelegate(new View.AccessibilityDelegate() {
            @Override
            public void onInitializeAccessibilityNodeInfo(View host, AccessibilityNodeInfo info) {
                Intrinsics.checkNotNullParameter(host, "host");
                Intrinsics.checkNotNullParameter(info, "info");
                super.onInitializeAccessibilityNodeInfo(host, info);
                if (info.isAccessibilityFocused()) {
                    view.setBackground(ViewKt.addBorderToDrawable(view, i, i2, i3));
                } else {
                    view.setBackground(defaultDrawable);
                }
            }
        });
    }

    public static final PopupMenu createCellContextualMenu(View view, List<ContextualMenuOption> list) {
        Intrinsics.checkNotNullParameter(view, "<this>");
        PopupMenu popupMenu = new PopupMenu(view.getContext(), view);
        if (list != null) {
            for (ContextualMenuOption contextualMenuOption : list) {
                popupMenu.getMenu().add(0, contextualMenuOption.getOptionId(), 0, contextualMenuOption.getOptionTitle());
            }
        }
        return popupMenu;
    }
}
