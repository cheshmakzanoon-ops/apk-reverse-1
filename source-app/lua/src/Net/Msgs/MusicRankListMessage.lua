local MusicRankListMessage = BaseClass("MusicRankListMessage", SFSBaseMessage)
local base = SFSBaseMessage

function MusicRankListMessage:OnCreate(activityId, songId)
  base.OnCreate(self)
  self.sfsObj:PutInt("activityId", activityId)
  self.sfsObj:PutInt("songId", songId)
end

function MusicRankListMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.ActCrazyRockDataManager:OnRecRankData(t)
  end
end

return MusicRankListMessage
