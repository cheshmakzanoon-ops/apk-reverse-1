local SeasonPhotoCommentUpdateMessage = BaseClass("SeasonPhotoCommentUpdateMessage", SFSBaseMessage)
local base = SFSBaseMessage

function SeasonPhotoCommentUpdateMessage:OnCreate(targetSeason, targetAllianceId, message)
  base.OnCreate(self)
  self.sfsObj:PutInt("targetSeason", targetSeason)
  self.sfsObj:PutUtfString("targetAllianceId", targetAllianceId)
  self.sfsObj:PutUtfString("message", message)
end

local function __SortComment(a, b)
  return a.refreshTime > b.refreshTime
end

function SeasonPhotoCommentUpdateMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
    return
  end
  if not t.photoCommentInfo then
    return
  end
  UIUtil.ShowTipsId("season_alliance_photo_tips_25")
  local id = DataCenter.SeasonPhotoManager:GetPhotoId(t.targetSeason, t.targetAllianceId)
  if t.userSeasonSettleRecordInfo then
    local SeasonPhotoSettleRecordInfo = require("DataCenter.SeasonPhoto.SeasonPhotoSettleRecordInfo")
    local settleData = SeasonPhotoSettleRecordInfo.New()
    settleData:UpdateData(t.userSeasonSettleRecordInfo)
    DataCenter.SeasonPhotoManager.userSettleRecordDic[settleData.id] = settleData
  end
  local list = DataCenter.SeasonPhotoManager.commentDic[id]
  if list then
    for i, v in ipairs(list) do
      if v.uid == t.photoCommentInfo.uid then
        v:UpdateData(t.photoCommentInfo)
        EventManager:GetInstance():Broadcast(EventId.SeasonPhotoCommentView, id)
        return
      end
    end
  else
    list = {}
    DataCenter.SeasonPhotoManager.commentDic[id] = list
  end
  local SeasonPhotoCommentInfo = require("DataCenter.SeasonPhoto.SeasonPhotoCommentInfo")
  local data = SeasonPhotoCommentInfo.New()
  data:UpdateData(t.photoCommentInfo)
  table.insert(list, data)
  table.sort(list, __SortComment)
  EventManager:GetInstance():Broadcast(EventId.SeasonPhotoCommentView, id)
  SFSNetwork.SendMessage(MsgDefines.ViewSeasonPhotoTasklist)
end

return SeasonPhotoCommentUpdateMessage
