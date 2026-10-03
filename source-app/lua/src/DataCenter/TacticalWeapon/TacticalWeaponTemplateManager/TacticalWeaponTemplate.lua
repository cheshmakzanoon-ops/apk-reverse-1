local TacticalWeaponTemplate = BaseClass("TacticalWeaponTemplate")

local function __init(self)
  self.id = 0
  self.name = ""
  self.maxLevel = 0
  self.levelId = {}
  self.base_attr = {}
end

local function __delete(self)
  self.id = nil
  self.name = nil
  self.maxLevel = nil
  self.levelId = nil
  self.base_attr = nil
end

local function InitData(self, row)
  if row == nil then
    return
  end
  self.id = row:getValue("id")
  self.name = row:getValue("name") or ""
  self.maxLevel = row:getValue("MaxLevel") or 0
  self.levelId = row:getValue("level_id") or {}
  self.base_attr = row:getValue("base_attr") or {}
end

local function GetLevelTemplateId(self, level)
  if level <= 0 or level > self.maxLevel + DataCenter.TacticalWeaponManager:GetMainWeaponMaxLevelExtra() then
    return 0
  end
  return self.levelId[1] + level - 1
end

TacticalWeaponTemplate.__init = __init
TacticalWeaponTemplate.__delete = __delete
TacticalWeaponTemplate.InitData = InitData
TacticalWeaponTemplate.GetLevelTemplateId = GetLevelTemplateId
return TacticalWeaponTemplate
