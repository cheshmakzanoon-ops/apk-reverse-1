local LWBuffTemplate = BaseClass("LWBuffTemplate")

local function __init(self)
end

local function __delete(self)
  self.sound_id_buff = nil
  self.name = nil
  self.desc = nil
end

local function InitData(self, row)
  if row == nil then
    return
  end
  self.id = tonumber(row:getValue("id")) or 0
  self.type = tonumber(row:getValue("type")) or 0
  self.buff_timeArr = row:getValue("buff_time") or {}
  if not self.buff_timeArr[1] then
    self.buff_time = 0
  else
    self.buff_time = tonumber(self.buff_timeArr[1]) or 0
    self.buff_time = self.buff_time * 0.001
  end
  self.buffBaseTime = self.buff_time
  if not self.buff_timeArr[2] then
    self.buffLvAddTime = 0
  else
    self.buffLvAddTime = tonumber(self.buff_timeArr[2]) or 0
    self.buffLvAddTime = self.buffLvAddTime * 0.001
  end
  self.additive_type = tonumber(row:getValue("additive_type")) or 0
  self.max_level = tonumber(row:getValue("max_level")) or 0
  self.group = tonumber(row:getValue("group")) or 0
  self.active_effect = row:getValue("active_effect")
  self.activing_effect = row:getValue("activing_effect")
  self.ignore_rotate = row:getValue("ignore_rotate") == "1"
  self.sub_type = tonumber(row:getValue("sub_type")) or 0
  self.para = {}
  self.sortedParaKey = {}
  self.diffValue = {}
  local para = row:getValue("para")
  self.rawPara = para
  if self.sub_type == BuffSubType.ShieldFromCasterHp or self.sub_type == BuffSubType.ShieldFromValue then
    if self.type == BuffType.Shield then
      local pair = string.split(para, ";")
      if pair and 1 <= #pair then
        self.para = tonumber(pair[1])
      else
        Logger.LogError("lw_buff\232\161\168para\229\143\130\230\149\176\233\133\141\231\189\174\233\148\153\232\175\175\239\188\154id=" .. self.id)
        self.para = 0
      end
    else
      self.para = tonumber(para)
    end
  elseif self.type == BuffType.ModelScale then
    self.para = tonumber(para)
  elseif self.type == BuffType.Dot then
    local strs = string.split(para, ";")
    local count = #strs
    if count < 4 then
      Logger.LogError("lw_buff\232\161\168dot\229\143\130\230\149\176\233\133\141\231\189\174\233\148\153\232\175\175\239\188\154id=" .. self.id)
    end
    for i = 1, count do
      self.para[i] = tonumber(strs[i])
    end
  elseif self.type == BuffType.NewHot or self.type == BuffType.ChangeMaxBlood then
    local strs = string.split(para, ";")
    local count = #strs
    for i = 1, count do
      self.para[i] = tonumber(strs[i])
    end
  elseif self.type == BuffType.Transformer then
    self.para = para
  elseif self.type == BuffType.Tornado then
    local strs = string.split(para, ";")
    if #strs < 4 then
      Logger.LogError("lw_buff\232\161\168Tornado\229\143\130\230\149\176\233\133\141\231\189\174\233\148\153\232\175\175\239\188\154id=" .. self.id)
    else
      for i = 1, 4 do
        self.para[i] = tonumber(strs[i])
      end
    end
  elseif not string.IsNullOrEmpty(para) then
    local strs = string.split(para, ",")
    for _, str in pairs(strs) do
      local pair = string.split(str, ";")
      self.para[tonumber(pair[1])] = tonumber(pair[2])
      table.insert(self.sortedParaKey, tonumber(pair[1]))
      if pair[3] then
        self.diffValue[tonumber(pair[1])] = tonumber(pair[3])
      end
    end
  end
  self.sound_id_buff = row:getValue("sound_id_buff") or 0
  local level_effect = row:getValue("level_effect") or {}
  self.level_effect = nil
  if not table.IsNullOrEmpty(level_effect) then
    local count = 1
    for level, effectPath in pairs(level_effect) do
      if not self.level_effect then
        self.level_effect = {}
      end
      self.level_effect[count] = {
        level = tonumber(level),
        path = effectPath
      }
      count = count + 1
    end
    if self.level_effect then
      table.sort(self.level_effect, function(a, b)
        return a.level < b.level
      end)
    end
  end
  self.name = row:getValue("name") or ""
  self.desc = row:getValue("desc") or ""
  self.buff_path = row:getValue("buff_path") or 1
  self.obtain_dialog_effect = row:getValue("obtain_dialog_effect") or ""
  self.is_debuff = tonumber(row:getValue("is_debuff")) == 1
  self.buff_icon = row:getValue("icon") or ""
  self.remove_convert = row:getValue("remove_convert") or 0
  self.add_buff_max_level = row:getValue("add_buff_max_level") or 0
  self.add_buff_order = row:getValue("add_buff_order") or 0
end

local function GetParaByLevel(self, level)
  level = level or 1
  if not table.IsNullOrEmpty(self.para) then
    local para = {}
    for __, paraKey in pairs(self.sortedParaKey) do
      local effectId = paraKey
      local value = self.para[effectId]
      local effect = {}
      effect.key = effectId
      effect.value = value
      if self.diffValue[effectId] then
        effect.value = effect.value + level * self.diffValue[effectId]
      end
      table.insert(para, effect)
    end
    return para
  else
    return {}
  end
end

local function GetParaDictByLevel(self, level)
  level = level or 0
  local ret = {}
  if self.para then
    for key, value in pairs(self.para) do
      local diffVal = self.diffValue[key]
      if not diffVal then
        diffVal = 0
        Logger.LogError("lw_buff\232\161\168para\229\143\130\230\149\176\230\178\161\233\133\141\231\172\172\228\184\137\228\184\170\229\128\188\233\148\153\232\175\175\239\188\154id=" .. self.id)
      end
      ret[key] = value + level * diffVal
    end
  end
  return ret
end

local function GetParaByLevelIndex(self, level, index)
  local level = level
  level = level or 1
  if not table.IsNullOrEmpty(self.para) then
    local para = {}
    if self.sortedParaKey[index] then
      local effectId = self.sortedParaKey[index]
      local value = self.para[effectId]
      local effect = {}
      effect.key = effectId
      effect.value = value
      if self.diffValue[effectId] then
        effect.value = effect.value + level * self.diffValue[effectId]
      end
      return effect
    end
    return nil
  else
    return nil
  end
end

local function GetActivingEffectPathByLevel(self, level)
  if not table.IsNullOrEmpty(self.level_effect) then
    for i = #self.level_effect, 1, -1 do
      if level >= self.level_effect[i].level then
        return self.level_effect[i].path, self.level_effect[i].level
      end
    end
  end
  return self.activing_effect, 0
end

local function GetTime(self, lv)
  local _lv = 1
  if lv and 0 < lv then
    _lv = lv
  end
  return self.buff_time + self.buffLvAddTime * _lv
end

LWBuffTemplate.__init = __init
LWBuffTemplate.__delete = __delete
LWBuffTemplate.InitData = InitData
LWBuffTemplate.GetParaByLevel = GetParaByLevel
LWBuffTemplate.GetParaDictByLevel = GetParaDictByLevel
LWBuffTemplate.GetParaByLevelIndex = GetParaByLevelIndex
LWBuffTemplate.GetActivingEffectPathByLevel = GetActivingEffectPathByLevel
LWBuffTemplate.GetTime = GetTime
return LWBuffTemplate
