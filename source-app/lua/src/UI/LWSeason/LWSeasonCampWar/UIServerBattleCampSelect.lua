local base = UIBaseContainer
local UIServerBattleCampSelect = BaseClass("UIServerBattleCampSelect", base)
local Localization = CS.GameEntry.Localization
local ZoneCitySelect = require("UI.LWSeason.LWSeasonCampWar.Component.ZoneCitySelect")
local ZoneItemSelect = require("UI.LWSeason.LWSeasonCampWar.Component.ZoneItemSelect")
local txtTitle_path = "root/Info/title"
local txtTime_path = "root/Info/TimeBg/remainTime"
local timeBg_path = "root/Info/TimeBg"
local btnInfo_path = "root/Info/InfoBtn"
local content_path = "root/Content"
local btnHistory_path = "root/bot/HistoryBtn"
local btnDesc_path = "root/Info/DescBtn"
local btnGroup_path = "root/bot/BtnGroup/BtnGroup"
local btnReward_path = "root/bot/BtnGroup/BtnReward"
local leftTimes_path = "root/bot/leftTimes"
local winLeft_path = "root/Info/WinLeft"
local loseLeft_path = "root/Info/LoseLeft"
local winRight_path = "root/Info/WinRight"
local loseRight_path = "root/Info/LoseRight"
local cityIdList = {
  THRONE_ID,
  1005,
  1006,
  1007
}

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:RefreshCity()
end

local function OnDestroy(self)
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
  self:AddUIListener(EventId.CrossKingRoundInfoALLRefresh, self.UpdateData)
  self:AddUIListener(EventId.CrossThroneGetStrategicAreaOverview, self.UpdateData)
  self:AddUIListener(EventId.CrossThroneStrategicAreaExchangeInfo, self.CrossThroneStrategicAreaExchangeInfo)
end

local function OnDisable(self)
  self:RemoveUIListener(EventId.CrossKingRoundInfoALLRefresh, self.UpdateData)
  self:RemoveUIListener(EventId.CrossThroneGetStrategicAreaOverview, self.UpdateData)
  self:RemoveUIListener(EventId.CrossThroneStrategicAreaExchangeInfo, self.CrossThroneStrategicAreaExchangeInfo)
  base.OnDisable(self)
end

local function ComponentDefine(self)
  self.txtTitle = self:AddComponent(UIText, txtTitle_path)
  self.txtTime = self:AddComponent(UIText, txtTime_path)
  self.timeBg = self:AddComponent(UIBaseContainer, timeBg_path)
  self.btnInfo = self:AddComponent(UIButton, btnInfo_path)
  self.content = self:AddComponent(UIBaseContainer, content_path)
  self.btnHistory = self:AddComponent(UIButton, btnHistory_path)
  self.btnDesc = self:AddComponent(UIButton, btnDesc_path)
  self.btnGroup = self:AddComponent(UIButton, btnGroup_path)
  self.btnReward = self:AddComponent(UIButton, btnReward_path)
  self.leftTimes = self:AddComponent(UIText, leftTimes_path)
  self.winLeft = self:AddComponent(UIBaseContainer, winLeft_path)
  self.loseLeft = self:AddComponent(UIBaseContainer, loseLeft_path)
  self.winRight = self:AddComponent(UIBaseContainer, winRight_path)
  self.loseRight = self:AddComponent(UIBaseContainer, loseRight_path)
  self.btnInfo:SetOnClick(function()
    local param = {}
    param.title = "801453"
    param.activityRulesStr = Localization:GetString("season_s4_camp_battle_02")
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIActivityDetailPopup, {anim = true}, param)
  end)
  self.btnDesc:SetOnClick(function()
    if self.config ~= nil then
      self.config:ShowActivityNews(self.btnDesc.transform.position, true, true)
    end
  end)
  self.btnHistory:SetOnClick(function()
    SFSNetwork.SendMessage(MsgDefines.CrossThroneStrategicAreaExchangeHistory)
    UIManager:GetInstance():OpenWindow(UIWindowNames.CampSelectHistory, {anim = true})
  end)
  self.btnGroup:SetOnClick(function()
    UIManager:GetInstance():OpenWindow(UIWindowNames.UILWSeasonServerGroup, {anim = true}, JumpServerMode.CrossServerKing)
  end)
  self.btnReward:SetOnClick(function()
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIGovernmentServerBattleRewardDetail)
  end)
end

local function ComponentDestroy(self)
  self.txtTitle = nil
  self.txtTime = nil
  self.timeBg = nil
  self.btnInfo = nil
  self.content = nil
  self.btnHistory = nil
  self.btnDesc = nil
  self.btnGroup = nil
  self.btnReward = nil
  self.leftTimes = nil
  self.winLeft = nil
  self.loseLeft = nil
  self.winRight = nil
  self.loseRight = nil
end

local function DataDefine(self)
end

local function DataDestroy(self)
end

function UIServerBattleCampSelect:ReInit(configSchedule, config, serverBattleType)
  self.config = config
  self.configSchedule = configSchedule
  self.endTime = configSchedule.endTime
  self.serverBattleType = serverBattleType
  self:UpdateData()
  self:Update1000MS()
  if self.config ~= nil and self.config:HasActivityNews() then
    local count = UIUtil.GetMonthActiveCount("ServerZoneBattleV8CampNews", true)
    if count == 0 then
      self.config:ShowActivityNews(self.btnDesc.transform.position, false, true)
    end
  end
  self.btnDesc:SetActive(self.config:HasActivityNews())
end

