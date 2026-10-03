package androidx.compose.material3;

import androidx.compose.p002ui.Modifier;
import androidx.compose.p002ui.draw.CacheDrawScope;
import androidx.compose.p002ui.draw.DrawModifierKt;
import androidx.compose.p002ui.draw.DrawResult;
import androidx.compose.p002ui.layout.LayoutCoordinates;
import kotlin.Metadata;
import kotlin.jvm.functions.Function0;
import kotlin.jvm.functions.Function1;
import kotlin.jvm.functions.Function2;

@Metadata(d1 = {"\u0000.\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0004\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\b\u0000\u0018\u00002\u00020\u0001B\u0015\u0012\u000e\u0010\u0002\u001a\n\u0012\u0006\u0012\u0004\u0018\u00010\u00040\u0003¢\u0006\u0002\u0010\u0005J-\u0010\b\u001a\u00020\t*\u00020\t2\u001f\u0010\n\u001a\u001b\u0012\u0004\u0012\u00020\f\u0012\u0006\u0012\u0004\u0018\u00010\u0004\u0012\u0004\u0012\u00020\r0\u000b¢\u0006\u0002\b\u000eH\u0016R\u0019\u0010\u0002\u001a\n\u0012\u0006\u0012\u0004\u0018\u00010\u00040\u0003¢\u0006\b\n\u0000\u001a\u0004\b\u0006\u0010\u0007¨\u0006\u000f"}, d2 = {"Landroidx/compose/material3/TooltipScopeImpl;", "Landroidx/compose/material3/TooltipScope;", "getAnchorBounds", "Lkotlin/Function0;", "Landroidx/compose/ui/layout/LayoutCoordinates;", "(Lkotlin/jvm/functions/Function0;)V", "getGetAnchorBounds", "()Lkotlin/jvm/functions/Function0;", "drawCaret", "Landroidx/compose/ui/Modifier;", "draw", "Lkotlin/Function2;", "Landroidx/compose/ui/draw/CacheDrawScope;", "Landroidx/compose/ui/draw/DrawResult;", "Lkotlin/ExtensionFunctionType;", "material3_release"}, k = 1, mv = {1, 8, 0}, xi = 48)
public final class TooltipScopeImpl implements TooltipScope {
    public static final int $stable = 0;
    private final Function0<LayoutCoordinates> getAnchorBounds;

    public TooltipScopeImpl(Function0<? extends LayoutCoordinates> function0) {
        this.getAnchorBounds = function0;
    }

    public final Function0<LayoutCoordinates> getGetAnchorBounds() {
        return this.getAnchorBounds;
    }

    @Override
    public Modifier drawCaret(Modifier modifier, final Function2<? super CacheDrawScope, ? super LayoutCoordinates, DrawResult> function2) {
        return DrawModifierKt.drawWithCache(modifier, new Function1<CacheDrawScope, DrawResult>() {
            {
                super(1);
            }

            public final DrawResult invoke(CacheDrawScope cacheDrawScope) {
                return (DrawResult) function2.invoke(cacheDrawScope, this.getGetAnchorBounds().invoke());
            }
        });
    }
}
