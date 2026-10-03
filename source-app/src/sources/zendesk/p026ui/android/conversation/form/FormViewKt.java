package zendesk.p026ui.android.conversation.form;

import java.util.ArrayList;
import java.util.List;
import kotlin.Metadata;
import kotlin.NoWhenBranchMatchedException;
import kotlin.Unit;
import kotlin.collections.CollectionsKt;
import kotlin.jvm.functions.Function0;
import kotlin.jvm.functions.Function1;
import kotlin.jvm.functions.Function2;
import kotlin.jvm.internal.Intrinsics;
import net.aihelp.data.model.p005cs.ConversationMsg;
import net.aihelp.data.track.data.TrackType;
import okhttp3.internal.p011ws.WebSocketProtocol;

@Metadata(m17d1 = {"\u0000F\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0010\b\n\u0002\b\u0006\n\u0002\u0010\u000e\n\u0000\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0010\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\u0010 \n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0010\u000b\n\u0002\b\u0003\u001aF\u0010\u0000\u001a\b\u0012\u0004\u0012\u0002H\u00020\u0001\"\u0004\b\u0000\u0010\u0002*\b\u0012\u0004\u0012\u0002H\u00020\u00012\b\b\u0001\u0010\u0003\u001a\u00020\u00042\b\b\u0001\u0010\u0005\u001a\u00020\u00042\b\b\u0001\u0010\u0006\u001a\u00020\u00042\b\b\u0001\u0010\u0007\u001a\u00020\u0004H\u0002\u001aH\u0010\b\u001a\b\u0012\u0004\u0012\u0002H\u00020\u0001\"\u0004\b\u0000\u0010\u0002*\b\u0012\u0004\u0012\u0002H\u00020\u00012\u0006\u0010\t\u001a\u00020\u00042\u0006\u0010\n\u001a\u00020\u000b2\u0018\u0010\f\u001a\u0014\u0012\u0004\u0012\u00020\u000e\u0012\u0004\u0012\u00020\u000b\u0012\u0004\u0012\u00020\u000f0\rH\u0002\u001a8\u0010\u0010\u001a\b\u0012\u0004\u0012\u0002H\u00020\u0001\"\u0004\b\u0000\u0010\u0002*\b\u0012\u0004\u0012\u0002H\u00020\u00012\u0018\u0010\u0011\u001a\u0014\u0012\n\u0012\b\u0012\u0004\u0012\u00020\u00140\u0013\u0012\u0004\u0012\u00020\u000f0\u0012H\u0002\u001a,\u0010\u0015\u001a\b\u0012\u0004\u0012\u0002H\u00020\u0001\"\u0004\b\u0000\u0010\u0002*\b\u0012\u0004\u0012\u0002H\u00020\u00012\f\u0010\u0011\u001a\b\u0012\u0004\u0012\u00020\u000f0\u0016H\u0002\u001a\\\u0010\u0017\u001a\b\u0012\u0004\u0012\u0002H\u00020\u0001\"\u0004\b\u0000\u0010\u0002*\b\u0012\u0004\u0012\u0002H\u00020\u00012\u0006\u0010\t\u001a\u00020\u00042\u0018\u0010\f\u001a\u0014\u0012\u0004\u0012\u00020\u000e\u0012\u0004\u0012\u00020\u000b\u0012\u0004\u0012\u00020\u000f0\r2\u0006\u0010\n\u001a\u00020\u000b2\u0012\u0010\u0011\u001a\u000e\u0012\u0004\u0012\u0002H\u0002\u0012\u0004\u0012\u00020\u000f0\u0012H\u0002\u001a2\u0010\u0018\u001a\b\u0012\u0004\u0012\u0002H\u00020\u0001\"\u0004\b\u0000\u0010\u0002*\b\u0012\u0004\u0012\u0002H\u00020\u00012\u0012\u0010\u0019\u001a\u000e\u0012\u0004\u0012\u00020\u001a\u0012\u0004\u0012\u00020\u000f0\u0012H\u0002\u001a<\u0010\u001b\u001a\b\u0012\u0004\u0012\u0002H\u00020\u0001\"\u0004\b\u0000\u0010\u0002*\b\u0012\u0004\u0012\u0002H\u00020\u00012\b\u0010\u001c\u001a\u0004\u0018\u00010\u000e2\u0012\u0010\u0011\u001a\u000e\u0012\u0004\u0012\u0002H\u0002\u0012\u0004\u0012\u00020\u000f0\u0012H\u0002¨\u0006\u001d"}, m18d2 = {"withBorderColorOverride", "Lzendesk/ui/android/conversation/form/FieldRendering;", "T", "textColor", "", "onDangerColor", "borderColor", "focusedBorderColor", "withFieldTextPrefilled", "currentIndex", "formId", "", "onFormDisplayedFieldsChanged", "Lkotlin/Function2;", "Lzendesk/ui/android/conversation/form/DisplayedField;", "", "withSelectChangedInterceptor", "interceptor", "Lkotlin/Function1;", "", "Lzendesk/ui/android/conversation/form/SelectOption;", "withSelectCheckMarkActionInterceptor", "Lkotlin/Function0;", "withStateChangedInterceptor", "withStateFocusChanged", "onFieldFocusChanged", "", "withStateInputCached", "displayedField", "zendesk.ui_ui-android"}, m19k = 2, m20mv = {1, 9, 0}, m22xi = 48)
public final class FormViewKt {
    public static final <T> FieldRendering<T> withSelectChangedInterceptor(final FieldRendering<T> fieldRendering, final Function1<? super List<SelectOption>, Unit> function1) {
        return !(fieldRendering instanceof FieldRendering.Select) ? fieldRendering : FieldRendering.Select.copy$default((FieldRendering.Select) fieldRendering, null, null, new Function1<List<? extends SelectOption>, Unit>() {
            {
                super(1);
            }

            @Override
            public Unit invoke(List<? extends SelectOption> list) {
                invoke2((List<SelectOption>) list);
                return Unit.INSTANCE;
            }

            public final void invoke2(List<SelectOption> selectOptions) {
                Intrinsics.checkNotNullParameter(selectOptions, "selectOptions");
                function1.invoke(selectOptions);
                ((FieldRendering.Select) fieldRendering).getOnSelected$zendesk_ui_ui_android().invoke(selectOptions);
            }
        }, null, null, null, 0, 123, null);
    }

