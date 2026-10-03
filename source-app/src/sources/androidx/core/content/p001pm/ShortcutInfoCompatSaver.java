package androidx.core.content.p001pm;

import java.util.ArrayList;
import java.util.List;

public abstract class ShortcutInfoCompatSaver<T> {
    public abstract T addShortcuts(List<ShortcutInfoCompat> list);

    public abstract T removeAllShortcuts();

    public abstract T removeShortcuts(List<String> list);

    public List<ShortcutInfoCompat> getShortcuts() throws Exception {
        return new ArrayList();
    }

    public static class NoopImpl extends ShortcutInfoCompatSaver<Void> {
        @Override
        public Void addShortcuts2(List<ShortcutInfoCompat> list) {
            return null;
        }

        @Override
        public Void removeAllShortcuts() {
            return null;
        }

        @Override
        public Void removeShortcuts2(List<String> list) {
            return null;
        }

        @Override
        public Void addShortcuts(List list) {
            return addShortcuts2((List<ShortcutInfoCompat>) list);
        }

        @Override
        public Void removeShortcuts(List list) {
            return removeShortcuts2((List<String>) list);
        }
    }
}
