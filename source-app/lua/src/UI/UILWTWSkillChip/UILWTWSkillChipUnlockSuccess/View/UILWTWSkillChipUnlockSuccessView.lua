local base = UIBaseView
local UILWTWSkillChipUnlockSuccessView = BaseClass("UILWTWSkillChipUnlockSuccessView", base)
local bgpanel_btn_path = "UIGarageRefitUpgrade/UICommonRewardPopUp/Panel"
local function_icon_path = "UIGarageRefitUpgrade/Root/FunctionImage"

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
  self.bgpanel_btn = self:AddComponent(UIButton, bgpanel_btn_path)
  self.function_icon = self:AddComponent(UIImage, function_icon_path)
  self.bgpanel_btn:SetOnClick(function()
    local functionIconPos = self.function_icon:GetPosition()
    self.ctrl:CloseSelf()
    EventManager:GetInstance():Broadcast(EventId.TWSkillChipFunctionUnlockClose, functionIconPos)
  end)
end

local function ComponentDestroy(self)
  self.bgpanel_btn = nil
  self.function_icon = nil
end

local function DataDefine(self)
end

local function DataDestroy(self)
end

UILWTWSkillChipUnlockSuccessView.OnCreate = OnCreate
UILWTWSkillChipUnlockSuccessView.OnDestroy = OnDestroy
UILWTWSkillChipUnlockSuccessView.OnEnable = OnEnable
UILWTWSkillChipUnlockSuccessView.OnDisable = OnDisable
UILWTWSkillChipUnlockSuccessView.ComponentDefine = ComponentDefine
UILWTWSkillChipUnlockSuccessView.ComponentDestroy = ComponentDestroy
UILWTWSkillChipUnlockSuccessView.DataDefine = DataDefine
UILWTWSkillChipUnlockSuccessView.DataDestroy = DataDestroy
return UILWTWSkillChipUnlockSuccessView
