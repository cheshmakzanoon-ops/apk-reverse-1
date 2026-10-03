local LWUIVotePlayerListCtrl = BaseClass("LWUISoldierNumTipsCtrl", UIBaseCtrl)

function LWUIVotePlayerListCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.LWUIVotePlayerList)
end

return LWUIVotePlayerListCtrl
