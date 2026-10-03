local base = require("UI.UIActivityCenterTable.Component.ActivityContentBase")
local SeasonPhotoMain = BaseClass("SeasonPhotoMain", base)
local SeasonPhotoCanva = require("UI.LWSeason.LWSeasonPhoto.Component.SeasonPhotoCanva")
local SeasonPhotoMessage = require("UI.LWSeason.LWSeasonPhoto.Component.SeasonPhotoMessage")
local TitleText_path = "Root/TextTitle"
local BtnBack_path = "Root/BtnBack"
local TimeRoot_path = "Root/TimeInfoItem"
local TimeText_path = "Root/TimeInfoItem/timeBg2/TimeText"
local IntroBtn_path = "Root/InfoBtn"
local RewardBtn_path = "Root/rewardBtn"
local RewardRed_path = "Root/rewardBtn/RedPoint"
local Toggle1_path = "Root/TabRoot/TabItem1"
local Red1_path = "Root/TabRoot/TabItem1/RedPoint1"
local Toggle2_path = "Root/TabRoot/TabItem2"
local Red2_path = "Root/TabRoot/TabItem2/RedPoint2"
local PhotoCanva_path = "Root/Content/Content1/SeasonPhotoCanva"
local PhotoMessage_path = "Root/Content/Content2/SeasonPhotoMessage"
local BtnEditor_path = "Root/Content/Content1/BtnGroup/BtnEditor"
local BtnShare_path = "Root/Content/Content1/BtnGroup/BtnShare"
local BtnMessage_path = "Root/Content/Content2/BtnGroup/BtnMessage"
local BtnShareMessage_path = "Root/Content/Content2/BtnGroup/BtnShareMessage"
local TextMessage_path = "Root/Content/Content2/BtnGroup/BtnMessage/Text"
local FlipPage_path = "Root/Content/Content1/flippage"

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:SetData(self:GetUserData())
  DataCenter.SeasonPhotoManager:UpdateActiveView(true)
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
  self.TitleText = self:AddComponent(UIText, TitleText_path)
  self.BtnBack = self:AddComponent(UIButton, BtnBack_path)
  self.TimeRoot = self:AddComponent(UIBaseContainer, TimeRoot_path)
  self.TimeText = self:AddComponent(UIText, TimeText_path)
  self.IntroBtn = self:AddComponent(UIButton, IntroBtn_path)
  self.RewardBtn = self:AddComponent(UIButton, RewardBtn_path)
  self.RewardRed = self:AddComponent(UIBaseContainer, RewardRed_path)
  self.Toggle1 = self:AddComponent(UIToggle, Toggle1_path)
  self.Red1 = self:AddComponent(UIBaseContainer, Red1_path)
  self.Toggle2 = self:AddComponent(UIToggle, Toggle2_path)
  self.Red2 = self:AddComponent(UIBaseContainer, Red2_path)
  self.BtnEditor = self:AddComponent(UIButton, BtnEditor_path)
  self.BtnShare = self:AddComponent(UIButton, BtnShare_path)
  self.BtnMessage = self:AddComponent(UIButton, BtnMessage_path)
  self.BtnShareMessage = self:AddComponent(UIButton, BtnShareMessage_path)
  self.TextMessage = self:AddComponent(UIText, TextMessage_path)
  self.flipPage = self:AddComponent(UIRawImage, FlipPage_path)
  self.simpleAnim = self:AddComponent(UISimpleAnimation, "")
  self.IntroBtn:SetOnClick(BindCallback(self, self.ShowIntro))
  self.RewardBtn:SetOnClick(function()
    SFSNetwork.SendMessage(MsgDefines.ViewSeasonPhotoTasklist, self.activityId)
    UIManager:GetInstance():OpenWindow(UIWindowNames.SeasonPhotoReward, {anim = true}, self.activityId)
  end)
  self.BtnBack:SetOnClick(BindCallback(self.ctrl, self.ctrl.CloseSelf))
  self.PhotoCanva = self:AddComponent(SeasonPhotoCanva, PhotoCanva_path)
  self.PhotoMessage = self:AddComponent(SeasonPhotoMessage, PhotoMessage_path)
  self.BtnShare:SetOnClick(BindCallback(self.PhotoCanva, self.PhotoCanva.SharePhoto))
  self.BtnEditor:SetOnClick(BindCallback(self, self.OnClickEdit))
  self.BtnMessage:SetOnClick(function()
    if not DataCenter.SeasonPhotoManager:CanEditPhoto(self.season, self.allianceId, true, true) then
      return
    end
    if self.season then
      UIManager:GetInstance():OpenWindow(UIWindowNames.SeasonPhotoMessage, {anim = true}, self.season, self.allianceId)
    end
  end)
  self.BtnShareMessage:SetOnClick(BindCallback(self.PhotoMessage, self.PhotoMessage.ShareMessage))
  self.Toggle1:SetOnValueChanged(function(isOn)
    if isOn then
      self:OnToggleChange(1, true)
    end
  end)
  self.Toggle2:SetOnValueChanged(function(isOn)
    if isOn then
      self:OnToggleChange(2, true)
    end
  end)
  self.Toggle1:SetIsOn(true)
