local WorldMarchTileUIManager = BaseClass("WorldMarchTileUIManager", Singleton)
local WorldMarchTileUI = require("Scene.WorldMarchTileUI.WorldMarchTileUI")
local ResourceManager = CS.GameEntry.Resource
local Localization = CS.GameEntry.Localization

local function __init(self)
  self.marchTileUI = nil
  self.isOnCreate = false
  self:AddListener()
end

local function __delete(self)
  self:RemoveListener()
  self.marchTileUI = nil
end

local function AddListener(self)
  EventManager:GetInstance():AddListener(EventId.ArmyFormatUpdate, self.OnUpdateMarchSignal)
  EventManager:GetInstance():AddListener(EventId.UpdateMarchItem, self.OnUpdateMarchSignal)
  EventManager:GetInstance():AddListener(EventId.WorldTroopGameObjectCreateFinish, self.OnWorldTroopCreate)
end

local function RemoveListener(self)
  EventManager:GetInstance():RemoveListener(EventId.ArmyFormatUpdate, self.OnUpdateMarchSignal)
  EventManager:GetInstance():RemoveListener(EventId.UpdateMarchItem, self.OnUpdateMarchSignal)
  EventManager:GetInstance():RemoveListener(EventId.WorldTroopGameObjectCreateFinish, self.OnWorldTroopCreate)
end

function WorldMarchTileUIManager:OnExitWorld()
  if self.marchTileUI ~= nil then
    self:RemoveTroop()
  end
end

local function RefreshTroop(self, marchUuid)
  local troop = CS.SceneManager.World:GetTroop(marchUuid)
  if troop == nil then
    return
  end
  local worldMarch = CS.SceneManager.World:GetMarch(marchUuid)
  if worldMarch == nil then
    return
  end
  if worldMarch:GetMarchType() ~= NewMarchType.RESOURCE_HELP then
    TroopNameLabelManager:GetInstance():RemoveOneEffect(marchUuid)
    if troop:IsBattle() then
      TroopHeadUIManager:GetInstance():ShowSelectCircle(marchUuid)
    else
      TroopHeadUIManager:GetInstance():ShowHeadUI(marchUuid, false)
    end
    WorldTroopAttackBuildIconManager:GetInstance():RemoveOneEffect(marchUuid)
  end
  if self.marchTileUI == nil and self.isOnCreate == false then
    local request = ResourceManager:InstantiateAsync(UIAssets.WorldMarchTileUI)
    self.isOnCreate = true
    request:completed("+", function()
      self.isOnCreate = false
      if request.isError then
        return
      end
      troop = CS.SceneManager.World:GetTroop(marchUuid)
      if troop == nil then
        request:Destroy()
        return
      end
      local transform = troop:GetTransform()
      if transform == nil then
        request:Destroy()
        return
      end
      request.gameObject:SetActive(true)
      request.gameObject.transform:SetParent(transform)
      request.gameObject.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
      request.gameObject.transform:Set_localPosition(ResetPosition.x, ResetPosition.y, ResetPosition.z)
      local tileUI = WorldMarchTileUI.New()
      tileUI:OnCreate(request)
      self.marchTileUI = tileUI
      self.marchTileUI:RefreshTroop(marchUuid)
      worldMarch = CS.SceneManager.World:GetMarch(marchUuid)
      if worldMarch ~= nil and (worldMarch:GetMarchType() == NewMarchType.GOLLOES_EXPLORE or worldMarch:GetMarchType() == NewMarchType.GOLLOES_TRADE) then
        request.gameObject:SetActive(false)
      end
    end)
  elseif self.marchTileUI ~= nil then
    local oldMarchUuid = self.marchTileUI:GetMarchUuid()
    if oldMarchUuid ~= nil and oldMarchUuid ~= marchUuid then
      local oldTroop = CS.SceneManager.World:GetTroop(oldMarchUuid)
      if oldTroop ~= nil then
        if oldTroop:IsBattle() == true then
          TroopHeadUIManager:GetInstance():HideSelectCircle(oldMarchUuid)
        elseif oldTroop:IsBattle() == false then
          TroopHeadUIManager:GetInstance():HideHeadUI(oldMarchUuid)
        end
        TroopNameLabelManager:GetInstance():CheckShowEffect(oldMarchUuid)
        WorldTroopAttackBuildIconManager:GetInstance():CheckShowEffect(oldMarchUuid)
        troop = CS.SceneManager.World:GetTroop(marchUuid)
        local request = self.marchTileUI.request
        if request == nil then
          return
        end
        if troop == nil then
          self.marchTileUI:ComponentDestroy()
          if request ~= nil then
            request:Destroy()
          end
          self.marchTileUI = nil
          return
        end
        local transform = troop:GetTransform()
        if transform == nil then
          self.marchTileUI:ComponentDestroy()
          if request ~= nil then
            request:Destroy()
          end
          self.marchTileUI = nil
          return
        end
        request.gameObject:SetActive(true)
        request.gameObject.transform:SetParent(transform)
        request.gameObject.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
        request.gameObject.transform:Set_localPosition(ResetPosition.x, ResetPosition.y, ResetPosition.z)
      end
    end
    self.marchTileUI:RefreshTroop(marchUuid)
  end
  EventManager:GetInstance():Broadcast(EventId.ShowFormationSelect, marchUuid)
