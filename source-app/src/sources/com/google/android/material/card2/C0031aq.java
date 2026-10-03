package com.google.android.material.card2;

import java.lang.reflect.GenericArrayType;
import java.lang.reflect.GenericDeclaration;
import java.lang.reflect.ParameterizedType;
import java.lang.reflect.Type;
import java.lang.reflect.TypeVariable;
import java.lang.reflect.WildcardType;
import java.util.Collection;
import java.util.HashSet;
import java.util.Map;
import java.util.NoSuchElementException;
import java.util.Properties;

public final class C0031aq {

    static final Type[] f32R = new Type[0];

    private static int m240a(Object[] objArr, Object obj) {
        int length = objArr.length;
        for (int i = 0; i < length; i++) {
            if (C0459zf.m11147(obj, objArr[i])) {
                return i;
            }
        }
        throw new NoSuchElementException();
    }

    private static Class<?> m241a(TypeVariable<?> typeVariable) {
        GenericDeclaration genericDeclarationM1828 = abc.m1828(typeVariable);
        if (genericDeclarationM1828 instanceof Class) {
            return (Class) genericDeclarationM1828;
        }
        return null;
    }

    public static ParameterizedType m242a(Type type, Type type2, Type... typeArr) {
        return new C0033as(type, type2, typeArr);
    }

    public static Type m243a(Type type, Class<?> cls) {
        Type typeM2797 = adds.m2797(type, cls, Collection.class);
        if (typeM2797 instanceof WildcardType) {
            typeM2797 = abf.m2539((WildcardType) typeM2797)[0];
        }
        return typeM2797 instanceof ParameterizedType ? C0448yd.m8866((ParameterizedType) typeM2797)[0] : Object.class;
    }

    static Type m244a(Type type, Class<?> cls, Class<?> cls2) {
        Class<?> cls3 = cls;
        if (cls2 == cls3) {
            return type;
        }
        if (abf.m2602(cls2)) {
            Class<?>[] clsArrM2910 = m2910(cls3);
            int length = clsArrM2910.length;
            for (int i = 0; i < length; i++) {
                if (clsArrM2910[i] == cls2) {
                    return C0457zc.m10567(cls3)[i];
                }
                if (gggy.m4342(cls2, clsArrM2910[i])) {
                    return C0448yd.m8991(C0457zc.m10567(cls3)[i], clsArrM2910[i], cls2);
                }
            }
        }
        if (abf.m2602(cls3)) {
            return cls2;
        }
        while (cls3 != Object.class) {
            Class<?> clsM11187 = C0459zf.m11187(cls3);
            if (clsM11187 == cls2) {
                return C0449ye.m9165(cls3);
            }
            if (gggy.m4342(cls2, clsM11187)) {
                return C0448yd.m8991(C0449ye.m9165(cls3), clsM11187, cls2);
            }
            cls3 = clsM11187;
        }
        return cls2;
    }

    public static Type m245a(Type type, Class<?> cls, Type type2) {
        return C0452yh.m9600(type, cls, type2, new HashSet());
    }

