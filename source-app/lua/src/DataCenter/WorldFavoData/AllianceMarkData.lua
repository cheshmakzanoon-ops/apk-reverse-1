local AllianceMarkData = BaseClass("AllianceMarkData")
local Localization = CS.GameEntry.Localization

local function __init(self)
  self.uid = 0
  self.userName = ""
  self.allianceId = ""
  self.type = 0
  self.pos = 0
  self.server = 0
  self.worldId = 0
  self.name = ""
  self.createTime = 0
  self.translateMsg = ""
  self.translateLanguage = ""
  self.isTranslating = false
  self.tanslateFinish = 0
  self.TranslateManager = nil
  self.startTime = 0
  self.viewRank = 0
  self.operateType = 0
end

local function __delete(self)
  self:Destroy()
end

local function Destroy(self)
  self.uid = nil
  self.userName = nil
  self.allianceId = nil
  self.type = nil
  self.pos = nil
  self.server = nil
  self.name = nil
  self.createTime = nil
  self.pointInfo = nil
  self.viewRank = nil
  self.operateType = nil
end

local function ParseData(self, msg)
  if not msg then
    return
  end
  if msg.uid then
    self.uid = msg.uid
  end
  if msg.userName then
    self.userName = msg.userName
  end
  if msg.allianceId then
    self.allianceId = msg.allianceId
  end
  if msg.markType then
    self.type = msg.markType
  end
  if msg.point then
    self.pos = msg.point
  end
  if msg.serverId then
    self.server = msg.serverId
  end
  if msg.worldId then
    self.worldId = msg.worldId
  end
  if msg.markName then
    self.name = msg.markName
  end
  if msg.markTime then
    self.createTime = msg.markTime
  end
  if msg.allianceName then
    self.allianceName = msg.allianceName
  end
  if msg.allianceAbbr then
    self.allianceAbbr = msg.allianceAbbr
  end
  if msg.startTime then
    self.startTime = msg.startTime
  end
  if msg.notice then
    self.notice = msg.notice
  end
  if msg.pointInfo then
    self.pointInfo = msg.pointInfo
  end
  if msg.viewRank then
    self.viewRank = msg.viewRank
  end
  if msg.operateType then
    self.operateType = msg.operateType
  end
end

local function IsSelfAlliance(self)
  local selfAllianceId = LuaEntry.Player.allianceId
  return self.allianceId == selfAllianceId
end

local function GetPrefabPath(self)
  if self:IsSelfAlliance() then
    return self.type == MarkType.Alliance_OtherServerRally and UIAssets.S5AllianceOtherServerRallyMark or UIAssets.AllianceWorldRallyMark
  else
    return UIAssets.OtherAllianceWorldRallyMark
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
  self.TranslateManager:Translate(self, self.TranslateManager.TranslateEnum.AllianceMark)
end

local function GetMessage(self)
  if self.type == 100 then
    return Localization:GetString(self.name)
  else
    return self.name
  end
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

function AllianceMarkData:GetPointIndex()
  return self.pos // 10
end

AllianceMarkData.__init = __init
AllianceMarkData.__delete = __delete
AllianceMarkData.Destroy = Destroy
AllianceMarkData.ParseData = ParseData
AllianceMarkData.IsSelfAlliance = IsSelfAlliance
AllianceMarkData.GetPrefabPath = GetPrefabPath
AllianceMarkData.SetTranslationMsg = SetTranslationMsg
AllianceMarkData.GetTranslationMsg = GetTranslationMsg
AllianceMarkData.SetIsTranslating = SetIsTranslating
AllianceMarkData.GetIsTranslating = GetIsTranslating
AllianceMarkData.SetTranslateLanguage = SetTranslateLanguage
AllianceMarkData.DoTranslate = DoTranslate
AllianceMarkData.SetTranslateFinishState = SetTranslateFinishState
AllianceMarkData.GetTranslateFinishState = GetTranslateFinishState
AllianceMarkData.GetMessage = GetMessage
AllianceMarkData.GetLanguageName = GetLanguageName
AllianceMarkData.SetLanguageName = SetLanguageName
AllianceMarkData.SetTranslateHandler = SetTranslateHandler
return AllianceMarkData