function UIServerBattleCampSelect:RefreshCity()
  if not self.cityItemList then
    self.cityItemList = {}
    for i, v in ipairs(cityIdList) do
      self.cityItemList[i] = self:AddComponent(ZoneCitySelect, string.format("%s/city%s", content_path, i))
    end
  end
  for i, item in ipairs(self.cityItemList) do
    item:ReInit(cityIdList[i], self.configSchedule)
  end
end

function UIServerBattleCampSelect:UpdateData()
  self:UpdateTime()
  local index = 0
  if not self.serverItemList then
    self.serverItemList = {}
    for i = 1, 4 do
      index = index + 1
      self.serverItemList[index] = self:AddComponent(ZoneItemSelect, string.format("%s/p%s", content_path, index))
    end
    for i = 1, 4 do
      index = index + 1
      self.serverItemList[index] = self:AddComponent(ZoneItemSelect, string.format("%s/p%s", content_path, index))
    end
  end
  local areaOverView = DataCenter.CampWarManager.areaOverView or {}
  local roundInfo = DataCenter.ZoneWarManager:GetCrossKingRoundInfoALL()
  local serverKing = roundInfo and roundInfo.serverKing or {}
  local serverInfo = roundInfo and roundInfo.serverInfo or {}
  local mySeverId = LuaEntry.Player:GetSourceServerId()
  local selfCamp = DataCenter.ZoneWarManager:GetServerCampIndex(mySeverId)
  local rightStatus = selfCamp == SeasonFactionType.Rebels and 1 or 2
  local leftStatus = rightStatus == 1 and 2 or 1
  index = 0
  local groupA = areaOverView[SeasonFactionType.Rebels] or {}
  local isLoseA = self:IsLose(roundInfo, groupA)
  for i, v in ipairs(groupA) do
    index = index + 1
    local item = self.serverItemList[index]
    local serverIdStr = tostring(v.serverId)
    local info = serverInfo[serverIdStr] or {cfgId = 511001}
    item:ReInit(i, v, serverKing[serverIdStr], info, leftStatus, self.isOver)
  end
  index = 4
  local groupB = areaOverView[SeasonFactionType.Gendarmerie] or {}
  local isLoseB = self:IsLose(roundInfo, groupB)
  for i, v in ipairs(groupB) do
    index = index + 1
    local item = self.serverItemList[index]
    local serverIdStr = tostring(v.serverId)
    local info = serverInfo[serverIdStr] or {cfgId = 511001}
    item:ReInit(i, v, serverKing[serverIdStr], info, rightStatus, self.isOver)
  end
  if isLoseA or isLoseB then
    self.winLeft:SetActive(isLoseA)
    self.loseLeft:SetActive(isLoseB)
    self.winRight:SetActive(isLoseB)
    self.loseRight:SetActive(isLoseA)
  else
    self.winLeft:SetActive(false)
    self.loseLeft:SetActive(false)
    self.winRight:SetActive(false)
    self.loseRight:SetActive(false)
  end
  local selfData = DataCenter.CampWarManager:GetAreaOverview()
  if not selfData then
    self.leftTimes:SetLocalText("-")
  elseif selfData.isLeaderServer then
    self.leftTimes:SetLocalText("season_s4_camp_battle_23")
  else
    local left = selfData and selfData.exchangeRemain or 0
    left = string.format("<color=#5fef87>%s</color>", left)
    self.leftTimes:SetLocalText(2000707, left)
  end
end

function UIServerBattleCampSelect:IsLose(roundInfo, group)
  if roundInfo and roundInfo.serverInfo and roundInfo.allRoundInfo then
    for _, v in ipairs(roundInfo.allRoundInfo) do
      if v.win == -1 and v.round == roundInfo.curRound then
        for i, v2 in ipairs(group) do
          if v.serverId == v2.serverId then
            return true
          end
        end
      end
    end
  end
  return false
end

function UIServerBattleCampSelect:CrossThroneStrategicAreaExchangeInfo()
  SFSNetwork.SendMessage(MsgDefines.CrossThroneGetStrategicAreaOverview)
end

function UIServerBattleCampSelect:UpdateTime()
  self.isOver = true
  local curTime = UITimeManager:GetInstance():GetServerTime()
  self.startTime = nil
  self.endTime = self.configSchedule and self.configSchedule.breakThroneProtectTime or 0
  if curTime < self.endTime then
    self.startTime = DataCenter.CampWarManager:GetExchangeEndTime()
    if curTime < self.startTime then
      self.isOver = false
      self.txtTitle:SetLocalText("season_s4_camp_battle_01")
    else
      self.startTime = nil
      self.txtTitle:SetLocalText("458153")
    end
    self.timeBg:SetActive(true)
  else
    self.endTime = nil
    self.txtTitle:SetLocalText("458155")
    self.timeBg:SetActive(false)
  end
end

function UIServerBattleCampSelect:Update1000MS()
  if self.startTime then
    if UIUtil.SetLeftTimeText(self.txtTime, self.startTime) then
      self:UpdateData()
    end
  elseif self.endTime and UIUtil.SetLeftTimeText(self.txtTime, nil, self.endTime) then
    self:UpdateData()
  end
end

UIServerBattleCampSelect.OnCreate = OnCreate
UIServerBattleCampSelect.OnDestroy = OnDestroy
UIServerBattleCampSelect.OnEnable = OnEnable
UIServerBattleCampSelect.OnDisable = OnDisable
UIServerBattleCampSelect.ComponentDefine = ComponentDefine
UIServerBattleCampSelect.ComponentDestroy = ComponentDestroy
UIServerBattleCampSelect.DataDefine = DataDefine
UIServerBattleCampSelect.DataDestroy = DataDestroy
return UIServerBattleCampSelect
