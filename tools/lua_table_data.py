#!/usr/bin/env python3
"""Statically interpret a deliberately small, data-only Lua 5.3 subset.

No calls, functions, control flow, operators (except unary minus), or globals.
The accepted statements are local declarations, assignments and one return.
Bytes, int64/float64 types, aliasing and cycles survive the neutral table graph.
"""
from __future__ import annotations
import json
import math
import re
import struct
from collections import deque
from dataclasses import dataclass, field


class DataError(ValueError):
    pass


def need(condition, message):
    if not condition:
        raise DataError(message)


@dataclass(eq=False)
class Table:
    entries: dict = field(default_factory=dict)


def key(value):
    if type(value) is float:
        need(math.isfinite(value), 'nonfinite table key')
        if value.is_integer() and -(1 << 63) <= value < (1 << 63):
            value = int(value)
    need(type(value) in (bool, int, float, bytes), 'only scalar non-nil keys are supported')
    # Python equates True and 1; Lua does not.
    return type(value), value


def get(table, index):
    need(isinstance(table, Table), 'indexing a non-table')
    return table.entries.get(key(index))


def put(table, index, value):
    need(isinstance(table, Table), 'writing a non-table')
    k = key(index)
    if value is None:
        table.entries.pop(k, None)
    else:
        table.entries[k] = value


NUMBER = re.compile(rb'(?:0[xX](?:[0-9a-fA-F]+(?:\.[0-9a-fA-F]*)?|\.[0-9a-fA-F]+)(?:[pP][+-]?[0-9]+)?|(?:[0-9]+(?:\.[0-9]*)?|\.[0-9]+)(?:[eE][+-]?[0-9]+)?)')
NAME = re.compile(rb'[A-Za-z_][A-Za-z_0-9]*')
LONG = re.compile(rb'\[(=*)\[')
SPACE = re.compile(rb'[\x09-\x0d ]+')
RESERVED = set(b'and break do else elseif end for function goto if in local not or repeat return then until while'.split())


def numeral(raw):
    text = raw.decode('ascii')
    hexadecimal = text.lower().startswith('0x')
    floating = '.' in text or ('p' in text.lower() if hexadecimal else 'e' in text.lower())
    if not floating:
        value = int(text, 16 if hexadecimal else 10)
        if hexadecimal:
            # Lua 5.3 accumulates hexadecimal integer literals modulo 2**64.
            value %= 1 << 64
            return value - (1 << 64) if value >= (1 << 63) else value
        if value < (1 << 63):
            return value
    try:
        value = float.fromhex(text) if hexadecimal else float(text)
    except (ValueError, OverflowError) as exc:
        raise DataError('invalid or overflowing numeral') from exc
    need(math.isfinite(value), 'nonfinite numeral is outside the supported data subset')
    return value


