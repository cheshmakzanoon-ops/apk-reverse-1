local UIVip18HistoryCtrl = BaseClass("UIVip18HistoryCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIVip18History)
end

UIVip18HistoryCtrl.CloseSelf = CloseSelf
return UIVip18HistoryCtrl
