local ActSlotMachineDataManager = BaseClass("ActSlotMachineDataManager")
local Localization = CS.GameEntry.Localization
local ActSlotMachineData = require("DataCenter.ActSlotMachineManager.ActSlotMachineData")
local ActivitySlotsBoxTemplate = require("DataCenter.ActSlotMachineManager.ActivitySlotsBoxTemplate")
local ActivitySlotsGroupTemplate = require("DataCenter.ActSlotMachineManager.ActivitySlotsGroupTemplate")
local ActivitySlotsIconTemplate = require("DataCenter.ActSlotMachineManager.ActivitySlotsIconTemplate")
local ActivitySlotsPicTemplate = require("DataCenter.ActSlotMachineManager.ActivitySlotsPicTemplate")
local ActivitySlotsDropShowTemplate = require("DataCenter.ActSlotMachineManager.ActivitySlotsDropShowTemplate")

local function __init(self)
  self.dataDict = {}
  self.boxTempDict = {}
  self.groupTempDict = {}
  self.groupResultDataDict = {}
  self.iconDict = {}
  self.picDict = {}
  self.ActSlotRollResultTypeToIconId = {}
  self.dropShowDict = {}
  self:InitTemplate()
end

local function __delete(self)
  self.dataDict = nil
  self.boxTempDict = nil
  self.groupTempDict = nil
  self.groupResultDataDict = nil
  self.iconDict = nil
  self.picDict = nil
  self.ActSlotRollResultTypeToIconId = nil
end

local function RefreshActDetailData(self, message)
  local activityId = tonumber(message.activityId)
  if self.dataDict[activityId] == nil then
    self.dataDict[activityId] = ActSlotMachineData.New()
  end
  self.dataDict[activityId]:ParseData(message)
end

local function InitTemplate(self)
  LocalController:instance():visitTable(TableName.ActivitySlotsBox, function(id, line)
    local template = ActivitySlotsBoxTemplate.New()
    template:InitData(line)
    local group = template.groupid
    if self.boxTempDict[group] == nil then
      self.boxTempDict[group] = {}
    end
    self.boxTempDict[group][id] = template
  end)
  LocalController:instance():visitTable(TableName.ActivitySlotsGroup, function(id, line)
    local template = ActivitySlotsGroupTemplate.New()
    template:InitData(line)
    local group = template.groupid
    if self.groupTempDict[group] == nil then
      self.groupTempDict[group] = {}
    end
    self.groupTempDict[group][id] = template
    if self.ActSlotRollResultTypeToIconId[group] == nil then
      self.ActSlotRollResultTypeToIconId[group] = {}
    end
    if self.ActSlotRollResultTypeToIconId[group][template.type] == nil then
      local iconList = line.type_icon_list
      if not string.IsNullOrEmpty(iconList) then
        self.ActSlotRollResultTypeToIconId[group][template.type] = string.string2array_num_oneSep(iconList, "|")
      end
    end
  end)
  LocalController:instance():visitTable(TableName.ActivitySlotsIcon, function(id, line)
    local template = ActivitySlotsIconTemplate.New()
    template:InitData(line)
    self.iconDict[id] = template
  end)
  LocalController:instance():visitTable(TableName.ActivitySlotsPic, function(id, line)
    local template = ActivitySlotsPicTemplate.New()
    template:InitData(line)
    local group = template.groupid
    local list_id = template.list_id
    if self.picDict[group] == nil then
      self.picDict[group] = {}
    end
    if self.picDict[group][list_id] == nil then
      self.picDict[group][list_id] = {}
    end
    table.insert(self.picDict[group][list_id], template)
  end)
  for k, v in pairs(self.picDict) do
    for k1, v1 in pairs(v) do
      table.sort(v1, function(a, b)
        return a.order < b.order
      end)
    end
  end
  LocalController:instance():visitTable(TableName.ActivitySlotsDropShow, function(id, line)
    local template = ActivitySlotsDropShowTemplate.New()
    template:InitData(line)
    local group = template.groupid
    local type_para = template.type_para
    if self.dropShowDict[group] == nil then
      self.dropShowDict[group] = {}
    end
    self.dropShowDict[group][type_para] = template
  end)
end

local function GetGroupResultDataDict(self, groupId)
  if self.groupResultDataDict[groupId] == nil then
    self.groupResultDataDict[groupId] = {}
    local groupData = self.groupResultDataDict[groupId]
    local totalWeight = 0
    local groupTempData = self.groupTempDict[groupId]
    if groupTempData then
      for k, v in pairs(groupTempData) do
        local type = v.type
        if groupData[type] == nil then
          groupData[type] = {}
          groupData[type].type = type
          groupData[type].temp = v
          groupData[type].weight = 0
          groupData[type].weightRate = 0
        end
        groupData[type].weight = groupData[type].weight + v.weight
        totalWeight = totalWeight + v.weight
      end
    end
    for k, v in pairs(groupData) do
      v.weightRate = v.weight / totalWeight
    end
  end
  return self.groupResultDataDict[groupId]
end

local function GetActData(self, activityId)
  local data
  data = self.dataDict[activityId]
  return data
