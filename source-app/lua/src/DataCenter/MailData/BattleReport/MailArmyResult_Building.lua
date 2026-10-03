local Localization = CS.GameEntry.Localization
local MailArmyResultBase = require("DataCenter.MailData.BattleReport.MailArmyResultBase")
local MailArmyResult_Building = BaseClass("MailArmyResult_Building", MailArmyResultBase)

function MailArmyResult_Building:InitData(armyResult)
  MailArmyResultBase.InitData(self, armyResult)
  self._isDefeat = armyResult.isDefeat
  local armyResultByType = self:GetArmyResultByType(armyResult)
  self._cityLevel = armyResultByType.level or 0
  self._buildId = armyResultByType.buildId or 0
  local _armyResultBase = armyResultByType.base
  if _armyResultBase == nil then
    return
  end
  local armyObj = _armyResultBase.armyObj or {}
  self._armyObj = self:InitCombatUnitData(armyObj)
  local afterArmyObj = _armyResultBase.afterArmyObj or {}
  self._afterArmyObj = self:InitCombatUnitData(afterArmyObj)
  self:CheckArmyObj()
  self:InitDestroyValue(_armyResultBase)
  self:InitDamagePercentInfo(_armyResultBase)
end

function MailArmyResult_Building:GetName()
  if self._unitType == BattleType.Turret then
    local strLevel = Localization:GetString("300665", self._cityLevel)
    return strLevel .. " " .. Localization:GetString("300626")
  else
    local template = DataCenter.BuildTemplateManager:GetBuildingDesTemplate(self._buildId)
    if template ~= nil then
      local strLevel = Localization:GetString("300665", self._cityLevel)
      return strLevel .. " " .. Localization:GetString(template.name)
    end
  end
end

function MailArmyResult_Building:GetPic()
  return DataCenter.BuildManager:GetBuildIconPath(self._buildId, self._cityLevel)
end

function MailArmyResult_Building:GetBuildId()
  return self._buildId
end

function MailArmyResult_Building:GetName_ForShare()
  local param = {type = "dialog"}
  if self._unitType == BattleType.Turret then
    param.level = self._cityLevel
    param.name = "300626"
  else
    local template = DataCenter.BuildTemplateManager:GetBuildingDesTemplate(self._buildId)
    if template ~= nil then
      param.level = self._cityLevel
      param.name = template.name
    end
  end
  return param
end

return MailArmyResult_Building