end

local function ShowTroop(self, marchUuid)
  DataCenter.LWSoundManager:PlaySound(SoundAssetId.Music_Troop_Movement, false)
  self:RefreshTroop(marchUuid)
end

local function RemoveTroop(self, marchUuid)
  if self.marchTileUI ~= nil then
    if CS.WorldScene.selectMarchUuid == 0 and (not marchUuid or marchUuid == CS.SceneManager.World.TrackMarchId) then
      CS.SceneManager.World.marchUuid = 0
      CS.SceneManager.World:TrackMarch(0)
    end
    DataCenter.LWSoundManager:PlaySound(SoundAssetId.Music_Effect_Close, false)
    EventManager:GetInstance():Broadcast(EventId.HideFormationSelect, self.marchTileUI.marchUuid)
    local troop = CS.SceneManager.World:GetTroop(self.marchTileUI.marchUuid)
    if troop ~= nil and troop:IsBattle() == true then
      TroopHeadUIManager:GetInstance():HideSelectCircle(self.marchTileUI.marchUuid)
    elseif troop ~= nil and troop:IsBattle() == false then
      TroopHeadUIManager:GetInstance():HideHeadUI(self.marchTileUI.marchUuid)
    end
    TroopNameLabelManager:GetInstance():CheckShowEffect(self.marchTileUI.marchUuid)
    WorldTroopAttackBuildIconManager:GetInstance():CheckShowEffect(self.marchTileUI.marchUuid)
    local request = self.marchTileUI.request
    self.marchTileUI:ComponentDestroy()
    if request ~= nil then
      request:Destroy()
    end
    self.marchTileUI = nil
  end
end

local function RemoveTroopByUuid(self, marchUuid)
  if self.marchTileUI ~= nil and self.marchTileUI.marchUuid == marchUuid then
    self:RemoveTroop(marchUuid)
  end
end

local function OnUpdateMarchSignal()
  WorldMarchTileUIManager:GetInstance():UpdateMarch()
end

local function UpdateMarch(self)
  if self.marchTileUI ~= nil then
    self.marchTileUI:OnMarchUpdate()
  end
end

