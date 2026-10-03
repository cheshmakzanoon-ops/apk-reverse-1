local UITacticalWeaponSuperStageUpView = BaseClass("UITacticalWeaponSuperStageUpView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization

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
  self.imgWeaponNameBgLight = self:AddComponent(UIImage, "Root/weaponNameBgLight")
  self.imgSmallTitleBg = self:AddComponent(UIImage, "Root/smallTitleBg")
  self.textWeaponName = self:AddComponent(UIText, "Root/nameRoot/weaponName")
  self.textReadyDesc = self:AddComponent(UIText, "Root/nameRoot/readyDesc")
  self.textReadyDesc:SetLocalText("new_uav_level_obtain_desc1")
  self.textSmallTitle = self:AddComponent(UIText, "Root/nameRoot/smallTitle")
  self.textSmallTitle:SetLocalText("new_uav_level_obtain_desc2")
  self.textOwnEffect = self:AddComponent(UIText, "Root/OwnEffect")
  self.textCloseTip = self:AddComponent(UIText, "Root/closeTip")
  self.textCloseTip:SetLocalText("new_uav_level_obtain_desc3")
  self.animator = self:AddComponent(UIAnimator, "")
end

local function ComponentDestroy(self)
  self.btnBg = nil
  self.imgWeaponNameBgLight = nil
  self.imgSmallTitleBg = nil
  self.textWeaponName = nil
  self.textReadyDesc = nil
  self.textSmallTitle = nil
  self.textOwnEffect = nil
  self.textCloseTip = nil
end

local function DataDefine(self)
end

local function DataDestroy(self)
end

local function OnAddListener(self)
  base.OnAddListener(self)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
end

function UITacticalWeaponSuperStageUpView:ReInit()
  self.decorationId = self:GetDecorationId()
  local template = DataCenter.DecorationTemplateManager:GetTemplate(self.decorationId)
  self.textWeaponName:SetLocalText(template.name)
  local effectData = DecorationUtil.GetEffectDesc(self.decorationId)
  self.textOwnEffect:SetText(effectData.ownEffect)
end

local function OnBtnBgClick(self)
  self.animator:Play("close")
  EventManager:GetInstance():Broadcast(EventId.TacticalWeaponSuperUpgradeViewClose)
  self.ctrl:CloseSelf()
end

function UITacticalWeaponSuperStageUpView:GetDecorationId()
  local weaponInfo = DataCenter.TacticalWeaponManager:GetFirstWeaponInfo()
  if weaponInfo then
    local id, unlockLv = DataCenter.TacticalWeaponManager:GetDecorationIdByLv(weaponInfo.level)
    return id
  end
  return 60000
end

UITacticalWeaponSuperStageUpView.OnCreate = OnCreate
UITacticalWeaponSuperStageUpView.OnDestroy = OnDestroy
UITacticalWeaponSuperStageUpView.OnEnable = OnEnable
UITacticalWeaponSuperStageUpView.OnDisable = OnDisable
UITacticalWeaponSuperStageUpView.ComponentDefine = ComponentDefine
UITacticalWeaponSuperStageUpView.ComponentDestroy = ComponentDestroy
UITacticalWeaponSuperStageUpView.DataDefine = DataDefine
UITacticalWeaponSuperStageUpView.DataDestroy = DataDestroy
UITacticalWeaponSuperStageUpView.OnAddListener = OnAddListener
UITacticalWeaponSuperStageUpView.OnRemoveListener = OnRemoveListener
UITacticalWeaponSuperStageUpView.OnBtnBgClick = OnBtnBgClick
return UITacticalWeaponSuperStageUpView
