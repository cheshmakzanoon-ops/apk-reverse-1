local ActFestivalPopUpManager = BaseClass("ActFestivalPopUpManager")
local Localization = CS.GameEntry.Localization
local FestivalInterfaceConfigTemplate = require("DataCenter.ActFestivalPopUpManager.FestivalInterfaceConfigTemplate")

local function __init(self)
  self:AddListener()
  self.festivalTemplateDic = {}
end

local function __delete(self)
  self:RemoveListener()
  self.festivalTemplateDic = nil
end

local function AddListener(self)
end

local function RemoveListener(self)
end

function ActFestivalPopUpManager:CheckActFestivalUseNewSkin(activityId, uiWindowNames)
  local festivalTemplate = self:GetTemplate(activityId)
  if festivalTemplate == nil then
    return false
  end
  return festivalTemplate:CheckActFestivalUseNewSkin(activityId, uiWindowNames)
end

function ActFestivalPopUpManager:GetTemplate(activityId)
  local activityData = DataCenter.ActivityListDataManager:GetActivityDataById(activityId)
  if activityData == nil then
    return nil
  end
  if string.IsNullOrEmpty(activityData.festival_interface_config) then
    return nil
  end
  if self.festivalTemplateDic[activityData.festival_interface_config] == nil then
    local rowData = LocalController:instance():getLine(TableName.Festival_Interface_Config, activityData.festival_interface_config)
    if rowData == nil then
      Logger.LogError("Festival_Interface_Config GetTemplate lineData is nil id:" .. activityData.festival_interface_config)
      return nil
    end
    local template = FestivalInterfaceConfigTemplate.New()
    template:UpdateData(rowData)
    self.festivalTemplateDic[activityData.festival_interface_config] = template
  end
  return self.festivalTemplateDic[activityData.festival_interface_config]
end

function ActFestivalPopUpManager:CheckLoadEffect(activityId, uiWindowName)
  local festivalTemplate = self:GetTemplate(activityId)
  if festivalTemplate == nil then
    return false
  end
  return festivalTemplate:CheckLoadEffect(activityId, uiWindowName)
end

function ActFestivalPopUpManager:CheckShowBottomNode(activityId, uiWindowName)
  local festivalTemplate = self:GetTemplate(activityId)
  if festivalTemplate == nil then
    return false
  end
  return festivalTemplate:CheckShowBottomNode(activityId, uiWindowName)
end

function ActFestivalPopUpManager:TryChangeActPackingId(activityId)
  local festivalPackagingCfgId
  local actData = DataCenter.ActivityListDataManager:GetActivityDataById(activityId)
  if actData and actData.festivalEntranceeffect and actData.festivalEntranceeffect > 0 then
    local line = LocalController:instance():getLine(TableName.ACTIVITY_ENTRANCE_CONFIG, actData.festivalEntranceeffect)
    if not line then
      return nil
    end
    if not line.festival_skin then
      return nil
    end
    local festivalSkinList = string.split(line.festival_skin, "|")
    local targetIndex = self:GetShowTargetIndex(line)
    festivalPackagingCfgId = tonumber(festivalSkinList[targetIndex])
    return festivalPackagingCfgId
  end
end

function ActFestivalPopUpManager:GetActStartTime(actId)
  local time = 0
  local tabData = LocalController:instance():getLine(TableName.Activity, toInt(actId))
  local AbsoluteTimeType = "101"
  if tabData and tabData.timeType == AbsoluteTimeType then
    local startTimeStr = tabData.para1
    local absoluteTime = UIUtil.GetAbsoluteTimeByStr(startTimeStr)
    if absoluteTime then
      time = absoluteTime * 1000
      time = time - 10000
    end
  end
  return time
end

function ActFestivalPopUpManager:GetShowTargetIndex(line)
  local targetIndex = 1
  if not string.IsNullOrEmpty(line.extra_condition) then
    local dataList = string.string2array_num(line.extra_condition, ";", "|")
    if dataList and #dataList == 2 and #dataList[1] == 1 and #dataList[2] > 0 then
      local actId = dataList[1][1]
      local dayNumList = dataList[2]
      local curTime = UITimeManager:GetInstance():GetServerTime()
      local actStartTime = self:GetActStartTime(actId)
      local curDayNum = math.floor((curTime - actStartTime) / (OneDayTime * 1000)) + 1
      local findIndex = -1
      for i, v in ipairs(dayNumList) do
        if v > curDayNum then
          findIndex = i
          break
        end
      end
      if findIndex <= 0 then
        findIndex = #dayNumList + 1
      end
      targetIndex = findIndex
    end
  end
  return targetIndex
end

ActFestivalPopUpManager.__init = __init
ActFestivalPopUpManager.__delete = __delete
ActFestivalPopUpManager.AddListener = AddListener
ActFestivalPopUpManager.RemoveListener = RemoveListener
return ActFestivalPopUpManager