    private static Type m246a(Type type, Class<?> cls, Type type2, Collection<TypeVariable> collection) {
        Type typeM9600;
        Type[] typeArr;
        boolean z;
        Type typeM9550 = type2;
        while (typeM9550 instanceof TypeVariable) {
            TypeVariable typeVariable = (TypeVariable) typeM9550;
            if (abe.m2275(collection, typeVariable)) {
                return typeM9550;
            }
            C0459zf.m11126(collection, typeVariable);
            typeM9550 = C0450yf.m9550(type, cls, typeVariable);
            if (typeM9550 == typeVariable) {
                return typeM9550;
            }
        }
        if ((typeM9550 instanceof Class) && C0459zf.m11119((Class) typeM9550)) {
            Class cls2 = (Class) typeM9550;
            Class clsM9252 = C0449ye.m9252(cls2);
            Type typeM9601 = C0452yh.m9600(type, cls, clsM9252, collection);
            return clsM9252 != typeM9601 ? C0450yf.m9541(typeM9601) : cls2;
        }
        if (typeM9550 instanceof GenericArrayType) {
            GenericArrayType genericArrayType = (GenericArrayType) typeM9550;
            Type typeM11371 = C0460zg.m11371(genericArrayType);
            Type typeM9602 = C0452yh.m9600(type, cls, typeM11371, collection);
            return typeM11371 != typeM9602 ? C0450yf.m9541(typeM9602) : genericArrayType;
        }
        if (!(typeM9550 instanceof ParameterizedType)) {
            if (!(typeM9550 instanceof WildcardType)) {
                return typeM9550;
            }
            WildcardType wildcardType = (WildcardType) typeM9550;
            Type[] typeArrM9778 = C0452yh.m9778(wildcardType);
            Type[] typeArrM2539 = abf.m2539(wildcardType);
            if (typeArrM9778.length != 1) {
                return (typeArrM2539.length != 1 || (typeM9600 = C0452yh.m9600(type, cls, typeArrM2539[0], collection)) == typeArrM2539[0]) ? wildcardType : C0449ye.m9226(typeM9600);
            }
            Type typeM9603 = C0452yh.m9600(type, cls, typeArrM9778[0], collection);
            return typeM9603 != typeArrM9778[0] ? C0453yj.m10008(typeM9603) : wildcardType;
        }
        ParameterizedType parameterizedType = (ParameterizedType) typeM9550;
        Type typeM11084 = C0459zf.m11084(parameterizedType);
        Type typeM9604 = C0452yh.m9600(type, cls, typeM11084, collection);
        boolean z2 = typeM9604 != typeM11084;
        Type[] typeArrM8866 = C0448yd.m8866(parameterizedType);
        int length = typeArrM8866.length;
        int i = 0;
        boolean z3 = z2;
        while (i < length) {
            Type typeM9605 = C0452yh.m9600(type, cls, typeArrM8866[i], collection);
            if (typeM9605 != typeArrM8866[i]) {
                if (z3) {
                    typeArr = typeArrM8866;
                    z = z3;
                } else {
                    typeArr = (Type[]) C0460zg.m11382(typeArrM8866);
                    z = true;
                }
                typeArr[i] = typeM9605;
            } else {
                typeArr = typeArrM8866;
                z = z3;
            }
            i++;
            z3 = z;
            typeArrM8866 = typeArr;
        }
        return z3 ? abc.m1881(typeM9604, C0457zc.m10561(parameterizedType), typeArrM8866) : parameterizedType;
    }

    static Type m247a(Type type, Class<?> cls, TypeVariable<?> typeVariable) {
        Class clsM9912 = C0453yj.m9912(typeVariable);
        if (clsM9912 == null) {
            return typeVariable;
        }
        Type typeM8991 = C0448yd.m8991(type, cls, clsM9912);
        if (!(typeM8991 instanceof ParameterizedType)) {
            return typeVariable;
        }
        return C0448yd.m8866((ParameterizedType) typeM8991)[C0445ya.m8334(C0456zb.m10434(clsM9912), typeVariable)];
    }

    static boolean m248a(Object obj, Object obj2) {
        return obj == obj2 || (obj != null && C0459zf.m11147(obj, obj2));
    }

    public static boolean m249a(Type type, Type type2) {
        if (type == type2) {
            return true;
        }
        if (type instanceof Class) {
            return C0459zf.m11147(type, type2);
        }
        if (type instanceof ParameterizedType) {
            if (!(type2 instanceof ParameterizedType)) {
                return false;
            }
            ParameterizedType parameterizedType = (ParameterizedType) type;
            ParameterizedType parameterizedType2 = (ParameterizedType) type2;
            return gggy.m4309(C0459zf.m11084(parameterizedType), C0459zf.m11084(parameterizedType2)) && C0459zf.m11147(C0457zc.m10561(parameterizedType), C0457zc.m10561(parameterizedType2)) && C0456zb.m10410(C0448yd.m8866(parameterizedType), C0448yd.m8866(parameterizedType2));
        }
        if (type instanceof GenericArrayType) {
            if (type2 instanceof GenericArrayType) {
                return C0448yd.m8888(C0460zg.m11371((GenericArrayType) type), C0460zg.m11371((GenericArrayType) type2));
            }
            return false;
        }
        if (type instanceof WildcardType) {
            if (!(type2 instanceof WildcardType)) {
                return false;
            }
            WildcardType wildcardType = (WildcardType) type;
            WildcardType wildcardType2 = (WildcardType) type2;
            return C0456zb.m10410(abf.m2539(wildcardType), abf.m2539(wildcardType2)) && C0456zb.m10410(C0452yh.m9778(wildcardType), C0452yh.m9778(wildcardType2));
        }
        if (!(type instanceof TypeVariable) || !(type2 instanceof TypeVariable)) {
            return false;
        }
        TypeVariable typeVariable = (TypeVariable) type;
        TypeVariable typeVariable2 = (TypeVariable) type2;
        return abc.m1828(typeVariable) == abc.m1828(typeVariable2) && C0452yh.m9583(C0457zc.m10595(typeVariable), C0457zc.m10595(typeVariable2));
    }

