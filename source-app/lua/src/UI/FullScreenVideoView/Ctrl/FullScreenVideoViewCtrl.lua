local FullScreenVideoViewCtrl = BaseClass("FullScreenVideoViewCtrl", UIBaseCtrl)

function FullScreenVideoViewCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.FullScreenVideoView)
end

function FullScreenVideoViewCtrl:OnCustomKeyCodeEscape()
  local window = UIManager:GetInstance():GetWindow(UIWindowNames.FullScreenVideoView)
  if window and window.View and window.View.onVideoCloseCallback then
    window.View.onVideoCloseCallback(true)
  end
  self:CloseSelf()
end

return FullScreenVideoViewCtrl
