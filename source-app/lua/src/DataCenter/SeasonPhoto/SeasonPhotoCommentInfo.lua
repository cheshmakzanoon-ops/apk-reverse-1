local SeasonPhotoCommentInfo = BaseClass("SeasonPhotoCommentInfo")

function SeasonPhotoCommentInfo:__init()
  self.uid = ""
  self.uuid = 0
  self.name = ""
  self.picVer = 0
  self.pic = ""
  self.firstRecordTime = 0
  self.refreshTime = 0
  self.message = ""
  self.thumbsUp = nil
end

function SeasonPhotoCommentInfo:__delete()
  self.uid = nil
  self.uuid = nil
  self.name = nil
  self.picVer = nil
  self.pic = nil
  self.firstRecordTime = nil
  self.refreshTime = nil
  self.message = nil
  self.thumbsUp = nil
end

function SeasonPhotoCommentInfo:UpdateData(message)
  if message == nil then
    return
  end
  if message.uid ~= nil then
    self.uid = message.uid
  end
  if message.uuid ~= nil then
    self.uuid = message.uuid
  end
  if message.name ~= nil then
    self.name = message.name
  end
  if message.picVer ~= nil then
    self.picVer = message.picVer
  end
  if message.pic ~= nil then
    self.pic = message.pic
  end
  if message.firstRecordTime ~= nil then
    self.firstRecordTime = message.firstRecordTime
  end
  if message.refreshTime ~= nil then
    self.refreshTime = message.refreshTime
  end
  if message.message ~= nil then
    self.message = message.message
  end
end

function SeasonPhotoCommentInfo:UpdateThumbsUp(thumbsUp)
  if thumbsUp == nil then
    return
  end
  self.thumbsUp = thumbsUp
end

function SeasonPhotoCommentInfo:IsMyComment()
  return self.uid == LuaEntry.Player.uid
end

function SeasonPhotoCommentInfo:GetThumbsUpArray()
  return self.thumbsUp and self.thumbsUp.thumbsArray
end

function SeasonPhotoCommentInfo:HasThumbsUp(thumbsType)
  local thumbsArray = self:GetThumbsUpArray()
  if not thumbsArray or not thumbsType then
    return false
  end
  for k, v in ipairs(thumbsArray) do
    if v.thumbsType == thumbsType then
      return v.hasThumbs
    end
  end
  return false
end

function SeasonPhotoCommentInfo:GetThumbsUpCount(thumbsType)
  local thumbsArray = self:GetThumbsUpArray()
  if not thumbsArray then
    return 0
  end
  for k, v in ipairs(thumbsArray) do
    if v.thumbsType == thumbsType then
      return v.thumbsCount or 0
    end
  end
  return 0
end

return SeasonPhotoCommentInfo
