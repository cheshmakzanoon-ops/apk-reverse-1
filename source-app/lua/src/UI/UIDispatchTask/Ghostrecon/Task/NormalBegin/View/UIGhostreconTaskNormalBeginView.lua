local base = UIBaseView
local UIGhostreconTaskNormalBeginView = BaseClass("UIGhostreconTaskNormalBeginView", base)
local UIGhostreconTaskBannerPanel = require("UI.UIDispatchTask.Ghostrecon.Task.Component.UIGhostreconTaskBannerPanel")
local UIGhostreconTaskRewardPanel = require("UI.UIDispatchTask.Ghostrecon.Task.Component.UIGhostreconTaskRewardPanel")
local UIGhostreconTaskBtnPanel = require("UI.UIDispatchTask.Ghostrecon.Task.Component.UIGhostreconTaskBtnPanel")
local titleText_path = "Root/Content/UICommonPopBg/bg_3/TitleTxt"
local bannerPanel_path = "Root/Content/ContentHolder/BannerPanel"
local rewardPanel_path = "Root/Content/ContentHolder/RewardPanel"
local btnPanel_path = "Root/Content/ContentHolder/BtnPanel"
local closeBtn_path = "Root/Content/UICommonPopBg/bg_3/CloseBtn"
local closePanel_path = "Panel"

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
  self.bannerPanel = self:AddComponent(UIGhostreconTaskBannerPanel, bannerPanel_path)
  self.rewardPanel = self:AddComponent(UIGhostreconTaskRewardPanel, rewardPanel_path)
  self.btnPanel = self:AddComponent(UIGhostreconTaskBtnPanel, btnPanel_path)
  self.closeBtn = self:AddComponent(UIButton, closeBtn_path)
  self.closePanel = self:AddComponent(UIButton, closePanel_path)
  self.closeBtn:SetOnClick(BindCallback(self.ctrl, self.ctrl.CloseSelf))
  self.closePanel:SetOnClick(BindCallback(self.ctrl, self.ctrl.CloseSelf))
end

local function ComponentDestroy(self)
  self.titleText = nil
  self.bannerPanel = nil
  self.rewardPanel = nil
  self.btnPanel = nil
  self.closeBtn = nil
  self.closePanel = nil
end

local function DataDefine(self)
  local uuid = self:GetUserData()
  self:SetData(uuid)
end

local function DataDestroy(self)
end

local function SetData(self, uuid)
  local taskInfo = DataCenter.ActGhostreconManager:GetTaskInfoByUUid(uuid)
  local cfg = DataCenter.ActGhostreconManager:GetTaskTemplate(taskInfo.cfgId)
  self.titleText:SetLocalText(cfg.nameId)
  self.bannerPanel:SetData(uuid)
  self.rewardPanel:SetData(uuid)
  self.btnPanel:SetData(uuid)
  self:CheckGuide()
end

local function CheckGuide(self)
  if DataCenter.ActGhostreconManager.isTriggerGuide then
    self.guideDelay = TimerManager:GetInstance():DelayInvoke(function()
      if self and self.btnPanel and self.btnPanel.deployBtn and self.btnPanel.deployBtn.transform then
        local param = {}
        param.positionType = PositionType.Screen
        param.position = self.btnPanel.deployBtn.transform.position + Vector3.New(50, -50, 0)
        param.isAutoClose = 3
        DataCenter.ArrowManager:ShowFingerArrow(param)
      end
    end, 1)
    DataCenter.ActGhostreconManager:SetTriggerGuide(false)
  end
end

UIGhostreconTaskNormalBeginView.OnCreate = OnCreate
UIGhostreconTaskNormalBeginView.OnDestroy = OnDestroy
UIGhostreconTaskNormalBeginView.OnEnable = OnEnable
UIGhostreconTaskNormalBeginView.OnDisable = OnDisable
UIGhostreconTaskNormalBeginView.ComponentDefine = ComponentDefine
UIGhostreconTaskNormalBeginView.ComponentDestroy = ComponentDestroy
UIGhostreconTaskNormalBeginView.DataDefine = DataDefine
UIGhostreconTaskNormalBeginView.DataDestroy = DataDestroy
UIGhostreconTaskNormalBeginView.SetData = SetData
UIGhostreconTaskNormalBeginView.CheckGuide = CheckGuide
return UIGhostreconTaskNormalBeginView
