local UILWSeasonMilitaryRoyalCtrl = BaseClass("UILWSeasonMilitaryRoyalCtrl", UIBaseCtrl)

function UILWSeasonMilitaryRoyalCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UILWSeasonMilitaryRoyal)
end

function UILWSeasonMilitaryRoyalCtrl:GetRankData(rankData, auto)
  if rankData == nil then
    return nil
  end
  local data = {}
  data.Uid = rankData.Uid
  data.Rank = rankData.Rank
  data.IsSelf = false
  data.IsAlliance = false
  data.ExtraData = {}
  data.ExtraData.Auto = auto
  if auto then
    data.ExtraData.Score = string.GetFormattedSeparatorNum(checknumber(rankData.MilitaryNum))
    data.ExtraData.Date = UITimeManager:GetInstance():GetTimeToMD(Mathf.Floor(rankData.RefreshTime / 1000))
  else
    data.ExtraData.Time = UITimeManager:GetInstance():TimeStampToTimeForServer(rankData.RefreshTime)
  end
  if rankData.UserInfo ~= nil then
    data.Pic = rankData.UserInfo.pic
    data.PicVer = rankData.UserInfo.picVer
    data.HeadFrame = rankData.UserInfo:GetHeadBgImg()
    data.Name = string.format("#%s %s", rankData.UserInfo.srcServer, rankData.UserInfo:GetShowName())
  end
  return data
end

return UILWSeasonMilitaryRoyalCtrl
