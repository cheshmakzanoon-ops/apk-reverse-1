local ActEasterEggTranslateData = BaseClass("ActEasterEggTranslateData")
local M = ActEasterEggTranslateData

function M:__init()
  self.index = 0
  self.eggUuid = ""
  self.sourceMsg = ""
  self.sourceLang = ""
  self.translateMsg = ""
  self.translatedLang = ""
  self.translateState = 0
  self.canRefreshTranslate = 0
  self.translateType = 0
end

function M:__delete()
  self.index = 0
  self.eggUuid = ""
  self.sourceMsg = ""
  self.sourceLang = ""
  self.translateMsg = ""
  self.translatedLang = ""
  self.translateState = 0
  self.canRefreshTranslate = 0
  self.translateType = 0
end

function M:SetIndex(index)
  self.index = index
end

function M:GetIndex()
  return self.index
end

function M:SetEggUuid(eggUuid)
  self.eggUuid = eggUuid
end

function M:GetEggUuid()
  return self.eggUuid
end

function M:SetSourceMsg(sourceMsg)
  self.sourceMsg = sourceMsg
end

function M:GetSourceMsg()
  return self.sourceMsg
end

function M:SetSourceLang(sourceLang)
  self.sourceLang = sourceLang
end

function M:GetSourceLang()
  return self.sourceLang
end

function M:SetTranslateMsg(translateMsg)
  self.translateMsg = translateMsg
end

function M:GetTranslateMsg()
  return self.translateMsg
end

function M:SetTranslatedLang(translatedLang)
  self.translatedLang = translatedLang
end

function M:GetTranslatedLang()
  return self.translatedLang
end

function M:SetTranslateState(translateState)
  self.translateState = translateState
end

function M:GetTranslateState()
  return self.translateState
end

function M:SetCanRefreshTranslate(canRefreshTranslate)
  self.canRefreshTranslate = canRefreshTranslate
end

function M:GetCanRefreshTranslate()
  return self.canRefreshTranslate
end

function M:SetTranslateType(translateType)
  self.translateType = translateType
end

function M:GetTranslateType()
  return self.translateType
end

return M