end

local function ComponentDestroy(self)
  self.TitleText = nil
  self.BtnBack = nil
  self.TimeRoot = nil
  self.TimeText = nil
  self.IntroBtn = nil
  self.RewardBtn = nil
  self.RewardRed = nil
  self.Toggle1 = nil
  self.Red1 = nil
  self.Toggle2 = nil
  self.Red2 = nil
  self.PhotoCanva = nil
  self.PhotoMessage = nil
  self.BtnEditor = nil
  self.BtnShare = nil
  self.BtnMessage = nil
  self.BtnShareMessage = nil
  self.TextMessage = nil
end

local function DataDefine(self)
  self.hasFlipPage = false
end

local function DataDestroy(self)
end

function SeasonPhotoMain:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.SeasonPhotoOneView, self.OnSeasonPhotoOneView)
  self:AddUIListener(EventId.SeasonPhotoCommentRefresh, self.SeasonPhotoCommentRefresh)
  self:AddUIListener(EventId.SeasonPhotoSavePhoto, self.SeasonPhotoSavePhoto)
  self:AddUIListener(EventId.SeasonPhotoTaskUpdate, self.RefreshReward)
end

function SeasonPhotoMain:OnRemoveListener()
  self:RemoveUIListener(EventId.SeasonPhotoOneView, self.OnSeasonPhotoOneView)
  self:RemoveUIListener(EventId.SeasonPhotoCommentRefresh, self.SeasonPhotoCommentRefresh)
  self:RemoveUIListener(EventId.SeasonPhotoSavePhoto, self.SeasonPhotoSavePhoto)
  self:RemoveUIListener(EventId.SeasonPhotoTaskUpdate, self.RefreshReward)
  base.OnRemoveListener(self)
end

function SeasonPhotoMain:SetData(activityId, titleName, season, allianceId)
  self.activityId = activityId
  self.season = season
  self.allianceId = allianceId
  if activityId then
    self.activityData = DataCenter.ActivityListDataManager:GetActivityDataById(activityId)
    if self.activityData then
      self.season = SeasonUtil.GetSeason()
      self.allianceId = DataCenter.SeasonPhotoManager:GetPhotoAllianceId(self.season)
    end
  elseif season and allianceId then
    self.activityData = DataCenter.SeasonPhotoManager:GetSeasonPhotoActivityData(season, allianceId)
    if self.activityData then
      self.activityId = self.activityData.id
    end
  end
  self:InitRedPoint()
  if self.activityData then
    self.TitleText:SetLocalText(self.activityData.name)
    if SeasonUtil.IsInSeasonPrepareMode() then
      self.EndTime = DataCenter.SeasonDataManager.nextSeasonStartTime
    else
      self.EndTime = self.activityData.endTime
    end
    local curTime = UITimeManager:GetInstance():GetServerTime()
    if self.EndTime and curTime < self.EndTime then
      self.TimeRoot:SetActive(true)
      self.RewardBtn:SetActive(true)
      self.BtnEditor:SetActive(true)
      self.BtnMessage:SetActive(true)
      self:Update1000MS()
      self:RefreshView()
      return
    end
  else
    self.TitleText:SetLocalText("season_alliance_photo_UI_2")
  end
  self.StartTime = nil
  self.EndTime = nil
  self.TimeRoot:SetActive(false)
  self.RewardBtn:SetActive(false)
  self.BtnEditor:SetActive(false)
  self.BtnMessage:SetActive(false)
  self:RefreshView()
end

function SeasonPhotoMain:RefreshView()
  if self.Toggle1:GetIsOn() then
    self:OnToggleChange(1)
  else
    self:OnToggleChange(2)
  end
  self:RefreshReward()
  DataCenter.SeasonPhotoManager:ChangeSkin(self, self.season)
