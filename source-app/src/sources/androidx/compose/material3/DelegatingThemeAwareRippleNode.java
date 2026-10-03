package androidx.compose.material3;

import androidx.compose.foundation.interaction.InteractionSource;
import androidx.compose.material.ripple.RippleAlpha;
import androidx.compose.p002ui.graphics.Color;
import androidx.compose.p002ui.graphics.ColorProducer;
import androidx.compose.p002ui.node.CompositionLocalConsumerModifierNode;
import androidx.compose.p002ui.node.CompositionLocalConsumerModifierNodeKt;
import androidx.compose.p002ui.node.DelegatableNode;
import androidx.compose.p002ui.node.DelegatingNode;
import androidx.compose.p002ui.node.ObserverModifierNode;
import androidx.compose.p002ui.node.ObserverModifierNodeKt;
import kotlin.Metadata;
import kotlin.Unit;
import kotlin.jvm.functions.Function0;
import kotlin.jvm.internal.DefaultConstructorMarker;

@Metadata(d1 = {"\u0000:\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u000b\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u0002\n\u0002\b\u0005\b\u0002\u0018\u00002\u00020\u00012\u00020\u00022\u00020\u0003B%\u0012\u0006\u0010\u0004\u001a\u00020\u0005\u0012\u0006\u0010\u0006\u001a\u00020\u0007\u0012\u0006\u0010\b\u001a\u00020\t\u0012\u0006\u0010\n\u001a\u00020\u000b¢\u0006\u0002\u0010\fJ\b\u0010\u0010\u001a\u00020\u0011H\u0002J\b\u0010\u0012\u001a\u00020\u0011H\u0016J\b\u0010\u0013\u001a\u00020\u0011H\u0016J\b\u0010\u0014\u001a\u00020\u0011H\u0002J\b\u0010\u0015\u001a\u00020\u0011H\u0002R\u000e\u0010\u0006\u001a\u00020\u0007X\u0082\u0004¢\u0006\u0002\n\u0000R\u000e\u0010\n\u001a\u00020\u000bX\u0082\u0004¢\u0006\u0002\n\u0000R\u000e\u0010\u0004\u001a\u00020\u0005X\u0082\u0004¢\u0006\u0002\n\u0000R\u0016\u0010\b\u001a\u00020\tX\u0082\u0004ø\u0001\u0000ø\u0001\u0001¢\u0006\u0004\n\u0002\u0010\rR\u0010\u0010\u000e\u001a\u0004\u0018\u00010\u000fX\u0082\u000e¢\u0006\u0002\n\u0000\u0082\u0002\u000b\n\u0005\b¡\u001e0\u0001\n\u0002\b!¨\u0006\u0016"}, d2 = {"Landroidx/compose/material3/DelegatingThemeAwareRippleNode;", "Landroidx/compose/ui/node/DelegatingNode;", "Landroidx/compose/ui/node/CompositionLocalConsumerModifierNode;", "Landroidx/compose/ui/node/ObserverModifierNode;", "interactionSource", "Landroidx/compose/foundation/interaction/InteractionSource;", "bounded", "", "radius", "Landroidx/compose/ui/unit/Dp;", "color", "Landroidx/compose/ui/graphics/ColorProducer;", "(Landroidx/compose/foundation/interaction/InteractionSource;ZFLandroidx/compose/ui/graphics/ColorProducer;Lkotlin/jvm/internal/DefaultConstructorMarker;)V", "F", "rippleNode", "Landroidx/compose/ui/node/DelegatableNode;", "attachNewRipple", "", "onAttach", "onObservedReadsChanged", "removeRipple", "updateConfiguration", "material3_release"}, k = 1, mv = {1, 8, 0}, xi = 48)
final class DelegatingThemeAwareRippleNode extends DelegatingNode implements CompositionLocalConsumerModifierNode, ObserverModifierNode {
    private final boolean bounded;
    private final ColorProducer color;
    private final InteractionSource interactionSource;
    private final float radius;
    private DelegatableNode rippleNode;

    public DelegatingThemeAwareRippleNode(InteractionSource interactionSource, boolean z, float f, ColorProducer colorProducer, DefaultConstructorMarker defaultConstructorMarker) {
        this(interactionSource, z, f, colorProducer);
    }

    private DelegatingThemeAwareRippleNode(InteractionSource interactionSource, boolean z, float f, ColorProducer colorProducer) {
        this.interactionSource = interactionSource;
        this.bounded = z;
        this.radius = f;
        this.color = colorProducer;
    }

    @Override
    public void onAttach() {
        updateConfiguration();
    }

    @Override
    public void onObservedReadsChanged() {
        updateConfiguration();
    }

    private final void updateConfiguration() {
        ObserverModifierNodeKt.observeReads(this, new Function0<Unit>() {
            {
                super(0);
            }

            public Object invoke() {
                m2332invoke();
                return Unit.INSTANCE;
            }

            public final void m2332invoke() {
                if (((RippleConfiguration) CompositionLocalConsumerModifierNodeKt.currentValueOf(DelegatingThemeAwareRippleNode.this, RippleKt.getLocalRippleConfiguration())) == null) {
                    DelegatingThemeAwareRippleNode.this.removeRipple();
                } else if (DelegatingThemeAwareRippleNode.this.rippleNode == null) {
                    DelegatingThemeAwareRippleNode.this.attachNewRipple();
                }
            }
        });
    }

    public final void attachNewRipple() {
        this.rippleNode = delegate(androidx.compose.material.ripple.RippleKt.m1975createRippleModifierNodeTDGSqEk(this.interactionSource, this.bounded, this.radius, new ColorProducer() {
            @Override
            public final long mo2330invoke0d7_KjU() {
                long jMo2330invoke0d7_KjU = this.this$0.color.mo2330invoke0d7_KjU();
                if (jMo2330invoke0d7_KjU != 16) {
                    return jMo2330invoke0d7_KjU;
                }
                RippleConfiguration rippleConfiguration = (RippleConfiguration) CompositionLocalConsumerModifierNodeKt.currentValueOf(this.this$0, RippleKt.getLocalRippleConfiguration());
                if (rippleConfiguration != null && rippleConfiguration.getColor() != 16) {
                    return rippleConfiguration.getColor();
                }
                return ((Color) CompositionLocalConsumerModifierNodeKt.currentValueOf(this.this$0, ContentColorKt.getLocalContentColor())).m4600unboximpl();
            }
        }, new Function0<RippleAlpha>() {
            {
                super(0);
            }

            public final RippleAlpha m2331invoke() {
                RippleAlpha rippleAlpha;
                RippleConfiguration rippleConfiguration = (RippleConfiguration) CompositionLocalConsumerModifierNodeKt.currentValueOf(this.this$0, RippleKt.getLocalRippleConfiguration());
                return (rippleConfiguration == null || (rippleAlpha = rippleConfiguration.getRippleAlpha()) == null) ? RippleDefaults.INSTANCE.getRippleAlpha() : rippleAlpha;
            }
        }));
    }

    public final void removeRipple() {
        DelegatableNode delegatableNode = this.rippleNode;
        if (delegatableNode != null) {
            undelegate(delegatableNode);
        }
    }
}
