package com.google.common.base;

import java.io.Serializable;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

@ElementTypesAreNonnullByDefault
final class JdkPattern extends CommonPattern implements Serializable {
    private static final long serialVersionUID = 0;
    private final Pattern pattern;

    JdkPattern(Pattern pattern) {
        this.pattern = (Pattern) Preconditions.checkNotNull(pattern);
    }

    @Override
    public CommonMatcher matcher(CharSequence charSequence) {
        return new JdkMatcher(this.pattern.matcher(charSequence));
    }

    @Override
    public String pattern() {
        return this.pattern.pattern();
    }

    @Override
    public int flags() {
        return this.pattern.flags();
    }

    @Override
    public String toString() {
        return this.pattern.toString();
    }

    private static final class JdkMatcher extends CommonMatcher {
        final Matcher matcher;

        JdkMatcher(Matcher matcher) {
            this.matcher = (Matcher) Preconditions.checkNotNull(matcher);
        }

        @Override
        public boolean matches() {
            return this.matcher.matches();
        }

        @Override
        public boolean find() {
            return this.matcher.find();
        }

        @Override
        public boolean find(int i) {
            return this.matcher.find(i);
        }

        @Override
        public String replaceAll(String str) {
            return this.matcher.replaceAll(str);
        }

        @Override
        public int end() {
            return this.matcher.end();
        }

        @Override
        public int start() {
            return this.matcher.start();
        }
    }
}
