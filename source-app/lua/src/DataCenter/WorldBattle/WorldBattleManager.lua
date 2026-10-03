local Squad = require("Scene.LWWorldMarch.Squad")
local UnitManager = require("Scene.LWBattle.BarrageBattle.Unit.UnitManager")
local EffectObjManager = require("Scene.LWBattle.EffectObj.EffectObjManager")
local BulletManager = require("Scene.LWBattle.Bullet.BulletManager")
local DisplaySettings = require("DataCenter.WorldBattle.WorldBattleDisplaySettings")
local DominatorUtils = require("DataCenter.Dominator.Main.DominatorUtils")
local WorldBattleManager = BaseClass("WorldBattleManager")

function WorldBattleManager:__init()
  self.nextObjId = 1
  self.squads = {}
  
  function self.__onUpdateDisplayMode()
    self:UpdateDisplayMode()
  end
  
  EventManager:GetInstance():AddListener(EventId.WorldMarchUpdateDisplayMode, self.__onUpdateDisplayMode)
  EventManager:GetInstance():AddListener(EventId.EnterDragonWorld, self.OnEnterDragonWorld)
  EventManager:GetInstance():AddListener(EventId.QuitDragonWorld, self.OnExitDragonWorld)
  EventManager:GetInstance():AddListener(EventId.CheckTroopStateIcon, self.CheckTroopStateIconSignal)
  EventManager:GetInstance():AddListener(EventId.AfterWorldCameraLodChanged, self.OnLodUpdate)
end

function WorldBattleManager:__delete()
  EventManager:GetInstance():RemoveListener(EventId.WorldMarchUpdateDisplayMode, self.__onUpdateDisplayMode)
  EventManager:GetInstance():RemoveListener(EventId.EnterDragonWorld, self.OnEnterDragonWorld)
  EventManager:GetInstance():RemoveListener(EventId.QuitDragonWorld, self.OnExitDragonWorld)
  EventManager:GetInstance():RemoveListener(EventId.CheckTroopStateIcon, self.CheckTroopStateIconSignal)
  EventManager:GetInstance():RemoveListener(EventId.AfterWorldCameraLodChanged, self.OnLodUpdate)
  self.__onUpdateDisplayMode = nil
  self:Destroy()
end

function WorldBattleManager:Destroy()
  if self.updateTimer then
    UpdateManager:GetInstance():RemoveUpdate(self.updateTimer)
    self.updateTimer = nil
  end
  if self.bulletManager then
    self.bulletManager:Delete()
    self.bulletManager = nil
  end
  for _, v in pairs(self.squads) do
    v:Delete()
    ObjectPool:GetInstance():Save(v)
  end
  if self.unitMgr then
    self.unitMgr:Destroy()
    self.unitMgr = nil
  end
  if self.effectObjMgr then
    self.effectObjMgr:Delete()
    self.effectObjMgr = nil
  end
  self.squads = {}
  self.isInWorld = false
end

function WorldBattleManager:OnEnterWorld()
  self.nextObjId = 1
  DataCenter.LWBattleManager:SetCurBattleLogic(self)
  if self.updateTimer == nil then
    function self.updateTimer()
      self:OnUpdate()
    end
    
    UpdateManager:GetInstance():AddUpdate(self.updateTimer)
  end
  self.unitMgr = UnitManager.New(self)
  self.effectObjMgr = EffectObjManager.New(self)
  self.bulletManager = BulletManager.New(self)
  self.isInWorld = true
  DisplaySettings.Reset()
end

function WorldBattleManager:OnExitWorld()
  self:Destroy()
  if DataCenter.LWBattleManager:GetCurBattleType() == PVEType.World then
    DataCenter.LWBattleManager:SetCurBattleLogic()
  end
  self.isInWorld = false
end

function WorldBattleManager:OnEnterDragonWorld()
  DisplaySettings.Reset()
end

function WorldBattleManager:OnExitDragonWorld()
end

function WorldBattleManager:OnUpdate()
  if self.effectObjMgr then
    self.effectObjMgr:OnUpdate()
  end
  if self.bulletManager then
    self.bulletManager:OnUpdate()
  end
  if CS.SceneManager.World then
    DisplaySettings.SetWorldZoom(CS.SceneManager.World.Zoom)
  end
end

function WorldBattleManager:CreateSquad(uuid, parent, collider)
  local isOn = LuaEntry.DataConfig:CheckSwitch("WorldMarch_DelayCreateSquad")
  if isOn then
    local display = DisplaySettings.RealSquadLevel(DisplaySettings.Levels.High)
    if self.lod and self.lod > 2 or display <= 1 then
      self:CreateSlimSquad(uuid, parent, collider)
    else
      self:CreateDetailSquad(uuid, parent, collider)
    end
  else
    self:CreateDetailSquad(uuid, parent, collider)
  end
