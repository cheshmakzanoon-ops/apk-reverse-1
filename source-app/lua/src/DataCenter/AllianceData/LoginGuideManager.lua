local LoginGuideManager = BaseClass("LoginGuideManager")

function LoginGuideManager:__init()
  self.allianceSwitch = nil
  self.championSwitch = nil
  self.battleCenterSwitch = nil
  self.battleCenterBuildId = 10229000
  
  function self._onEnterCityHandler()
    self:OnEnterCity()
  end
  
  function self._onPassDayHandler()
    self:OnPassDay()
  end
  
  self:AddListeners()
end

function LoginGuideManager:__delete()
  self.allianceSwitch = nil
  self.championSwitch = nil
  self.battleCenterBuildId = nil
  self.battleCenterSwitch = nil
  self:RemoveListeners()
end

function LoginGuideManager:AddListeners()
  EventManager:GetInstance():AddListener(EventId.OnEnterCity, self._onEnterCityHandler)
  EventManager:GetInstance():AddListener(EventId.OnPassDay, self._onPassDayHandler)
end

function LoginGuideManager:RemoveListeners()
  EventManager:GetInstance():RemoveListener(EventId.OnEnterCity, self._onEnterCityHandler)
  EventManager:GetInstance():RemoveListener(EventId.OnPassDay, self._onPassDayHandler)
end

function LoginGuideManager:Startup()
end

function LoginGuideManager:ChampionCondition(strId)
  local open, beginTime = DataCenter.NewPeakArenaManager:GetChampionDuelIsOpen()
  open = DataCenter.BuildManager:HasBuilding(BuildingTypes.LW_BUILD_PVP_ARENA, false) and open
  local lastBeginTime = CS.GameEntry.Setting:GetString(SettingKeys.CHAMPION_GUIDE_CONDITION .. LuaEntry.Player.uid .. strId, "")
  if beginTime and tonumber(beginTime) == tonumber(lastBeginTime) then
    return false
  end
  return open, beginTime
end

function LoginGuideManager:AllianceCondition()
  if not DataCenter.BuildManager:HasBuildByIdAndLevel(BuildingTypes.LW_BUILD_ALLIANCE_CENTER, 1) then
    return false
  end
  if not LuaEntry.Player:IsInAlliance() then
    return false
  end
  local openServerDay = UITimeManager:GetInstance():GetOpenServerDay()
  if 1 < openServerDay then
    local actOpen = DataCenter.ActivityListDataManager:IsContainActivityGroup(CommonActivityGroupEnum.Alliance)
    local switch = LuaEntry.DataConfig:CheckSwitch("alliance_activity_entrance")
    local server = LuaEntry.Player:IsLoginSourceServer()
    return actOpen or switch and not server
  end
  return false
end

function LoginGuideManager:BattleCenterBuildingCondition()
  local open = LuaEntry.DataConfig:CheckSwitch("new_activity_test2")
  local haveBuildRed = DataCenter.BuildManager:HaveRedDotBattleCenterBuilding()
  local mainLv = DataCenter.BuildManager.MainLv
  local day = UITimeManager:GetInstance():GetOpenServerDayByOpenServerZero()
  return open and haveBuildRed ~= nil and 15 <= mainLv and 12 <= day
end

function LoginGuideManager:GetBattleCenterBuildingId()
  return self.battleCenterBuildId
end

function LoginGuideManager:LoginGuide()
  local playGuide = false
  self.battleCenterSwitch = self:BattleCenterBuildingCondition()
  if self.battleCenterSwitch and DataCenter.LWGuideFlowManager:TryTriggerFlexibly(4506) then
    playGuide = true
  end
  local switch, beginTime = self:ChampionCondition(4504)
  self.championSwitch = switch
  if self.championSwitch and DataCenter.LWGuideFlowManager:TryTriggerFlexibly(4504) then
    CS.GameEntry.Setting:SetString(SettingKeys.CHAMPION_GUIDE_CONDITION .. LuaEntry.Player.uid .. "4504", tostring(beginTime))
    playGuide = true
  end
  self.allianceSwitch = self:AllianceCondition()
  if self.allianceSwitch and DataCenter.LWGuideFlowManager:TryTriggerFlexibly(4501) then
    playGuide = true
  end
  local skyBattleSwitch = DataCenter.LWSkyBattleChapterManager:IsOpen()
  if skyBattleSwitch and DataCenter.LWGuideFlowManager:TryTriggerFlexibly(5420) then
    playGuide = true
  end
  return playGuide
end

function LoginGuideManager:PlayChampionGuide()
  local switch, beginTime = self:ChampionCondition(4505)
  self.championSwitch = switch
  if self.championSwitch and DataCenter.LWGuideFlowManager:TryTriggerFlexibly(4505) then
    CS.GameEntry.Setting:SetString(SettingKeys.CHAMPION_GUIDE_CONDITION .. LuaEntry.Player.uid .. "4505", tostring(beginTime))
  end
end

function LoginGuideManager:OnEnterCity()
  self:LoginGuide()
end

function LoginGuideManager:OnPassDay()
  local curScene = CS.SceneManager.CurrSceneID
  if curScene == SceneManagerSceneID.City and UIManager:GetInstance():CheckIfIsMainUIOpenOnly() then
    self:LoginGuide()
  end
end

function LoginGuideManager:PlayAttackCityS0RadarGuide()
  DataCenter.LWGuideFlowManager:TryTriggerFlexibly(7003)
end

function LoginGuideManager:GetAttackCityS0ActIsOpen()
  local list = DataCenter.ActivityListDataManager:GetNowActivityList(nil)
  for _, value in pairs(list) do
    if value.type == EnumActivity.S0AttackCityNew.Type and DataCenter.ActivityListDataManager:CheckIsSend(value) then
      return true
    end
  end
  return false
end

return LoginGuideManager
