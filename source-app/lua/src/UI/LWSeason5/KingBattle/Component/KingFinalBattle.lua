local base = UIBaseContainer
local KingFinalBattle = BaseClass("KingFinalBattle", base)
local AllianceNameItem = require("UI.LWSeason5.KingBattle.Component.AllianceNameItem")
local Localization = CS.GameEntry.Localization
local ScorePlayerReward = require("UI.LWSeason5.KingBattle.Component.ScorePlayerReward")
local title_path = "RightView/Top/title"
local title_text_path = "RightView/Top/subTitle"
local tick_path = "RightView/Top/time"
local tick_time_path = "RightView/Top/time"
local cityIcon_path = "RightView/icon/CityIcon"
local cityBtn_path = "RightView/icon/CityIcon"
local infoBtn_path = "RightView/Top/InfoBtn"
local rankBtn_path = "RightView/Top/RankBtn"
local rewardInfo_path = "ScorePlayerReward"
local allianceRoot_path = "allianceRoot"

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

local function OnDestroy(self)
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function ComponentDefine(self)
  self.title = self:AddComponent(UIText, title_path)
  self.title_text = self:AddComponent(UIText, title_text_path)
  self.tick = self:AddComponent(UIBaseContainer, tick_path)
  self.tick_time = self:AddComponent(UIText, tick_time_path)
  self.cityIcon = self:AddComponent(UIRawImage, cityIcon_path)
  self.cityBtn = self:AddComponent(UIButton, cityBtn_path)
  self.infoBtn = self:AddComponent(UIButton, infoBtn_path)
  self.rankBtn = self:AddComponent(UIButton, rankBtn_path)
  self.rewardInfo = self:AddComponent(UIBaseContainer, rewardInfo_path)
  self.allianceRoot = self:AddComponent(UIBaseContainer, allianceRoot_path)
  self.title:SetLocalText("season_s5_activity_1200067_title02")
  self.infoBtn:SetOnClick(function()
    local param = {}
    param.activityId = self.activityId
    param.activityRulesStr = Localization:GetString(self.activityData.story)
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIActivityDetailPopup, {anim = true}, param)
  end)
  self.rankBtn:SetOnClick(function()
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIKingBattleRank, {anim = true, playEffect = false})
  end)
  self.cityBtn:SetOnClick(function()
    DataCenter.SeasonNineKingManager:GotoCenterCity()
  end)
  self.allianceItems = {}
  for i = 1, 8 do
    local path = string.format("%s/AllianceNameItem%d", allianceRoot_path, i)
    self.allianceItems[i] = self:AddComponent(AllianceNameItem, path)
  end
  self.playerReward = self:AddComponent(ScorePlayerReward, rewardInfo_path)
end

local function ComponentDestroy(self)
  self.title = nil
  self.title_text = nil
  self.tick = nil
  self.tick_time = nil
  self.cityIcon = nil
  self.cityBtn = nil
  self.infoBtn = nil
  self.rankBtn = nil
  self.rewardInfo = nil
  self.allianceRoot = nil
end

local function DataDefine(self)
end

local function DataDestroy(self)
end

function KingFinalBattle:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.ThroneConnectedInfoUpdate, self.UpdateData)
  self:AddUIListener(EventId.CenterThroneActivityInfoUpdate, self.UpdateData)
  self:AddUIListener(EventId.HeroEventCfgInfoUpdate, self.UpdateData)
  self:AddUIListener(EventId.HeroEventClaimBoxReward, self.UpdateData)
  self:AddUIListener(EventId.HeroEventDataUpdate, self.UpdateData)
end

function KingFinalBattle:OnRemoveListener()
  self:RemoveUIListener(EventId.ThroneConnectedInfoUpdate, self.UpdateData)
  self:RemoveUIListener(EventId.CenterThroneActivityInfoUpdate, self.UpdateData)
  self:RemoveUIListener(EventId.HeroEventCfgInfoUpdate, self.UpdateData)
  self:RemoveUIListener(EventId.HeroEventClaimBoxReward, self.UpdateData)
  self:RemoveUIListener(EventId.HeroEventDataUpdate, self.UpdateData)
  base.OnRemoveListener(self)
end

function KingFinalBattle:ReInit(activityData)
  self.activityData = activityData
  self.EndTime = activityData.endTime
  self:UpdateData()
  self:Update1000MS()
end