end

function WorldBattleManager:CreateDetailSquad(uuid, parent, collider)
  if not self.isInWorld then
    return
  end
  local objId = self:GetNextObjId()
  local allHeroes = {}
  local tacticalWeaponInfo, tacticalWeaponAppearance
  local formation = require("Scene.LWWorldMarch.Formation")
  local marchInfo = CS.SceneManager.World:GetMarch(uuid)
  if marchInfo then
    if marchInfo:GetMarchType() == NewMarchType.ASSEMBLY_MARCH then
      for i = 0, marchInfo.armyInfos.Count - 1 do
        local csHeroData = marchInfo.armyInfos[i].HeroInfos
        local leaderHero
        for j = 0, csHeroData.Count - 1 do
          local heroData = csHeroData[j]
          local idx = heroData.index
          if not (idx >= ArmyFormationSlot.Dominator) and (leaderHero == nil or leaderHero.heroQuality < csHeroData[j].heroQuality) then
            leaderHero = csHeroData[j]
          end
        end
        if leaderHero ~= nil then
          local heroInfo = {}
          heroInfo.heroId = leaderHero.heroId
          heroInfo.meta = DataCenter.HeroTemplateManager:GetTemplate(leaderHero.heroId)
          local weaponLevel = leaderHero.weaponLevel or 0
          local modelAssetPath, appearanceId = HeroUtils.GetHeroModelData(heroInfo.heroId, HeroModelType.World, weaponLevel, leaderHero.skinId)
          heroInfo.appearanceMeta = DataCenter.AppearanceTemplateManager:GetTemplate(appearanceId)
          heroInfo.modelAssetPath = modelAssetPath
          heroInfo.isLeader = i == 0
          allHeroes[i + 1] = heroInfo
        end
      end
      formation = require("Scene.LWWorldMarch.AssemblyFormation")
    else
      local armyInfo = marchInfo.armyInfos[0]
      if not armyInfo then
        return
      end
      local csHeroData = armyInfo.HeroInfos
      local leaderIdx
      for i = 0, csHeroData.Count - 1 do
        local heroData = csHeroData[i]
        local index = heroData.index
        if index >= ArmyFormationSlot.Dominator then
          do
            local dominatorInfo = heroData.dominatorInfo
            local heroInfo = DominatorUtils.DominatorIdToHeroInfo(dominatorInfo.dominatorId, dominatorInfo.dominatorRank)
            if heroInfo then
              allHeroes[ArmyFormationSlot.Dominator] = heroInfo
            end
          end
        else
          local heroId = heroData.heroId
          local heroInfo = {}
          heroInfo.heroId = heroId
          heroInfo.quality = heroData.heroQuality
          heroInfo.meta = DataCenter.HeroTemplateManager:GetTemplate(heroId)
          local weaponLevel = heroData.weaponLevel or 0
          local modelAssetPath, appearanceId = HeroUtils.GetHeroModelData(heroId, HeroModelType.World, weaponLevel, heroData.skinId)
          heroInfo.appearanceMeta = DataCenter.AppearanceTemplateManager:GetTemplate(appearanceId)
          heroInfo.modelAssetPath = modelAssetPath
          allHeroes[index] = heroInfo
          if leaderIdx == nil or allHeroes[leaderIdx].quality < heroInfo.quality then
            leaderIdx = index
          end
        end
      end
      if leaderIdx ~= nil then
        allHeroes[leaderIdx].isLeader = true
      end
      local csWeaponData = armyInfo.WeaponInfo
      if csWeaponData and 0 < csWeaponData.weaponId then
        local weaponId = csWeaponData.weaponId
        local level = csWeaponData.weaponLevel or 1
        local template = DataCenter.TacticalWeaponTemplateManager:GetTemplate(weaponId)
        if template ~= nil then
          local levelTemplate = DataCenter.TacticalWeaponLevelTemplateManager:GetTemplateByLevel(level)
          if levelTemplate ~= nil then
            tacticalWeaponInfo = TacticalWeaponInfo.New()
            tacticalWeaponInfo:CreateFromTemplate(weaponId, level)
          end
        end
      end
      tacticalWeaponAppearance = DataCenter.TacticalWeaponManager:GetWeaponAppearanceData(tacticalWeaponInfo, armyInfo.weaponSkinId)
    end
  else
    marchInfo = DataCenter.ArmyFormationDataManager:GetOneArmyInfoByUuid(uuid)
    if marchInfo ~= nil then
      local heroes = marchInfo:GetAllHeroes()
      for slotIndex, heroUuid in pairs(heroes) do
        if slotIndex >= ArmyFormationSlot.Dominator then
          do
            local dominatorInfo = DataCenter.DominatorDataManager:GetInfoByUuid(heroUuid)
            if dominatorInfo then
              local heroInfo
              if dominatorInfo then
                heroInfo = dominatorInfo:GetHeroInfo()
              end
              if heroInfo then
                allHeroes[ArmyFormationSlot.Dominator] = heroInfo
              end
            end
          end
        else
          local heroData = DataCenter.HeroDataManager:GetHeroByUuid(heroUuid)
          if heroData ~= nil then
            allHeroes[slotIndex] = heroData
          end
        end
      end
      tacticalWeaponInfo = DataCenter.TacticalWeaponManager:GetFirstWeaponInfo()
      tacticalWeaponAppearance = DataCenter.TacticalWeaponManager:GetWeaponAppearance(tacticalWeaponInfo.id)
    end
  end
  if marchInfo then
    local isMummyMarch = marchInfo.isMummyMarch
    local targetType = MarchTargetType.BACK_HOME
    if type(marchInfo.GetMarchTargetType) == "function" then
      targetType = marchInfo:GetMarchTargetType()
    end
    if targetType == MarchTargetType.BACK_HOME then
      isMummyMarch = false
    end
    local squad = self.squads[uuid]
    squad = squad or ObjectPool:GetInstance():Load(Squad)
    local animNameCache = squad.animNameCache
    local rewindCache = squad.rewindCache
    squad:Init(self, objId, marchInfo.ownerUid, allHeroes, formation, parent, 0.5, tacticalWeaponInfo, tacticalWeaponAppearance, DisplaySettings.Levels.High, collider, uuid)
    squad:OnCreate(isMummyMarch)
    self.squads[uuid] = squad
    EventManager:GetInstance():Broadcast(EventId.OnSquadCreated, uuid)
    if squad.isSlim then
      squad.isSlim = nil
      if animNameCache then
        squad:PlayAnim(animNameCache, rewindCache)
      end
    end
  end
