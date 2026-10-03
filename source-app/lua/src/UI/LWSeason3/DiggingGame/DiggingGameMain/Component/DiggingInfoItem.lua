local base = UIBaseContainer
local DiggingInfoItem = BaseClass("DiggingInfoItem", base)
local Localization = CS.GameEntry.Localization
local Icon_path = "IconImg"
local Btn_path = ""
local TitleText_path = "TitleText"
local TimeText_path = "TimeText"
local Text_path = "Text"
local Red_path = "red"
local __IconPath = "Assets/Main/SeasonRes/S3/Textures/DiggingGame/%s.png"
local __IconName = {
  Single = "ljq_saijis3_yindiannaqiongsi_rukou_01",
  SingleLock = "ljq_saijis3_yindiannaqiongsi_rukou_02",
  Alliance = "ljq_saijis3_yindiannaqiongsi_rukou_03",
  AllianceLock = "ljq_saijis3_yindiannaqiongsi_rukou_04"
}

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
  self.Icon = self:AddComponent(UIRawImage, Icon_path)
  self.Btn = self:AddComponent(UIButton, Btn_path)
  self.TitleText = self:AddComponent(UIText, TitleText_path)
  self.TimeText = self:AddComponent(UIText, TimeText_path)
  self.Text = self:AddComponent(UIText, Text_path)
  self.Red = self:AddComponent(UIBaseContainer, Red_path)
  self.canvas = self:AddComponent(UICanvasGroup, "")
  self.Btn:SetOnClick(BindCallback(self, self.OnClickGotoBtn))
end

local function ComponentDestroy(self)
  self.Icon = nil
  self.Btn = nil
  self.TitleText = nil
  self.TimeText = nil
  self.Text = nil
  self.Red = nil
end

local function DataDefine(self)
  self.state = -1
end

local function DataDestroy(self)
end

function DiggingInfoItem:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.DiggingGameRedUpdate, self.RefreshRed)
end

function DiggingInfoItem:OnRemoveListener()
  self:RemoveUIListener(EventId.DiggingGameRedUpdate, self.RefreshRed)
  base.OnRemoveListener(self)
end

function DiggingInfoItem:ReInit(index, data)
  self.index = index
  self.data = data
  local config = DataCenter.DiggingDataTemplateManager:GetConfigData(data.mapConfigId)
  if config then
    self.TitleText:SetLocalText(config.name)
  end
  self:RefreshRed()
  self:Update1000MS()
end

function DiggingInfoItem:RefreshState()
  if not self.data then
    return
  end
  local lock = self.state == 0
  local iconName, text
  local config = DataCenter.DiggingDataTemplateManager:GetConfigData(self.data.mapConfigId)
  if config then
    iconName = lock and config.pic_lock or config.pic
  end
  if string.IsNullOrEmpty(iconName) then
    if config and config.type == SeasonDigGameType.Single then
      iconName = lock and __IconName.SingleLock or __IconName.Single
    else
      iconName = lock and __IconName.AllianceLock or __IconName.Alliance
    end
    iconName = string.format(__IconPath, iconName)
  end
  self.Icon:LoadSprite(iconName)
  if lock then
    text = "season_activity_1000070_desc03"
  elseif self.state == 1 then
    text = "season_activity_1000070_desc04"
  else
    text = "season_s3_digging_game_tips03"
  end
  self.Text:SetText(Localization:GetString(text, ""))
end

function DiggingInfoItem:Update1000MS()
  if not self.data then
    return
  end
  local deltaTime, state = 0, 2
  local curTime = UITimeManager:GetInstance():GetServerTime()
  if curTime < self.data.startTime then
    deltaTime = self.data.startTime - curTime
    state = 0
  elseif curTime < self.data.endTime then
    deltaTime = self.data.endTime - curTime
    state = 2 <= self.data.rewardState and 2 or 1
  end
  if state ~= self.state then
    self.state = state
    self:RefreshState()
  end
  if 0 < deltaTime then
    self.TimeText:SetText(UITimeManager:GetInstance():MilliSecondToFmtString(deltaTime))
  else
    self.TimeText:SetText("00:00:00")
  end
end

function DiggingInfoItem:OnClickGotoBtn()
  if not self.data or self:IsLock(true) then
    return
  end
  DataCenter.DiggingDataManager:OpenDiggingMap(self.data.uuid, self.data.uid, self.data.type)
end

function DiggingInfoItem:IsLock(showTips)
  local curTime = UITimeManager:GetInstance():GetServerTime()
  local deltaTime = self.data.startTime - curTime
  if 0 < deltaTime then
    if showTips then
      UIUtil.ShowTips(Localization:GetString("season_activity_1000070_desc03", UITimeManager:GetInstance():MilliSecondToFmtString(deltaTime)))
    end
    return true
  end
  deltaTime = self.data.endTime - curTime
  if deltaTime <= 0 then
    if showTips then
      UIUtil.ShowTips(Localization:GetString("season_activity_1000070_desc04", UITimeManager:GetInstance():MilliSecondToFmtString(deltaTime)))
    end
    return true
  end
  return false
end

function DiggingInfoItem:RefreshRed()
  self.Red:SetActive(self.data and self.data.redNum > 0)
end

function DiggingInfoItem:ShowFadeInEffect()
  self.canvas:SetAlpha(0)
  self:SetLocalScaleXYZ(0.8, 0.8, 1)
  local delayTime = toInt(self.index - 1) * 0.06
  local sequence = DOTween.Sequence()
  sequence:AppendInterval(delayTime)
  sequence:Append(self.transform:DOScale(Vector3.New(1.02, 1.02, 1), 0.133))
  sequence:Append(self.transform:DOScale(Vector3.New(1, 1, 1), 0.333))
  sequence:Join(self.canvas.unity_canvas_group:DOFade(1, 0.14))
end

DiggingInfoItem.OnCreate = OnCreate
DiggingInfoItem.OnDestroy = OnDestroy
DiggingInfoItem.OnEnable = OnEnable
DiggingInfoItem.OnDisable = OnDisable
DiggingInfoItem.ComponentDefine = ComponentDefine
DiggingInfoItem.ComponentDestroy = ComponentDestroy
DiggingInfoItem.DataDefine = DataDefine
DiggingInfoItem.DataDestroy = DataDestroy
return DiggingInfoItem
