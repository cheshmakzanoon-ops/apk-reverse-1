local base = UIBaseContainer
local UICommonRewardPopUpComponent = BaseClass("UICommonRewardPopUpComponent", UIBaseContainer)
local Localization = CS.GameEntry.Localization

function UICommonRewardPopUpComponent:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UICommonRewardPopUpComponent:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UICommonRewardPopUpComponent:ComponentDefine()
  self.textTitle = self:AddComponent(UITextMeshProUGUIEx, "Panel/ImgTitleBg/TextTitle")
end

function UICommonRewardPopUpComponent:ComponentDestroy()
  self.textTitle = nil
end

function UICommonRewardPopUpComponent:DataDefine()
end

function UICommonRewardPopUpComponent:DataDestroy()
end

function UICommonRewardPopUpComponent:OnAddListener()
  base.OnAddListener(self)
end

function UICommonRewardPopUpComponent:OnRemoveListener()
  base.OnRemoveListener(self)
end

return UICommonRewardPopUpComponent
