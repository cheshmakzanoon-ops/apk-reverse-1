local NewsCenterData = BaseClass("NewsCenterData")

function NewsCenterData:__init()
  self:Reset()
end

function NewsCenterData:__delete()
  self:Reset()
end

function NewsCenterData:Reset()
  self.type = nil
  self.priority = nil
  self.title = nil
  self.urlPic = nil
  self.urlWiki = nil
  self.likeCount = nil
  self.effectTime = nil
  self.overTime = nil
  self.uuid = nil
  self.translateMsg = nil
  self.translateState = nil
  self.translatedLang = nil
  self.canRefreshTranslate = nil
  self.isLike = nil
end

function NewsCenterData:onParseServerData(serverData, wikiInfo)
  self.priority = serverData.priority
  self.title = serverData.title
  self.urlPic = serverData.urlPic
  self.urlWiki = serverData.urlWiki
  self.likeCount = serverData.likeCount or 0
  self.effectTime = serverData.effectTime
  self.overTime = serverData.overTime
  self.uuid = serverData.uuid
  self.type = serverData.type
  self.isLike = serverData.isLike
  local redDotId = DataCenter.LWNewsCenterManager:GetRedDotId(self.type)
  self.isNew = redDotId < serverData.uuid
  self.wikiChain = serverData.wikiChain
end

function NewsCenterData:UpLikeCount()
  self.likeCount = self.likeCount and self.likeCount + 1 or 1
  self.isLike = true
end

function NewsCenterData:UpdateCountByWeb(count)
  if not count then
    return
  end
  self.likeCount = count
  self.isLike = true
end

function NewsCenterData:UpdateCount(count)
  if count then
    self.likeCount = count
    EventManager:GetInstance():Broadcast(ChatEventEnum.CHAT_NEWSCENTER_UPLIKECOUNT, self)
  end
end

function NewsCenterData:UpdateWikiInfo(info)
  if info and info.likeCount then
    self.likeCount = info.likeCount
    self.isLike = info.isLike
    EventManager:GetInstance():Broadcast(ChatEventEnum.CHAT_NEWSCENTER_UPLIKECOUNT, self)
  end
end

function NewsCenterData:IsCanShow()
  return true
end

function NewsCenterData:SetTranslateMsg(str)
  self.translateMsg = str
end

function NewsCenterData:SetTranslateState(state)
  self.translateState = state
end

function NewsCenterData:GetTranslateState()
  return self.translateState
end

function NewsCenterData:GetTranslateType()
  return self.translateType
end

function NewsCenterData:SetTranslateType(type)
  self.translateType = type
end

function NewsCenterData:SetTranslatedLang(translatedLang)
  self.translatedLang = translatedLang
end

function NewsCenterData:GetTranslateMsg()
  return self.translateMsg
end

function NewsCenterData:IsTranslating()
  return self.translateState == 1
end

function NewsCenterData:SetCanRefreshTranslate(canRefreshTranslate)
  self.canRefreshTranslate = canRefreshTranslate
end

function NewsCenterData:GetCanRefreshTranslate()
  return self.canRefreshTranslate
end

function NewsCenterData:SetRead()
  self.isNew = false
end

return NewsCenterData
