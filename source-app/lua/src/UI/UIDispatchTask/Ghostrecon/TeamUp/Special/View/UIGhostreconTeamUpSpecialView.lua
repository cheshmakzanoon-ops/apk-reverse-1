local base = UIBaseView
local UIGhostreconTeamUpSpecialView = BaseClass("UIGhostreconTeamUpSpecialView", base)
local UIGhostreconTaskBannerPanel = require("UI.UIDispatchTask.Ghostrecon.Task.Component.UIGhostreconTaskBannerPanel")
local UIGhostreconTeamUpSpecialPanel = require("UI.UIDispatchTask.Ghostrecon.TeamUp.Component.UIGhostreconTeamUpSpecialPanel")
local UIGhostreconTeamUpMemberPanel = require("UI.UIDispatchTask.Ghostrecon.TeamUp.Component.UIGhostreconTeamUpMemberPanel")
local UIGhostreconTeamUpBtnPanel = require("UI.UIDispatchTask.Ghostrecon.TeamUp.Component.UIGhostreconTeamUpBtnPanel")
local titleText_path = "Root/Content/UICommonPopBg/bg_3/TitleTxt"
local closeBtn_path = "Root/Content/UICommonPopBg/bg_3/CloseBtn"
local closePanel_path = "Panel"
local bannerPanel_path = "Root/Content/ContentHolder/BannerPanel"
local specialPanel_path = "Root/Content/ContentHolder/SpecialPanel"
local teamUpPanel_path = "Root/Content/ContentHolder/TeamUpPanel"
local btnPanel_path = "Root/Content/ContentHolder/BtnPanel"

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
  self.specialPanel = self:AddComponent(UIGhostreconTeamUpSpecialPanel, specialPanel_path)
  self.teamUpPanel = self:AddComponent(UIGhostreconTeamUpMemberPanel, teamUpPanel_path)
  self.btnPanel = self:AddComponent(UIGhostreconTeamUpBtnPanel, btnPanel_path)
  self.closeBtn:SetOnClick(BindCallback(self.ctrl, self.ctrl.CloseSelf))
  self.closePanel:SetOnClick(BindCallback(self.ctrl, self.ctrl.CloseSelf))
end

local function ComponentDestroy(self)
  self.titleText = nil
  self.closeBtn = nil
  self.closePanel = nil
  self.bannerPanel = nil
  self.specialPanel = nil
  self.teamUpPanel = nil
  self.btnPanel = nil
end

local function DataDefine(self)
  local uuid = self:GetUserData()
  self:SetData(uuid)
end

local function DataDestroy(self)
  self.uuid = nil
  self.isRemoveListener = nil
end

local function OnAddListener(self)
  self:AddUIListener(EventId.GhostreconRefreshOneTask, self.Refresh)
  self.isAddListener = true
end

local function OnRemoveListener(self)
  if self.isAddListener then
    self:RemoveUIListener(EventId.GhostreconRefreshOneTask, self.Refresh)
    self.isAddListener = false
  end
end

local function SetData(self, uuid)
  self.uuid = uuid
  local taskInfo = DataCenter.ActGhostreconManager:GetTaskInfoByUUid(uuid)
  if taskInfo and (taskInfo.bubbleType == GhostreconTaskType.Own_TeamingUp or taskInfo.bubbleType == GhostreconTaskType.Alliance_TeamingUp) then
    local cfg = DataCenter.ActGhostreconManager:GetTaskTemplate(taskInfo.cfgId)
    self.titleText:SetLocalText(cfg.nameId)
    self.bannerPanel:SetData(uuid)
    self.specialPanel:SetData(uuid)
    self.teamUpPanel:SetData(uuid)
    self.btnPanel:SetData(uuid)
  else
    self.ctrl.CloseSelf()
  end
end

local function OnGhostreconRefreshTask(self, param)
  if param.uuid == self.uuid then
    self:SetData(self.uuid)
  end
end

local function Refresh(self, param)
  if param.uuid == self.uuid then
    self:SetData(self.uuid)
  end
end

local function IsMeet(self)
  return self.specialPanel:IsMeet()
end

UIGhostreconTeamUpSpecialView.OnCreate = OnCreate
UIGhostreconTeamUpSpecialView.OnDestroy = OnDestroy
UIGhostreconTeamUpSpecialView.OnEnable = OnEnable
UIGhostreconTeamUpSpecialView.OnDisable = OnDisable
UIGhostreconTeamUpSpecialView.ComponentDefine = ComponentDefine
UIGhostreconTeamUpSpecialView.ComponentDestroy = ComponentDestroy
UIGhostreconTeamUpSpecialView.DataDefine = DataDefine
UIGhostreconTeamUpSpecialView.DataDestroy = DataDestroy
UIGhostreconTeamUpSpecialView.SetData = SetData
UIGhostreconTeamUpSpecialView.OnAddListener = OnAddListener
UIGhostreconTeamUpSpecialView.OnRemoveListener = OnRemoveListener
UIGhostreconTeamUpSpecialView.OnGhostreconRefreshTask = OnGhostreconRefreshTask
UIGhostreconTeamUpSpecialView.Refresh = Refresh
UIGhostreconTeamUpSpecialView.IsMeet = IsMeet
return UIGhostreconTeamUpSpecialView
