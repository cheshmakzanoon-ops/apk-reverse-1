local MusicSetOffsetMessage = BaseClass("MusicSetOffsetMessage", SFSBaseMessage)
local base = SFSBaseMessage

function MusicSetOffsetMessage:OnCreate(activityId, offset)
  base.OnCreate(self)
  self.sfsObj:PutInt("activityId", activityId)
  self.sfsObj:PutInt("offset", offset)
end

function MusicSetOffsetMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  elseif t.activityId and t.offset then
    local activityId = toInt(t.activityId)
    local actData = DataCenter.ActCrazyRockDataManager:GetActDataById(activityId)
    if actData and t.offset then
      actData:UpdateOffset(toInt(t.offset))
      EventManager:GetInstance():Broadcast(EventId.MusicGameSetOffsetSuccess)
      UIUtil.ShowTipsId("activity_99179_tips_1")
    end
  end
end

return MusicSetOffsetMessage
