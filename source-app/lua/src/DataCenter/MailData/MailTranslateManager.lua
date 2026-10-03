local MailTranslateManager = BaseClass("MailTranslateManager")
local rapidjson = require("rapidjson")
local Localization = CS.GameEntry.Localization
local TranslateEnum = {
  Mail = 1,
  AllianceMark = 2,
  AlianceAnnouncement = 3,
  AlianceAnnouncementTitle = 4,
  LandlordAllyMsg = 5,
  ChampionDuel = 6,
  Max = 10
}
local TRANS_URL = "http://10.7.88.22:83/client.php"
local TRANS_CHANNEL = "lastwar"

function MailTranslateManager:__init()
  self.translatingList = {}
  self.version = ChatInterface.getVersionName()
  TRANS_URL = "http://translate-aps.metapoint.club/client.php"
  local isMiddleEast = false
  if isMiddleEast then
    TRANS_URL = "http://app1.im.medrickgames.com:8083/v3/client.php"
  end
  self:ClearDatas()
end

function MailTranslateManager:ClearDatas()
  self.translatingList = {}
end

function MailTranslateManager:GetLangString(str)
  str = str or ""
  if str == "zh-CN" or str == "zh_CN" or str == "zh-Hans" or str == "zh-CHS" or str == "cn" then
    return "zh-Hans"
  elseif str == "zh-TW" or str == "zh_TW" or str == "zh-Hant" or str == "zh-CHT" or str == "tw" then
    return "zh-Hant"
  end
  return str
end

function MailTranslateManager:MakePostParam(srcLang, targetLang, content)
  local tarL = self:GetLangString(targetLang)
  local oriL = srcLang
  local pUid = LuaEntry.Player.uid
  local sid = LuaEntry.Player.serverId
  local ui = pUid .. "," .. sid .. "," .. self.version
  local translateKey = LuaEntry.Player.translateKey
  local channel = TRANS_CHANNEL
  local t = {}
  t.sc = tostring(content)
  t.sf = tostring(oriL)
  t.tf = tostring(tarL)
  t.ch = tostring(channel)
  t.ui = tostring(ui)
  t.scene = tostring(channel)
  t.uid = tostring(pUid)
  t.tk = tostring(translateKey)
  return t
end

function MailTranslateManager:Translate(origInfo, translateType, roomGroupType)
  if not origInfo then
    return false
  end
  local oriLang = ""
  local strMsg = ""
  local targetLang = ChatInterface.GetChatTranslateLanguageAbbr()
  if translateType == TranslateEnum.AlianceAnnouncementTitle then
    strMsg = origInfo:GetAnnounceTitle()
  else
    strMsg = origInfo:GetMessage()
  end
  table.insert(self.translatingList, origInfo)
  ChatManager2:GetInstance().Translate:Translate(strMsg, oriLang, targetLang, function(ok, rtnTbl)
    table.removebyvalue(self.translatingList, origInfo)
    self:onTranslateCallback(origInfo, ok, rtnTbl, translateType)
  end, nil, nil, roomGroupType)
end

function MailTranslateManager:onTranslateCallback(origInfo, ok, responseData, translateType)
  local ret = false
  if responseData then
    local data = responseData
    if not data or data.code ~= 0 then
    else
      if translateType == TranslateEnum.AlianceAnnouncementTitle then
        origInfo:SetTransAnnounceTitle(data.translateMsg)
      else
        origInfo:SetTranslationMsg(data.translateMsg)
      end
      origInfo.translatedLang = data.targetLang
      ret = true
    end
  end
  if ret == true then
    if translateType == TranslateEnum.AlianceAnnouncementTitle then
      origInfo:SetAnnounceTitleTranslateing(false)
    else
      origInfo:SetIsTranslating(false)
    end
    if translateType == TranslateEnum.AllianceMark then
      origInfo:SetTranslateFinishState(1)
    end
    if translateType == TranslateEnum.Mail then
      DataCenter.MailDataManager:SetMailTranslated(origInfo.uid, origInfo.translateMsg, origInfo.translatedLang)
    end
  elseif translateType == TranslateEnum.AllianceMark then
    origInfo:SetTranslateFinishState(-1)
  end
  if translateType == TranslateEnum.Mail then
    EventManager:GetInstance():Broadcast(EventId.ChangeShowTranslatedStatus, origInfo)
  elseif translateType == TranslateEnum.AllianceMark then
    EventManager:GetInstance():Broadcast(EventId.WorldAllianceMarkTranslateFinish, origInfo)
  elseif translateType == TranslateEnum.AlianceAnnouncement then
    EventManager:GetInstance():Broadcast(EventId.AllianceAnnouncementTranslateFinish, origInfo)
  elseif translateType == TranslateEnum.AlianceAnnouncementTitle then
    EventManager:GetInstance():Broadcast(EventId.AllianceAnnouncementTitleTranslateFinish, origInfo)
  elseif translateType == TranslateEnum.LandlordAllyMsg then
    EventManager:GetInstance():Broadcast(EventId.LandlordAllyMsgTranslateFinish, origInfo)
  elseif translateType == TranslateEnum.ChampionDuel then
    EventManager:GetInstance():Broadcast(EventId.ChampionDuelBattleTranslateFinish, origInfo)
  end
end

local function __delete(self)
end

MailTranslateManager.__delete = __delete
MailTranslateManager.TranslateEnum = TranslateEnum
return MailTranslateManager
