local ActEasterEggData = BaseClass("ActEasterEggData")

function ActEasterEggData:__init()
  self:AddListener()
  self.eggUuid = ""
  self.uid = 0
  self.thumbsUp = 0
  self.commentThumbsUp = 0
  self.lang = ""
  self.country = ""
  self.anonymousStr = ""
  self.anonymousHeadIndex = ""
  self.anonymousName = ""
  self.anonymousState = false
  self.content = ""
  self.createTime = 0
  self.commentNum = 0
  self.lastViewCommentNum = 0
  self.reportNum = 0
  self.eggType = 0
  self.totalScore = 0
  self.eggState = 0
  self.optionA = ""
  self.optionB = ""
  self.answerANum = 0
  self.answerBNum = 0
  self.posterInfo = {}
  self.curAnonymousStr = ""
  self.curAnonymousHeadIndex = 0
  self.curAnonymousName = ""
  self.curAnonymousState = false
  self.praiseCommentArr = {}
  self.praise = nil
  self.praiseSeqArr = {}
  self.eggOwnerAnswer = 0
  self.answer = 0
  self.pickUpNum = 0
end

function ActEasterEggData:__delete()
  self:RemoveListener()
  self.eggUuid = nil
  self.uid = nil
  self.thumbsUp = nil
  self.commentThumbsUp = nil
  self.lang = nil
  self.country = nil
  self.anonymousStr = nil
  self.anonymousHeadIndex = nil
  self.anonymousName = nil
  self.anonymousState = nil
  self.content = nil
  self.createTime = nil
  self.commentNum = nil
  self.lastViewCommentNum = nil
  self.reportNum = nil
  self.eggType = nil
  self.totalScore = nil
  self.eggState = nil
  self.optionA = nil
  self.optionB = nil
  self.answerANum = nil
  self.answerBNum = nil
  self.posterInfo = nil
  self.curAnonymousStr = nil
  self.curAnonymousHeadIndex = nil
  self.curAnonymousName = nil
  self.curAnonymousState = nil
  self.praiseCommentArr = nil
  self.praise = nil
  self.praiseSeqArr = nil
  self.eggOwnerAnswer = nil
  self.answer = nil
  self.pickUpNum = nil
end

function ActEasterEggData:AddListener()
end

function ActEasterEggData:RemoveListener()
end

function ActEasterEggData:ParseEggInfo(eggInfo)
  self.eggUuid = eggInfo.eggUuid
  self.uid = eggInfo.uid
  self.thumbsUp = eggInfo.thumbsUp
  self.commentThumbsUp = eggInfo.commentThumbsUp
  self.lang = eggInfo.lang
  self.country = eggInfo.country
  self.anonymousStr = eggInfo.anonymousHead
  local anonymousInfo = string.split(self.anonymousStr, ";")
  self.anonymousHeadIndex = tonumber(anonymousInfo[2])
  self.anonymousName = anonymousInfo[1]
  self.anonymousState = tonumber(anonymousInfo[3]) == 0
  self.content = eggInfo.content
  self.createTime = eggInfo.createTime
  self.commentNum = eggInfo.commentNum
  self.lastViewCommentNum = eggInfo.lastViewCommentNum
  self.reportNum = eggInfo.reportNum
  self.eggType = eggInfo.eggType
  self.totalScore = eggInfo.totalScore
  self.eggState = eggInfo.eggState
  self.optionA = eggInfo.optionA
  self.optionB = eggInfo.optionB
  self.answerANum = eggInfo.answerA
  self.answerBNum = eggInfo.answerB
  self.posterInfo = eggInfo.playerInfo
  self.curAnonymousStr = eggInfo.curAnonymousHead
  if not string.IsNullOrEmpty(self.curAnonymousStr) then
    local curAnonymousInfo = string.split(self.curAnonymousStr, ";")
    self.curAnonymousHeadIndex = tonumber(curAnonymousInfo[2] or 0)
    self.curAnonymousName = curAnonymousInfo[1]
    self.curAnonymousState = tonumber(curAnonymousInfo[3]) == 0
  end
  self.praiseCommentArr = eggInfo.praiseCommentArr or {}
  self.praise = eggInfo.praise or 0
  self.praiseSeqArr = eggInfo.praiseSeqArr or {}
  self.eggOwnerAnswer = tonumber(eggInfo.eggOwnerAnswer) or 0
  self.answer = tonumber(eggInfo.answer) or 0
  self.pickUpNum = eggInfo.pickUpNum
end

function ActEasterEggData:GetId()
  return self.eggUuid
end

function ActEasterEggData:GetPosterInfo()
  return self.posterInfo
end

function ActEasterEggData:GetCurAnonymousHeadIndex()
  return self.curAnonymousHeadIndex
end

function ActEasterEggData:GetEggType()
  return self.eggType
end

function ActEasterEggData:GetPraiseSeqArr()
  return self.praiseSeqArr
end

function ActEasterEggData:GetPraiseCommentArr()
  return self.praiseCommentArr
end

function ActEasterEggData:GetCurAnonymousName()
  return self.curAnonymousName
end

function ActEasterEggData:GetPoserVoteRes()
  return self.eggOwnerAnswer
end

function ActEasterEggData:GetMyVoteRes()
  return self.answer
end

function ActEasterEggData:GetPostContent()
  return self.content
end

function ActEasterEggData:GetPostLang()
  return self.lang
end

function ActEasterEggData:GetCreateTime()
  return self.createTime
end

function ActEasterEggData:SetThumbsUp(nums)
  self.thumbsUp = nums
end

function ActEasterEggData:GetThumbsUp()
  return self.thumbsUp
end

function ActEasterEggData:SetPraise(state)
  self.praise = state
end

function ActEasterEggData:GetPraise()
  return self.praise
end

function ActEasterEggData:GetPosterUid()
  return self.uid
end

function ActEasterEggData:UpdateVoteInfo(message)
  if message == nil then
    return
  end
  if message.eggUuid == nil or message.eggUuid ~= self.eggUuid then
    return
  end
  self.answer = message.answer
  self.answerANum = message.answerA
  self.answerBNum = message.answerB
end

function ActEasterEggData:GetPosterAnswer()
  return self.eggOwnerAnswer
end

function ActEasterEggData:GetPlayerSelfAnswer()
  return self.answer
end

function ActEasterEggData:GetCurAnonymousStr()
  return self.curAnonymousStr
end

return ActEasterEggData
