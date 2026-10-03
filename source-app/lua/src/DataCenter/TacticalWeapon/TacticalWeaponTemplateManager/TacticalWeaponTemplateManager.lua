local TacticalWeaponTemplateManager = BaseClass("TacticalWeaponTemplateManager")
local TacticalWeaponTemplate = require("DataCenter.TacticalWeapon.TacticalWeaponTemplateManager.TacticalWeaponTemplate")

local function __init(self)
  self.templateDic = {}
  self.normalStageUpgradeTempDic = {}
end

local function __delete(self)
  self.templateDic = nil
  self.normalStageUpgradeTempDic = nil
end

local function GetTemplate(self, id)
  if self.templateDic[tonumber(id)] == nil then
    local oneTemplate = LocalController:instance():getLine(TableName.LW_UAV, tostring(id))
    if oneTemplate ~= nil then
      local item = TacticalWeaponTemplate.New()
      item:InitData(oneTemplate)
      if item.id ~= nil then
        self.templateDic[item.id] = item
      end
    end
  end
  return self.templateDic[tonumber(id)]
end

function TacticalWeaponTemplateManager:GetNormalStageUpgradeTemplate(id)
  if self.templateDic[id] == nil then
    local oneTemplate = LocalController:instance():getLine(TableName.LW_UAV_UPGRADE, id)
    self.templateDic[id] = oneTemplate
  end
  return self.templateDic[id]
end

TacticalWeaponTemplateManager.__init = __init
TacticalWeaponTemplateManager.__delete = __delete
TacticalWeaponTemplateManager.GetTemplate = GetTemplate
return TacticalWeaponTemplateManager
