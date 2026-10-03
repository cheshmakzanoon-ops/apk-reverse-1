local UILWRemarkNameListCtrl = BaseClass("UILWRemarkNameListCtrl", UIBaseCtrl)

function UILWRemarkNameListCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UILWRemarkNameList)
end

return UILWRemarkNameListCtrl
