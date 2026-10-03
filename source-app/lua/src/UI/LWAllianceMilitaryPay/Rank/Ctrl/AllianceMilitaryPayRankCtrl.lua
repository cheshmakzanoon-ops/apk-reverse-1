local AllianceMilitaryPayRankCtrl = BaseClass("AllianceMilitaryPayRankCtrl", UIBaseCtrl)

function AllianceMilitaryPayRankCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.AllianceMilitaryPayRank)
end

return AllianceMilitaryPayRankCtrl
