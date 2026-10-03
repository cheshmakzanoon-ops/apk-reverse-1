local SeasonPhotoSetOtherModifyMessage = BaseClass("SeasonPhotoSetOtherModifyMessage", SFSBaseMessage)
local base = SFSBaseMessage

function SeasonPhotoSetOtherModifyMessage:OnCreate(targetSeason, targetAllianceId, setModify)
  base.OnCreate(self)
  self.sfsObj:PutInt("targetSeason", targetSeason)
  self.sfsObj:PutUtfString("targetAllianceId", targetAllianceId)
  self.sfsObj:PutBool("setModify", setModify)
end

function SeasonPhotoSetOtherModifyMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
    return
  end
  local photoInfo = DataCenter.SeasonPhotoManager:GetSeasonPhotoData(t.targetSeason, t.targetAllianceId)
  local selfMember = photoInfo and photoInfo:GetMemberSelf()
  if selfMember then
    selfMember.otherModify = t.modify
    EventManager:GetInstance():Broadcast(EventId.SeasonPhotoSetOtherModify, photoInfo.id)
  end
end

return SeasonPhotoSetOtherModifyMessage
