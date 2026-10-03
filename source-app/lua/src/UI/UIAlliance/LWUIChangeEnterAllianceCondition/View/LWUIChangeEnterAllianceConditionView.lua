local LWUIChangeEnterAllianceConditionView = BaseClass("LWUIChangeEnterAllianceConditionView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local panel_path = "UICommonMiniPopUpTitle/Panel"
local close_btn_path = "UICommonMiniPopUpTitle/CloseBtn"
local name_tips_text_path = "ImgBg/NameTipsText"
local input_field_path = "ImgBg/InputField"
local change_btn_path = "ImgBg/ChangeBtn"

function LWUIChangeEnterAllianceConditionView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:InitData()
end

function LWUIChangeEnterAllianceConditionView:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function LWUIChangeEnterAllianceConditionView:ComponentDefine()
  self.panel = self:AddComponent(UIButton, panel_path)
  self.panel:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.close_btn = self:AddComponent(UIButton, close_btn_path)
  self.close_btn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.name_tips_text = self:AddComponent(UIText, name_tips_text_path)
  self.input_field = self:AddComponent(UIInput, input_field_path)
  self.input_field:SetOnValueChange(function(value)
    self:InputOnValueChange(value)
  end)
  self.change_btn = self:AddComponent(UIButton, change_btn_path)
  self.change_btn:SetOnClick(function()
    self:ChangeBtnClick()
  end)
end

function LWUIChangeEnterAllianceConditionView:ComponentDestroy()
  self.panel = nil
  self.close_btn = nil
  self.name_tips_text = nil
  self.input_field = nil
  self.change_btn = nil
end

function LWUIChangeEnterAllianceConditionView:InitData()
  self.conditionValue, self.conditionType = self:GetUserData()
  self.cacheInputValue = 0
  self.input_field:SetText("")
  if self.conditionType == ApplyEnterAllianceConditionType.Power then
    self.name_tips_text:SetLocalText("alliance_system002")
  else
    self.name_tips_text:SetLocalText("alliance_system003")
  end
  self.isGray = true
  CS.UIGray.SetGray(self.change_btn.transform, true, false)
end

function LWUIChangeEnterAllianceConditionView:InputOnValueChange(value)
  local tempValue = tonumber(value)
  if tempValue then
    self.cacheInputValue = tempValue
    if self.cacheInputValue < 0 then
      self.cacheInputValue = 0
    end
    if self.conditionType == ApplyEnterAllianceConditionType.Power then
      local maxValue = LuaEntry.DataConfig:TryGetNum("set_join_alliance_limit", "k2", MAX_AL_LIMIT_POWER)
      if maxValue <= self.cacheInputValue then
        self.cacheInputValue = maxValue
      end
    else
      local maxValue = LuaEntry.DataConfig:TryGetNum("set_join_alliance_limit", "k1", MAX_AL_LIMIT_BASE_LEVEL)
      if maxValue <= self.cacheInputValue then
        self.cacheInputValue = maxValue
      end
    end
    self.input_field:SetText(tostring(self.cacheInputValue))
    if self.isGray then
      self.isGray = false
      CS.UIGray.SetGray(self.change_btn.transform, false, true)
    end
  else
    self.isGray = true
    CS.UIGray.SetGray(self.change_btn.transform, true, false)
  end
end

function LWUIChangeEnterAllianceConditionView:ChangeBtnClick()
  if self.conditionType == ApplyEnterAllianceConditionType.Power then
    SFSNetwork.SendMessage(MsgDefines.AllianceChangeAttributes, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, self.cacheInputValue)
  elseif self.conditionType == ApplyEnterAllianceConditionType.BaseLevel then
    SFSNetwork.SendMessage(MsgDefines.AllianceChangeAttributes, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, self.cacheInputValue)
  end
  self.ctrl:CloseSelf()
end

return LWUIChangeEnterAllianceConditionView
