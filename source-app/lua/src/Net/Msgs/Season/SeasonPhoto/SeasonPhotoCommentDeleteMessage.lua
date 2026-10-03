local SeasonPhotoCommentDeleteMessage = BaseClass("SeasonPhotoCommentDeleteMessage", SFSBaseMessage)
local base = SFSBaseMessage

function SeasonPhotoCommentDeleteMessage:OnCreate(targetSeason, targetAllianceId, targetUid)
  base.OnCreate(self)
  self.sfsObj:PutInt("targetSeason", targetSeason)
  self.sfsObj:PutUtfString("targetAllianceId", targetAllianceId)
  self.sfsObj:PutUtfString("targetUid", targetUid)
end

function SeasonPhotoCommentDeleteMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
    return
  end
  UIUtil.ShowTipsId("season_alliance_photo_tips_26")
  local id = DataCenter.SeasonPhotoManager:GetPhotoId(t.targetSeason, t.targetAllianceId)
  local list = DataCenter.SeasonPhotoManager.commentDic[id]
  if list then
    for i, v in ipairs(list) do
      if v.uid == t.targetUid then
        table.remove(list, i)
        break
      end
    end
  end
  EventManager:GetInstance():Broadcast(EventId.SeasonPhotoCommentView, id)
end

return SeasonPhotoCommentDeleteMessage
