local UITrainPrepareMemberListCtrl = BaseClass("UITrainPrepareMemberListCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UITrainPrepareMemberList)
end

UITrainPrepareMemberListCtrl.CloseSelf = CloseSelf
return UITrainPrepareMemberListCtrl
