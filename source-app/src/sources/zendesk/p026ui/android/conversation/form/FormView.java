package zendesk.p026ui.android.conversation.form;

import android.content.Context;
import android.util.AttributeSet;
import android.util.TypedValue;
import android.view.KeyEvent;
import android.view.View;
import android.widget.EditText;
import android.widget.FrameLayout;
import android.widget.LinearLayout;
import android.widget.TextView;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.NoSuchElementException;
import kotlin.Metadata;
import kotlin.Unit;
import kotlin.collections.CollectionsKt;
import kotlin.jvm.functions.Function0;
import kotlin.jvm.functions.Function1;
import kotlin.jvm.functions.Function2;
import kotlin.jvm.internal.DefaultConstructorMarker;
import kotlin.jvm.internal.Intrinsics;
import zendesk.core.p017ui.android.internal.xml.AccessibilityExtKt;
import zendesk.p026ui.android.internal.ColorExtKt;
import zendesk.p026ui.android.internal.ViewKt;
import zendesk.ui.android.R;
import zendesk.ui.android.Renderer;
import zendesk.ui.android.common.button.ButtonRendering;
import zendesk.ui.android.common.button.ButtonState;
import zendesk.ui.android.common.button.ButtonView;

@Metadata(m17d1 = {"\u0000~\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\b\n\u0002\b\u0003\n\u0002\u0010\u0007\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010!\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0010\u000b\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0002\b\u0007\n\u0002\u0018\u0002\n\u0002\b\u0007\n\u0002\u0010\u000e\n\u0002\b\u0003\b\u0007\u0018\u0000 9*\u0004\b\u0000\u0010\u00012\u00020\u00022\u000e\u0012\n\u0012\b\u0012\u0004\u0012\u0002H\u00010\u00040\u0003:\u00019B/\b\u0007\u0012\u0006\u0010\u0005\u001a\u00020\u0006\u0012\n\b\u0002\u0010\u0007\u001a\u0004\u0018\u00010\b\u0012\b\b\u0002\u0010\t\u001a\u00020\n\u0012\b\b\u0002\u0010\u000b\u001a\u00020\n¢\u0006\u0002\u0010\fJ$\u0010\u001b\u001a\u00020\u001c2\u0006\u0010\u001d\u001a\u00020\n2\n\b\u0002\u0010\u001e\u001a\u0004\u0018\u00010\u001f2\u0006\u0010 \u001a\u00020\nH\u0002J\b\u0010!\u001a\u00020\u001cH\u0002J\b\u0010\"\u001a\u00020#H\u0002J\u001e\u0010$\u001a\u00020\u001c2\u0006\u0010%\u001a\u00020\n2\f\u0010&\u001a\b\u0012\u0004\u0012\u00020\u001c0'H\u0002J\b\u0010(\u001a\u00020\u001cH\u0002J\b\u0010)\u001a\u00020\u001cH\u0002J\b\u0010*\u001a\u00020#H\u0002J\u001e\u0010+\u001a\u00020\u001c2\u0006\u0010%\u001a\u00020\n2\f\u0010,\u001a\b\u0012\u0004\u0012\u00020\u001c0'H\u0002J(\u0010-\u001a\u00020\u001c2\u001e\u0010.\u001a\u001a\u0012\n\u0012\b\u0012\u0004\u0012\u00028\u00000\u0004\u0012\n\u0012\b\u0012\u0004\u0012\u00028\u00000\u00040/H\u0016J\u0010\u00100\u001a\u00020\u001c2\u0006\u00101\u001a\u00020#H\u0002J\b\u00102\u001a\u00020\u001cH\u0002J\u0018\u00103\u001a\u00020\u001c2\u0006\u0010%\u001a\u00020\n2\u0006\u00104\u001a\u00020\nH\u0002J\u001e\u00105\u001a\u00020\u001c*\u0004\u0018\u00010\u001f2\u0006\u0010\u001d\u001a\u00020\n2\u0006\u00106\u001a\u000207H\u0002J\f\u00108\u001a\u00020\u001c*\u00020\u0014H\u0002R\u000e\u0010\r\u001a\u00020\u000eX\u0082\u000e¢\u0006\u0002\n\u0000R\u000e\u0010\u000f\u001a\u00020\u0010X\u0082\u0004¢\u0006\u0002\n\u0000R\u0014\u0010\u0011\u001a\b\u0012\u0004\u0012\u00028\u00000\u0012X\u0082\u0004¢\u0006\u0002\n\u0000R\u0014\u0010\u0013\u001a\b\u0012\u0004\u0012\u00020\u00140\u0012X\u0082\u0004¢\u0006\u0002\n\u0000R\u000e\u0010\u0015\u001a\u00020\u0016X\u0082\u0004¢\u0006\u0002\n\u0000R\u000e\u0010\u0017\u001a\u00020\u0016X\u0082\u0004¢\u0006\u0002\n\u0000R\u0014\u0010\u0018\u001a\b\u0012\u0004\u0012\u00028\u00000\u0004X\u0082\u000e¢\u0006\u0002\n\u0000R\u000e\u0010\u0019\u001a\u00020\u001aX\u0082\u0004¢\u0006\u0002\n\u0000¨\u0006:"}, m18d2 = {"Lzendesk/ui/android/conversation/form/FormView;", "T", "Landroid/widget/FrameLayout;", "Lzendesk/ui/android/Renderer;", "Lzendesk/ui/android/conversation/form/FormRendering;", "context", "Landroid/content/Context;", "attrs", "Landroid/util/AttributeSet;", "defStyleAttrs", "", "defStyleRes", "(Landroid/content/Context;Landroid/util/AttributeSet;II)V", "borderAlpha", "", "fieldCounterLabel", "Landroid/widget/TextView;", "fieldStates", "", "fieldViews", "Lzendesk/ui/android/conversation/form/FieldView;", "fieldsContainer", "Landroid/widget/LinearLayout;", "formLayout", "rendering", "submitButton", "Lzendesk/ui/android/common/button/ButtonView;", "addFieldView", "", "currentIndex", "displayedField", "Lzendesk/ui/android/conversation/form/DisplayedField;", "numberOfFields", "addFormFieldsFromStorage", "arePreviousFieldsValid", "", "displayNextFieldView", "index", "displayFieldView", "Lkotlin/Function0;", "formViewRenderingUpdate", "getTheFormBorderAlpha", "isCurrentFormStored", "nextActionButtonClicked", "progressToNextFieldView", "render", "renderingUpdate", "Lkotlin/Function1;", "sendActionButtonClicked", "enableSendActionButton", "setDoneActionListener", "updateFieldCounterLabel", "size", "addToListOfDisplayedFormIfNull", "formId", "", "requestViewFocus", "Companion", "zendesk.ui_ui-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
public final class FormView<T> extends FrameLayout implements Renderer<FormRendering<T>> {
    private static final long ACCESSIBILITY_EVENT_DELAY = 500;

    @Deprecated
    public static final float FIELD_COUNTER_ALPHA = 0.65f;
    private float borderAlpha;
    private final TextView fieldCounterLabel;
    private final List<T> fieldStates;
    private final List<FieldView> fieldViews;
    private final LinearLayout fieldsContainer;
    private final LinearLayout formLayout;
    private FormRendering<T> rendering;
    private final ButtonView submitButton;
    private static final Companion Companion = new Companion(null);
    public static final int $stable = 8;

    public FormView(Context context) {
        this(context, null, 0, 0, 14, null);
        Intrinsics.checkNotNullParameter(context, "context");
    }

    public FormView(Context context, AttributeSet attributeSet) {
        this(context, attributeSet, 0, 0, 12, null);
        Intrinsics.checkNotNullParameter(context, "context");
    }

    public FormView(Context context, AttributeSet attributeSet, int i) {
        this(context, attributeSet, i, 0, 8, null);
        Intrinsics.checkNotNullParameter(context, "context");
    }

    public FormView(Context context, AttributeSet attributeSet, int i, int i2, int i3, DefaultConstructorMarker defaultConstructorMarker) {
        this(context, (i3 & 2) != 0 ? null : attributeSet, (i3 & 4) != 0 ? 0 : i, (i3 & 8) != 0 ? 0 : i2);
    }

    public FormView(Context context, AttributeSet attributeSet, int i, int i2) {
        super(context, attributeSet, i, i2);
        Intrinsics.checkNotNullParameter(context, "context");
        this.rendering = new FormRendering<>(null, null, null, null, null, null, null, null, 255, null);
        this.fieldStates = new ArrayList();
        this.fieldViews = new ArrayList();
        FrameLayout.inflate(context, R.layout.zuia_view_form, this);
        View viewFindViewById = findViewById(R.id.zuia_form_fields_container);
        Intrinsics.checkNotNullExpressionValue(viewFindViewById, "findViewById(...)");
        this.fieldsContainer = (LinearLayout) viewFindViewById;
        ButtonView buttonViewFindViewById = findViewById(R.id.zuia_submit_button);
        Intrinsics.checkNotNullExpressionValue(buttonViewFindViewById, "findViewById(...)");
        this.submitButton = buttonViewFindViewById;
        View viewFindViewById2 = findViewById(R.id.zuia_form_layout);
        Intrinsics.checkNotNullExpressionValue(viewFindViewById2, "findViewById(...)");
        LinearLayout linearLayout = (LinearLayout) viewFindViewById2;
        this.formLayout = linearLayout;
        View viewFindViewById3 = findViewById(R.id.zuia_form_field_counter_label);
        Intrinsics.checkNotNullExpressionValue(viewFindViewById3, "findViewById(...)");
        this.fieldCounterLabel = (TextView) viewFindViewById3;
        AccessibilityExtKt.postDelayRequestFocusWhenAccessibilityRunning(linearLayout, context, ACCESSIBILITY_EVENT_DELAY);
    }

    public void render(Function1<? super FormRendering<T>, FormRendering<T>> renderingUpdate) {
        Intrinsics.checkNotNullParameter(renderingUpdate, "renderingUpdate");
        this.rendering = renderingUpdate.invoke(this.rendering);
        this.submitButton.render(new Function1<ButtonRendering, ButtonRendering>(this) {
            final FormView<T> this$0;

            {
                super(1);
                this.this$0 = this;
            }

            @Override
            public final ButtonRendering invoke(ButtonRendering formButtonRendering) {
                Intrinsics.checkNotNullParameter(formButtonRendering, "formButtonRendering");
                ButtonRendering.Builder builder = formButtonRendering.toBuilder();
                final FormView<T> formView = this.this$0;
                return builder.state(new Function1<ButtonState, ButtonState>() {
                    {
                        super(1);
                    }

                    @Override
                    public final ButtonState invoke(ButtonState state) {
                        Intrinsics.checkNotNullParameter(state, "state");
                        boolean pending$zendesk_ui_ui_android = ((FormView) formView).rendering.getState$zendesk_ui_ui_android().getPending$zendesk_ui_ui_android();
                        int colorAccent$zendesk_ui_ui_android = ((FormView) formView).rendering.getState$zendesk_ui_ui_android().getColorAccent$zendesk_ui_ui_android();
                        String string = formView.getResources().getString(R.string.zuia_form_next_button);
                        int onActionColor$zendesk_ui_ui_android = ((FormView) formView).rendering.getState$zendesk_ui_ui_android().getOnActionColor$zendesk_ui_ui_android();
                        int onActionColor$zendesk_ui_ui_android2 = ((FormView) formView).rendering.getState$zendesk_ui_ui_android().getOnActionColor$zendesk_ui_ui_android();
                        Intrinsics.checkNotNull(string);
                        return ButtonState.copy$default(state, string, pending$zendesk_ui_ui_android, Integer.valueOf(colorAccent$zendesk_ui_ui_android), Integer.valueOf(onActionColor$zendesk_ui_ui_android), Integer.valueOf(onActionColor$zendesk_ui_ui_android2), false, 32, (Object) null);
                    }
                }).build();
            }
        });
        getTheFormBorderAlpha();
        LinearLayout linearLayout = this.formLayout;
        Context context = getContext();
        Intrinsics.checkNotNullExpressionValue(context, "getContext(...)");
        ViewKt.outlinedBoxBackground$default(linearLayout, ColorExtKt.adjustAlpha(ColorExtKt.resolveColorAttr(context, com.google.android.material.R.attr.colorOnSurface), this.borderAlpha), 0.0f, 0.0f, this.rendering.getState$zendesk_ui_ui_android().getBackgroundColor$zendesk_ui_ui_android(), 6, null);
        this.fieldsContainer.removeAllViews();
        this.fieldViews.clear();
        this.fieldStates.clear();
        List<T> list = this.fieldStates;
        List<FieldRendering<T>> fieldRenderings$zendesk_ui_ui_android = this.rendering.getFieldRenderings$zendesk_ui_ui_android();
        ArrayList arrayList = new ArrayList(CollectionsKt.collectionSizeOrDefault(fieldRenderings$zendesk_ui_ui_android, 10));
        Iterator<T> it = fieldRenderings$zendesk_ui_ui_android.iterator();
        while (it.hasNext()) {
            arrayList.add(((FieldRendering) it.next()).getNormalizedState());
        }
        list.addAll(arrayList);
        formViewRenderingUpdate();
    }

    private final void formViewRenderingUpdate() {
        if (isCurrentFormStored() && !this.rendering.getState$zendesk_ui_ui_android().getHasFailed$zendesk_ui_ui_android()) {
            addFormFieldsFromStorage();
        } else {
            addFieldView$default(this, 0, null, this.rendering.getFieldRenderings$zendesk_ui_ui_android().size(), 2, null);
        }
    }

    private final void addFormFieldsFromStorage() {
        Iterator<Map.Entry<String, DisplayedForm>> it = this.rendering.getMapOfDisplayedForm$zendesk_ui_ui_android().entrySet().iterator();
        while (it.hasNext()) {
            DisplayedForm value = it.next().getValue();
            if (Intrinsics.areEqual(value.getFormId(), this.rendering.getFormId$zendesk_ui_ui_android())) {
                for (Map.Entry<Integer, DisplayedField> entry : value.getFields().entrySet()) {
                    addFieldView(entry.getValue().getIndex(), entry.getValue(), this.rendering.getFieldRenderings$zendesk_ui_ui_android().size());
                }
            }
        }
        Iterator<T> it2 = this.fieldViews.iterator();
        while (it2.hasNext()) {
            FieldView.validate$zendesk_ui_ui_android$default((FieldView) it2.next(), false, 1, null);
        }
    }

    static void addFieldView$default(FormView formView, int i, DisplayedField displayedField, int i2, int i3, Object obj) {
        if ((i3 & 2) != 0) {
            displayedField = null;
        }
        formView.addFieldView(i, displayedField, i2);
    }

    private final void addFieldView(final int currentIndex, final DisplayedField displayedField, final int numberOfFields) {
        if (CollectionsKt.getOrNull(this.fieldViews, currentIndex) == null && currentIndex < numberOfFields) {
            final int i = currentIndex + 1;
            final boolean z = currentIndex == numberOfFields + (-1);
            LinearLayout linearLayout = this.fieldsContainer;
            Context context = getContext();
            Intrinsics.checkNotNullExpressionValue(context, "getContext(...)");
            FieldView fieldView = new FieldView(context, null, 0, 0, 14, null);
            fieldView.render(new Function1<FieldRendering<?>, FieldRendering<?>>(this) {
                final FormView<T> this$0;

                {
                    super(1);
                    this.this$0 = this;
                }

                @Override
                public final FieldRendering<?> invoke(FieldRendering<?> it) {
                    Intrinsics.checkNotNullParameter(it, "it");
                    FieldRendering fieldRenderingWithBorderColorOverride = FormViewKt.withBorderColorOverride(FormViewKt.withFieldTextPrefilled((FieldRendering) ((FormView) this.this$0).rendering.getFieldRenderings$zendesk_ui_ui_android().get(currentIndex), currentIndex, ((FormView) this.this$0).rendering.getFormId$zendesk_ui_ui_android(), ((FormView) this.this$0).rendering.getOnFormDisplayedFieldsChanged$zendesk_ui_ui_android()), ((FormView) this.this$0).rendering.getState$zendesk_ui_ui_android().getTextColor$zendesk_ui_ui_android(), ((FormView) this.this$0).rendering.getState$zendesk_ui_ui_android().getOnDangerColor$zendesk_ui_ui_android(), ((FormView) this.this$0).rendering.getState$zendesk_ui_ui_android().getFieldBorderColor$zendesk_ui_ui_android(), ((FormView) this.this$0).rendering.getState$zendesk_ui_ui_android().getFocusedFieldBorderColor$zendesk_ui_ui_android());
                    int i2 = currentIndex;
                    Function2<DisplayedField, String, Unit> onFormDisplayedFieldsChanged$zendesk_ui_ui_android = ((FormView) this.this$0).rendering.getOnFormDisplayedFieldsChanged$zendesk_ui_ui_android();
                    String formId$zendesk_ui_ui_android = ((FormView) this.this$0).rendering.getFormId$zendesk_ui_ui_android();
                    final FormView<T> formView = this.this$0;
                    final int i3 = currentIndex;
                    FieldRendering fieldRenderingWithStateChangedInterceptor = FormViewKt.withStateChangedInterceptor(fieldRenderingWithBorderColorOverride, i2, onFormDisplayedFieldsChanged$zendesk_ui_ui_android, formId$zendesk_ui_ui_android, new Function1<T, Unit>() {
                        {
                            super(1);
                        }

                        @Override
                        public Unit invoke(Object obj) {
                            invoke2(obj);
                            return Unit.INSTANCE;
                        }

                        public final void invoke2(T t) {
                            ((FormView) formView).fieldStates.set(i3, t);
                            ((FormView) formView).rendering.getOnFormChanged$zendesk_ui_ui_android().invoke(((FormView) formView).fieldStates);
                        }
                    });
                    final FormView<T> formView2 = this.this$0;
                    final int i4 = i;
                    FieldRendering fieldRenderingWithStateFocusChanged = FormViewKt.withStateFocusChanged(FormViewKt.withSelectChangedInterceptor(fieldRenderingWithStateChangedInterceptor, new Function1<List<? extends SelectOption>, Unit>() {
                        {
                            super(1);
                        }

                        @Override
                        public Unit invoke(List<? extends SelectOption> list) {
                            invoke2((List<SelectOption>) list);
                            return Unit.INSTANCE;
                        }

                        public final void invoke2(List<SelectOption> it2) {
                            Intrinsics.checkNotNullParameter(it2, "it");
                            FieldView fieldView2 = (FieldView) CollectionsKt.getOrNull(((FormView) formView2).fieldViews, i4);
                            if (fieldView2 != null) {
                                formView2.requestViewFocus(fieldView2);
                            }
                        }
                    }), ((FormView) this.this$0).rendering.getOnFormFocusChanged$zendesk_ui_ui_android());
                    DisplayedField displayedField2 = displayedField;
                    final FormView<T> formView3 = this.this$0;
                    final int i5 = currentIndex;
                    FieldRendering fieldRenderingWithStateInputCached = FormViewKt.withStateInputCached(fieldRenderingWithStateFocusChanged, displayedField2, new Function1<T, Unit>() {
                        {
                            super(1);
                        }

                        @Override
                        public Unit invoke(Object obj) {
                            invoke2(obj);
                            return Unit.INSTANCE;
                        }

                        public final void invoke2(T t) {
                            ((FormView) formView3).fieldStates.set(i5, t);
                        }
                    });
                    final boolean z2 = z;
                    final FormView<T> formView4 = this.this$0;
                    final int i6 = currentIndex;
                    final int i7 = i;
                    final int i8 = numberOfFields;
                    return FormViewKt.withSelectCheckMarkActionInterceptor(fieldRenderingWithStateInputCached, new Function0<Unit>() {
                        {
                            super(0);
                        }

                        @Override
                        public Unit invoke() {
                            invoke2();
                            return Unit.INSTANCE;
                        }

                        public final void invoke2() {
                            FieldView fieldView2;
                            if (z2 && (fieldView2 = (FieldView) CollectionsKt.getOrNull(((FormView) formView4).fieldViews, i6)) != null) {
                                fieldView2.clearFocus();
                            }
                            FormView<T> formView5 = formView4;
                            int i9 = i7;
                            final FormView<T> formView6 = formView4;
                            final int i10 = i7;
                            final int i11 = i8;
                            formView5.displayNextFieldView(i9, new Function0<Unit>() {
                                {
                                    super(0);
                                }

                                @Override
                                public Unit invoke() {
                                    invoke2();
                                    return Unit.INSTANCE;
                                }

                                public final void invoke2() {
                                    FormView.addFieldView$default(formView6, i10, null, i11, 2, null);
                                }
                            });
                        }
                    });
                }
            });
            this.fieldViews.add(fieldView);
            LinearLayout.LayoutParams layoutParams = new LinearLayout.LayoutParams(-1, -2);
            layoutParams.bottomMargin = getResources().getDimensionPixelSize(R.dimen.zuia_vertical_spacing_xlarge);
            Unit unit = Unit.INSTANCE;
            linearLayout.addView(fieldView, layoutParams);
            nextActionButtonClicked(currentIndex, new Function0<Unit>(this) {
                final FormView<T> this$0;

                {
                    super(0);
                    this.this$0 = this;
                }

                @Override
                public Unit invoke() {
                    invoke2();
                    return Unit.INSTANCE;
                }

                public final void invoke2() {
                    FormView<T> formView = this.this$0;
                    int i2 = i;
                    final FormView<T> formView2 = this.this$0;
                    final int i3 = i;
                    final int i4 = numberOfFields;
                    formView.displayNextFieldView(i2, new Function0<Unit>() {
                        {
                            super(0);
                        }

                        @Override
                        public Unit invoke() {
                            invoke2();
                            return Unit.INSTANCE;
                        }

                        public final void invoke2() {
                            FormView.addFieldView$default(formView2, i3, null, i4, 2, null);
                        }
                    });
                    FormView<T> formView3 = this.this$0;
                    formView3.addToListOfDisplayedFormIfNull(displayedField, i, ((FormView) formView3).rendering.getFormId$zendesk_ui_ui_android());
                }
            });
            sendActionButtonClicked(z);
            updateFieldCounterLabel(currentIndex, numberOfFields);
        }
    }

    private final void nextActionButtonClicked(int index, final Function0<Unit> progressToNextFieldView) {
        EditText editText;
        FieldView fieldView = (FieldView) CollectionsKt.getOrNull(this.fieldViews, index);
        if (fieldView != null && (editText = (EditText) fieldView.findViewById(R.id.zuia_field_input)) != null && editText.getInputType() != 176) {
            editText.setImeOptions(5);
            editText.setOnEditorActionListener(new TextView.OnEditorActionListener() {
                @Override
                public final boolean onEditorAction(TextView textView, int i, KeyEvent keyEvent) {
                    return FormView.nextActionButtonClicked$lambda$7$lambda$6(this.f$0, progressToNextFieldView, textView, i, keyEvent);
                }
            });
        }
        this.submitButton.render(new Function1<ButtonRendering, ButtonRendering>(this) {
            final FormView<T> this$0;

            {
                super(1);
                this.this$0 = this;
            }

            @Override
            public final ButtonRendering invoke(ButtonRendering formButtonRendering) {
                Intrinsics.checkNotNullParameter(formButtonRendering, "formButtonRendering");
                ButtonRendering.Builder builder = formButtonRendering.toBuilder();
                final FormView<T> formView = this.this$0;
                final Function0<Unit> function0 = progressToNextFieldView;
                return builder.onButtonClicked(new Function0<Unit>() {
                    {
                        super(0);
                    }

                    @Override
                    public Unit invoke() {
                        invoke2();
                        return Unit.INSTANCE;
                    }

                    public final void invoke2() {
                        if (formView.arePreviousFieldsValid()) {
                            function0.invoke();
                        }
                        FormView<T> formView2 = formView;
                        formView2.requestViewFocus((FieldView) CollectionsKt.last(((FormView) formView2).fieldViews));
                    }
                }).build();
            }
        });
    }

    public static final boolean nextActionButtonClicked$lambda$7$lambda$6(FormView this$0, Function0 progressToNextFieldView, TextView textView, int i, KeyEvent keyEvent) {
        Intrinsics.checkNotNullParameter(this$0, "this$0");
        Intrinsics.checkNotNullParameter(progressToNextFieldView, "$progressToNextFieldView");
        if (i == 5 && this$0.arePreviousFieldsValid()) {
            progressToNextFieldView.invoke();
        }
        return false;
    }

    public final boolean arePreviousFieldsValid() {
        List<FieldView> list = this.fieldViews;
        ArrayList arrayList = new ArrayList();
        for (T t : list) {
            if (FieldView.validate$zendesk_ui_ui_android$default((FieldView) t, false, 1, null)) {
                arrayList.add(t);
            }
        }
        return arrayList.containsAll(this.fieldViews);
    }

    private final void sendActionButtonClicked(boolean enableSendActionButton) {
        if (enableSendActionButton) {
            this.submitButton.render(new Function1<ButtonRendering, ButtonRendering>(this) {
                final FormView<T> this$0;

                {
                    super(1);
                    this.this$0 = this;
                }

                @Override
                public final ButtonRendering invoke(ButtonRendering formButtonRendering) {
                    Intrinsics.checkNotNullParameter(formButtonRendering, "formButtonRendering");
                    ButtonRendering.Builder builder = formButtonRendering.toBuilder();
                    final FormView<T> formView = this.this$0;
                    ButtonRendering.Builder builderOnButtonClicked = builder.onButtonClicked(new Function0<Unit>() {
                        {
                            super(0);
                        }

                        @Override
                        public Unit invoke() {
                            invoke2();
                            return Unit.INSTANCE;
                        }

                        public final void invoke2() {
                            List list = ((FormView) formView).fieldViews;
                            ArrayList arrayList = new ArrayList();
                            for (T t : list) {
                                if (FieldView.validate$zendesk_ui_ui_android$default((FieldView) t, false, 1, null)) {
                                    arrayList.add(t);
                                }
                            }
                            if (arrayList.containsAll(((FormView) formView).fieldViews)) {
                                ((FormView) formView).rendering.getOnFormCompleted$zendesk_ui_ui_android().invoke(CollectionsKt.toList(((FormView) formView).fieldStates));
                                Iterator<T> it = ((FormView) formView).fieldViews.iterator();
                                while (it.hasNext()) {
                                    ((FieldView) it.next()).clearFocus();
                                }
                                return;
                            }
                            if (((FormView) formView).rendering.getState$zendesk_ui_ui_android().getPending$zendesk_ui_ui_android()) {
                                return;
                            }
                            FormView<T> formView2 = formView;
                            for (FieldView fieldView : ((FormView) formView2).fieldViews) {
                                if (!FieldView.validate$zendesk_ui_ui_android$default(fieldView, false, 1, null)) {
                                    formView2.requestViewFocus(fieldView);
                                    return;
                                }
                            }
                            throw new NoSuchElementException("Collection contains no element matching the predicate.");
                        }
                    });
                    final FormView<T> formView2 = this.this$0;
                    return builderOnButtonClicked.state(new Function1<ButtonState, ButtonState>() {
                        {
                            super(1);
                        }

                        @Override
                        public final ButtonState invoke(ButtonState state) {
                            Intrinsics.checkNotNullParameter(state, "state");
                            boolean pending$zendesk_ui_ui_android = ((FormView) formView2).rendering.getState$zendesk_ui_ui_android().getPending$zendesk_ui_ui_android();
                            String string = formView2.getResources().getString(R.string.zuia_form_send_button);
                            Intrinsics.checkNotNull(string);
                            return ButtonState.copy$default(state, string, pending$zendesk_ui_ui_android, (Integer) null, (Integer) null, (Integer) null, false, 60, (Object) null);
                        }
                    }).build();
                }
            });
            setDoneActionListener();
        }
    }

    private final void setDoneActionListener() {
        EditText editText = (EditText) ((FieldView) CollectionsKt.last((List) this.fieldViews)).findViewById(R.id.zuia_field_input);
        editText.setImeOptions(4);
        editText.setOnEditorActionListener(new TextView.OnEditorActionListener() {
            @Override
            public final boolean onEditorAction(TextView textView, int i, KeyEvent keyEvent) {
                return FormView.setDoneActionListener$lambda$10$lambda$9(this.f$0, textView, i, keyEvent);
            }
        });
    }

    public static final boolean setDoneActionListener$lambda$10$lambda$9(FormView this$0, TextView textView, int i, KeyEvent keyEvent) {
        Intrinsics.checkNotNullParameter(this$0, "this$0");
        if (i != 4) {
            return false;
        }
        this$0.submitButton.performClick();
        return true;
    }

    private final void updateFieldCounterLabel(int index, int size) {
        this.fieldCounterLabel.setTextColor(ColorExtKt.adjustAlpha(this.rendering.getState$zendesk_ui_ui_android().getTextColor$zendesk_ui_ui_android(), 0.65f));
        this.fieldCounterLabel.setText(getResources().getString(R.string.zuia_form_field_counter_label, Integer.valueOf(index + 1), Integer.valueOf(size)));
    }

    public final void displayNextFieldView(int index, Function0<Unit> displayFieldView) {
        displayFieldView.invoke();
        FieldView fieldView = (FieldView) CollectionsKt.getOrNull(this.fieldViews, index);
        if (fieldView != null) {
            requestViewFocus(fieldView);
        }
    }

    public final void addToListOfDisplayedFormIfNull(DisplayedField displayedField, int i, String str) {
        if (displayedField == null) {
            this.rendering.getOnFormDisplayedFieldsChanged$zendesk_ui_ui_android().invoke(new DisplayedField(i, null, 2, null), str);
        }
    }

    public final void requestViewFocus(FieldView fieldView) {
        EditText editText = (EditText) fieldView.findViewById(R.id.zuia_field_input);
        if (editText != null) {
            ViewKt.focusAndShowKeyboard(editText);
        }
    }

    private final boolean isCurrentFormStored() {
        DisplayedForm displayedForm;
        Map<Integer, DisplayedField> fields;
        Map<String, DisplayedForm> mapOfDisplayedForm$zendesk_ui_ui_android = this.rendering.getMapOfDisplayedForm$zendesk_ui_ui_android();
        return mapOfDisplayedForm$zendesk_ui_ui_android.containsKey(this.rendering.getFormId$zendesk_ui_ui_android()) && (displayedForm = mapOfDisplayedForm$zendesk_ui_ui_android.get(this.rendering.getFormId$zendesk_ui_ui_android())) != null && (fields = displayedForm.getFields()) != null && (fields.isEmpty() ^ true);
    }

    private final void getTheFormBorderAlpha() {
        TypedValue typedValue = new TypedValue();
        getResources().getValue(R.dimen.zuia_form_border_alpha, typedValue, true);
        this.borderAlpha = typedValue.getFloat();
    }

    @Metadata(m17d1 = {"\u0000\u0018\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0002\b\u0002\n\u0002\u0010\t\n\u0000\n\u0002\u0010\u0007\n\u0000\b\u0082\u0003\u0018\u00002\u00020\u0001B\u0007\b\u0002¢\u0006\u0002\u0010\u0002R\u000e\u0010\u0003\u001a\u00020\u0004X\u0082T¢\u0006\u0002\n\u0000R\u000e\u0010\u0005\u001a\u00020\u0006X\u0086T¢\u0006\u0002\n\u0000¨\u0006\u0007"}, m18d2 = {"Lzendesk/ui/android/conversation/form/FormView$Companion;", "", "()V", "ACCESSIBILITY_EVENT_DELAY", "", "FIELD_COUNTER_ALPHA", "", "zendesk.ui_ui-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    private static final class Companion {
        public Companion(DefaultConstructorMarker defaultConstructorMarker) {
            this();
        }

        private Companion() {
        }
    }
}
