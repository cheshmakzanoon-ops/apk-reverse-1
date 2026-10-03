local AlSearchMessage = BaseClass("AlSearchMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

local function OnCreate(self, type, page, key, searchType, isRecommend)
  base.OnCreate(self)
  self.sfsObj:PutInt("type", type)
  self.sfsObj:PutInt("page", page)
  self.sfsObj:PutUtfString("key", key)
  self.sfsObj:PutInt("searchType", searchType)
  local curLanguage = Localization:GetLanguage()
  local languageId = SuportedLanguagesLocalName[curLanguage]
  if languageId then
    self.sfsObj:PutUtfString("lang", languageId)
  else
    self.sfsObj:PutUtfString("lang", SuportedLanguagesLocalName[Language.English])
  end
  self.sfsObj:PutBool("recommend", isRecommend and true or false)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.AllianceTempListManager:RefreshSearchAllianceList(t)
    EventManager:GetInstance():BroadcastDeferred(EventId.SearchAllianceSuccess)
  end
end

AlSearchMessage.OnCreate = OnCreate
AlSearchMessage.HandleMessage = HandleMessage
return AlSearchMessage
