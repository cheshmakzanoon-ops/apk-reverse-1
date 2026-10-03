local UIActValentineShareRankCtrl = BaseClass("UIActValentineShareRankCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.ValentineShareRank)
end

UIActValentineShareRankCtrl.CloseSelf = CloseSelf
return UIActValentineShareRankCtrl
