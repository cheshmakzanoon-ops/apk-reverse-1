package androidx.compose.foundation.text.input.internal.selection;

import androidx.compose.foundation.contextmenu.ContextMenuScope;
import androidx.compose.foundation.contextmenu.ContextMenuState;
import androidx.compose.foundation.contextmenu.ContextMenuState_androidKt;
import androidx.compose.foundation.text.ContextMenu_androidKt;
import androidx.compose.foundation.text.TextContextMenuItems;
import kotlin.Metadata;
import kotlin.Unit;
import kotlin.jvm.functions.Function0;
import kotlin.jvm.functions.Function1;

@Metadata(d1 = {"\u0000\u001e\n\u0000\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0010\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\u001a%\u0010\u0000\u001a\u0013\u0012\u0004\u0012\u00020\u0002\u0012\u0004\u0012\u00020\u00030\u0001¢\u0006\u0002\b\u0004*\u00020\u00052\u0006\u0010\u0006\u001a\u00020\u0007H\u0000¨\u0006\b"}, d2 = {"contextMenuBuilder", "Lkotlin/Function1;", "Landroidx/compose/foundation/contextmenu/ContextMenuScope;", "", "Lkotlin/ExtensionFunctionType;", "Landroidx/compose/foundation/text/input/internal/selection/TextFieldSelectionState;", "state", "Landroidx/compose/foundation/contextmenu/ContextMenuState;", "foundation_release"}, k = 2, mv = {1, 8, 0}, xi = 48)
public final class TextFieldSelectionState_androidKt {
    public static final Function1<ContextMenuScope, Unit> contextMenuBuilder(final TextFieldSelectionState textFieldSelectionState, final ContextMenuState contextMenuState) {
        return new Function1<ContextMenuScope, Unit>() {
            {
                super(1);
            }

            public Object invoke(Object obj) {
                invoke((ContextMenuScope) obj);
                return Unit.INSTANCE;
            }

            public final void invoke(ContextMenuScope contextMenuScope) {
                final ContextMenuState contextMenuState2 = contextMenuState;
                TextContextMenuItems textContextMenuItems = TextContextMenuItems.Cut;
                boolean zCanCut = textFieldSelectionState.canCut();
                final TextFieldSelectionState textFieldSelectionState2 = textFieldSelectionState;
                ContextMenuScope.item$default(contextMenuScope, new ContextMenu_androidKt.C08021(textContextMenuItems), null, zCanCut, null, new Function0<Unit>() {
                    {
                        super(0);
                    }

                    public Object invoke() {
                        m1802invoke();
                        return Unit.INSTANCE;
                    }

                    public final void m1802invoke() {
                        textFieldSelectionState2.cut();
                        ContextMenuState_androidKt.close(contextMenuState2);
                    }
                }, 10, null);
                final ContextMenuState contextMenuState3 = contextMenuState;
                TextContextMenuItems textContextMenuItems2 = TextContextMenuItems.Copy;
                boolean zCanCopy = textFieldSelectionState.canCopy();
                final TextFieldSelectionState textFieldSelectionState3 = textFieldSelectionState;
                ContextMenuScope.item$default(contextMenuScope, new ContextMenu_androidKt.C08021(textContextMenuItems2), null, zCanCopy, null, new Function0<Unit>() {
                    {
                        super(0);
                    }

                    public Object invoke() {
                        m1803invoke();
                        return Unit.INSTANCE;
                    }

                    public final void m1803invoke() {
                        textFieldSelectionState3.copy(false);
                        ContextMenuState_androidKt.close(contextMenuState3);
                    }
                }, 10, null);
                final ContextMenuState contextMenuState4 = contextMenuState;
                TextContextMenuItems textContextMenuItems3 = TextContextMenuItems.Paste;
                boolean zCanPaste = textFieldSelectionState.canPaste();
                final TextFieldSelectionState textFieldSelectionState4 = textFieldSelectionState;
                ContextMenuScope.item$default(contextMenuScope, new ContextMenu_androidKt.C08021(textContextMenuItems3), null, zCanPaste, null, new Function0<Unit>() {
                    {
                        super(0);
                    }

                    public Object invoke() {
                        m1804invoke();
                        return Unit.INSTANCE;
                    }

                    public final void m1804invoke() {
                        textFieldSelectionState4.paste();
                        ContextMenuState_androidKt.close(contextMenuState4);
                    }
                }, 10, null);
                final ContextMenuState contextMenuState5 = contextMenuState;
                TextContextMenuItems textContextMenuItems4 = TextContextMenuItems.SelectAll;
                boolean zCanSelectAll = textFieldSelectionState.canSelectAll();
                final TextFieldSelectionState textFieldSelectionState5 = textFieldSelectionState;
                ContextMenuScope.item$default(contextMenuScope, new ContextMenu_androidKt.C08021(textContextMenuItems4), null, zCanSelectAll, null, new Function0<Unit>() {
                    {
                        super(0);
                    }

                    public Object invoke() {
                        m1805invoke();
                        return Unit.INSTANCE;
                    }

                    public final void m1805invoke() {
                        textFieldSelectionState5.selectAll();
                        ContextMenuState_androidKt.close(contextMenuState5);
                    }
                }, 10, null);
            }
        };
    }
}
