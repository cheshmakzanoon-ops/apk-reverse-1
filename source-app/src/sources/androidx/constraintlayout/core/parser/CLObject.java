package androidx.constraintlayout.core.parser;

import java.util.Iterator;

public class CLObject extends CLContainer implements Iterable<CLKey> {
    public CLObject(char[] cArr) {
        super(cArr);
    }

    public static CLObject allocate(char[] cArr) {
        return new CLObject(cArr);
    }

    @Override
    public String toJSON() {
        StringBuilder sb = new StringBuilder(getDebugName() + "{ ");
        boolean z = true;
        for (CLElement cLElement : this.mElements) {
            if (z) {
                z = false;
            } else {
                sb.append(", ");
            }
            sb.append(cLElement.toJSON());
        }
        sb.append(" }");
        return sb.toString();
    }

    public String toFormattedJSON() {
        return toFormattedJSON(0, 0);
    }

    @Override
    public String toFormattedJSON(int i, int i2) {
        StringBuilder sb = new StringBuilder(getDebugName());
        sb.append("{\n");
        boolean z = true;
        for (CLElement cLElement : this.mElements) {
            if (z) {
                z = false;
            } else {
                sb.append(",\n");
            }
            sb.append(cLElement.toFormattedJSON(sBaseIndent + i, i2 - 1));
        }
        sb.append("\n");
        addIndent(sb, i);
        sb.append("}");
        return sb.toString();
    }

    @Override
    public Iterator<CLKey> iterator() {
        return new CLObjectIterator(this);
    }

    private static class CLObjectIterator implements Iterator<CLKey> {
        int mIndex = 0;
        CLObject mObject;

        CLObjectIterator(CLObject cLObject) {
            this.mObject = cLObject;
        }

        @Override
        public boolean hasNext() {
            return this.mIndex < this.mObject.size();
        }

        @Override
        public CLKey next() {
            CLKey cLKey = (CLKey) this.mObject.mElements.get(this.mIndex);
            this.mIndex++;
            return cLKey;
        }
    }

    @Override
    public CLObject mo2128clone() {
        return (CLObject) super.mo2128clone();
    }
}
