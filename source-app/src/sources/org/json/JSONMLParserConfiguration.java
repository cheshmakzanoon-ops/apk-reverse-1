package org.json;

public class JSONMLParserConfiguration extends ParserConfiguration {
    public static final int DEFAULT_MAXIMUM_NESTING_DEPTH = 512;
    public static final JSONMLParserConfiguration ORIGINAL = new JSONMLParserConfiguration();
    public static final JSONMLParserConfiguration KEEP_STRINGS = new JSONMLParserConfiguration().withKeepStrings(true);

    public JSONMLParserConfiguration() {
        this.maxNestingDepth = 512;
    }

    protected JSONMLParserConfiguration(boolean z, int i) {
        super(z, i);
    }

    @Override
    public JSONMLParserConfiguration clone() {
        return new JSONMLParserConfiguration(this.keepStrings, this.maxNestingDepth);
    }

    @Override
    public JSONMLParserConfiguration withKeepStrings(boolean z) {
        return (JSONMLParserConfiguration) super.withKeepStrings(z);
    }

    @Override
    public JSONMLParserConfiguration withMaxNestingDepth(int i) {
        return (JSONMLParserConfiguration) super.withMaxNestingDepth(i);
    }
}
