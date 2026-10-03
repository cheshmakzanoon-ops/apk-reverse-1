local ActInfiniteGiftTemplate = BaseClass("ActInfiniteGiftTemplate")
local Localization = CS.GameEntry.Localization

local function __init(self)
  self.id = 0
  self.type = 0
  self.gift_group = 0
  self.sub_group = 0
  self.exchangeId = 0
  self.reward1Id = 0
  self.reward2Id = 0
  self.show_values = {}
  self.pic_types = {}
  self.effects = {}
  self.items = {}
  self.can_refresh = 0
end

local function __delete(self)
end

local function InitConfig(self, row)
  if row == nil then
    return
  end
  self.id = tonumber(row:getValue("id")) or 0
  self.type = row:getValue("type") or 0
  self.gift_group = row:getValue("gift_group") or 0
  self.sub_group = row:getValue("sub_group") or 0
  self.exchangeId = tonumber(row:getValue("exchange")) or 0
  self.reward1Id = tonumber(row:getValue("reward")) or 0
  self.reward2Id = tonumber(row:getValue("reward2")) or 0
  self.show_values = row:getValue("show_value") or {}
  self.pic_types = row:getValue("pic_type") or {}
  self.effects = row:getValue("effect") or {}
  self.can_refresh = tonumber(row:getValue("can_refresh")) or 0
end

local function GetValueByIndex(self, index)
  return self.show_values[index] or 0
end

local function GetPicTypeByIndex(self, index)
  return self.pic_types[index] or 0
end

local function GetEffectByIndex(self, index)
  return self.effects[index] or 0
end

ActInfiniteGiftTemplate.__init = __init
ActInfiniteGiftTemplate.__delete = __delete
ActInfiniteGiftTemplate.InitConfig = InitConfig
ActInfiniteGiftTemplate.GetValueByIndex = GetValueByIndex
ActInfiniteGiftTemplate.GetPicTypeByIndex = GetPicTypeByIndex
ActInfiniteGiftTemplate.GetEffectByIndex = GetEffectByIndex
return ActInfiniteGiftTemplate
