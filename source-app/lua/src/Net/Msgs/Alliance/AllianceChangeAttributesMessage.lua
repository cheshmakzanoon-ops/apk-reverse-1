local AllianceChangeAttributesMessage = BaseClass("AllianceChangeAttributesMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, name, abbr, recruitTotal, intro, language, castleRestrictionN, powerRestrictionN, announce, lookForCareers, icon, country, recommend, applyPowerLimit, applyLevelLimit, autoKickInactiveMember, autoScienceResearch)
  base.OnCreate(self)
  if name ~= nil and name ~= "" then
    self.sfsObj:PutUtfString("name", name)
  end
  if abbr ~= nil and abbr ~= "" then
    self.sfsObj:PutUtfString("abbr", abbr)
  end
  if intro ~= nil and intro ~= "" then
    self.sfsObj:PutUtfString("intro", intro)
  end
  if not string.IsNullOrEmpty(icon) then
    self.sfsObj:PutUtfString("icon", icon)
  end
  if language ~= nil and language ~= "" then
    self.sfsObj:PutUtfString("language", tostring(language))
  end
  if recruitTotal ~= nil and recruitTotal ~= -1 then
    self.sfsObj:PutInt("recruitTotal", recruitTotal)
    self.sfsObj:PutInt("recruit", recruitTotal)
  end
  if recommend then
    self.sfsObj:PutInt("recommendFunc", recommend)
  end
  if castleRestrictionN ~= nil then
    self.sfsObj:PutUtfString("castleRestrictionN", castleRestrictionN)
  end
  if powerRestrictionN ~= nil then
    self.sfsObj:PutUtfString("powerRestrictionN", powerRestrictionN)
  end
  if announce and announce ~= "" then
    self.sfsObj:PutUtfString("announce", announce)
  end
  if country and country ~= "" then
    self.sfsObj:PutUtfString("country", country)
  end
  if lookForCareers then
    self.sfsObj:PutUtfString("lookingForCareers", string.join(lookForCareers, ";"))
  end
  if applyLevelLimit then
    self.sfsObj:PutInt("applyLevelLimit", applyLevelLimit)
  end
  if applyPowerLimit then
    self.sfsObj:PutInt("applyPowerLimit", applyPowerLimit)
  end
  if autoKickInactiveMember then
    self.sfsObj:PutInt("autoKickInactiveMember", autoKickInactiveMember)
  end
  if autoScienceResearch then
    self.sfsObj:PutInt("autoScienceResearch", autoScienceResearch)
  end
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowErrorCodeTips(t)
  else
    if t.gold ~= nil then
      LuaEntry.Player.gold = t.gold
      EventManager:GetInstance():Broadcast(EventId.UpdateGold)
    end
    if t.clientReq ~= nil then
      local message = t.clientReq
      DataCenter.AllianceBaseDataManager:UpdateAllianceSetting(message)
      if message.name ~= nil then
        UIUtil.ShowTipsId(390117)
        EventManager:GetInstance():Broadcast(EventId.AllianceNameChange, message.name)
      elseif message.abbr ~= nil then
        UIUtil.ShowTipsId(390103)
        EventManager:GetInstance():Broadcast(EventId.AllianceAbbrChange, message.abbr)
      elseif message.lookingForCareers ~= nil then
        UIUtil.ShowTipsId(393022)
        local careers = {}
        for _, str in ipairs(string.split(message.lookingForCareers, ";")) do
          table.insert(careers, tonumber(str))
        end
        EventManager:GetInstance():Broadcast(EventId.AllianceLookForCareers, careers)
      elseif message.icon then
        EventManager:GetInstance():Broadcast(EventId.AllianceFlagChanged, message.icon)
        UIUtil.ShowTipsId(393022)
      elseif message.country then
        EventManager:GetInstance():Broadcast(EventId.AllianceCountryChanged, message.country)
      elseif message.language then
        EventManager:GetInstance():Broadcast(EventId.AllianceLanguage, message.language)
      elseif message.recommendFunc then
        EventManager:GetInstance():Broadcast(EventId.OnAllianceRecommendChange, message.recommendFunc)
      elseif message.applyLevelLimit then
        EventManager:GetInstance():Broadcast(EventId.AllianceApplyBaseLevelLimitChange, message.applyLevelLimit)
      elseif message.applyPowerLimit then
        EventManager:GetInstance():Broadcast(EventId.AllianceApplyPowerLimitChange, message.applyPowerLimit)
      elseif message.autoScienceResearch then
        EventManager:GetInstance():Broadcast(EventId.AllianceAutoDinate, message.autoScienceResearch)
      else
        UIUtil.ShowTipsId(393022)
      end
    end
  end
end

AllianceChangeAttributesMessage.OnCreate = OnCreate
AllianceChangeAttributesMessage.HandleMessage = HandleMessage
return AllianceChangeAttributesMessage