    public static final <T> FieldRendering<T> withSelectCheckMarkActionInterceptor(FieldRendering<T> fieldRendering, final Function0<Unit> function0) {
        return !(fieldRendering instanceof FieldRendering.Select) ? fieldRendering : FieldRendering.Select.copy$default((FieldRendering.Select) fieldRendering, null, null, null, null, null, new Function0<Unit>() {
            {
                super(0);
            }

            @Override
            public Unit invoke() {
                invoke2();
                return Unit.INSTANCE;
            }

            public final void invoke2() {
                function0.invoke();
            }
        }, 0, 95, null);
    }

    public static final <T> FieldRendering<T> withStateFocusChanged(FieldRendering<T> fieldRendering, final Function1<? super Boolean, Unit> function1) {
        if (fieldRendering instanceof FieldRendering.Text) {
            return FieldRendering.Text.copy$default((FieldRendering.Text) fieldRendering, null, null, null, null, new Function1<Boolean, Unit>() {
                {
                    super(1);
                }

                @Override
                public Unit invoke(Boolean bool) {
                    invoke(bool.booleanValue());
                    return Unit.INSTANCE;
                }

                public final void invoke(boolean z) {
                    function1.invoke(Boolean.valueOf(z));
                }
            }, 0, 47, null);
        }
        if (fieldRendering instanceof FieldRendering.Email) {
            return FieldRendering.Email.copy$default((FieldRendering.Email) fieldRendering, null, null, null, null, new Function1<Boolean, Unit>() {
                {
                    super(1);
                }

                @Override
                public Unit invoke(Boolean bool) {
                    invoke(bool.booleanValue());
                    return Unit.INSTANCE;
                }

                public final void invoke(boolean z) {
                    function1.invoke(Boolean.valueOf(z));
                }
            }, 0, 47, null);
        }
        if (fieldRendering instanceof FieldRendering.Select) {
            return FieldRendering.Select.copy$default((FieldRendering.Select) fieldRendering, null, null, null, null, new Function1<Boolean, Unit>() {
                {
                    super(1);
                }

                @Override
                public Unit invoke(Boolean bool) {
                    invoke(bool.booleanValue());
                    return Unit.INSTANCE;
                }

                public final void invoke(boolean z) {
                    function1.invoke(Boolean.valueOf(z));
                }
            }, null, 0, ConversationMsg.TYPE_ADMIN_TYPING, null);
        }
        throw new NoWhenBranchMatchedException();
    }

