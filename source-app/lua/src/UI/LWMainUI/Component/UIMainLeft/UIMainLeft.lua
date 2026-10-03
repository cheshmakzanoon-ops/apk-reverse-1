local base = UIBaseContainer
local UIMainLeft = BaseClass("UIMainLeft", base)
local Resource = CS.GameEntry.Resource
local UIMainTroops = require("UI.UIMain.Component.UIMainBottom.UIMainTroops")
local UITroopsList = require("UI.UIMain.Component.UIMainBottom.TroopList.MainTroopList")
local UIBuildQueue = require("UI.UIMain.Component.UIMainBottom.UIMainBuildQueue")
local UIScienceQueue = require("UI.UIMain.Component.UIMainBottom.UIScienceQueue")
local UIMainVipBtn = require("UI.LWMainUI.Component.UIMainLeft.UIMainVipBtn")
local UIMainSaveGirlBubbleCtrl = require("UI.LWMainUI.Component.UIMainLeft.UIMainSaveGirlBubbleCtrl")
local UIMainCityEvent = require("UI.LWMainUI.Component.UIMainLeft.UIMainCityEvent")
local UIMainArmedUpgradeWarningBubbleCtrl = require("UI.UILWArmedUpgrade.WarningBubble.UIMainArmedUpgradeWarningBubbleCtrl")
local UIMainPlayerObj = require("UI.LWMainUI.Component.UIMainLeft.UIMainPlayerObj")
local player_obj_path = "playerObj"
local UIEnterDragonBattle = require("UI.LWMainUI.Component.UIMainTop.UIEnterDragonBattle")
local UIEnterEpidemicBattle = require("UI.LWMainUI.Component.UIMainTop.UIEnterEpidemicBattle")
local UIEnterDsbDuelBattle = require("UI.DsbDuelBattlefield.Misc.EnterDsbDuelBattle")
local UIMainWinterStormBack = require("UI.LWMainUI.Component.UIMainTop.UIMainWinterStormBack")
local troop_obj_path = "troopNode"
local troop_list_obj_path = "troopNode"
local build_queue_path = "layout/BuildQueue"
local vip_path = "layout/PlayerVIPLevel"
local science_queue_path = "layout/ScienceQueue"
local save_girl_warning_path = "layout/SaveGirlWarning"
local layout_path = "layout"
local cityEvent_path = "layout/CityEvent"
local enter_dragon_battle_path = "EnterDragonBattle"
local enter_winter_storm_path = "UIWinterStormBack"
local enter_epidemic_battle_path = "EnterEpidemicBattle"
local enter_dsb_duel_path = "DsbDuelBattle"

function UIMainLeft:OnCreate()
  base.OnCreate(self)
  local ok, errorMsg = pcall(function()
    self:ComponentDefine()
    self:DataDefine()
  end)
  if not ok and errorMsg then
    Logger.LogError(errorMsg)
  end
end

function UIMainLeft:OnDestroy()
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

function UIMainLeft:OnEnable()
  base.OnEnable(self)
end

function UIMainLeft:OnDisable()
  base.OnDisable(self)
end

function UIMainLeft:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.PostLayoutSizeChanged, self.OnLayoutSizeChanged)
  self:AddUIListener(EventId.OnClaimCollectRewardSucc, self.ShowCollectRewardFlyEff)
  self:AddUIListener(EventId.LWSeasonWeatherInfoUpdate, self.SeasonWeatherInfoUpdate)
  self:AddUIListener(EventId.SeasonHunterBattleStatus, self.SeasonWeatherInfoUpdate)
  self:AddUIListener(EventId.SeasonHunterGetActivityInfo, self.SeasonWeatherInfoUpdate)
  self:AddUIListener(EventId.OnEnterCrossServer, self.SeasonWeatherInfoUpdate)
  self:AddUIListener(EventId.OnQuitCrossServer, self.SeasonWeatherInfoUpdate)
  self:AddUIListener(EventId.OnSetCrossID, self.SeasonWeatherInfoUpdate)
  self:AddUIListener(EventId.PushBloodQueenNextRound, self.SeasonWeatherInfoUpdate)
  self:AddUIListener(EventId.BattlefieldActStateChanged, self.OnBattlefieldActStateChanged)
  self:AddUIListener(EventId.UpdateMainAllianceRedCount, self.OnUpdateMainAllianceRedCount)
