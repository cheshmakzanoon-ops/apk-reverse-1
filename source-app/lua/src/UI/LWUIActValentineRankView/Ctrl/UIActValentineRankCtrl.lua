local UIActValentineRankCtrl = BaseClass("UIActValentineRankCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIActValentineRankView)
end

UIActValentineRankCtrl.CloseSelf = CloseSelf
return UIActValentineRankCtrl
