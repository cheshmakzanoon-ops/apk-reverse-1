local UIAlLeaderVoteCtrl = BaseClass("UIAlLeaderVoteCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIAlLeaderVote)
end

UIAlLeaderVoteCtrl.CloseSelf = CloseSelf
return UIAlLeaderVoteCtrl
