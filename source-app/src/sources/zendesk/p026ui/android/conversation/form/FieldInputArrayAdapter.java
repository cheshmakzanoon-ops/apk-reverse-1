package zendesk.p026ui.android.conversation.form;

import android.content.Context;
import android.content.res.ColorStateList;
import android.graphics.drawable.Drawable;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.view.accessibility.AccessibilityNodeInfo;
import android.widget.ArrayAdapter;
import android.widget.CheckedTextView;
import android.widget.Filter;
import android.widget.Filterable;
import com.google.android.material.shape.MaterialShapeDrawable;
import java.util.ArrayList;
import java.util.List;
import java.util.Locale;
import kotlin.Metadata;
import kotlin.collections.CollectionsKt;
import kotlin.jvm.internal.Intrinsics;
import kotlin.text.StringsKt;
import zendesk.p026ui.android.internal.ColorExtKt;
import zendesk.ui.android.R;

@Metadata(m17d1 = {"\u0000d\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\b\n\u0000\n\u0002\u0010 \n\u0002\b\u0004\n\u0002\u0018\u0002\n\u0002\b\u0004\n\u0002\u0010\u000e\n\u0002\b\u0006\n\u0002\u0018\u0002\n\u0002\b\u0007\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u000b\n\u0002\b\u0002\n\u0002\u0010\u0002\n\u0002\b\t\n\u0002\u0018\u0002\n\u0002\b\u0002\b\u0000\u0018\u00002\b\u0012\u0004\u0012\u00020\u00020\u00012\u00020\u0003B/\u0012\u0006\u0010\u0004\u001a\u00020\u0005\u0012\u0006\u0010\u0006\u001a\u00020\u0007\u0012\f\u0010\b\u001a\b\u0012\u0004\u0012\u00020\u00020\t\u0012\n\b\u0001\u0010\n\u001a\u0004\u0018\u00010\u0007¢\u0006\u0002\u0010\u000bJ\b\u0010\u0016\u001a\u00020\u0007H\u0016J\r\u0010\u0017\u001a\u00020\u0002H\u0000¢\u0006\u0002\b\u0018J\b\u0010\u0019\u001a\u00020\u001aH\u0016J\u000f\u0010\u001b\u001a\u0004\u0018\u00010\u0013H\u0000¢\u0006\u0002\b\u001cJ\u0010\u0010\u001d\u001a\u00020\u00022\u0006\u0010\u001e\u001a\u00020\u0007H\u0016J\u0018\u0010\u001f\u001a\b\u0012\u0004\u0012\u00020\u00020\t2\b\u0010 \u001a\u0004\u0018\u00010\u0013H\u0002J\"\u0010!\u001a\u00020\"2\u0006\u0010\u001e\u001a\u00020\u00072\b\u0010#\u001a\u0004\u0018\u00010\"2\u0006\u0010$\u001a\u00020%H\u0016J\r\u0010&\u001a\u00020'H\u0000¢\u0006\u0002\b(J\r\u0010)\u001a\u00020*H\u0000¢\u0006\u0002\b+J\r\u0010,\u001a\u00020*H\u0000¢\u0006\u0002\b-J\r\u0010.\u001a\u00020*H\u0000¢\u0006\u0002\b/J\u0015\u00100\u001a\u00020*2\u0006\u00101\u001a\u00020\u0002H\u0000¢\u0006\u0002\b2J\u0014\u00103\u001a\u00020**\u0002042\u0006\u0010\u001e\u001a\u00020\u0007H\u0002J\u0016\u00105\u001a\u000204*\u0004\u0018\u00010\"2\u0006\u0010$\u001a\u00020%H\u0002R\u0014\u0010\b\u001a\b\u0012\u0004\u0012\u00020\u00020\tX\u0082\u0004¢\u0006\u0002\n\u0000R\u000e\u0010\f\u001a\u00020\u0002X\u0082.¢\u0006\u0002\n\u0000R\u0011\u0010\r\u001a\u00020\u000e¢\u0006\b\n\u0000\u001a\u0004\b\u000f\u0010\u0010R\u0012\u0010\n\u001a\u0004\u0018\u00010\u0007X\u0082\u0004¢\u0006\u0004\n\u0002\u0010\u0011R\u0010\u0010\u0012\u001a\u0004\u0018\u00010\u0013X\u0082\u000e¢\u0006\u0002\n\u0000R\u000e\u0010\u0006\u001a\u00020\u0007X\u0082\u0004¢\u0006\u0002\n\u0000R\u000e\u0010\u0014\u001a\u00020\u0002X\u0082\u0004¢\u0006\u0002\n\u0000R\u0014\u0010\u0015\u001a\b\u0012\u0004\u0012\u00020\u00020\tX\u0082\u000e¢\u0006\u0002\n\u0000¨\u00066"}, m18d2 = {"Lzendesk/ui/android/conversation/form/FieldInputArrayAdapter;", "Landroid/widget/ArrayAdapter;", "Lzendesk/ui/android/conversation/form/SelectOption;", "Landroid/widget/Filterable;", "context", "Landroid/content/Context;", "layoutResource", "", "allMenuOptions", "", "focusedBorderColor", "(Landroid/content/Context;ILjava/util/List;Ljava/lang/Integer;)V", "currentSelectedOption", "focusedBackground", "Lcom/google/android/material/shape/MaterialShapeDrawable;", "getFocusedBackground", "()Lcom/google/android/material/shape/MaterialShapeDrawable;", "Ljava/lang/Integer;", "invalidTypedTextQuery", "", "noMatchesFound", "suggestedMenuOptions", "getCount", "getCurrentSelectedOption", "getCurrentSelectedOption$zendesk_ui_ui_android", "getFilter", "Landroid/widget/Filter;", "getInvalidTypedTextQuery", "getInvalidTypedTextQuery$zendesk_ui_ui_android", "getItem", "position", "getSuggestions", "query", "getView", "Landroid/view/View;", "convertView", "parent", "Landroid/view/ViewGroup;", "hasValidSuggestions", "", "hasValidSuggestions$zendesk_ui_ui_android", "performFilterOnInvalidTypedQuery", "", "performFilterOnInvalidTypedQuery$zendesk_ui_ui_android", "resetInvalidTypedTextQuery", "resetInvalidTypedTextQuery$zendesk_ui_ui_android", "resetSuggestions", "resetSuggestions$zendesk_ui_ui_android", "setCurrentSelectedOption", "selectedOption", "setCurrentSelectedOption$zendesk_ui_ui_android", "disableIfNoMatchesFound", "Landroid/widget/CheckedTextView;", "toCheckedTextView", "zendesk.ui_ui-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
public final class FieldInputArrayAdapter extends ArrayAdapter<SelectOption> implements Filterable {
    public static final int $stable = 8;
    private final List<SelectOption> allMenuOptions;
    private SelectOption currentSelectedOption;
    private final MaterialShapeDrawable focusedBackground;
    private final Integer focusedBorderColor;
    private String invalidTypedTextQuery;
    private final int layoutResource;
    private final SelectOption noMatchesFound;
    private List<SelectOption> suggestedMenuOptions;

    public FieldInputArrayAdapter(Context context, int i, List<SelectOption> allMenuOptions, Integer num) {
        super(context, i, allMenuOptions);
        Intrinsics.checkNotNullParameter(context, "context");
        Intrinsics.checkNotNullParameter(allMenuOptions, "allMenuOptions");
        this.layoutResource = i;
        this.allMenuOptions = allMenuOptions;
        this.focusedBorderColor = num;
        this.suggestedMenuOptions = allMenuOptions;
        String string = context.getString(R.string.zuia_no_matches_found_label);
        Intrinsics.checkNotNullExpressionValue(string, "getString(...)");
        this.noMatchesFound = new SelectOption("", string);
        MaterialShapeDrawable materialShapeDrawableCreateWithElevationOverlay = MaterialShapeDrawable.createWithElevationOverlay(context);
        materialShapeDrawableCreateWithElevationOverlay.setStrokeWidth(context.getResources().getDimension(R.dimen.zuia_border_width));
        materialShapeDrawableCreateWithElevationOverlay.setStrokeColor(ColorStateList.valueOf(num != null ? num.intValue() : ColorExtKt.resolveColorAttr(context, androidx.appcompat.R.attr.colorAccent)));
        Intrinsics.checkNotNullExpressionValue(materialShapeDrawableCreateWithElevationOverlay, "apply(...)");
        this.focusedBackground = materialShapeDrawableCreateWithElevationOverlay;
    }

    public final MaterialShapeDrawable getFocusedBackground() {
        return this.focusedBackground;
    }

    @Override
    public int getCount() {
        return this.suggestedMenuOptions.size();
    }

    @Override
    public SelectOption getItem(int position) {
        return this.suggestedMenuOptions.get(position);
    }

    @Override
    public View getView(int position, View convertView, ViewGroup parent) {
        Intrinsics.checkNotNullParameter(parent, "parent");
        final CheckedTextView checkedTextView = toCheckedTextView(convertView, parent);
        checkedTextView.setText(getItem(position).getLabel());
        disableIfNoMatchesFound(checkedTextView, position);
        checkedTextView.setAccessibilityDelegate(new View.AccessibilityDelegate() {
            @Override
            public void onInitializeAccessibilityNodeInfo(View host, AccessibilityNodeInfo info) {
                Intrinsics.checkNotNullParameter(host, "host");
                Intrinsics.checkNotNullParameter(info, "info");
                super.onInitializeAccessibilityNodeInfo(host, info);
                if (info.isAccessibilityFocused() && !Intrinsics.areEqual(checkedTextView.getBackground(), this.getFocusedBackground())) {
                    checkedTextView.setBackground((Drawable) this.getFocusedBackground());
                } else {
                    if (info.isAccessibilityFocused() || !Intrinsics.areEqual(checkedTextView.getBackground(), this.getFocusedBackground())) {
                        return;
                    }
                    checkedTextView.setBackground(null);
                }
            }
        });
        return checkedTextView;
    }

    @Override
    public Filter getFilter() {
        return new Filter() {
            @Override
            protected void publishResults(CharSequence charSequence, Filter.FilterResults filterResults) {
                Intrinsics.checkNotNullParameter(filterResults, "filterResults");
                FieldInputArrayAdapter fieldInputArrayAdapter = FieldInputArrayAdapter.this;
                Object obj = filterResults.values;
                Intrinsics.checkNotNull(obj, "null cannot be cast to non-null type kotlin.collections.List<zendesk.ui.android.conversation.form.SelectOption>");
                fieldInputArrayAdapter.suggestedMenuOptions = (List) obj;
                FieldInputArrayAdapter.this.notifyDataSetChanged();
            }

            @Override
            protected Filter.FilterResults performFiltering(CharSequence charSequence) {
                String lowerCase;
                String string;
                if (charSequence == null || (string = charSequence.toString()) == null) {
                    lowerCase = null;
                } else {
                    Locale locale = Locale.getDefault();
                    Intrinsics.checkNotNullExpressionValue(locale, "getDefault(...)");
                    lowerCase = string.toLowerCase(locale);
                    Intrinsics.checkNotNullExpressionValue(lowerCase, "toLowerCase(...)");
                }
                Filter.FilterResults filterResults = new Filter.FilterResults();
                filterResults.values = FieldInputArrayAdapter.this.getSuggestions(lowerCase);
                return filterResults;
            }
        };
    }

    public final void resetSuggestions$zendesk_ui_ui_android() {
        if (this.suggestedMenuOptions.size() != this.allMenuOptions.size()) {
            getFilter().filter(null);
        }
    }

    public final void performFilterOnInvalidTypedQuery$zendesk_ui_ui_android() {
        String str = this.invalidTypedTextQuery;
        if (str == null || str.length() == 0) {
            return;
        }
        getFilter().filter(this.invalidTypedTextQuery);
    }

    public final void setCurrentSelectedOption$zendesk_ui_ui_android(SelectOption selectedOption) {
        Intrinsics.checkNotNullParameter(selectedOption, "selectedOption");
        this.currentSelectedOption = selectedOption;
    }

    public final SelectOption getCurrentSelectedOption$zendesk_ui_ui_android() {
        SelectOption selectOption = this.currentSelectedOption;
        if (selectOption != null) {
            return selectOption;
        }
        Intrinsics.throwUninitializedPropertyAccessException("currentSelectedOption");
        return null;
    }

    public final String getInvalidTypedTextQuery() {
        return this.invalidTypedTextQuery;
    }

    public final void resetInvalidTypedTextQuery$zendesk_ui_ui_android() {
        if (this.invalidTypedTextQuery != null) {
            this.invalidTypedTextQuery = null;
        }
    }

    public final List<SelectOption> getSuggestions(String query) {
        String str = query;
        if (str == null || str.length() == 0) {
            return this.allMenuOptions;
        }
        List<SelectOption> list = this.allMenuOptions;
        ArrayList arrayList = new ArrayList();
        for (Object obj : list) {
            String label = ((SelectOption) obj).getLabel();
            Locale locale = Locale.getDefault();
            Intrinsics.checkNotNullExpressionValue(locale, "getDefault(...)");
            String lowerCase = label.toLowerCase(locale);
            Intrinsics.checkNotNullExpressionValue(lowerCase, "toLowerCase(...)");
            if (StringsKt.contains$default((CharSequence) lowerCase, (CharSequence) str, false, 2, (Object) null)) {
                arrayList.add(obj);
            }
        }
        ArrayList arrayListListOf = arrayList;
        if (arrayListListOf.isEmpty()) {
            this.invalidTypedTextQuery = query;
            arrayListListOf = CollectionsKt.listOf(this.noMatchesFound);
        }
        return arrayListListOf;
    }

    private final void disableIfNoMatchesFound(CheckedTextView checkedTextView, int i) {
        boolean zAreEqual = Intrinsics.areEqual(getItem(i).getLabel(), this.noMatchesFound.getLabel());
        checkedTextView.setClickable(zAreEqual);
        checkedTextView.setEnabled(!zAreEqual);
    }

    public final boolean hasValidSuggestions$zendesk_ui_ui_android() {
        return (this.suggestedMenuOptions.isEmpty() || Intrinsics.areEqual(this.suggestedMenuOptions.get(0).getLabel(), this.noMatchesFound.getLabel())) ? false : true;
    }

    private final CheckedTextView toCheckedTextView(View view, ViewGroup viewGroup) {
        CheckedTextView checkedTextView = view instanceof CheckedTextView ? (CheckedTextView) view : null;
        if (checkedTextView != null) {
            return checkedTextView;
        }
        View viewInflate = LayoutInflater.from(getContext()).inflate(this.layoutResource, viewGroup, false);
        Intrinsics.checkNotNull(viewInflate, "null cannot be cast to non-null type android.widget.CheckedTextView");
        return (CheckedTextView) viewInflate;
    }
}
