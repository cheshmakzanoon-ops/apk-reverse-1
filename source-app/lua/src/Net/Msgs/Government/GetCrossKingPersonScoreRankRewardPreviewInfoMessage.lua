local GetCrossKingPersonScoreRankRewardPreviewInfoMessage = BaseClass("GetCrossKingPersonScoreRankRewardPreviewInfoMessage", SFSBaseMessage)
local base = SFSBaseMessage

function GetCrossKingPersonScoreRankRewardPreviewInfoMessage:OnCreate()
  base.OnCreate(self)
end

function GetCrossKingPersonScoreRankRewardPreviewInfoMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
    return
  end
  DataCenter.ZoneWarManager:SetPersonScoreRankRewardPreviewInfo(t)
end

return GetCrossKingPersonScoreRankRewardPreviewInfoMessage