function KingFinalBattle:UpdateData()
  local throneConnectedInfo = DataCenter.SeasonNineKingManager.allianceDic
  self.throneConnectedInfo = throneConnectedInfo
  if throneConnectedInfo == nil then
    self.rewardInfo:SetActive(false)
    self.allianceRoot:SetActive(false)
    self.playerReward:SetActive(false)
    return
  end
  self.rewardInfo:SetActive(true)
  self.allianceRoot:SetActive(true)
  local index = 1
  for allianceId, data in pairs(throneConnectedInfo) do
    local node = self.allianceItems[index]
    if node ~= nil then
      node:SetActive(true)
      node:ReInit(allianceId, data)
      index = index + 1
    end
  end
  for i = index, 8 do
    local node = self.allianceItems[i]
    if node ~= nil then
      node:SetActive(false)
    end
  end
  local throneActivityInfo = DataCenter.SeasonNineKingManager.sourceInfo
  self.throneActivityInfo = throneActivityInfo
  if throneActivityInfo == nil then
    self.playerReward:SetActive(false)
    return
  end
  if self.hero_event_data == nil then
    self.hero_event_id_use, self.hero_event_data = DataCenter.SeasonNineKingManager:TryGetCurHeroEventInfo(true, self.hero_event_id_use, self.activityData)
  end
  local heroEventInfo = self.hero_event_data
  if heroEventInfo == nil then
    self.playerReward:SetActive(false)
    return
  end
  local weekShieldInfo = throneActivityInfo.weekShieldInfo
  local curWeek = throneActivityInfo.curWeek
  if weekShieldInfo == nil or curWeek == -1 or weekShieldInfo[curWeek] == nil then
    self.playerReward:SetActive(false)
    return
  end
  local shieldInfo = weekShieldInfo[curWeek]
  if shieldInfo == nil or shieldInfo.week == nil or shieldInfo.breakShieldTime == nil then
    self.playerReward:SetActive(false)
    return
  end
  self.playerReward:SetActive(true)
  self.battleStartTime = shieldInfo.breakShieldTime
  self.battleEndTime, self.isTodayBattleEnd = DataCenter.SeasonNineKingManager:GetWorldBattleEndTime(throneActivityInfo.centerServerId)
  self.battleStartTimeNext = nil
  local curTime = UITimeManager:GetInstance():GetServerTime()
  if self.battleEndTime and curTime >= self.battleEndTime then
    self.battleEndTime = nil
    local nextWeek = curWeek + 1
    if weekShieldInfo[nextWeek] and weekShieldInfo[nextWeek].breakShieldTime then
      self.battleStartTimeNext = weekShieldInfo[nextWeek].breakShieldTime
    end
  end
  self:ShowScore(self.battleStartTime, self.battleStartTimeNext)
  if self.battleStartTime and curTime >= self.battleStartTime then
    self.battleStartTime = nil
  end
  self.playerReward:ReInit(self, heroEventInfo, DataCenter.SeasonNineKingManager:GetCurHeroEventUserInfo(), self.battleStartTimeNext or self.battleStartTime)
  self:Update1000MS()
end

function KingFinalBattle:ShowScore(battleStartTime, battleStartTimeNext)
  if battleStartTime and UITimeManager:GetInstance():IsTodayServer(battleStartTime) or battleStartTimeNext and UITimeManager:GetInstance():IsTodayServer(battleStartTimeNext) then
    self.playerReward:ShowScore(true)
    return
  end
  self.playerReward:ShowScore(false)
end

function KingFinalBattle:Update1000MS()
  local curTime = UITimeManager:GetInstance():GetServerTime()
  local remainTime = 0
  if self.isTodayBattleEnd and (not self.battleEndTime or curTime > self.battleEndTime) then
    remainTime = UITimeManager:GetInstance():GetTomorrowZero() - curTime
    if 0 < remainTime then
      self.tick:SetActive(true)
      self.title_text:SetLocalText("activity_endalerttips1")
      self.tick_time:SetText(UITimeManager:GetInstance():MilliSecondToFmtString(remainTime))
    else
      self.isTodayBattleEnd = false
    end
    return
  end
  if self.battleStartTime then
    remainTime = self.battleStartTime - curTime
    if 0 < remainTime then
      self.tick:SetActive(true)
      self.title_text:SetLocalText("winter_battlefield_interface_tips1022")
      self.tick_time:SetText(UITimeManager:GetInstance():MilliSecondToFmtString(remainTime))
    else
      self.tick:SetActive(false)
      self.tick_time:SetText("--:--:--")
      self.title_text:SetLocalText("winter_battlefield_interface_tips1022")
      self.battleStartTime = nil
    end
    return
  end
  if self.battleEndTime then
    remainTime = self.battleEndTime - curTime
    if 0 < remainTime then
      self.tick:SetActive(true)
      self.title_text:SetLocalText("winter_battlefield_interface_tips1023")
      self.tick_time:SetText(UITimeManager:GetInstance():MilliSecondToFmtString(remainTime))
    else
      self.tick:SetActive(false)
      self.tick_time:SetText("--:--:--")
      self.title_text:SetLocalText("winter_battlefield_interface_tips1023")
      self.battleEndTime = nil
    end
    return
  end
  if self.battleStartTimeNext then
    remainTime = self.battleStartTimeNext - curTime
    if 0 < remainTime then
      self.tick:SetActive(true)
      self.title_text:SetLocalText("winter_battlefield_interface_tips1022")
      self.tick_time:SetText(UITimeManager:GetInstance():MilliSecondToFmtString(remainTime))
      return
    end
  end
  if self.EndTime then
    self.tick:SetActive(true)
    UIUtil.SetLeftTimeText(self.tick_time, nil, self.EndTime)
    self.title_text:SetLocalText(100238)
    return
  end
  self.tick:SetActive(false)
  self.tick_time:SetText("--:--:--")
  self.title_text:SetLocalText("activity_endalerttips1")
end

function KingFinalBattle:GetTestData()
  local battleInfo = {}
  local zoneList = {}
  battleInfo.zoneList = zoneList
  for i = 1, 8 do
    zoneList[i] = {
      cityId = math.random(1, 100),
      serverId = LuaEntry.Player:GetSourceServerId(),
      abbr = math.random(100, 999),
      allianceName = math.random(10000, 100000),
      icon = math.random(1, 6)
    }
  end
  return battleInfo
end

KingFinalBattle.OnCreate = OnCreate
KingFinalBattle.OnDestroy = OnDestroy
KingFinalBattle.OnEnable = OnEnable
KingFinalBattle.OnDisable = OnDisable
KingFinalBattle.ComponentDefine = ComponentDefine
KingFinalBattle.ComponentDestroy = ComponentDestroy
KingFinalBattle.DataDefine = DataDefine
KingFinalBattle.DataDestroy = DataDestroy
return KingFinalBattle
