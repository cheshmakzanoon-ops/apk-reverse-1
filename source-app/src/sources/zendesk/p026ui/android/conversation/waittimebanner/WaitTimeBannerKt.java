package zendesk.p026ui.android.conversation.waittimebanner;

import androidx.compose.foundation.BorderKt;
import androidx.compose.foundation.BorderStroke;
import androidx.compose.foundation.BorderStrokeKt;
import androidx.compose.foundation.FocusableKt;
import androidx.compose.foundation.interaction.MutableInteractionSource;
import androidx.compose.foundation.layout.Arrangement;
import androidx.compose.foundation.layout.AspectRatioKt;
import androidx.compose.foundation.layout.ColumnKt;
import androidx.compose.foundation.layout.ColumnScope;
import androidx.compose.foundation.layout.ColumnScopeInstance;
import androidx.compose.foundation.layout.PaddingKt;
import androidx.compose.foundation.layout.SizeKt;
import androidx.compose.foundation.shape.RoundedCornerShapeKt;
import androidx.compose.foundation.text.InlineTextContent;
import androidx.compose.foundation.text.InlineTextContentKt;
import androidx.compose.material3.IconKt;
import androidx.compose.material3.TextKt;
import androidx.compose.runtime.Applier;
import androidx.compose.runtime.ComposablesKt;
import androidx.compose.runtime.Composer;
import androidx.compose.runtime.ComposerKt;
import androidx.compose.runtime.CompositionLocalMap;
import androidx.compose.runtime.RecomposeScopeImplKt;
import androidx.compose.runtime.ScopeUpdateScope;
import androidx.compose.runtime.Updater;
import androidx.compose.runtime.internal.ComposableLambdaKt;
import androidx.compose.ui.Alignment;
import androidx.compose.ui.ComposedModifierKt;
import androidx.compose.ui.Modifier;
import androidx.compose.ui.draw.ClipKt;
import androidx.compose.ui.focus.FocusChangedModifierKt;
import androidx.compose.ui.focus.FocusState;
import androidx.compose.ui.graphics.Color;
import androidx.compose.ui.graphics.Shape;
import androidx.compose.ui.layout.MeasurePolicy;
import androidx.compose.ui.node.ComposeUiNode;
import androidx.compose.ui.platform.TestTagKt;
import androidx.compose.ui.res.PainterResources_androidKt;
import androidx.compose.ui.res.PrimitiveResources_androidKt;
import androidx.compose.ui.res.StringResources_androidKt;
import androidx.compose.ui.semantics.LiveRegionMode;
import androidx.compose.ui.semantics.SemanticsModifierKt;
import androidx.compose.ui.semantics.SemanticsPropertiesKt;
import androidx.compose.ui.semantics.SemanticsPropertyReceiver;
import androidx.compose.ui.text.AnnotatedString;
import androidx.compose.ui.text.Placeholder;
import androidx.compose.ui.text.PlaceholderVerticalAlign;
import androidx.compose.ui.text.TextStyle;
import androidx.compose.ui.text.font.FontFamily;
import androidx.compose.ui.text.font.FontStyle;
import androidx.compose.ui.text.font.FontWeight;
import androidx.compose.ui.text.style.TextAlign;
import androidx.compose.ui.text.style.TextDecoration;
import androidx.compose.ui.unit.TextUnitKt;
import java.util.Map;
import kotlin.Metadata;
import kotlin.NoWhenBranchMatchedException;
import kotlin.TuplesKt;
import kotlin.Unit;
import kotlin.collections.MapsKt;
import kotlin.jvm.functions.Function0;
import kotlin.jvm.functions.Function1;
import kotlin.jvm.functions.Function2;
import kotlin.jvm.functions.Function3;
import kotlin.jvm.internal.DefaultConstructorMarker;
import kotlin.jvm.internal.Intrinsics;
import zendesk.ui.android.R;
import zendesk.ui.android.compose.theme.ThemeKt;
import zendesk.ui.android.compose.utils.PreviewThemes;
import zendesk.ui.android.compose.utils.ResourceUtilsKt;

@Metadata(m17d1 = {"\u0000D\n\u0000\n\u0002\u0010\u000e\n\u0002\b\u0003\n\u0002\u0010\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0007\n\u0002\u0018\u0002\n\u0002\b\u0005\n\u0002\u0010\u000b\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\t\n\u0002\u0010\t\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0002\b\u0002\u001a\u001a\u0010\u0004\u001a\u00020\u00052\u0006\u0010\u0006\u001a\u00020\u0007H\u0003ø\u0001\u0000¢\u0006\u0004\b\b\u0010\t\u001a\r\u0010\n\u001a\u00020\u0005H\u0003¢\u0006\u0002\u0010\u000b\u001a\r\u0010\f\u001a\u00020\u0005H\u0003¢\u0006\u0002\u0010\u000b\u001ah\u0010\r\u001a\u00020\u00052\u0006\u0010\u000e\u001a\u00020\u000f2\u0006\u0010\u0006\u001a\u00020\u00072\u0006\u0010\u0010\u001a\u00020\u00072\u0006\u0010\u0011\u001a\u00020\u00072\u0006\u0010\u0012\u001a\u00020\u00072\u0006\u0010\u0013\u001a\u00020\u00072\u0006\u0010\u0014\u001a\u00020\u00152\u0012\u0010\u0016\u001a\u000e\u0012\u0004\u0012\u00020\u0015\u0012\u0004\u0012\u00020\u00050\u00172\b\b\u0002\u0010\u0018\u001a\u00020\u0019H\u0007ø\u0001\u0000¢\u0006\u0004\b\u001a\u0010\u001b\u001a*\u0010\u001c\u001a\u00020\u00052\u0006\u0010\u0006\u001a\u00020\u00072\u0006\u0010\u001d\u001a\u00020\u00012\u0006\u0010\u001e\u001a\u00020\u0007H\u0003ø\u0001\u0000¢\u0006\u0004\b\u001f\u0010 \u001a\u001d\u0010!\u001a\u00020\u00012\u0006\u0010\"\u001a\u00020#2\u0006\u0010$\u001a\u00020#H\u0003¢\u0006\u0002\u0010%\u001a\u0015\u0010&\u001a\u00020\u00012\u0006\u0010\u000e\u001a\u00020'H\u0003¢\u0006\u0002\u0010(\"\u0014\u0010\u0000\u001a\u00020\u0001X\u0080T¢\u0006\b\n\u0000\u0012\u0004\b\u0002\u0010\u0003\u0082\u0002\u0007\n\u0005\b¡\u001e0\u0001¨\u0006)"}, m18d2 = {WaitTimeBannerKt.ZUIWaitTimeBannerTag, "", "getZUIWaitTimeBannerTag$annotations", "()V", "ClockIcon", "", "iconColor", "Landroidx/compose/ui/graphics/Color;", "ClockIcon-ek8zF_U", "(JLandroidx/compose/runtime/Composer;I)V", "PreviewBanner", "(Landroidx/compose/runtime/Composer;I)V", "PreviewClearedBanner", "WaitTimeBanner", "type", "Lzendesk/ui/android/conversation/waittimebanner/WaitTimeBannerType;", "borderColor", "focusedBorderColor", "statusColor", "descriptionColor", "isFocused", "", "onFocusChange", "Lkotlin/Function1;", "modifier", "Landroidx/compose/ui/Modifier;", "WaitTimeBanner-fB7ZVRg", "(Lzendesk/ui/android/conversation/waittimebanner/WaitTimeBannerType;JJJJJZLkotlin/jvm/functions/Function1;Landroidx/compose/ui/Modifier;Landroidx/compose/runtime/Composer;II)V", "WaitTimeText", "text", "textColor", "WaitTimeText-M3jwhU8", "(JLjava/lang/String;JLandroidx/compose/runtime/Composer;I)V", "queuedBannerText", "lowerResponseTime", "", "upperResponseTime", "(JJLandroidx/compose/runtime/Composer;I)Ljava/lang/String;", "stringForType", "Lzendesk/ui/android/conversation/waittimebanner/QueuedBannerStatusType;", "(Lzendesk/ui/android/conversation/waittimebanner/QueuedBannerStatusType;Landroidx/compose/runtime/Composer;I)Ljava/lang/String;", "zendesk.ui_ui-android"}, m19k = 2, m20mv = {1, 9, 0}, m22xi = 48)
public final class WaitTimeBannerKt {
    public static final String ZUIWaitTimeBannerTag = "ZUIWaitTimeBannerTag";

    public static void getZUIWaitTimeBannerTag$annotations() {
    }

