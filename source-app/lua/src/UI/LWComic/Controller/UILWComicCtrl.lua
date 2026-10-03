local UILWComicCtrl = BaseClass("UILWComicCtrl", UIBaseCtrl)

function UILWComicCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UILWComic, {anim = false})
end

return UILWComicCtrl