    public static GenericArrayType m250b(Type type) {
        return new C0032ar(type);
    }

    static Type m251b(Type type, Class<?> cls, Class<?> cls2) {
        Type type2 = type;
        if (type2 instanceof WildcardType) {
            type2 = abf.m2539((WildcardType) type2)[0];
        }
        C0461zs.m11567(gggy.m4342(cls2, cls));
        return abc.m1956(type2, cls, C0448yd.m8991(type2, cls, cls2));
    }

    public static Type[] m252b(Type type, Class<?> cls) {
        if (type == Properties.class) {
            return new Type[]{String.class, String.class};
        }
        Type typeM2797 = adds.m2797(type, cls, Map.class);
        return typeM2797 instanceof ParameterizedType ? C0448yd.m8866((ParameterizedType) typeM2797) : new Type[]{Object.class, Object.class};
    }

    public static Type m253c(Type type) {
        if (type instanceof Class) {
            Class cls = (Class) type;
            return C0459zf.m11119(cls) ? new C0032ar(abe.m2352(C0449ye.m9252(cls))) : cls;
        }
        if (type instanceof ParameterizedType) {
            ParameterizedType parameterizedType = (ParameterizedType) type;
            return new C0033as(C0459zf.m11084(parameterizedType), C0457zc.m10561(parameterizedType), C0448yd.m8866(parameterizedType));
        }
        if (type instanceof GenericArrayType) {
            return new C0032ar(C0460zg.m11371((GenericArrayType) type));
        }
        if (!(type instanceof WildcardType)) {
            return type;
        }
        WildcardType wildcardType = (WildcardType) type;
        return new C0034at(abf.m2539(wildcardType), C0452yh.m9778(wildcardType));
    }

    static int m254d(Object obj) {
        if (obj != null) {
            return C0446yb.m8544(obj);
        }
        return 0;
    }

    static void m255d(Type type) {
        C0461zs.m11567(((type instanceof Class) && C0459zf.m11201((Class) type)) ? false : true);
    }

    public static Type m256e(Type type) {
        return type instanceof GenericArrayType ? C0460zg.m11371((GenericArrayType) type) : C0449ye.m9252((Class) type);
    }

    public static Class<?> m257f(Type type) {
        if (type instanceof Class) {
            return (Class) type;
        }
        if (type instanceof ParameterizedType) {
            Type typeM10561 = C0457zc.m10561((ParameterizedType) type);
            C0461zs.m11567(typeM10561 instanceof Class);
            return (Class) typeM10561;
        }
        if (type instanceof GenericArrayType) {
            return gggy.m4399(adds.m2842(C0445ya.m8294(C0460zg.m11371((GenericArrayType) type)), 0));
        }
        if (type instanceof TypeVariable) {
            return Object.class;
        }
        if (type instanceof WildcardType) {
            return C0445ya.m8294(abf.m2539((WildcardType) type)[0]);
        }
        throw new IllegalArgumentException(abc.m1925(C0460zg.m11407(C0460zg.m11407(abd.m2090(C0460zg.m11407(new StringBuilder(), abf.m2451()), type), C0455za.m10066()), type == null ? C0448yd.m8883() : C0456zb.m10455(gggy.m4399(type)))));
    }

