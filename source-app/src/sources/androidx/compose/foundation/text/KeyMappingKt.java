package androidx.compose.foundation.text;

import androidx.compose.p002ui.input.key.Key;
import androidx.compose.p002ui.input.key.KeyEvent;
import androidx.compose.p002ui.input.key.KeyEvent_androidKt;
import kotlin.Metadata;
import kotlin.jvm.functions.Function1;
import kotlin.jvm.internal.PropertyReference1Impl;

@Metadata(d1 = {"\u0000\u0018\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0004\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0010\u000b\n\u0000\u001a\u001c\u0010\u0004\u001a\u00020\u00012\u0012\u0010\u0005\u001a\u000e\u0012\u0004\u0012\u00020\u0007\u0012\u0004\u0012\u00020\b0\u0006H\u0000\"\u0014\u0010\u0000\u001a\u00020\u0001X\u0080\u0004¢\u0006\b\n\u0000\u001a\u0004\b\u0002\u0010\u0003¨\u0006\t"}, d2 = {"defaultKeyMapping", "Landroidx/compose/foundation/text/KeyMapping;", "getDefaultKeyMapping", "()Landroidx/compose/foundation/text/KeyMapping;", "commonKeyMapping", "shortcutModifier", "Lkotlin/Function1;", "Landroidx/compose/ui/input/key/KeyEvent;", "", "foundation_release"}, k = 2, mv = {1, 8, 0}, xi = 48)
public final class KeyMappingKt {
    private static final KeyMapping defaultKeyMapping;

