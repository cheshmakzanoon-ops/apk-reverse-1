local base = UIBaseContainer
local UISurfingBattleGMItem = BaseClass("UISurfingBattleGMItem", base)
local invincible_tog_path = "InvincibleTog"
local option_tog_path = "OptionTog"
local old_option_path = "OldOption"
local jump_vo_path = "OldOption/JumpVo"
local gravity_path = "OldOption/Gravity"
local new_option_path = "NewOption"
local height_limit_path = "NewOption/HeightLimit"
local jump_duration_path = "NewOption/JumpDuration"
local curve_top_param_path = "NewOption/CurveTopParam"

function UISurfingBattleGMItem:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:AddListener()
end

function UISurfingBattleGMItem:OnDestroy()
  self:RemoveListener()
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

function UISurfingBattleGMItem:ComponentDefine()
  self.invincible_tog = self:AddComponent(UIToggle, invincible_tog_path)
  self.invincible_tog:SetIsOn(false)
  self.invincible_tog:SetOnValueChanged(function(isOn)
    self:OnInvincibleTogChanged(isOn)
  end)
  self.option_tog = self:AddComponent(UIToggle, option_tog_path)
  self.option_tog:SetOnValueChanged(function(isOn)
    self:OnOptionTogChanged(isOn)
  end)
  self.old_option = self:AddComponent(UIBaseContainer, old_option_path)
  self.jump_vo = self:AddComponent(UIInput, jump_vo_path)
  self.jump_vo:SetOnEndEdit(function(val)
    self:OnJumpVoEndEdit(val)
  end)
  self.gravity = self:AddComponent(UIInput, gravity_path)
  self.gravity:SetOnEndEdit(function(val)
    self:OnGravityEndEdit(val)
  end)
  self.new_option = self:AddComponent(UIBaseContainer, new_option_path)
  self.height_limit = self:AddComponent(UIInput, height_limit_path)
  self.height_limit:SetOnEndEdit(function(val)
    self:OnHeightLimitEndEdit(val)
  end)
  self.jump_duration = self:AddComponent(UIInput, jump_duration_path)
  self.jump_duration:SetOnEndEdit(function(val)
    self:OnJumpDurationEndEdit(val)
  end)
  self.curve_top_param = self:AddComponent(UIInput, curve_top_param_path)
  self.curve_top_param:SetOnEndEdit(function(val)
    self:OnCurveTopParamEndEdit(val)
  end)
end

function UISurfingBattleGMItem:ComponentDestroy()
  self.invincible_tog = nil
  self.option_tog = nil
  self.old_option = nil
  self.jump_vo = nil
  self.gravity = nil
  self.new_option = nil
  self.height_limit = nil
  self.jump_duration = nil
  self.curve_top_param = nil
end

function UISurfingBattleGMItem:DataDefine()
  self.buff = nil
  self.logic = DataCenter.LWBattleManager:GetCurBattleLogic()
  local isOn = self.logic:GetOldOption()
  self.option_tog:SetIsOn(isOn)
  self:OnOptionTogChanged(isOn)
end

function UISurfingBattleGMItem:DataDestroy()
  self.buff = nil
  self.logic = nil
end

function UISurfingBattleGMItem:AddListener()
  self:AddUIListener(EventId.SurfingOnGmInvincibleChanged, self.OnInvincibleChanged)
end

function UISurfingBattleGMItem:RemoveListener()
  self:RemoveUIListener(EventId.SurfingOnGmInvincibleChanged)
end

function UISurfingBattleGMItem:OnInvincibleChanged(isOn)
  self.invincible_tog:SetIsOn(isOn)
end

function UISurfingBattleGMItem:OnInvincibleTogChanged(isOn)
  if self.logic then
    self.logic:SetInvincible(isOn)
  end
end

function UISurfingBattleGMItem:OnOptionTogChanged(isOn)
  self.old_option:SetActive(isOn)
  self.new_option:SetActive(not isOn)
  if self.logic then
    self.logic:SetOldOption(isOn)
    if isOn then
      self.jump_vo:SetText(self.logic:GetJumpVo())
      self.gravity:SetText(self.logic:GetGravity())
    else
      self.height_limit:SetText(self.logic:GetHeightLimit())
      self.jump_duration:SetText(self.logic:GetJumpDuration())
      self.curve_top_param:SetText(self.logic:GetCurveTopParam())
    end
  end
end

function UISurfingBattleGMItem:OnJumpVoEndEdit(value)
  if self.logic then
    self.logic:SetJumpVo(value)
  end
end

function UISurfingBattleGMItem:OnGravityEndEdit(value)
  if self.logic then
    self.logic:SetGravity(value)
  end
end

function UISurfingBattleGMItem:OnHeightLimitEndEdit(value)
  if self.logic then
    self.logic:SetHeightLimit(value)
  end
end

function UISurfingBattleGMItem:OnJumpDurationEndEdit(value)
  if self.logic then
    self.logic:SetJumpDuration(value)
  end
end

function UISurfingBattleGMItem:OnCurveTopParamEndEdit(value)
  if self.logic then
    self.logic:SetCurveTopParam(value)
  end
end

return UISurfingBattleGMItem