local function OnBtnClick(self, type, marchUuid)
  local info = CS.SceneManager.World:GetMarch(marchUuid)
  local infoLua = DataCenter.WorldMarchDataManager:GetMarch(marchUuid)
  if info == nil then
    info = infoLua
  end
  if info ~= nil then
    if info:GetIsBroken() then
      if BattleFieldUtil.InBattleField(BattleFieldType.WinterStorm) then
        UIUtil.ShowTipsId("winter_battlefield_interface_tips1067")
      else
        UIUtil.ShowTipsId(120004)
      end
    elseif type == WorldMarchTileBtnType.March_Attack then
      local army = CS.SceneManager.World:GetTroop(marchUuid)
      if army ~= nil then
        local pointId = SceneUtils.WorldToTileIndex(army:GetPosition())
        MarchUtil.OnClickStartMarch(MarchTargetType.ATTACK_ARMY, pointId, marchUuid)
      end
    elseif type == WorldMarchTileBtnType.March_ReinforceTrain then
      DataCenter.LWMyStationDataManager:TryReinforce()
    elseif type == WorldMarchTileBtnType.March_AttackTrain then
      local trainData = DataCenter.LWTrainDataManager:GetOneTrainByMarchUuid(marchUuid)
      RailwayUtil.ClickAttackTrain(trainData)
    elseif type == WorldMarchTileBtnType.March_AssistTrain then
      local army = CS.SceneManager.World:GetTroop(marchUuid)
      local march = CS.SceneManager.World:GetMarch(marchUuid)
      if army ~= nil and march ~= nil then
        local pointId = SceneUtils.WorldToTileIndex(army:GetPosition())
        MarchUtil.OnClickStartMarch(MarchTargetType.ASSIST_TRAIN, pointId, march.train.uuid)
      end
    elseif type == WorldMarchTileBtnType.March_ViewTroop then
      if info.ownerUid == LuaEntry.Player.uid then
        UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroPVPFormation, {anim = true}, EnterHeroSquadPanelWay.Marching, info.ownerFormationUuid)
      else
        UIManager:GetInstance():OpenWindow(UIWindowNames.UILWPlayerDetail, info.ownerUid)
      end
    elseif type == WorldMarchTileBtnType.March_ViewTrain then
    elseif type == WorldMarchTileBtnType.March_Rally then
    elseif type == WorldMarchTileBtnType.March_Callback then
      local langKey = GameDialogDefine.MARCH_CONFIRM_BACK_HOME
      local switch = LuaEntry.DataConfig:CheckSwitch("slide_left_return")
      if switch then
        MarchUtil.OnBackHome(marchUuid)
      else
        UIUtil.ShowMessage(Localization:GetString(langKey), 2, GameDialogDefine.CONFIRM, GameDialogDefine.CANCEL, function()
          MarchUtil.OnBackHome(marchUuid)
        end)
      end
    elseif type == WorldMarchTileBtnType.March_Rapid then
      local isLandlordCenterServerMarch = info.ownerCurServerId == DataCenter.LandlordMgr:GetCenterServerId() and DataCenter.LandlordMgr:GetActCurStage() == LLConst.LandlordStage.BATTLE
      if info.blackStartTime > 0 or isLandlordCenterServerMarch then
        UIUtil.ShowTipsId("march_speedup_tips")
      elseif BattleFieldUtil.InBattleField(BattleFieldType.EpidemicZone) then
        UIManager:GetInstance():OpenWindow(UIWindowNames.UIEpidemicBattleSpeed, {anim = true}, marchUuid)
      else
        UIManager:GetInstance():OpenWindow(UIWindowNames.UILWRapid, {anim = true}, ItemSpdMenu.ItemSpdMenu_Troop, marchUuid)
      end
    elseif type == WorldMarchTileBtnType.March_Stop then
    elseif type == WorldMarchTileBtnType.March_Scout or type == WorldMarchTileBtnType.March_ScoutTrain then
      local army = CS.SceneManager.World:GetTroop(marchUuid)
      if not army then
        return
      end
      local pointId = SceneUtils.WorldToTileIndex(army:GetPosition())
      local marchTargetType, uuid
      if type == WorldMarchTileBtnType.March_Scout then
        marchTargetType = MarchTargetType.SCOUT_TROOP
        uuid = marchUuid
      elseif type == WorldMarchTileBtnType.March_ScoutTrain then
        local march = CS.SceneManager.World:GetMarch(marchUuid)
        marchTargetType = MarchTargetType.SCOUT_TRAIN
        uuid = march.train.uuid
      end
      local needConfirm, status, title, content, needBreakProtect = DataCenter.StatusManager:ShowTipForWarFever()
      if needConfirm then
        if status ~= nil and title ~= nil then
          UIUtil.ShowSecondMessage(title, content, 2, "", "", function()
            MarchUtil.LaunchScout(marchTargetType, pointId, uuid)
          end, function(needSellConfirm)
            DataCenter.StatusManager:SetWarFeverConfirmFlag(needSellConfirm)
          end)
        else
          MarchUtil.LaunchScout(marchTargetType, pointId, uuid)
        end
      elseif needBreakProtect == true then
        UIUtil.ShowMessage(content, 1, GameDialogDefine.CONFIRM, GameDialogDefine.CANCEL, function()
          MarchUtil.LaunchScout(marchTargetType, pointId, uuid)
        end, function()
        end)
      else
        MarchUtil.LaunchScout(marchTargetType, pointId, uuid)
      end
    elseif type == WorldMarchTileBtnType.March_PlayerInfo then
      if MarchUtil.IsWerewolf(info) then
        UIUtil.ShowTipsId("season_s4_activity_1200011_desc7")
      else
        UIManager:GetInstance():OpenWindow(UIWindowNames.UILWPlayerDetail, info.ownerUid)
      end
    elseif type == WorldMarchTileBtnType.March_AttackZombieBusTrain then
      local busList = info:GetZombieBusList()
      local busCount = busList.Count
      if 0 < busCount then
        for i = busCount - 1, 0, -1 do
          local busData = busList[i]
          if busData and busData.isPass == 0 then
            local rotation = Quaternion.LookRotation(Vector3.New(info.MoveDir.x, info.MoveDir.y, info.MoveDir.z))
            local euler = rotation:ToEulerAngles()
            DataCenter.RadarCenterDataManager:ClickAttackWorldZombieBus(busData, i + 1, info.eventUuid, info.position, euler)
            break
          end
        end
      end
    end
  end
  self:RemoveTroop()
