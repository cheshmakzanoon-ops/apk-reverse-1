local WorldMarchFormationNewMessage = BaseClass("WorldMarchFormationNewMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

local function OnCreate(self, formationUuid, target, targetUid, path, waitTimeIndex, autoBackHome, formationParam, targetServer, destroyTimeIndex, serverSoldiers, extraParam, cardSkillUseInfoList)
  base.OnCreate(self)
  target = target ~= nil and SeasonUtil.InSeasonBigMapMode(targetServer) and targetServer ~= LuaEntry.Player:GetSelfServerId() and CrossMarchTargetSwitchDefine[target] or target
  self.sfsObj:PutLong("formationUuid", formationUuid)
  self.sfsObj:PutInt("target", target)
  self.sfsObj:PutLong("targetUid", targetUid)
  if path ~= nil and path ~= "" then
    self.sfsObj:PutUtfString("path", path)
  end
  if MarchUtil.IsScoutMarch(target) then
    LuaEntry.GlobalData.UseLightWorkerMan = 0
    self.sfsObj:PutInt("soldierType", SoldierType.Player)
  else
    self.sfsObj:PutInt("soldierType", Setting:GetPrivateInt("TheLastUseSoldierType", 1))
  end
  local worldId = LuaEntry.Player:GetCurWorldId()
  self.sfsObj:PutInt("worldId", worldId)
  self.sfsObj:PutInt("worldType", LuaEntry.Player:GetCurWorldType())
  self.sfsObj:PutInt("waitTimeIndex", waitTimeIndex)
  self.sfsObj:PutBool("autoBackHome", autoBackHome)
  if formationParam ~= nil then
    self.sfsObj:PutSFSObject("formationParam", formationParam)
  end
  if 0 < worldId then
    self.sfsObj:PutInt("targetServer", LuaEntry.Player:GetCurServerId())
  elseif 0 < targetServer then
    self.sfsObj:PutInt("targetServer", targetServer)
  end
  if 0 < destroyTimeIndex then
    self.sfsObj:PutInt("destroyTimeIndex", destroyTimeIndex)
  end
  local clientCreateGuid = CS.SceneManager.World:SaveCreateMarchRecordTime()
  self.sfsObj:PutUtfString("clientCreateUuid", clientCreateGuid)
  if LuaEntry.GlobalData.UseLightWorkerMan == 1 then
    if extraParam == nil then
      extraParam = SFSObject.New()
    end
    extraParam:PutBool("userPowerWorker", true)
    UIUtil.CheckEventTrigger(OpMode.ClickBtnMakeMarchWithLight)
  end
  Setting:SetPrivateBool("FL_" .. formationUuid, LuaEntry.GlobalData.UseLightWorkerMan == 1)
  if cardSkillUseInfoList and 0 < #cardSkillUseInfoList then
    local cardSkills = SFSArray.New()
    for i, v in ipairs(cardSkillUseInfoList) do
      local obj = SFSObject.New()
      obj:PutLong("cardUuid", v.cardUuid)
      obj:PutInt("cardSkillId", v.cardSkillId)
      cardSkills:AddSFSObject(obj)
    end
    if extraParam == nil then
      extraParam = SFSObject.New()
    end
    extraParam:PutSFSArray("cardSkills", cardSkills)
  end
  if extraParam then
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
    elseif errCode == "s5_map_ui_30" and t.needTime then
      local leftMS = UITimeManager:GetInstance():MilliSecondToFmtString(t.needTime)
      UIUtil.ShowTips(Localization:GetString(errCode, leftMS))
    elseif errCode == "season_s5_deposit_max01" then
      UIUtil.ShowTips(Localization:GetString(errCode, t.currNum, t.maxNum))
    else
      UIUtil.ShowTipsId(errCode)
    end
    if errCode == "season_s4_lighthouse_tips_12" then
      UIManager:GetInstance():OpenWindow(UIWindowNames.UILWPowerHouse, {anim = true}, 2)
    end
  else
    CS.SceneManager.World:HandleFormationMarch(t)
  end
  DataCenter.ArmyFormationDataManager:FetchFormationSoldier()
  local theSoldierType = Setting:GetPrivateInt("TheLastUseSoldierType", 1)
  if theSoldierType == SoldierType.Mummy then
    SFSNetwork.SendMessage(MsgDefines.FetchSeasonMummyMainInfo)
  end
end

function WorldMarchFormationNewMessage:GetTestData(formationUuid, target, targetUid, path, waitTimeIndex, autoBackHome, formationParam, targetServer, destroyTimeIndex, serverSoldiers, extraParam)
  local t = {
    teamUuid = 0,
    resource = {
      obsidian = 0,
      pvePoint = 0,
      metal = 80194155,
      electricity = 0,
      water = 0,
      people = 0,
      oil = 0,
      money = 120224387,
      dragonHonorScore = 160000,
      flint = 0,
      wood = 87827466,
      db_timezone_offset = 1757669231,
      petroleum = 0
    },
    clientCreateUuid = "c681ecac-6068-4890-85b5-c48c9635c8f1",
    isProto = true,
    _id = 306,
    ownerUid = "7205198135000112",
    uuid = 1283697452423081986,
    _time = 142
  }
  return t
end

WorldMarchFormationNewMessage.OnCreate = OnCreate
WorldMarchFormationNewMessage.HandleMessage = HandleMessage
return WorldMarchFormationNewMessage
