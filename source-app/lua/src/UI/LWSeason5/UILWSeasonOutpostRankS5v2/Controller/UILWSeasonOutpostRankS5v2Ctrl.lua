local UILWSeasonOutpostRankS5v2Ctrl = BaseClass("UILWSeasonOutpostRankS5v2Ctrl", UIBaseCtrl)

function UILWSeasonOutpostRankS5v2Ctrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UILWSeasonOutpostRankS5)
end

return UILWSeasonOutpostRankS5v2Ctrl
