local UILWFriendsCircleFolloweeCtrl = BaseClass("UILWFriendsCircleFolloweeCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UILWFriendsCircleFollowee)
end

UILWFriendsCircleFolloweeCtrl.CloseSelf = CloseSelf
return UILWFriendsCircleFolloweeCtrl
