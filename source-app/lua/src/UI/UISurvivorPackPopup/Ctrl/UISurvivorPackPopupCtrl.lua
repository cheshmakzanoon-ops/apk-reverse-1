local UISurvivorPackPopupCtrl = BaseClass("UISurvivorPackPopupCtrl", UIBaseCtrl)

function UISurvivorPackPopupCtrl:CloseSelf(fakeUid)
  if fakeUid ~= nil and DataCenter and DataCenter.SurvivorPackManager and DataCenter.SurvivorPackManager.OnGiftPopupClosed then
    DataCenter.SurvivorPackManager:OnGiftPopupClosed(fakeUid)
  end
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UISurvivorPackPopup)
end

return UISurvivorPackPopupCtrl
