local DefenceWallDataManager = BaseClass("ArmyFormationDataManager")
local Localization = CS.GameEntry.Localization

local function __init(self)
  self.defenceWallData = {}
  self.defenceFormationMaxSize = 0
  self.defFormationFirstMaxCount = 0
  self.defFormationSecondMaxCount = 0
  self.defFormationThirdMaxCount = 0
  self.defDomeMaxNum = 0
  self.defDomeAddSpeed = 0
  self.fixPercentOnce = 0
  self.guardArmyInfo = nil
  self.state = false
  EventManager:GetInstance():AddListener(EventId.EffectNumChange, self.UpdateValueSignal)
end

local function __delete(self)
  self.defenceWallData = nil
  self.guardArmyInfo = nil
  self.state = false
  EventManager:GetInstance():RemoveListener(EventId.EffectNumChange, self.UpdateValueSignal)
end

local function InitData(self, message)
  self:UpdateValue()
  self:UpdateDefenceWallData(message.defend_wall)
  if message.defend_wall ~= nil then
    local dic = message.defend_wall
    if dic.cityBroken ~= nil then
      self.state = dic.cityBroken
      if self.state == true then
        Logger.Log("show broken")
        UIUtil.ShowMessage(Localization:GetString("300543"), 1, GameDialogDefine.CONFIRM, GameDialogDefine.CANCEL, function()
          GoToUtil.GotoMainBuildPos()
        end, function()
          GoToUtil.GotoMainBuildPos()
        end, function()
          GoToUtil.GotoMainBuildPos()
        end)
      end
    end
  end
end

local function UpdateDefenceWallData(self, message)
  if message ~= nil then
    self.defenceWallData = DefenceWallData.New()
    self.defenceWallData:ParseData(message)
  end
end

local function UpdateCurDurability(self, message)
  if message.uid ~= nil then
    local uid = message.uid
    if uid == LuaEntry.Player.uid and message.nowDurability ~= nil and self.defenceWallData ~= nil then
      self.defenceWallData:SetCurDurability(message.nowDurability)
    end
  end
end

local function UpdateColdDownTime(self, message)
  if message.lastGoldRecoverDurabilityTime ~= nil and self.defenceWallData ~= nil then
    self.defenceWallData:SetColdDownTime(message.lastGoldRecoverDurabilityTime)
  end
end

local function UpdateValueSignal(data)
  DataCenter.DefenceWallDataManager:UpdateValue()
end

local function UpdateValue(self)
  self.defenceFormationMaxSize = LuaEntry.Effect:GetGameEffect(EffectDefine.APS_DEFENCE_FORMATION_SIZE)
  self.defFormationFirstMaxCount = LuaEntry.Effect:GetGameEffect(EffectDefine.APS_DEFENCE_FORMATION_FIRST_HERO_COUNT)
  self.defFormationSecondMaxCount = LuaEntry.Effect:GetGameEffect(EffectDefine.APS_DEFENCE_FORMATION_SECOND_HERO_COUNT)
  self.defFormationThirdMaxCount = LuaEntry.Effect:GetGameEffect(EffectDefine.APS_DEFENCE_FORMATION_THIRD_HERO_COUNT)
  self.defDomeMaxNum = 0
  self.defDomeAddSpeed = 0
  self.fixPercentOnce = LuaEntry.DataConfig:TryGetNum("city_wall", "k1")
  self.fixDiamond = LuaEntry.DataConfig:TryGetNum("city_wall", "k2")
  self.fixColdDownTime = LuaEntry.DataConfig:TryGetNum("city_wall", "k3")
  local buildLevelTemplate = DataCenter.BuildTemplateManager:GetBuildingLevelTemplate(BuildingTypes.FUN_BUILD_MAIN, DataCenter.BuildManager.MainLv)
  if buildLevelTemplate ~= nil then
    self.defDomeMaxNum = buildLevelTemplate:GetDefenceWallMax()
    self.defDomeAddSpeed = buildLevelTemplate:GetDefenceWallCoverSpeed()
  end
end

local function GetConfigData(self)
  local oneData = {}
  oneData.defenceFormationMaxSize = self.defenceFormationMaxSize
  oneData.defFormationFirstMaxCount = self.defFormationFirstMaxCount
  oneData.defFormationSecondMaxCount = self.defFormationSecondMaxCount
  oneData.defFormationThirdMaxCount = self.defFormationThirdMaxCount
  oneData.defDomeMaxNum = 0
  oneData.defDomeAddSpeed = 0
  local buildLevelTemplate = DataCenter.BuildTemplateManager:GetBuildingLevelTemplate(BuildingTypes.FUN_BUILD_MAIN, DataCenter.BuildManager.MainLv)
  if buildLevelTemplate ~= nil then
    oneData.defDomeMaxNum = buildLevelTemplate:GetDefenceWallMax()
    oneData.defDomeAddSpeed = buildLevelTemplate:GetDefenceWallCoverSpeed()
  end
  oneData.fixPercentOnce = self.fixPercentOnce
  oneData.fixDiamond = self.fixDiamond
  oneData.fixColdDownTime = self.fixColdDownTime
  return oneData