class Lexer:
    def __init__(self, source, max_tokens=8_000_000):
        need(type(source) is bytes, 'source must be bytes')
        self.source = source[3:] if source.startswith(b'\xef\xbb\xbf') else source
        self.pos = 0
        self.used = 0
        self.limit = max_tokens
        self.cached = None

    def long_string(self):
        m = LONG.match(self.source, self.pos)
        if not m:
            return None
        end_mark = b']' + m[1] + b']'
        start = m.end()
        end = self.source.find(end_mark, start)
        need(end >= 0, 'unterminated long string/comment')
        value = self.source[start:end]
        self.pos = end + len(end_mark)
        value = re.sub(rb'\r\n|\n\r|\r', b'\n', value)
        if value.startswith(b'\n'):
            value = value[1:]
        return value

    def quoted(self):
        s = self.source
        quote = s[self.pos]
        self.pos += 1
        out = bytearray()
        escapes = {97:7, 98:8, 102:12, 110:10, 114:13, 116:9, 118:11, 92:92, 34:34, 39:39}
        while self.pos < len(s):
            c = s[self.pos]; self.pos += 1
            if c == quote:
                return bytes(out)
            need(c not in (10, 13), 'unescaped newline in quoted string')
            if c != 92:
                out.append(c); continue
            need(self.pos < len(s), 'unterminated string escape')
            c = s[self.pos]; self.pos += 1
            if c in escapes:
                out.append(escapes[c])
            elif c in (10, 13):
                if self.pos < len(s) and s[self.pos] in (10, 13) and s[self.pos] != c:
                    self.pos += 1
                out.append(10)
            elif c == 122:
                m = SPACE.match(s, self.pos)
                if m: self.pos = m.end()
            elif c == 120:
                raw = s[self.pos:self.pos+2]
                need(len(raw) == 2 and re.fullmatch(rb'[0-9a-fA-F]{2}', raw), 'bad hexadecimal escape')
                out.append(int(raw, 16)); self.pos += 2
            elif 48 <= c <= 57:
                start = self.pos - 1
                while self.pos < min(start+3, len(s)) and 48 <= s[self.pos] <= 57:
                    self.pos += 1
                value = int(s[start:self.pos])
                need(value <= 255, 'decimal byte escape exceeds 255')
                out.append(value)
            elif c == 117:
                m = re.match(rb'\{([0-9a-fA-F]+)\}', s[self.pos:])
                need(m is not None, 'bad Unicode escape')
                value = int(m[1], 16)
                need(value <= 0x10ffff and not 0xd800 <= value <= 0xdfff, 'unsupported Unicode code point')
                out.extend(chr(value).encode('utf-8')); self.pos += m.end()
            else:
                raise DataError('unsupported string escape')
        raise DataError('unterminated quoted string')

    def take(self):
        if self.cached is not None:
            result = self.cached; self.cached = None; return result
        s = self.source
        while self.pos < len(s):
            m = SPACE.match(s, self.pos)
            if m:
                self.pos = m.end(); continue
            if s.startswith(b'--', self.pos):
                self.pos += 2
                if LONG.match(s, self.pos):
                    self.long_string()
                else:
                    while self.pos < len(s) and s[self.pos] not in (10, 13): self.pos += 1
                continue
            break
        self.used += 1
        need(self.used <= self.limit, 'token budget exceeded')
        if self.pos == len(s): return ('eof', None)
        c = s[self.pos]
        if c in (34, 39): return ('value', self.quoted())
        if LONG.match(s, self.pos): return ('value', self.long_string())
        m = NUMBER.match(s, self.pos)
        if m:
            self.pos = m.end()
            need(self.pos == len(s) or not (s[self.pos:self.pos+1].isalnum() or s[self.pos] == 95), 'malformed numeral')
            return ('value', numeral(m[0]))
        m = NAME.match(s, self.pos)
        if m:
            self.pos = m.end(); word = m[0]
            if word in (b'true', b'false', b'nil'):
                return ('value', {b'true': True, b'false': False, b'nil': None}[word])
            return (word.decode() if word in RESERVED else 'name', word)
        self.pos += 1
        need(c in b'{}[]=.,;()-', 'unsupported token at byte ' + str(self.pos-1))
        return (chr(c), None)

    def peek(self):
        if self.cached is None: self.cached = self.take()
        return self.cached

    def accept(self, kind):
        if self.peek()[0] == kind:
            return self.take()
        return None

    def expect(self, kind):
        token = self.take()
        need(token[0] == kind, 'expected ' + kind + ', got ' + token[0] + ' at byte ' + str(self.pos))
        return token[1]


class Parser:
    def __init__(self, source, *, max_tokens=8_000_000, max_tables=300_000):
        self.lex = Lexer(source, max_tokens)
        self.locals = {}
        self.tables = 0
        self.max_tables = max_tables

    def suffix(self, value, depth):
        while self.lex.peek()[0] in ('.', '['):
            if self.lex.accept('.'):
                index = self.lex.expect('name')
            else:
                self.lex.expect('['); index = self.expr(depth+1); self.lex.expect(']')
            value = get(value, index)
        return value

    def expr(self, depth=0):
        need(depth < 100, 'expression nesting budget exceeded')
        kind, value = self.lex.take()
        if kind == 'value': return value
        if kind == '-':
            value = self.expr(depth+1)
            need(type(value) in (int, float), 'unary minus requires a number')
            return -value if type(value) is float or value != -(1 << 63) else value
        if kind == 'name':
            need(value in self.locals, 'global/undeclared name is not data: ' + value.decode())
            return self.suffix(self.locals[value], depth)
        if kind == '(':
            value = self.expr(depth+1); self.lex.expect(')')
            return self.suffix(value, depth)
        if kind == '{':
            self.tables += 1
            need(self.tables <= self.max_tables, 'table budget exceeded')
            out = Table(); sequence = 1; seen = set()
            while not self.lex.accept('}'):
                if self.lex.accept('['):
                    index = self.expr(depth+1); self.lex.expect(']'); self.lex.expect('=')
                    value = self.expr(depth+1)
                else:
                    first = self.lex.peek()
                    # Named constructor fields are unambiguous only when followed by '='.
                    if first[0] == 'name':
                        self.lex.take()
                        if self.lex.accept('='):
                            index = first[1]; value = self.expr(depth+1)
                        else:
                            need(first[1] in self.locals, 'global in constructor')
                            value = self.suffix(self.locals[first[1]], depth+1)
                            index = sequence; sequence += 1
                    else:
                        index = sequence; sequence += 1; value = self.expr(depth+1)
                k = key(index)
                need(k not in seen, 'duplicate constructor key has unsupported assignment ordering')
                seen.add(k); put(out, index, value)
                if self.lex.accept(',') or self.lex.accept(';'): continue
                self.lex.expect('}'); break
            return out
        raise DataError('unsupported expression ' + kind + ' at byte ' + str(self.lex.pos))

    def target(self):
        name = self.lex.expect('name')
        need(name in self.locals, 'assignment to global/undeclared local')
        value = self.locals[name]
        container = self.locals; index = name
        while self.lex.peek()[0] in ('.', '['):
            container = value
            if self.lex.accept('.'): index = self.lex.expect('name')
            else:
                self.lex.expect('['); index = self.expr(); self.lex.expect(']')
            value = get(container, index)
        return container, index

    def values(self):
        values = [self.expr()]
        while self.lex.accept(','): values.append(self.expr())
        return values

    def parse(self):
        while True:
            if self.lex.accept(';'): continue
            if self.lex.accept('return'):
                result = self.expr()
                self.lex.accept(';'); self.lex.expect('eof')
                need(isinstance(result, Table), 'returned value must be a table')
                return result
            if self.lex.accept('local'):
                names = [self.lex.expect('name')]
                while self.lex.accept(','): names.append(self.lex.expect('name'))
                need(len(set(names)) == len(names), 'duplicate local declaration')
                values = self.values() if self.lex.accept('=') else []
                for i, name in enumerate(names): self.locals[name] = values[i] if i < len(values) else None
                continue
            need(self.lex.peek()[0] != 'eof', 'data chunk has no return')
            targets = [self.target()]
            while self.lex.accept(','): targets.append(self.target())
            self.lex.expect('='); values = self.values()
            for i, (container, index) in enumerate(targets):
                value = values[i] if i < len(values) else None
                if isinstance(container, Table): put(container, index, value)
                else: container[index] = value


