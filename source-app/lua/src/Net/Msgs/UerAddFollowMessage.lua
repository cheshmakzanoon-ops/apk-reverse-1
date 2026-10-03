local UerAddFollowMessage = BaseClass("UerAddFollowMessage", SFSBaseMessage)
local base = SFSBaseMessage

function UerAddFollowMessage:OnCreate(param)
  base.OnCreate(self)
  if param.targetUid then
    self.sfsObj:PutUtfString("targetUid", param.targetUid)
  end
  if param.itemId then
    self.sfsObj:PutInt("itemId", param.itemId)
  end
  if param.num then
    self.sfsObj:PutLong("num", param.num)
  end
  self.sfsObj:PutUtfString("context", param.context or "")
  self.sfsObj:PutInt("isAnonymous", param.isAnonymous and 1 or 0)
  self.sfsObj:PutLong("returnGiftUuid", param.returnGiftUuid or 0)
  self.sfsObj:PutInt("activityId", param.activityId or 0)
end

function UerAddFollowMessage:HandleMessage(t)
end

return UerAddFollowMessage
