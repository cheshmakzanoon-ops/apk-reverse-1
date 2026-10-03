local UIGetDuelScoreTipCtrl = BaseClass("UIGetDuelScoreTipCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIGetDuelScoreTip)
end

UIGetDuelScoreTipCtrl.CloseSelf = CloseSelf
return UIGetDuelScoreTipCtrl
