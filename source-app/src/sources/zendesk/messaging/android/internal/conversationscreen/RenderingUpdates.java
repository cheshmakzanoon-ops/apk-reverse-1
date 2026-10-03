package zendesk.messaging.android.internal.conversationscreen;

import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import kotlin.Metadata;
import kotlin.Unit;
import kotlin.collections.CollectionsKt;
import kotlin.jvm.functions.Function1;
import kotlin.jvm.functions.Function2;
import kotlin.jvm.internal.Intrinsics;
import zendesk.conversationkit.android.model.Field;
import zendesk.conversationkit.android.model.FieldOption;
import zendesk.p026ui.android.conversation.form.DisplayedField;
import zendesk.p026ui.android.conversation.form.DisplayedForm;
import zendesk.p026ui.android.conversation.form.FieldRendering;
import zendesk.p026ui.android.conversation.form.FieldState;
import zendesk.p026ui.android.conversation.form.FormRendering;
import zendesk.p026ui.android.conversation.form.FormResponseRendering;
import zendesk.p026ui.android.conversation.form.FormResponseState;
import zendesk.p026ui.android.conversation.form.FormState;
import zendesk.p026ui.android.conversation.form.SelectOption;

@Metadata(m17d1 = {"\u0000^\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010 \n\u0000\n\u0002\u0010\u0002\n\u0000\n\u0002\u0010\u000b\n\u0000\n\u0002\u0010\b\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0010\u000e\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010%\n\u0002\u0018\u0002\n\u0002\b\t\n\u0002\u0018\u0002\n\u0002\b\u0002\bÀ\u0002\u0018\u00002\u00020\u0001B\u0007\b\u0002¢\u0006\u0002\u0010\u0002Jú\u0001\u0010\u0003\u001a*\u0012\n\u0012\b\u0012\u0004\u0012\u00020\u00060\u0005\u0012\n\u0012\b\u0012\u0004\u0012\u00020\u00060\u00050\u0004j\u000e\u0012\n\u0012\b\u0012\u0004\u0012\u00020\u00060\u0005`\u00072\f\u0010\b\u001a\b\u0012\u0004\u0012\u00020\u00060\t2\u0018\u0010\n\u001a\u0014\u0012\n\u0012\b\u0012\u0004\u0012\u00020\u00060\t\u0012\u0004\u0012\u00020\u000b0\u00042\u0012\u0010\f\u001a\u000e\u0012\u0004\u0012\u00020\r\u0012\u0004\u0012\u00020\u000b0\u00042\b\b\u0001\u0010\u000e\u001a\u00020\u000f2\u0006\u0010\u0010\u001a\u00020\r2\u001c\u0010\u0011\u001a\u0018\u0012\u0004\u0012\u00020\u0013\u0012\u0004\u0012\u00020\u0014\u0012\u0004\u0012\u00020\u000b0\u0012j\u0002`\u00152\u0012\u0010\u0016\u001a\u000e\u0012\u0004\u0012\u00020\u0014\u0012\u0004\u0012\u00020\u00180\u00172\u0006\u0010\u0019\u001a\u00020\u00142\b\b\u0001\u0010\u001a\u001a\u00020\u000f2\b\b\u0001\u0010\u001b\u001a\u00020\u000f2\b\b\u0001\u0010\u001c\u001a\u00020\u000f2\b\b\u0001\u0010\u001d\u001a\u00020\u000f2\b\b\u0001\u0010\u001e\u001a\u00020\u000f2\b\b\u0001\u0010\u001f\u001a\u00020\u000f2\u0006\u0010 \u001a\u00020\rJH\u0010!\u001a\u0018\u0012\u0004\u0012\u00020\"\u0012\u0004\u0012\u00020\"0\u0004j\b\u0012\u0004\u0012\u00020\"`\u00072\f\u0010\b\u001a\b\u0012\u0004\u0012\u00020\u00060\t2\b\b\u0001\u0010#\u001a\u00020\u000f2\b\b\u0001\u0010\u001f\u001a\u00020\u000f2\b\b\u0001\u0010\u001e\u001a\u00020\u000f¨\u0006$"}, m18d2 = {"Lzendesk/messaging/android/internal/conversationscreen/RenderingUpdates;", "", "()V", "formRenderingUpdate", "Lkotlin/Function1;", "Lzendesk/ui/android/conversation/form/FormRendering;", "Lzendesk/conversationkit/android/model/Field;", "Lzendesk/messaging/android/internal/conversationscreen/RenderingUpdate;", "fields", "", "onFormCompleted", "", "onFormFocusChanged", "", "colorAccent", "", "pending", "onFormDisplayedFieldsChanged", "Lkotlin/Function2;", "Lzendesk/ui/android/conversation/form/DisplayedField;", "", "Lzendesk/messaging/android/internal/conversationscreen/messagelog/OnFormDisplayedFieldsChanged;", "mapOfDisplayedForm", "", "Lzendesk/ui/android/conversation/form/DisplayedForm;", "formId", "onActionColor", "onDangerColor", "focusedFieldBorderColor", "fieldBorderColor", "textColor", "backgroundColor", "hasFailed", "formResponseRenderingUpdate", "Lzendesk/ui/android/conversation/form/FormResponseRendering;", "borderColor", "zendesk.messaging_messaging-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
public final class RenderingUpdates {
    public static final RenderingUpdates INSTANCE = new RenderingUpdates();

    private RenderingUpdates() {
    }

    public final Function1<FormRendering<Field>, FormRendering<Field>> formRenderingUpdate(final List<? extends Field> fields, final Function1<? super List<? extends Field>, Unit> onFormCompleted, final Function1<? super Boolean, Unit> onFormFocusChanged, final int colorAccent, final boolean pending, final Function2<? super DisplayedField, ? super String, Unit> onFormDisplayedFieldsChanged, final Map<String, DisplayedForm> mapOfDisplayedForm, final String formId, final int onActionColor, final int onDangerColor, final int focusedFieldBorderColor, final int fieldBorderColor, final int textColor, final int backgroundColor, final boolean hasFailed) {
        Intrinsics.checkNotNullParameter(fields, "fields");
        Intrinsics.checkNotNullParameter(onFormCompleted, "onFormCompleted");
        Intrinsics.checkNotNullParameter(onFormFocusChanged, "onFormFocusChanged");
        Intrinsics.checkNotNullParameter(onFormDisplayedFieldsChanged, "onFormDisplayedFieldsChanged");
        Intrinsics.checkNotNullParameter(mapOfDisplayedForm, "mapOfDisplayedForm");
        Intrinsics.checkNotNullParameter(formId, "formId");
        return new Function1<FormRendering<Field>, FormRendering<Field>>() {
            {
                super(1);
            }

            @Override
            public final FormRendering<Field> invoke(FormRendering<Field> it) {
                FieldRendering.Select selectBuild;
                Intrinsics.checkNotNullParameter(it, "it");
                FormRendering.Builder builder = new FormRendering.Builder();
                final int i = colorAccent;
                final int i2 = onDangerColor;
                final int i3 = focusedFieldBorderColor;
                final int i4 = fieldBorderColor;
                final int i5 = onActionColor;
                final int i6 = textColor;
                final int i7 = backgroundColor;
                final boolean z = pending;
                final boolean z2 = hasFailed;
                FormRendering.Builder builderState = builder.state(new Function1<FormState, FormState>() {
                    {
                        super(1);
                    }

                    @Override
                    public final FormState invoke(FormState state) {
                        Intrinsics.checkNotNullParameter(state, "state");
                        return state.copy(i, i2, i3, i4, i5, i6, i7, z, z2);
                    }
                });
                List<Field> list = fields;
                ArrayList arrayList = new ArrayList();
                for (final Field field : list) {
                    if (field instanceof Field.Text) {
                        selectBuild = new FieldRendering.Text.Builder(new Function1<FieldState.Text, Field>() {
                            {
                                super(1);
                            }

                            @Override
                            public final Field invoke(FieldState.Text state) {
                                Intrinsics.checkNotNullParameter(state, "state");
                                Field.Text text = (Field.Text) field;
                                String text2 = state.getText();
                                if (text2 == null) {
                                    text2 = "";
                                }
                                return Field.Text.copy$default(text, null, null, null, null, 0, 0, text2, 63, null);
                            }
                        }).state(new Function1<FieldState.Text, FieldState.Text>() {
                            {
                                super(1);
                            }

                            @Override
                            public final FieldState.Text invoke(FieldState.Text it2) {
                                Intrinsics.checkNotNullParameter(it2, "it");
                                return new FieldState.Text.Builder().minLength(((Field.Text) field).getMinSize()).maxLength(((Field.Text) field).getMaxSize()).placeholder(field.getPlaceholder()).label(field.getLabel()).text(((Field.Text) field).getText()).getState();
                            }
                        }).inputType(Intrinsics.areEqual(field.getName(), Field.SYSTEM_FIELD_NAME) ? 532481 : 16385).build();
                    } else if (field instanceof Field.Email) {
                        selectBuild = new FieldRendering.Email.Builder(new Function1<FieldState.Email, Field>() {
                            {
                                super(1);
                            }

                            @Override
                            public final Field invoke(FieldState.Email state) {
                                Intrinsics.checkNotNullParameter(state, "state");
                                Field.Email email = (Field.Email) field;
                                String email2 = state.getEmail();
                                if (email2 == null) {
                                    email2 = "";
                                }
                                return Field.Email.copy$default(email, null, null, null, null, email2, 15, null);
                            }
                        }).state(new Function1<FieldState.Email, FieldState.Email>() {
                            {
                                super(1);
                            }

                            @Override
                            public final FieldState.Email invoke(FieldState.Email it2) {
                                Intrinsics.checkNotNullParameter(it2, "it");
                                return new FieldState.Email.Builder().label(field.getLabel()).placeholder(field.getPlaceholder()).email(((Field.Email) field).getEmail()).getState();
                            }
                        }).build();
                    } else {
                        selectBuild = field instanceof Field.Select ? new FieldRendering.Select.Builder(new Function1<FieldState.Select, Field>() {
                            {
                                super(1);
                            }

                            @Override
                            public final Field invoke(FieldState.Select state) {
                                Intrinsics.checkNotNullParameter(state, "state");
                                Field field2 = field;
                                Field.Select select = (Field.Select) field2;
                                List<FieldOption> options = ((Field.Select) field2).getOptions();
                                ArrayList arrayList2 = new ArrayList();
                                for (Object obj : options) {
                                    FieldOption fieldOption = (FieldOption) obj;
                                    List<SelectOption> select2 = state.getSelect();
                                    ArrayList arrayList3 = new ArrayList(CollectionsKt.collectionSizeOrDefault(select2, 10));
                                    Iterator<T> it2 = select2.iterator();
                                    while (it2.hasNext()) {
                                        arrayList3.add(((SelectOption) it2.next()).getId());
                                    }
                                    if (arrayList3.contains(fieldOption.getName())) {
                                        arrayList2.add(obj);
                                    }
                                }
                                return Field.Select.copy$default(select, null, null, null, null, null, 0, arrayList2, 63, null);
                            }
                        }).state(new Function1<FieldState.Select, FieldState.Select>() {
                            {
                                super(1);
                            }

                            @Override
                            public final FieldState.Select invoke(FieldState.Select it2) {
                                Intrinsics.checkNotNullParameter(it2, "it");
                                FieldState.Select.Builder builderPlaceholder = new FieldState.Select.Builder().label(field.getLabel()).placeholder(field.getPlaceholder());
                                List<FieldOption> options = ((Field.Select) field).getOptions();
                                ArrayList arrayList2 = new ArrayList(CollectionsKt.collectionSizeOrDefault(options, 10));
                                for (FieldOption fieldOption : options) {
                                    arrayList2.add(new SelectOption(fieldOption.getName(), fieldOption.getLabel()));
                                }
                                FieldState.Select.Builder builderOptions = builderPlaceholder.options(arrayList2);
                                List<FieldOption> select = ((Field.Select) field).getSelect();
                                ArrayList arrayList3 = new ArrayList(CollectionsKt.collectionSizeOrDefault(select, 10));
                                for (FieldOption fieldOption2 : select) {
                                    arrayList3.add(new SelectOption(fieldOption2.getName(), fieldOption2.getLabel()));
                                }
                                return builderOptions.select(arrayList3).getState();
                            }
                        }).build() : null;
                    }
                    if (selectBuild != null) {
                        arrayList.add(selectBuild);
                    }
                }
                return builderState.fieldRenderings(arrayList).onFormCompleted(onFormCompleted).onFormFocusChanged(onFormFocusChanged).onFormDisplayedFieldsChanged(onFormDisplayedFieldsChanged).mapOfDisplayedForm(mapOfDisplayedForm).formId(formId).build();
            }
        };
    }

    public final Function1<FormResponseRendering, FormResponseRendering> formResponseRenderingUpdate(final List<? extends Field> fields, final int borderColor, final int backgroundColor, final int textColor) {
        Intrinsics.checkNotNullParameter(fields, "fields");
        return new Function1<FormResponseRendering, FormResponseRendering>() {
            {
                super(1);
            }

            @Override
            public final FormResponseRendering invoke(FormResponseRendering it) {
                Intrinsics.checkNotNullParameter(it, "it");
                FormResponseRendering.Builder builder = new FormResponseRendering.Builder();
                final List<Field> list = fields;
                final int i = textColor;
                final int i2 = backgroundColor;
                final int i3 = borderColor;
                return builder.state(new Function1<FormResponseState, FormResponseState>() {
                    {
                        super(1);
                    }

                    @Override
                    public final FormResponseState invoke(FormResponseState state) {
                        Intrinsics.checkNotNullParameter(state, "state");
                        List<Field> list2 = list;
                        ArrayList arrayList = new ArrayList(CollectionsKt.collectionSizeOrDefault(list2, 10));
                        Iterator<T> it2 = list2.iterator();
                        while (it2.hasNext()) {
                            arrayList.add(RenderingUpdatesKt.toFieldResponseState((Field) it2.next()));
                        }
                        return state.copy(i, i2, i3, arrayList);
                    }
                }).build();
            }
        };
    }
}