end

function UIMainLeft:OnRemoveListener()
  self:RemoveUIListener(EventId.PostLayoutSizeChanged, self.OnLayoutSizeChanged)
  self:RemoveUIListener(EventId.OnClaimCollectRewardSucc, self.ShowCollectRewardFlyEff)
  self:RemoveUIListener(EventId.LWSeasonWeatherInfoUpdate, self.SeasonWeatherInfoUpdate)
  self:RemoveUIListener(EventId.SeasonHunterBattleStatus, self.SeasonWeatherInfoUpdate)
  self:RemoveUIListener(EventId.SeasonHunterGetActivityInfo, self.SeasonWeatherInfoUpdate)
  self:RemoveUIListener(EventId.OnEnterCrossServer, self.SeasonWeatherInfoUpdate)
  self:RemoveUIListener(EventId.OnQuitCrossServer, self.SeasonWeatherInfoUpdate)
  self:RemoveUIListener(EventId.OnSetCrossID, self.SeasonWeatherInfoUpdate)
  self:RemoveUIListener(EventId.PushBloodQueenNextRound, self.SeasonWeatherInfoUpdate)
  self:RemoveUIListener(EventId.BattlefieldActStateChanged, self.OnBattlefieldActStateChanged)
  self:RemoveUIListener(EventId.UpdateMainAllianceRedCount, self.OnUpdateMainAllianceRedCount)
  base.OnRemoveListener(self)
end

function UIMainLeft:ComponentDefine()
  self.playerObj = self:AddComponent(UIMainPlayerObj, player_obj_path)
  self.view:RegisterFunctionUnlock(LWFunctionUnlockType.MainUI_PlayerInfo, self.playerObj.player_btn.gameObject)
  self.view:RegisterFunctionUnlock(LWFunctionUnlockType.MainUI_PlayerInfo, self.playerObj.stamina_root.gameObject)
  self.troop_obj = self:AddComponent(UIMainTroops, troop_obj_path)
  self.troopListObj = self:AddComponent(UITroopsList, troop_list_obj_path)
  self.troop_obj:SetActive(false)
  self.troopListObj:SetActive(false)
  self.build_queue = self:AddComponent(UIBuildQueue, build_queue_path)
  self.build_queue:ReInit()
  self.layout = self:AddComponent(UIHorizontalOrVerticalLayoutGroup, layout_path)
  self.vip = self:AddComponent(UIMainVipBtn, vip_path)
  self.vip:RefreshVIP()
  self.science_queue = self:AddComponent(UIScienceQueue, science_queue_path)
  self.science_queue:ReInit()
  self.saveGirlBubble = self:AddComponent(UIMainArmedUpgradeWarningBubbleCtrl, save_girl_warning_path)
  self.cityEvent = self:AddComponent(UIMainCityEvent, cityEvent_path)
end

function UIMainLeft:ComponentDestroy()
  self.playerObj = nil
  if self.epidemicReq ~= nil then
    self.epidemicReq:Destroy()
    self.epidemicReq = nil
  end
  self.enter_epidemic_battle = nil
  if self.winterReq ~= nil then
    self.winterReq:Destroy()
    self.winterReq = nil
  end
  self.enter_winter_storm = nil
  if self.dragonReq ~= nil then
    self.dragonReq:Destroy()
    self.dragonReq = nil
  end
  self.enter_dragon_battle = nil
  if self.dsbDuelReq ~= nil then
    self.dsbDuelReq:Destroy()
    self.dsbDuelReq = nil
  end
  self.enter_dsb_duel_battle = nil
  self.troop_obj = nil
  self.troopListObj = nil
  self.vip = nil
  self.saveGirlBubble = nil
  self.cityEvent = nil
end

function UIMainLeft:DataDefine()
end

function UIMainLeft:DataDestroy()
end

function UIMainLeft:ReInit()
  self.playerObj:ReInit()
  self.troop_obj:ReInit()
  self.saveGirlBubble:ReInit()
  self.cityEvent:ReInit()
end

