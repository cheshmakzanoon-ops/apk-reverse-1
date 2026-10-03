local UIPVEResetPosition = BaseClass("UIPVEResetPosition", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local reset_position_name_path = "ResetPositionImg/ResetPositionName"
local this_path = ""

function UIPVEResetPosition:OnCreate()
  base.OnCreate(self)
  self:DataDefine()
  self:ComponentDefine()
  self:ReInit()
end

function UIPVEResetPosition:OnDestroy()
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

function UIPVEResetPosition:ComponentDefine()
  self.reset_position_name = self:AddComponent(UIText, reset_position_name_path)
  self.self_btn = self:AddComponent(UIButton, this_path)
  self.self_btn:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self:OnResetPositionClick()
  end)
end

function UIPVEResetPosition:OnResetPositionClick()
  UIUtil.ShowMessage(Localization:GetString(GameDialogDefine.RESET_POSITION_TIP), 2, tostring(GameDialogDefine.RESET_POSITION), GameDialogDefine.CANCEL, function()
    DataCenter.BattleLevel:SetPosition(DataCenter.BattleLevel:GetResetPosition(), true)
    self:SetActive(false)
  end, nil)
end

function UIPVEResetPosition:ComponentDestroy()
  self.reset_position_name = nil
  self.self_btn = nil
end

function UIPVEResetPosition:DataDefine()
end

function UIPVEResetPosition:DataDestroy()
end

function UIPVEResetPosition:OnEnable()
  base.OnEnable(self)
end

function UIPVEResetPosition:OnDisable()
  base.OnDisable(self)
end

function UIPVEResetPosition:OnAddListener()
  base.OnAddListener(self)
end

function UIPVEResetPosition:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UIPVEResetPosition:ReInit()
  self.reset_position_name:SetLocalText(GameDialogDefine.RESET_POSITION)
  self:SetActive(false)
end

return UIPVEResetPosition
