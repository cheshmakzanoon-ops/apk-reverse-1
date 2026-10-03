local LWSeasonHeroListCtrl = BaseClass("LWSeasonHeroListCtrl", UIBaseCtrl)

function LWSeasonHeroListCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UILWSeasonHeroList)
end

return LWSeasonHeroListCtrl