function UIMainLeft:OnLayoutSizeChanged(data)
  if data ~= nil and data.t == LayoutSizeChangeType.MainUIResourceBar and data.h ~= nil then
    local height = toInt(data.h)
    if 164 < height and SceneUtils.GetIsInWorld() then
      local seasonType = SeasonUtil.GetSeasonType()
      if seasonType == SeasonMapType.Darkness then
        height = height + 7
      end
      self.layout:SetPaddingTop(height - 164 + 15)
      CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.layout.rectTransform)
    end
    self.layout_size_height = 0
  end
end

function UIMainLeft:Update1000MS()
  if self.weatherObj and self.layout then
    local x, y = self.layout.rectTransform:Get_sizeDelta()
    if self.layout_size_height ~= y then
      self.layout_size_height = y
      if self.troop_obj and 100 < y then
        self.troop_obj:SetLocalPositionXYZ(86, -30 - (y - 100) / 2, 0)
      end
    end
  end
end

function UIMainLeft:GetPlayerLevelPos()
  return self.playerObj.player_level.gameObject.transform.position
end

function UIMainLeft:GetBuildQueuePos()
  return self.build_queue.gameObject.transform.position
end

function UIMainLeft:GetSaveGirlWarningPos()
  if self.saveGirlBubble then
    return self.saveGirlBubble.gameObject.transform.position
  end
  return nil
end

function UIMainLeft:OnEnterWorld(data)
  self.troop_obj:SetActive(true)
  self.troopListObj:SetActive(true)
  self.build_queue:SetActive(false)
  self.science_queue:SetActive(false)
  self.vip:SetActive(false)
  self.saveGirlBubble:SetActiveLogic(false)
  self.cityEvent:ReInit()
  self:ShowOrHideWeather(true)
  self:CheckDragonEnter()
  self:CheckWinterStormEnter()
  self:CheckEpidemicEnter()
  self:CheckDsbDuelEnter()
end

function UIMainLeft:OnEnterCity(data)
  self.troop_obj:SetActive(false)
  self.troopListObj:SetActive(false)
  self.build_queue:SetActive(true)
  self.build_queue:ReInit()
  self.science_queue:SetActive(true)
  self.science_queue:ReInit()
  self.vip:SetActive(true)
  self.vip:RefreshVIP()
  self.saveGirlBubble:ReInit()
  self.cityEvent:ReInit()
  self:ShowOrHideWeather(false)
  self:CheckDragonEnter()
  self:CheckWinterStormEnter()
  self:CheckEpidemicEnter()
  self:CheckDsbDuelEnter()
end

function UIMainLeft:AddCurMarchList()
  if self.troop_obj ~= nil then
    self.troop_obj:AddCurMarchList()
  end
end

function UIMainLeft:IsTroopListShow()
  return self.troopListObj ~= nil and self.troopListObj:GetActive()
end

function UIMainLeft:UpdateLod(lod)
  self.lodCache = lod
end

function UIMainLeft:SetTroopListShow(show, loopListIndex)
  if show and self.lodCache <= 3 then
    if loopListIndex == 1 then
      self.troopListObj:ShowMarchItemList()
    elseif loopListIndex == 2 then
      self.troopListObj:ShowDetectItemList()
    end
  else
    if loopListIndex == 1 then
      self.troopListObj:HideMarchItemList()
    elseif loopListIndex == 2 then
      self.troopListObj:HideDetectItemList()
    end
    self.view.ctrl:SetSelectFormationUuid(0)
    self.view:HideAllShowTip()
  end
end

function UIMainLeft:IsTroopListShow()
  return self.troopListObj ~= nil and self.troopListObj:GetActive()
end

function UIMainLeft:HideAllShowTip()
  self.troopListObj:HideAllShowTip()
end

function UIMainLeft:ShowFormationRallyTip(x, y, dataInfo)
  self.troopListObj:ShowFormationRallyTip(x, y, dataInfo)
end

function UIMainLeft:OnSelectClick(uuid)
  self.troopListObj:OnSelectClick(uuid)
end

function UIMainLeft:ShowFormationCreateTip(x, y, dataInfo)
  self.troopListObj:ShowFormationCreateTip(x, y, dataInfo)
end

function UIMainLeft:OnAtkClick(uuid)
  self.troopListObj:OnAtkClick(uuid)
end

function UIMainLeft:OnCreateClick(uuid)
  self.troopListObj:OnCreateClick(uuid)
end

function UIMainLeft:OnEditClick(uuid, needAutoAdd)
  self.troopListObj:OnEditClick(uuid, needAutoAdd)
