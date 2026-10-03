package zendesk.p026ui.android.conversation.form;

import android.content.Context;
import android.content.res.ColorStateList;
import android.graphics.Rect;
import android.graphics.drawable.Drawable;
import android.os.Parcelable;
import android.text.Editable;
import android.text.TextWatcher;
import android.util.AttributeSet;
import android.util.SparseArray;
import android.view.KeyEvent;
import android.view.View;
import android.view.ViewGroup;
import android.widget.AdapterView;
import android.widget.FrameLayout;
import android.widget.TextView;
import com.google.android.material.shape.MaterialShapeDrawable;
import com.google.android.material.textfield.MaterialAutoCompleteTextView;
import com.google.android.material.textfield.TextInputLayout;
import java.util.List;
import kotlin.Metadata;
import kotlin.NoWhenBranchMatchedException;
import kotlin.Unit;
import kotlin.collections.CollectionsKt;
import kotlin.jvm.functions.Function1;
import kotlin.jvm.internal.DefaultConstructorMarker;
import kotlin.jvm.internal.Intrinsics;
import kotlin.text.Regex;
import kotlin.text.StringsKt;
import net.aihelp.data.track.data.TrackType;
import okhttp3.internal.p011ws.WebSocketProtocol;
import zendesk.p026ui.android.conversation.receipt.MessageReceiptPosition;
import zendesk.p026ui.android.conversation.receipt.MessageReceiptRendering;
import zendesk.p026ui.android.conversation.receipt.MessageReceiptState;
import zendesk.p026ui.android.conversation.receipt.MessageReceiptView;
import zendesk.p026ui.android.internal.Patterns;
import zendesk.p026ui.android.internal.ViewKt;
import zendesk.ui.android.R;
import zendesk.ui.android.Renderer;

