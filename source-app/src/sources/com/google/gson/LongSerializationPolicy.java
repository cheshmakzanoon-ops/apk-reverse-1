package com.google.gson;

public enum LongSerializationPolicy {
    DEFAULT {
        @Override
        public JsonElement serialize(Long l) {
            return new JsonPrimitive(l);
        }
    },
    STRING {
        @Override
        public JsonElement serialize(Long l) {
            return new JsonPrimitive(String.valueOf(l));
        }
    };

    public abstract JsonElement serialize(Long l);
}