end

function UIMainLeft:GetTimeInFormation(uuid)
  return self.troopListObj:GetTimeInFormation(uuid)
end

function UIMainLeft:OnClickStartInvestigate(targetPointId)
  self.troopListObj:OnClickStartInvestigate(targetPointId)
end

function UIMainLeft:ResetScoutSelectTipPosition(posX, posY)
  return self.troopListObj:ResetScoutSelectTipPosition(posX, posY)
end

function UIMainLeft:OnClickScoutTroopItem(formationIndex)
  return self.troopListObj:OnClickScoutTroopItem(formationIndex)
end

function UIMainLeft:GetScoutTroopUnlockLv(formationIndex)
  return self.troopListObj:GetScoutTroopUnlockLv(formationIndex)
end

function UIMainLeft:ShowFormationArmyTip(x, y, dataInfo)
  self.troopListObj:ShowFormationArmyTip(x, y, dataInfo)
end

function UIMainLeft:ShowCollectRewardFlyEff(rewards)
  self.troop_obj:PlayCollectRewardFlyEff(rewards)
end

function UIMainLeft:ShowOrHideWeather(isWorld)
  if isWorld then
    local isInSeason = SeasonUtil.IsInSeason(false)
    local seasonType = SeasonUtil.GetSeasonType()
    if isInSeason and seasonType == SeasonMapType.Snow and DataCenter.SeasonSnowStormDataManager:NeedShowBlizzardInMainUI() then
      self:ShowWeather(WeatherObjectInfo.SnowStorm)
      return
    elseif isInSeason and seasonType == SeasonMapType.Darkness and DataCenter.BloodyNightDataManager:GetBloodyNightState() ~= BloodyNightState.None then
      if DataCenter.SeasonHunterManager:IsBattleBegin() then
        self:ShowWeather(WeatherObjectInfo.Hunter)
      else
        self:ShowWeather(WeatherObjectInfo.BloodyMoon)
      end
      return
    elseif not isInSeason and seasonType ~= SeasonMapType.Nothing and DataCenter.OffSeason1QueenOfBloodManager:ShowQueenOfBloodRound() then
      self:ShowWeather(WeatherObjectInfo.QueenOfBlood)
      return
    end
    if seasonType ~= SeasonMapType.Nothing then
      DataCenter.SeasonWeatherManager:TryRequestData()
      if DataCenter.SeasonWeatherManager:CanShowUI() then
        self:ShowWeather(WeatherObjectInfo.SeasonWeather)
        return
      end
      if seasonType == SeasonMapType.Darkness then
        self:ShowWeather(WeatherObjectInfo.BloodyMoon)
        return
      end
    end
  end
  self:HideWeather()
end

function UIMainLeft:ShowWeather(objectInfo)
  if not objectInfo then
    return
  end
  if self.weatherObj then
    if self.weatherObj.objectType == objectInfo.type then
      self.weatherObj:Refresh()
      return
    else
      self:HideWeather()
    end
  end
  if not self.weatherObjReq then
    self.weatherObjReq = self:GameObjectInstantiateAsync(objectInfo.path, function(req)
      local gameObject = req.gameObject
      if IsNull(gameObject) then
        return
      end
      local transform = gameObject.transform
      gameObject:SetActive(true)
      transform:SetParent(self.layout.transform)
      transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
      transform:SetSiblingIndex(0)
      local name = gameObject.name
      self.weatherObj = self.layout:AddComponent(require(objectInfo.script), name)
      self.weatherObj.objectType = objectInfo.type
      self.weatherObj:Refresh()
      local param = {}
      param.t = LayoutSizeChangeType.MainUIResourceBar
      
      function param.f(width, height)
        self:OnLayoutSizeChanged({
          t = LayoutSizeChangeType.MainUIResourceBar,
          w = width,
          h = height
        })
      end
      
      self.layout_size_height = 0
      EventManager:GetInstance():Broadcast(EventId.QueryLayoutSize, param)
    end)
  end
end

function UIMainLeft:HideWeather()
  if self.weatherObj then
    local objInfo = WeatherObjectInfo[self.weatherObj.objectType]
    if objInfo then
      self.layout:RemoveComponents(require(objInfo.script))
    end
    self.weatherObj = nil
  end
  if self.weatherObjReq then
    self.weatherObjReq:Destroy()
    self.weatherObjReq = nil
  end
  self.layout_size_height = 0
  self.troop_obj:SetLocalPositionXYZ(86, -30, 0)
  self.layout:SetPaddingTop(0)
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.layout.rectTransform)
end

