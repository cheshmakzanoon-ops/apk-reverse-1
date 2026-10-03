local base = require("DataCenter.TowerUpDataManager.TowerUpBaseTemplate")
local DominatorUpTemplate = BaseClass("DominatorUpTemplate", base)
local Localization = CS.GameEntry.Localization

local function __init(self)
  self.dominatorPositionType = 1
  self.dominatorWinType = 1
  self.dominatorTemporaryUse = nil
  self.powerRecommendData = nil
end

local function __delete(self)
  self.dominatorPositionType = nil
  self.dominatorWinType = nil
  self.dominatorTemporaryUse = nil
  self.powerRecommendData = nil
end

local function InitData(self, row)
  base.InitData(self, row)
  self.dominatorPositionType = tonumber(row:getValue("dominator_position_type"))
  self.dominatorWinType = tonumber(row:getValue("dominator_win_type"))
  local dominatorTemporaryUse = row:getValue("dominator_temporary_use")
  if not string.IsNullOrEmpty(dominatorTemporaryUse) then
    self.dominatorTemporaryUse = {}
    local split = string.split(dominatorTemporaryUse, ";")
    for i, v in ipairs(split) do
      table.insert(self.dominatorTemporaryUse, tonumber(v))
    end
  end
  local powerRecommend = row:getValue("power_recommend")
  if not string.IsNullOrEmpty(powerRecommend) then
    local split = string.split(powerRecommend, ";")
    if #split == 2 then
      self.powerRecommendData = {
        split[1],
        split[2]
      }
    end
  end
end

local function GetFormationPositionType(self)
  return self.dominatorPositionType
end

local function GetFormationSaveType(self)
  local positionType = self:GetFormationPositionType()
  if positionType == ArmyFormationPositionType.Normal then
    return FormationSaveType.DominatorNormal
  elseif positionType == ArmyFormationPositionType.DominatorAndHero345 then
    return FormationSaveType.DominatorAndHero345
  elseif positionType == ArmyFormationPositionType.OnlyDominator then
    return FormationSaveType.OnlyDominator
  end
  return FormationSaveType.PVESquad
end

local function GetPowerRecommendData(self)
  return self.powerRecommendData
end

DominatorUpTemplate.__init = __init
DominatorUpTemplate.__delete = __delete
DominatorUpTemplate.InitData = InitData
DominatorUpTemplate.GetFormationPositionType = GetFormationPositionType
DominatorUpTemplate.GetFormationSaveType = GetFormationSaveType
DominatorUpTemplate.GetPowerRecommendData = GetPowerRecommendData
return DominatorUpTemplate
