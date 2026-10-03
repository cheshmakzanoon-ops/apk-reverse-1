local AllianceStarThumbsUpNewMessage = BaseClass("AllianceStarThumbsUpNewMessage", SFSBaseMessage)
local base = SFSBaseMessage

function AllianceStarThumbsUpNewMessage:OnCreate(configId, targetUid, thumbsIndexId, type)
  base.OnCreate(self)
  self.sfsObj:PutInt("configId", configId)
  self.sfsObj:PutUtfString("targetUid", targetUid)
  self.sfsObj:PutInt("thumbsIndexId", thumbsIndexId)
  self.sfsObj:PutInt("type", type)
end

function AllianceStarThumbsUpNewMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  elseif t.type and t.type == 1 then
    DataCenter.AllianceStarManager:OnAllianceStarThumbsUpNew(t)
  end
end

return AllianceStarThumbsUpNewMessage