function UIMainLeft:SeasonWeatherInfoUpdate()
  if self.whenWeatherInfoUpdate == true then
    return
  end
  self.whenWeatherInfoUpdate = true
  self:ShowOrHideWeather(SceneUtils.GetIsInWorld())
  self.whenWeatherInfoUpdate = false
end

function UIMainLeft:UpdateWhenAnim(animName)
  local stackCount = UIManager:GetInstance():GetStackWindowCount()
  if 1 < stackCount and animName ~= UIMainAnimType.AllShow or animName == UIMainAnimType.AllHide then
    if self.enter_dragon_battle then
      self.enter_dragon_battle:SetActive(false)
    end
    if self.enter_dsb_duel_battle then
      self.enter_dsb_duel_battle:SetActive(false)
    end
    if self.enter_winter_storm then
      self.enter_winter_storm:SetActive(false)
    end
    if self.enter_epidemic_battle then
      self.enter_epidemic_battle:SetActive(false)
    end
  else
    self:CheckDragonEnter()
    self:CheckWinterStormEnter()
    self:CheckEpidemicEnter()
    self:CheckDsbDuelEnter()
  end
end

function UIMainLeft:CheckWinterStormEnter()
  if self.enter_winter_storm then
    self.enter_winter_storm:Refresh()
    return
  end
  if self.winterReq ~= nil then
    return
  end
  local remainTime = DataCenter.ActWinterStormManager:GetInBattleWorldLeftTime()
  if remainTime <= 0 then
    return
  end
  local request = Resource:InstantiateAsync("Assets/Main/Prefabs/UI/ActivityCenter/WinterStorm/LWWinterStormBack.prefab")
  self.winterReq = request
  request:completed("+", function(req)
    local _go = req.gameObject
    if IsNull(_go) then
      if self.winterReq ~= nil then
        self.winterReq:Destroy()
        self.winterReq = nil
      end
      return
    end
    _go.name = enter_winter_storm_path
    local pTF = _go.transform
    local pName = "EnterBattleField"
    local node = self.transform:Find(pName)
    pTF:SetParent(node)
    pTF:Set_localPosition(0, -100, 0)
    pTF:Set_localScale(1, 1, 1)
    self.enter_winter_storm = self:AddComponent(UIMainWinterStormBack, pName .. "/" .. enter_winter_storm_path)
    self.enter_winter_storm:Refresh()
  end)
end

function UIMainLeft:CheckDragonEnter()
  local canShow = DataCenter.ActDragonManager:CanShowEnter()
  if self.enter_dragon_battle then
    self.enter_dragon_battle:SetActive(canShow)
    if canShow then
      self.enter_dragon_battle:Refresh()
    end
    return
  end
  if not canShow or self.dragonReq ~= nil then
    return
  end
  local request = Resource:InstantiateAsync("Assets/Main/Prefabs/UI/LWMainUI/EnterDragonBattle.prefab")
  self.dragonReq = request
  request:completed("+", function(req)
    local _go = req.gameObject
    if IsNull(_go) then
      if self.dragonReq ~= nil then
        self.dragonReq:Destroy()
        self.dragonReq = nil
      end
      return
    end
    _go.name = enter_dragon_battle_path
    local pTF = _go.transform
    local pName = "EnterBattleField"
    local node = self.transform:Find(pName)
    pTF:SetParent(node)
    pTF:Set_localPosition(0, 0, 0)
    pTF:Set_localScale(1, 1, 1)
    self.enter_dragon_battle = self:AddComponent(UIEnterDragonBattle, pName .. "/" .. enter_dragon_battle_path)
    canShow = DataCenter.ActDragonManager:CanShowEnter()
    self.enter_dragon_battle:SetActive(canShow)
    if canShow then
      self.enter_dragon_battle:Refresh()
    end
  end)
end

