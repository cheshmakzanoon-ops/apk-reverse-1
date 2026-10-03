local ActEasterEggCommentData = BaseClass("ActEasterEggCommentData")

function ActEasterEggCommentData:__init()
  self:AddListener()
  self.uuid = ""
  self.uid = 0
  self.opType = 0
  self.thumbsUp = 0
  self.anonymousName = ""
  self.anonymousHeadIndex = 0
  self.anonymousState = false
  self.eggUuid = ""
  self.eggContent = ""
  self.otherUid = ""
  self.createTime = 0
  self.curAnonymousName = ""
  self.curAnonymousAvatarIndex = 0
  self.curAnonymousState = false
  self.playerInfo = nil
end

function ActEasterEggCommentData:__delete()
  self:RemoveListener()
  self.uuid = nil
  self.uid = nil
  self.opType = nil
  self.thumbsUp = nil
  self.anonymousName = nil
  self.anonymousHeadIndex = nil
  self.anonymousState = nil
  self.eggUuid = nil
  self.eggContent = nil
  self.otherUid = nil
  self.createTime = nil
  self.curAnonymousName = nil
  self.curAnonymousAvatarIndex = nil
  self.curAnonymousState = nil
  self.playerInfo = nil
end

function ActEasterEggCommentData:AddListener()
end

function ActEasterEggCommentData:RemoveListener()
end

function ActEasterEggCommentData:ParseCommentData(commentInfo)
  self:AddListener()
  self.uuid = commentInfo.uuid or ""
  self.uid = commentInfo.uid
  self.opType = commentInfo.opType
  self.thumbsUp = commentInfo.thumbsUp
  local anonymousHead = commentInfo.anonymousHead or ""
  local anonymousInfo = string.split(anonymousHead, ";")
  self.anonymousName = anonymousInfo[1]
  self.anonymousHeadIndex = tonumber(anonymousInfo[2])
  self.anonymousState = tonumber(anonymousInfo[3]) == 0
  self.eggUuid = commentInfo.eggUuid
  self.content = commentInfo.eggContent
  self.otherUid = commentInfo.otherUid
  self.createTime = commentInfo.createTime
  local curAnonymousHead = commentInfo.curAnonymousHead or ""
  local curAnonymousInfo = string.split(curAnonymousHead, ";")
  self.curAnonymousName = curAnonymousInfo[1]
  self.curAnonymousAvatarIndex = curAnonymousInfo[2]
  self.curAnonymousState = tonumber(curAnonymousInfo[3]) == 0
  self.playerInfo = commentInfo.playerInfo
end

function ActEasterEggCommentData:GetId()
  return self.uuid
end

return ActEasterEggCommentData
