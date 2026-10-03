package zendesk.core.android.internal.serializer;

import java.util.ArrayList;
import java.util.Iterator;
import java.util.LinkedHashMap;
import java.util.Map;
import kotlin.Metadata;
import kotlin.collections.CollectionsKt;
import kotlin.collections.MapsKt;
import kotlin.jvm.internal.Reflection;
import kotlin.text.StringsKt;
import kotlinx.serialization.SerializationException;
import kotlinx.serialization.json.JsonArray;
import kotlinx.serialization.json.JsonElement;
import kotlinx.serialization.json.JsonElementKt;
import kotlinx.serialization.json.JsonObject;
import kotlinx.serialization.json.JsonPrimitive;

@Metadata(m17d1 = {"\u0000\u0012\n\u0000\n\u0002\u0010\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\u001a\f\u0010\u0000\u001a\u00020\u0001*\u00020\u0002H\u0002\u001a\f\u0010\u0003\u001a\u00020\u0001*\u00020\u0004H\u0002¨\u0006\u0005"}, m18d2 = {"toKotlinPrimitiveType", "", "Lkotlinx/serialization/json/JsonPrimitive;", "toKotlinType", "Lkotlinx/serialization/json/JsonElement;", "zendesk.core_core-utilities"}, m19k = 2, m20mv = {1, 9, 0}, m22xi = 48)
public final class AnySerializerKt {
    public static final Object toKotlinType(JsonElement jsonElement) {
        if (jsonElement instanceof JsonPrimitive) {
            return toKotlinPrimitiveType((JsonPrimitive) jsonElement);
        }
        if (!(jsonElement instanceof JsonArray)) {
            if (!(jsonElement instanceof JsonObject)) {
                throw new SerializationException("Unsupported JsonElement type: " + Reflection.getOrCreateKotlinClass(jsonElement.getClass()));
            }
            Map map = (Map) jsonElement;
            LinkedHashMap linkedHashMap = new LinkedHashMap(MapsKt.mapCapacity(map.size()));
            for (Map.Entry entry : map.entrySet()) {
                linkedHashMap.put(entry.getKey(), toKotlinType((JsonElement) entry.getValue()));
            }
            return linkedHashMap;
        }
        Iterable iterable = (Iterable) jsonElement;
        ArrayList arrayList = new ArrayList(CollectionsKt.collectionSizeOrDefault(iterable, 10));
        Iterator it = iterable.iterator();
        while (it.hasNext()) {
            arrayList.add(toKotlinType((JsonElement) it.next()));
        }
        return arrayList;
    }

    private static final Object toKotlinPrimitiveType(JsonPrimitive jsonPrimitive) {
        String content = jsonPrimitive.getContent();
        if (JsonElementKt.getLongOrNull(jsonPrimitive) != null) {
            return StringsKt.startsWith$default(content, "0", false, 2, (Object) null) ? content : Long.valueOf(JsonElementKt.getLong(jsonPrimitive));
        }
        if (JsonElementKt.getIntOrNull(jsonPrimitive) != null) {
            return StringsKt.startsWith$default(content, "0", false, 2, (Object) null) ? content : Integer.valueOf(JsonElementKt.getInt(jsonPrimitive));
        }
        if (JsonElementKt.getDoubleOrNull(jsonPrimitive) == null) {
            return JsonElementKt.getBooleanOrNull(jsonPrimitive) != null ? Boolean.valueOf(JsonElementKt.getBoolean(jsonPrimitive)) : content;
        }
        if (!StringsKt.contains$default((CharSequence) content, (CharSequence) ".", false, 2, (Object) null)) {
            return content;
        }
        String strSubstringBefore$default = StringsKt.substringBefore$default(content, ".", (String) null, 2, (Object) null);
        return (strSubstringBefore$default.length() <= 1 || !StringsKt.startsWith$default(strSubstringBefore$default, "0", false, 2, (Object) null)) ? Double.valueOf(JsonElementKt.getDouble(jsonPrimitive)) : content;
    }
}