function UIMainLeft:CheckEpidemicEnter()
  local canShow = DataCenter.ActEpidemicZoneManager:CanShowEnter()
  if self.enter_epidemic_battle then
    self.enter_epidemic_battle:SetActive(canShow)
    if canShow then
      self.enter_epidemic_battle:Refresh()
    end
    return
  end
  if not canShow or self.epidemicReq ~= nil then
    return
  end
  local request = Resource:InstantiateAsync("Assets/Main/Prefabs/UI/BF_Epidemic/Common/EnterEpidemicBattle.prefab")
  self.epidemicReq = request
  request:completed("+", function(req)
    local _go = req.gameObject
    if IsNull(_go) then
      if self.epidemicReq ~= nil then
        self.epidemicReq:Destroy()
        self.epidemicReq = nil
      end
      return
    end
    _go.name = enter_epidemic_battle_path
    local pTF = _go.transform
    local pName = "EnterBattleField"
    local node = self.transform:Find(pName)
    pTF:SetParent(node)
    pTF:Set_localPosition(0, 0, 0)
    pTF:Set_localScale(1, 1, 1)
    self.enter_epidemic_battle = self:AddComponent(UIEnterEpidemicBattle, pName .. "/" .. enter_epidemic_battle_path)
    canShow = DataCenter.ActEpidemicZoneManager:CanShowEnter()
    self.enter_epidemic_battle:SetActive(canShow)
    if canShow then
      self.enter_epidemic_battle:Refresh()
    end
  end)
end

function UIMainLeft:CheckDsbDuelEnter()
  local canShow = DataCenter.BattlefieldDsbDuelManager:CanShowEnter()
  if self.enter_dsb_duel_battle then
    self.enter_dsb_duel_battle:SetActive(canShow)
    if canShow then
      self.enter_dsb_duel_battle:Refresh()
    end
    return
  end
  if not canShow or self.dsbDuelReq ~= nil then
    return
  end
  local request = Resource:InstantiateAsync("Assets/Main/Prefabs/UI/BF_Dsb_Duel/Battlefield/EnterDsbDuelBattle.prefab")
  self.dsbDuelReq = request
  request:completed("+", function(req)
    local _go = req.gameObject
    if IsNull(_go) then
      if self.dsbDuelReq ~= nil then
        self.dsbDuelReq:Destroy()
        self.dsbDuelReq = nil
      end
      return
    end
    _go.name = enter_dsb_duel_path
    local pTF = _go.transform
    local pName = "EnterBattleField"
    local node = self.transform:Find(pName)
    pTF:SetParent(node)
    pTF:Set_localPosition(0, 0, 0)
    pTF:Set_localScale(1, 1, 1)
    self.enter_dsb_duel_battle = self:AddComponent(UIEnterDsbDuelBattle, pName .. "/" .. enter_dsb_duel_path)
    canShow = DataCenter.BattlefieldDsbDuelManager:CanShowEnter()
    self.enter_dsb_duel_battle:SetActive(canShow)
    if canShow then
      self.enter_dsb_duel_battle:Refresh()
    end
  end)
end

function UIMainLeft:OnBattlefieldActStateChanged()
  self:CheckDragonEnter()
  self:CheckWinterStormEnter()
  self:CheckEpidemicEnter()
  self:CheckDsbDuelEnter()
end

function UIMainLeft:OnUpdateMainAllianceRedCount()
  if not LuaEntry.Player:IsInAlliance() then
    if self.enter_dragon_battle then
      self.enter_dragon_battle:SetActive(false)
    end
    if self.enter_epidemic_battle then
      self.enter_epidemic_battle:SetActive(false)
    end
  end
end

function UIMainLeft:OnCrossServerMaxBtnClick()
  if self.enter_dragon_battle and self.enter_dragon_battle:IsSmallShow() then
    self.enter_dragon_battle:SetMaxShow()
  elseif self.enter_winter_storm and self.enter_winter_storm:IsSmallShow() then
    self.enter_winter_storm:SetMaxShow()
  elseif self.enter_epidemic_battle and self.enter_epidemic_battle:IsSmallShow() then
    self.enter_epidemic_battle:SetMaxShow()
  end
end

function UIMainLeft:IsAnyBattleFieldSmallShow()
  return (not self.enter_dragon_battle or not self.enter_dragon_battle:IsSmallShow()) and (not self.enter_winter_storm or not self.enter_winter_storm:IsSmallShow()) and self.enter_epidemic_battle and self.enter_epidemic_battle:IsSmallShow()
end

return UIMainLeft
