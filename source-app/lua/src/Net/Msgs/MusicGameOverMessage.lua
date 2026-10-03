local MusicGameOverMessage = BaseClass("MusicGameOverMessage", SFSBaseMessage)
local base = SFSBaseMessage

function MusicGameOverMessage:OnCreate(param)
  base.OnCreate(self)
  local activityId = param.activityId
  local songId = param.songId
  local actions = param.actions
  local score = param.score
  self.sfsObj:PutInt("activityId", activityId)
  self.sfsObj:PutInt("songId", songId)
  self.sfsObj:PutInt("score", score)
  local actionMsgList = SFSArray.New()
  if actions then
    for _, v in ipairs(actions) do
      actionMsgList:AddUtfString(v)
    end
  end
  self.sfsObj:PutSFSArray("actions", actionMsgList)
end

function MusicGameOverMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.ActCrazyRockDataManager:OnRecSettleData(t)
    EventManager:GetInstance():Broadcast(EventId.SuccessOverMusicGame)
  end
end

return MusicGameOverMessage
