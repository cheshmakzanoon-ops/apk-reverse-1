local UITreasureHuntTipsCtrl = BaseClass("UITreasureHuntTipsCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UITreasureHuntTips)
end

UITreasureHuntTipsCtrl.CloseSelf = CloseSelf
return UITreasureHuntTipsCtrl
