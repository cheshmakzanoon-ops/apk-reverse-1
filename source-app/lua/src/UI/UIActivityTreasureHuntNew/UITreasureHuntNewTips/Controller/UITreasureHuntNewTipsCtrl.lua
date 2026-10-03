local UITreasureHuntNewTipsCtrl = BaseClass("UITreasureHuntNewTipsCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UITreasureHuntNewTips)
end

UITreasureHuntNewTipsCtrl.CloseSelf = CloseSelf
return UITreasureHuntNewTipsCtrl
