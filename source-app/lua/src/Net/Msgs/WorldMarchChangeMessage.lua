local WorldMarchChangeMessage = BaseClass("WorldMarchChangeMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

local function OnCreate(self, uuid, target, targetUid, path, worldId, autoBackHome, targetServer, destroyTimeIndex, cardSkillUseInfoList)
  base.OnCreate(self)
  if target ~= nil and SeasonUtil.InSeasonBigMapMode(targetServer) then
    local marchInfo = CS.SceneManager.World:GetMarch(uuid)
    if marchInfo then
      if marchInfo.globalArmy then
        target = CrossMarchTargetSwitchDefine[target] or target
      else
        local loginServerId = LuaEntry.Player:GetSelfServerId()
        target = loginServerId ~= targetServer and CrossMarchTargetSwitchDefine[target] or target
      end
    end
  end
  self.sfsObj:PutLong("uuid", uuid)
  self.sfsObj:PutInt("target", target)
  self.sfsObj:PutLong("targetUid", targetUid)
  if path ~= nil and path ~= "" then
    self.sfsObj:PutUtfString("path", path)
  end
  if worldId == nil or worldId == 0 then
    worldId = LuaEntry.Player:GetCurWorldId()
  end
  self.sfsObj:PutInt("worldId", worldId)
  self.sfsObj:PutBool("autoBackHome", autoBackHome)
  if 0 < worldId then
    self.sfsObj:PutInt("targetServer", LuaEntry.Player:GetCurServerId())
  elseif 0 < targetServer then
    self.sfsObj:PutInt("targetServer", targetServer)
  end
  if 0 < destroyTimeIndex then
    self.sfsObj:PutInt("destroyTimeIndex", destroyTimeIndex)
  end
  if cardSkillUseInfoList and 0 < #cardSkillUseInfoList then
    local extraParam = SFSObject.New()
    local cardSkills = SFSArray.New()
    for i, v in ipairs(cardSkillUseInfoList) do
      local obj = SFSObject.New()
      obj:PutLong("cardUuid", v.cardUuid)
      obj:PutInt("cardSkillId", v.cardSkillId)
      cardSkills:AddSFSObject(obj)
    end
    extraParam:PutSFSArray("cardSkills", cardSkills)
    self.sfsObj:PutSFSObject("extraParam", extraParam)
  end
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    if errCode == "season_cross_battle_tips01" and t.openTime then
      local now = UITimeManager:GetInstance():GetServerTime()
      local deltaTime = t.openTime - now
      if 0 < deltaTime then
        local leftMS = UITimeManager:GetInstance():MilliSecondToFmtString(deltaTime)
        UIUtil.ShowTips(Localization:GetString("season_cross_battle_tips01", leftMS))
      end
    elseif errCode == "season_builders_alliance_tips_45" and t.leftMS then
      local leftMS = UITimeManager:GetInstance():MilliSecondToFmtString(t.leftMS)
      UIUtil.ShowTips(Localization:GetString(errCode, leftMS))
    elseif errCode == "yuntieBattle_tips_1043" then
      if t.errorPara2 then
        UIUtil.ShowTips(Localization:GetString(errCode, table.unpack(t.errorPara2)))
      else
        UIUtil.ShowTipsId(errCode)
      end
    else
      UIUtil.ShowTipsId(errCode)
    end
  else
    CS.SceneManager.World:HandleFormationMarchChange(t)
  end
end

WorldMarchChangeMessage.OnCreate = OnCreate
WorldMarchChangeMessage.HandleMessage = HandleMessage
return WorldMarchChangeMessage
