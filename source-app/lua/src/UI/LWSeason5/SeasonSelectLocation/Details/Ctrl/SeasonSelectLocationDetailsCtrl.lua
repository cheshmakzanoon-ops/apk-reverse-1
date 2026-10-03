local SeasonSelectLocationDetailsCtrl = BaseClass("SeasonSelectLocationDetailsCtrl", UIBaseCtrl)

function SeasonSelectLocationDetailsCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.SeasonSelectLocationDetails)
end

return SeasonSelectLocationDetailsCtrl