end

local function UpdateDailyRewardData(self, message)
  local activityId = message.activity
  if self.dataDict[activityId] == nil then
    return
  end
  self.dataDict[activityId]:UpdateDailyRewardData(message)
end

local function CanGetFreePack(self, actId)
  if self.dataDict[actId] then
    return self.dataDict[actId]:CanGetFreePack()
  end
  return false
end

local function CanGotoPackShop(self, actId)
  if self.dataDict[actId] then
    return self.dataDict[actId]:CanGotoPackShop()
  end
  return false
end

local function GetKeyGiftPackId(self, actId)
  if self.dataDict[actId] then
    return self.dataDict[actId]:GetGiftPackId()
  end
end

local function GetRedNum(self, actId)
  local num = 0
  if self.dataDict[actId] then
    num = self.dataDict[actId]:GetRedNum()
  end
  if 0 < num then
    num = 1
  end
  return num
end

local function UpdateLotteyMessage(self, message)
  local activityId = message.activityId
  if self.dataDict[activityId] == nil then
    return
  end
  self.dataDict[activityId]:UpdateLotteyMessage(message)
end

local function UpdateProgressRewardMessage(self, message)
  local activityId = message.activityId
  if self.dataDict[activityId] == nil then
    return
  end
  self.dataDict[activityId]:UpdateProgressRewardMessage(message)
end

local function UpdateBoxMessage(self, message)
  local activityId = message.activity
  if self.dataDict[activityId] == nil then
    return
  end
  self.dataDict[activityId]:UpdateBoxMessage(message)
end

local function UpdateActTasks(self, message)
  local activityId = message.aid
  if self.dataDict[activityId] == nil then
    return
  end
  self.dataDict[activityId]:UpdateActTasks(message)
end

local function GetOneTaskReward(self, message)
  local activityId = message.activity
  if self.dataDict[activityId] == nil then
    return
  end
  self.dataDict[activityId]:GetOneTaskReward(message)
end

local function SetHistoryLogData(self, message)
  local activityId = message.activityId
  if self.dataDict[activityId] == nil then
    return
  end
  self.dataDict[activityId]:SetHistoryLogData(message)
end

local function GetGroupTemplate(self, group, id)
  if not group or not id then
    return nil
  end
  local _numId = tonumber(id)
  local _group = tonumber(group)
  if not self.groupTempDict[_group] then
    return nil
  end
  return self.groupTempDict[_group][_numId]
end

local function GetIconTemplate(self, id)
  if not id then
    return nil
  end
  local _numId = tonumber(id)
  return self.iconDict[_numId]
end

local function GetDropShowRate(self, group, type_para)
  local rateNum = 0
  if self.dropShowDict[group] and self.dropShowDict[group][type_para] then
    rateNum = self.dropShowDict[group][type_para].drop_show
  end
  return rateNum
end

function ActSlotMachineDataManager:GetServerTimeStr(time)
  local str = ""
  local format = UITimeManager:GetInstance():TimeStampToServerDate(time)
  str = string.format("%d-%d", format.month, format.day)
  return str
end

function ActSlotMachineDataManager:GetServerTimeHMSStr(time)
  local str = ""
  local format = UITimeManager:GetInstance():TimeStampToServerDate(time)
  str = string.format("%d-%d %02d:%02d:%02d", format.month, format.day, format.hour, format.min, format.sec)
  return str
end

function ActSlotMachineDataManager:GetHistroyLogOnePageNum()
  local itemNum = 50
  return itemNum
end

ActSlotMachineDataManager.__init = __init
ActSlotMachineDataManager.__delete = __delete
ActSlotMachineDataManager.RefreshActDetailData = RefreshActDetailData
ActSlotMachineDataManager.InitTemplate = InitTemplate
ActSlotMachineDataManager.GetActData = GetActData
ActSlotMachineDataManager.UpdateDailyRewardData = UpdateDailyRewardData
ActSlotMachineDataManager.CanGotoPackShop = CanGotoPackShop
ActSlotMachineDataManager.CanGetFreePack = CanGetFreePack
ActSlotMachineDataManager.GetKeyGiftPackId = GetKeyGiftPackId
ActSlotMachineDataManager.GetRedNum = GetRedNum
ActSlotMachineDataManager.GetGroupResultDataDict = GetGroupResultDataDict
ActSlotMachineDataManager.UpdateLotteyMessage = UpdateLotteyMessage
ActSlotMachineDataManager.UpdateProgressRewardMessage = UpdateProgressRewardMessage
ActSlotMachineDataManager.UpdateBoxMessage = UpdateBoxMessage
ActSlotMachineDataManager.GetOneTaskReward = GetOneTaskReward
ActSlotMachineDataManager.UpdateActTasks = UpdateActTasks
ActSlotMachineDataManager.SetHistoryLogData = SetHistoryLogData
ActSlotMachineDataManager.GetGroupTemplate = GetGroupTemplate
ActSlotMachineDataManager.GetIconTemplate = GetIconTemplate
ActSlotMachineDataManager.GetDropShowRate = GetDropShowRate
return ActSlotMachineDataManager
