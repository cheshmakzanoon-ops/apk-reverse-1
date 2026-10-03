package org.json;

import java.io.Reader;
import java.util.HashMap;

public class XMLTokener extends JSONTokener {
    public static final HashMap<String, Character> entity;

    static {
        HashMap<String, Character> map = new HashMap<>(8);
        entity = map;
        map.put("amp", XML.AMP);
        map.put("apos", XML.APOS);
        map.put("gt", XML.f132GT);
        map.put("lt", XML.f133LT);
        map.put("quot", XML.QUOT);
    }

    public XMLTokener(Reader reader) {
        super(reader);
    }

    public XMLTokener(String str) {
        super(str);
    }

    public String nextCDATA() throws JSONException {
        StringBuilder sb = new StringBuilder();
        while (more()) {
            sb.append(next());
            int length = sb.length();
            int i = length - 3;
            if (i >= 0 && sb.charAt(i) == ']' && sb.charAt(length - 2) == ']' && sb.charAt(length - 1) == '>') {
                sb.setLength(i);
                return sb.toString();
            }
        }
        throw syntaxError("Unclosed CDATA");
    }

    public Object nextContent() throws JSONException {
        char next;
        do {
            next = next();
        } while (Character.isWhitespace(next));
        if (next == 0) {
            return null;
        }
        if (next == '<') {
            return XML.f133LT;
        }
        StringBuilder sb = new StringBuilder();
        while (next != 0) {
            if (next == '<') {
                back();
                return sb.toString().trim();
            }
            if (next == '&') {
                sb.append(nextEntity(next));
            } else {
                sb.append(next);
            }
            next = next();
        }
        return sb.toString().trim();
    }

    public Object nextEntity(char c) throws JSONException {
        char next;
        StringBuilder sb = new StringBuilder();
        while (true) {
            next = next();
            if (!Character.isLetterOrDigit(next) && next != '#') {
                break;
            }
            sb.append(Character.toLowerCase(next));
        }
        if (next != ';') {
            throw syntaxError("Missing ';' in XML entity: &" + ((Object) sb));
        }
        return unescapeEntity(sb.toString());
    }

    static String unescapeEntity(String str) {
        int i;
        if (str == null || str.isEmpty()) {
            return "";
        }
        if (str.charAt(0) == '#') {
            if (str.charAt(1) == 'x' || str.charAt(1) == 'X') {
                i = Integer.parseInt(str.substring(2), 16);
            } else {
                i = Integer.parseInt(str.substring(1));
            }
            return new String(new int[]{i}, 0, 1);
        }
        Character ch = entity.get(str);
        if (ch == null) {
            return "&" + str + ';';
        }
        return ch.toString();
    }

    public Object nextMeta() throws JSONException {
        char next;
        char next2;
        do {
            next = next();
        } while (Character.isWhitespace(next));
        if (next == 0) {
            throw syntaxError("Misshaped meta tag");
        }
        if (next != '\'') {
            if (next == '/') {
                return XML.SLASH;
            }
            if (next == '!') {
                return XML.BANG;
            }
            if (next != '\"') {
                switch (next) {
                    case '<':
                        return XML.f133LT;
                    case '=':
                        return XML.f131EQ;
                    case '>':
                        return XML.f132GT;
                    case '?':
                        return XML.QUEST;
                }
                while (true) {
                    char next3 = next();
                    if (Character.isWhitespace(next3)) {
                        return Boolean.TRUE;
                    }
                    if (next3 == 0) {
                        throw syntaxError("Unterminated string");
                    }
                    if (next3 != '\'' && next3 != '/' && next3 != '!' && next3 != '\"') {
                        switch (next3) {
                            case '<':
                            case '=':
                            case '>':
                            case '?':
                                break;
                            default:
                                break;
                        }
                    }
                    back();
                    return Boolean.TRUE;
                }
            }
        }
        do {
            next2 = next();
            if (next2 == 0) {
                throw syntaxError("Unterminated string");
            }
        } while (next2 != next);
        return Boolean.TRUE;
    }

    public Object nextToken() throws JSONException {
        char next;
        do {
            next = next();
        } while (Character.isWhitespace(next));
        if (next == 0) {
            throw syntaxError("Misshaped element");
        }
        if (next != '\'') {
            if (next == '/') {
                return XML.SLASH;
            }
            if (next == '!') {
                return XML.BANG;
            }
            if (next != '\"') {
                switch (next) {
                    case '<':
                        throw syntaxError("Misplaced '<'");
                    case '=':
                        return XML.f131EQ;
                    case '>':
                        return XML.f132GT;
                    case '?':
                        return XML.QUEST;
                    default:
                        StringBuilder sb = new StringBuilder();
                        while (true) {
                            sb.append(next);
                            next = next();
                            if (Character.isWhitespace(next)) {
                                return sb.toString();
                            }
                            if (next == 0) {
                                return sb.toString();
                            }
                            if (next != '\'') {
                                if (next != '/' && next != '[' && next != ']' && next != '!') {
                                    if (next != '\"') {
                                        switch (next) {
                                            case '<':
                                                break;
                                            case '=':
                                            case '>':
                                            case '?':
                                                break;
                                            default:
                                                break;
                                        }
                                    }
                                }
                                back();
                                return sb.toString();
                            }
                            throw syntaxError("Bad character in a name");
                        }
                }
            }
        }
        StringBuilder sb2 = new StringBuilder();
        while (true) {
            char next2 = next();
            if (next2 == 0) {
                throw syntaxError("Unterminated string");
            }
            if (next2 == next) {
                return sb2.toString();
            }
            if (next2 == '&') {
                sb2.append(nextEntity(next2));
            } else {
                sb2.append(next2);
            }
        }
    }

    public void skipPast(String str) {
        int length = str.length();
        char[] cArr = new char[length];
        for (int i = 0; i < length; i++) {
            char next = next();
            if (next == 0) {
                return;
            }
            cArr[i] = next;
        }
        int i2 = 0;
        while (true) {
            int i3 = i2;
            for (int i4 = 0; i4 < length; i4++) {
                if (cArr[i3] != str.charAt(i4)) {
                    char next2 = next();
                    if (next2 == 0) {
                        return;
                    }
                    cArr[i2] = next2;
                    i2++;
                    if (i2 >= length) {
                        i2 -= length;
                    }
                } else {
                    i3++;
                    if (i3 >= length) {
                        i3 -= length;
                    }
                }
            }
            return;
        }
    }
}
