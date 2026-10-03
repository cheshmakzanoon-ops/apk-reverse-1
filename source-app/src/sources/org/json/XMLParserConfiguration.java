package org.json;

import java.util.Collections;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Map;
import java.util.Set;

public class XMLParserConfiguration extends ParserConfiguration {
    private String cDataTagName;
    private boolean convertNilAttributeToNull;
    private Set<String> forceList;
    private Map<String, XMLXsiTypeConverter<?>> xsiTypeMap;
    public static final XMLParserConfiguration ORIGINAL = new XMLParserConfiguration();
    public static final XMLParserConfiguration KEEP_STRINGS = new XMLParserConfiguration().withKeepStrings(true);

    public XMLParserConfiguration() {
        this.cDataTagName = "content";
        this.convertNilAttributeToNull = false;
        this.xsiTypeMap = Collections.emptyMap();
        this.forceList = Collections.emptySet();
    }

    @Deprecated
    public XMLParserConfiguration(boolean z) {
        this(z, "content", false);
    }

    @Deprecated
    public XMLParserConfiguration(String str) {
        this(false, str, false);
    }

    @Deprecated
    public XMLParserConfiguration(boolean z, String str) {
        super(z, 512);
        this.cDataTagName = str;
        this.convertNilAttributeToNull = false;
    }

    @Deprecated
    public XMLParserConfiguration(boolean z, String str, boolean z2) {
        super(z, 512);
        this.cDataTagName = str;
        this.convertNilAttributeToNull = z2;
    }

    private XMLParserConfiguration(boolean z, String str, boolean z2, Map<String, XMLXsiTypeConverter<?>> map, Set<String> set, int i) {
        super(z, i);
        this.cDataTagName = str;
        this.convertNilAttributeToNull = z2;
        this.xsiTypeMap = Collections.unmodifiableMap(map);
        this.forceList = Collections.unmodifiableSet(set);
    }

    @Override
    public XMLParserConfiguration clone() {
        return new XMLParserConfiguration(this.keepStrings, this.cDataTagName, this.convertNilAttributeToNull, this.xsiTypeMap, this.forceList, this.maxNestingDepth);
    }

    @Override
    public XMLParserConfiguration withKeepStrings(boolean z) {
        return (XMLParserConfiguration) super.withKeepStrings(z);
    }

    public String getcDataTagName() {
        return this.cDataTagName;
    }

    public XMLParserConfiguration withcDataTagName(String str) {
        XMLParserConfiguration xMLParserConfigurationClone = clone();
        xMLParserConfigurationClone.cDataTagName = str;
        return xMLParserConfigurationClone;
    }

    public boolean isConvertNilAttributeToNull() {
        return this.convertNilAttributeToNull;
    }

    public XMLParserConfiguration withConvertNilAttributeToNull(boolean z) {
        XMLParserConfiguration xMLParserConfigurationClone = clone();
        xMLParserConfigurationClone.convertNilAttributeToNull = z;
        return xMLParserConfigurationClone;
    }

    public Map<String, XMLXsiTypeConverter<?>> getXsiTypeMap() {
        return this.xsiTypeMap;
    }

    public XMLParserConfiguration withXsiTypeMap(Map<String, XMLXsiTypeConverter<?>> map) {
        XMLParserConfiguration xMLParserConfigurationClone = clone();
        xMLParserConfigurationClone.xsiTypeMap = Collections.unmodifiableMap(new HashMap(map));
        return xMLParserConfigurationClone;
    }

    public Set<String> getForceList() {
        return this.forceList;
    }

    public XMLParserConfiguration withForceList(Set<String> set) {
        XMLParserConfiguration xMLParserConfigurationClone = clone();
        xMLParserConfigurationClone.forceList = Collections.unmodifiableSet(new HashSet(set));
        return xMLParserConfigurationClone;
    }

    @Override
    public XMLParserConfiguration withMaxNestingDepth(int i) {
        return (XMLParserConfiguration) super.withMaxNestingDepth(i);
    }
}
