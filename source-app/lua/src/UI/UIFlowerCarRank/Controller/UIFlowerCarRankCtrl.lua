local UIFlowerCarRankCtrl = BaseClass("UIFlowerCarRankCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIFlowerCarRank)
end

UIFlowerCarRankCtrl.CloseSelf = CloseSelf
return UIFlowerCarRankCtrl
