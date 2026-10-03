local base = UIBaseContainer
local KingPreBattle = BaseClass("KingPreBattle", base)
local AllianceInfo = require("UI.LWSeason5.KingBattle.Component.AllianceInfo")
local Localization = CS.GameEntry.Localization
local title_path = "RightView/Top/title"
local time_path = "RightView/Top/TimeInfoItem/timeBg2/TimeText"
local infoBtn_path = "RightView/Top/InfoBtn"
local cityIcon_path = "RightView/icon/CityIcon"
local cityBtn_path = "RightView/icon/CityIcon"
local zoneRoot_path = "RightView/ZoneRoot"
local occupy_path = "RightView/ZoneRoot/AllianceInfoOccupy"

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
  self.time = self:AddComponent(UIText, time_path)
  self.infoBtn = self:AddComponent(UIButton, infoBtn_path)
  self.cityIcon = self:AddComponent(UIRawImage, cityIcon_path)
  self.cityBtn = self:AddComponent(UIButton, cityBtn_path)
  self.zoneRoot = self:AddComponent(UIBaseContainer, zoneRoot_path)
  self.occupy = self:AddComponent(UIBaseContainer, occupy_path)
  self.title:SetLocalText("season_s5_activity_1200067_title01")
  self.infoBtn:SetOnClick(function()
    local param = {}
    param.activityId = self.activityId
    param.activityRulesStr = Localization:GetString(self.activityData.story)
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIActivityDetailPopup, {anim = true}, param)
  end)
  self.cityBtn:SetOnClick(function()
    DataCenter.SeasonNineKingManager:GotoCenterCity()
  end)
  self.occupyItem = self:AddComponent(AllianceInfo, occupy_path)
  self.allianceItems = {}
  for i = 1, 8 do
    local path = string.format("%s/AllianceInfo%d", zoneRoot_path, i)
    self.allianceItems[i] = self:AddComponent(AllianceInfo, path)
  end
end

local function ComponentDestroy(self)
  self.title = nil
  self.time = nil
  self.infoBtn = nil
  self.cityIcon = nil
  self.cityBtn = nil
  self.zoneRoot = nil
  self.occupy = nil
end

local function DataDefine(self)
end

local function DataDestroy(self)
end

function KingPreBattle:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.ThroneConnectedInfoMessage, self.UpdateData)
end

function KingPreBattle:OnRemoveListener()
  self:RemoveUIListener(EventId.ThroneConnectedInfoMessage, self.UpdateData)
  base.OnRemoveListener(self)
end

function KingPreBattle:ReInit(activityData)
  self.activityData = activityData
  self.EndTime = activityData.endTime
  self:Update1000MS()
  self:UpdateData()
end

function KingPreBattle:UpdateData(info)
  info = info or DataCenter.SeasonNineKingManager.throneConnectedInfo
  if info == nil then
    self.zoneRoot:SetActive(false)
    return
  end
  self.zoneRoot:SetActive(true)
  if info.throne and not string.IsNullOrEmpty(info.throne.allianceAbbr) then
    self.occupyItem:ReInit(info.throne, 0)
    self.occupyItem:SetActive(true)
  else
    self.occupyItem:SetActive(false)
  end
  local list = info.ls or {}
  for i, v in ipairs(self.allianceItems) do
    v:ReInit(list[i], i)
  end
end

function KingPreBattle:Update1000MS()
  if self.EndTime then
    UIUtil.SetLeftTimeText(self.time, nil, self.EndTime)
  end
end

function KingPreBattle:GetTestData()
  local battleInfo = {}
  local zoneList = {}
  battleInfo.zoneList = zoneList
  for i = 1, 8 do
    zoneList[i] = {
      cityId = math.random(1, 100),
      serverId = LuaEntry.Player:GetSourceServerId(),
      allianceAbbr = math.random(100, 999),
      allianceName = math.random(10000, 100000),
      icon = math.random(1, 6)
    }
  end
  if math.random(1, 100) > 50 then
    battleInfo.occupy = {
      cityId = SeasonUtil.GetKingCityId(LuaEntry.Player:GetSourceServerId()),
      serverId = LuaEntry.Player:GetSourceServerId(),
      allianceAbbr = math.random(100, 999),
      allianceName = math.random(10000, 100000),
      icon = math.random(1, 6)
    }
  end
  return battleInfo
end

KingPreBattle.OnCreate = OnCreate
KingPreBattle.OnDestroy = OnDestroy
KingPreBattle.OnEnable = OnEnable
KingPreBattle.OnDisable = OnDisable
KingPreBattle.ComponentDefine = ComponentDefine
KingPreBattle.ComponentDestroy = ComponentDestroy
KingPreBattle.DataDefine = DataDefine
KingPreBattle.DataDestroy = DataDestroy
return KingPreBattle
