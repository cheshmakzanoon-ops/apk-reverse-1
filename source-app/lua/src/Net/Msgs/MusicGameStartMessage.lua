local MusicGameStartMessage = BaseClass("MusicGameStartMessage", SFSBaseMessage)
local base = SFSBaseMessage

function MusicGameStartMessage:OnCreate(activityId)
  base.OnCreate(self)
  self.sfsObj:PutInt("activityId", activityId)
end

function MusicGameStartMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    local activityId = t.activityId
    if activityId then
      local songId = t.songId
      local params = {}
      params.activityId = activityId
      params.songId = songId
      EventManager:GetInstance():Broadcast(EventId.StartMusicGamePlay, params)
    end
  end
end

return MusicGameStartMessage
