local UILWPlayerThumbsUpHistoryCtrl = BaseClass("UILWPlayerThumbsUpHistoryCtrl", UIBaseCtrl)

function UILWPlayerThumbsUpHistoryCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UILWPlayerThumbsUpHistory)
end

return UILWPlayerThumbsUpHistoryCtrl