def scalar(value):
    if type(value) is bool: return ['b', value]
    if type(value) is int:
        need(-(1 << 63) <= value < (1 << 63), 'integer outside int64')
        return ['i', str(value)]
    if type(value) is float:
        need(math.isfinite(value), 'nonfinite float')
        return ['f', struct.pack('<d', value).hex()]
    if type(value) is bytes: return ['s', value.hex()]
    raise DataError('unsupported scalar')


def compact(value):
    return json.dumps(value, sort_keys=True, ensure_ascii=True, separators=(',', ':')).encode('ascii')


def encode(root):
    need(isinstance(root, Table), 'root must be a table')
    ids = {root: 0}; pending = deque([root]); tables = []
    while pending:
        current = pending.popleft(); entries = []
        for (kind, k), value in sorted(current.entries.items(), key=lambda x: compact(scalar(x[0][1]))):
            if isinstance(value, Table):
                if value not in ids:
                    ids[value] = len(ids); pending.append(value)
                encoded = ['t', ids[value]]
            else: encoded = scalar(value)
            entries.append([scalar(k), encoded])
        tables.append(entries)
    return {'format': 'lua-table-graph-v1', 'root': 0, 'tables': tables}


def interpret(source, **limits):
    return encode(Parser(source, **limits).parse())


def decode(document):
    need(type(document) is dict and document.get('format') == 'lua-table-graph-v1' and type(document.get('root')) is int and document['root'] == 0, 'invalid graph header')
    rows = document.get('tables')
    need(type(rows) is list and 0 < len(rows) <= 300_000, 'invalid table list')
    tables = [Table() for _ in rows]
    def value(token, is_key=False):
        need(type(token) is list and len(token) == 2, 'invalid value token')
        t, v = token
        if t == 't':
            need(not is_key and type(v) is int and 0 <= v < len(tables), 'bad table reference')
            return tables[v]
        if t == 'b': need(type(v) is bool, 'bad boolean'); return v
        need(type(v) is str, 'numeric/string payload must be a string')
        if t == 'i':
            need(re.fullmatch(r'-?(0|[1-9][0-9]*)', v) is not None, 'bad integer token')
            n = int(v); need(-(1 << 63) <= n < (1 << 63) and str(n) == v, 'integer overflow/noncanonical')
            return n
        if t in ('s', 'f'):
            need(len(v) % 2 == 0 and re.fullmatch(r'[0-9a-f]*', v) is not None, 'invalid hex payload')
            raw = bytes.fromhex(v)
            if t == 's': return raw
            need(len(raw) == 8, 'bad float payload')
            n = struct.unpack('<d', raw)[0]; need(math.isfinite(n), 'nonfinite float'); return n
        raise DataError('unknown scalar tag')
    for tab, entries in zip(tables, rows):
        need(type(entries) is list, 'invalid entries')
        for entry in entries:
            need(type(entry) is list and len(entry) == 2, 'invalid entry')
            k = value(entry[0], True)
            need(key(k) not in tab.entries, 'duplicate/equivalent key')
            put(tab, k, value(entry[1]))
    need(encode(tables[0]) == document, 'graph must be canonical and contain exactly the reachable tables')
    return tables[0]