end

function WorldBattleManager:CreateSlimSquad(uuid, parent, collider)
  if not self.isInWorld then
    return
  end
  local marchInfo = CS.SceneManager.World:GetMarch(uuid)
  if marchInfo == nil then
    marchInfo = DataCenter.ArmyFormationDataManager:GetOneArmyInfoByUuid(uuid)
  end
  if marchInfo then
    local squad = ObjectPool:GetInstance():Load(Squad)
    squad.isSlim = true
    squad.marchUuid = uuid
    squad.gameObject = CS.UnityEngine.GameObject("Squad")
    squad.gameObject.transform:SetParent(parent, false)
    squad.transform = squad.gameObject.transform
    squad.collider = collider
    squad.displayLevel = DisplaySettings.Levels.High
    self.squads[uuid] = squad
  end
end

function WorldBattleManager:GetSquad(uuid)
  return self.squads and self.squads[uuid] or nil
end

function WorldBattleManager:WorldSquadRefreshMummyMarchSkin(uuid)
  local squad = self:GetSquad(uuid)
  if squad then
    local marchInfo = CS.SceneManager.World:GetMarch(uuid)
    if marchInfo then
      local isMummyMarch = marchInfo.isMummyMarch
      local targetType = MarchTargetType.BACK_HOME
      if type(marchInfo.GetMarchTargetType) == "function" then
        targetType = marchInfo:GetMarchTargetType()
      end
      if targetType == MarchTargetType.BACK_HOME then
        isMummyMarch = false
      end
      squad:RefreshMummyMarchSkin(isMummyMarch)
    end
  end
end

function WorldBattleManager:AddUnit(unit)
  if self.unitMgr then
    self.unitMgr:AddUnit(unit)
  end
end

function WorldBattleManager:GetUnit(id)
  return self.unitMgr:GetUnit(id)
end

function WorldBattleManager:RemoveUnitTotal(unit)
  self.unitMgr:RemoveUnitTotal(unit)
end

function WorldBattleManager:ShowEffectObj(path, pos, rot, time, parent, type)
  if self.effectObjMgr then
    return self.effectObjMgr:ShowEffectObj(path, pos, rot, time, parent, type)
  end
end

function WorldBattleManager:RemoveEffectObj(id)
  self.effectObjMgr:RemoveEffectObj(id)
end

function WorldBattleManager:GetNextObjId()
  local nextObjId = self.nextObjId
  self.nextObjId = nextObjId + 1
  return nextObjId
end

function WorldBattleManager:PlayAnim(uuid, anim, rewind)
  if not self.isInWorld then
    return
  end
  if self.squads[uuid] then
    self.squads[uuid]:PlayAnim(anim, rewind)
  end
  if anim ~= "attack" then
    if self.effectObjMgr then
      self.effectObjMgr:ResetData()
    end
    if self.bulletManager then
      self.bulletManager:ResetData()
    end
  end
