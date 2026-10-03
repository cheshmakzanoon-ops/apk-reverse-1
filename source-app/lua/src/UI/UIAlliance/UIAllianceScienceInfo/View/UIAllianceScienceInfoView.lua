local UIAllianceScienceInfoView = BaseClass("UIAllianceScienceInfoView", UIBaseView)
local AlScienceIconInfo = require("UI.UIAlliance.UIAllianceScienceInfo.Component.AlScienceIconInfo")
local AlScienceDetails = require("UI.UIAlliance.UIAllianceScienceInfo.Component.AlScienceDetails")
local base = UIBaseView
local panel_path = "UICommonPopUpTitle/panel"
local title_text_path = "UICommonPopUpTitle/Common_img_title/titleText"
local close_btn_path = "UICommonPopUpTitle/CloseBtn"
local animator_path = "BgGo/MiddleBg"
local build_info_path = "BgGo/MiddleBg/BuildInfo"
local build_details_path = "BgGo/MiddleBg/BuildDetails"
local ShowEndTimerTime = 43200

local function OnCreate(self)
  base.OnCreate(self)
  self.scienceData, self.tabIndex, self.showRecommendEffect = self:GetUserData()
  SFSNetwork.SendMessage(MsgDefines.AlScienceNumFresh, self.scienceData.scienceId)
  SFSNetwork.SendMessage(MsgDefines.AlScienceFresh, self.scienceData.scienceId)
  self.btn = self:AddComponent(UIButton, panel_path)
  self.close_btn = self:AddComponent(UIButton, close_btn_path)
  self.title_text = self:AddComponent(UIText, title_text_path)
  self.title_text:SetLocalText(454117)
  self.animator = self:AddComponent(UIAnimator, animator_path)
  self.build_info = self:AddComponent(AlScienceIconInfo, build_info_path)
  self.build_info_canvas_group = self:AddComponent(UICanvasGroup, build_info_path)
  self.build_details = self:AddComponent(AlScienceDetails, build_details_path)
  self.build_details_canvas_group = self:AddComponent(UICanvasGroup, build_details_path)
  self.btn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.close_btn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.build_details_canvas_group:SetAlpha(1)
  self.build_info_canvas_group:SetAlpha(1)
  self.build_info.transform:Set_localPosition(ResetPosition.x, ResetPosition.y, ResetPosition.z)
  self.build_info:SetActive(false)
  self.build_details:SetActive(false)
  self.tipText = self:AddComponent(UIText, "BgGo/MiddleBg/BuildInfo/TipText")
  ShowEndTimerTime = LuaEntry.DataConfig:TryGetNum("guild_plus_sep", "k16") or 43200
  self:OnUpdateView()
end

local function OnDestroy(self)
  self.scienceData = nil
  self.btn = nil
  self.close_btn = nil
  self.title_text = nil
  self.animator = nil
  self.build_info = nil
  self.build_info_canvas_group = nil
  self.build_details = nil
  self.build_details_canvas_group = nil
  self.tipText = nil
  base.OnDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function DetailsBtnClick(self)
  self.animator:Enable(true)
  self.animator:Play("switchEnter", 0, 0)
end

local function BackBtnClick(self)
  self.animator:Enable(true)
  self.animator:Play("switchOut", 0, 0)
end

local function OnAddListener(self)
  base.OnAddListener(self)
  self:AddUIListener(EventId.AllianceTechnology, self.OnUpdateView)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
  self:RemoveUIListener(EventId.AllianceTechnology, self.OnUpdateView)
end

local function OnUpdateView(self)
  self.scienceData = DataCenter.AllianceScienceDataManager:GetOneAllianceScienceById(self.scienceData.scienceId)
  if self.scienceData ~= nil then
    if self.showRecommendEffect then
      self.showRecommendEffect = false
      self.build_info:RefreshData(self.scienceData, self.tabIndex, true)
    else
      self.build_info:RefreshData(self.scienceData, self.tabIndex, false)
    end
    self.build_details:SetActive(false)
    self.build_info:SetActive(true)
  else
    self.build_info:SetActive(false)
    self.build_details:SetActive(false)
  end
  self:RefreshTipText()
end

local function RefreshTipText(self)
  if self.scienceData == nil or self.scienceData.isLock or self.scienceData.maxLevel == self.scienceData.curLevel then
    self.tipText:SetActive(false)
    return
  end
  local curTime = UITimeManager:GetInstance():GetServerTime()
  local nextWeekZero = UITimeManager:GetInstance():GetNextWeekDay(1, curTime)
  local diff = (nextWeekZero - curTime) / 1000
  local ShowEndTipTime = 60
  if diff > ShowEndTimerTime then
    self.tipText:SetActive(false)
  elseif diff > ShowEndTipTime then
    self.tipText:SetActive(true)
    self.tipText:SetLocalText("alliance_donate_endTimer", UITimeManager:GetInstance():SecondToFmtString(diff - ShowEndTipTime))
  else
    self.tipText:SetActive(true)
    self.tipText:SetLocalText("alliance_donate_endTips")
  end
end

local function Update1000MS(self)
  self:RefreshTipText()
end

UIAllianceScienceInfoView.OnCreate = OnCreate
UIAllianceScienceInfoView.OnDestroy = OnDestroy
UIAllianceScienceInfoView.OnEnable = OnEnable
UIAllianceScienceInfoView.OnDisable = OnDisable
UIAllianceScienceInfoView.DetailsBtnClick = DetailsBtnClick
UIAllianceScienceInfoView.BackBtnClick = BackBtnClick
UIAllianceScienceInfoView.OnAddListener = OnAddListener
UIAllianceScienceInfoView.OnRemoveListener = OnRemoveListener
UIAllianceScienceInfoView.OnUpdateView = OnUpdateView
UIAllianceScienceInfoView.RefreshTipText = RefreshTipText
UIAllianceScienceInfoView.Update1000MS = Update1000MS
return UIAllianceScienceInfoView
