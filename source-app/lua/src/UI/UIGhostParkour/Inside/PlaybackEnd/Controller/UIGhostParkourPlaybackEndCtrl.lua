local UIGhostParkourPlaybackEndCtrl = BaseClass("UIGhostParkourPlaybackEndCtrl", UIBaseCtrl)

function UIGhostParkourPlaybackEndCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIGhostParkourPlaybackEnd, {anim = false})
end

return UIGhostParkourPlaybackEndCtrl
