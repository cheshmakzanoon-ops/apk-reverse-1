local CountryMarkData = BaseClass("CountryMarkData")

local function __init(self)
  self.isCountryMark = true
  self.uuid = 0
  self.uid = ""
  self.oriServerId = 0
  self.server = 0
  self.worldId = 0
  self.type = 0
  self.pos = 0
  self.pointInfo = ""
  self.createTime = 0
  self.startTime = 0
  self.notice = false
  self.operateType = 0
  self.translateMsg = ""
  self.translateLanguage = ""
  self.isTranslating = false
  self.tanslateFinish = 0
  self.TranslateManager = nil
end

local function ParseData(self, msg)
  if not msg then
    return
  end
  if msg.uuid then
    self.uuid = msg.uuid
  end
  if msg.uid then
    self.uid = msg.uid
  end
  if msg.oriServerId then
    self.oriServerId = msg.oriServerId
  end
  if msg.serverId then
    self.server = msg.serverId
  end
  if msg.worldId then
    self.worldId = msg.worldId
  end
  if msg.markType then
    self.type = msg.markType
  end
  if msg.point then
    self.pos = msg.point
  end
  if msg.pointInfo ~= nil then
    self.pointInfo = msg.pointInfo
  end
  self.name = self.pointInfo
  if msg.markTime then
    self.createTime = msg.markTime
  end
  if msg.planTime then
    self.startTime = msg.planTime
  end
  if msg.notice ~= nil then
    self.notice = msg.notice
  end
  if msg.operateType then
    self.operateType = msg.operateType
  end
end

local function SetTranslationMsg(self, translateMsg)
  self.translateMsg = translateMsg
end

local function GetTranslationMsg(self)
  return self.translateMsg
end

local function SetIsTranslating(self, translatingFlag)
  self.isTranslating = translatingFlag
end

local function GetIsTranslating(self)
  return self.isTranslating
end

local function SetTranslateLanguage(self, language)
  self.language = language
end

local function SetTranslateFinishState(self, state)
  self.tanslateFinish = state
end

local function GetTranslateFinishState(self)
  return self.tanslateFinish
end

local function DoTranslate(self)
  if self.TranslateManager then
    self.TranslateManager:Translate(self, self.TranslateManager.TranslateEnum.AllianceMark)
  end
end

local function GetMessage(self)
  return self.name
end

local function GetLanguageName(self)
  return self.language
end

local function SetLanguageName(self, language)
  self.language = language
end

local function SetTranslateHandler(self, translateHandler)
  self.TranslateManager = translateHandler
end

function CountryMarkData:GetPointIndex()
  return self.pos // 10
end

CountryMarkData.__init = __init
CountryMarkData.ParseData = ParseData
CountryMarkData.SetTranslationMsg = SetTranslationMsg
CountryMarkData.GetTranslationMsg = GetTranslationMsg
CountryMarkData.SetIsTranslating = SetIsTranslating
CountryMarkData.GetIsTranslating = GetIsTranslating
CountryMarkData.SetTranslateLanguage = SetTranslateLanguage
CountryMarkData.SetTranslateFinishState = SetTranslateFinishState
CountryMarkData.GetTranslateFinishState = GetTranslateFinishState
CountryMarkData.DoTranslate = DoTranslate
CountryMarkData.GetMessage = GetMessage
CountryMarkData.GetLanguageName = GetLanguageName
CountryMarkData.SetLanguageName = SetLanguageName
CountryMarkData.SetTranslateHandler = SetTranslateHandler
return CountryMarkData
