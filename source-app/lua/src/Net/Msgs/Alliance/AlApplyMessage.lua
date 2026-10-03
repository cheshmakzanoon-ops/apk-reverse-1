local AlApplyMessage = BaseClass("AlApplyMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

local function OnCreate(self, allianceId, applyType, language, checkType)
  base.OnCreate(self)
  self.applyType = applyType
  self.alUid = allianceId
  self.sfsObj:PutUtfString("allianceId", allianceId)
  self.sfsObj:PutInt("applyType", applyType)
  self.sfsObj:PutUtfString("playerlabel", "")
  self.sfsObj:PutUtfString("language", language)
  self.sfsObj:PutUtfString("playerSelf", "")
  self.sfsObj:PutInt("isRedpack", 0)
  if checkType then
    self.sfsObj:PutInt("checkType", checkType)
  end
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    if errCode == "season_tips144" then
      local time = t.coolEndTime
      if time then
        local coolTime = time - UITimeManager:GetInstance():GetServerTime()
        if 0 < coolTime then
          local timeStr = UITimeManager:GetInstance():MilliSecondToFmtString(coolTime)
          UIUtil.ShowTips(Localization:GetString("season_tips144", timeStr))
        end
      end
    else
      UIUtil.ShowTipsId(errCode)
    end
  elseif t.resultCode ~= nil then
    if t.resultCode == "allianceFull" then
      UIUtil.ShowMessage(Localization:GetString("E100070"))
    end
  elseif t.alliance_apply_not_qualified ~= nil then
    local label = t.alliance_apply_not_qualified
    UIUtil.ShowMessage(Localization:GetString(label))
  elseif t.applyType ~= nil and t.allianceId ~= nil then
    local applyType = t.applyType
    local allianceId = t.allianceId
    if t.join ~= nil and applyType == 0 and t.join == false then
      UIUtil.ShowMessage(Localization:GetString("E100089"))
    end
    if t.alliance ~= nil then
      DataCenter.AllianceBaseDataManager:UpdateAllianceBaseData(t)
      local allianceData = DataCenter.AllianceBaseDataManager:GetAllianceBaseData()
      local str = Localization:GetString("390084", allianceData.allianceName)
      UIUtil.ShowTips(str)
      DataCenter.AllianceBaseDataManager:Coalize(t)
      if SeasonUtil.IsInSeasonDesertMode() then
        DataCenter.AllianceMineManager:RequestAllianceMineInfo(true)
      end
      if SceneUtils.GetIsInWorld() then
        CS.SceneManager.World:SetFirstViewRequestFlag(true)
        CS.SceneManager.World:UpdateViewRequest(true)
      end
    end
    if applyType == 1 then
      DataCenter.AllianceTempListManager:ApplyAllianceByUid(allianceId)
      EventManager:GetInstance():Broadcast(EventId.CLICK_ALLIANCE_ITEM, allianceId)
    end
  end
end

AlApplyMessage.OnCreate = OnCreate
AlApplyMessage.HandleMessage = HandleMessage
return AlApplyMessage