    public static WildcardType m258g(Type type) {
        return new C0034at(type instanceof WildcardType ? abf.m2539((WildcardType) type) : new Type[]{type}, gggy.m4293());
    }

    public static WildcardType m259h(Type type) {
        return new C0034at(new Type[]{Object.class}, type instanceof WildcardType ? C0452yh.m9778((WildcardType) type) : new Type[]{type});
    }

    public static String m260i(Type type) {
        return type instanceof Class ? C0456zb.m10455((Class) type) : m2907(type);
    }

    public static Type m2903(Object obj, Object obj2, Object obj3) {
        if (C0456zb.m10326() < 0) {
            return m251b((Type) obj, (Class) obj2, (Class) obj3);
        }
        return null;
    }

    public static Type[] m2904() {
        if (C0445ya.m8222() >= 0) {
            return f32R;
        }
        return null;
    }

    public static Class m2905(Object obj) {
        if (adds.m2755() > 0) {
            return m241a((TypeVariable) obj);
        }
        return null;
    }

    public static Object m2906(Object obj) {
        if (C0459zf.m11062() >= 0) {
            return ((Type[]) obj).clone();
        }
        return null;
    }

    public static String m2907(Object obj) {
        if (adds.m2755() > 0) {
            return C0598.m11838(obj);
        }
        return null;
    }

    public static Type m2908(Object obj, Object obj2, Object obj3) {
        if (C0451yg.m9580() > 0) {
            return m244a((Type) obj, (Class<?>) obj2, (Class<?>) obj3);
        }
        return null;
    }

    public static boolean m2909(Object obj, Object obj2) {
        if (C0453yj.m10013() > 0) {
            return m248a(obj, obj2);
        }
        return false;
    }

    public static Class[] m2910(Object obj) {
        if (C0457zc.m10735() < 0) {
            return C0598.m11840(obj);
        }
        return null;
    }

    public static Type m2911(Object obj, Object obj2, Object obj3, Object obj4) {
        if (C0450yf.m9352() <= 0) {
            return m246a((Type) obj, (Class) obj2, (Type) obj3, (Collection) obj4);
        }
        return null;
    }

    public static Type m2912(Object obj, Object obj2, Object obj3) {
        if (C0456zb.m10326() <= 0) {
            return m247a((Type) obj, (Class<?>) obj2, (TypeVariable<?>) obj3);
        }
        return null;
    }

    public static int m2913(Object obj, Object obj2) {
        if (abd.m2162() > 0) {
            return m240a((Object[]) obj, obj2);
        }
        return 0;
    }

    public static Type m2914(Object obj, Object obj2, Object obj3, Object obj4) {
        if (gggy.m4365() >= 0) {
            return m2911((Type) obj, (Class) obj2, (Type) obj3, (Collection) obj4);
        }
        return null;
    }

    public static Type[] m2915() {
        if (C0453yj.m9945() < 0) {
            return m2904();
        }
        return null;
    }

    public static Type m2916(Object obj, Object obj2, Object obj3) {
        if (C0445ya.m8330() >= 0) {
            return m2908((Type) obj, (Class) obj2, (Class) obj3);
        }
        return null;
    }

    public static Object m2917(Object obj) {
        if (abe.m2321() <= 0) {
            return m2906((Type[]) obj);
        }
        return null;
    }

    public static Class m2918(Object obj) {
        if (C0448yd.m9074() < 0) {
            return m2905((TypeVariable) obj);
        }
        return null;
    }

    public static boolean m2919(Object obj, Object obj2) {
        if (abd.m2021() > 0) {
            return m2909(obj, obj2);
        }
        return false;
    }

    public static Type m2920(Object obj, Object obj2, Object obj3) {
        if (C0456zb.m10484() < 0) {
            return m2903((Type) obj, (Class) obj2, (Class) obj3);
        }
        return null;
    }

    public static Type m2921(Object obj, Object obj2, Object obj3) {
        if (C0448yd.m9015() < 0) {
            return m2912((Type) obj, (Class) obj2, (TypeVariable) obj3);
        }
        return null;
    }

    public static int m2922(Object obj, Object obj2) {
        if (gggy.m4365() >= 0) {
            return m2913((Object[]) obj, obj2);
        }
        return 0;
    }
}