    public static final KeyMapping commonKeyMapping(final Function1<? super KeyEvent, Boolean> function1) {
        return new KeyMapping() {
            @Override
            public KeyCommand mo1457mapZmokQxo(android.view.KeyEvent event) {
                if (((Boolean) function1.invoke(KeyEvent.m5680boximpl(event))).booleanValue() && KeyEvent_androidKt.m5703isShiftPressedZmokQxo(event)) {
                    if (Key.m5389equalsimpl0(KeyEvent_androidKt.m5697getKeyZmokQxo(event), MappedKeys.INSTANCE.m1515getZEK5gGoQ())) {
                        return KeyCommand.REDO;
                    }
                    return null;
                }
                if (((Boolean) function1.invoke(KeyEvent.m5680boximpl(event))).booleanValue()) {
                    long jM5697getKeyZmokQxo = KeyEvent_androidKt.m5697getKeyZmokQxo(event);
                    if (Key.m5389equalsimpl0(jM5697getKeyZmokQxo, MappedKeys.INSTANCE.m1495getCEK5gGoQ()) ? true : Key.m5389equalsimpl0(jM5697getKeyZmokQxo, MappedKeys.INSTANCE.m1505getInsertEK5gGoQ())) {
                        return KeyCommand.COPY;
                    }
                    if (Key.m5389equalsimpl0(jM5697getKeyZmokQxo, MappedKeys.INSTANCE.m1512getVEK5gGoQ())) {
                        return KeyCommand.PASTE;
                    }
                    if (Key.m5389equalsimpl0(jM5697getKeyZmokQxo, MappedKeys.INSTANCE.m1513getXEK5gGoQ())) {
                        return KeyCommand.CUT;
                    }
                    if (Key.m5389equalsimpl0(jM5697getKeyZmokQxo, MappedKeys.INSTANCE.m1492getAEK5gGoQ())) {
                        return KeyCommand.SELECT_ALL;
                    }
                    if (Key.m5389equalsimpl0(jM5697getKeyZmokQxo, MappedKeys.INSTANCE.m1514getYEK5gGoQ())) {
                        return KeyCommand.REDO;
                    }
                    if (Key.m5389equalsimpl0(jM5697getKeyZmokQxo, MappedKeys.INSTANCE.m1515getZEK5gGoQ())) {
                        return KeyCommand.UNDO;
                    }
                    return null;
                }
                if (KeyEvent_androidKt.m5701isCtrlPressedZmokQxo(event)) {
                    return null;
                }
                if (KeyEvent_androidKt.m5703isShiftPressedZmokQxo(event)) {
                    long jM5697getKeyZmokQxo2 = KeyEvent_androidKt.m5697getKeyZmokQxo(event);
                    if (Key.m5389equalsimpl0(jM5697getKeyZmokQxo2, MappedKeys.INSTANCE.m1500getDirectionLeftEK5gGoQ())) {
                        return KeyCommand.SELECT_LEFT_CHAR;
                    }
                    if (Key.m5389equalsimpl0(jM5697getKeyZmokQxo2, MappedKeys.INSTANCE.m1501getDirectionRightEK5gGoQ())) {
                        return KeyCommand.SELECT_RIGHT_CHAR;
                    }
                    if (Key.m5389equalsimpl0(jM5697getKeyZmokQxo2, MappedKeys.INSTANCE.m1502getDirectionUpEK5gGoQ())) {
                        return KeyCommand.SELECT_UP;
                    }
                    if (Key.m5389equalsimpl0(jM5697getKeyZmokQxo2, MappedKeys.INSTANCE.m1499getDirectionDownEK5gGoQ())) {
                        return KeyCommand.SELECT_DOWN;
                    }
                    if (Key.m5389equalsimpl0(jM5697getKeyZmokQxo2, MappedKeys.INSTANCE.m1509getPageUpEK5gGoQ())) {
                        return KeyCommand.SELECT_PAGE_UP;
                    }
                    if (Key.m5389equalsimpl0(jM5697getKeyZmokQxo2, MappedKeys.INSTANCE.m1508getPageDownEK5gGoQ())) {
                        return KeyCommand.SELECT_PAGE_DOWN;
                    }
                    if (Key.m5389equalsimpl0(jM5697getKeyZmokQxo2, MappedKeys.INSTANCE.m1507getMoveHomeEK5gGoQ())) {
                        return KeyCommand.SELECT_LINE_START;
                    }
                    if (Key.m5389equalsimpl0(jM5697getKeyZmokQxo2, MappedKeys.INSTANCE.m1506getMoveEndEK5gGoQ())) {
                        return KeyCommand.SELECT_LINE_END;
                    }
                    if (Key.m5389equalsimpl0(jM5697getKeyZmokQxo2, MappedKeys.INSTANCE.m1505getInsertEK5gGoQ())) {
                        return KeyCommand.PASTE;
                    }
                    return null;
                }
                long jM5697getKeyZmokQxo3 = KeyEvent_androidKt.m5697getKeyZmokQxo(event);
                if (Key.m5389equalsimpl0(jM5697getKeyZmokQxo3, MappedKeys.INSTANCE.m1500getDirectionLeftEK5gGoQ())) {
                    return KeyCommand.LEFT_CHAR;
                }
                if (Key.m5389equalsimpl0(jM5697getKeyZmokQxo3, MappedKeys.INSTANCE.m1501getDirectionRightEK5gGoQ())) {
                    return KeyCommand.RIGHT_CHAR;
                }
                if (Key.m5389equalsimpl0(jM5697getKeyZmokQxo3, MappedKeys.INSTANCE.m1502getDirectionUpEK5gGoQ())) {
                    return KeyCommand.UP;
                }
                if (Key.m5389equalsimpl0(jM5697getKeyZmokQxo3, MappedKeys.INSTANCE.m1499getDirectionDownEK5gGoQ())) {
                    return KeyCommand.DOWN;
                }
                if (Key.m5389equalsimpl0(jM5697getKeyZmokQxo3, MappedKeys.INSTANCE.m1509getPageUpEK5gGoQ())) {
                    return KeyCommand.PAGE_UP;
                }
                if (Key.m5389equalsimpl0(jM5697getKeyZmokQxo3, MappedKeys.INSTANCE.m1508getPageDownEK5gGoQ())) {
                    return KeyCommand.PAGE_DOWN;
                }
                if (Key.m5389equalsimpl0(jM5697getKeyZmokQxo3, MappedKeys.INSTANCE.m1507getMoveHomeEK5gGoQ())) {
                    return KeyCommand.LINE_START;
                }
                if (Key.m5389equalsimpl0(jM5697getKeyZmokQxo3, MappedKeys.INSTANCE.m1506getMoveEndEK5gGoQ())) {
                    return KeyCommand.LINE_END;
                }
                if (Key.m5389equalsimpl0(jM5697getKeyZmokQxo3, MappedKeys.INSTANCE.m1503getEnterEK5gGoQ())) {
                    return KeyCommand.NEW_LINE;
                }
                if (Key.m5389equalsimpl0(jM5697getKeyZmokQxo3, MappedKeys.INSTANCE.m1494getBackspaceEK5gGoQ())) {
                    return KeyCommand.DELETE_PREV_CHAR;
                }
                if (Key.m5389equalsimpl0(jM5697getKeyZmokQxo3, MappedKeys.INSTANCE.m1498getDeleteEK5gGoQ())) {
                    return KeyCommand.DELETE_NEXT_CHAR;
                }
                if (Key.m5389equalsimpl0(jM5697getKeyZmokQxo3, MappedKeys.INSTANCE.m1510getPasteEK5gGoQ())) {
                    return KeyCommand.PASTE;
                }
                if (Key.m5389equalsimpl0(jM5697getKeyZmokQxo3, MappedKeys.INSTANCE.m1497getCutEK5gGoQ())) {
                    return KeyCommand.CUT;
                }
                if (Key.m5389equalsimpl0(jM5697getKeyZmokQxo3, MappedKeys.INSTANCE.m1496getCopyEK5gGoQ())) {
                    return KeyCommand.COPY;
                }
                if (Key.m5389equalsimpl0(jM5697getKeyZmokQxo3, MappedKeys.INSTANCE.m1511getTabEK5gGoQ())) {
                    return KeyCommand.TAB;
                }
                return null;
            }
        };
    }

