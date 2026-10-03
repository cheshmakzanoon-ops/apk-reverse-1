local UIAccountList = BaseClass("UIAccountList", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIAccountList)
end

UIAccountList.CloseSelf = CloseSelf
return UIAccountList
