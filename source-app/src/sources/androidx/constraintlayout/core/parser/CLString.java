package androidx.constraintlayout.core.parser;

public class CLString extends CLElement {
    public CLString(char[] cArr) {
        super(cArr);
    }

    public static CLElement allocate(char[] cArr) {
        return new CLString(cArr);
    }

    public static CLString from(String str) {
        CLString cLString = new CLString(str.toCharArray());
        cLString.setStart(0L);
        cLString.setEnd(str.length() - 1);
        return cLString;
    }

    @Override
    protected String toJSON() {
        return "'" + content() + "'";
    }

    @Override
    protected String toFormattedJSON(int i, int i2) {
        StringBuilder sb = new StringBuilder();
        addIndent(sb, i);
        sb.append("'");
        sb.append(content());
        sb.append("'");
        return sb.toString();
    }

    @Override
    public boolean equals(Object obj) {
        if (this == obj) {
            return true;
        }
        if ((obj instanceof CLString) && content().equals(((CLString) obj).content())) {
            return true;
        }
        return super.equals(obj);
    }

    @Override
    public int hashCode() {
        return super.hashCode();
    }
}