    public static final void m2150WaitTimeBannerfB7ZVRg(final WaitTimeBannerType type, final long j, final long j2, final long j3, final long j4, final long j5, final boolean z, final Function1<? super Boolean, Unit> onFocusChange, Modifier modifier, Composer composer, final int i, final int i2) {
        int i3;
        int i4;
        int i5;
        int i6;
        Modifier modifier2;
        int i7;
        Shape shape;
        BorderStroke borderStroke;
        int i8;
        String str;
        final String strPluralStringResource;
        boolean shouldShowQueue;
        boolean z2;
        final Modifier modifier3;
        boolean z3;
        Object objRememberedValue;
        int currentCompositeKeyHash;
        Function0 constructor;
        Composer composer2;
        Function2 setCompositeKeyHash;
        ScopeUpdateScope scopeUpdateScopeEndRestartGroup;
        ScopeUpdateScope scopeUpdateScopeEndRestartGroup2;
        Intrinsics.checkNotNullParameter(type, "type");
        Intrinsics.checkNotNullParameter(onFocusChange, "onFocusChange");
        Composer composerStartRestartGroup = composer.startRestartGroup(-1731051425);
        if ((i2 & 1) != 0) {
            i3 = i | 6;
        } else if ((i & 14) == 0) {
            i3 = (composerStartRestartGroup.changed(type) ? 4 : 2) | i;
        } else {
            i3 = i;
        }
        if ((i2 & 2) != 0) {
            i3 |= 48;
        } else if ((i & 112) == 0) {
            i3 |= composerStartRestartGroup.changed(j) ? 32 : 16;
        }
        if ((i2 & 4) != 0) {
            i3 |= 384;
        } else if ((i & 896) == 0) {
            i3 |= composerStartRestartGroup.changed(j2) ? 256 : 128;
        }
        if ((i2 & 8) != 0) {
            i3 |= 3072;
        } else if ((i & 7168) == 0) {
            i3 |= composerStartRestartGroup.changed(j3) ? 2048 : 1024;
        }
        if ((i2 & 16) != 0) {
            i3 |= 24576;
        } else if ((57344 & i) == 0) {
            i3 |= composerStartRestartGroup.changed(j4) ? 16384 : 8192;
        }
        if ((i2 & 32) != 0) {
            i3 |= 196608;
        } else if ((i & 458752) == 0) {
            i3 |= composerStartRestartGroup.changed(j5) ? 131072 : 65536;
        }
        if ((i2 & 64) == 0) {
            if ((i & 3670016) == 0) {
                i4 = composerStartRestartGroup.changed(z) ? 1048576 : 524288;
            }
            if ((i2 & 128) != 0) {
                if ((i & 29360128) == 0) {
                    if (composerStartRestartGroup.changedInstance(onFocusChange)) {
                        i5 = 8388608;
                    } else {
                        i5 = 4194304;
                    }
                }
                i6 = i2 & 256;
                if (i6 != 0) {
                    i3 |= 100663296;
                    modifier2 = modifier;
                } else {
                    modifier2 = modifier;
                    if ((i & 234881024) == 0) {
                        if (composerStartRestartGroup.changed(modifier2)) {
                            i7 = 67108864;
                        } else {
                            i7 = 33554432;
                        }
                        i3 |= i7;
                    }
                }
                if ((i3 & 191739611) == 38347922 || !composerStartRestartGroup.getSkipping()) {
                    if (i6 != 0) {
                        modifier2 = (Modifier) Modifier.Companion;
                    }
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(-1731051425, i3, -1, "zendesk.ui.android.conversation.waittimebanner.WaitTimeBanner (WaitTimeBanner.kt:72)");
                    }
                    shape = RoundedCornerShapeKt.RoundedCornerShape-0680j_4(PrimitiveResources_androidKt.dimensionResource(R.dimen.zuia_wait_time_banner_border_radius, composerStartRestartGroup, 0));
                    if (type instanceof WaitTimeBannerType.Cleared) {
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventEnd();
                        }
                        scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
                        if (scopeUpdateScopeEndRestartGroup != null) {
                            final Modifier modifier4 = modifier2;
                            scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                                {
                                    super(2);
                                }

                                @Override
                                public Unit invoke(Composer composer3, Integer num) {
                                    invoke(composer3, num.intValue());
                                    return Unit.INSTANCE;
                                }

                                public final void invoke(Composer composer3, int i9) {
                                    WaitTimeBannerKt.m2150WaitTimeBannerfB7ZVRg(type, j, j2, j3, j4, j5, z, onFocusChange, modifier4, composer3, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                                }
                            });
                            return;
                        }
                        return;
                    }
                    Modifier modifier5 = modifier2;
                    if (z) {
                        composerStartRestartGroup.startReplaceGroup(2081561351);
                        borderStroke = BorderStrokeKt.BorderStroke-cXLIe8U(PrimitiveResources_androidKt.dimensionResource(R.dimen.zuia_border_width, composerStartRestartGroup, 0), j3);
                        composerStartRestartGroup.endReplaceGroup();
                    } else {
                        composerStartRestartGroup.startReplaceGroup(2081714150);
                        borderStroke = BorderStrokeKt.BorderStroke-cXLIe8U(PrimitiveResources_androidKt.dimensionResource(R.dimen.zuia_divider_size, composerStartRestartGroup, 0), Color.copy-wmQWz5c$default(j2, ResourceUtilsKt.floatResources(R.dimen.zuia_wait_time_banner_border_alpha, composerStartRestartGroup, 0), 0.0f, 0.0f, 0.0f, 14, (Object) null));
                        composerStartRestartGroup.endReplaceGroup();
                    }
                    if (type instanceof WaitTimeBannerType.Queued) {
                        composerStartRestartGroup.startReplaceGroup(2082150506);
                        WaitTimeBannerType.Queued queued = (WaitTimeBannerType.Queued) type;
                        boolean shouldShowResponseTime = queued.getShouldShowResponseTime();
                        String strQueuedBannerText = queuedBannerText(queued.getResponseTime().getLower(), queued.getResponseTime().getUpper(), composerStartRestartGroup, 0);
                        shouldShowQueue = queued.getShouldShowQueue();
                        z2 = shouldShowResponseTime;
                        i8 = 0;
                        strPluralStringResource = StringResources_androidKt.pluralStringResource(R.plurals.bannerQueue, queued.getQueuePosition(), new Object[]{Integer.valueOf(queued.getQueuePosition())}, composerStartRestartGroup, 512);
                        composerStartRestartGroup.endReplaceGroup();
                        str = strQueuedBannerText;
                    } else {
                        i8 = 0;
                        composerStartRestartGroup.startReplaceGroup(2082609027);
                        String strStringResource = StringResources_androidKt.stringResource(R.string.zuia_static_wait_time_banner_will_be_shortly, composerStartRestartGroup, 0);
                        String strStringResource2 = StringResources_androidKt.stringResource(R.string.zuia_static_wait_time_banner_you_are_up_next, composerStartRestartGroup, 0);
                        composerStartRestartGroup.endReplaceGroup();
                        str = strStringResource;
                        strPluralStringResource = strStringResource2;
                        shouldShowQueue = true;
                        z2 = true;
                    }
                    Alignment.Horizontal centerHorizontally = Alignment.Companion.getCenterHorizontally();
                    modifier3 = modifier5;
                    Modifier modifierFillMaxWidth$default = SizeKt.fillMaxWidth$default(PaddingKt.padding-VpY3zN4$default(SizeKt.defaultMinSize-VpY3zN4$default(modifier3, 0.0f, PrimitiveResources_androidKt.dimensionResource(R.dimen.zuia_wait_time_banner_min_height, composerStartRestartGroup, i8), 1, (Object) null), PrimitiveResources_androidKt.dimensionResource(R.dimen.zuia_spacing_medium, composerStartRestartGroup, 0), 0.0f, 2, (Object) null), 0.0f, 1, (Object) null);
                    composerStartRestartGroup.startReplaceGroup(-1318272805);
                    if ((i3 & 29360128) == 8388608) {
                        z3 = true;
                    } else {
                        z3 = false;
                    }
                    objRememberedValue = composerStartRestartGroup.rememberedValue();
                    if (!z3 || objRememberedValue == Composer.Companion.getEmpty()) {
                        objRememberedValue = (Function1) new Function1<FocusState, Unit>() {
                            {
                                super(1);
                            }

                            @Override
                            public Unit invoke(FocusState focusState) {
                                invoke2(focusState);
                                return Unit.INSTANCE;
                            }

                            public final void invoke2(FocusState focusState) {
                                Intrinsics.checkNotNullParameter(focusState, "focusState");
                                onFocusChange.invoke(Boolean.valueOf(focusState.isFocused()));
                            }
                        };
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                    }
                    composerStartRestartGroup.endReplaceGroup();
                    Shape shape2 = shape;
                    Modifier modifierTestTag = TestTagKt.testTag(SemanticsModifierKt.semantics(PaddingKt.padding-3ABfNKs(ClipKt.clip(BorderKt.border(FocusableKt.focusable$default(FocusChangedModifierKt.onFocusChanged(modifierFillMaxWidth$default, (Function1) objRememberedValue), false, (MutableInteractionSource) null, 3, (Object) null), borderStroke, shape2), shape2), PrimitiveResources_androidKt.dimensionResource(R.dimen.zuia_spacing_medium, composerStartRestartGroup, 0)), true, new Function1<SemanticsPropertyReceiver, Unit>() {
                        @Override
                        public Unit invoke(SemanticsPropertyReceiver semanticsPropertyReceiver) {
                            invoke2(semanticsPropertyReceiver);
                            return Unit.INSTANCE;
                        }

                        public final void invoke2(SemanticsPropertyReceiver semantics) {
                            Intrinsics.checkNotNullParameter(semantics, "$this$semantics");
                            SemanticsPropertiesKt.setLiveRegion-hR3wRGc(semantics, LiveRegionMode.Companion.getAssertive-0phEisY());
                        }
                    }), ZUIWaitTimeBannerTag);
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -483455358, "CC(Column)P(2,3,1)86@4330L61,87@4396L133:Column.kt#2w3rfo");
                    MeasurePolicy measurePolicyColumnMeasurePolicy = ColumnKt.columnMeasurePolicy(Arrangement.INSTANCE.getTop(), centerHorizontally, composerStartRestartGroup, 48);
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1323940314, "CC(Layout)P(!1,2)79@3208L23,82@3359L411:Layout.kt#80mrfh");
                    currentCompositeKeyHash = ComposablesKt.getCurrentCompositeKeyHash(composerStartRestartGroup, 0);
                    CompositionLocalMap currentCompositionLocalMap = composerStartRestartGroup.getCurrentCompositionLocalMap();
                    Modifier modifierMaterializeModifier = ComposedModifierKt.materializeModifier(composerStartRestartGroup, modifierTestTag);
                    constructor = ComposeUiNode.Companion.getConstructor();
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -692256719, "CC(ReusableComposeNode)P(1,2)376@14062L9:Composables.kt#9igjgp");
                    if (!(composerStartRestartGroup.getApplier() instanceof Applier)) {
                        ComposablesKt.invalidApplier();
                    }
                    composerStartRestartGroup.startReusableNode();
                    if (composerStartRestartGroup.getInserting()) {
                        composerStartRestartGroup.createNode(constructor);
                    } else {
                        composerStartRestartGroup.useNode();
                    }
                    composer2 = Updater.constructor-impl(composerStartRestartGroup);
                    Updater.set-impl(composer2, measurePolicyColumnMeasurePolicy, ComposeUiNode.Companion.getSetMeasurePolicy());
                    Updater.set-impl(composer2, currentCompositionLocalMap, ComposeUiNode.Companion.getSetResolvedCompositionLocals());
                    setCompositeKeyHash = ComposeUiNode.Companion.getSetCompositeKeyHash();
                    if (!composer2.getInserting() || !Intrinsics.areEqual(composer2.rememberedValue(), Integer.valueOf(currentCompositeKeyHash))) {
                        composer2.updateRememberedValue(Integer.valueOf(currentCompositeKeyHash));
                        composer2.apply(Integer.valueOf(currentCompositeKeyHash), setCompositeKeyHash);
                    }
                    Updater.set-impl(composer2, modifierMaterializeModifier, ComposeUiNode.Companion.getSetModifier());
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -384784025, "C88@4444L9:Column.kt#2w3rfo");
                    ColumnScope columnScope = ColumnScopeInstance.INSTANCE;
                    if (!z2 && shouldShowQueue) {
                        composerStartRestartGroup.startReplaceGroup(-35313828);
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -483455358, "CC(Column)P(2,3,1)86@4330L61,87@4396L133:Column.kt#2w3rfo");
                        Modifier modifier6 = Modifier.Companion;
                        MeasurePolicy measurePolicyColumnMeasurePolicy2 = ColumnKt.columnMeasurePolicy(Arrangement.INSTANCE.getTop(), Alignment.Companion.getStart(), composerStartRestartGroup, 0);
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1323940314, "CC(Layout)P(!1,2)79@3208L23,82@3359L411:Layout.kt#80mrfh");
                        int currentCompositeKeyHash2 = ComposablesKt.getCurrentCompositeKeyHash(composerStartRestartGroup, 0);
                        CompositionLocalMap currentCompositionLocalMap2 = composerStartRestartGroup.getCurrentCompositionLocalMap();
                        Modifier modifierMaterializeModifier2 = ComposedModifierKt.materializeModifier(composerStartRestartGroup, modifier6);
                        Function0 constructor2 = ComposeUiNode.Companion.getConstructor();
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -692256719, "CC(ReusableComposeNode)P(1,2)376@14062L9:Composables.kt#9igjgp");
                        if (!(composerStartRestartGroup.getApplier() instanceof Applier)) {
                            ComposablesKt.invalidApplier();
                        }
                        composerStartRestartGroup.startReusableNode();
                        if (composerStartRestartGroup.getInserting()) {
                            composerStartRestartGroup.createNode(constructor2);
                        } else {
                            composerStartRestartGroup.useNode();
                        }
                        Composer composer3 = Updater.constructor-impl(composerStartRestartGroup);
                        Updater.set-impl(composer3, measurePolicyColumnMeasurePolicy2, ComposeUiNode.Companion.getSetMeasurePolicy());
                        Updater.set-impl(composer3, currentCompositionLocalMap2, ComposeUiNode.Companion.getSetResolvedCompositionLocals());
                        Function2 setCompositeKeyHash2 = ComposeUiNode.Companion.getSetCompositeKeyHash();
                        if (composer3.getInserting() || !Intrinsics.areEqual(composer3.rememberedValue(), Integer.valueOf(currentCompositeKeyHash2))) {
                            composer3.updateRememberedValue(Integer.valueOf(currentCompositeKeyHash2));
                            composer3.apply(Integer.valueOf(currentCompositeKeyHash2), setCompositeKeyHash2);
                        }
                        Updater.set-impl(composer3, modifierMaterializeModifier2, ComposeUiNode.Companion.getSetModifier());
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -384784025, "C88@4444L9:Column.kt#2w3rfo");
                        ColumnScope columnScope2 = ColumnScopeInstance.INSTANCE;
                        m2151WaitTimeTextM3jwhU8(j, str, j4, composerStartRestartGroup, ((i3 >> 3) & 14) | ((i3 >> 6) & 896));
                        long j6 = Color.copy-wmQWz5c$default(j5, ResourceUtilsKt.floatResources(R.integer.zuia_wait_time_banner_subtitle_alpha, composerStartRestartGroup, 0), 0.0f, 0.0f, 0.0f, 14, (Object) null);
                        int i9 = TextAlign.Companion.getCenter-e0LSkKk();
                        Modifier modifierAlign = columnScope2.align(Modifier.Companion, Alignment.Companion.getCenterHorizontally());
                        composerStartRestartGroup.startReplaceGroup(-434979386);
                        boolean zChanged = composerStartRestartGroup.changed(strPluralStringResource);
                        Object objRememberedValue2 = composerStartRestartGroup.rememberedValue();
                        if (zChanged || objRememberedValue2 == Composer.Companion.getEmpty()) {
                            objRememberedValue2 = (Function1) new Function1<SemanticsPropertyReceiver, Unit>() {
                                {
                                    super(1);
                                }

                                @Override
                                public Unit invoke(SemanticsPropertyReceiver semanticsPropertyReceiver) {
                                    invoke2(semanticsPropertyReceiver);
                                    return Unit.INSTANCE;
                                }

                                public final void invoke2(SemanticsPropertyReceiver semantics) {
                                    Intrinsics.checkNotNullParameter(semantics, "$this$semantics");
                                    SemanticsPropertiesKt.setContentDescription(semantics, strPluralStringResource);
                                }
                            };
                            composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                        }
                        composerStartRestartGroup.endReplaceGroup();
                        TextKt.Text--4IGK_g(strPluralStringResource, SemanticsModifierKt.semantics$default(modifierAlign, false, (Function1) objRememberedValue2, 1, (Object) null), j6, 0L, (FontStyle) null, (FontWeight) null, (FontFamily) null, 0L, (TextDecoration) null, TextAlign.box-impl(i9), 0L, 0, false, 0, 0, (Function1) null, (TextStyle) null, composerStartRestartGroup, 0, 0, 130552);
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        composerStartRestartGroup.endNode();
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        composerStartRestartGroup.endReplaceGroup();
                    } else if (z2) {
                        composerStartRestartGroup.startReplaceGroup(-34540595);
                        m2151WaitTimeTextM3jwhU8(j, str, j4, composerStartRestartGroup, ((i3 >> 3) & 14) | ((i3 >> 6) & 896));
                        composerStartRestartGroup.endReplaceGroup();
                    } else if (shouldShowQueue) {
                        composerStartRestartGroup.startReplaceGroup(-34336057);
                        m2151WaitTimeTextM3jwhU8(j, strPluralStringResource, j5, composerStartRestartGroup, ((i3 >> 3) & 14) | ((i3 >> 9) & 896));
                        composerStartRestartGroup.endReplaceGroup();
                    } else {
                        composerStartRestartGroup.startReplaceGroup(-34164999);
                        composerStartRestartGroup.endReplaceGroup();
                    }
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    composerStartRestartGroup.endNode();
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                } else {
                    composerStartRestartGroup.skipToGroupEnd();
                    modifier3 = modifier2;
                }
                scopeUpdateScopeEndRestartGroup2 = composerStartRestartGroup.endRestartGroup();
                if (scopeUpdateScopeEndRestartGroup2 != null) {
                    scopeUpdateScopeEndRestartGroup2.updateScope(new Function2<Composer, Integer, Unit>() {
                        {
                            super(2);
                        }

                        @Override
                        public Unit invoke(Composer composer4, Integer num) {
                            invoke(composer4, num.intValue());
                            return Unit.INSTANCE;
                        }

                        public final void invoke(Composer composer4, int i10) {
                            WaitTimeBannerKt.m2150WaitTimeBannerfB7ZVRg(type, j, j2, j3, j4, j5, z, onFocusChange, modifier3, composer4, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                        }
                    });
                }
            }
            i5 = 12582912;
            i3 |= i5;
            i6 = i2 & 256;
            if (i6 != 0) {
                i3 |= 100663296;
                modifier2 = modifier;
            } else {
                modifier2 = modifier;
                if ((i & 234881024) == 0) {
                    if (composerStartRestartGroup.changed(modifier2)) {
                        i7 = 67108864;
                    } else {
                        i7 = 33554432;
                    }
                    i3 |= i7;
                }
            }
            if ((i3 & 191739611) == 38347922) {
                if (i6 != 0) {
                    modifier2 = (Modifier) Modifier.Companion;
                }
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(-1731051425, i3, -1, "zendesk.ui.android.conversation.waittimebanner.WaitTimeBanner (WaitTimeBanner.kt:72)");
                }
                shape = RoundedCornerShapeKt.RoundedCornerShape-0680j_4(PrimitiveResources_androidKt.dimensionResource(R.dimen.zuia_wait_time_banner_border_radius, composerStartRestartGroup, 0));
                if (type instanceof WaitTimeBannerType.Cleared) {
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
                    if (scopeUpdateScopeEndRestartGroup != null) {
                        final Modifier modifier7 = modifier2;
                        scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                            {
                                super(2);
                            }

                            @Override
                            public Unit invoke(Composer composer4, Integer num) {
                                invoke(composer4, num.intValue());
                                return Unit.INSTANCE;
                            }

                            public final void invoke(Composer composer4, int i10) {
                                WaitTimeBannerKt.m2150WaitTimeBannerfB7ZVRg(type, j, j2, j3, j4, j5, z, onFocusChange, modifier7, composer4, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                            }
                        });
                        return;
                    }
                    return;
                }
                Modifier modifier8 = modifier2;
                if (z) {
                    composerStartRestartGroup.startReplaceGroup(2081561351);
                    borderStroke = BorderStrokeKt.BorderStroke-cXLIe8U(PrimitiveResources_androidKt.dimensionResource(R.dimen.zuia_border_width, composerStartRestartGroup, 0), j3);
                    composerStartRestartGroup.endReplaceGroup();
                } else {
                    composerStartRestartGroup.startReplaceGroup(2081714150);
                    borderStroke = BorderStrokeKt.BorderStroke-cXLIe8U(PrimitiveResources_androidKt.dimensionResource(R.dimen.zuia_divider_size, composerStartRestartGroup, 0), Color.copy-wmQWz5c$default(j2, ResourceUtilsKt.floatResources(R.dimen.zuia_wait_time_banner_border_alpha, composerStartRestartGroup, 0), 0.0f, 0.0f, 0.0f, 14, (Object) null));
                    composerStartRestartGroup.endReplaceGroup();
                }
                if (type instanceof WaitTimeBannerType.Queued) {
                    composerStartRestartGroup.startReplaceGroup(2082150506);
                    WaitTimeBannerType.Queued queued2 = (WaitTimeBannerType.Queued) type;
                    boolean shouldShowResponseTime2 = queued2.getShouldShowResponseTime();
                    String strQueuedBannerText2 = queuedBannerText(queued2.getResponseTime().getLower(), queued2.getResponseTime().getUpper(), composerStartRestartGroup, 0);
                    shouldShowQueue = queued2.getShouldShowQueue();
                    z2 = shouldShowResponseTime2;
                    i8 = 0;
                    strPluralStringResource = StringResources_androidKt.pluralStringResource(R.plurals.bannerQueue, queued2.getQueuePosition(), new Object[]{Integer.valueOf(queued2.getQueuePosition())}, composerStartRestartGroup, 512);
                    composerStartRestartGroup.endReplaceGroup();
                    str = strQueuedBannerText2;
                } else {
                    i8 = 0;
                    composerStartRestartGroup.startReplaceGroup(2082609027);
                    String strStringResource3 = StringResources_androidKt.stringResource(R.string.zuia_static_wait_time_banner_will_be_shortly, composerStartRestartGroup, 0);
                    String strStringResource4 = StringResources_androidKt.stringResource(R.string.zuia_static_wait_time_banner_you_are_up_next, composerStartRestartGroup, 0);
                    composerStartRestartGroup.endReplaceGroup();
                    str = strStringResource3;
                    strPluralStringResource = strStringResource4;
                    shouldShowQueue = true;
                    z2 = true;
                }
                Alignment.Horizontal centerHorizontally2 = Alignment.Companion.getCenterHorizontally();
                modifier3 = modifier8;
                Modifier modifierFillMaxWidth$default2 = SizeKt.fillMaxWidth$default(PaddingKt.padding-VpY3zN4$default(SizeKt.defaultMinSize-VpY3zN4$default(modifier3, 0.0f, PrimitiveResources_androidKt.dimensionResource(R.dimen.zuia_wait_time_banner_min_height, composerStartRestartGroup, i8), 1, (Object) null), PrimitiveResources_androidKt.dimensionResource(R.dimen.zuia_spacing_medium, composerStartRestartGroup, 0), 0.0f, 2, (Object) null), 0.0f, 1, (Object) null);
                composerStartRestartGroup.startReplaceGroup(-1318272805);
                if ((i3 & 29360128) == 8388608) {
                    z3 = true;
                } else {
                    z3 = false;
                }
                objRememberedValue = composerStartRestartGroup.rememberedValue();
                if (!z3) {
                    objRememberedValue = (Function1) new Function1<FocusState, Unit>() {
                        {
                            super(1);
                        }

                        @Override
                        public Unit invoke(FocusState focusState) {
                            invoke2(focusState);
                            return Unit.INSTANCE;
                        }

                        public final void invoke2(FocusState focusState) {
                            Intrinsics.checkNotNullParameter(focusState, "focusState");
                            onFocusChange.invoke(Boolean.valueOf(focusState.isFocused()));
                        }
                    };
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                } else {
                    objRememberedValue = (Function1) new Function1<FocusState, Unit>() {
                        {
                            super(1);
                        }

                        @Override
                        public Unit invoke(FocusState focusState) {
                            invoke2(focusState);
                            return Unit.INSTANCE;
                        }

                        public final void invoke2(FocusState focusState) {
                            Intrinsics.checkNotNullParameter(focusState, "focusState");
                            onFocusChange.invoke(Boolean.valueOf(focusState.isFocused()));
                        }
                    };
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                }
                composerStartRestartGroup.endReplaceGroup();
                Shape shape3 = shape;
                Modifier modifierTestTag2 = TestTagKt.testTag(SemanticsModifierKt.semantics(PaddingKt.padding-3ABfNKs(ClipKt.clip(BorderKt.border(FocusableKt.focusable$default(FocusChangedModifierKt.onFocusChanged(modifierFillMaxWidth$default2, (Function1) objRememberedValue), false, (MutableInteractionSource) null, 3, (Object) null), borderStroke, shape3), shape3), PrimitiveResources_androidKt.dimensionResource(R.dimen.zuia_spacing_medium, composerStartRestartGroup, 0)), true, new Function1<SemanticsPropertyReceiver, Unit>() {
                    @Override
                    public Unit invoke(SemanticsPropertyReceiver semanticsPropertyReceiver) {
                        invoke2(semanticsPropertyReceiver);
                        return Unit.INSTANCE;
                    }

                    public final void invoke2(SemanticsPropertyReceiver semantics) {
                        Intrinsics.checkNotNullParameter(semantics, "$this$semantics");
                        SemanticsPropertiesKt.setLiveRegion-hR3wRGc(semantics, LiveRegionMode.Companion.getAssertive-0phEisY());
                    }
                }), ZUIWaitTimeBannerTag);
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -483455358, "CC(Column)P(2,3,1)86@4330L61,87@4396L133:Column.kt#2w3rfo");
                MeasurePolicy measurePolicyColumnMeasurePolicy3 = ColumnKt.columnMeasurePolicy(Arrangement.INSTANCE.getTop(), centerHorizontally2, composerStartRestartGroup, 48);
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1323940314, "CC(Layout)P(!1,2)79@3208L23,82@3359L411:Layout.kt#80mrfh");
                currentCompositeKeyHash = ComposablesKt.getCurrentCompositeKeyHash(composerStartRestartGroup, 0);
                CompositionLocalMap currentCompositionLocalMap3 = composerStartRestartGroup.getCurrentCompositionLocalMap();
                Modifier modifierMaterializeModifier3 = ComposedModifierKt.materializeModifier(composerStartRestartGroup, modifierTestTag2);
                constructor = ComposeUiNode.Companion.getConstructor();
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -692256719, "CC(ReusableComposeNode)P(1,2)376@14062L9:Composables.kt#9igjgp");
                if (!(composerStartRestartGroup.getApplier() instanceof Applier)) {
                    ComposablesKt.invalidApplier();
                }
                composerStartRestartGroup.startReusableNode();
                if (composerStartRestartGroup.getInserting()) {
                    composerStartRestartGroup.createNode(constructor);
                } else {
                    composerStartRestartGroup.useNode();
                }
                composer2 = Updater.constructor-impl(composerStartRestartGroup);
                Updater.set-impl(composer2, measurePolicyColumnMeasurePolicy3, ComposeUiNode.Companion.getSetMeasurePolicy());
                Updater.set-impl(composer2, currentCompositionLocalMap3, ComposeUiNode.Companion.getSetResolvedCompositionLocals());
                setCompositeKeyHash = ComposeUiNode.Companion.getSetCompositeKeyHash();
                if (!composer2.getInserting()) {
                    composer2.updateRememberedValue(Integer.valueOf(currentCompositeKeyHash));
                    composer2.apply(Integer.valueOf(currentCompositeKeyHash), setCompositeKeyHash);
                } else {
                    composer2.updateRememberedValue(Integer.valueOf(currentCompositeKeyHash));
                    composer2.apply(Integer.valueOf(currentCompositeKeyHash), setCompositeKeyHash);
                }
                Updater.set-impl(composer2, modifierMaterializeModifier3, ComposeUiNode.Companion.getSetModifier());
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -384784025, "C88@4444L9:Column.kt#2w3rfo");
                ColumnScope columnScope3 = ColumnScopeInstance.INSTANCE;
                if (!z2) {
                    if (z2) {
                        composerStartRestartGroup.startReplaceGroup(-34540595);
                        m2151WaitTimeTextM3jwhU8(j, str, j4, composerStartRestartGroup, ((i3 >> 3) & 14) | ((i3 >> 6) & 896));
                        composerStartRestartGroup.endReplaceGroup();
                    } else if (shouldShowQueue) {
                        composerStartRestartGroup.startReplaceGroup(-34336057);
                        m2151WaitTimeTextM3jwhU8(j, strPluralStringResource, j5, composerStartRestartGroup, ((i3 >> 3) & 14) | ((i3 >> 9) & 896));
                        composerStartRestartGroup.endReplaceGroup();
                    } else {
                        composerStartRestartGroup.startReplaceGroup(-34164999);
                        composerStartRestartGroup.endReplaceGroup();
                    }
                } else if (z2) {
                    composerStartRestartGroup.startReplaceGroup(-34540595);
                    m2151WaitTimeTextM3jwhU8(j, str, j4, composerStartRestartGroup, ((i3 >> 3) & 14) | ((i3 >> 6) & 896));
                    composerStartRestartGroup.endReplaceGroup();
                } else if (shouldShowQueue) {
                    composerStartRestartGroup.startReplaceGroup(-34336057);
                    m2151WaitTimeTextM3jwhU8(j, strPluralStringResource, j5, composerStartRestartGroup, ((i3 >> 3) & 14) | ((i3 >> 9) & 896));
                    composerStartRestartGroup.endReplaceGroup();
                } else {
                    composerStartRestartGroup.startReplaceGroup(-34164999);
                    composerStartRestartGroup.endReplaceGroup();
                }
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                composerStartRestartGroup.endNode();
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
            } else {
                if (i6 != 0) {
                    modifier2 = (Modifier) Modifier.Companion;
                }
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(-1731051425, i3, -1, "zendesk.ui.android.conversation.waittimebanner.WaitTimeBanner (WaitTimeBanner.kt:72)");
                }
                shape = RoundedCornerShapeKt.RoundedCornerShape-0680j_4(PrimitiveResources_androidKt.dimensionResource(R.dimen.zuia_wait_time_banner_border_radius, composerStartRestartGroup, 0));
                if (type instanceof WaitTimeBannerType.Cleared) {
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
                    if (scopeUpdateScopeEndRestartGroup != null) {
                        final Modifier modifier9 = modifier2;
                        scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                            {
                                super(2);
                            }

                            @Override
                            public Unit invoke(Composer composer4, Integer num) {
                                invoke(composer4, num.intValue());
                                return Unit.INSTANCE;
                            }

                            public final void invoke(Composer composer4, int i10) {
                                WaitTimeBannerKt.m2150WaitTimeBannerfB7ZVRg(type, j, j2, j3, j4, j5, z, onFocusChange, modifier9, composer4, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                            }
                        });
                        return;
                    }
                    return;
                }
                Modifier modifier10 = modifier2;
                if (z) {
                    composerStartRestartGroup.startReplaceGroup(2081561351);
                    borderStroke = BorderStrokeKt.BorderStroke-cXLIe8U(PrimitiveResources_androidKt.dimensionResource(R.dimen.zuia_border_width, composerStartRestartGroup, 0), j3);
                    composerStartRestartGroup.endReplaceGroup();
                } else {
                    composerStartRestartGroup.startReplaceGroup(2081714150);
                    borderStroke = BorderStrokeKt.BorderStroke-cXLIe8U(PrimitiveResources_androidKt.dimensionResource(R.dimen.zuia_divider_size, composerStartRestartGroup, 0), Color.copy-wmQWz5c$default(j2, ResourceUtilsKt.floatResources(R.dimen.zuia_wait_time_banner_border_alpha, composerStartRestartGroup, 0), 0.0f, 0.0f, 0.0f, 14, (Object) null));
                    composerStartRestartGroup.endReplaceGroup();
                }
                if (type instanceof WaitTimeBannerType.Queued) {
                    composerStartRestartGroup.startReplaceGroup(2082150506);
                    WaitTimeBannerType.Queued queued3 = (WaitTimeBannerType.Queued) type;
                    boolean shouldShowResponseTime3 = queued3.getShouldShowResponseTime();
                    String strQueuedBannerText3 = queuedBannerText(queued3.getResponseTime().getLower(), queued3.getResponseTime().getUpper(), composerStartRestartGroup, 0);
                    shouldShowQueue = queued3.getShouldShowQueue();
                    z2 = shouldShowResponseTime3;
                    i8 = 0;
                    strPluralStringResource = StringResources_androidKt.pluralStringResource(R.plurals.bannerQueue, queued3.getQueuePosition(), new Object[]{Integer.valueOf(queued3.getQueuePosition())}, composerStartRestartGroup, 512);
                    composerStartRestartGroup.endReplaceGroup();
                    str = strQueuedBannerText3;
                } else {
                    i8 = 0;
                    composerStartRestartGroup.startReplaceGroup(2082609027);
                    String strStringResource5 = StringResources_androidKt.stringResource(R.string.zuia_static_wait_time_banner_will_be_shortly, composerStartRestartGroup, 0);
                    String strStringResource6 = StringResources_androidKt.stringResource(R.string.zuia_static_wait_time_banner_you_are_up_next, composerStartRestartGroup, 0);
                    composerStartRestartGroup.endReplaceGroup();
                    str = strStringResource5;
                    strPluralStringResource = strStringResource6;
                    shouldShowQueue = true;
                    z2 = true;
                }
                Alignment.Horizontal centerHorizontally3 = Alignment.Companion.getCenterHorizontally();
                modifier3 = modifier10;
                Modifier modifierFillMaxWidth$default3 = SizeKt.fillMaxWidth$default(PaddingKt.padding-VpY3zN4$default(SizeKt.defaultMinSize-VpY3zN4$default(modifier3, 0.0f, PrimitiveResources_androidKt.dimensionResource(R.dimen.zuia_wait_time_banner_min_height, composerStartRestartGroup, i8), 1, (Object) null), PrimitiveResources_androidKt.dimensionResource(R.dimen.zuia_spacing_medium, composerStartRestartGroup, 0), 0.0f, 2, (Object) null), 0.0f, 1, (Object) null);
                composerStartRestartGroup.startReplaceGroup(-1318272805);
                if ((i3 & 29360128) == 8388608) {
                    z3 = true;
                } else {
                    z3 = false;
                }
                objRememberedValue = composerStartRestartGroup.rememberedValue();
                if (!z3) {
                    objRememberedValue = (Function1) new Function1<FocusState, Unit>() {
                        {
                            super(1);
                        }

                        @Override
                        public Unit invoke(FocusState focusState) {
                            invoke2(focusState);
                            return Unit.INSTANCE;
                        }

                        public final void invoke2(FocusState focusState) {
                            Intrinsics.checkNotNullParameter(focusState, "focusState");
                            onFocusChange.invoke(Boolean.valueOf(focusState.isFocused()));
                        }
                    };
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                } else {
                    objRememberedValue = (Function1) new Function1<FocusState, Unit>() {
                        {
                            super(1);
                        }

                        @Override
                        public Unit invoke(FocusState focusState) {
                            invoke2(focusState);
                            return Unit.INSTANCE;
                        }

                        public final void invoke2(FocusState focusState) {
                            Intrinsics.checkNotNullParameter(focusState, "focusState");
                            onFocusChange.invoke(Boolean.valueOf(focusState.isFocused()));
                        }
                    };
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                }
                composerStartRestartGroup.endReplaceGroup();
                Shape shape4 = shape;
                Modifier modifierTestTag3 = TestTagKt.testTag(SemanticsModifierKt.semantics(PaddingKt.padding-3ABfNKs(ClipKt.clip(BorderKt.border(FocusableKt.focusable$default(FocusChangedModifierKt.onFocusChanged(modifierFillMaxWidth$default3, (Function1) objRememberedValue), false, (MutableInteractionSource) null, 3, (Object) null), borderStroke, shape4), shape4), PrimitiveResources_androidKt.dimensionResource(R.dimen.zuia_spacing_medium, composerStartRestartGroup, 0)), true, new Function1<SemanticsPropertyReceiver, Unit>() {
                    @Override
                    public Unit invoke(SemanticsPropertyReceiver semanticsPropertyReceiver) {
                        invoke2(semanticsPropertyReceiver);
                        return Unit.INSTANCE;
                    }

                    public final void invoke2(SemanticsPropertyReceiver semantics) {
                        Intrinsics.checkNotNullParameter(semantics, "$this$semantics");
                        SemanticsPropertiesKt.setLiveRegion-hR3wRGc(semantics, LiveRegionMode.Companion.getAssertive-0phEisY());
                    }
                }), ZUIWaitTimeBannerTag);
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -483455358, "CC(Column)P(2,3,1)86@4330L61,87@4396L133:Column.kt#2w3rfo");
                MeasurePolicy measurePolicyColumnMeasurePolicy4 = ColumnKt.columnMeasurePolicy(Arrangement.INSTANCE.getTop(), centerHorizontally3, composerStartRestartGroup, 48);
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1323940314, "CC(Layout)P(!1,2)79@3208L23,82@3359L411:Layout.kt#80mrfh");
                currentCompositeKeyHash = ComposablesKt.getCurrentCompositeKeyHash(composerStartRestartGroup, 0);
                CompositionLocalMap currentCompositionLocalMap4 = composerStartRestartGroup.getCurrentCompositionLocalMap();
                Modifier modifierMaterializeModifier4 = ComposedModifierKt.materializeModifier(composerStartRestartGroup, modifierTestTag3);
                constructor = ComposeUiNode.Companion.getConstructor();
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -692256719, "CC(ReusableComposeNode)P(1,2)376@14062L9:Composables.kt#9igjgp");
                if (!(composerStartRestartGroup.getApplier() instanceof Applier)) {
                    ComposablesKt.invalidApplier();
                }
                composerStartRestartGroup.startReusableNode();
                if (composerStartRestartGroup.getInserting()) {
                    composerStartRestartGroup.createNode(constructor);
                } else {
                    composerStartRestartGroup.useNode();
                }
                composer2 = Updater.constructor-impl(composerStartRestartGroup);
                Updater.set-impl(composer2, measurePolicyColumnMeasurePolicy4, ComposeUiNode.Companion.getSetMeasurePolicy());
                Updater.set-impl(composer2, currentCompositionLocalMap4, ComposeUiNode.Companion.getSetResolvedCompositionLocals());
                setCompositeKeyHash = ComposeUiNode.Companion.getSetCompositeKeyHash();
                if (!composer2.getInserting()) {
                    composer2.updateRememberedValue(Integer.valueOf(currentCompositeKeyHash));
                    composer2.apply(Integer.valueOf(currentCompositeKeyHash), setCompositeKeyHash);
                } else {
                    composer2.updateRememberedValue(Integer.valueOf(currentCompositeKeyHash));
                    composer2.apply(Integer.valueOf(currentCompositeKeyHash), setCompositeKeyHash);
                }
                Updater.set-impl(composer2, modifierMaterializeModifier4, ComposeUiNode.Companion.getSetModifier());
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -384784025, "C88@4444L9:Column.kt#2w3rfo");
                ColumnScope columnScope4 = ColumnScopeInstance.INSTANCE;
                if (!z2) {
                    if (z2) {
                        composerStartRestartGroup.startReplaceGroup(-34540595);
                        m2151WaitTimeTextM3jwhU8(j, str, j4, composerStartRestartGroup, ((i3 >> 3) & 14) | ((i3 >> 6) & 896));
                        composerStartRestartGroup.endReplaceGroup();
                    } else if (shouldShowQueue) {
                        composerStartRestartGroup.startReplaceGroup(-34336057);
                        m2151WaitTimeTextM3jwhU8(j, strPluralStringResource, j5, composerStartRestartGroup, ((i3 >> 3) & 14) | ((i3 >> 9) & 896));
                        composerStartRestartGroup.endReplaceGroup();
                    } else {
                        composerStartRestartGroup.startReplaceGroup(-34164999);
                        composerStartRestartGroup.endReplaceGroup();
                    }
                } else if (z2) {
                    composerStartRestartGroup.startReplaceGroup(-34540595);
                    m2151WaitTimeTextM3jwhU8(j, str, j4, composerStartRestartGroup, ((i3 >> 3) & 14) | ((i3 >> 6) & 896));
                    composerStartRestartGroup.endReplaceGroup();
                } else if (shouldShowQueue) {
                    composerStartRestartGroup.startReplaceGroup(-34336057);
                    m2151WaitTimeTextM3jwhU8(j, strPluralStringResource, j5, composerStartRestartGroup, ((i3 >> 3) & 14) | ((i3 >> 9) & 896));
                    composerStartRestartGroup.endReplaceGroup();
                } else {
                    composerStartRestartGroup.startReplaceGroup(-34164999);
                    composerStartRestartGroup.endReplaceGroup();
                }
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                composerStartRestartGroup.endNode();
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
            }
            scopeUpdateScopeEndRestartGroup2 = composerStartRestartGroup.endRestartGroup();
            if (scopeUpdateScopeEndRestartGroup2 != null) {
                scopeUpdateScopeEndRestartGroup2.updateScope(new Function2<Composer, Integer, Unit>() {
                    {
                        super(2);
                    }

                    @Override
                    public Unit invoke(Composer composer4, Integer num) {
                        invoke(composer4, num.intValue());
                        return Unit.INSTANCE;
                    }

                    public final void invoke(Composer composer4, int i10) {
                        WaitTimeBannerKt.m2150WaitTimeBannerfB7ZVRg(type, j, j2, j3, j4, j5, z, onFocusChange, modifier3, composer4, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                    }
                });
            }
        }
        i4 = 1572864;
        i3 |= i4;
        if ((i2 & 128) != 0) {
            if ((i & 29360128) == 0) {
                if (composerStartRestartGroup.changedInstance(onFocusChange)) {
                    i5 = 8388608;
                } else {
                    i5 = 4194304;
                }
            }
            i6 = i2 & 256;
            if (i6 != 0) {
                i3 |= 100663296;
                modifier2 = modifier;
            } else {
                modifier2 = modifier;
                if ((i & 234881024) == 0) {
                    if (composerStartRestartGroup.changed(modifier2)) {
                        i7 = 67108864;
                    } else {
                        i7 = 33554432;
                    }
                    i3 |= i7;
                }
            }
            if ((i3 & 191739611) == 38347922) {
                if (i6 != 0) {
                    modifier2 = (Modifier) Modifier.Companion;
                }
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(-1731051425, i3, -1, "zendesk.ui.android.conversation.waittimebanner.WaitTimeBanner (WaitTimeBanner.kt:72)");
                }
                shape = RoundedCornerShapeKt.RoundedCornerShape-0680j_4(PrimitiveResources_androidKt.dimensionResource(R.dimen.zuia_wait_time_banner_border_radius, composerStartRestartGroup, 0));
                if (type instanceof WaitTimeBannerType.Cleared) {
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
                    if (scopeUpdateScopeEndRestartGroup != null) {
                        final Modifier modifier11 = modifier2;
                        scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                            {
                                super(2);
                            }

                            @Override
                            public Unit invoke(Composer composer4, Integer num) {
                                invoke(composer4, num.intValue());
                                return Unit.INSTANCE;
                            }

                            public final void invoke(Composer composer4, int i10) {
                                WaitTimeBannerKt.m2150WaitTimeBannerfB7ZVRg(type, j, j2, j3, j4, j5, z, onFocusChange, modifier11, composer4, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                            }
                        });
                        return;
                    }
                    return;
                }
                Modifier modifier12 = modifier2;
                if (z) {
                    composerStartRestartGroup.startReplaceGroup(2081561351);
                    borderStroke = BorderStrokeKt.BorderStroke-cXLIe8U(PrimitiveResources_androidKt.dimensionResource(R.dimen.zuia_border_width, composerStartRestartGroup, 0), j3);
                    composerStartRestartGroup.endReplaceGroup();
                } else {
                    composerStartRestartGroup.startReplaceGroup(2081714150);
                    borderStroke = BorderStrokeKt.BorderStroke-cXLIe8U(PrimitiveResources_androidKt.dimensionResource(R.dimen.zuia_divider_size, composerStartRestartGroup, 0), Color.copy-wmQWz5c$default(j2, ResourceUtilsKt.floatResources(R.dimen.zuia_wait_time_banner_border_alpha, composerStartRestartGroup, 0), 0.0f, 0.0f, 0.0f, 14, (Object) null));
                    composerStartRestartGroup.endReplaceGroup();
                }
                if (type instanceof WaitTimeBannerType.Queued) {
                    composerStartRestartGroup.startReplaceGroup(2082150506);
                    WaitTimeBannerType.Queued queued4 = (WaitTimeBannerType.Queued) type;
                    boolean shouldShowResponseTime4 = queued4.getShouldShowResponseTime();
                    String strQueuedBannerText4 = queuedBannerText(queued4.getResponseTime().getLower(), queued4.getResponseTime().getUpper(), composerStartRestartGroup, 0);
                    shouldShowQueue = queued4.getShouldShowQueue();
                    z2 = shouldShowResponseTime4;
                    i8 = 0;
                    strPluralStringResource = StringResources_androidKt.pluralStringResource(R.plurals.bannerQueue, queued4.getQueuePosition(), new Object[]{Integer.valueOf(queued4.getQueuePosition())}, composerStartRestartGroup, 512);
                    composerStartRestartGroup.endReplaceGroup();
                    str = strQueuedBannerText4;
                } else {
                    i8 = 0;
                    composerStartRestartGroup.startReplaceGroup(2082609027);
                    String strStringResource7 = StringResources_androidKt.stringResource(R.string.zuia_static_wait_time_banner_will_be_shortly, composerStartRestartGroup, 0);
                    String strStringResource8 = StringResources_androidKt.stringResource(R.string.zuia_static_wait_time_banner_you_are_up_next, composerStartRestartGroup, 0);
                    composerStartRestartGroup.endReplaceGroup();
                    str = strStringResource7;
                    strPluralStringResource = strStringResource8;
                    shouldShowQueue = true;
                    z2 = true;
                }
                Alignment.Horizontal centerHorizontally4 = Alignment.Companion.getCenterHorizontally();
                modifier3 = modifier12;
                Modifier modifierFillMaxWidth$default4 = SizeKt.fillMaxWidth$default(PaddingKt.padding-VpY3zN4$default(SizeKt.defaultMinSize-VpY3zN4$default(modifier3, 0.0f, PrimitiveResources_androidKt.dimensionResource(R.dimen.zuia_wait_time_banner_min_height, composerStartRestartGroup, i8), 1, (Object) null), PrimitiveResources_androidKt.dimensionResource(R.dimen.zuia_spacing_medium, composerStartRestartGroup, 0), 0.0f, 2, (Object) null), 0.0f, 1, (Object) null);
                composerStartRestartGroup.startReplaceGroup(-1318272805);
                if ((i3 & 29360128) == 8388608) {
                    z3 = true;
                } else {
                    z3 = false;
                }
                objRememberedValue = composerStartRestartGroup.rememberedValue();
                if (!z3) {
                    objRememberedValue = (Function1) new Function1<FocusState, Unit>() {
                        {
                            super(1);
                        }

                        @Override
                        public Unit invoke(FocusState focusState) {
                            invoke2(focusState);
                            return Unit.INSTANCE;
                        }

                        public final void invoke2(FocusState focusState) {
                            Intrinsics.checkNotNullParameter(focusState, "focusState");
                            onFocusChange.invoke(Boolean.valueOf(focusState.isFocused()));
                        }
                    };
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                } else {
                    objRememberedValue = (Function1) new Function1<FocusState, Unit>() {
                        {
                            super(1);
                        }

                        @Override
                        public Unit invoke(FocusState focusState) {
                            invoke2(focusState);
                            return Unit.INSTANCE;
                        }

                        public final void invoke2(FocusState focusState) {
                            Intrinsics.checkNotNullParameter(focusState, "focusState");
                            onFocusChange.invoke(Boolean.valueOf(focusState.isFocused()));
                        }
                    };
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                }
                composerStartRestartGroup.endReplaceGroup();
                Shape shape5 = shape;
                Modifier modifierTestTag4 = TestTagKt.testTag(SemanticsModifierKt.semantics(PaddingKt.padding-3ABfNKs(ClipKt.clip(BorderKt.border(FocusableKt.focusable$default(FocusChangedModifierKt.onFocusChanged(modifierFillMaxWidth$default4, (Function1) objRememberedValue), false, (MutableInteractionSource) null, 3, (Object) null), borderStroke, shape5), shape5), PrimitiveResources_androidKt.dimensionResource(R.dimen.zuia_spacing_medium, composerStartRestartGroup, 0)), true, new Function1<SemanticsPropertyReceiver, Unit>() {
                    @Override
                    public Unit invoke(SemanticsPropertyReceiver semanticsPropertyReceiver) {
                        invoke2(semanticsPropertyReceiver);
                        return Unit.INSTANCE;
                    }

                    public final void invoke2(SemanticsPropertyReceiver semantics) {
                        Intrinsics.checkNotNullParameter(semantics, "$this$semantics");
                        SemanticsPropertiesKt.setLiveRegion-hR3wRGc(semantics, LiveRegionMode.Companion.getAssertive-0phEisY());
                    }
                }), ZUIWaitTimeBannerTag);
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -483455358, "CC(Column)P(2,3,1)86@4330L61,87@4396L133:Column.kt#2w3rfo");
                MeasurePolicy measurePolicyColumnMeasurePolicy5 = ColumnKt.columnMeasurePolicy(Arrangement.INSTANCE.getTop(), centerHorizontally4, composerStartRestartGroup, 48);
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1323940314, "CC(Layout)P(!1,2)79@3208L23,82@3359L411:Layout.kt#80mrfh");
                currentCompositeKeyHash = ComposablesKt.getCurrentCompositeKeyHash(composerStartRestartGroup, 0);
                CompositionLocalMap currentCompositionLocalMap5 = composerStartRestartGroup.getCurrentCompositionLocalMap();
                Modifier modifierMaterializeModifier5 = ComposedModifierKt.materializeModifier(composerStartRestartGroup, modifierTestTag4);
                constructor = ComposeUiNode.Companion.getConstructor();
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -692256719, "CC(ReusableComposeNode)P(1,2)376@14062L9:Composables.kt#9igjgp");
                if (!(composerStartRestartGroup.getApplier() instanceof Applier)) {
                    ComposablesKt.invalidApplier();
                }
                composerStartRestartGroup.startReusableNode();
                if (composerStartRestartGroup.getInserting()) {
                    composerStartRestartGroup.createNode(constructor);
                } else {
                    composerStartRestartGroup.useNode();
                }
                composer2 = Updater.constructor-impl(composerStartRestartGroup);
                Updater.set-impl(composer2, measurePolicyColumnMeasurePolicy5, ComposeUiNode.Companion.getSetMeasurePolicy());
                Updater.set-impl(composer2, currentCompositionLocalMap5, ComposeUiNode.Companion.getSetResolvedCompositionLocals());
                setCompositeKeyHash = ComposeUiNode.Companion.getSetCompositeKeyHash();
                if (!composer2.getInserting()) {
                    composer2.updateRememberedValue(Integer.valueOf(currentCompositeKeyHash));
                    composer2.apply(Integer.valueOf(currentCompositeKeyHash), setCompositeKeyHash);
                } else {
                    composer2.updateRememberedValue(Integer.valueOf(currentCompositeKeyHash));
                    composer2.apply(Integer.valueOf(currentCompositeKeyHash), setCompositeKeyHash);
                }
                Updater.set-impl(composer2, modifierMaterializeModifier5, ComposeUiNode.Companion.getSetModifier());
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -384784025, "C88@4444L9:Column.kt#2w3rfo");
                ColumnScope columnScope5 = ColumnScopeInstance.INSTANCE;
                if (!z2) {
                    if (z2) {
                        composerStartRestartGroup.startReplaceGroup(-34540595);
                        m2151WaitTimeTextM3jwhU8(j, str, j4, composerStartRestartGroup, ((i3 >> 3) & 14) | ((i3 >> 6) & 896));
                        composerStartRestartGroup.endReplaceGroup();
                    } else if (shouldShowQueue) {
                        composerStartRestartGroup.startReplaceGroup(-34336057);
                        m2151WaitTimeTextM3jwhU8(j, strPluralStringResource, j5, composerStartRestartGroup, ((i3 >> 3) & 14) | ((i3 >> 9) & 896));
                        composerStartRestartGroup.endReplaceGroup();
                    } else {
                        composerStartRestartGroup.startReplaceGroup(-34164999);
                        composerStartRestartGroup.endReplaceGroup();
                    }
                } else if (z2) {
                    composerStartRestartGroup.startReplaceGroup(-34540595);
                    m2151WaitTimeTextM3jwhU8(j, str, j4, composerStartRestartGroup, ((i3 >> 3) & 14) | ((i3 >> 6) & 896));
                    composerStartRestartGroup.endReplaceGroup();
                } else if (shouldShowQueue) {
                    composerStartRestartGroup.startReplaceGroup(-34336057);
                    m2151WaitTimeTextM3jwhU8(j, strPluralStringResource, j5, composerStartRestartGroup, ((i3 >> 3) & 14) | ((i3 >> 9) & 896));
                    composerStartRestartGroup.endReplaceGroup();
                } else {
                    composerStartRestartGroup.startReplaceGroup(-34164999);
                    composerStartRestartGroup.endReplaceGroup();
                }
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                composerStartRestartGroup.endNode();
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
            } else {
                if (i6 != 0) {
                    modifier2 = (Modifier) Modifier.Companion;
                }
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(-1731051425, i3, -1, "zendesk.ui.android.conversation.waittimebanner.WaitTimeBanner (WaitTimeBanner.kt:72)");
                }
                shape = RoundedCornerShapeKt.RoundedCornerShape-0680j_4(PrimitiveResources_androidKt.dimensionResource(R.dimen.zuia_wait_time_banner_border_radius, composerStartRestartGroup, 0));
                if (type instanceof WaitTimeBannerType.Cleared) {
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
                    if (scopeUpdateScopeEndRestartGroup != null) {
                        final Modifier modifier13 = modifier2;
                        scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                            {
                                super(2);
                            }

                            @Override
                            public Unit invoke(Composer composer4, Integer num) {
                                invoke(composer4, num.intValue());
                                return Unit.INSTANCE;
                            }

                            public final void invoke(Composer composer4, int i10) {
                                WaitTimeBannerKt.m2150WaitTimeBannerfB7ZVRg(type, j, j2, j3, j4, j5, z, onFocusChange, modifier13, composer4, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                            }
                        });
                        return;
                    }
                    return;
                }
                Modifier modifier14 = modifier2;
                if (z) {
                    composerStartRestartGroup.startReplaceGroup(2081561351);
                    borderStroke = BorderStrokeKt.BorderStroke-cXLIe8U(PrimitiveResources_androidKt.dimensionResource(R.dimen.zuia_border_width, composerStartRestartGroup, 0), j3);
                    composerStartRestartGroup.endReplaceGroup();
                } else {
                    composerStartRestartGroup.startReplaceGroup(2081714150);
                    borderStroke = BorderStrokeKt.BorderStroke-cXLIe8U(PrimitiveResources_androidKt.dimensionResource(R.dimen.zuia_divider_size, composerStartRestartGroup, 0), Color.copy-wmQWz5c$default(j2, ResourceUtilsKt.floatResources(R.dimen.zuia_wait_time_banner_border_alpha, composerStartRestartGroup, 0), 0.0f, 0.0f, 0.0f, 14, (Object) null));
                    composerStartRestartGroup.endReplaceGroup();
                }
                if (type instanceof WaitTimeBannerType.Queued) {
                    composerStartRestartGroup.startReplaceGroup(2082150506);
                    WaitTimeBannerType.Queued queued5 = (WaitTimeBannerType.Queued) type;
                    boolean shouldShowResponseTime5 = queued5.getShouldShowResponseTime();
                    String strQueuedBannerText5 = queuedBannerText(queued5.getResponseTime().getLower(), queued5.getResponseTime().getUpper(), composerStartRestartGroup, 0);
                    shouldShowQueue = queued5.getShouldShowQueue();
                    z2 = shouldShowResponseTime5;
                    i8 = 0;
                    strPluralStringResource = StringResources_androidKt.pluralStringResource(R.plurals.bannerQueue, queued5.getQueuePosition(), new Object[]{Integer.valueOf(queued5.getQueuePosition())}, composerStartRestartGroup, 512);
                    composerStartRestartGroup.endReplaceGroup();
                    str = strQueuedBannerText5;
                } else {
                    i8 = 0;
                    composerStartRestartGroup.startReplaceGroup(2082609027);
                    String strStringResource9 = StringResources_androidKt.stringResource(R.string.zuia_static_wait_time_banner_will_be_shortly, composerStartRestartGroup, 0);
                    String strStringResource10 = StringResources_androidKt.stringResource(R.string.zuia_static_wait_time_banner_you_are_up_next, composerStartRestartGroup, 0);
                    composerStartRestartGroup.endReplaceGroup();
                    str = strStringResource9;
                    strPluralStringResource = strStringResource10;
                    shouldShowQueue = true;
                    z2 = true;
                }
                Alignment.Horizontal centerHorizontally5 = Alignment.Companion.getCenterHorizontally();
                modifier3 = modifier14;
                Modifier modifierFillMaxWidth$default5 = SizeKt.fillMaxWidth$default(PaddingKt.padding-VpY3zN4$default(SizeKt.defaultMinSize-VpY3zN4$default(modifier3, 0.0f, PrimitiveResources_androidKt.dimensionResource(R.dimen.zuia_wait_time_banner_min_height, composerStartRestartGroup, i8), 1, (Object) null), PrimitiveResources_androidKt.dimensionResource(R.dimen.zuia_spacing_medium, composerStartRestartGroup, 0), 0.0f, 2, (Object) null), 0.0f, 1, (Object) null);
                composerStartRestartGroup.startReplaceGroup(-1318272805);
                if ((i3 & 29360128) == 8388608) {
                    z3 = true;
                } else {
                    z3 = false;
                }
                objRememberedValue = composerStartRestartGroup.rememberedValue();
                if (!z3) {
                    objRememberedValue = (Function1) new Function1<FocusState, Unit>() {
                        {
                            super(1);
                        }

                        @Override
                        public Unit invoke(FocusState focusState) {
                            invoke2(focusState);
                            return Unit.INSTANCE;
                        }

                        public final void invoke2(FocusState focusState) {
                            Intrinsics.checkNotNullParameter(focusState, "focusState");
                            onFocusChange.invoke(Boolean.valueOf(focusState.isFocused()));
                        }
                    };
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                } else {
                    objRememberedValue = (Function1) new Function1<FocusState, Unit>() {
                        {
                            super(1);
                        }

                        @Override
                        public Unit invoke(FocusState focusState) {
                            invoke2(focusState);
                            return Unit.INSTANCE;
                        }

                        public final void invoke2(FocusState focusState) {
                            Intrinsics.checkNotNullParameter(focusState, "focusState");
                            onFocusChange.invoke(Boolean.valueOf(focusState.isFocused()));
                        }
                    };
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                }
                composerStartRestartGroup.endReplaceGroup();
                Shape shape6 = shape;
                Modifier modifierTestTag5 = TestTagKt.testTag(SemanticsModifierKt.semantics(PaddingKt.padding-3ABfNKs(ClipKt.clip(BorderKt.border(FocusableKt.focusable$default(FocusChangedModifierKt.onFocusChanged(modifierFillMaxWidth$default5, (Function1) objRememberedValue), false, (MutableInteractionSource) null, 3, (Object) null), borderStroke, shape6), shape6), PrimitiveResources_androidKt.dimensionResource(R.dimen.zuia_spacing_medium, composerStartRestartGroup, 0)), true, new Function1<SemanticsPropertyReceiver, Unit>() {
                    @Override
                    public Unit invoke(SemanticsPropertyReceiver semanticsPropertyReceiver) {
                        invoke2(semanticsPropertyReceiver);
                        return Unit.INSTANCE;
                    }

                    public final void invoke2(SemanticsPropertyReceiver semantics) {
                        Intrinsics.checkNotNullParameter(semantics, "$this$semantics");
                        SemanticsPropertiesKt.setLiveRegion-hR3wRGc(semantics, LiveRegionMode.Companion.getAssertive-0phEisY());
                    }
                }), ZUIWaitTimeBannerTag);
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -483455358, "CC(Column)P(2,3,1)86@4330L61,87@4396L133:Column.kt#2w3rfo");
                MeasurePolicy measurePolicyColumnMeasurePolicy6 = ColumnKt.columnMeasurePolicy(Arrangement.INSTANCE.getTop(), centerHorizontally5, composerStartRestartGroup, 48);
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1323940314, "CC(Layout)P(!1,2)79@3208L23,82@3359L411:Layout.kt#80mrfh");
                currentCompositeKeyHash = ComposablesKt.getCurrentCompositeKeyHash(composerStartRestartGroup, 0);
                CompositionLocalMap currentCompositionLocalMap6 = composerStartRestartGroup.getCurrentCompositionLocalMap();
                Modifier modifierMaterializeModifier6 = ComposedModifierKt.materializeModifier(composerStartRestartGroup, modifierTestTag5);
                constructor = ComposeUiNode.Companion.getConstructor();
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -692256719, "CC(ReusableComposeNode)P(1,2)376@14062L9:Composables.kt#9igjgp");
                if (!(composerStartRestartGroup.getApplier() instanceof Applier)) {
                    ComposablesKt.invalidApplier();
                }
                composerStartRestartGroup.startReusableNode();
                if (composerStartRestartGroup.getInserting()) {
                    composerStartRestartGroup.createNode(constructor);
                } else {
                    composerStartRestartGroup.useNode();
                }
                composer2 = Updater.constructor-impl(composerStartRestartGroup);
                Updater.set-impl(composer2, measurePolicyColumnMeasurePolicy6, ComposeUiNode.Companion.getSetMeasurePolicy());
                Updater.set-impl(composer2, currentCompositionLocalMap6, ComposeUiNode.Companion.getSetResolvedCompositionLocals());
                setCompositeKeyHash = ComposeUiNode.Companion.getSetCompositeKeyHash();
                if (!composer2.getInserting()) {
                    composer2.updateRememberedValue(Integer.valueOf(currentCompositeKeyHash));
                    composer2.apply(Integer.valueOf(currentCompositeKeyHash), setCompositeKeyHash);
                } else {
                    composer2.updateRememberedValue(Integer.valueOf(currentCompositeKeyHash));
                    composer2.apply(Integer.valueOf(currentCompositeKeyHash), setCompositeKeyHash);
                }
                Updater.set-impl(composer2, modifierMaterializeModifier6, ComposeUiNode.Companion.getSetModifier());
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -384784025, "C88@4444L9:Column.kt#2w3rfo");
                ColumnScope columnScope6 = ColumnScopeInstance.INSTANCE;
                if (!z2) {
                    if (z2) {
                        composerStartRestartGroup.startReplaceGroup(-34540595);
                        m2151WaitTimeTextM3jwhU8(j, str, j4, composerStartRestartGroup, ((i3 >> 3) & 14) | ((i3 >> 6) & 896));
                        composerStartRestartGroup.endReplaceGroup();
                    } else if (shouldShowQueue) {
                        composerStartRestartGroup.startReplaceGroup(-34336057);
                        m2151WaitTimeTextM3jwhU8(j, strPluralStringResource, j5, composerStartRestartGroup, ((i3 >> 3) & 14) | ((i3 >> 9) & 896));
                        composerStartRestartGroup.endReplaceGroup();
                    } else {
                        composerStartRestartGroup.startReplaceGroup(-34164999);
                        composerStartRestartGroup.endReplaceGroup();
                    }
                } else if (z2) {
                    composerStartRestartGroup.startReplaceGroup(-34540595);
                    m2151WaitTimeTextM3jwhU8(j, str, j4, composerStartRestartGroup, ((i3 >> 3) & 14) | ((i3 >> 6) & 896));
                    composerStartRestartGroup.endReplaceGroup();
                } else if (shouldShowQueue) {
                    composerStartRestartGroup.startReplaceGroup(-34336057);
                    m2151WaitTimeTextM3jwhU8(j, strPluralStringResource, j5, composerStartRestartGroup, ((i3 >> 3) & 14) | ((i3 >> 9) & 896));
                    composerStartRestartGroup.endReplaceGroup();
                } else {
                    composerStartRestartGroup.startReplaceGroup(-34164999);
                    composerStartRestartGroup.endReplaceGroup();
                }
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                composerStartRestartGroup.endNode();
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
            }
            scopeUpdateScopeEndRestartGroup2 = composerStartRestartGroup.endRestartGroup();
            if (scopeUpdateScopeEndRestartGroup2 != null) {
                scopeUpdateScopeEndRestartGroup2.updateScope(new Function2<Composer, Integer, Unit>() {
                    {
                        super(2);
                    }

                    @Override
                    public Unit invoke(Composer composer4, Integer num) {
                        invoke(composer4, num.intValue());
                        return Unit.INSTANCE;
                    }

                    public final void invoke(Composer composer4, int i10) {
                        WaitTimeBannerKt.m2150WaitTimeBannerfB7ZVRg(type, j, j2, j3, j4, j5, z, onFocusChange, modifier3, composer4, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                    }
                });
            }
        }
        i5 = 12582912;
        i3 |= i5;
        i6 = i2 & 256;
        if (i6 != 0) {
            i3 |= 100663296;
            modifier2 = modifier;
        } else {
            modifier2 = modifier;
            if ((i & 234881024) == 0) {
                if (composerStartRestartGroup.changed(modifier2)) {
                    i7 = 67108864;
                } else {
                    i7 = 33554432;
                }
                i3 |= i7;
            }
        }
        if ((i3 & 191739611) == 38347922) {
            if (i6 != 0) {
                modifier2 = (Modifier) Modifier.Companion;
            }
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventStart(-1731051425, i3, -1, "zendesk.ui.android.conversation.waittimebanner.WaitTimeBanner (WaitTimeBanner.kt:72)");
            }
            shape = RoundedCornerShapeKt.RoundedCornerShape-0680j_4(PrimitiveResources_androidKt.dimensionResource(R.dimen.zuia_wait_time_banner_border_radius, composerStartRestartGroup, 0));
            if (type instanceof WaitTimeBannerType.Cleared) {
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
                if (scopeUpdateScopeEndRestartGroup != null) {
                    final Modifier modifier15 = modifier2;
                    scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                        {
                            super(2);
                        }

                        @Override
                        public Unit invoke(Composer composer4, Integer num) {
                            invoke(composer4, num.intValue());
                            return Unit.INSTANCE;
                        }

                        public final void invoke(Composer composer4, int i10) {
                            WaitTimeBannerKt.m2150WaitTimeBannerfB7ZVRg(type, j, j2, j3, j4, j5, z, onFocusChange, modifier15, composer4, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                        }
                    });
                    return;
                }
                return;
            }
            Modifier modifier16 = modifier2;
            if (z) {
                composerStartRestartGroup.startReplaceGroup(2081561351);
                borderStroke = BorderStrokeKt.BorderStroke-cXLIe8U(PrimitiveResources_androidKt.dimensionResource(R.dimen.zuia_border_width, composerStartRestartGroup, 0), j3);
                composerStartRestartGroup.endReplaceGroup();
            } else {
                composerStartRestartGroup.startReplaceGroup(2081714150);
                borderStroke = BorderStrokeKt.BorderStroke-cXLIe8U(PrimitiveResources_androidKt.dimensionResource(R.dimen.zuia_divider_size, composerStartRestartGroup, 0), Color.copy-wmQWz5c$default(j2, ResourceUtilsKt.floatResources(R.dimen.zuia_wait_time_banner_border_alpha, composerStartRestartGroup, 0), 0.0f, 0.0f, 0.0f, 14, (Object) null));
                composerStartRestartGroup.endReplaceGroup();
            }
            if (type instanceof WaitTimeBannerType.Queued) {
                composerStartRestartGroup.startReplaceGroup(2082150506);
                WaitTimeBannerType.Queued queued6 = (WaitTimeBannerType.Queued) type;
                boolean shouldShowResponseTime6 = queued6.getShouldShowResponseTime();
                String strQueuedBannerText6 = queuedBannerText(queued6.getResponseTime().getLower(), queued6.getResponseTime().getUpper(), composerStartRestartGroup, 0);
                shouldShowQueue = queued6.getShouldShowQueue();
                z2 = shouldShowResponseTime6;
                i8 = 0;
                strPluralStringResource = StringResources_androidKt.pluralStringResource(R.plurals.bannerQueue, queued6.getQueuePosition(), new Object[]{Integer.valueOf(queued6.getQueuePosition())}, composerStartRestartGroup, 512);
                composerStartRestartGroup.endReplaceGroup();
                str = strQueuedBannerText6;
            } else {
                i8 = 0;
                composerStartRestartGroup.startReplaceGroup(2082609027);
                String strStringResource11 = StringResources_androidKt.stringResource(R.string.zuia_static_wait_time_banner_will_be_shortly, composerStartRestartGroup, 0);
                String strStringResource12 = StringResources_androidKt.stringResource(R.string.zuia_static_wait_time_banner_you_are_up_next, composerStartRestartGroup, 0);
                composerStartRestartGroup.endReplaceGroup();
                str = strStringResource11;
                strPluralStringResource = strStringResource12;
                shouldShowQueue = true;
                z2 = true;
            }
            Alignment.Horizontal centerHorizontally6 = Alignment.Companion.getCenterHorizontally();
            modifier3 = modifier16;
            Modifier modifierFillMaxWidth$default6 = SizeKt.fillMaxWidth$default(PaddingKt.padding-VpY3zN4$default(SizeKt.defaultMinSize-VpY3zN4$default(modifier3, 0.0f, PrimitiveResources_androidKt.dimensionResource(R.dimen.zuia_wait_time_banner_min_height, composerStartRestartGroup, i8), 1, (Object) null), PrimitiveResources_androidKt.dimensionResource(R.dimen.zuia_spacing_medium, composerStartRestartGroup, 0), 0.0f, 2, (Object) null), 0.0f, 1, (Object) null);
            composerStartRestartGroup.startReplaceGroup(-1318272805);
            if ((i3 & 29360128) == 8388608) {
                z3 = true;
            } else {
                z3 = false;
            }
            objRememberedValue = composerStartRestartGroup.rememberedValue();
            if (!z3) {
                objRememberedValue = (Function1) new Function1<FocusState, Unit>() {
                    {
                        super(1);
                    }

                    @Override
                    public Unit invoke(FocusState focusState) {
                        invoke2(focusState);
                        return Unit.INSTANCE;
                    }

                    public final void invoke2(FocusState focusState) {
                        Intrinsics.checkNotNullParameter(focusState, "focusState");
                        onFocusChange.invoke(Boolean.valueOf(focusState.isFocused()));
                    }
                };
                composerStartRestartGroup.updateRememberedValue(objRememberedValue);
            } else {
                objRememberedValue = (Function1) new Function1<FocusState, Unit>() {
                    {
                        super(1);
                    }

                    @Override
                    public Unit invoke(FocusState focusState) {
                        invoke2(focusState);
                        return Unit.INSTANCE;
                    }

                    public final void invoke2(FocusState focusState) {
                        Intrinsics.checkNotNullParameter(focusState, "focusState");
                        onFocusChange.invoke(Boolean.valueOf(focusState.isFocused()));
                    }
                };
                composerStartRestartGroup.updateRememberedValue(objRememberedValue);
            }
            composerStartRestartGroup.endReplaceGroup();
            Shape shape7 = shape;
            Modifier modifierTestTag6 = TestTagKt.testTag(SemanticsModifierKt.semantics(PaddingKt.padding-3ABfNKs(ClipKt.clip(BorderKt.border(FocusableKt.focusable$default(FocusChangedModifierKt.onFocusChanged(modifierFillMaxWidth$default6, (Function1) objRememberedValue), false, (MutableInteractionSource) null, 3, (Object) null), borderStroke, shape7), shape7), PrimitiveResources_androidKt.dimensionResource(R.dimen.zuia_spacing_medium, composerStartRestartGroup, 0)), true, new Function1<SemanticsPropertyReceiver, Unit>() {
                @Override
                public Unit invoke(SemanticsPropertyReceiver semanticsPropertyReceiver) {
                    invoke2(semanticsPropertyReceiver);
                    return Unit.INSTANCE;
                }

                public final void invoke2(SemanticsPropertyReceiver semantics) {
                    Intrinsics.checkNotNullParameter(semantics, "$this$semantics");
                    SemanticsPropertiesKt.setLiveRegion-hR3wRGc(semantics, LiveRegionMode.Companion.getAssertive-0phEisY());
                }
            }), ZUIWaitTimeBannerTag);
            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -483455358, "CC(Column)P(2,3,1)86@4330L61,87@4396L133:Column.kt#2w3rfo");
            MeasurePolicy measurePolicyColumnMeasurePolicy7 = ColumnKt.columnMeasurePolicy(Arrangement.INSTANCE.getTop(), centerHorizontally6, composerStartRestartGroup, 48);
            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1323940314, "CC(Layout)P(!1,2)79@3208L23,82@3359L411:Layout.kt#80mrfh");
            currentCompositeKeyHash = ComposablesKt.getCurrentCompositeKeyHash(composerStartRestartGroup, 0);
            CompositionLocalMap currentCompositionLocalMap7 = composerStartRestartGroup.getCurrentCompositionLocalMap();
            Modifier modifierMaterializeModifier7 = ComposedModifierKt.materializeModifier(composerStartRestartGroup, modifierTestTag6);
            constructor = ComposeUiNode.Companion.getConstructor();
            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -692256719, "CC(ReusableComposeNode)P(1,2)376@14062L9:Composables.kt#9igjgp");
            if (!(composerStartRestartGroup.getApplier() instanceof Applier)) {
                ComposablesKt.invalidApplier();
            }
            composerStartRestartGroup.startReusableNode();
            if (composerStartRestartGroup.getInserting()) {
                composerStartRestartGroup.createNode(constructor);
            } else {
                composerStartRestartGroup.useNode();
            }
            composer2 = Updater.constructor-impl(composerStartRestartGroup);
            Updater.set-impl(composer2, measurePolicyColumnMeasurePolicy7, ComposeUiNode.Companion.getSetMeasurePolicy());
            Updater.set-impl(composer2, currentCompositionLocalMap7, ComposeUiNode.Companion.getSetResolvedCompositionLocals());
            setCompositeKeyHash = ComposeUiNode.Companion.getSetCompositeKeyHash();
            if (!composer2.getInserting()) {
                composer2.updateRememberedValue(Integer.valueOf(currentCompositeKeyHash));
                composer2.apply(Integer.valueOf(currentCompositeKeyHash), setCompositeKeyHash);
            } else {
                composer2.updateRememberedValue(Integer.valueOf(currentCompositeKeyHash));
                composer2.apply(Integer.valueOf(currentCompositeKeyHash), setCompositeKeyHash);
            }
            Updater.set-impl(composer2, modifierMaterializeModifier7, ComposeUiNode.Companion.getSetModifier());
            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -384784025, "C88@4444L9:Column.kt#2w3rfo");
            ColumnScope columnScope7 = ColumnScopeInstance.INSTANCE;
            if (!z2) {
                if (z2) {
                    composerStartRestartGroup.startReplaceGroup(-34540595);
                    m2151WaitTimeTextM3jwhU8(j, str, j4, composerStartRestartGroup, ((i3 >> 3) & 14) | ((i3 >> 6) & 896));
                    composerStartRestartGroup.endReplaceGroup();
                } else if (shouldShowQueue) {
                    composerStartRestartGroup.startReplaceGroup(-34336057);
                    m2151WaitTimeTextM3jwhU8(j, strPluralStringResource, j5, composerStartRestartGroup, ((i3 >> 3) & 14) | ((i3 >> 9) & 896));
                    composerStartRestartGroup.endReplaceGroup();
                } else {
                    composerStartRestartGroup.startReplaceGroup(-34164999);
                    composerStartRestartGroup.endReplaceGroup();
                }
            } else if (z2) {
                composerStartRestartGroup.startReplaceGroup(-34540595);
                m2151WaitTimeTextM3jwhU8(j, str, j4, composerStartRestartGroup, ((i3 >> 3) & 14) | ((i3 >> 6) & 896));
                composerStartRestartGroup.endReplaceGroup();
            } else if (shouldShowQueue) {
                composerStartRestartGroup.startReplaceGroup(-34336057);
                m2151WaitTimeTextM3jwhU8(j, strPluralStringResource, j5, composerStartRestartGroup, ((i3 >> 3) & 14) | ((i3 >> 9) & 896));
                composerStartRestartGroup.endReplaceGroup();
            } else {
                composerStartRestartGroup.startReplaceGroup(-34164999);
                composerStartRestartGroup.endReplaceGroup();
            }
            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
            composerStartRestartGroup.endNode();
            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventEnd();
            }
        } else {
            if (i6 != 0) {
                modifier2 = (Modifier) Modifier.Companion;
            }
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventStart(-1731051425, i3, -1, "zendesk.ui.android.conversation.waittimebanner.WaitTimeBanner (WaitTimeBanner.kt:72)");
            }
            shape = RoundedCornerShapeKt.RoundedCornerShape-0680j_4(PrimitiveResources_androidKt.dimensionResource(R.dimen.zuia_wait_time_banner_border_radius, composerStartRestartGroup, 0));
            if (type instanceof WaitTimeBannerType.Cleared) {
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
                if (scopeUpdateScopeEndRestartGroup != null) {
                    final Modifier modifier17 = modifier2;
                    scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                        {
                            super(2);
                        }

                        @Override
                        public Unit invoke(Composer composer4, Integer num) {
                            invoke(composer4, num.intValue());
                            return Unit.INSTANCE;
                        }

                        public final void invoke(Composer composer4, int i10) {
                            WaitTimeBannerKt.m2150WaitTimeBannerfB7ZVRg(type, j, j2, j3, j4, j5, z, onFocusChange, modifier17, composer4, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                        }
                    });
                    return;
                }
                return;
            }
            Modifier modifier18 = modifier2;
            if (z) {
                composerStartRestartGroup.startReplaceGroup(2081561351);
                borderStroke = BorderStrokeKt.BorderStroke-cXLIe8U(PrimitiveResources_androidKt.dimensionResource(R.dimen.zuia_border_width, composerStartRestartGroup, 0), j3);
                composerStartRestartGroup.endReplaceGroup();
            } else {
                composerStartRestartGroup.startReplaceGroup(2081714150);
                borderStroke = BorderStrokeKt.BorderStroke-cXLIe8U(PrimitiveResources_androidKt.dimensionResource(R.dimen.zuia_divider_size, composerStartRestartGroup, 0), Color.copy-wmQWz5c$default(j2, ResourceUtilsKt.floatResources(R.dimen.zuia_wait_time_banner_border_alpha, composerStartRestartGroup, 0), 0.0f, 0.0f, 0.0f, 14, (Object) null));
                composerStartRestartGroup.endReplaceGroup();
            }
            if (type instanceof WaitTimeBannerType.Queued) {
                composerStartRestartGroup.startReplaceGroup(2082150506);
                WaitTimeBannerType.Queued queued7 = (WaitTimeBannerType.Queued) type;
                boolean shouldShowResponseTime7 = queued7.getShouldShowResponseTime();
                String strQueuedBannerText7 = queuedBannerText(queued7.getResponseTime().getLower(), queued7.getResponseTime().getUpper(), composerStartRestartGroup, 0);
                shouldShowQueue = queued7.getShouldShowQueue();
                z2 = shouldShowResponseTime7;
                i8 = 0;
                strPluralStringResource = StringResources_androidKt.pluralStringResource(R.plurals.bannerQueue, queued7.getQueuePosition(), new Object[]{Integer.valueOf(queued7.getQueuePosition())}, composerStartRestartGroup, 512);
                composerStartRestartGroup.endReplaceGroup();
                str = strQueuedBannerText7;
            } else {
                i8 = 0;
                composerStartRestartGroup.startReplaceGroup(2082609027);
                String strStringResource13 = StringResources_androidKt.stringResource(R.string.zuia_static_wait_time_banner_will_be_shortly, composerStartRestartGroup, 0);
                String strStringResource14 = StringResources_androidKt.stringResource(R.string.zuia_static_wait_time_banner_you_are_up_next, composerStartRestartGroup, 0);
                composerStartRestartGroup.endReplaceGroup();
                str = strStringResource13;
                strPluralStringResource = strStringResource14;
                shouldShowQueue = true;
                z2 = true;
            }
            Alignment.Horizontal centerHorizontally7 = Alignment.Companion.getCenterHorizontally();
            modifier3 = modifier18;
            Modifier modifierFillMaxWidth$default7 = SizeKt.fillMaxWidth$default(PaddingKt.padding-VpY3zN4$default(SizeKt.defaultMinSize-VpY3zN4$default(modifier3, 0.0f, PrimitiveResources_androidKt.dimensionResource(R.dimen.zuia_wait_time_banner_min_height, composerStartRestartGroup, i8), 1, (Object) null), PrimitiveResources_androidKt.dimensionResource(R.dimen.zuia_spacing_medium, composerStartRestartGroup, 0), 0.0f, 2, (Object) null), 0.0f, 1, (Object) null);
            composerStartRestartGroup.startReplaceGroup(-1318272805);
            if ((i3 & 29360128) == 8388608) {
                z3 = true;
            } else {
                z3 = false;
            }
            objRememberedValue = composerStartRestartGroup.rememberedValue();
            if (!z3) {
                objRememberedValue = (Function1) new Function1<FocusState, Unit>() {
                    {
                        super(1);
                    }

                    @Override
                    public Unit invoke(FocusState focusState) {
                        invoke2(focusState);
                        return Unit.INSTANCE;
                    }

                    public final void invoke2(FocusState focusState) {
                        Intrinsics.checkNotNullParameter(focusState, "focusState");
                        onFocusChange.invoke(Boolean.valueOf(focusState.isFocused()));
                    }
                };
                composerStartRestartGroup.updateRememberedValue(objRememberedValue);
            } else {
                objRememberedValue = (Function1) new Function1<FocusState, Unit>() {
                    {
                        super(1);
                    }

                    @Override
                    public Unit invoke(FocusState focusState) {
                        invoke2(focusState);
                        return Unit.INSTANCE;
                    }

                    public final void invoke2(FocusState focusState) {
                        Intrinsics.checkNotNullParameter(focusState, "focusState");
                        onFocusChange.invoke(Boolean.valueOf(focusState.isFocused()));
                    }
                };
                composerStartRestartGroup.updateRememberedValue(objRememberedValue);
            }
            composerStartRestartGroup.endReplaceGroup();
            Shape shape8 = shape;
            Modifier modifierTestTag7 = TestTagKt.testTag(SemanticsModifierKt.semantics(PaddingKt.padding-3ABfNKs(ClipKt.clip(BorderKt.border(FocusableKt.focusable$default(FocusChangedModifierKt.onFocusChanged(modifierFillMaxWidth$default7, (Function1) objRememberedValue), false, (MutableInteractionSource) null, 3, (Object) null), borderStroke, shape8), shape8), PrimitiveResources_androidKt.dimensionResource(R.dimen.zuia_spacing_medium, composerStartRestartGroup, 0)), true, new Function1<SemanticsPropertyReceiver, Unit>() {
                @Override
                public Unit invoke(SemanticsPropertyReceiver semanticsPropertyReceiver) {
                    invoke2(semanticsPropertyReceiver);
                    return Unit.INSTANCE;
                }

                public final void invoke2(SemanticsPropertyReceiver semantics) {
                    Intrinsics.checkNotNullParameter(semantics, "$this$semantics");
                    SemanticsPropertiesKt.setLiveRegion-hR3wRGc(semantics, LiveRegionMode.Companion.getAssertive-0phEisY());
                }
            }), ZUIWaitTimeBannerTag);
            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -483455358, "CC(Column)P(2,3,1)86@4330L61,87@4396L133:Column.kt#2w3rfo");
            MeasurePolicy measurePolicyColumnMeasurePolicy8 = ColumnKt.columnMeasurePolicy(Arrangement.INSTANCE.getTop(), centerHorizontally7, composerStartRestartGroup, 48);
            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1323940314, "CC(Layout)P(!1,2)79@3208L23,82@3359L411:Layout.kt#80mrfh");
            currentCompositeKeyHash = ComposablesKt.getCurrentCompositeKeyHash(composerStartRestartGroup, 0);
            CompositionLocalMap currentCompositionLocalMap8 = composerStartRestartGroup.getCurrentCompositionLocalMap();
            Modifier modifierMaterializeModifier8 = ComposedModifierKt.materializeModifier(composerStartRestartGroup, modifierTestTag7);
            constructor = ComposeUiNode.Companion.getConstructor();
            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -692256719, "CC(ReusableComposeNode)P(1,2)376@14062L9:Composables.kt#9igjgp");
            if (!(composerStartRestartGroup.getApplier() instanceof Applier)) {
                ComposablesKt.invalidApplier();
            }
            composerStartRestartGroup.startReusableNode();
            if (composerStartRestartGroup.getInserting()) {
                composerStartRestartGroup.createNode(constructor);
            } else {
                composerStartRestartGroup.useNode();
            }
            composer2 = Updater.constructor-impl(composerStartRestartGroup);
            Updater.set-impl(composer2, measurePolicyColumnMeasurePolicy8, ComposeUiNode.Companion.getSetMeasurePolicy());
            Updater.set-impl(composer2, currentCompositionLocalMap8, ComposeUiNode.Companion.getSetResolvedCompositionLocals());
            setCompositeKeyHash = ComposeUiNode.Companion.getSetCompositeKeyHash();
            if (!composer2.getInserting()) {
                composer2.updateRememberedValue(Integer.valueOf(currentCompositeKeyHash));
                composer2.apply(Integer.valueOf(currentCompositeKeyHash), setCompositeKeyHash);
            } else {
                composer2.updateRememberedValue(Integer.valueOf(currentCompositeKeyHash));
                composer2.apply(Integer.valueOf(currentCompositeKeyHash), setCompositeKeyHash);
            }
            Updater.set-impl(composer2, modifierMaterializeModifier8, ComposeUiNode.Companion.getSetModifier());
            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -384784025, "C88@4444L9:Column.kt#2w3rfo");
            ColumnScope columnScope8 = ColumnScopeInstance.INSTANCE;
            if (!z2) {
                if (z2) {
                    composerStartRestartGroup.startReplaceGroup(-34540595);
                    m2151WaitTimeTextM3jwhU8(j, str, j4, composerStartRestartGroup, ((i3 >> 3) & 14) | ((i3 >> 6) & 896));
                    composerStartRestartGroup.endReplaceGroup();
                } else if (shouldShowQueue) {
                    composerStartRestartGroup.startReplaceGroup(-34336057);
                    m2151WaitTimeTextM3jwhU8(j, strPluralStringResource, j5, composerStartRestartGroup, ((i3 >> 3) & 14) | ((i3 >> 9) & 896));
                    composerStartRestartGroup.endReplaceGroup();
                } else {
                    composerStartRestartGroup.startReplaceGroup(-34164999);
                    composerStartRestartGroup.endReplaceGroup();
                }
            } else if (z2) {
                composerStartRestartGroup.startReplaceGroup(-34540595);
                m2151WaitTimeTextM3jwhU8(j, str, j4, composerStartRestartGroup, ((i3 >> 3) & 14) | ((i3 >> 6) & 896));
                composerStartRestartGroup.endReplaceGroup();
            } else if (shouldShowQueue) {
                composerStartRestartGroup.startReplaceGroup(-34336057);
                m2151WaitTimeTextM3jwhU8(j, strPluralStringResource, j5, composerStartRestartGroup, ((i3 >> 3) & 14) | ((i3 >> 9) & 896));
                composerStartRestartGroup.endReplaceGroup();
            } else {
                composerStartRestartGroup.startReplaceGroup(-34164999);
                composerStartRestartGroup.endReplaceGroup();
            }
            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
            composerStartRestartGroup.endNode();
            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventEnd();
            }
        }
        scopeUpdateScopeEndRestartGroup2 = composerStartRestartGroup.endRestartGroup();
        if (scopeUpdateScopeEndRestartGroup2 != null) {
            scopeUpdateScopeEndRestartGroup2.updateScope(new Function2<Composer, Integer, Unit>() {
                {
                    super(2);
                }

                @Override
                public Unit invoke(Composer composer4, Integer num) {
                    invoke(composer4, num.intValue());
                    return Unit.INSTANCE;
                }

                public final void invoke(Composer composer4, int i10) {
                    WaitTimeBannerKt.m2150WaitTimeBannerfB7ZVRg(type, j, j2, j3, j4, j5, z, onFocusChange, modifier3, composer4, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                }
            });
        }
    }

    public static final void m2151WaitTimeTextM3jwhU8(final long j, final String str, final long j2, Composer composer, final int i) {
        int i2;
        Composer composerStartRestartGroup = composer.startRestartGroup(176156886);
        if ((i & 14) == 0) {
            i2 = (composerStartRestartGroup.changed(j) ? 4 : 2) | i;
        } else {
            i2 = i;
        }
        if ((i & 112) == 0) {
            i2 |= composerStartRestartGroup.changed(str) ? 32 : 16;
        }
        if ((i & 896) == 0) {
            i2 |= composerStartRestartGroup.changed(j2) ? 256 : 128;
        }
        if ((i2 & 731) != 146 || !composerStartRestartGroup.getSkipping()) {
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventStart(176156886, i2, -1, "zendesk.ui.android.conversation.waittimebanner.WaitTimeText (WaitTimeBanner.kt:180)");
            }
            AnnotatedString.Builder builder = new AnnotatedString.Builder(0, 1, (DefaultConstructorMarker) null);
            InlineTextContentKt.appendInlineContent$default(builder, "image", (String) null, 2, (Object) null);
            builder.append(str);
            AnnotatedString annotatedString = builder.toAnnotatedString();
            Map mapMapOf = MapsKt.mapOf(TuplesKt.m25to("image", new InlineTextContent(new Placeholder(TextUnitKt.getSp(ResourceUtilsKt.floatResources(R.dimen.zuia_wait_time_banner_icon_relative_width, composerStartRestartGroup, 0)), TextUnitKt.getSp(ResourceUtilsKt.floatResources(R.dimen.zuia_wait_time_banner_icon_relative_height, composerStartRestartGroup, 0)), PlaceholderVerticalAlign.Companion.getTextCenter-J6kI3mc(), (DefaultConstructorMarker) null), ComposableLambdaKt.rememberComposableLambda(1392451830, true, new Function3<String, Composer, Integer, Unit>() {
                {
                    super(3);
                }

                @Override
                public Unit invoke(String str2, Composer composer2, Integer num) {
                    invoke(str2, composer2, num.intValue());
                    return Unit.INSTANCE;
                }

                public final void invoke(String it, Composer composer2, int i3) {
                    Intrinsics.checkNotNullParameter(it, "it");
                    if ((i3 & 81) == 16 && composer2.getSkipping()) {
                        composer2.skipToGroupEnd();
                        return;
                    }
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(1392451830, i3, -1, "zendesk.ui.android.conversation.waittimebanner.WaitTimeText.<anonymous> (WaitTimeBanner.kt:193)");
                    }
                    WaitTimeBannerKt.m2149ClockIconek8zF_U(j, composer2, 0);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                }
            }, composerStartRestartGroup, 54))));
            int i3 = TextAlign.Companion.getCenter-e0LSkKk();
            Modifier modifier = Modifier.Companion;
            composerStartRestartGroup.startReplaceGroup(1787466268);
            boolean z = (i2 & 112) == 32;
            Object objRememberedValue = composerStartRestartGroup.rememberedValue();
            if (z || objRememberedValue == Composer.Companion.getEmpty()) {
                objRememberedValue = (Function1) new Function1<SemanticsPropertyReceiver, Unit>() {
                    {
                        super(1);
                    }

                    @Override
                    public Unit invoke(SemanticsPropertyReceiver semanticsPropertyReceiver) {
                        invoke2(semanticsPropertyReceiver);
                        return Unit.INSTANCE;
                    }

                    public final void invoke2(SemanticsPropertyReceiver semantics) {
                        Intrinsics.checkNotNullParameter(semantics, "$this$semantics");
                        SemanticsPropertiesKt.setContentDescription(semantics, str);
                    }
                };
                composerStartRestartGroup.updateRememberedValue(objRememberedValue);
            }
            composerStartRestartGroup.endReplaceGroup();
            TextKt.Text-IbK3jfQ(annotatedString, SemanticsModifierKt.semantics$default(modifier, false, (Function1) objRememberedValue, 1, (Object) null), j2, 0L, (FontStyle) null, (FontWeight) null, (FontFamily) null, 0L, (TextDecoration) null, TextAlign.box-impl(i3), 0L, 0, false, 0, 0, mapMapOf, (Function1) null, (TextStyle) null, composerStartRestartGroup, i2 & 896, 0, 228856);
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventEnd();
            }
        } else {
            composerStartRestartGroup.skipToGroupEnd();
        }
        ScopeUpdateScope scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
        if (scopeUpdateScopeEndRestartGroup != null) {
            scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                {
                    super(2);
                }

                @Override
                public Unit invoke(Composer composer2, Integer num) {
                    invoke(composer2, num.intValue());
                    return Unit.INSTANCE;
                }

                public final void invoke(Composer composer2, int i4) {
                    WaitTimeBannerKt.m2151WaitTimeTextM3jwhU8(j, str, j2, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1));
                }
            });
        }
    }

    public static final void m2149ClockIconek8zF_U(final long j, Composer composer, final int i) {
        int i2;
        Composer composerStartRestartGroup = composer.startRestartGroup(-2021958978);
        if ((i & 14) == 0) {
            i2 = (composerStartRestartGroup.changed(j) ? 4 : 2) | i;
        } else {
            i2 = i;
        }
        if ((i2 & 11) != 2 || !composerStartRestartGroup.getSkipping()) {
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventStart(-2021958978, i2, -1, "zendesk.ui.android.conversation.waittimebanner.ClockIcon (WaitTimeBanner.kt:209)");
            }
            IconKt.Icon-ww6aTOc(PainterResources_androidKt.painterResource(R.drawable.zuia_ic_clock, composerStartRestartGroup, 0), (String) null, AspectRatioKt.aspectRatio$default(Modifier.Companion, ResourceUtilsKt.floatResources(R.dimen.zuia_wait_time_banner_icon_aspect_ratio, composerStartRestartGroup, 0), false, 2, (Object) null), j, composerStartRestartGroup, ((i2 << 9) & 7168) | 56, 0);
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventEnd();
            }
        } else {
            composerStartRestartGroup.skipToGroupEnd();
        }
        ScopeUpdateScope scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
        if (scopeUpdateScopeEndRestartGroup != null) {
            scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                {
                    super(2);
                }

                @Override
                public Unit invoke(Composer composer2, Integer num) {
                    invoke(composer2, num.intValue());
                    return Unit.INSTANCE;
                }

                public final void invoke(Composer composer2, int i3) {
                    WaitTimeBannerKt.m2149ClockIconek8zF_U(j, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1));
                }
            });
        }
    }

    private static final String queuedBannerText(long j, long j2, Composer composer, int i) {
        composer.startReplaceGroup(-1769123263);
        if (ComposerKt.isTraceInProgress()) {
            ComposerKt.traceEventStart(-1769123263, i, -1, "zendesk.ui.android.conversation.waittimebanner.queuedBannerText (WaitTimeBanner.kt:222)");
        }
        String strStringForType = stringForType(WaitTimeQueuedBannerUtil.INSTANCE.getType(j, j2), composer, 0);
        if (ComposerKt.isTraceInProgress()) {
            ComposerKt.traceEventEnd();
        }
        composer.endReplaceGroup();
        return strStringForType;
    }

    private static final String stringForType(QueuedBannerStatusType queuedBannerStatusType, Composer composer, int i) {
        String strStringResource;
        composer.startReplaceGroup(1984271312);
        if (ComposerKt.isTraceInProgress()) {
            ComposerKt.traceEventStart(1984271312, i, -1, "zendesk.ui.android.conversation.waittimebanner.stringForType (WaitTimeBanner.kt:230)");
        }
        if (queuedBannerStatusType instanceof QueuedBannerStatusType.AboutDays) {
            composer.startReplaceGroup(1355958944);
            strStringResource = StringResources_androidKt.stringResource(queuedBannerStatusType.getResId(), new Object[]{Integer.valueOf(((QueuedBannerStatusType.AboutDays) queuedBannerStatusType).getUpperDays())}, composer, 64);
            composer.endReplaceGroup();
        } else if (queuedBannerStatusType instanceof QueuedBannerStatusType.AboutHours) {
            composer.startReplaceGroup(1355961729);
            strStringResource = StringResources_androidKt.stringResource(queuedBannerStatusType.getResId(), new Object[]{Integer.valueOf(((QueuedBannerStatusType.AboutHours) queuedBannerStatusType).getUpperHours())}, composer, 64);
            composer.endReplaceGroup();
        } else if (queuedBannerStatusType instanceof QueuedBannerStatusType.AboutMinute) {
            composer.startReplaceGroup(1355964573);
            strStringResource = StringResources_androidKt.stringResource(queuedBannerStatusType.getResId(), new Object[]{Integer.valueOf(((QueuedBannerStatusType.AboutMinute) queuedBannerStatusType).getMinute())}, composer, 64);
            composer.endReplaceGroup();
        } else if (queuedBannerStatusType instanceof QueuedBannerStatusType.AboutMinutes) {
            composer.startReplaceGroup(1355967331);
            strStringResource = StringResources_androidKt.stringResource(queuedBannerStatusType.getResId(), new Object[]{Integer.valueOf(((QueuedBannerStatusType.AboutMinutes) queuedBannerStatusType).getUpperMinutes())}, composer, 64);
            composer.endReplaceGroup();
        } else if (queuedBannerStatusType instanceof QueuedBannerStatusType.DailyRange) {
            composer.startReplaceGroup(1355970255);
            int resId = queuedBannerStatusType.getResId();
            QueuedBannerStatusType.DailyRange dailyRange = (QueuedBannerStatusType.DailyRange) queuedBannerStatusType;
            strStringResource = StringResources_androidKt.stringResource(resId, new Object[]{Integer.valueOf(dailyRange.getLowerDays()), Integer.valueOf(dailyRange.getUpperDays())}, composer, 64);
            composer.endReplaceGroup();
        } else if (queuedBannerStatusType instanceof QueuedBannerStatusType.HourlyRange) {
            composer.startReplaceGroup(1355974609);
            int resId2 = queuedBannerStatusType.getResId();
            QueuedBannerStatusType.HourlyRange hourlyRange = (QueuedBannerStatusType.HourlyRange) queuedBannerStatusType;
            strStringResource = StringResources_androidKt.stringResource(resId2, new Object[]{Integer.valueOf(hourlyRange.getLowerHours()), Integer.valueOf(hourlyRange.getUpperHours())}, composer, 64);
            composer.endReplaceGroup();
        } else if (queuedBannerStatusType instanceof QueuedBannerStatusType.MinuteRange) {
            composer.startReplaceGroup(1355979029);
            int resId3 = queuedBannerStatusType.getResId();
            QueuedBannerStatusType.MinuteRange minuteRange = (QueuedBannerStatusType.MinuteRange) queuedBannerStatusType;
            strStringResource = StringResources_androidKt.stringResource(resId3, new Object[]{Integer.valueOf(minuteRange.getLowerMinutes()), Integer.valueOf(minuteRange.getUpperMinutes())}, composer, 64);
            composer.endReplaceGroup();
        } else if (queuedBannerStatusType instanceof QueuedBannerStatusType.WithinDays) {
            composer.startReplaceGroup(1355983488);
            strStringResource = StringResources_androidKt.stringResource(queuedBannerStatusType.getResId(), new Object[]{Integer.valueOf(((QueuedBannerStatusType.WithinDays) queuedBannerStatusType).getUpperDays())}, composer, 64);
            composer.endReplaceGroup();
        } else if (queuedBannerStatusType instanceof QueuedBannerStatusType.WithinHours) {
            composer.startReplaceGroup(1355986305);
            strStringResource = StringResources_androidKt.stringResource(queuedBannerStatusType.getResId(), new Object[]{Integer.valueOf(((QueuedBannerStatusType.WithinHours) queuedBannerStatusType).getUpperHours())}, composer, 64);
            composer.endReplaceGroup();
        } else if (queuedBannerStatusType instanceof QueuedBannerStatusType.WithinMinute) {
            composer.startReplaceGroup(1355989181);
            strStringResource = StringResources_androidKt.stringResource(queuedBannerStatusType.getResId(), new Object[]{Integer.valueOf(((QueuedBannerStatusType.WithinMinute) queuedBannerStatusType).getMinute())}, composer, 64);
            composer.endReplaceGroup();
        } else {
            if (!(queuedBannerStatusType instanceof QueuedBannerStatusType.WithinMinutes)) {
                composer.startReplaceGroup(1355688214);
                composer.endReplaceGroup();
                throw new NoWhenBranchMatchedException();
            }
            composer.startReplaceGroup(1355991971);
            strStringResource = StringResources_androidKt.stringResource(queuedBannerStatusType.getResId(), new Object[]{Integer.valueOf(((QueuedBannerStatusType.WithinMinutes) queuedBannerStatusType).getUpperMinutes())}, composer, 64);
            composer.endReplaceGroup();
        }
        if (ComposerKt.isTraceInProgress()) {
            ComposerKt.traceEventEnd();
        }
        composer.endReplaceGroup();
        return strStringResource;
    }

    @PreviewThemes
    public static final void PreviewBanner(Composer composer, final int i) {
        Composer composerStartRestartGroup = composer.startRestartGroup(-1398977200);
        if (i != 0 || !composerStartRestartGroup.getSkipping()) {
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventStart(-1398977200, i, -1, "zendesk.ui.android.conversation.waittimebanner.PreviewBanner (WaitTimeBanner.kt:263)");
            }
            ThemeKt.UiComposeAndroidTheme(false, ComposableSingletons$WaitTimeBannerKt.INSTANCE.m2146getLambda2$zendesk_ui_ui_android(), composerStartRestartGroup, 48, 1);
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventEnd();
            }
        } else {
            composerStartRestartGroup.skipToGroupEnd();
        }
        ScopeUpdateScope scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
        if (scopeUpdateScopeEndRestartGroup != null) {
            scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                {
                    super(2);
                }

                @Override
                public Unit invoke(Composer composer2, Integer num) {
                    invoke(composer2, num.intValue());
                    return Unit.INSTANCE;
                }

                public final void invoke(Composer composer2, int i2) {
                    WaitTimeBannerKt.PreviewBanner(composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1));
                }
            });
        }
    }

    @PreviewThemes
    public static final void PreviewClearedBanner(Composer composer, final int i) {
        Composer composerStartRestartGroup = composer.startRestartGroup(-2080279832);
        if (i != 0 || !composerStartRestartGroup.getSkipping()) {
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventStart(-2080279832, i, -1, "zendesk.ui.android.conversation.waittimebanner.PreviewClearedBanner (WaitTimeBanner.kt:341)");
            }
            ThemeKt.UiComposeAndroidTheme(false, ComposableSingletons$WaitTimeBannerKt.INSTANCE.m2148getLambda4$zendesk_ui_ui_android(), composerStartRestartGroup, 48, 1);
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventEnd();
            }
        } else {
            composerStartRestartGroup.skipToGroupEnd();
        }
        ScopeUpdateScope scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
        if (scopeUpdateScopeEndRestartGroup != null) {
            scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                {
                    super(2);
                }

                @Override
                public Unit invoke(Composer composer2, Integer num) {
                    invoke(composer2, num.intValue());
                    return Unit.INSTANCE;
                }

                public final void invoke(Composer composer2, int i2) {
                    WaitTimeBannerKt.PreviewClearedBanner(composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1));
                }
            });
        }
    }
}
