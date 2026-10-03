local AllianceHelpShowData = {
  helpId = "",
  uid = "",
  name = "",
  des = "",
  isSelf = false,
  nowCount = 0,
  maxCount = 0
}
local AllianceHelpDataManager = BaseClass("AllianceHelpDataManager")
local OneData = DataClass("OneData", AllianceHelpShowData)
local table_walk = table.walk
local table_insert = table.insert
local DataCenter = _ENV.DataCenter
local AllianceHelpType = _ENV.AllianceHelpType
local Localization = CS.GameEntry.Localization
local LuaEntry = _ENV.LuaEntry

local function __init(self)
  self.helpNum = 0
  self.otherHelpInfoList = {}
  self.myHelpInfoList = {}
  self.todayHelpPoint = 0
  self.refreshTime = 0
  self.maxHelpCount = LuaEntry.DataConfig:TryGetNum("alliance_help", "k4")
end

local function __delete(self)
  self.helpNum = nil
  self.otherHelpInfoList = nil
  self.myHelpInfoList = nil
  self.todayHelpPoint = nil
  self.refreshTime = nil
  self.maxHelpCount = nil
  if self.minuteTimer then
    self.minuteTimer:Stop()
    self.minuteTimer = nil
  end
end

function AllianceHelpDataManager:ResetData()
  self.helpNum = 0
  self.otherHelpInfoList = {}
  self.myHelpInfoList = {}
  self.todayHelpPoint = 0
  self.refreshTime = 0
end

local function GetTodayHelpPoint(self)
  return self.todayHelpPoint
end

local function ResetTodayHelpPoint(self)
  self.todayHelpPoint = 0
end

local function UpdateHelpInfoList(self, message)
  local refreshWholeList = false
  if message.helpArr ~= nil then
    self.otherHelpInfoList = {}
    if table.IsNotEmpty(self.myHelpInfoList) then
      self.completedInfoList = DeepCopy(self.myHelpInfoList)
    end
    self.myHelpInfoList = {}
    table.walk(message.helpArr, function(k, v)
      local info = AllianceHelpInfo.New()
      info:ParseData(v)
      if info.helpId ~= nil and info.helpId ~= "" then
        if info.stats == 1 then
          if info:CheckIsFinish() == false then
            self.otherHelpInfoList[info.helpId] = info
          end
        elseif info.stats == 0 then
          self.myHelpInfoList[info.helpId] = info
          if not self.completedInfoList then
            self.completedInfoList = {}
          end
          self.completedInfoList[info.helpId] = info
        end
      end
      EventManager:GetInstance():Broadcast(EventId.AllianceHelpUpdateSpeedUUid, info.content)
    end)
    self:SetHelpNum(table.count(self.otherHelpInfoList))
    refreshWholeList = true
  end
  if message.refreshTime ~= nil then
    self.refreshTime = message.refreshTime
  end
  if message.todayHelpPoint ~= nil and (not message.uid or message.uid == LuaEntry.Player.uid) then
    self.todayHelpPoint = message.todayHelpPoint
  end
  if refreshWholeList then
    EventManager:GetInstance():Broadcast(EventId.AllianceHelpSever)
    EventManager:GetInstance():Broadcast(EventId.AllianceHelpUpdateSpeed)
  end
end

local function RefreshAllianceHelp(self, message)
  if message.helpId ~= nil then
    local helpId = message.helpId
    local currentNum = message.nowCount
    if self.otherHelpInfoList[helpId] ~= nil then
      local data = self.otherHelpInfoList[helpId]
      data:SetNowCount(currentNum)
      if data:CheckIsFinish() then
        self:OnFinishAllianceHelp(helpId)
        EventManager:GetInstance():Broadcast(EventId.AllianceHelpSever)
      else
        local oneData = AllianceHelpDataManager.ConvertHelpInfo2ShowData(self, data, false)
        EventManager:GetInstance():Broadcast(EventId.AllianceHelpUpdateItem, oneData)
      end
    elseif self.myHelpInfoList[helpId] ~= nil then
      local data = self.myHelpInfoList[helpId]
      data:SetNowCount(currentNum)
      local oneData = AllianceHelpDataManager.ConvertHelpInfo2ShowData(self, data, true)
      EventManager:GetInstance():Broadcast(EventId.AllianceHelpUpdateItem, oneData)
      EventManager:GetInstance():Broadcast(EventId.AllianceHelpUpdateSpeed, message.queueId)
      EventManager:GetInstance():Broadcast(EventId.AllianceHelpUpdateSpeedUUid, message.queueId)
    elseif message.senderId and message.senderId == LuaEntry.Player.uid then
      SFSNetwork.SendMessage(MsgDefines.AllianceShowHelp)
    end
  end
end

local function OnFinishAllianceHelp(self, helpId)
  if self.otherHelpInfoList[helpId] ~= nil then
    self.otherHelpInfoList[helpId] = nil
  end
  self:SetHelpNum(table.count(self.otherHelpInfoList))
end

local function OnHelpAll(self)
  self.otherHelpInfoList = {}
  self:SetHelpNum(0)
end

local function SetHelpNum(self, count)
  if 0 < count then
    self.helpNum = count
  else
    self.helpNum = 0
  end
  EventManager:GetInstance():Broadcast(EventId.UpdateMainAllianceRedCount)
