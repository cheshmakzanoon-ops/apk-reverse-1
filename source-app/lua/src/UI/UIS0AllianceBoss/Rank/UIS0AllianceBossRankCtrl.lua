local UIS0AllianceBossRankCtrl = BaseClass("UIS0AllianceBossRankCtrl", UIBaseCtrl)

function UIS0AllianceBossRankCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIS0AllianceBossRank)
end

return UIS0AllianceBossRankCtrl
