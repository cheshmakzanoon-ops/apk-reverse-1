local SeasonPhotoCommentThumbsUpMessage = BaseClass("SeasonPhotoCommentThumbsUpMessage", SFSBaseMessage)
local base = SFSBaseMessage

function SeasonPhotoCommentThumbsUpMessage:OnCreate(param)
  base.OnCreate(self)
  self.sfsObj:PutInt("targetSeason", param.targetSeason)
  self.sfsObj:PutUtfString("targetAllianceId", param.targetAllianceId)
  self.sfsObj:PutLong("targetUuid", param.targetUuid)
  self.sfsObj:PutUtfString("targetUid", param.targetUid)
  self.sfsObj:PutInt("thumbsType", param.thumbsType or 1)
  self.sfsObj:PutUtfString("content", param.content or "")
  self.sfsObj:PutUtfString("extParam", param.extParam or "")
end

function SeasonPhotoCommentThumbsUpMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
    return
  end
  if t.success == false then
    return
  end
  local id = DataCenter.SeasonPhotoManager:GetPhotoId(t.targetSeason, t.targetAllianceId)
  local list = DataCenter.SeasonPhotoManager.commentDic[id]
  local thumbsUpArr = t.thumbsUpArr
  if not list or not thumbsUpArr then
    return
  end
  local thumbsUpDic = {}
  for i, v in ipairs(thumbsUpArr) do
    thumbsUpDic[v.targetUuid] = v
  end
  for i, v in ipairs(list) do
    v:UpdateThumbsUp(v.uuid and thumbsUpDic[v.uuid])
    EventManager:GetInstance():Broadcast(EventId.SeasonPhotoCommentChange, v)
  end
  if t.thumbsUpObj then
    InteractiveUtil.OnThumbsUpMessage(t.thumbsUpObj)
  end
end

function SeasonPhotoCommentThumbsUpMessage:GetTestData(param)
  local t = {}
  t.targetSeason = param.targetSeason or 10001
  t.targetAllianceId = param.targetAllianceId or "alliance123"
  t.targetUuid = param.targetUuid or 1234567890
  t.targetUid = param.targetUid or "user123"
  t.thumbsType = param.thumbsType or 1
  t.content = param.content
  t.extParam = param.extParam
  local id = DataCenter.SeasonPhotoManager:GetPhotoId(t.targetSeason, t.targetAllianceId)
  local list = DataCenter.SeasonPhotoManager.commentDic[id]
  if list then
    local thumbsUpArr = {}
    t.thumbsUpArr = thumbsUpArr
    for i, v in ipairs(list) do
      if v.thumbsUp then
        thumbsUpArr[i] = v.thumbsUp
      else
        thumbsUpArr[i] = {
          targetUuid = v.uuid,
          thumbsArray = {}
        }
      end
      if v.uuid == t.targetUuid and v.uid == t.targetUid then
        local array = thumbsUpArr[i].thumbsArray
        local find = false
        for ii, vv in ipairs(array) do
          if vv.thumbsType == t.thumbsType then
            if vv.hasThumbs then
              vv.thumbsCount = (vv.thumbsCount or 0) - 1
              vv.hasThumbs = false
            else
              vv.thumbsCount = (vv.thumbsCount or 0) + 1
              vv.hasThumbs = true
            end
            find = true
            break
          end
        end
        if not find then
          array[#array + 1] = {
            thumbsType = t.thumbsType,
            thumbsCount = 1,
            hasThumbs = true
          }
        end
      end
    end
  end
  return t
end

return SeasonPhotoCommentThumbsUpMessage
