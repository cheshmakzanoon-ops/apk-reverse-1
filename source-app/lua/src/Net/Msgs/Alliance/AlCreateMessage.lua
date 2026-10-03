local AlCreateMessage = BaseClass("AlCreateMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization
local send_name, send_intro, send_icon, send_language, send_abbr, send_country, send_chooseLeader, send_confirmCreate

local function OnCreate(self, name, intro, icon, language, abbr, country, chooseLeader, confirmCreate)
  base.OnCreate(self)
  if not string.IsNullOrEmpty(name) then
    self.sfsObj:PutUtfString("name", name)
  end
  if not string.IsNullOrEmpty(intro) then
    self.sfsObj:PutUtfString("intro", intro)
  end
  if not string.IsNullOrEmpty(icon) then
    self.sfsObj:PutUtfString("icon", icon)
  end
  if not string.IsNullOrEmpty(language) then
    self.sfsObj:PutUtfString("language", tostring(language))
  else
    local curLanguage = Localization:GetLanguage()
    local languageId = SuportedLanguagesLocalName[curLanguage]
    self.sfsObj:PutUtfString("language", languageId)
  end
  if not string.IsNullOrEmpty(abbr) then
    self.sfsObj:PutUtfString("abbr", abbr)
  end
  if not string.IsNullOrEmpty(country) then
    self.sfsObj:PutUtfString("country", country)
  end
  chooseLeader = chooseLeader and 1 or 0
  self.sfsObj:PutInt("chooseLeader", chooseLeader)
  if confirmCreate ~= nil then
    self.sfsObj:PutBool("confirmCreate", confirmCreate)
  end
  send_name = name
  send_intro = intro
  send_icon = icon
  send_language = language
  send_abbr = abbr
  send_country = country
  send_chooseLeader = chooseLeader
  send_confirmCreate = confirmCreate
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
    if errCode == "E100054" then
      EventManager:GetInstance():Broadcast(EventId.AllianceCreateSuccess, false)
    end
  else
    if t.gold ~= nil then
      LuaEntry.Player.gold = t.gold
      EventManager:GetInstance():Broadcast(EventId.UpdateGold)
    end
    if t.resource ~= nil then
      LuaEntry.Resource:UpdateResource(t.resource)
    end
    if t.alliance ~= nil then
      DataCenter.AllianceBaseDataManager:UpdateAllianceBaseData(t)
    end
    if t.lastUpdateTime then
      LuaEntry.Player:SetLastUpdateTime(t.lastUpdateTime)
    end
    if t.needConfirm ~= nil and t.needConfirm == true then
      UIUtil.ShowMessage(Localization:GetString("455124"), 1, GameDialogDefine.CONFIRM, GameDialogDefine.CANCEL, function()
        SFSNetwork.SendMessage(MsgDefines.AlCreate, send_name, send_intro, send_icon, send_language, send_abbr, send_country, send_chooseLeader, true)
      end, function()
      end, nil, 455123)
    else
      UIUtil.ShowTipsId(390007)
      EventManager:GetInstance():Broadcast(EventId.AllianceCreateSuccess, true)
    end
  end
end

AlCreateMessage.OnCreate = OnCreate
AlCreateMessage.HandleMessage = HandleMessage
return AlCreateMessage