end

local function GetDefenceWallData(self)
  return self.defenceWallData
end

local function GetMaxDefenceNum(self)
  return self.defenceFormationMaxSize
end

local function UpdateGuardArmyInfo(self, message)
  if message.armyInfo ~= nil then
    self.guardArmyInfo = PBController.ParsePb1(message.armyInfo, "protobuf.ArmyUnitInfo")
  end
end

local function GetGuardArmyInfo(self)
  return self.guardArmyInfo
end

function DefenceWallDataManager:IsInShield()
  if not self.defenceWallData then
    return false
  end
  local protectEndTime = self.defenceWallData.protectEndTime
  return protectEndTime - UITimeManager:GetInstance():GetServerTime() > 0
end

function DefenceWallDataManager:GetBreakState()
  return self.state
end

function DefenceWallDataManager:GetScoutAlarmIsOn()
  if self.investigationIsOn == nil then
    self.investigationIsOn = CommonUtil.PlayerPrefsGetBool("Investigation", true)
  end
  return self.investigationIsOn
end

function DefenceWallDataManager:RefreshScoutAlarmIsOn()
  self.investigationIsOn = CommonUtil.PlayerPrefsGetBool("Investigation", true)
end

function DefenceWallDataManager:FetchWallBar()
  if SeasonUtil.IsInSeasonNineNationRainforestMode(true) then
    SFSNetwork.SendMessage(MsgDefines.ShieldInfo)
  end
end

function DefenceWallDataManager:SetWallBar(msg)
  self.shieldInfo = msg.shieldInfo
  if self:HasWallBar() then
    self:AddTimer()
  end
  EventManager:GetInstance():Broadcast(EventId.RefreshMyWallBar)
end

function DefenceWallDataManager:HasWallBar()
  if self.shieldInfo == nil then
    return false
  end
  if self.shieldInfo.expireTime > 0 and UITimeManager:GetInstance():GetServerTime() > self.shieldInfo.expireTime then
    self.shieldInfo = nil
    return false
  end
  return true
end

function DefenceWallDataManager:GetWallBarCurAndMax()
  if self:HasWallBar() then
    return self.shieldInfo.shieldValue, self.shieldInfo.shieldMaxValue
  end
  return 0, 0
end

function DefenceWallDataManager:GetWallBarBuffData()
  if self:HasWallBar() then
    local skillTemplate = DataCenter.MasteryManager:GetSkillTemplateByType(MasterySkill.CreateWall)
    if skillTemplate then
      return {
        icon = skillTemplate:GetIconFullPath(),
        expireTime = self.shieldInfo.expireTime,
        totalTime = tonumber(skillTemplate.value2) * 1000
      }
    else
      return {
        icon = "Assets/Main/SeasonRes/S6/Sprites/Mastery/lyt_S6_chengqiangjiagu.png",
        expireTime = self.shieldInfo.expireTime,
        totalTime = 3600000
      }
    end
  end
  return nil
end

function DefenceWallDataManager:AddTimer()
  if self.timer == nil then
    self.timer = TimerManager:GetInstance():GetTimer(1, self.Update1000MS, self, false, false, false)
  end
  self.timer:Start()
end

function DefenceWallDataManager:RemoveTimer()
  if self.timer ~= nil then
    self.timer:Stop()
    self.timer = nil
  end
end

function DefenceWallDataManager:Update1000MS()
  if not self:HasWallBar() then
    self.shieldInfo = nil
    self:RemoveTimer()
    EventManager:GetInstance():Broadcast(EventId.RefreshMyWallBar)
  end
end

DefenceWallDataManager.__init = __init
DefenceWallDataManager.__delete = __delete
DefenceWallDataManager.UpdateCurDurability = UpdateCurDurability
DefenceWallDataManager.UpdateDefenceWallData = UpdateDefenceWallData
DefenceWallDataManager.UpdateValue = UpdateValue
DefenceWallDataManager.UpdateValueSignal = UpdateValueSignal
DefenceWallDataManager.GetConfigData = GetConfigData
DefenceWallDataManager.GetDefenceWallData = GetDefenceWallData
DefenceWallDataManager.InitData = InitData
DefenceWallDataManager.UpdateColdDownTime = UpdateColdDownTime
DefenceWallDataManager.GetMaxDefenceNum = GetMaxDefenceNum
DefenceWallDataManager.UpdateGuardArmyInfo = UpdateGuardArmyInfo
DefenceWallDataManager.GetGuardArmyInfo = GetGuardArmyInfo
return DefenceWallDataManager
