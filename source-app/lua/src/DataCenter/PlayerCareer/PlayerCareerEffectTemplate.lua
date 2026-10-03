local PlayerCareerEffectTemplate = BaseClass("PlayerCareerEffectTemplate")

local function __init(self)
  self.id = 0
  self.type = 0
  self.name = 0
  self.description = 0
  self.icon = ""
  self.order = 0
  self.effects = {}
  self.effectVals = {}
  self.showTypes = {}
  self.show = 0
  self.cdTime = 0
end

local function __delete(self)
  self.id = nil
  self.type = nil
  self.name = nil
  self.description = nil
  self.icon = nil
  self.order = nil
  self.effects = nil
  self.effectVals = nil
  self.showTypes = nil
  self.show = nil
  self.cdTime = nil
end

local function InitData(self, row)
  if row == nil then
    return
  end
  self.id = tonumber(row:getValue("id")) or 0
  self.type = tonumber(row:getValue("type")) or 0
  self.name = tonumber(row:getValue("name")) or 0
  self.description = tonumber(row:getValue("description")) or 0
  self.icon = row:getValue("icon")
  self.order = tonumber(row:getValue("order")) or 0
  self.effects = {}
  local effectStr = row:getValue("effect")
  if not string.IsNullOrEmpty(effectStr) then
    for _, str in ipairs(string.split(effectStr, "|")) do
      table.insert(self.effects, tonumber(str))
    end
  end
  self.effectVals = {}
  local effectValStr = row:getValue("effect_value")
  if not string.IsNullOrEmpty(effectValStr) then
    for _, str in ipairs(string.split(effectValStr, "|")) do
      table.insert(self.effectVals, tonumber(str))
    end
  end
  self.showTypes = {}
  local showTypeStr = row:getValue("show_type")
  if not string.IsNullOrEmpty(showTypeStr) then
    for _, str in ipairs(string.split(showTypeStr, "|")) do
      table.insert(self.showTypes, tonumber(str))
    end
  end
  self.show = tonumber(row:getValue("show")) or 0
  self.cdTime = tonumber(row:getValue("cd_time")) or 0
end

local function GetIconPath(self)
  local icon = ""
  if string.startswith(self.icon, "career") then
    icon = string.format(LoadPath.UIPlayerCareer, self.icon)
  elseif string.startswith(self.icon, "UITechnology") then
    icon = string.format(LoadPath.ScienceIcons, self.icon)
  end
  return icon
end

PlayerCareerEffectTemplate.__init = __init
PlayerCareerEffectTemplate.__delete = __delete
PlayerCareerEffectTemplate.InitData = InitData
PlayerCareerEffectTemplate.GetIconPath = GetIconPath
return PlayerCareerEffectTemplate
