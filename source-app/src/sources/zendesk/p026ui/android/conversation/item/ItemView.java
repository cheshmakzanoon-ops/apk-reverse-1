package zendesk.p026ui.android.conversation.item;

import android.content.Context;
import android.graphics.drawable.GradientDrawable;
import android.graphics.drawable.StateListDrawable;
import android.util.AttributeSet;
import android.util.StateSet;
import android.view.View;
import android.widget.LinearLayout;
import android.widget.TextView;
import kotlin.Metadata;
import kotlin.Unit;
import kotlin.jvm.functions.Function0;
import kotlin.jvm.functions.Function1;
import kotlin.jvm.internal.DefaultConstructorMarker;
import kotlin.jvm.internal.Intrinsics;
import zendesk.p026ui.android.internal.ColorExtKt;
import zendesk.p026ui.android.internal.ThrottledOnClickListenerKt;
import zendesk.ui.android.R;
import zendesk.ui.android.Renderer;

@Metadata(m17d1 = {"\u0000:\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\b\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0010\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\b\u0007\u0018\u00002\u00020\u00012\b\u0012\u0004\u0012\u00020\u00030\u0002B/\b\u0007\u0012\u0006\u0010\u0004\u001a\u00020\u0005\u0012\n\b\u0002\u0010\u0006\u001a\u0004\u0018\u00010\u0007\u0012\b\b\u0002\u0010\b\u001a\u00020\t\u0012\b\b\u0002\u0010\n\u001a\u00020\t¢\u0006\u0002\u0010\u000bJ\u001c\u0010\u0010\u001a\u00020\u00112\u0012\u0010\u0012\u001a\u000e\u0012\u0004\u0012\u00020\u0003\u0012\u0004\u0012\u00020\u00030\u0013H\u0016R\u000e\u0010\f\u001a\u00020\rX\u0082\u0004¢\u0006\u0002\n\u0000R\u000e\u0010\u000e\u001a\u00020\rX\u0082\u0004¢\u0006\u0002\n\u0000R\u000e\u0010\u000f\u001a\u00020\u0003X\u0082\u000e¢\u0006\u0002\n\u0000¨\u0006\u0014"}, m18d2 = {"Lzendesk/ui/android/conversation/item/ItemView;", "Landroid/widget/LinearLayout;", "Lzendesk/ui/android/Renderer;", "Lzendesk/ui/android/conversation/item/ItemRendering;", "context", "Landroid/content/Context;", "attrs", "Landroid/util/AttributeSet;", "defStyleAttrs", "", "defStyleRes", "(Landroid/content/Context;Landroid/util/AttributeSet;II)V", "itemSubtitle", "Landroid/widget/TextView;", "itemTitle", "rendering", "render", "", "renderingUpdate", "Lkotlin/Function1;", "zendesk.ui_ui-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
public final class ItemView extends LinearLayout implements Renderer<ItemRendering> {
    public static final int $stable = 8;
    private final TextView itemSubtitle;
    private final TextView itemTitle;
    private ItemRendering rendering;

    public ItemView(Context context) {
        this(context, null, 0, 0, 14, null);
        Intrinsics.checkNotNullParameter(context, "context");
    }

    public ItemView(Context context, AttributeSet attributeSet) {
        this(context, attributeSet, 0, 0, 12, null);
        Intrinsics.checkNotNullParameter(context, "context");
    }

    public ItemView(Context context, AttributeSet attributeSet, int i) {
        this(context, attributeSet, i, 0, 8, null);
        Intrinsics.checkNotNullParameter(context, "context");
    }

    public ItemView(Context context, AttributeSet attributeSet, int i, int i2, int i3, DefaultConstructorMarker defaultConstructorMarker) {
        this(context, (i3 & 2) != 0 ? null : attributeSet, (i3 & 4) != 0 ? 0 : i, (i3 & 8) != 0 ? 0 : i2);
    }

    public ItemView(Context context, AttributeSet attributeSet, int i, int i2) {
        super(context, attributeSet, i, i2);
        Intrinsics.checkNotNullParameter(context, "context");
        this.rendering = new ItemRendering();
        context.getTheme().applyStyle(R.style.ThemeOverlay_ZendeskComponents_Item, false);
        LinearLayout.inflate(context, R.layout.zuia_view_item, this);
        LinearLayout.LayoutParams layoutParams = new LinearLayout.LayoutParams(-1, -2);
        int dimensionPixelSize = getResources().getDimensionPixelSize(R.dimen.zuia_vertical_message_padding);
        setPadding(0, dimensionPixelSize, 0, dimensionPixelSize);
        setLayoutParams(layoutParams);
        setOrientation(1);
        setClickable(true);
        setFocusable(true);
        View viewFindViewById = findViewById(R.id.zuia_item_title);
        Intrinsics.checkNotNullExpressionValue(viewFindViewById, "findViewById(...)");
        this.itemTitle = (TextView) viewFindViewById;
        View viewFindViewById2 = findViewById(R.id.zuia_item_subtitle);
        Intrinsics.checkNotNullExpressionValue(viewFindViewById2, "findViewById(...)");
        this.itemSubtitle = (TextView) viewFindViewById2;
        render(new Function1<ItemRendering, ItemRendering>() {
            @Override
            public final ItemRendering invoke(ItemRendering it) {
                Intrinsics.checkNotNullParameter(it, "it");
                return it;
            }
        });
    }

    public void render(Function1<? super ItemRendering, ItemRendering> renderingUpdate) {
        int iResolveColorAttr;
        Unit unit;
        Intrinsics.checkNotNullParameter(renderingUpdate, "renderingUpdate");
        this.rendering = renderingUpdate.invoke(this.rendering);
        StateListDrawable stateListDrawable = new StateListDrawable();
        Integer pressedColor$zendesk_ui_ui_android = this.rendering.getState().getPressedColor$zendesk_ui_ui_android();
        if (pressedColor$zendesk_ui_ui_android != null) {
            iResolveColorAttr = pressedColor$zendesk_ui_ui_android.intValue();
        } else {
            Context context = getContext();
            Intrinsics.checkNotNullExpressionValue(context, "getContext(...)");
            iResolveColorAttr = ColorExtKt.resolveColorAttr(context, androidx.appcompat.R.attr.colorAccent);
        }
        GradientDrawable gradientDrawable = new GradientDrawable();
        gradientDrawable.setColor(ColorExtKt.adjustAlpha(iResolveColorAttr, 0.3f));
        stateListDrawable.addState(new int[]{android.R.attr.state_pressed}, gradientDrawable);
        GradientDrawable gradientDrawable2 = new GradientDrawable();
        gradientDrawable2.setColor(0);
        stateListDrawable.addState(StateSet.WILD_CARD, gradientDrawable2);
        setBackground(stateListDrawable);
        Item<?> item$zendesk_ui_ui_android = this.rendering.getState().getItem$zendesk_ui_ui_android();
        Integer titleColor = item$zendesk_ui_ui_android.getTitleColor();
        if (titleColor == null) {
            titleColor = this.rendering.getState().getTitleColor$zendesk_ui_ui_android();
        }
        if (titleColor != null) {
            this.itemTitle.setTextColor(titleColor.intValue());
        }
        this.itemTitle.setText(item$zendesk_ui_ui_android.getTitle());
        String subtitle = item$zendesk_ui_ui_android.getSubtitle();
        if (subtitle != null) {
            this.itemSubtitle.setVisibility(0);
            this.itemSubtitle.setText(subtitle);
            unit = Unit.INSTANCE;
        } else {
            unit = null;
        }
        if (unit == null) {
            this.itemSubtitle.setVisibility(8);
        }
        setOnClickListener(ThrottledOnClickListenerKt.throttledOnClickListener$default(0L, new Function0<Unit>() {
            {
                super(0);
            }

            @Override
            public Unit invoke() {
                invoke2();
                return Unit.INSTANCE;
            }

            public final void invoke2() {
                Function1<Item<?>, Unit> onItemClicked$zendesk_ui_ui_android = ItemView.this.rendering.getOnItemClicked$zendesk_ui_ui_android();
                if (onItemClicked$zendesk_ui_ui_android != null) {
                    onItemClicked$zendesk_ui_ui_android.invoke(ItemView.this.rendering.getState().getItem$zendesk_ui_ui_android());
                }
            }
        }, 1, null));
    }
}
