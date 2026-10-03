local base = UIBaseView
local UIGhostreconTaskNormalRuningView = BaseClass("UIGhostreconTaskNormalRuningView", base)
local UIGhostreconTaskBannerPanel = require("UI.UIDispatchTask.Ghostrecon.Task.Component.UIGhostreconTaskBannerPanel")
local UIGhostreconTaskRewardPanel = require("UI.UIDispatchTask.Ghostrecon.Task.Component.UIGhostreconTaskRewardPanel")
local UIGhostreconTaskMemberPanel = require("UI.UIDispatchTask.Ghostrecon.Task.Component.UIGhostreconTaskMemberPanel")
local titleText_path = "Root/Content/UICommonPopBg/bg_3/TitleTxt"
local closeBtn_path = "Root/Content/UICommonPopBg/bg_3/CloseBtn"
local closePanel_path = "Panel"
local bannerPanel_path = "Root/Content/ContentHolder/BannerPanel"
local rewardPanel_path = "Root/Content/ContentHolder/RewardPanel"
local memberPanel_path = "Root/Content/ContentHolder/MemberPanel"
local tipText_path = "Root/Content/ContentHolder/TipText"

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
  self.titleText = self:AddComponent(UIText, titleText_path)
  self.closeBtn = self:AddComponent(UIButton, closeBtn_path)
  self.closePanel = self:AddComponent(UIButton, closePanel_path)
  self.bannerPanel = self:AddComponent(UIGhostreconTaskBannerPanel, bannerPanel_path)
  self.rewardPanel = self:AddComponent(UIGhostreconTaskRewardPanel, rewardPanel_path)
  self.memberPanel = self:AddComponent(UIGhostreconTaskMemberPanel, memberPanel_path)
  self.tipText = self:AddComponent(UIText, tipText_path)
  self.closeBtn:SetOnClick(BindCallback(self.ctrl, self.ctrl.CloseSelf))
  self.closePanel:SetOnClick(BindCallback(self.ctrl, self.ctrl.CloseSelf))
end

local function ComponentDestroy(self)
  self.titleText = nil
  self.closeBtn = nil
  self.closePanel = nil
  self.bannerPanel = nil
  self.rewardPanel = nil
  self.memberPanel = nil
  self.tipText = nil
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
  self.memberPanel:SetData(uuid)
  if DataCenter.ActGhostreconManager:GetTeamworkRewardTimesFull() then
    self.tipText:SetActive(true)
  else
    self.tipText:SetActive(false)
  end
end

UIGhostreconTaskNormalRuningView.OnCreate = OnCreate
UIGhostreconTaskNormalRuningView.OnDestroy = OnDestroy
UIGhostreconTaskNormalRuningView.OnEnable = OnEnable
UIGhostreconTaskNormalRuningView.OnDisable = OnDisable
UIGhostreconTaskNormalRuningView.ComponentDefine = ComponentDefine
UIGhostreconTaskNormalRuningView.ComponentDestroy = ComponentDestroy
UIGhostreconTaskNormalRuningView.DataDefine = DataDefine
UIGhostreconTaskNormalRuningView.DataDestroy = DataDestroy
UIGhostreconTaskNormalRuningView.SetData = SetData
return UIGhostreconTaskNormalRuningView