    public static final <T> FieldRendering<T> withFieldTextPrefilled(FieldRendering<T> fieldRendering, int i, String str, Function2<? super DisplayedField, ? super String, Unit> function2) {
        if (fieldRendering instanceof FieldRendering.Text) {
            FieldRendering.Text text = (FieldRendering.Text) fieldRendering;
            String text2 = text.getState().getText();
            if (text2 != null && text2.length() != 0) {
                function2.invoke(new DisplayedField(i, text.getState().getText()), str);
            }
        }
        return fieldRendering;
    }

    public static final <T> FieldRendering<T> withStateChangedInterceptor(final FieldRendering<T> fieldRendering, final int i, final Function2<? super DisplayedField, ? super String, Unit> function2, final String str, final Function1<? super T, Unit> function1) {
        if (fieldRendering instanceof FieldRendering.Text) {
            return FieldRendering.Text.copy$default((FieldRendering.Text) fieldRendering, null, new Function1<FieldState.Text, Unit>() {
                {
                    super(1);
                }

                @Override
                public Unit invoke(FieldState.Text text) {
                    invoke2(text);
                    return Unit.INSTANCE;
                }

                public final void invoke2(FieldState.Text textState) {
                    Intrinsics.checkNotNullParameter(textState, "textState");
                    function1.invoke((T) ((FieldRendering.Text) fieldRendering).getNormalize$zendesk_ui_ui_android().invoke(textState));
                    ((FieldRendering.Text) fieldRendering).getOnStateChanged().invoke(textState);
                    function2.invoke(new DisplayedField(i, textState.getText()), str);
                }
            }, null, null, null, 0, 61, null);
        }
        if (fieldRendering instanceof FieldRendering.Email) {
            return FieldRendering.Email.copy$default((FieldRendering.Email) fieldRendering, null, new Function1<FieldState.Email, Unit>() {
                {
                    super(1);
                }

                @Override
                public Unit invoke(FieldState.Email email) {
                    invoke2(email);
                    return Unit.INSTANCE;
                }

                public final void invoke2(FieldState.Email emailState) {
                    Intrinsics.checkNotNullParameter(emailState, "emailState");
                    function1.invoke((T) ((FieldRendering.Email) fieldRendering).getNormalize$zendesk_ui_ui_android().invoke(emailState));
                    ((FieldRendering.Email) fieldRendering).getOnStateChanged().invoke(emailState);
                    function2.invoke(new DisplayedField(i, emailState.getEmail()), str);
                }
            }, null, null, null, 0, 61, null);
        }
        if (fieldRendering instanceof FieldRendering.Select) {
            return FieldRendering.Select.copy$default((FieldRendering.Select) fieldRendering, null, new Function1<FieldState.Select, Unit>() {
                {
                    super(1);
                }

                @Override
                public Unit invoke(FieldState.Select select) {
                    invoke2(select);
                    return Unit.INSTANCE;
                }

                public final void invoke2(FieldState.Select selectState) {
                    Intrinsics.checkNotNullParameter(selectState, "selectState");
                    function1.invoke((T) ((FieldRendering.Select) fieldRendering).getNormalize$zendesk_ui_ui_android().invoke(selectState));
                    ((FieldRendering.Select) fieldRendering).getOnStateChanged().invoke(selectState);
                    function2.invoke(new DisplayedField(i, ((SelectOption) CollectionsKt.first((List) selectState.getSelect())).getId()), str);
                }
            }, null, null, null, null, 0, 125, null);
        }
        throw new NoWhenBranchMatchedException();
    }

