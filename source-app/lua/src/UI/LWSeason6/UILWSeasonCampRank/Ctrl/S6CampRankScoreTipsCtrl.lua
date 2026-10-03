local S6CampRankScoreTipsCtrl = BaseClass("S6CampRankScoreTipsCtrl", UIBaseCtrl)

function S6CampRankScoreTipsCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.S6CampRankScoreTips)
end

return S6CampRankScoreTipsCtrl
