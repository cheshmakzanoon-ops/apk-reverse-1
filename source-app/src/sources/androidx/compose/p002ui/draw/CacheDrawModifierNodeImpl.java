package androidx.compose.p002ui.draw;

import androidx.compose.p002ui.Modifier;
import androidx.compose.p002ui.graphics.Fields;
import androidx.compose.p002ui.graphics.GraphicsContext;
import androidx.compose.p002ui.graphics.drawscope.ContentDrawScope;
import androidx.compose.p002ui.internal.InlineClassHelperKt;
import androidx.compose.p002ui.node.DelegatableNodeKt;
import androidx.compose.p002ui.node.DrawModifierNodeKt;
import androidx.compose.p002ui.node.NodeKind;
import androidx.compose.p002ui.node.ObserverModifierNode;
import androidx.compose.p002ui.node.ObserverModifierNodeKt;
import androidx.compose.ui.unit.Density;
import androidx.compose.ui.unit.IntSizeKt;
import androidx.compose.ui.unit.LayoutDirection;
import kotlin.KotlinNothingValueException;
import kotlin.Metadata;
import kotlin.Unit;
import kotlin.jvm.functions.Function0;
import kotlin.jvm.functions.Function1;
import kotlin.jvm.internal.Intrinsics;

@Metadata(d1 = {"\u0000f\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0007\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0010\u000b\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0002\b\u0004\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u0002\n\u0002\b\u0005\b\u0002\u0018\u00002\u00020\u00012\u00020\u00022\u00020\u00032\u00020\u0004B&\u0012\u0006\u0010\u0005\u001a\u00020\u0006\u0012\u0017\u0010\u0007\u001a\u0013\u0012\u0004\u0012\u00020\u0006\u0012\u0004\u0012\u00020\t0\b¢\u0006\u0002\b\n¢\u0006\u0002\u0010\u000bJ\u0010\u0010%\u001a\u00020\t2\u0006\u0010&\u001a\u00020'H\u0002J\b\u0010(\u001a\u00020)H\u0016J\b\u0010*\u001a\u00020)H\u0016J\b\u0010+\u001a\u00020)H\u0016J\b\u0010,\u001a\u00020)H\u0016J\f\u0010-\u001a\u00020)*\u00020'H\u0016RF\u0010\u0007\u001a\u0013\u0012\u0004\u0012\u00020\u0006\u0012\u0004\u0012\u00020\t0\b¢\u0006\u0002\b\n2\u0017\u0010\f\u001a\u0013\u0012\u0004\u0012\u00020\u0006\u0012\u0004\u0012\u00020\t0\b¢\u0006\u0002\b\n@FX\u0086\u000e¢\u0006\u000e\n\u0000\u001a\u0004\b\r\u0010\u000e\"\u0004\b\u000f\u0010\u0010R\u000e\u0010\u0005\u001a\u00020\u0006X\u0082\u0004¢\u0006\u0002\n\u0000R\u0010\u0010\u0011\u001a\u0004\u0018\u00010\u0012X\u0082\u000e¢\u0006\u0002\n\u0000R\u0014\u0010\u0013\u001a\u00020\u00148VX\u0096\u0004¢\u0006\u0006\u001a\u0004\b\u0015\u0010\u0016R\u0011\u0010\u0017\u001a\u00020\u00188F¢\u0006\u0006\u001a\u0004\b\u0019\u0010\u001aR\u000e\u0010\u001b\u001a\u00020\u001cX\u0082\u000e¢\u0006\u0002\n\u0000R\u0014\u0010\u001d\u001a\u00020\u001e8VX\u0096\u0004¢\u0006\u0006\u001a\u0004\b\u001f\u0010 R\u001a\u0010!\u001a\u00020\"8VX\u0096\u0004ø\u0001\u0000ø\u0001\u0001¢\u0006\u0006\u001a\u0004\b#\u0010$\u0082\u0002\u000b\n\u0005\b¡\u001e0\u0001\n\u0002\b!¨\u0006."}, d2 = {"Landroidx/compose/ui/draw/CacheDrawModifierNodeImpl;", "Landroidx/compose/ui/Modifier$Node;", "Landroidx/compose/ui/draw/CacheDrawModifierNode;", "Landroidx/compose/ui/node/ObserverModifierNode;", "Landroidx/compose/ui/draw/BuildDrawCacheParams;", "cacheDrawScope", "Landroidx/compose/ui/draw/CacheDrawScope;", "block", "Lkotlin/Function1;", "Landroidx/compose/ui/draw/DrawResult;", "Lkotlin/ExtensionFunctionType;", "(Landroidx/compose/ui/draw/CacheDrawScope;Lkotlin/jvm/functions/Function1;)V", "value", "getBlock", "()Lkotlin/jvm/functions/Function1;", "setBlock", "(Lkotlin/jvm/functions/Function1;)V", "cachedGraphicsContext", "Landroidx/compose/ui/draw/ScopedGraphicsContext;", "density", "Landroidx/compose/ui/unit/Density;", "getDensity", "()Landroidx/compose/ui/unit/Density;", "graphicsContext", "Landroidx/compose/ui/graphics/GraphicsContext;", "getGraphicsContext", "()Landroidx/compose/ui/graphics/GraphicsContext;", "isCacheValid", "", "layoutDirection", "Landroidx/compose/ui/unit/LayoutDirection;", "getLayoutDirection", "()Landroidx/compose/ui/unit/LayoutDirection;", "size", "Landroidx/compose/ui/geometry/Size;", "getSize-NH-jbRc", "()J", "getOrBuildCachedDrawBlock", "contentDrawScope", "Landroidx/compose/ui/graphics/drawscope/ContentDrawScope;", "invalidateDrawCache", "", "onDetach", "onMeasureResultChanged", "onObservedReadsChanged", "draw", "ui_release"}, k = 1, mv = {1, 8, 0}, xi = 48)
final class CacheDrawModifierNodeImpl extends Modifier.Node implements CacheDrawModifierNode, ObserverModifierNode, BuildDrawCacheParams {
    private Function1<? super CacheDrawScope, DrawResult> block;
    private final CacheDrawScope cacheDrawScope;
    private ScopedGraphicsContext cachedGraphicsContext;
    private boolean isCacheValid;

