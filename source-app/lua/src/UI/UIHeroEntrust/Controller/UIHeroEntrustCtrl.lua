local UIHeroEntrustCtrl = BaseClass("UIHeroEntrustCtrl", UIBaseCtrl)

function UIHeroEntrustCtrl:CloseSelf()
  UIManager.Instance:DestroyWindow(UIWindowNames.UIHeroEntrust)
end

return UIHeroEntrustCtrl
