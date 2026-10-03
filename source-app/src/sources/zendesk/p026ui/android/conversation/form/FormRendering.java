package zendesk.p026ui.android.conversation.form;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import kotlin.Metadata;
import kotlin.Unit;
import kotlin.collections.ArraysKt;
import kotlin.collections.CollectionsKt;
import kotlin.jvm.functions.Function1;
import kotlin.jvm.functions.Function2;
import kotlin.jvm.internal.DefaultConstructorMarker;
import kotlin.jvm.internal.Intrinsics;
import net.aihelp.data.track.data.TrackType;

@Metadata(m17d1 = {"\u0000P\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u0000\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010 \n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\u0010\u0002\n\u0002\b\u0002\n\u0002\u0010\u000b\n\u0000\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0010\u000e\n\u0000\n\u0002\u0010%\n\u0002\u0018\u0002\n\u0002\b$\n\u0002\u0010\b\n\u0002\b\u0003\b\u0087\b\u0018\u0000*\u0004\b\u0000\u0010\u00012\u00020\u0002:\u0001;B±\u0001\b\u0000\u0012\b\b\u0002\u0010\u0003\u001a\u00020\u0004\u0012\u0014\b\u0002\u0010\u0005\u001a\u000e\u0012\n\u0012\b\u0012\u0004\u0012\u00028\u00000\u00070\u0006\u0012\u001a\b\u0002\u0010\b\u001a\u0014\u0012\n\u0012\b\u0012\u0004\u0012\u00028\u00000\u0006\u0012\u0004\u0012\u00020\n0\t\u0012\u001a\b\u0002\u0010\u000b\u001a\u0014\u0012\n\u0012\b\u0012\u0004\u0012\u00028\u00000\u0006\u0012\u0004\u0012\u00020\n0\t\u0012\u0014\b\u0002\u0010\f\u001a\u000e\u0012\u0004\u0012\u00020\r\u0012\u0004\u0012\u00020\n0\t\u0012\u001a\b\u0002\u0010\u000e\u001a\u0014\u0012\u0004\u0012\u00020\u0010\u0012\u0004\u0012\u00020\u0011\u0012\u0004\u0012\u00020\n0\u000f\u0012\u0014\b\u0002\u0010\u0012\u001a\u000e\u0012\u0004\u0012\u00020\u0011\u0012\u0004\u0012\u00020\u00140\u0013\u0012\b\b\u0002\u0010\u0015\u001a\u00020\u0011¢\u0006\u0002\u0010\u0016J\u000e\u0010%\u001a\u00020\u0004HÀ\u0003¢\u0006\u0002\b&J\u001a\u0010'\u001a\u000e\u0012\n\u0012\b\u0012\u0004\u0012\u00028\u00000\u00070\u0006HÀ\u0003¢\u0006\u0002\b(J \u0010)\u001a\u0014\u0012\n\u0012\b\u0012\u0004\u0012\u00028\u00000\u0006\u0012\u0004\u0012\u00020\n0\tHÀ\u0003¢\u0006\u0002\b*J \u0010+\u001a\u0014\u0012\n\u0012\b\u0012\u0004\u0012\u00028\u00000\u0006\u0012\u0004\u0012\u00020\n0\tHÀ\u0003¢\u0006\u0002\b,J\u001a\u0010-\u001a\u000e\u0012\u0004\u0012\u00020\r\u0012\u0004\u0012\u00020\n0\tHÀ\u0003¢\u0006\u0002\b.J \u0010/\u001a\u0014\u0012\u0004\u0012\u00020\u0010\u0012\u0004\u0012\u00020\u0011\u0012\u0004\u0012\u00020\n0\u000fHÀ\u0003¢\u0006\u0002\b0J\u001a\u00101\u001a\u000e\u0012\u0004\u0012\u00020\u0011\u0012\u0004\u0012\u00020\u00140\u0013HÀ\u0003¢\u0006\u0002\b2J\u000e\u00103\u001a\u00020\u0011HÀ\u0003¢\u0006\u0002\b4J¹\u0001\u00105\u001a\b\u0012\u0004\u0012\u00028\u00000\u00002\b\b\u0002\u0010\u0003\u001a\u00020\u00042\u0014\b\u0002\u0010\u0005\u001a\u000e\u0012\n\u0012\b\u0012\u0004\u0012\u00028\u00000\u00070\u00062\u001a\b\u0002\u0010\b\u001a\u0014\u0012\n\u0012\b\u0012\u0004\u0012\u00028\u00000\u0006\u0012\u0004\u0012\u00020\n0\t2\u001a\b\u0002\u0010\u000b\u001a\u0014\u0012\n\u0012\b\u0012\u0004\u0012\u00028\u00000\u0006\u0012\u0004\u0012\u00020\n0\t2\u0014\b\u0002\u0010\f\u001a\u000e\u0012\u0004\u0012\u00020\r\u0012\u0004\u0012\u00020\n0\t2\u001a\b\u0002\u0010\u000e\u001a\u0014\u0012\u0004\u0012\u00020\u0010\u0012\u0004\u0012\u00020\u0011\u0012\u0004\u0012\u00020\n0\u000f2\u0014\b\u0002\u0010\u0012\u001a\u000e\u0012\u0004\u0012\u00020\u0011\u0012\u0004\u0012\u00020\u00140\u00132\b\b\u0002\u0010\u0015\u001a\u00020\u0011HÆ\u0001J\u0013\u00106\u001a\u00020\r2\b\u00107\u001a\u0004\u0018\u00010\u0002HÖ\u0003J\t\u00108\u001a\u000209HÖ\u0001J\t\u0010:\u001a\u00020\u0011HÖ\u0001R \u0010\u0005\u001a\u000e\u0012\n\u0012\b\u0012\u0004\u0012\u00028\u00000\u00070\u0006X\u0080\u0004¢\u0006\b\n\u0000\u001a\u0004\b\u0017\u0010\u0018R\u0014\u0010\u0015\u001a\u00020\u0011X\u0080\u0004¢\u0006\b\n\u0000\u001a\u0004\b\u0019\u0010\u001aR \u0010\u0012\u001a\u000e\u0012\u0004\u0012\u00020\u0011\u0012\u0004\u0012\u00020\u00140\u0013X\u0080\u0004¢\u0006\b\n\u0000\u001a\u0004\b\u001b\u0010\u001cR&\u0010\u000b\u001a\u0014\u0012\n\u0012\b\u0012\u0004\u0012\u00028\u00000\u0006\u0012\u0004\u0012\u00020\n0\tX\u0080\u0004¢\u0006\b\n\u0000\u001a\u0004\b\u001d\u0010\u001eR&\u0010\b\u001a\u0014\u0012\n\u0012\b\u0012\u0004\u0012\u00028\u00000\u0006\u0012\u0004\u0012\u00020\n0\tX\u0080\u0004¢\u0006\b\n\u0000\u001a\u0004\b\u001f\u0010\u001eR&\u0010\u000e\u001a\u0014\u0012\u0004\u0012\u00020\u0010\u0012\u0004\u0012\u00020\u0011\u0012\u0004\u0012\u00020\n0\u000fX\u0080\u0004¢\u0006\b\n\u0000\u001a\u0004\b \u0010!R \u0010\f\u001a\u000e\u0012\u0004\u0012\u00020\r\u0012\u0004\u0012\u00020\n0\tX\u0080\u0004¢\u0006\b\n\u0000\u001a\u0004\b\"\u0010\u001eR\u0014\u0010\u0003\u001a\u00020\u0004X\u0080\u0004¢\u0006\b\n\u0000\u001a\u0004\b#\u0010$¨\u0006<"}, m18d2 = {"Lzendesk/ui/android/conversation/form/FormRendering;", "T", "", "state", "Lzendesk/ui/android/conversation/form/FormState;", "fieldRenderings", "", "Lzendesk/ui/android/conversation/form/FieldRendering;", "onFormCompleted", "Lkotlin/Function1;", "", "onFormChanged", "onFormFocusChanged", "", "onFormDisplayedFieldsChanged", "Lkotlin/Function2;", "Lzendesk/ui/android/conversation/form/DisplayedField;", "", "mapOfDisplayedForm", "", "Lzendesk/ui/android/conversation/form/DisplayedForm;", "formId", "(Lzendesk/ui/android/conversation/form/FormState;Ljava/util/List;Lkotlin/jvm/functions/Function1;Lkotlin/jvm/functions/Function1;Lkotlin/jvm/functions/Function1;Lkotlin/jvm/functions/Function2;Ljava/util/Map;Ljava/lang/String;)V", "getFieldRenderings$zendesk_ui_ui_android", "()Ljava/util/List;", "getFormId$zendesk_ui_ui_android", "()Ljava/lang/String;", "getMapOfDisplayedForm$zendesk_ui_ui_android", "()Ljava/util/Map;", "getOnFormChanged$zendesk_ui_ui_android", "()Lkotlin/jvm/functions/Function1;", "getOnFormCompleted$zendesk_ui_ui_android", "getOnFormDisplayedFieldsChanged$zendesk_ui_ui_android", "()Lkotlin/jvm/functions/Function2;", "getOnFormFocusChanged$zendesk_ui_ui_android", "getState$zendesk_ui_ui_android", "()Lzendesk/ui/android/conversation/form/FormState;", "component1", "component1$zendesk_ui_ui_android", "component2", "component2$zendesk_ui_ui_android", "component3", "component3$zendesk_ui_ui_android", "component4", "component4$zendesk_ui_ui_android", "component5", "component5$zendesk_ui_ui_android", "component6", "component6$zendesk_ui_ui_android", "component7", "component7$zendesk_ui_ui_android", "component8", "component8$zendesk_ui_ui_android", "copy", "equals", "other", "hashCode", "", "toString", "Builder", "zendesk.ui_ui-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
public final class FormRendering<T> {
    public static final int $stable = 8;
    private final List<FieldRendering<T>> fieldRenderings;
    private final String formId;
    private final Map<String, DisplayedForm> mapOfDisplayedForm;
    private final Function1<List<? extends T>, Unit> onFormChanged;
    private final Function1<List<? extends T>, Unit> onFormCompleted;
    private final Function2<DisplayedField, String, Unit> onFormDisplayedFieldsChanged;
    private final Function1<Boolean, Unit> onFormFocusChanged;
    private final FormState state;

    public FormRendering() {
        this(null, null, null, null, null, null, null, null, 255, null);
    }

    public static FormRendering copy$default(FormRendering formRendering, FormState formState, List list, Function1 function1, Function1 function2, Function1 function3, Function2 function4, Map map, String str, int i, Object obj) {
        return formRendering.copy((i & 1) != 0 ? formRendering.state : formState, (i & 2) != 0 ? formRendering.fieldRenderings : list, (i & 4) != 0 ? formRendering.onFormCompleted : function1, (i & 8) != 0 ? formRendering.onFormChanged : function2, (i & 16) != 0 ? formRendering.onFormFocusChanged : function3, (i & 32) != 0 ? formRendering.onFormDisplayedFieldsChanged : function4, (i & 64) != 0 ? formRendering.mapOfDisplayedForm : map, (i & 128) != 0 ? formRendering.formId : str);
    }

    public final FormState getState() {
        return this.state;
    }

    public final List<FieldRendering<T>> component2$zendesk_ui_ui_android() {
        return this.fieldRenderings;
    }

    public final Function1<List<? extends T>, Unit> component3$zendesk_ui_ui_android() {
        return this.onFormCompleted;
    }

    public final Function1<List<? extends T>, Unit> component4$zendesk_ui_ui_android() {
        return this.onFormChanged;
    }

    public final Function1<Boolean, Unit> component5$zendesk_ui_ui_android() {
        return this.onFormFocusChanged;
    }

    public final Function2<DisplayedField, String, Unit> component6$zendesk_ui_ui_android() {
        return this.onFormDisplayedFieldsChanged;
    }

    public final Map<String, DisplayedForm> component7$zendesk_ui_ui_android() {
        return this.mapOfDisplayedForm;
    }

    public final String getFormId() {
        return this.formId;
    }

    public final FormRendering<T> copy(FormState state, List<? extends FieldRendering<T>> fieldRenderings, Function1<? super List<? extends T>, Unit> onFormCompleted, Function1<? super List<? extends T>, Unit> onFormChanged, Function1<? super Boolean, Unit> onFormFocusChanged, Function2<? super DisplayedField, ? super String, Unit> onFormDisplayedFieldsChanged, Map<String, DisplayedForm> mapOfDisplayedForm, String formId) {
        Intrinsics.checkNotNullParameter(state, "state");
        Intrinsics.checkNotNullParameter(fieldRenderings, "fieldRenderings");
        Intrinsics.checkNotNullParameter(onFormCompleted, "onFormCompleted");
        Intrinsics.checkNotNullParameter(onFormChanged, "onFormChanged");
        Intrinsics.checkNotNullParameter(onFormFocusChanged, "onFormFocusChanged");
        Intrinsics.checkNotNullParameter(onFormDisplayedFieldsChanged, "onFormDisplayedFieldsChanged");
        Intrinsics.checkNotNullParameter(mapOfDisplayedForm, "mapOfDisplayedForm");
        Intrinsics.checkNotNullParameter(formId, "formId");
        return new FormRendering<>(state, fieldRenderings, onFormCompleted, onFormChanged, onFormFocusChanged, onFormDisplayedFieldsChanged, mapOfDisplayedForm, formId);
    }

    public boolean equals(Object other) {
        if (this == other) {
            return true;
        }
        if (!(other instanceof FormRendering)) {
            return false;
        }
        FormRendering formRendering = (FormRendering) other;
        return Intrinsics.areEqual(this.state, formRendering.state) && Intrinsics.areEqual(this.fieldRenderings, formRendering.fieldRenderings) && Intrinsics.areEqual(this.onFormCompleted, formRendering.onFormCompleted) && Intrinsics.areEqual(this.onFormChanged, formRendering.onFormChanged) && Intrinsics.areEqual(this.onFormFocusChanged, formRendering.onFormFocusChanged) && Intrinsics.areEqual(this.onFormDisplayedFieldsChanged, formRendering.onFormDisplayedFieldsChanged) && Intrinsics.areEqual(this.mapOfDisplayedForm, formRendering.mapOfDisplayedForm) && Intrinsics.areEqual(this.formId, formRendering.formId);
    }

    public int hashCode() {
        return (((((((((((((this.state.hashCode() * 31) + this.fieldRenderings.hashCode()) * 31) + this.onFormCompleted.hashCode()) * 31) + this.onFormChanged.hashCode()) * 31) + this.onFormFocusChanged.hashCode()) * 31) + this.onFormDisplayedFieldsChanged.hashCode()) * 31) + this.mapOfDisplayedForm.hashCode()) * 31) + this.formId.hashCode();
    }

    public String toString() {
        return "FormRendering(state=" + this.state + ", fieldRenderings=" + this.fieldRenderings + ", onFormCompleted=" + this.onFormCompleted + ", onFormChanged=" + this.onFormChanged + ", onFormFocusChanged=" + this.onFormFocusChanged + ", onFormDisplayedFieldsChanged=" + this.onFormDisplayedFieldsChanged + ", mapOfDisplayedForm=" + this.mapOfDisplayedForm + ", formId=" + this.formId + ')';
    }

    public FormRendering(FormState state, List<? extends FieldRendering<T>> fieldRenderings, Function1<? super List<? extends T>, Unit> onFormCompleted, Function1<? super List<? extends T>, Unit> onFormChanged, Function1<? super Boolean, Unit> onFormFocusChanged, Function2<? super DisplayedField, ? super String, Unit> onFormDisplayedFieldsChanged, Map<String, DisplayedForm> mapOfDisplayedForm, String formId) {
        Intrinsics.checkNotNullParameter(state, "state");
        Intrinsics.checkNotNullParameter(fieldRenderings, "fieldRenderings");
        Intrinsics.checkNotNullParameter(onFormCompleted, "onFormCompleted");
        Intrinsics.checkNotNullParameter(onFormChanged, "onFormChanged");
        Intrinsics.checkNotNullParameter(onFormFocusChanged, "onFormFocusChanged");
        Intrinsics.checkNotNullParameter(onFormDisplayedFieldsChanged, "onFormDisplayedFieldsChanged");
        Intrinsics.checkNotNullParameter(mapOfDisplayedForm, "mapOfDisplayedForm");
        Intrinsics.checkNotNullParameter(formId, "formId");
        this.state = state;
        this.fieldRenderings = fieldRenderings;
        this.onFormCompleted = onFormCompleted;
        this.onFormChanged = onFormChanged;
        this.onFormFocusChanged = onFormFocusChanged;
        this.onFormDisplayedFieldsChanged = onFormDisplayedFieldsChanged;
        this.mapOfDisplayedForm = mapOfDisplayedForm;
        this.formId = formId;
    }

    public FormRendering(FormState formState, List list, Function1 function1, Function1 function2, Function1 function3, Function2 function4, Map map, String str, int i, DefaultConstructorMarker defaultConstructorMarker) {
        this((i & 1) != 0 ? new FormState(0, 0, 0, 0, 0, 0, 0, false, false, 511, null) : formState, (i & 2) != 0 ? CollectionsKt.emptyList() : list, (i & 4) != 0 ? new Function1<List<? extends T>, Unit>() {
            public final void invoke(List<? extends T> it) {
                Intrinsics.checkNotNullParameter(it, "it");
            }

            @Override
            public Unit invoke(Object obj) {
                invoke((List) obj);
                return Unit.INSTANCE;
            }
        } : function1, (i & 8) != 0 ? new Function1<List<? extends T>, Unit>() {
            public final void invoke(List<? extends T> it) {
                Intrinsics.checkNotNullParameter(it, "it");
            }

            @Override
            public Unit invoke(Object obj) {
                invoke((List) obj);
                return Unit.INSTANCE;
            }
        } : function2, (i & 16) != 0 ? new Function1<Boolean, Unit>() {
            public final void invoke(boolean z) {
            }

            @Override
            public Unit invoke(Boolean bool) {
                invoke(bool.booleanValue());
                return Unit.INSTANCE;
            }
        } : function3, (i & 32) != 0 ? new Function2<DisplayedField, String, Unit>() {
            public final void invoke2(DisplayedField displayedField, String str2) {
                Intrinsics.checkNotNullParameter(displayedField, "<anonymous parameter 0>");
                Intrinsics.checkNotNullParameter(str2, "<anonymous parameter 1>");
            }

            @Override
            public Unit invoke(DisplayedField displayedField, String str2) {
                invoke2(displayedField, str2);
                return Unit.INSTANCE;
            }
        } : function4, (i & 64) != 0 ? new HashMap() : map, (i & 128) != 0 ? "" : str);
    }

    public final FormState getState$zendesk_ui_ui_android() {
        return this.state;
    }

    public final List<FieldRendering<T>> getFieldRenderings$zendesk_ui_ui_android() {
        return this.fieldRenderings;
    }

    public final Function1<List<? extends T>, Unit> getOnFormCompleted$zendesk_ui_ui_android() {
        return this.onFormCompleted;
    }

    public final Function1<List<? extends T>, Unit> getOnFormChanged$zendesk_ui_ui_android() {
        return this.onFormChanged;
    }

    public final Function1<Boolean, Unit> getOnFormFocusChanged$zendesk_ui_ui_android() {
        return this.onFormFocusChanged;
    }

    public final Function2<DisplayedField, String, Unit> getOnFormDisplayedFieldsChanged$zendesk_ui_ui_android() {
        return this.onFormDisplayedFieldsChanged;
    }

    public final Map<String, DisplayedForm> getMapOfDisplayedForm$zendesk_ui_ui_android() {
        return this.mapOfDisplayedForm;
    }

    public final String getFormId$zendesk_ui_ui_android() {
        return this.formId;
    }

    @Metadata(m17d1 = {"\u0000Z\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u0000\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0010\u0011\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010 \n\u0000\n\u0002\u0010\u000e\n\u0000\n\u0002\u0010%\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\u0010\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u000b\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0000\b\u0007\u0018\u0000*\u0004\b\u0001\u0010\u00012\u00020\u0002B\u0005¢\u0006\u0002\u0010\u0003J\f\u0010\u0006\u001a\b\u0012\u0004\u0012\u00028\u00010\u0005J1\u0010\u0007\u001a\b\u0012\u0004\u0012\u00028\u00010\u00002\u001e\u0010\u0007\u001a\u0010\u0012\f\b\u0001\u0012\b\u0012\u0004\u0012\u00028\u00010\t0\b\"\b\u0012\u0004\u0012\u00028\u00010\t¢\u0006\u0002\u0010\nJ \u0010\u0007\u001a\b\u0012\u0004\u0012\u00028\u00010\u00002\u0012\u0010\u0007\u001a\u000e\u0012\n\u0012\b\u0012\u0004\u0012\u00028\u00010\t0\u000bJ\u0014\u0010\f\u001a\b\u0012\u0004\u0012\u00028\u00010\u00002\u0006\u0010\f\u001a\u00020\rJ \u0010\u000e\u001a\b\u0012\u0004\u0012\u00028\u00010\u00002\u0012\u0010\u000e\u001a\u000e\u0012\u0004\u0012\u00020\r\u0012\u0004\u0012\u00020\u00100\u000fJ&\u0010\u0011\u001a\b\u0012\u0004\u0012\u00028\u00010\u00002\u0018\u0010\u0011\u001a\u0014\u0012\n\u0012\b\u0012\u0004\u0012\u00028\u00010\u000b\u0012\u0004\u0012\u00020\u00130\u0012J&\u0010\u0014\u001a\b\u0012\u0004\u0012\u00028\u00010\u00002\u0018\u0010\u0014\u001a\u0014\u0012\n\u0012\b\u0012\u0004\u0012\u00028\u00010\u000b\u0012\u0004\u0012\u00020\u00130\u0012J&\u0010\u0015\u001a\b\u0012\u0004\u0012\u00028\u00010\u00002\u0018\u0010\u0015\u001a\u0014\u0012\u0004\u0012\u00020\u0017\u0012\u0004\u0012\u00020\r\u0012\u0004\u0012\u00020\u00130\u0016J \u0010\u0018\u001a\b\u0012\u0004\u0012\u00028\u00010\u00002\u0012\u0010\u0018\u001a\u000e\u0012\u0004\u0012\u00020\u0019\u0012\u0004\u0012\u00020\u00130\u0012J \u0010\u001a\u001a\b\u0012\u0004\u0012\u00028\u00010\u00002\u0012\u0010\u001b\u001a\u000e\u0012\u0004\u0012\u00020\u001c\u0012\u0004\u0012\u00020\u001c0\u0012R\u0014\u0010\u0004\u001a\b\u0012\u0004\u0012\u00028\u00010\u0005X\u0082\u000e¢\u0006\u0002\n\u0000¨\u0006\u001d"}, m18d2 = {"Lzendesk/ui/android/conversation/form/FormRendering$Builder;", "T", "", "()V", "rendering", "Lzendesk/ui/android/conversation/form/FormRendering;", "build", "fieldRenderings", "", "Lzendesk/ui/android/conversation/form/FieldRendering;", "([Lzendesk/ui/android/conversation/form/FieldRendering;)Lzendesk/ui/android/conversation/form/FormRendering$Builder;", "", "formId", "", "mapOfDisplayedForm", "", "Lzendesk/ui/android/conversation/form/DisplayedForm;", "onFormChanged", "Lkotlin/Function1;", "", "onFormCompleted", "onFormDisplayedFieldsChanged", "Lkotlin/Function2;", "Lzendesk/ui/android/conversation/form/DisplayedField;", "onFormFocusChanged", "", "state", "stateUpdate", "Lzendesk/ui/android/conversation/form/FormState;", "zendesk.ui_ui-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    public static final class Builder<T> {
        public static final int $stable = 8;
        private FormRendering<T> rendering = new FormRendering<>(null, null, null, null, null, null, null, null, 255, null);

        public final Builder<T> state(Function1<? super FormState, FormState> stateUpdate) {
            Intrinsics.checkNotNullParameter(stateUpdate, "stateUpdate");
            FormRendering<T> formRendering = this.rendering;
            this.rendering = FormRendering.copy$default(formRendering, stateUpdate.invoke(formRendering.getState$zendesk_ui_ui_android()), null, null, null, null, null, null, null, 254, null);
            return this;
        }

        public final Builder<T> fieldRenderings(List<? extends FieldRendering<T>> fieldRenderings) {
            Intrinsics.checkNotNullParameter(fieldRenderings, "fieldRenderings");
            this.rendering = FormRendering.copy$default(this.rendering, null, CollectionsKt.toList(fieldRenderings), null, null, null, null, null, null, TrackType.TRACK_FORM_ACTION_SUBMITTED, null);
            return this;
        }

        public final Builder<T> fieldRenderings(FieldRendering<T>... fieldRenderings) {
            Intrinsics.checkNotNullParameter(fieldRenderings, "fieldRenderings");
            this.rendering = FormRendering.copy$default(this.rendering, null, ArraysKt.toList(fieldRenderings), null, null, null, null, null, null, TrackType.TRACK_FORM_ACTION_SUBMITTED, null);
            return this;
        }

        public final Builder<T> onFormCompleted(Function1<? super List<? extends T>, Unit> onFormCompleted) {
            Intrinsics.checkNotNullParameter(onFormCompleted, "onFormCompleted");
            this.rendering = FormRendering.copy$default(this.rendering, null, null, onFormCompleted, null, null, null, null, null, 251, null);
            return this;
        }

        public final Builder<T> onFormChanged(Function1<? super List<? extends T>, Unit> onFormChanged) {
            Intrinsics.checkNotNullParameter(onFormChanged, "onFormChanged");
            this.rendering = FormRendering.copy$default(this.rendering, null, null, null, onFormChanged, null, null, null, null, 247, null);
            return this;
        }

        public final Builder<T> onFormFocusChanged(Function1<? super Boolean, Unit> onFormFocusChanged) {
            Intrinsics.checkNotNullParameter(onFormFocusChanged, "onFormFocusChanged");
            this.rendering = FormRendering.copy$default(this.rendering, null, null, null, null, onFormFocusChanged, null, null, null, 239, null);
            return this;
        }

        public final Builder<T> onFormDisplayedFieldsChanged(Function2<? super DisplayedField, ? super String, Unit> onFormDisplayedFieldsChanged) {
            Intrinsics.checkNotNullParameter(onFormDisplayedFieldsChanged, "onFormDisplayedFieldsChanged");
            this.rendering = FormRendering.copy$default(this.rendering, null, null, null, null, null, onFormDisplayedFieldsChanged, null, null, 223, null);
            return this;
        }

        public final Builder<T> mapOfDisplayedForm(Map<String, DisplayedForm> mapOfDisplayedForm) {
            Intrinsics.checkNotNullParameter(mapOfDisplayedForm, "mapOfDisplayedForm");
            this.rendering = FormRendering.copy$default(this.rendering, null, null, null, null, null, null, mapOfDisplayedForm, null, 191, null);
            return this;
        }

        public final Builder<T> formId(String formId) {
            Intrinsics.checkNotNullParameter(formId, "formId");
            this.rendering = FormRendering.copy$default(this.rendering, null, null, null, null, null, null, null, formId, 127, null);
            return this;
        }

        public final FormRendering<T> build() {
            return this.rendering;
        }
    }
}
