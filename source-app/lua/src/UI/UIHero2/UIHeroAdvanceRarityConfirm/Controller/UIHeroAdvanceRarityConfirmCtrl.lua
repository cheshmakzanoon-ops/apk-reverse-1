local UIHeroAdvanceRarityConfirmCtrl = BaseClass("UIHeroAdvanceRarityConfirmCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIHeroAdvanceRarityConfirm)
end

UIHeroAdvanceRarityConfirmCtrl.CloseSelf = CloseSelf
return UIHeroAdvanceRarityConfirmCtrl
