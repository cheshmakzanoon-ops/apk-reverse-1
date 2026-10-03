local UIActCrazyRockRankCtrl = BaseClass("UIActCrazyRockRankCtrl", UIBaseCtrl)

function UIActCrazyRockRankCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIActCrazyRockRank)
end

function UIActCrazyRockRankCtrl:RequestRankData(activityId, songId)
  SFSNetwork.SendMessage(MsgDefines.MusicRankList, activityId, songId)
end

return UIActCrazyRockRankCtrl
