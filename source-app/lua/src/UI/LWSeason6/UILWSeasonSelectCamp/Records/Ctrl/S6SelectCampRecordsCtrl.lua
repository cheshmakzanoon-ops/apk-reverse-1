local S6SelectCampRecordsCtrl = BaseClass("S6SelectCampRecordsCtrl", UIBaseCtrl)

function S6SelectCampRecordsCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.S6SelectCampRecordsView)
end

return S6SelectCampRecordsCtrl
