local TacticalWeaponLevelTemplateManager = BaseClass("TacticalWeaponLevelTemplateManager")
local TacticalWeaponLevelTemplate = require("DataCenter.TacticalWeapon.TacticalWeaponLevelTemplateManager.TacticalWeaponLevelTemplate")

local function __init(self)
  self.templateDic = {}
  self.templateSubLevelMap = {}
  self.templateLv2AppearanceIdDic = {}
  self:InitTemplate()
end

local function __delete(self)
  self.templateDic = nil
  self.templateSubLevelMap = nil
  self.templateLv2AppearanceIdDic = nil
end

local function InitTemplate(self)
  LocalController:instance():visitTable(TableName.LW_UAV_LEVEL, function(id, line)
    if line.upgradeType == 2 then
      local subLevelDic = self.templateSubLevelMap[line.level]
      subLevelDic = subLevelDic or {}
      subLevelDic[line.sub_level] = id
      self.templateSubLevelMap[line.level] = subLevelDic
    end
    self.templateLv2AppearanceIdDic[line.level] = line.appearance
  end)
end

local function GetTemplate(self, idKey)
  local id = tonumber(idKey)
  if self.templateDic[id] == nil then
    local oneTemplate = LocalController:instance():getLine(TableName.LW_UAV_LEVEL, id)
    if oneTemplate ~= nil then
      local item = TacticalWeaponLevelTemplate.New()
      item:InitData(oneTemplate)
      if item.id ~= nil then
        self.templateDic[item.id] = item
      end
    end
  end
  return self.templateDic[id]
end

local function GetTemplateByLevel(self, level)
  local id = level + 1000
  return self:GetTemplate(id)
end

local function TryGetSubLevelDic(self, level)
  if self.templateSubLevelMap[level] then
    local dic = {}
    for i, id in pairs(self.templateSubLevelMap[level]) do
      if id then
        local template = self:GetTemplate(id)
        dic[template.sub_level] = template
      end
    end
    return true, dic
  end
  return false
end

local function TryGetAppearanceIdByLv(self, level)
  if self.templateLv2AppearanceIdDic[level] then
    return true, self.templateLv2AppearanceIdDic[level]
  end
  return false
end

TacticalWeaponLevelTemplateManager.__init = __init
TacticalWeaponLevelTemplateManager.__delete = __delete
TacticalWeaponLevelTemplateManager.GetTemplate = GetTemplate
TacticalWeaponLevelTemplateManager.InitTemplate = InitTemplate
TacticalWeaponLevelTemplateManager.TryGetSubLevelDic = TryGetSubLevelDic
TacticalWeaponLevelTemplateManager.TryGetAppearanceIdByLv = TryGetAppearanceIdByLv
TacticalWeaponLevelTemplateManager.GetTemplateByLevel = GetTemplateByLevel
return TacticalWeaponLevelTemplateManager
