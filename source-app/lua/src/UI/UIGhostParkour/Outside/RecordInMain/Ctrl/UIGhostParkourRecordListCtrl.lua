local UIGhostParkourRecordListCtrl = BaseClass("UIGhostParkourRecordListCtrl", UIBaseCtrl)

function UIGhostParkourRecordListCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIGhostParkourRecordListView)
end

return UIGhostParkourRecordListCtrl
