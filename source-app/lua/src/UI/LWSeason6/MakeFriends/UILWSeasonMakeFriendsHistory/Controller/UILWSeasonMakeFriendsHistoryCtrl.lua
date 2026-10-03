local UILWSeasonMakeFriendsHistoryCtrl = BaseClass("UILWSeasonMakeFriendsHistoryCtrl", UIBaseCtrl)

function UILWSeasonMakeFriendsHistoryCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UILWSeasonMakeFriendsHistory)
end

return UILWSeasonMakeFriendsHistoryCtrl