    public CacheDrawModifierNodeImpl(CacheDrawScope cacheDrawScope, Function1<? super CacheDrawScope, DrawResult> function1) {
        this.cacheDrawScope = cacheDrawScope;
        this.block = function1;
        cacheDrawScope.setCacheParams$ui_release(this);
        cacheDrawScope.setGraphicsContextProvider$ui_release(new Function0<GraphicsContext>() {
            {
                super(0);
            }

            public final GraphicsContext m4214invoke() {
                return CacheDrawModifierNodeImpl.this.getGraphicsContext();
            }
        });
    }

    public final Function1<CacheDrawScope, DrawResult> getBlock() {
        return this.block;
    }

    public final void setBlock(Function1<? super CacheDrawScope, DrawResult> function1) {
        this.block = function1;
        invalidateDrawCache();
    }

    @Override
    public Density getDensity() {
        return DelegatableNodeKt.requireDensity(this);
    }

    @Override
    public LayoutDirection getLayoutDirection() {
        return DelegatableNodeKt.requireLayoutDirection(this);
    }

    @Override
    public long mo4213getSizeNHjbRc() {
        return IntSizeKt.toSize-ozmzZPI(DelegatableNodeKt.m6200requireCoordinator64DMado(this, NodeKind.m6367constructorimpl(Fields.SpotShadowColor)).mo6040getSizeYbymL2g());
    }

    public final GraphicsContext getGraphicsContext() {
        ScopedGraphicsContext scopedGraphicsContext = this.cachedGraphicsContext;
        if (scopedGraphicsContext == null) {
            scopedGraphicsContext = new ScopedGraphicsContext();
            this.cachedGraphicsContext = scopedGraphicsContext;
        }
        if (scopedGraphicsContext.getGraphicsContext() == null) {
            scopedGraphicsContext.setGraphicsContext(DelegatableNodeKt.requireGraphicsContext(this));
        }
        return scopedGraphicsContext;
    }

    @Override
    public void onDetach() {
        super.onDetach();
        ScopedGraphicsContext scopedGraphicsContext = this.cachedGraphicsContext;
        if (scopedGraphicsContext != null) {
            scopedGraphicsContext.releaseGraphicsLayers();
        }
    }

    @Override
    public void onMeasureResultChanged() {
        invalidateDrawCache();
    }

    @Override
    public void onObservedReadsChanged() {
        invalidateDrawCache();
    }

    @Override
    public void invalidateDrawCache() {
        ScopedGraphicsContext scopedGraphicsContext = this.cachedGraphicsContext;
        if (scopedGraphicsContext != null) {
            scopedGraphicsContext.releaseGraphicsLayers();
        }
        this.isCacheValid = false;
        this.cacheDrawScope.setDrawResult$ui_release(null);
        DrawModifierNodeKt.invalidateDraw(this);
    }

    private final DrawResult getOrBuildCachedDrawBlock(ContentDrawScope contentDrawScope) throws KotlinNothingValueException {
        if (!this.isCacheValid) {
            final CacheDrawScope cacheDrawScope = this.cacheDrawScope;
            cacheDrawScope.setDrawResult$ui_release(null);
            cacheDrawScope.setContentDrawScope$ui_release(contentDrawScope);
            ObserverModifierNodeKt.observeReads(this, new Function0<Unit>() {
                {
                    super(0);
                }

                public Object invoke() {
                    m4215invoke();
                    return Unit.INSTANCE;
                }

                public final void m4215invoke() {
                    this.this$0.getBlock().invoke(cacheDrawScope);
                }
            });
            if (cacheDrawScope.getDrawResult() != null) {
                this.isCacheValid = true;
            } else {
                InlineClassHelperKt.throwIllegalStateExceptionForNullCheck("DrawResult not defined, did you forget to call onDraw?");
                throw new KotlinNothingValueException();
            }
        }
        DrawResult drawResult = this.cacheDrawScope.getDrawResult();
        Intrinsics.checkNotNull(drawResult);
        return drawResult;
    }

    @Override
    public void draw(ContentDrawScope contentDrawScope) {
        getOrBuildCachedDrawBlock(contentDrawScope).getBlock$ui_release().invoke(contentDrawScope);
    }
}
