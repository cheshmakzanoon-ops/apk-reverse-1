local UIDetectEventLevelUpCtrl = BaseClass("UIDetectEventLevelUpCtrl", UIBaseCtrl)
local Localization = CS.GameEntry.Localization

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIDetectEventLevelUp)
end

local function GetEventRecoverNum(self, level)
  if level == nil then
    level = DataCenter.RadarCenterDataManager:GetDetectInfoLevel()
  end
  if level == nil then
    return 0
  end
  local num = 0
  local numStr = ""
  local template = LocalController:instance():getLine(LuaEntry.Player:GetABTestTableName(TableName.DETECT_LEVEL), level)
  if template ~= nil then
    numStr = template.refresh
    local numStrArry = string.split(numStr, ";")
    if 2 <= #numStrArry then
      num = tonumber(numStrArry[2])
    end
  end
  return num
end

local function GetEventStoreMax(self, level)
  if level == nil then
    level = DataCenter.RadarCenterDataManager:GetDetectInfoLevel()
  end
  if level < 1 then
    return 1
  end
  local num = 1
  local template = LocalController:instance():getLine(LuaEntry.Player:GetABTestTableName(TableName.DETECT_LEVEL), level)
  if template ~= nil then
    num = template.detect_max_num
  end
  return num
end

local function GetDetectEventNum(self, level)
  local maxLv = self:GetDetectEventMaxLevel()
  level = math.min(level, maxLv)
  local eventNum = 1
  local template = LocalController:instance():getLine(LuaEntry.Player:GetABTestTableName(TableName.DETECT_LEVEL), level)
  if template ~= nil then
    eventNum = template.detect_show_num
  end
  return eventNum
end

local function GetEventResEffect(self, level)
  local maxLv = self:GetDetectEventMaxLevel()
  level = math.min(level, maxLv)
  local effectNum = 0
  local template = LocalController:instance():getLine(LuaEntry.Player:GetABTestTableName(TableName.DETECT_LEVEL), level)
  if template ~= nil then
    effectNum = tonumber(template.res_increase_num) or 0
  end
  return effectNum
end

local function GetDetectEventMaxLevel(self)
  local result = DataCenter.DetectLevelTemplateManager:GetMaxLevel()
  return result
end

UIDetectEventLevelUpCtrl.CloseSelf = CloseSelf
UIDetectEventLevelUpCtrl.GetEventStoreMax = GetEventStoreMax
UIDetectEventLevelUpCtrl.GetEventRecoverNum = GetEventRecoverNum
UIDetectEventLevelUpCtrl.GetDetectEventNum = GetDetectEventNum
UIDetectEventLevelUpCtrl.GetEventResEffect = GetEventResEffect
UIDetectEventLevelUpCtrl.GetDetectEventMaxLevel = GetDetectEventMaxLevel
return UIDetectEventLevelUpCtrl