@Metadata(m17d1 = {"\u0000¤\u0001\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\b\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u000b\n\u0000\n\u0002\u0010\u000e\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0004\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\f\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\b\u0007\u0018\u00002\u00020\u00012\f\u0012\b\u0012\u0006\u0012\u0002\b\u00030\u00030\u0002B/\b\u0007\u0012\u0006\u0010\u0004\u001a\u00020\u0005\u0012\n\b\u0002\u0010\u0006\u001a\u0004\u0018\u00010\u0007\u0012\b\b\u0002\u0010\b\u001a\u00020\t\u0012\b\b\u0002\u0010\n\u001a\u00020\t¢\u0006\u0002\u0010\u000bJ\u0018\u0010\u0017\u001a\u00020\u00182\u000e\u0010\u0019\u001a\n\u0012\u0004\u0012\u00020\u001b\u0018\u00010\u001aH\u0014J\u0018\u0010\u001c\u001a\u00020\u00182\u000e\u0010\u0019\u001a\n\u0012\u0004\u0012\u00020\u001b\u0018\u00010\u001aH\u0014J$\u0010\u001d\u001a\u00020\u00182\u001a\u0010\u001e\u001a\u0016\u0012\b\u0012\u0006\u0012\u0002\b\u00030\u0003\u0012\b\u0012\u0006\u0012\u0002\b\u00030\u00030\u001fH\u0016J\u0010\u0010 \u001a\u00020!2\u0006\u0010\"\u001a\u00020#H\u0002J\u0014\u0010$\u001a\u00020\u00182\n\u0010%\u001a\u0006\u0012\u0002\b\u00030&H\u0002J\u0014\u0010$\u001a\u00020\u00182\n\u0010%\u001a\u0006\u0012\u0002\b\u00030'H\u0002J\u0014\u0010$\u001a\u00020\u00182\n\u0010%\u001a\u0006\u0012\u0002\b\u00030(H\u0002J\b\u0010)\u001a\u00020!H\u0002J\u001a\u0010*\u001a\u00020!2\u0006\u0010+\u001a\u00020\t2\b\u0010,\u001a\u0004\u0018\u00010-H\u0016J$\u0010.\u001a\u00020\u00182\n\u0010%\u001a\u0006\u0012\u0002\b\u00030'2\u0006\u0010/\u001a\u0002002\u0006\u00101\u001a\u000202H\u0002J\u0012\u00103\u001a\u00020\u00182\b\b\u0002\u00104\u001a\u00020!H\u0002J$\u00105\u001a\u00020\u00182\u0006\u00106\u001a\u0002022\u0006\u00107\u001a\u0002002\n\u0010%\u001a\u0006\u0012\u0002\b\u00030'H\u0002J\u0017\u00108\u001a\u00020!2\b\b\u0002\u00109\u001a\u00020!H\u0000¢\u0006\u0002\b:J\u0012\u0010;\u001a\u0004\u0018\u000102*\u0006\u0012\u0002\b\u00030'H\u0002J\u0014\u0010<\u001a\u00020\u0018*\u0002002\u0006\u00106\u001a\u000202H\u0002J\f\u0010=\u001a\u00020\u0018*\u000200H\u0002J\u0018\u0010>\u001a\u00020\u0018*\u0006\u0012\u0002\b\u00030'2\u0006\u00106\u001a\u000202H\u0002J\u0014\u00108\u001a\u00020!*\u00020?2\u0006\u00109\u001a\u00020!H\u0002J\u0014\u00108\u001a\u00020!*\u00020@2\u0006\u00109\u001a\u00020!H\u0002J\u0014\u00108\u001a\u00020!*\u00020A2\u0006\u00109\u001a\u00020!H\u0002J\u0014\u00108\u001a\u00020!*\u00020B2\u0006\u00109\u001a\u00020!H\u0002R\u000e\u0010\f\u001a\u00020\rX\u0082\u0004¢\u0006\u0002\n\u0000R\u000e\u0010\u000e\u001a\u00020\u000fX\u0082\u0004¢\u0006\u0002\n\u0000R\u000e\u0010\u0010\u001a\u00020\u0011X\u0082\u0004¢\u0006\u0002\n\u0000R\u000e\u0010\u0012\u001a\u00020\u0013X\u0082\u0004¢\u0006\u0002\n\u0000R\u0012\u0010\u0014\u001a\u0006\u0012\u0002\b\u00030\u0003X\u0082\u000e¢\u0006\u0002\n\u0000R\u0010\u0010\u0015\u001a\u0004\u0018\u00010\u0016X\u0082\u000e¢\u0006\u0002\n\u0000¨\u0006C"}, m18d2 = {"Lzendesk/ui/android/conversation/form/FieldView;", "Landroid/widget/FrameLayout;", "Lzendesk/ui/android/Renderer;", "Lzendesk/ui/android/conversation/form/FieldRendering;", "context", "Landroid/content/Context;", "attrs", "Landroid/util/AttributeSet;", "defStyleAttrs", "", "defStyleRes", "(Landroid/content/Context;Landroid/util/AttributeSet;II)V", "fieldInput", "Lcom/google/android/material/textfield/MaterialAutoCompleteTextView;", "fieldLabel", "Landroid/widget/TextView;", "fieldLayout", "Lcom/google/android/material/textfield/TextInputLayout;", "messageReceiptView", "Lzendesk/ui/android/conversation/receipt/MessageReceiptView;", "rendering", "textWatcher", "Landroid/text/TextWatcher;", "dispatchRestoreInstanceState", "", "container", "Landroid/util/SparseArray;", "Landroid/os/Parcelable;", "dispatchSaveInstanceState", "render", "renderingUpdate", "Lkotlin/Function1;", "renderError", "", "error", "", "renderFormField", "fieldRendering", "Lzendesk/ui/android/conversation/form/FieldRendering$Email;", "Lzendesk/ui/android/conversation/form/FieldRendering$Select;", "Lzendesk/ui/android/conversation/form/FieldRendering$Text;", "renderNoError", "requestFocus", "direction", "previouslyFocusedRect", "Landroid/graphics/Rect;", "setPrefillOrFirstOption", "fieldInputAdapter", "Lzendesk/ui/android/conversation/form/FieldInputArrayAdapter;", "firstOption", "Lzendesk/ui/android/conversation/form/SelectOption;", "updateBackground", "hasError", "updateInputFieldOption", "selectedOption", "arrayAdapter", "validate", "includeFocus", "validate$zendesk_ui_ui_android", "getPrefillOption", "updateCurrentSelectedOption", "updateInputFieldText", "updateStateOnSelection", "Lzendesk/ui/android/conversation/form/FieldState;", "Lzendesk/ui/android/conversation/form/FieldState$Email;", "Lzendesk/ui/android/conversation/form/FieldState$Select;", "Lzendesk/ui/android/conversation/form/FieldState$Text;", "zendesk.ui_ui-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
public final class FieldView extends FrameLayout implements Renderer<FieldRendering<?>> {
    public static final int $stable = 8;
    private final MaterialAutoCompleteTextView fieldInput;
    private final TextView fieldLabel;
    private final TextInputLayout fieldLayout;
    private final MessageReceiptView messageReceiptView;
    private FieldRendering<?> rendering;
    private TextWatcher textWatcher;

    public FieldView(Context context) {
        this(context, null, 0, 0, 14, null);
        Intrinsics.checkNotNullParameter(context, "context");
    }

    public FieldView(Context context, AttributeSet attributeSet) {
        this(context, attributeSet, 0, 0, 12, null);
        Intrinsics.checkNotNullParameter(context, "context");
    }

    public FieldView(Context context, AttributeSet attributeSet, int i) {
        this(context, attributeSet, i, 0, 8, null);
        Intrinsics.checkNotNullParameter(context, "context");
    }

    public FieldView(Context context, AttributeSet attributeSet, int i, int i2, int i3, DefaultConstructorMarker defaultConstructorMarker) {
        this(context, (i3 & 2) != 0 ? null : attributeSet, (i3 & 4) != 0 ? 0 : i, (i3 & 8) != 0 ? 0 : i2);
    }

    public FieldView(Context context, AttributeSet attributeSet, int i, int i2) {
        super(context, attributeSet, i, i2);
        Intrinsics.checkNotNullParameter(context, "context");
        this.rendering = new FieldRendering.Text(new FieldState.Text(null, 0, 0, null, null, 0, 0, 0, 0, 511, null), null, null, new Function1<FieldState.Text, FieldState.Text>() {
            @Override
            public final FieldState.Text invoke(FieldState.Text it) {
                Intrinsics.checkNotNullParameter(it, "it");
                return it;
            }
        }, null, 0, 54, null);
        context.getTheme().applyStyle(R.style.ThemeOverlay_ZendeskComponents_Field, false);
        FrameLayout.inflate(context, R.layout.zuia_view_field, this);
        setClipToPadding(false);
        setClipChildren(false);
        View viewFindViewById = findViewById(R.id.zuia_error_indicator);
        Intrinsics.checkNotNullExpressionValue(viewFindViewById, "findViewById(...)");
        this.messageReceiptView = (MessageReceiptView) viewFindViewById;
        TextInputLayout textInputLayoutFindViewById = findViewById(R.id.zuia_field_layout);
        Intrinsics.checkNotNullExpressionValue(textInputLayoutFindViewById, "findViewById(...)");
        TextInputLayout textInputLayout = textInputLayoutFindViewById;
        this.fieldLayout = textInputLayout;
        textInputLayout.setBoxStrokeWidthFocused((int) getResources().getDimension(R.dimen.zuia_border_width));
        View viewFindViewById2 = findViewById(R.id.zuia_field_label);
        Intrinsics.checkNotNullExpressionValue(viewFindViewById2, "findViewById(...)");
        this.fieldLabel = (TextView) viewFindViewById2;
        MaterialAutoCompleteTextView materialAutoCompleteTextViewFindViewById = findViewById(R.id.zuia_field_input);
        Intrinsics.checkNotNullExpressionValue(materialAutoCompleteTextViewFindViewById, "findViewById(...)");
        this.fieldInput = materialAutoCompleteTextViewFindViewById;
        View viewFindViewById3 = textInputLayout.findViewById(com.google.android.material.R.id.text_input_end_icon);
        int dimensionPixelSize = viewFindViewById3.getResources().getDimensionPixelSize(R.dimen.zuia_control_min_size);
        viewFindViewById3.setMinimumWidth(dimensionPixelSize);
        viewFindViewById3.setMinimumHeight(dimensionPixelSize);
        viewFindViewById3.requestLayout();
        this.textWatcher = null;
        render(new Function1<FieldRendering<?>, FieldRendering<?>>() {
            {
                super(1);
            }

            @Override
            public final FieldRendering<?> invoke(FieldRendering<?> it) {
                Intrinsics.checkNotNullParameter(it, "it");
                return FieldView.this.rendering;
            }
        });
    }

    @Override
    public boolean requestFocus(int direction, Rect previouslyFocusedRect) {
        if (previouslyFocusedRect != null) {
            return this.fieldInput.requestFocus(direction, previouslyFocusedRect);
        }
        return false;
    }

    public void render(Function1<? super FieldRendering<?>, ? extends FieldRendering<?>> renderingUpdate) {
        Intrinsics.checkNotNullParameter(renderingUpdate, "renderingUpdate");
        FieldRendering<?> fieldRenderingInvoke = renderingUpdate.invoke(this.rendering);
        this.rendering = fieldRenderingInvoke;
        this.fieldLayout.setBoxStrokeColor(fieldRenderingInvoke.getState().getBorderColor());
        this.fieldLayout.setErrorIconDrawable((Drawable) null);
        this.fieldLabel.setTextColor(this.rendering.getState().getTextColor());
        this.fieldLabel.setText(this.rendering.getState().getLabel());
        TextView textView = this.fieldLabel;
        String label = this.rendering.getState().getLabel();
        int dimensionPixelSize = 0;
        textView.setVisibility(label == null || StringsKt.isBlank(label) ? 8 : 0);
        this.fieldLabel.setContentDescription(getResources().getString(R.string.zuia_form_field_required_accessibility_label, this.fieldLabel.getText()));
        ViewGroup.LayoutParams layoutParams = this.fieldLabel.getLayoutParams();
        Intrinsics.checkNotNull(layoutParams, "null cannot be cast to non-null type android.view.ViewGroup.MarginLayoutParams");
        ViewGroup.MarginLayoutParams marginLayoutParams = (ViewGroup.MarginLayoutParams) layoutParams;
        String label2 = this.rendering.getState().getLabel();
        if (label2 != null && !StringsKt.isBlank(label2)) {
            dimensionPixelSize = getResources().getDimensionPixelSize(R.dimen.zuia_spacing_xsmall);
        }
        marginLayoutParams.bottomMargin = dimensionPixelSize;
        this.fieldLabel.setLayoutParams(marginLayoutParams);
        this.fieldInput.removeTextChangedListener(this.textWatcher);
        this.fieldInput.setTextColor(this.rendering.getState().getTextColor());
        this.fieldInput.setOnFocusChangeListener(new View.OnFocusChangeListener() {
            @Override
            public final void onFocusChange(View view, boolean z) {
                FieldView.render$lambda$2(this.f$0, view, z);
            }
        });
        this.fieldInput.setInputType(this.rendering.getInputType());
        FieldRendering<?> fieldRendering = this.rendering;
        if (fieldRendering instanceof FieldRendering.Text) {
            renderFormField((FieldRendering.Text<?>) fieldRendering);
        } else if (fieldRendering instanceof FieldRendering.Email) {
            renderFormField((FieldRendering.Email<?>) fieldRendering);
        } else if (fieldRendering instanceof FieldRendering.Select) {
            renderFormField((FieldRendering.Select<?>) fieldRendering);
        }
        if (this.rendering instanceof FieldRendering.Select) {
            ViewKt.requestLayoutOnKeyBoardShown(this.fieldInput);
        }
    }

    public static final void render$lambda$2(FieldView this$0, View view, boolean z) {
        Intrinsics.checkNotNullParameter(this$0, "this$0");
        this$0.validate(this$0.rendering.getState(), true);
        updateBackground$default(this$0, false, 1, null);
    }

    private final void renderFormField(final FieldRendering.Select<?> fieldRendering) {
        SelectOption selectOption;
        this.fieldInput.setImeOptions(6);
        this.fieldLayout.setEndIconMode(3);
        ViewKt.outlinedBoxBackground$default(this.fieldLayout, this.rendering.getState().getBorderColor(), 0.0f, 0.0f, 0, 14, null);
        this.fieldLayout.setEndIconTintList(ColorStateList.valueOf(this.rendering.getState().getTextColor()));
        this.fieldLayout.setEndIconCheckable(false);
        this.fieldLayout.setEndIconContentDescription(getResources().getString(R.string.zuia_form_dropdown_menu_accessibility_label, this.fieldLabel.getText()));
        MaterialAutoCompleteTextView materialAutoCompleteTextView = this.fieldInput;
        Drawable drawableCreateWithElevationOverlay = MaterialShapeDrawable.createWithElevationOverlay(getContext());
        drawableCreateWithElevationOverlay.setStrokeWidth(getResources().getDimension(R.dimen.zuia_divider_size));
        drawableCreateWithElevationOverlay.setStrokeColor(ColorStateList.valueOf(this.rendering.getState().getBorderColor()));
        drawableCreateWithElevationOverlay.setCornerSize(getResources().getDimension(R.dimen.zuia_message_cell_radius));
        materialAutoCompleteTextView.setDropDownBackgroundDrawable(drawableCreateWithElevationOverlay);
        Context context = getContext();
        Intrinsics.checkNotNullExpressionValue(context, "getContext(...)");
        final FieldInputArrayAdapter fieldInputArrayAdapter = new FieldInputArrayAdapter(context, R.layout.zuia_item_field_option, fieldRendering.getState().getOptions(), Integer.valueOf(this.rendering.getState().getFocusedBorderColor()));
        this.fieldInput.setAdapter(fieldInputArrayAdapter);
        if (fieldRendering.getState().getSelect().isEmpty()) {
            selectOption = fieldRendering.getState().getOptions().get(0);
        } else {
            selectOption = (SelectOption) CollectionsKt.first((List) fieldRendering.getState().getSelect());
        }
        setPrefillOrFirstOption(fieldRendering, fieldInputArrayAdapter, selectOption);
        this.fieldInput.setOnItemClickListener(new AdapterView.OnItemClickListener() {
            @Override
            public final void onItemClick(AdapterView adapterView, View view, int i, long j) {
                FieldView.renderFormField$lambda$4(fieldInputArrayAdapter, this, fieldRendering, adapterView, view, i, j);
            }
        });
        this.fieldInput.setOnFocusChangeListener(new View.OnFocusChangeListener() {
            @Override
            public final void onFocusChange(View view, boolean z) {
                FieldView.renderFormField$lambda$6(fieldRendering, this, fieldInputArrayAdapter, view, z);
            }
        });
        this.fieldInput.setOnEditorActionListener(new TextView.OnEditorActionListener() {
            @Override
            public final boolean onEditorAction(TextView textView, int i, KeyEvent keyEvent) {
                return FieldView.renderFormField$lambda$7(this.f$0, fieldInputArrayAdapter, fieldRendering, textView, i, keyEvent);
            }
        });
        TextView textView = this.fieldInput;
        TextWatcher textWatcher = new TextWatcher() {
            @Override
            public void beforeTextChanged(CharSequence text, int start, int count, int after) {
            }

            @Override
            public void onTextChanged(CharSequence text, int start, int before, int count) {
            }

            @Override
            public void afterTextChanged(Editable s) {
                Editable editable = s;
                if (editable == null || editable.length() == 0) {
                    fieldInputArrayAdapter.resetInvalidTypedTextQuery$zendesk_ui_ui_android();
                }
            }
        };
        textView.addTextChangedListener(textWatcher);
        this.textWatcher = textWatcher;
    }

    public static final void renderFormField$lambda$4(FieldInputArrayAdapter fieldInputAdapter, FieldView this$0, FieldRendering.Select fieldRendering, AdapterView adapterView, View view, int i, long j) {
        Intrinsics.checkNotNullParameter(fieldInputAdapter, "$fieldInputAdapter");
        Intrinsics.checkNotNullParameter(this$0, "this$0");
        Intrinsics.checkNotNullParameter(fieldRendering, "$fieldRendering");
        this$0.updateInputFieldOption(fieldInputAdapter.getItem(i), fieldInputAdapter, fieldRendering);
    }

    public static final void renderFormField$lambda$6(FieldRendering.Select fieldRendering, FieldView this$0, FieldInputArrayAdapter fieldInputAdapter, View view, boolean z) {
        Intrinsics.checkNotNullParameter(fieldRendering, "$fieldRendering");
        Intrinsics.checkNotNullParameter(this$0, "this$0");
        Intrinsics.checkNotNullParameter(fieldInputAdapter, "$fieldInputAdapter");
        fieldRendering.getOnFieldFocusChanged$zendesk_ui_ui_android().invoke(Boolean.valueOf(z));
        this$0.validate$zendesk_ui_ui_android(true);
        updateBackground$default(this$0, false, 1, null);
        this$0.updateInputFieldText(fieldInputAdapter);
        if (z) {
            if (this$0.getPrefillOption(fieldRendering) != null) {
                this$0.updateInputFieldOption(fieldInputAdapter.getCurrentSelectedOption$zendesk_ui_ui_android(), fieldInputAdapter, fieldRendering);
            }
            this$0.fieldInput.showDropDown();
            ViewKt.requestLayoutOnKeyBoardShown(this$0.fieldInput);
        }
    }

    public static final boolean renderFormField$lambda$7(FieldView this$0, FieldInputArrayAdapter fieldInputAdapter, FieldRendering.Select fieldRendering, TextView textView, int i, KeyEvent keyEvent) {
        Intrinsics.checkNotNullParameter(this$0, "this$0");
        Intrinsics.checkNotNullParameter(fieldInputAdapter, "$fieldInputAdapter");
        Intrinsics.checkNotNullParameter(fieldRendering, "$fieldRendering");
        Editable text = this$0.fieldInput.getText();
        if (text != null && text.length() != 0 && this$0.fieldInput.isPopupShowing() && fieldInputAdapter.hasValidSuggestions$zendesk_ui_ui_android()) {
            this$0.setPrefillOrFirstOption(fieldRendering, fieldInputAdapter, fieldInputAdapter.getItem(0));
        }
        fieldRendering.getOnCheckMarkPressed$zendesk_ui_ui_android().invoke();
        return false;
    }

    private final void updateInputFieldOption(SelectOption selectedOption, FieldInputArrayAdapter arrayAdapter, FieldRendering.Select<?> fieldRendering) {
        updateCurrentSelectedOption(arrayAdapter, selectedOption);
        updateStateOnSelection(fieldRendering, selectedOption);
        this.fieldInput.setText(selectedOption.getLabel(), false);
        this.fieldInput.setSelection(selectedOption.getLabel().length());
    }

    private final void updateStateOnSelection(FieldRendering.Select<?> select, SelectOption selectOption) {
        FieldRendering.Select selectCopy$default = FieldRendering.Select.copy$default(select, FieldState.Select.copy$default(select.getState(), null, CollectionsKt.listOf(selectOption), null, null, 0, 0, 0, 0, TrackType.TRACK_FORM_ACTION_SUBMITTED, null), null, null, null, null, null, 0, WebSocketProtocol.PAYLOAD_SHORT, null);
        this.rendering = selectCopy$default;
        validate(selectCopy$default.getState(), true);
        selectCopy$default.getOnStateChanged().invoke(selectCopy$default.getState());
    }

    private final void setPrefillOrFirstOption(FieldRendering.Select<?> fieldRendering, FieldInputArrayAdapter fieldInputAdapter, SelectOption firstOption) {
        SelectOption prefillOption = getPrefillOption(fieldRendering);
        if (prefillOption != null) {
            firstOption = prefillOption;
        }
        updateInputFieldOption(firstOption, fieldInputAdapter, fieldRendering);
    }

    private final SelectOption getPrefillOption(FieldRendering.Select<?> select) {
        String placeholder = select.getState().getPlaceholder();
        Object obj = null;
        if (placeholder == null || placeholder.length() == 0) {
            return null;
        }
        for (Object obj2 : select.getState().getOptions()) {
            if (Intrinsics.areEqual(((SelectOption) obj2).getId(), select.getState().getPlaceholder())) {
                obj = obj2;
                break;
            }
        }
        return (SelectOption) obj;
    }

    private final void updateCurrentSelectedOption(FieldInputArrayAdapter fieldInputArrayAdapter, SelectOption selectOption) {
        fieldInputArrayAdapter.setCurrentSelectedOption$zendesk_ui_ui_android(selectOption);
        fieldInputArrayAdapter.resetInvalidTypedTextQuery$zendesk_ui_ui_android();
        fieldInputArrayAdapter.resetSuggestions$zendesk_ui_ui_android();
    }

    private final void updateInputFieldText(FieldInputArrayAdapter fieldInputArrayAdapter) {
        if (this.fieldInput.hasFocus()) {
            String invalidTypedTextQuery = fieldInputArrayAdapter.getInvalidTypedTextQuery();
            MaterialAutoCompleteTextView materialAutoCompleteTextView = this.fieldInput;
            if (invalidTypedTextQuery == null) {
                invalidTypedTextQuery = "";
            }
            materialAutoCompleteTextView.setText(invalidTypedTextQuery, false);
            fieldInputArrayAdapter.performFilterOnInvalidTypedQuery$zendesk_ui_ui_android();
            return;
        }
        this.fieldInput.setText(fieldInputArrayAdapter.getCurrentSelectedOption$zendesk_ui_ui_android().getLabel(), false);
        fieldInputArrayAdapter.resetSuggestions$zendesk_ui_ui_android();
    }

    private final void renderFormField(final FieldRendering.Text<?> fieldRendering) {
        this.fieldInput.setText(fieldRendering.getState().getText());
        this.fieldLayout.setEndIconVisible(false);
        ViewKt.outlinedBoxBackground$default(this.fieldLayout, this.rendering.getState().getBorderColor(), 0.0f, 0.0f, 0, 14, null);
        TextView textView = this.fieldInput;
        TextWatcher textWatcher = new TextWatcher() {
            @Override
            public void beforeTextChanged(CharSequence text, int start, int count, int after) {
            }

            @Override
            public void onTextChanged(CharSequence text, int start, int before, int count) {
            }

            @Override
            public void afterTextChanged(Editable s) {
                FieldRendering.Text text = fieldRendering;
                FieldRendering.Text textCopy$default = FieldRendering.Text.copy$default(text, FieldState.Text.copy$default(text.getState(), String.valueOf(s), 0, 0, null, null, 0, 0, 0, 0, 510, null), null, null, null, null, 0, 62, null);
                this.rendering = textCopy$default;
                FieldView fieldView = this;
                fieldView.validate(fieldView.rendering.getState(), true);
                Function1<String, Unit> onTextChanged$zendesk_ui_ui_android = fieldRendering.getOnTextChanged$zendesk_ui_ui_android();
                String text2 = textCopy$default.getState().getText();
                if (text2 == null) {
                    text2 = "";
                }
                onTextChanged$zendesk_ui_ui_android.invoke(text2);
                fieldRendering.getOnStateChanged().invoke(textCopy$default.getState());
            }
        };
        textView.addTextChangedListener(textWatcher);
        this.textWatcher = textWatcher;
        this.fieldInput.setOnFocusChangeListener(new View.OnFocusChangeListener() {
            @Override
            public final void onFocusChange(View view, boolean z) {
                FieldView.renderFormField$lambda$13(fieldRendering, this, view, z);
            }
        });
    }

    public static final void renderFormField$lambda$13(FieldRendering.Text fieldRendering, FieldView this$0, View view, boolean z) {
        Intrinsics.checkNotNullParameter(fieldRendering, "$fieldRendering");
        Intrinsics.checkNotNullParameter(this$0, "this$0");
        fieldRendering.getOnFieldFocusChanged$zendesk_ui_ui_android().invoke(Boolean.valueOf(z));
        updateBackground$default(this$0, false, 1, null);
    }

    private final void renderFormField(final FieldRendering.Email<?> fieldRendering) {
        this.fieldInput.setText(fieldRendering.getState().getEmail());
        this.fieldLayout.setEndIconVisible(false);
        ViewKt.outlinedBoxBackground$default(this.fieldLayout, this.rendering.getState().getBorderColor(), 0.0f, 0.0f, 0, 14, null);
        TextView textView = this.fieldInput;
        TextWatcher textWatcher = new TextWatcher() {
            @Override
            public void beforeTextChanged(CharSequence text, int start, int count, int after) {
            }

            @Override
            public void onTextChanged(CharSequence text, int start, int before, int count) {
            }

            @Override
            public void afterTextChanged(Editable s) {
                FieldRendering.Email email = fieldRendering;
                FieldRendering.Email emailCopy$default = FieldRendering.Email.copy$default(email, FieldState.Email.copy$default(email.getState(), String.valueOf(s), null, null, 0, 0, 0, 0, WebSocketProtocol.PAYLOAD_SHORT, null), null, null, null, null, 0, 62, null);
                this.rendering = emailCopy$default;
                FieldView fieldView = this;
                fieldView.validate(fieldView.rendering.getState(), true);
                Function1<String, Unit> onEmailChanged$zendesk_ui_ui_android = fieldRendering.getOnEmailChanged$zendesk_ui_ui_android();
                String email2 = emailCopy$default.getState().getEmail();
                if (email2 == null) {
                    email2 = "";
                }
                onEmailChanged$zendesk_ui_ui_android.invoke(email2);
                fieldRendering.getOnStateChanged().invoke(emailCopy$default.getState());
            }
        };
        textView.addTextChangedListener(textWatcher);
        this.textWatcher = textWatcher;
        this.fieldInput.setOnFocusChangeListener(new View.OnFocusChangeListener() {
            @Override
            public final void onFocusChange(View view, boolean z) {
                FieldView.renderFormField$lambda$16(fieldRendering, this, view, z);
            }
        });
    }

    public static final void renderFormField$lambda$16(FieldRendering.Email fieldRendering, FieldView this$0, View view, boolean z) {
        Intrinsics.checkNotNullParameter(fieldRendering, "$fieldRendering");
        Intrinsics.checkNotNullParameter(this$0, "this$0");
        fieldRendering.getOnFieldFocusChanged$zendesk_ui_ui_android().invoke(Boolean.valueOf(z));
        updateBackground$default(this$0, false, 1, null);
    }

    static void updateBackground$default(FieldView fieldView, boolean z, int i, Object obj) {
        if ((i & 1) != 0) {
            z = !fieldView.validate$zendesk_ui_ui_android(true);
        }
        fieldView.updateBackground(z);
    }

    private final void updateBackground(boolean hasError) {
        if (hasError) {
            ViewKt.outlinedBoxBackground$default(this.fieldLayout, this.rendering.getState().getOnDangerColor(), 0.0f, 0.0f, 0, 14, null);
        } else if (this.fieldInput.hasFocus()) {
            this.fieldLayout.setBoxStrokeColor(this.rendering.getState().getFocusedBorderColor());
            this.fieldLayout.setEndIconTintList(ColorStateList.valueOf(this.rendering.getState().getFocusedBorderColor()));
        } else {
            ViewKt.outlinedBoxBackground$default(this.fieldLayout, this.rendering.getState().getBorderColor(), 0.0f, 0.0f, 0, 14, null);
            this.fieldLayout.setEndIconTintList(ColorStateList.valueOf(this.rendering.getState().getTextColor()));
        }
    }

    @Override
    protected void dispatchSaveInstanceState(SparseArray<Parcelable> container) {
        dispatchFreezeSelfOnly(container);
    }

    @Override
    protected void dispatchRestoreInstanceState(SparseArray<Parcelable> container) {
        dispatchThawSelfOnly(container);
    }

    public static boolean validate$zendesk_ui_ui_android$default(FieldView fieldView, boolean z, int i, Object obj) {
        if ((i & 1) != 0) {
            z = false;
        }
        return fieldView.validate$zendesk_ui_ui_android(z);
    }

    public final boolean validate$zendesk_ui_ui_android(boolean includeFocus) {
        return validate(this.rendering.getState(), includeFocus);
    }

    public final boolean validate(FieldState fieldState, boolean z) {
        if (fieldState instanceof FieldState.Text) {
            return validate((FieldState.Text) fieldState, z);
        }
        if (fieldState instanceof FieldState.Email) {
            return validate((FieldState.Email) fieldState, z);
        }
        if (fieldState instanceof FieldState.Select) {
            return validate((FieldState.Select) fieldState, z);
        }
        throw new NoWhenBranchMatchedException();
    }

    private final boolean validate(FieldState.Text text, boolean z) {
        boolean zHasFocus = this.fieldInput.hasFocus();
        String text2 = text.getText();
        if (text2 == null) {
            text2 = "";
        }
        int length = text2.length();
        if (length > text.getMaxLength$zendesk_ui_ui_android()) {
            String string = getResources().getString(R.string.zuia_form_field_max_character_error, Integer.valueOf(text.getMaxLength$zendesk_ui_ui_android()));
            Intrinsics.checkNotNullExpressionValue(string, "getString(...)");
            return renderError(string);
        }
        if (z && zHasFocus) {
            return renderNoError();
        }
        String text3 = text.getText();
        if (text3 == null || StringsKt.isBlank(text3)) {
            String string2 = getResources().getString(R.string.zuia_form_field_required_label);
            Intrinsics.checkNotNullExpressionValue(string2, "getString(...)");
            return renderError(string2);
        }
        if (length < text.getMinLength$zendesk_ui_ui_android()) {
            String string3 = getResources().getString(R.string.zuia_form_field_min_character_error, Integer.valueOf(text.getMinLength$zendesk_ui_ui_android()));
            Intrinsics.checkNotNullExpressionValue(string3, "getString(...)");
            return renderError(string3);
        }
        return renderNoError();
    }

    private final boolean validate(FieldState.Email email, boolean z) {
        boolean zHasFocus = this.fieldInput.hasFocus();
        if (z && zHasFocus) {
            return renderNoError();
        }
        Regex email_regex = Patterns.INSTANCE.getEMAIL_REGEX();
        String email2 = email.getEmail();
        if (email2 == null) {
            email2 = "";
        }
        if (email_regex.matches(email2)) {
            return renderNoError();
        }
        String email3 = email.getEmail();
        if (email3 == null || StringsKt.isBlank(email3)) {
            String string = getResources().getString(R.string.zuia_form_field_required_label);
            Intrinsics.checkNotNullExpressionValue(string, "getString(...)");
            return renderError(string);
        }
        String string2 = getResources().getString(R.string.zuia_form_field_invalid_email_error);
        Intrinsics.checkNotNullExpressionValue(string2, "getString(...)");
        return renderError(string2);
    }

    private final boolean validate(FieldState.Select select, boolean z) {
        boolean zHasFocus = this.fieldInput.hasFocus();
        if (z && zHasFocus) {
            return renderNoError();
        }
        if (select.getSelect().isEmpty()) {
            String string = getResources().getString(R.string.zuia_form_field_required_label);
            Intrinsics.checkNotNullExpressionValue(string, "getString(...)");
            return renderError(string);
        }
        return renderNoError();
    }

    private final boolean renderNoError() {
        this.messageReceiptView.render(new Function1<MessageReceiptRendering, MessageReceiptRendering>() {
            @Override
            public final MessageReceiptRendering invoke(MessageReceiptRendering it) {
                Intrinsics.checkNotNullParameter(it, "it");
                return new MessageReceiptRendering.Builder().build();
            }
        });
        updateBackground(false);
        return true;
    }

    private final boolean renderError(final String error) {
        this.messageReceiptView.render(new Function1<MessageReceiptRendering, MessageReceiptRendering>() {
            {
                super(1);
            }

            @Override
            public final MessageReceiptRendering invoke(MessageReceiptRendering it) {
                Intrinsics.checkNotNullParameter(it, "it");
                MessageReceiptRendering.Builder builder = new MessageReceiptRendering.Builder();
                final String str = error;
                final FieldView fieldView = this;
                return builder.state(new Function1<MessageReceiptState, MessageReceiptState>() {
                    {
                        super(1);
                    }

                    @Override
                    public final MessageReceiptState invoke(MessageReceiptState it2) {
                        Intrinsics.checkNotNullParameter(it2, "it");
                        return new MessageReceiptState.Builder().label(str).iconColor(fieldView.rendering.getState().getOnDangerColor()).labelColor(fieldView.rendering.getState().getOnDangerColor()).messageReceiptPosition(MessageReceiptPosition.INBOUND_FAILED).getState();
                    }
                }).build();
            }
        });
        updateBackground(true);
        return false;
    }
}
