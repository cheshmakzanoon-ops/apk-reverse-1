package zendesk.p026ui.android.conversation.item;

import android.content.Context;
import android.util.AttributeSet;
import android.util.TypedValue;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.FrameLayout;
import android.widget.LinearLayout;
import java.util.List;
import kotlin.Metadata;
import kotlin.Unit;
import kotlin.collections.CollectionsKt;
import kotlin.jvm.functions.Function1;
import kotlin.jvm.internal.DefaultConstructorMarker;
import kotlin.jvm.internal.Intrinsics;
import zendesk.p026ui.android.internal.ViewKt;
import zendesk.ui.android.R;
import zendesk.ui.android.Renderer;

@Metadata(m17d1 = {"\u0000F\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\b\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\b\u0007\u0018\u00002\u00020\u00012\b\u0012\u0004\u0012\u00020\u00030\u0002B/\b\u0007\u0012\u0006\u0010\u0004\u001a\u00020\u0005\u0012\n\b\u0002\u0010\u0006\u001a\u0004\u0018\u00010\u0007\u0012\b\b\u0002\u0010\b\u001a\u00020\t\u0012\b\b\u0002\u0010\n\u001a\u00020\t¢\u0006\u0002\u0010\u000bJ\u0014\u0010\u000f\u001a\u00020\u00102\n\u0010\u0011\u001a\u0006\u0012\u0002\b\u00030\u0012H\u0002J\u001c\u0010\u0013\u001a\u00020\u00142\u0012\u0010\u0015\u001a\u000e\u0012\u0004\u0012\u00020\u0003\u0012\u0004\u0012\u00020\u00030\u0016H\u0016R\u000e\u0010\f\u001a\u00020\rX\u0082\u0004¢\u0006\u0002\n\u0000R\u000e\u0010\u000e\u001a\u00020\u0003X\u0082\u000e¢\u0006\u0002\n\u0000¨\u0006\u0017"}, m18d2 = {"Lzendesk/ui/android/conversation/item/ItemGroupView;", "Landroid/widget/FrameLayout;", "Lzendesk/ui/android/Renderer;", "Lzendesk/ui/android/conversation/item/ItemGroupRendering;", "context", "Landroid/content/Context;", "attrs", "Landroid/util/AttributeSet;", "defStyleAttrs", "", "defStyleRes", "(Landroid/content/Context;Landroid/util/AttributeSet;II)V", "itemContainer", "Landroid/widget/LinearLayout;", "rendering", "createItemView", "Landroid/view/View;", "item", "Lzendesk/ui/android/conversation/item/Item;", "render", "", "renderingUpdate", "Lkotlin/Function1;", "zendesk.ui_ui-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
public final class ItemGroupView extends FrameLayout implements Renderer<ItemGroupRendering> {
    public static final int $stable = 8;
    private final LinearLayout itemContainer;
    private ItemGroupRendering rendering;

    public ItemGroupView(Context context) {
        this(context, null, 0, 0, 14, null);
        Intrinsics.checkNotNullParameter(context, "context");
    }

    public ItemGroupView(Context context, AttributeSet attributeSet) {
        this(context, attributeSet, 0, 0, 12, null);
        Intrinsics.checkNotNullParameter(context, "context");
    }

    public ItemGroupView(Context context, AttributeSet attributeSet, int i) {
        this(context, attributeSet, i, 0, 8, null);
        Intrinsics.checkNotNullParameter(context, "context");
    }

    public ItemGroupView(Context context, AttributeSet attributeSet, int i, int i2, int i3, DefaultConstructorMarker defaultConstructorMarker) {
        this(context, (i3 & 2) != 0 ? null : attributeSet, (i3 & 4) != 0 ? 0 : i, (i3 & 8) != 0 ? 0 : i2);
    }

    public ItemGroupView(Context context, AttributeSet attributeSet, int i, int i2) {
        super(context, attributeSet, i, i2);
        Intrinsics.checkNotNullParameter(context, "context");
        this.rendering = new ItemGroupRendering();
        FrameLayout.inflate(context, R.layout.zuia_view_item_group, this);
        View viewFindViewById = findViewById(R.id.zuia_item_container);
        Intrinsics.checkNotNullExpressionValue(viewFindViewById, "findViewById(...)");
        LinearLayout linearLayout = (LinearLayout) viewFindViewById;
        this.itemContainer = linearLayout;
        linearLayout.setClipToOutline(true);
        context.getTheme().resolveAttribute(com.google.android.material.R.attr.colorOnSurface, new TypedValue(), true);
        ViewKt.outlinedBoxBackground$default(linearLayout, 0, 0.0f, 0.0f, 0, 15, null);
        render(new Function1<ItemGroupRendering, ItemGroupRendering>() {
            @Override
            public final ItemGroupRendering invoke(ItemGroupRendering it) {
                Intrinsics.checkNotNullParameter(it, "it");
                return it;
            }
        });
    }

    public void render(Function1<? super ItemGroupRendering, ItemGroupRendering> renderingUpdate) {
        Intrinsics.checkNotNullParameter(renderingUpdate, "renderingUpdate");
        this.rendering = renderingUpdate.invoke(this.rendering);
        int dimensionPixelSize = getResources().getDimensionPixelSize(R.dimen.zuia_divider_size);
        Item item = (Item) CollectionsKt.lastOrNull((List) this.rendering.getState().getItems$zendesk_ui_ui_android());
        this.itemContainer.removeAllViews();
        for (Item<?> item2 : this.rendering.getState().getItems$zendesk_ui_ui_android()) {
            this.itemContainer.addView(createItemView(item2));
            if (Intrinsics.areEqual(item2, item)) {
                return;
            }
            View viewInflate = LayoutInflater.from(getContext()).inflate(R.layout.zuia_view_divider, (ViewGroup) this, false);
            ViewGroup.LayoutParams layoutParams = viewInflate.getLayoutParams();
            ViewGroup.MarginLayoutParams marginLayoutParams = null;
            ViewGroup.MarginLayoutParams marginLayoutParams2 = layoutParams instanceof ViewGroup.MarginLayoutParams ? (ViewGroup.MarginLayoutParams) layoutParams : null;
            if (marginLayoutParams2 != null) {
                marginLayoutParams2.setMarginStart(dimensionPixelSize);
                marginLayoutParams2.setMarginEnd(dimensionPixelSize);
                marginLayoutParams = marginLayoutParams2;
            }
            viewInflate.setLayoutParams(marginLayoutParams);
            this.itemContainer.addView(viewInflate);
        }
    }

    private final View createItemView(final Item<?> item) {
        Context context = getContext();
        Intrinsics.checkNotNullExpressionValue(context, "getContext(...)");
        ItemView itemView = new ItemView(context, null, 0, 0, 14, null);
        itemView.render(new Function1<ItemRendering, ItemRendering>() {
            {
                super(1);
            }

            @Override
            public final ItemRendering invoke(ItemRendering itemRendering) {
                Intrinsics.checkNotNullParameter(itemRendering, "itemRendering");
                ItemRendering.Builder builder = itemRendering.toBuilder();
                final Item<?> item2 = item;
                final ItemGroupView itemGroupView = this;
                ItemRendering.Builder builderState = builder.state(new Function1<ItemState, ItemState>() {
                    {
                        super(1);
                    }

                    @Override
                    public final ItemState invoke(ItemState state) {
                        Intrinsics.checkNotNullParameter(state, "state");
                        return state.copy(item2, itemGroupView.rendering.getState().getTitleColor$zendesk_ui_ui_android(), itemGroupView.rendering.getState().getPressedColor$zendesk_ui_ui_android());
                    }
                });
                Function1<Item<?>, Unit> onItemClicked$zendesk_ui_ui_android = this.rendering.getOnItemClicked$zendesk_ui_ui_android();
                if (onItemClicked$zendesk_ui_ui_android != null) {
                    builderState.onItemClicked(onItemClicked$zendesk_ui_ui_android);
                }
                return builderState.build();
            }
        });
        return itemView;
    }
}