    public static final <T> FieldRendering<T> withBorderColorOverride(FieldRendering<T> fieldRendering, int i, int i2, int i3, int i4) {
        if (fieldRendering instanceof FieldRendering.Text) {
            FieldRendering.Text text = (FieldRendering.Text) fieldRendering;
            return FieldRendering.Text.copy$default(text, FieldState.Text.copy$default(text.getState(), null, 0, 0, null, null, i2, i3, i4, i, 31, null), null, null, null, null, 0, 62, null);
        }
        if (fieldRendering instanceof FieldRendering.Email) {
            FieldRendering.Email email = (FieldRendering.Email) fieldRendering;
            return FieldRendering.Email.copy$default(email, FieldState.Email.copy$default(email.getState(), null, null, null, i2, i3, i4, i, 7, null), null, null, null, null, 0, 62, null);
        }
        if (!(fieldRendering instanceof FieldRendering.Select)) {
            throw new NoWhenBranchMatchedException();
        }
        FieldRendering.Select select = (FieldRendering.Select) fieldRendering;
        return FieldRendering.Select.copy$default(select, FieldState.Select.copy$default(select.getState(), null, null, null, null, i2, i3, i4, i, 15, null), null, null, null, null, null, 0, WebSocketProtocol.PAYLOAD_SHORT, null);
    }

    public static final <T> FieldRendering<T> withStateInputCached(FieldRendering<T> fieldRendering, DisplayedField displayedField, Function1<? super T, Unit> function1) {
        if (displayedField == null || displayedField.getValue() == null) {
            return fieldRendering;
        }
        if (fieldRendering instanceof FieldRendering.Text) {
            FieldRendering.Text text = (FieldRendering.Text) fieldRendering;
            FieldRendering.Text textCopy$default = FieldRendering.Text.copy$default(text, FieldState.Text.copy$default(text.getState(), displayedField.getValue(), 0, 0, null, null, 0, 0, 0, 0, 510, null), null, null, null, null, 0, 62, null);
            function1.invoke(text.getNormalize$zendesk_ui_ui_android().invoke(textCopy$default.getState()));
            return textCopy$default;
        }
        if (fieldRendering instanceof FieldRendering.Email) {
            FieldRendering.Email email = (FieldRendering.Email) fieldRendering;
            FieldRendering.Email emailCopy$default = FieldRendering.Email.copy$default(email, FieldState.Email.copy$default(email.getState(), displayedField.getValue(), null, null, 0, 0, 0, 0, WebSocketProtocol.PAYLOAD_SHORT, null), null, null, null, null, 0, 62, null);
            function1.invoke(email.getNormalize$zendesk_ui_ui_android().invoke(emailCopy$default.getState()));
            return emailCopy$default;
        }
        if (!(fieldRendering instanceof FieldRendering.Select)) {
            throw new NoWhenBranchMatchedException();
        }
        FieldRendering.Select select = (FieldRendering.Select) fieldRendering;
        FieldState.Select state = select.getState();
        List<SelectOption> options = select.getState().getOptions();
        ArrayList arrayList = new ArrayList();
        for (T t : options) {
            if (Intrinsics.areEqual(((SelectOption) t).getId(), displayedField.getValue())) {
                arrayList.add(t);
            }
        }
        FieldRendering.Select selectCopy$default = FieldRendering.Select.copy$default(select, FieldState.Select.copy$default(state, null, arrayList, null, null, 0, 0, 0, 0, TrackType.TRACK_FORM_ACTION_SUBMITTED, null), null, null, null, null, null, 0, WebSocketProtocol.PAYLOAD_SHORT, null);
        function1.invoke(select.getNormalize$zendesk_ui_ui_android().invoke(selectCopy$default.getState()));
        return selectCopy$default;
    }
}
