local UIHeroStoryPanelCtrl = BaseClass("UIHeroStoryPanelCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIHeroStoryPanel)
end

UIHeroStoryPanelCtrl.CloseSelf = CloseSelf
return UIHeroStoryPanelCtrl
