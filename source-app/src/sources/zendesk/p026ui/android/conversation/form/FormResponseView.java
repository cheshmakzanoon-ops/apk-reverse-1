package zendesk.p026ui.android.conversation.form;

import android.content.Context;
import android.util.AttributeSet;
import android.util.TypedValue;
import android.widget.LinearLayout;
import kotlin.Metadata;
import kotlin.Unit;
import kotlin.jvm.functions.Function1;
import kotlin.jvm.internal.DefaultConstructorMarker;
import kotlin.jvm.internal.Intrinsics;
import zendesk.p026ui.android.internal.ColorExtKt;
import zendesk.p026ui.android.internal.ViewKt;
import zendesk.ui.android.R;
import zendesk.ui.android.Renderer;

@Metadata(m17d1 = {"\u0000<\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\b\n\u0002\b\u0003\n\u0002\u0010\u0007\n\u0002\b\u0003\n\u0002\u0010\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0000\b\u0007\u0018\u00002\u00020\u00012\b\u0012\u0004\u0012\u00020\u00030\u0002B/\b\u0007\u0012\u0006\u0010\u0004\u001a\u00020\u0005\u0012\n\b\u0002\u0010\u0006\u001a\u0004\u0018\u00010\u0007\u0012\b\b\u0002\u0010\b\u001a\u00020\t\u0012\b\b\u0002\u0010\n\u001a\u00020\t¢\u0006\u0002\u0010\u000bJ\b\u0010\u0010\u001a\u00020\u0011H\u0002J\u001c\u0010\u0012\u001a\u00020\u00112\u0012\u0010\u0013\u001a\u000e\u0012\u0004\u0012\u00020\u0003\u0012\u0004\u0012\u00020\u00030\u0014H\u0016R\u000e\u0010\f\u001a\u00020\rX\u0082\u000e¢\u0006\u0002\n\u0000R\u000e\u0010\u000e\u001a\u00020\u0003X\u0082\u000e¢\u0006\u0002\n\u0000R\u0010\u0010\u000f\u001a\u00020\t8\u0002X\u0083\u0004¢\u0006\u0002\n\u0000¨\u0006\u0015"}, m18d2 = {"Lzendesk/ui/android/conversation/form/FormResponseView;", "Landroid/widget/LinearLayout;", "Lzendesk/ui/android/Renderer;", "Lzendesk/ui/android/conversation/form/FormResponseRendering;", "context", "Landroid/content/Context;", "attrs", "Landroid/util/AttributeSet;", "defStyleAttrs", "", "defStyleRes", "(Landroid/content/Context;Landroid/util/AttributeSet;II)V", "borderAlpha", "", "rendering", "spacing", "getTheFormResponseBorderAlpha", "", "render", "renderingUpdate", "Lkotlin/Function1;", "zendesk.ui_ui-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
public final class FormResponseView extends LinearLayout implements Renderer<FormResponseRendering> {
    public static final int $stable = 8;
    private float borderAlpha;
    private FormResponseRendering rendering;
    private final int spacing;

    public FormResponseView(Context context) {
        this(context, null, 0, 0, 14, null);
        Intrinsics.checkNotNullParameter(context, "context");
    }

    public FormResponseView(Context context, AttributeSet attributeSet) {
        this(context, attributeSet, 0, 0, 12, null);
        Intrinsics.checkNotNullParameter(context, "context");
    }

    public FormResponseView(Context context, AttributeSet attributeSet, int i) {
        this(context, attributeSet, i, 0, 8, null);
        Intrinsics.checkNotNullParameter(context, "context");
    }

    public FormResponseView(Context context, AttributeSet attributeSet, int i, int i2, int i3, DefaultConstructorMarker defaultConstructorMarker) {
        this(context, (i3 & 2) != 0 ? null : attributeSet, (i3 & 4) != 0 ? 0 : i, (i3 & 8) != 0 ? 0 : i2);
    }

    public FormResponseView(Context context, AttributeSet attributeSet, int i, int i2) {
        super(context, attributeSet, i, i2);
        Intrinsics.checkNotNullParameter(context, "context");
        this.rendering = new FormResponseRendering();
        setLayoutParams(new LinearLayout.LayoutParams(-1, -2));
        int dimensionPixelOffset = context.getResources().getDimensionPixelOffset(R.dimen.zuia_spacing_xsmall);
        this.spacing = dimensionPixelOffset;
        setPadding(dimensionPixelOffset, dimensionPixelOffset, dimensionPixelOffset, dimensionPixelOffset);
        setClipChildren(true);
        setOrientation(1);
        render(new Function1<FormResponseRendering, FormResponseRendering>() {
            @Override
            public final FormResponseRendering invoke(FormResponseRendering it) {
                Intrinsics.checkNotNullParameter(it, "it");
                return it;
            }
        });
    }

    public void render(Function1<? super FormResponseRendering, FormResponseRendering> renderingUpdate) {
        Intrinsics.checkNotNullParameter(renderingUpdate, "renderingUpdate");
        FormResponseState state = this.rendering.getState();
        FormResponseRendering formResponseRenderingInvoke = renderingUpdate.invoke(this.rendering);
        this.rendering = formResponseRenderingInvoke;
        if (Intrinsics.areEqual(state, formResponseRenderingInvoke.getState())) {
            return;
        }
        getTheFormResponseBorderAlpha();
        Context context = getContext();
        Intrinsics.checkNotNullExpressionValue(context, "getContext(...)");
        ViewKt.outlinedBoxBackground$default(this, ColorExtKt.adjustAlpha(ColorExtKt.resolveColorAttr(context, com.google.android.material.R.attr.colorOnSurface), this.borderAlpha), 0.0f, 0.0f, this.rendering.getState().getBackgroundColor$zendesk_ui_ui_android(), 6, null);
        removeAllViews();
        for (final FieldResponse fieldResponse : this.rendering.getState().getFieldResponses$zendesk_ui_ui_android()) {
            Context context2 = getContext();
            Intrinsics.checkNotNullExpressionValue(context2, "getContext(...)");
            FieldResponseView fieldResponseView = new FieldResponseView(context2, null, 2, null);
            fieldResponseView.render(new Function1<FieldResponseRendering, FieldResponseRendering>() {
                {
                    super(1);
                }

                @Override
                public final FieldResponseRendering invoke(FieldResponseRendering fieldResponseRendering) {
                    Intrinsics.checkNotNullParameter(fieldResponseRendering, "fieldResponseRendering");
                    FieldResponseRendering.Builder builder = fieldResponseRendering.toBuilder();
                    final FieldResponse fieldResponse2 = fieldResponse;
                    final FormResponseView formResponseView = this;
                    return builder.state(new Function1<FieldResponseState, FieldResponseState>() {
                        {
                            super(1);
                        }

                        @Override
                        public final FieldResponseState invoke(FieldResponseState state2) {
                            Intrinsics.checkNotNullParameter(state2, "state");
                            return state2.copy(fieldResponse2.getLabel(), fieldResponse2.getResponse(), formResponseView.rendering.getState().getTextColor$zendesk_ui_ui_android());
                        }
                    }).build();
                }
            });
            LinearLayout.LayoutParams layoutParams = new LinearLayout.LayoutParams(-1, -2);
            int i = this.spacing;
            layoutParams.setMargins(i, i, i, i);
            Unit unit = Unit.INSTANCE;
            addView(fieldResponseView, layoutParams);
        }
    }

    private final void getTheFormResponseBorderAlpha() {
        TypedValue typedValue = new TypedValue();
        getResources().getValue(R.dimen.zuia_form_response_border_alpha, typedValue, true);
        this.borderAlpha = typedValue.getFloat();
    }
}