end

local function GetHelpNum(self)
  return self.helpNum
end

local function GetSelfHelpList(self)
  return self.myHelpInfoList
end

local function GetAllianceHelp(self, uuid)
  local selfList = AllianceHelpDataManager.GetSelfHelpList(self)
  if selfList then
    for key, helpData in pairs(selfList) do
      if helpData and helpData.content == uuid then
        return helpData
      end
    end
  end
  selfList = self.completedInfoList
  if selfList then
    for key, helpData in pairs(selfList) do
      if helpData and helpData.content == uuid then
        return helpData
      end
    end
  end
  return nil
end

local function GetOtherHelpList(self)
  return self.otherHelpInfoList
end

local function ConvertHelpInfo2ShowData(self, info, isSelf)
  if info == nil then
    return
  end
  local oneData = OneData.New()
  oneData.helpId = info.helpId
  oneData.uid = info.senderId
  oneData.name = info.name
  oneData.isSelf = isSelf
  oneData.pic = info.pic
  oneData.picVer = info.picVer
  oneData.headBg = info:GetHeadBgImg()
  oneData.reduceSec = info.reduceSec
  oneData.nowCount = info.nowCount
  oneData.maxCount = info.maxCount
  if info.helpType == AllianceHelpType.Queue then
    if info.queueType == NewQueueType.Science then
      local science = DataCenter.ScienceManager:GetScienceTemplate(tonumber(info.itemId))
      if science ~= nil then
        oneData.des = Localization:GetString("390113", Localization:GetString(science.name))
      end
    elseif info.queueType == NewQueueType.Hospital then
      oneData.des = Localization:GetString("390114")
    end
  elseif info.helpType == AllianceHelpType.Building then
    local building = DataCenter.BuildTemplateManager:GetBuildingDesTemplate(info.itemId)
    if building ~= nil then
      oneData.des = Localization:GetString("390115", info.level, Localization:GetString(building.name))
    end
  elseif info.helpType == AllianceHelpType.FIX_BUILDING then
    local building = DataCenter.BuildTemplateManager:GetBuildingDesTemplate(info.itemId)
    if building ~= nil then
      local name = Localization:GetString(building.name) .. "(" .. Localization:GetString("104202") .. ")"
      oneData.des = Localization:GetString("390885", info.level, name)
    end
  end
  return oneData
end

local function GetSelfAllianceHelp(self, uuid)
  local selfList = AllianceHelpDataManager.GetSelfHelpList(self)
  if selfList then
    for key, helpData in pairs(selfList) do
      if helpData and helpData.content == uuid then
        return helpData
      end
    end
  end
  return nil
end

local function GetAllianceHelpList(self)
  local showList = {}
  local selfList = AllianceHelpDataManager.GetSelfHelpList(self)
  if selfList ~= nil then
    table_walk(selfList, function(_, v)
      local oneData = AllianceHelpDataManager.ConvertHelpInfo2ShowData(self, v, true)
      table_insert(showList, oneData)
    end)
  end
  local otherList = AllianceHelpDataManager.GetOtherHelpList(self)
  if otherList ~= nil then
    table_walk(otherList, function(_, v)
      local oneData = AllianceHelpDataManager.ConvertHelpInfo2ShowData(self, v, false)
      table_insert(showList, oneData)
    end)
  end
  return showList
end

local function GetAllianceHelpSliderData(self)
  local oneData = {}
  oneData.todayHelpPoint = AllianceHelpDataManager.GetTodayHelpPoint(self)
  oneData.maxHelpCount = self.maxHelpCount
  return oneData
end

function AllianceHelpDataManager:CheckFakeHelp(helpId)
  return false
end

function AllianceHelpDataManager:CheckFakeMinuteHelp()
  return false
end

AllianceHelpDataManager.__init = __init
AllianceHelpDataManager.__delete = __delete
AllianceHelpDataManager.UpdateHelpInfoList = UpdateHelpInfoList
AllianceHelpDataManager.RefreshAllianceHelp = RefreshAllianceHelp
AllianceHelpDataManager.OnFinishAllianceHelp = OnFinishAllianceHelp
AllianceHelpDataManager.OnHelpAll = OnHelpAll
AllianceHelpDataManager.SetHelpNum = SetHelpNum
AllianceHelpDataManager.GetHelpNum = GetHelpNum
AllianceHelpDataManager.GetSelfHelpList = GetSelfHelpList
AllianceHelpDataManager.GetAllianceHelp = GetAllianceHelp
AllianceHelpDataManager.GetSelfAllianceHelp = GetSelfAllianceHelp
AllianceHelpDataManager.GetOtherHelpList = GetOtherHelpList
AllianceHelpDataManager.GetTodayHelpPoint = GetTodayHelpPoint
AllianceHelpDataManager.ResetTodayHelpPoint = ResetTodayHelpPoint
AllianceHelpDataManager.ConvertHelpInfo2ShowData = ConvertHelpInfo2ShowData
AllianceHelpDataManager.GetAllianceHelpList = GetAllianceHelpList
AllianceHelpDataManager.GetAllianceHelpSliderData = GetAllianceHelpSliderData
return AllianceHelpDataManager
