local UIRadarRally = BaseClass("UIRadarRally", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local ResourceManager = CS.GameEntry.Resource
local UIRadarRallyItem = require("UI.UIActivityCenterTable.Component.RadarRally.UIRadarRallyItem")
local title_path = "Panel/titleBg/Title"
local info_path = "Panel/Info"
local time_path = "Panel/Time"
local story_path = "Panel/Story"
local reward_list_path = "Panel/RewardList"
local rest_time_path = "Panel/RestTimeBg/RestTime"
local go_path = "Panel/GoBtn"
local go_text_path = "Panel/GoBtn/GoBtnText"
local red_dot_path = "Panel/GoBtn/RedDot"

local function OnCreate(self)
  base.OnCreate(self)
  self:DataDefine()
  self:ComponentDefine()
end

local function OnDestroy(self)
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
  self:Refresh()
end

local function OnDisable(self)
  self.reward_list_go:RemoveComponents(UIRadarRallyItem)
  self.reward_list_go:DestroyChildNode()
  base.OnDisable(self)
end

local function ComponentDefine(self)
  self.title_text = self:AddComponent(UIText, title_path)
  self.info_btn = self:AddComponent(UIButton, info_path)
  self.info_btn:SetOnClick(function()
    self:OnInfoClick()
  end)
  self.time_text = self:AddComponent(UIText, time_path)
  self.story_text = self:AddComponent(UIText, story_path)
  self.reward_list_go = self:AddComponent(UIBaseContainer, reward_list_path)
  self.rest_time_text = self:AddComponent(UIText, rest_time_path)
  self.go_btn = self:AddComponent(UIButton, go_path)
  self.go_btn:SetOnClick(function()
    self:OnGoClick()
  end)
  self.go_text = self:AddComponent(UIText, go_text_path)
  self.go_text:SetLocalText(110003)
  self.red_dot_go = self:AddComponent(UIBaseContainer, red_dot_path)
end

local function ComponentDestroy(self)
  self.title_text = nil
  self.info_btn = nil
  self.time_text = nil
  self.story_text = nil
  self.reward_list_go = nil
  self.rest_time_text = nil
  self.go_btn = nil
  self.red_dot_go = nil
end

local function DataDefine(self)
  self.actId = ""
  self.timer = nil
end

local function DataDestroy(self)
  self.data = nil
  if self.timer ~= nil then
    self.timer:Stop()
  end
  self.timer = nil
end

local function OnAddListener(self)
end

local function OnRemoveListener(self)
end

local function Refresh(self)
  local dataList = DataCenter.ActivityListDataManager:GetActivityDataByType(EnumActivity.BarterShopNotice.Type)
  if table.IsNullOrEmpty(dataList) then
    return
  end
  local data = dataList[1]
  local startTime = math.floor(data.startTime)
  local endTime = math.floor(data.endTime)
  local startTimeStr = UITimeManager:GetInstance():TimeStampToTimeForLocal(startTime)
  startTimeStr = string.split(startTimeStr, " ")[1]
  startTimeStr = string.gsub(startTimeStr, "-", "/")
  local endTimeStr = UITimeManager:GetInstance():TimeStampToTimeForLocal(endTime)
  endTimeStr = string.split(endTimeStr, " ")[1]
  endTimeStr = string.gsub(endTimeStr, "-", "/")
  self.data = data
  self.title_text:SetLocalText(tonumber(data.name))
  self.time_text:SetText(startTimeStr .. " ~ " .. endTimeStr)
  self.story_text:SetLocalText(tonumber(data.story))
  self.timer = TimerManager:GetInstance():GetTimer(0.1, self.TimerAction, {self = self, endTime = endTime}, false, false, false)
  self.timer:Start()
  self.red_dot_go:SetActive(DataCenter.ActivityListDataManager:GetRewardNumByTypeAndId(data.type, data.id) > 0)
end

local function TimerAction(param)
  if param.self.rest_time_text then
    local curTime = math.floor(UITimeManager:GetInstance():GetServerTime())
    local restTime = math.max(param.endTime - curTime, 0)
    local restTimeStr = UITimeManager:GetInstance():MilliSecondToFmtString(restTime)
    param.self.rest_time_text:SetText(restTimeStr)
  end
end

local function OnInfoClick(self)
  UIUtil.ShowIntro(Localization:GetString("302078"), "", Localization:GetString("372126"))
end

UIRadarRally.OnCreate = OnCreate
UIRadarRally.OnDestroy = OnDestroy
UIRadarRally.OnEnable = OnEnable
UIRadarRally.OnDisable = OnDisable
UIRadarRally.ComponentDefine = ComponentDefine
UIRadarRally.ComponentDestroy = ComponentDestroy
UIRadarRally.DataDefine = DataDefine
UIRadarRally.DataDestroy = DataDestroy
UIRadarRally.OnAddListener = OnAddListener
UIRadarRally.OnRemoveListener = OnRemoveListener
UIRadarRally.Refresh = Refresh
UIRadarRally.TimerAction = TimerAction
UIRadarRally.OnInfoClick = OnInfoClick
UIRadarRally.OnGoClick = OnGoClick
UIRadarRally.RadarRallyGetBossCountSignal = RadarRallyGetBossCountSignal
return UIRadarRally