end

function SeasonPhotoMain:Update1000MS()
  if self.activityData then
    UIUtil.SetLeftTimeText(self.TimeText, self.StartTime, self.EndTime)
  end
end

function SeasonPhotoMain:OnToggleChange(index, playAnim)
  if index == 1 then
    self.PhotoCanva:SetPhotoInfo(self.season, self.allianceId, nil, nil, true)
    self.Toggle1:SetInteractable(false)
    self.Toggle2:SetInteractable(true)
    if playAnim then
      self.simpleAnim:Play("SwitchBack")
    end
  else
    self.PhotoMessage:SetPhotoInfo(self.season, self.allianceId, true)
    self.Toggle1:SetInteractable(true)
    self.Toggle2:SetInteractable(false)
    if playAnim then
      self.simpleAnim:Play("Switch")
    end
  end
  self:RefreshFlipPage()
end

function SeasonPhotoMain:OnSeasonPhotoOneView()
  self.hasFlipPage = false
  self:RefreshFlipPage()
end

function SeasonPhotoMain:RefreshFlipPage()
  if not self.hasFlipPage then
    local data = self.PhotoCanva:GetData()
    local borderConfig = data and data:GetPhotoBorderConfig() or DataCenter.SeasonPhotoTemplateManager:GetDefaultBorderConfig(self.season)
    if borderConfig and not string.IsNullOrEmpty(borderConfig.resource) then
      self.flipPage:LoadSpriteAsync(borderConfig.resource)
      self.hasFlipPage = true
    end
  end
end

function SeasonPhotoMain:ShowIntro()
  if self.activityId and self.activityData then
    local param = {}
    param.activityId = self.activityId
    param.activityRulesStr = CS.GameEntry.Localization:GetString(self.activityData.story)
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIActivityDetailPopup, {anim = true}, param)
    return
  end
  local param = {}
  param.activityRulesStr = CS.GameEntry.Localization:GetString("season_alliance_photo_help_2")
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIActivityDetailPopup, {anim = true}, param)
end

function SeasonPhotoMain:InitRedPoint()
  if CS.ClientSwitch.IsOn(CS.ClientSwitch.DISABLE_RED_POINT_TREE) then
    return
  end
  self:BindRedPointUI(self.RewardRed, nil, {
    RedDef.Season,
    tostring(self.activityId),
    RedDef.SeasonPhotoTask
  })
end

function SeasonPhotoMain:RefreshReward()
  if not CS.ClientSwitch.IsOn(CS.ClientSwitch.DISABLE_RED_POINT_TREE) then
    return
  end
  self.RewardRed:SetActive(DataCenter.SeasonPhotoManager.rewardRed > 0)
end

function SeasonPhotoMain:SeasonPhotoCommentRefresh(target)
  if target ~= self.PhotoMessage then
    return
  end
  local listData = DataCenter.SeasonPhotoManager:GetCommentData(self.season, self.allianceId)
  if listData then
    local selfUid = LuaEntry.Player.uid
    for i, v in ipairs(listData) do
      if v.uid == selfUid then
        self.TextMessage:SetLocalText("season_alliance_photo_UI_45")
        return
      end
    end
  end
  self.TextMessage:SetLocalText("season_alliance_photo_UI_8")
end

function SeasonPhotoMain:OnClickEdit()
  if not DataCenter.SeasonPhotoManager:CanEditPhoto(self.season, self.allianceId, true, true) then
    return
  end
  if self.season then
    UIManager:GetInstance():OpenWindow(UIWindowNames.SeasonPhotoCanva, {anim = true}, self.season, self.allianceId)
  end
end

function SeasonPhotoMain:SeasonPhotoSavePhoto(chat_data_param)
  self.PhotoCanva:SavePhoto(chat_data_param)
end

SeasonPhotoMain.OnCreate = OnCreate
SeasonPhotoMain.OnDestroy = OnDestroy
SeasonPhotoMain.OnEnable = OnEnable
SeasonPhotoMain.OnDisable = OnDisable
SeasonPhotoMain.ComponentDefine = ComponentDefine
SeasonPhotoMain.ComponentDestroy = ComponentDestroy
SeasonPhotoMain.DataDefine = DataDefine
SeasonPhotoMain.DataDestroy = DataDestroy
return SeasonPhotoMain