end

function WorldBattleManager:SetRotation(uuid, quat)
  if not self.isInWorld then
    return
  end
  if self.squads[uuid] then
    self.squads[uuid]:SetRotation(quat)
  end
end

function WorldBattleManager:Attack(uuid, quat, index)
  if not self.isInWorld then
    return
  end
  if self.squads[uuid] and DisplaySettings.PlayBattleSkills(self.squads[uuid].displayLevel) then
    self.squads[uuid]:Attack(quat, index)
  end
end

function WorldBattleManager:RemoveSquad(uuid)
  if not self.isInWorld then
    return
  end
  local squad = self.squads[uuid]
  if squad then
    squad:Destroy()
    ObjectPool:GetInstance():Save(squad)
    self.squads[uuid] = nil
  end
end

function WorldBattleManager:ShakeCameraWithParam()
end

function WorldBattleManager:DealDamage()
end

function WorldBattleManager:GetPVEType()
  return PVEType.World
end

function WorldBattleManager:UpdateDisplayMode()
  local display = DisplaySettings.RealSquadLevel(DisplaySettings.Levels.High)
  for _, v in pairs(self.squads) do
    if v.isSlim and self.lod and self.lod <= 2 and 1 < display then
      self:CreateDetailSquad(v.marchUuid, v.gameObject.transform.parent, v.collider)
    end
    v:UpdateDisplayMode()
  end
end

function WorldBattleManager.CheckTroopStateIconSignal(uuid)
  local self = DataCenter.WorldBattleManager
  local squad = self:GetSquad(uuid)
  local info = CS.SceneManager.World:GetMarch(uuid)
  if not squad or not info then
    return
  end
  squad:SetOnFire(info:GetIsBroken())
end

function WorldBattleManager.OnLodUpdate(lod)
  local self = DataCenter.WorldBattleManager
  if not self.squads then
    return
  end
  local display = DisplaySettings.RealSquadLevel(DisplaySettings.Levels.High)
  lod = toInt(lod) or 1
  self.lod = lod
  if self.lod <= 2 and 1 < display then
    for _, v in pairs(self.squads) do
      if v.isSlim then
        self:CreateDetailSquad(v.marchUuid, v.gameObject.transform.parent, v.collider)
      end
    end
  end
  for _, v in pairs(self.squads) do
    v:UpdateLod(lod)
  end
end

function WorldBattleManager:WorldSquadRefreshMeteorite(uuid)
  local squad = self:GetSquad(uuid)
  if squad then
    local marchInfo = CS.SceneManager.World:GetMarch(uuid)
    if marchInfo then
      if marchInfo then
        local crystalCount = marchInfo.crystal
        local nucleusCount = marchInfo.nucleus
        if 0 < crystalCount or 0 < nucleusCount then
          squad:ShowMeteoriteCount(crystalCount, nucleusCount)
        else
          squad:DestroyMeteoriteNode()
        end
      else
        squad:DestroyMeteoriteNode()
      end
    end
  end
end

local Prefab_PvpBattleDamageTip = "Assets/Main/Prefabs/UI/LWWorld/PvpBattleDamageTip.prefab"

function WorldBattleManager:OnHandlePvpBattleDamage(t)
  local pointId = t.pointId or 0
  local num = t.solider or 0
  local serverId = t.serverId
  local curServerId = LuaEntry.Player:GetCurServerId()
  if serverId == nil then
    serverId = curServerId
  elseif serverId ~= curServerId then
    return
  end
  local bubbleHandle = CS.GameEntry.Resource:InstantiateAsync(Prefab_PvpBattleDamageTip)
  bubbleHandle:completed("+", function(req)
    if req.isError then
      return
    end
    if not SceneUtils.GetIsInWorld() then
      req:Destroy()
      return
    end
    local go = req.gameObject
    local animRoot = go.transform:Find("bg")
    if animRoot then
      go.name = string.format("PvpBattleDamage_%s_%s", serverId, pointId)
      go.transform:SetParent(CS.SceneManager.World.DynamicObjNode)
      go.transform.position = SceneUtils.TileIndexToWorld(pointId, ForceChangeScene.World, serverId)
      animRoot.gameObject:SetActive(true)
      go:SetActive(true)
      local txt = go.transform:Find("bg/txt")
      local unity_txt_ex = txt.gameObject:GetComponent(typeof(CS.TextMeshProEx))
      if unity_txt_ex then
        unity_txt_ex.text = string.GetFormattedSeparatorNum(num)
      end
      TimerManager:GetInstance():DelayInvoke(function()
        if req ~= nil then
          req:Destroy()
        end
      end, 3)
    else
      req:Destroy()
    end
  end)
end

return WorldBattleManager
