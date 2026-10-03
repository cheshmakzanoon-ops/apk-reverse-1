package zendesk.p026ui.android.conversation.quickreply;

import android.content.Context;
import android.util.AttributeSet;
import android.view.View;
import android.widget.FrameLayout;
import androidx.constraintlayout.helper.widget.Flow;
import androidx.constraintlayout.widget.ConstraintLayout;
import java.util.List;
import kotlin.Metadata;
import kotlin.Unit;
import kotlin.jvm.functions.Function1;
import kotlin.jvm.functions.Function2;
import kotlin.jvm.internal.DefaultConstructorMarker;
import kotlin.jvm.internal.Intrinsics;
import zendesk.ui.android.R;
import zendesk.ui.android.Renderer;

@Metadata(m17d1 = {"\u0000R\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\b\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u000e\n\u0002\b\u0002\n\u0002\u0010\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\b\u0007\u0018\u00002\u00020\u00012\b\u0012\u0004\u0012\u00020\u00030\u0002B/\b\u0007\u0012\u0006\u0010\u0004\u001a\u00020\u0005\u0012\n\b\u0002\u0010\u0006\u001a\u0004\u0018\u00010\u0007\u0012\b\b\u0002\u0010\b\u001a\u00020\t\u0012\b\b\u0002\u0010\n\u001a\u00020\t¢\u0006\u0002\u0010\u000bJ\u0018\u0010\u0011\u001a\u00020\u00122\u0006\u0010\u0013\u001a\u00020\u00142\u0006\u0010\u0015\u001a\u00020\u0014H\u0002J\b\u0010\u0016\u001a\u00020\u0017H\u0002J\u001c\u0010\u0018\u001a\u00020\u00172\u0012\u0010\u0019\u001a\u000e\u0012\u0004\u0012\u00020\u0003\u0012\u0004\u0012\u00020\u00030\u001aH\u0016J\b\u0010\u001b\u001a\u00020\u0017H\u0002R\u000e\u0010\f\u001a\u00020\rX\u0082\u0004¢\u0006\u0002\n\u0000R\u000e\u0010\u000e\u001a\u00020\u000fX\u0082\u0004¢\u0006\u0002\n\u0000R\u000e\u0010\u0010\u001a\u00020\u0003X\u0082\u000e¢\u0006\u0002\n\u0000¨\u0006\u001c"}, m18d2 = {"Lzendesk/ui/android/conversation/quickreply/QuickReplyView;", "Landroid/widget/FrameLayout;", "Lzendesk/ui/android/Renderer;", "Lzendesk/ui/android/conversation/quickreply/QuickReplyRendering;", "context", "Landroid/content/Context;", "attrs", "Landroid/util/AttributeSet;", "defStyleAttrs", "", "defStyleRes", "(Landroid/content/Context;Landroid/util/AttributeSet;II)V", "chipContainer", "Landroidx/constraintlayout/widget/ConstraintLayout;", "chipFlow", "Landroidx/constraintlayout/helper/widget/Flow;", "rendering", "addQuickReplyOption", "Landroid/view/View;", "id", "", "text", "removeQuickReplies", "", "render", "renderingUpdate", "Lkotlin/Function1;", "setupQuickReplies", "zendesk.ui_ui-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
public final class QuickReplyView extends FrameLayout implements Renderer<QuickReplyRendering> {
    public static final int $stable = 8;
    private final ConstraintLayout chipContainer;
    private final Flow chipFlow;
    private QuickReplyRendering rendering;

    public QuickReplyView(Context context) {
        this(context, null, 0, 0, 14, null);
        Intrinsics.checkNotNullParameter(context, "context");
    }

    public QuickReplyView(Context context, AttributeSet attributeSet) {
        this(context, attributeSet, 0, 0, 12, null);
        Intrinsics.checkNotNullParameter(context, "context");
    }

    public QuickReplyView(Context context, AttributeSet attributeSet, int i) {
        this(context, attributeSet, i, 0, 8, null);
        Intrinsics.checkNotNullParameter(context, "context");
    }

    public QuickReplyView(Context context, AttributeSet attributeSet, int i, int i2, int i3, DefaultConstructorMarker defaultConstructorMarker) {
        this(context, (i3 & 2) != 0 ? null : attributeSet, (i3 & 4) != 0 ? 0 : i, (i3 & 8) != 0 ? 0 : i2);
    }

    public QuickReplyView(Context context, AttributeSet attributeSet, int i, int i2) {
        super(context, attributeSet, i, i2);
        Intrinsics.checkNotNullParameter(context, "context");
        this.rendering = new QuickReplyRendering();
        FrameLayout.inflate(context, R.layout.zuia_view_quick_reply, this);
        ConstraintLayout constraintLayoutFindViewById = findViewById(R.id.zuia_quick_reply_chip_container);
        Intrinsics.checkNotNullExpressionValue(constraintLayoutFindViewById, "findViewById(...)");
        this.chipContainer = constraintLayoutFindViewById;
        Flow flowFindViewById = findViewById(R.id.zuia_quick_reply_chip_flow);
        Intrinsics.checkNotNullExpressionValue(flowFindViewById, "findViewById(...)");
        this.chipFlow = flowFindViewById;
        render(new Function1<QuickReplyRendering, QuickReplyRendering>() {
            @Override
            public final QuickReplyRendering invoke(QuickReplyRendering it) {
                Intrinsics.checkNotNullParameter(it, "it");
                return it;
            }
        });
    }

    public void render(Function1<? super QuickReplyRendering, QuickReplyRendering> renderingUpdate) {
        Intrinsics.checkNotNullParameter(renderingUpdate, "renderingUpdate");
        QuickReplyState state = this.rendering.getState();
        QuickReplyRendering quickReplyRenderingInvoke = renderingUpdate.invoke(this.rendering);
        this.rendering = quickReplyRenderingInvoke;
        if (Intrinsics.areEqual(state, quickReplyRenderingInvoke.getState())) {
            return;
        }
        removeQuickReplies();
        setupQuickReplies();
    }

    private final void setupQuickReplies() {
        List<QuickReplyOption> quickReplyOptions$zendesk_ui_ui_android = this.rendering.getState().getQuickReplyOptions$zendesk_ui_ui_android();
        int[] iArr = new int[quickReplyOptions$zendesk_ui_ui_android.size()];
        int size = quickReplyOptions$zendesk_ui_ui_android.size();
        for (int i = 0; i < size; i++) {
            View viewAddQuickReplyOption = addQuickReplyOption(quickReplyOptions$zendesk_ui_ui_android.get(i).getId(), quickReplyOptions$zendesk_ui_ui_android.get(i).getText());
            viewAddQuickReplyOption.setId(View.generateViewId());
            this.chipContainer.addView(viewAddQuickReplyOption);
            iArr[i] = viewAddQuickReplyOption.getId();
        }
        this.chipFlow.setReferencedIds(iArr);
    }

    private final void removeQuickReplies() {
        int childCount = this.chipContainer.getChildCount();
        while (true) {
            childCount--;
            if (-1 >= childCount) {
                return;
            }
            View childAt = this.chipContainer.getChildAt(childCount);
            if (!Intrinsics.areEqual(childAt, this.chipFlow)) {
                this.chipContainer.removeView(childAt);
            }
        }
    }

    private final View addQuickReplyOption(final String id, final String text) {
        Context context = getContext();
        Intrinsics.checkNotNullExpressionValue(context, "getContext(...)");
        QuickReplyOptionView quickReplyOptionView = new QuickReplyOptionView(context, null, 0, 0, 14, null);
        quickReplyOptionView.render(new Function1<QuickReplyOptionRendering, QuickReplyOptionRendering>() {
            {
                super(1);
            }

            @Override
            public final QuickReplyOptionRendering invoke(QuickReplyOptionRendering quickReplyOptionRendering) {
                Intrinsics.checkNotNullParameter(quickReplyOptionRendering, "quickReplyOptionRendering");
                QuickReplyOptionRendering.Builder builder = quickReplyOptionRendering.toBuilder();
                final String str = id;
                final String str2 = text;
                final QuickReplyView quickReplyView = this;
                QuickReplyOptionRendering.Builder builderState = builder.state(new Function1<QuickReplyOptionState, QuickReplyOptionState>() {
                    {
                        super(1);
                    }

                    @Override
                    public final QuickReplyOptionState invoke(QuickReplyOptionState state) {
                        Intrinsics.checkNotNullParameter(state, "state");
                        return state.copy(str, str2, quickReplyView.rendering.getState().getColor$zendesk_ui_ui_android(), quickReplyView.rendering.getState().getBackgroundColor$zendesk_ui_ui_android());
                    }
                });
                final QuickReplyView quickReplyView2 = this;
                return builderState.onOptionClicked(new Function2<String, String, Unit>() {
                    {
                        super(2);
                    }

                    @Override
                    public Unit invoke(String str3, String str4) {
                        invoke2(str3, str4);
                        return Unit.INSTANCE;
                    }

                    public final void invoke2(String id2, String text2) {
                        Intrinsics.checkNotNullParameter(id2, "id");
                        Intrinsics.checkNotNullParameter(text2, "text");
                        Function1<QuickReplyOption, Unit> onOptionClicked$zendesk_ui_ui_android = quickReplyView2.rendering.getOnOptionClicked$zendesk_ui_ui_android();
                        if (onOptionClicked$zendesk_ui_ui_android != null) {
                            onOptionClicked$zendesk_ui_ui_android.invoke(new QuickReplyOption(id2, text2));
                        }
                        int childCount = quickReplyView2.chipContainer.getChildCount();
                        for (int i = 0; i < childCount; i++) {
                            View childAt = quickReplyView2.chipContainer.getChildAt(i);
                            QuickReplyOptionView quickReplyOptionView2 = childAt instanceof QuickReplyOptionView ? (QuickReplyOptionView) childAt : null;
                            if (quickReplyOptionView2 != null && !quickReplyOptionView2.isSelected() && quickReplyOptionView2.getChildCount() > 0) {
                                quickReplyOptionView2.getChildAt(0).setEnabled(false);
                            }
                        }
                    }
                }).build();
            }
        });
        return quickReplyOptionView;
    }
}
