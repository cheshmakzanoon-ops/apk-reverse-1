local HeroRankTemplate = BaseClass("HeroTemplate")

local function __init(self)
  self.id = 0
  self.name = ""
  self.attr_add = {}
  self.star_show = {}
  self.attr_ratio = 0
  self.shard_need = 0
  self.icon = ""
  self.small_icon = ""
  self.shard_need_promotion = 0
end

local function __delete(self)
  self.id = nil
  self.name = nil
  self.attr_add = nil
  self.star_show = nil
  self.attr_ratio = nil
  self.shard_need = nil
  self.icon = nil
  self.small_icon = nil
  self.shard_need_promotion = nil
end

local function InitData(self, row)
  if row == nil then
    return
  end
  self.id = row:getValue("id") or 0
  self.name = row:getValue("name") or ""
  self.attr_add = row:getValue("attr_add") or {}
  self.star_show = row:getValue("star_show") or {}
  self.attr_ratio = row:getValue("attr_ratio") or 0
  self.shard_need = row:getValue("shard_need") or 0
  self.icon = row:getValue("icon") or ""
  self.small_icon = row:getValue("icon_simple") or ""
  self.shard_need_promotion = row:getValue("shard_need_promotion") or 0
end

local function GetStarCount(self)
  local curCount = 0
  local maxCount = 0
  if self.star_show[1] then
    curCount = self.star_show[1]
  end
  if self.star_show[2] then
    maxCount = self.star_show[2]
  end
  return curCount, maxCount
end

local function GetEffectAdd(self, effctId, formatted)
  local add = 0
  if self.attr_add[effctId] then
    add = self.attr_add[effctId]
  end
  if not formatted then
    return add
  else
    return tostring(math.floor(add))
  end
end

local function GetEffectRatio(self)
  return self.attr_ratio
end

local function GetEffectRatioStr(self)
  local temp = (self.attr_ratio - 1) * 100
  local str = string.format("%s%%", tostring(temp))
  return str
end

local function GetAddEffect(self, effectId)
  if self.attr_add[effectId] then
    return self.attr_add[effectId]
  end
  return 0
end

HeroRankTemplate.__init = __init
HeroRankTemplate.__delete = __delete
HeroRankTemplate.InitData = InitData
HeroRankTemplate.GetStarCount = GetStarCount
HeroRankTemplate.GetEffectAdd = GetEffectAdd
HeroRankTemplate.GetEffectRatio = GetEffectRatio
HeroRankTemplate.GetEffectRatioStr = GetEffectRatioStr
HeroRankTemplate.GetAddEffect = GetAddEffect
return HeroRankTemplate
