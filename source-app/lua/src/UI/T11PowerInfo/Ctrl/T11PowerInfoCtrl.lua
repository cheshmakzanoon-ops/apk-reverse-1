local T11PowerInfoCtrl = BaseClass("T11PowerInfoCtrl", UIBaseCtrl)

function T11PowerInfoCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.T11PowerInfoView)
end

function T11PowerInfoCtrl:GetPowerMap()
  return T11Util.GetT11PowerMap(T11PowerInfoGetType.All)
end

return T11PowerInfoCtrl