end

local function OnWorldTroopCreate(data)
  local marchUuid = tonumber(data)
  local marchInfo = CS.SceneManager.World:GetMarch(marchUuid)
  if not marchInfo then
    return
  end
  if marchInfo:GetMarchType() == NewMarchType.TRAIN or marchInfo:GetMarchType() == NewMarchType.ZONE_TRAIN then
    return
  end
  if marchInfo:GetMarchType() == NewMarchType.FLOWER_TRAIN then
    return
  end
  if marchInfo:GetMarchType() == NewMarchType.DETECT_ZOMBIE_BUS_TRAIN then
    return
  end
  if marchInfo:IsWanderBoss() or marchInfo:GetMarchType() == NewMarchType.ZONE_MOBILIZATION_BOSS then
    if marchInfo.isCameraFollow then
      CS.SceneManager.World:TrackMarch(marchInfo.uuid)
    end
    return
  end
  if CS.SceneManager.World.marchUuid == marchUuid then
    WorldMarchTileUIManager:GetInstance():ShowTroop(marchUuid)
  end
  if marchInfo.isCameraFollow then
    CS.SceneManager.World:TrackMarch(marchInfo.uuid)
    if not marchInfo:IsMonsterOrBoss() then
      WorldMarchTileUIManager:GetInstance():ShowTroop(marchUuid)
    end
  end
end

WorldMarchTileUIManager.__init = __init
WorldMarchTileUIManager.__delete = __delete
WorldMarchTileUIManager.ShowTroop = ShowTroop
WorldMarchTileUIManager.RemoveTroop = RemoveTroop
WorldMarchTileUIManager.UpdateMarch = UpdateMarch
WorldMarchTileUIManager.OnUpdateMarchSignal = OnUpdateMarchSignal
WorldMarchTileUIManager.AddListener = AddListener
WorldMarchTileUIManager.RemoveListener = RemoveListener
WorldMarchTileUIManager.OnBtnClick = OnBtnClick
WorldMarchTileUIManager.RemoveTroopByUuid = RemoveTroopByUuid
WorldMarchTileUIManager.RefreshTroop = RefreshTroop
WorldMarchTileUIManager.OnWorldTroopCreate = OnWorldTroopCreate
return WorldMarchTileUIManager
