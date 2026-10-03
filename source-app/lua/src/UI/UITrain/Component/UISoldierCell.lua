local UISoldierCell = BaseClass("UISoldierCell", UIBaseContainer)
local base = UIBaseContainer
local Param = DataClass("Param", ParamData)
local ParamData = {
  armyId,
  callBack,
  index,
  isShowFlag,
  isUnLock,
  gray,
  isSelect
}
local icon_path = "Icon"
local num_text_path = "CountText"
local level_text_path = "LevelText"
local upgrad_path = "Upgrade"
local this_path = ""
local locked_img_path = "locked"
local unlock_img_path = "unlock"
local unlock_effect_path = "VFX_ui_trainsoldiercell_unlock"
local SelectNumColor = Color.New(1, 0.8901961, 0.7921569, 1)
local UnSelectNumColor = Color.New(0.7137255, 0.5372549, 0.4392157, 1)
local unlock_ani = "V_ui_UITrainSoldierCell_unlock"
local normal_ani = "V_ui_UITrainSoldierCell_normal"

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

local function OnDestroy(self)
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function ComponentDefine(self)
  self.icon = self:AddComponent(UIImage, icon_path)
  self.num_text = self:AddComponent(UIText, num_text_path)
  self.btn = self:AddComponent(UIButton, this_path)
  self.level_text = self:AddComponent(UIText, level_text_path)
  self.upgrade = self:AddComponent(UIBaseContainer, upgrad_path)
  self.btn:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self:OnBtnClick()
  end)
  self.locked_img = self:AddComponent(UIImage, locked_img_path)
  self.unlock_img = self:AddComponent(UIImage, unlock_img_path)
  self.unlock_effect = self:AddComponent(UIBaseContainer, unlock_effect_path)
  self.anim = self:AddComponent(UIAnimator, this_path)
  self.unlock_effect:SetActive(false)
  self.locked_img:SetActive(false)
  self.unlock_img:SetActive(false)
end

local function ComponentDestroy(self)
  self.icon = nil
  self.num_text = nil
  self.btn = nil
  self.level_text = nil
  self.upgrade = nil
  if self.delayTimer ~= nil then
    self.delayTimer:Stop()
    self.delayTimer = nil
  end
end

local function DataDefine(self)
  self.param = {}
  self.numColor = nil
end

local function DataDestroy(self)
  self.param = nil
  self.numColor = nil
end

local function ReInit(self, param)
  self.param = param
  if param.armyId ~= nil then
    local template = DataCenter.ArmyTemplateManager:GetArmyTemplate(self.param.armyId)
    if template ~= nil then
      self.icon:LoadSprite(string.format(LoadPath.SoldierIcons, template.icon))
    end
  end
  self.locked_img:SetActive(false)
  self.unlock_img:SetActive(false)
  if param.isUnLock then
    if param.isToUnLock then
      self.icon:SetMaterial(param.gray)
      self.unlock_img:SetActive(true)
    else
      self.icon:SetMaterial(nil)
    end
  else
    self.locked_img:SetActive(true)
    self.icon:SetMaterial(param.gray)
  end
  self.level_text:SetText(RomeNum[param.index])
  local count = 0
  local soldier = DataCenter.ArmyManager:FindArmy(param.armyId)
  if soldier ~= nil then
    count = soldier.free
  end
  self.num_text:SetText(string.GetFormattedSeperatorNum(count))
  self:SetSelect(param.isSelect)
  local showUpgrade = DataCenter.ArmyManager:IsCanUpgrade(param.armyId, param.buildId)
  local unlock = DataCenter.ArmyManager:GetCanUnLockUpgrade(param.buildId)
  self.upgrade:SetActive(showUpgrade and unlock)
  if self.param.isToUnLock then
    self:ShowUnlockAnimation()
  else
    self:ShowNormalAnimation()
  end
end

local function OnBtnClick(self)
  if self.param.isToUnLock then
    return
  end
  if self.param.callBack ~= nil then
    self.param.callBack(self.param.index)
  end
end

local function ShowNormalAnimation(self)
  self.unlock_effect:SetActive(false)
  self.anim:Play(normal_ani, 0, 0)
end

local function ShowUnlockAnimation(self)
  self.unlock_effect:SetActive(true)
  local _, time = self.anim:PlayAnimationReturnTime(unlock_ani, 0, 0)
  self.delayTimer = TimerManager:GetInstance():DelayInvoke(function()
    if self.delayTimer ~= nil then
      self.delayTimer:Stop()
      self.delayTimer = nil
    end
    self:DoWhenUnlockAnimationComplete()
  end, time)
end

local function DoWhenUnlockAnimationComplete(self)
  DataCenter.ArmyManager:SaveArmyUnlock(self.param.buildId, "")
  self.param.isToUnLock = false
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIArmyUnlock, self.param.armyId)
  self:ReInit(self.param)
end

local function SetSelect(self, value)
  if value then
    self:SetNumColor(SelectNumColor)
  else
    self:SetNumColor(UnSelectNumColor)
  end
end

local function SetNumColor(self, value)
  if self.numColor ~= value then
    self.numColor = value
    self.num_text:SetColor(value)
  end
end

local function GetSelectGo(self)
  return self.transform
end

UISoldierCell.OnCreate = OnCreate
UISoldierCell.OnDestroy = OnDestroy
UISoldierCell.Param = Param
UISoldierCell.OnBtnClick = OnBtnClick
UISoldierCell.OnEnable = OnEnable
UISoldierCell.OnDisable = OnDisable
UISoldierCell.ComponentDefine = ComponentDefine
UISoldierCell.ComponentDestroy = ComponentDestroy
UISoldierCell.DataDefine = DataDefine
UISoldierCell.DataDestroy = DataDestroy
UISoldierCell.ReInit = ReInit
UISoldierCell.SetNumColor = SetNumColor
UISoldierCell.SetSelect = SetSelect
UISoldierCell.GetSelectGo = GetSelectGo
UISoldierCell.ShowUnlockAnimation = ShowUnlockAnimation
UISoldierCell.ShowNormalAnimation = ShowNormalAnimation
UISoldierCell.DoWhenUnlockAnimationComplete = DoWhenUnlockAnimationComplete
return UISoldierCell
