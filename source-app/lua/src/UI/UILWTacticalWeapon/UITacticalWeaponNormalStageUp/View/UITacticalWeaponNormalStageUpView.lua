local UITacticalWeaponNormalStageUpView = BaseClass("UITacticalWeaponNormalStageUpView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local CONTENT_TIME = 2

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:ReInit()
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
  self.btnBg = self:AddComponent(UIButton, "bgBtn")
  self.btnBg:SetOnClick(function()
    self:OnBtnBgClick()
  end)
  self.textDesc = self:AddComponent(UIText, "Root/desc")
  self.textCloseTip = self:AddComponent(UIText, "Root/closeTip")
  self.textCloseTip:SetLocalText("new_uav_level_obtain_desc3")
  self.textCloseTip:SetActive(false)
  self.canQuit = false
end

local function ComponentDestroy(self)
  self.btnBg = nil
  self.textDesc = nil
  self.textCloseTip = nil
end

local function DataDefine(self)
end

local function DataDestroy(self)
  if self.timer then
    self.timer:Stop()
    self.timer = nil
  end
end

local function OnAddListener(self)
  base.OnAddListener(self)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
end

function UITacticalWeaponNormalStageUpView:ReInit()
  local weaponInfo = DataCenter.TacticalWeaponManager:GetFirstWeaponInfo()
  if not weaponInfo or not weaponInfo.levelTemplate then
    self.ctrl:CloseSelf()
    return
  end
  local upgradeId = weaponInfo.levelTemplate.upgrade_id
  local upgradeTemplate = DataCenter.TacticalWeaponTemplateManager:GetNormalStageUpgradeTemplate(upgradeId)
  self.textDesc:SetFontSize(30)
  self.textDesc:SetBestFitEnable(true)
  local content = Localization:GetString(upgradeTemplate.typewriter_desc)
  self.textDesc:SetText(content)
  self.textDesc:ForceUpdate()
  local size = self.textDesc:GetFontSize()
  self.textDesc:SetBestFitEnable(false)
  self.textDesc:SetFontSize(size)
  self.textDesc:DOText(content, CONTENT_TIME)
  self.timer = TimerManager:GetInstance():DelayInvoke(function()
    self.textCloseTip:SetActive(true)
    self.canQuit = true
  end, CONTENT_TIME)
end

local function OnBtnBgClick(self)
  if not self.canQuit then
    return
  end
  EventManager:GetInstance():Broadcast(EventId.TacticalWeaponNormalUpgradeViewClose)
  self.ctrl:CloseSelf()
end

UITacticalWeaponNormalStageUpView.OnCreate = OnCreate
UITacticalWeaponNormalStageUpView.OnDestroy = OnDestroy
UITacticalWeaponNormalStageUpView.OnEnable = OnEnable
UITacticalWeaponNormalStageUpView.OnDisable = OnDisable
UITacticalWeaponNormalStageUpView.ComponentDefine = ComponentDefine
UITacticalWeaponNormalStageUpView.ComponentDestroy = ComponentDestroy
UITacticalWeaponNormalStageUpView.DataDefine = DataDefine
UITacticalWeaponNormalStageUpView.DataDestroy = DataDestroy
UITacticalWeaponNormalStageUpView.OnAddListener = OnAddListener
UITacticalWeaponNormalStageUpView.OnRemoveListener = OnRemoveListener
UITacticalWeaponNormalStageUpView.OnBtnBgClick = OnBtnBgClick
return UITacticalWeaponNormalStageUpView
