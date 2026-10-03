local base = UIBaseView
local UIGhostreconTaskSpecialBeginView = BaseClass("UIGhostreconTaskSpecialBeginView", base)
local UIGhostreconTaskBannerPanel = require("UI.UIDispatchTask.Ghostrecon.Task.Component.UIGhostreconTaskBannerPanel")
local UIGhostreconTaskRewardPanel = require("UI.UIDispatchTask.Ghostrecon.Task.Component.UIGhostreconTaskRewardPanel")
local UIGhostreconTaskSpecialPanel = require("UI.UIDispatchTask.Ghostrecon.Task.Component.UIGhostreconTaskSpecialPanel")
local UIGhostreconTaskBtnPanel = require("UI.UIDispatchTask.Ghostrecon.Task.Component.UIGhostreconTaskBtnPanel")
local titleText_path = "Root/Content/UICommonPopBg/bg_3/TitleTxt"
local closeBtn_path = "Root/Content/UICommonPopBg/bg_3/CloseBtn"
local closePanel_path = "Panel"
local bannerPanel_path = "Root/Content/ContentHolder/BannerPanel"
local rewardPanel_path = "Root/Content/ContentHolder/RewardPanel"
local specialPanel_path = "Root/Content/ContentHolder/SpecialPanel"
local btnPanel_path = "Root/Content/ContentHolder/BtnPanel"
local guidePanel_path = "GuidePanel"

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
  if self.guideDelay then
    self.guideDelay:Stop()
    self.guideDelay = nil
  end
  base.OnDisable(self)
end

local function ComponentDefine(self)
  self.titleText = self:AddComponent(UIText, titleText_path)
  self.closeBtn = self:AddComponent(UIButton, closeBtn_path)
  self.closePanel = self:AddComponent(UIButton, closePanel_path)
  self.bannerPanel = self:AddComponent(UIGhostreconTaskBannerPanel, bannerPanel_path)
  self.rewardPanel = self:AddComponent(UIGhostreconTaskRewardPanel, rewardPanel_path)
  self.specialPanel = self:AddComponent(UIGhostreconTaskSpecialPanel, specialPanel_path)
  self.btnPanel = self:AddComponent(UIGhostreconTaskBtnPanel, btnPanel_path)
  self.guidePanel = self:AddComponent(UIButton, guidePanel_path)
  self.closeBtn:SetOnClick(BindCallback(self.ctrl, self.ctrl.CloseSelf))
  self.closePanel:SetOnClick(BindCallback(self.ctrl, self.ctrl.CloseSelf))
  self.guidePanel:SetActive(false)
  self.guidePanel:SetOnClick(Bind(self, self.OnClickGuidePanel))
end

local function ComponentDestroy(self)
  self.titleText = nil
  self.closeBtn = nil
  self.closePanel = nil
  self.bannerPanel = nil
  self.rewardPanel = nil
  self.specialPanel = nil
  self.btnPanel = nil
  self.guidePanel = nil
end

local function DataDefine(self)
  local uuid = self:GetUserData()
  self:SetData(uuid)
end

local function DataDestroy(self)
end

local function SetData(self, uuid)
  self.bannerPanel:SetData(uuid)
  self.rewardPanel:SetData(uuid)
  local taskInfo = DataCenter.ActGhostreconManager:GetTaskInfoByUUid(uuid)
  local cfg = DataCenter.ActGhostreconManager:GetTaskTemplate(taskInfo.cfgId)
  self.specialPanel:SetData(cfg)
  self.btnPanel:SetData(uuid)
  self.titleText:SetLocalText(cfg.nameId)
  self:CheckGuide()
end

local function OnAddListener(self)
  self:AddUIListener(EventId.PlotGroupDone, self.OnPlotGroupDone)
end

local function OnRemoveListener(self)
  self:RemoveUIListener(EventId.PlotGroupDone, self.OnPlotGroupDone)
end

local function CheckGuide(self)
  if DataCenter.ActGhostreconManager.isTriggerGuide then
    self.guidePanel:SetActive(true)
    self.guideDelay = TimerManager:GetInstance():DelayInvoke(function()
      if self.guidePanel then
        self:OnClickGuidePanel()
      end
    end, 3)
  end
end

local function OnClickGuidePanel(self)
  if self.guidePanel:GetActive() then
    self.guidePanel:SetActive(false)
    local plotId = DataCenter.ActGhostreconManager:GetPlotId(2)
    if plotId then
      EventManager:GetInstance():Broadcast(EventId.PlayPlotGroup, {plotGroupId = plotId, hideMainUI = false})
    else
      DataCenter.ActGhostreconManager:SetTriggerGuide(false)
    end
  end
end

local function OnPlotGroupDone(self, plotGroupId)
  if plotGroupId == DataCenter.ActGhostreconManager:GetPlotId(2) and DataCenter.ActGhostreconManager.isTriggerGuide and self and self.btnPanel and self.btnPanel.deployBtn and self.btnPanel.deployBtn.transform then
    local param = {}
    param.positionType = PositionType.Screen
    param.position = self.btnPanel.deployBtn.transform.position + Vector3.New(50, -50, 0)
    param.isAutoClose = 3
    DataCenter.ArrowManager:ShowFingerArrow(param)
    DataCenter.ActGhostreconManager:SetTriggerGuide(false)
  end
end

UIGhostreconTaskSpecialBeginView.OnCreate = OnCreate
UIGhostreconTaskSpecialBeginView.OnDestroy = OnDestroy
UIGhostreconTaskSpecialBeginView.OnEnable = OnEnable
UIGhostreconTaskSpecialBeginView.OnDisable = OnDisable
UIGhostreconTaskSpecialBeginView.ComponentDefine = ComponentDefine
UIGhostreconTaskSpecialBeginView.ComponentDestroy = ComponentDestroy
UIGhostreconTaskSpecialBeginView.DataDefine = DataDefine
UIGhostreconTaskSpecialBeginView.DataDestroy = DataDestroy
UIGhostreconTaskSpecialBeginView.SetData = SetData
UIGhostreconTaskSpecialBeginView.CheckGuide = CheckGuide
UIGhostreconTaskSpecialBeginView.OnClickGuidePanel = OnClickGuidePanel
UIGhostreconTaskSpecialBeginView.OnPlotGroupDone = OnPlotGroupDone
UIGhostreconTaskSpecialBeginView.OnAddListener = OnAddListener
UIGhostreconTaskSpecialBeginView.OnRemoveListener = OnRemoveListener
return UIGhostreconTaskSpecialBeginView
