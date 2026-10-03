local UIVipExtendMainCtrl = BaseClass("UIVipExtendMainCtrl", UIBaseCtrl)

function UIVipExtendMainCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIVipExtend)
end

function UIVipExtendMainCtrl:GetTabDataList()
  return DataCenter.VipExtendManager:GetTypeDataList()
end

return UIVipExtendMainCtrl
