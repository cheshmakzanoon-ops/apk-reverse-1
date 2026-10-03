local base = UIBaseContainer
local UIActEpidemicMainHelpTips = BaseClass("UIActEpidemicMainHelpTips", UIBaseContainer)
local Localization = CS.GameEntry.Localization

function UIActEpidemicMainHelpTips:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UIActEpidemicMainHelpTips:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIActEpidemicMainHelpTips:ComponentDefine()
  self.imgIcon = self:AddComponent(UIImage, "imgIcon")
  self.btnClickRect = self:AddComponent(UIButton, "clickRect")
  self.btnClickRect:SetOnClick(function()
    self:OnBtnClickRectClick()
  end)
end

function UIActEpidemicMainHelpTips:ComponentDestroy()
  self.imgIcon = nil
  self.btnClickRect = nil
end

function UIActEpidemicMainHelpTips:DataDefine()
end

function UIActEpidemicMainHelpTips:DataDestroy()
end

function UIActEpidemicMainHelpTips:OnAddListener()
  base.OnAddListener(self)
end

function UIActEpidemicMainHelpTips:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UIActEpidemicMainHelpTips:OnBtnClickRectClick()
  if self.ruleId then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIActEpidemicHelpView, {anim = true}, self.ruleId)
  end
end

function UIActEpidemicMainHelpTips:Setup(ruleId)
  self.ruleId = ruleId
end

return UIActEpidemicMainHelpTips