    public static final KeyMapping getDefaultKeyMapping() {
        return defaultKeyMapping;
    }

    static {
        final KeyMapping keyMappingCommonKeyMapping = commonKeyMapping(new PropertyReference1Impl() {
            public Object get(Object obj) {
                return Boolean.valueOf(KeyEvent_androidKt.m5701isCtrlPressedZmokQxo(((KeyEvent) obj).m5686unboximpl()));
            }
        });
        defaultKeyMapping = new KeyMapping() {
            @Override
            public KeyCommand mo1457mapZmokQxo(android.view.KeyEvent event) {
                KeyCommand keyCommand = null;
                if (KeyEvent_androidKt.m5703isShiftPressedZmokQxo(event) && KeyEvent_androidKt.m5701isCtrlPressedZmokQxo(event)) {
                    long jM5697getKeyZmokQxo = KeyEvent_androidKt.m5697getKeyZmokQxo(event);
                    if (Key.m5389equalsimpl0(jM5697getKeyZmokQxo, MappedKeys.INSTANCE.m1500getDirectionLeftEK5gGoQ())) {
                        keyCommand = KeyCommand.SELECT_LEFT_WORD;
                    } else if (Key.m5389equalsimpl0(jM5697getKeyZmokQxo, MappedKeys.INSTANCE.m1501getDirectionRightEK5gGoQ())) {
                        keyCommand = KeyCommand.SELECT_RIGHT_WORD;
                    } else if (Key.m5389equalsimpl0(jM5697getKeyZmokQxo, MappedKeys.INSTANCE.m1502getDirectionUpEK5gGoQ())) {
                        keyCommand = KeyCommand.SELECT_PREV_PARAGRAPH;
                    } else if (Key.m5389equalsimpl0(jM5697getKeyZmokQxo, MappedKeys.INSTANCE.m1499getDirectionDownEK5gGoQ())) {
                        keyCommand = KeyCommand.SELECT_NEXT_PARAGRAPH;
                    }
                } else if (KeyEvent_androidKt.m5701isCtrlPressedZmokQxo(event)) {
                    long jM5697getKeyZmokQxo2 = KeyEvent_androidKt.m5697getKeyZmokQxo(event);
                    if (Key.m5389equalsimpl0(jM5697getKeyZmokQxo2, MappedKeys.INSTANCE.m1500getDirectionLeftEK5gGoQ())) {
                        keyCommand = KeyCommand.LEFT_WORD;
                    } else if (Key.m5389equalsimpl0(jM5697getKeyZmokQxo2, MappedKeys.INSTANCE.m1501getDirectionRightEK5gGoQ())) {
                        keyCommand = KeyCommand.RIGHT_WORD;
                    } else if (Key.m5389equalsimpl0(jM5697getKeyZmokQxo2, MappedKeys.INSTANCE.m1502getDirectionUpEK5gGoQ())) {
                        keyCommand = KeyCommand.PREV_PARAGRAPH;
                    } else if (Key.m5389equalsimpl0(jM5697getKeyZmokQxo2, MappedKeys.INSTANCE.m1499getDirectionDownEK5gGoQ())) {
                        keyCommand = KeyCommand.NEXT_PARAGRAPH;
                    } else if (Key.m5389equalsimpl0(jM5697getKeyZmokQxo2, MappedKeys.INSTANCE.m1504getHEK5gGoQ())) {
                        keyCommand = KeyCommand.DELETE_PREV_CHAR;
                    } else if (Key.m5389equalsimpl0(jM5697getKeyZmokQxo2, MappedKeys.INSTANCE.m1498getDeleteEK5gGoQ())) {
                        keyCommand = KeyCommand.DELETE_NEXT_WORD;
                    } else if (Key.m5389equalsimpl0(jM5697getKeyZmokQxo2, MappedKeys.INSTANCE.m1494getBackspaceEK5gGoQ())) {
                        keyCommand = KeyCommand.DELETE_PREV_WORD;
                    } else if (Key.m5389equalsimpl0(jM5697getKeyZmokQxo2, MappedKeys.INSTANCE.m1493getBackslashEK5gGoQ())) {
                        keyCommand = KeyCommand.DESELECT;
                    }
                } else if (KeyEvent_androidKt.m5703isShiftPressedZmokQxo(event)) {
                    long jM5697getKeyZmokQxo3 = KeyEvent_androidKt.m5697getKeyZmokQxo(event);
                    if (Key.m5389equalsimpl0(jM5697getKeyZmokQxo3, MappedKeys.INSTANCE.m1507getMoveHomeEK5gGoQ())) {
                        keyCommand = KeyCommand.SELECT_LINE_LEFT;
                    } else if (Key.m5389equalsimpl0(jM5697getKeyZmokQxo3, MappedKeys.INSTANCE.m1506getMoveEndEK5gGoQ())) {
                        keyCommand = KeyCommand.SELECT_LINE_RIGHT;
                    }
                } else if (KeyEvent_androidKt.m5700isAltPressedZmokQxo(event)) {
                    long jM5697getKeyZmokQxo4 = KeyEvent_androidKt.m5697getKeyZmokQxo(event);
                    if (Key.m5389equalsimpl0(jM5697getKeyZmokQxo4, MappedKeys.INSTANCE.m1494getBackspaceEK5gGoQ())) {
                        keyCommand = KeyCommand.DELETE_FROM_LINE_START;
                    } else if (Key.m5389equalsimpl0(jM5697getKeyZmokQxo4, MappedKeys.INSTANCE.m1498getDeleteEK5gGoQ())) {
                        keyCommand = KeyCommand.DELETE_TO_LINE_END;
                    }
                }
                return keyCommand == null ? keyMappingCommonKeyMapping.mo1457mapZmokQxo(event) : keyCommand;
            }
        };
    }
}
