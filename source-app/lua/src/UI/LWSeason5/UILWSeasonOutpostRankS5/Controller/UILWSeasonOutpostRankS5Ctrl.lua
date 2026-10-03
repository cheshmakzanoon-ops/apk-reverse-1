local UILWSeasonOutpostRankS5Ctrl = BaseClass("UILWSeasonOutpostRankS5Ctrl", UIBaseCtrl)

function UILWSeasonOutpostRankS5Ctrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UILWSeasonOutpostRankS5)
end

return UILWSeasonOutpostRankS5Ctrl
