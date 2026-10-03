local Resource = CS.GameEntry.Resource
local Camera = CS.UnityEngine.Camera
local MobileTouchCamera = CS.BitBenderGames.MobileTouchCamera
local GameObject = CS.UnityEngine.GameObject
local DEFAULT_SEGMENT_LENGTH = 44
local ARMY_BIRTH_POSITION_Z = 15
local LWSeasonTowerEnemyLogic = BaseClass("LWSeasonTowerEnemyLogic")
local SkirmishSceneData = require("DataCenter.LWBattle.Logic.Skirmish.SkirmishSceneData")

local function DisableTrackEffects(modelGo)
  if IsNull(modelGo) then
    return
  end
  local allTransforms = modelGo:GetComponentsInChildren(typeof(CS.UnityEngine.Transform), true)
  if allTransforms == nil then
    return
  end
  for i = 0, allTransforms.Length - 1 do
    local trans = allTransforms[i]
    local go = trans and trans.gameObject or nil
    local goName = go and go.name or nil
    if go and not string.IsNullOrEmpty(goName) then
      local lowerName = string.lower(goName)
      if string.find(lowerName, "cheyin", 1, true) or string.find(lowerName, "lvdai", 1, true) or string.find(lowerName, "luntai", 1, true) then
        go:SetActive(false)
      end
    end
  end
end

function LWSeasonTowerEnemyLogic:__init()
  self.armyRoot = nil
  self.armyRootAnim = nil
  self.levelId = nil
  self.sceneId = nil
  self.armyRootReq = nil
  self.platoonGoList = {}
  self.heroReqList = {}
  self.qualitySlots = {}
  self.heroDataList = {}
  self.alive = false
  self.destroySounds = {}
  self.destroySoundsTimerList = {}
end

function LWSeasonTowerEnemyLogic:__delete()
  self.armyRoot = nil
  self.armyRootAnim = nil
  self.levelId = nil
  self.sceneId = nil
  self.armyRootReq = nil
  self.platoonGoList = {}
  self.heroReqList = {}
  self.qualitySlots = {}
  self.heroDataList = {}
  self.alive = false
  self.destroySounds = {}
  self.destroySoundsTimerList = {}
end

function LWSeasonTowerEnemyLogic:Init(param)
  self.param = param
  self.levelId = param.levelId
  self.sceneId = param.sceneId
  self.sceneIndex = param.sceneIndex
  self.sweeping = param.sweeping
  self:CreateHeroes()
end

function LWSeasonTowerEnemyLogic:CreateHeroes()
  self.sceneData = SkirmishSceneData.New()
  self.sceneData.MAX_MINION_PER_HERO = 0
  local sceneMeta = LocalController:instance():getLine(LuaEntry.Player:GetABTestTableName(TableName.LW_Scene), self.sceneId)
  local sceneName = sceneMeta.asset
  self.sceneData.sceneName = sceneName
  self.sceneData.enterType = self.param.enterType
  self.sceneData:InitData(true, true)
  self:CreateFakeEnemy(self.sceneIndex)
end

function LWSeasonTowerEnemyLogic:CreateFakeEnemy(sceneIndex)
  self:DestroyFakeEnemy()
  self:CreateFakeEnemyHeroData()
  self.armyRootReq = Resource:InstantiateAsync("Assets/Main/Prefabs/UI/LWUISeasonTower/ArmyRoot.prefab")
  self.armyRootReq:completed("+", function(request)
    local go = request.gameObject
    self.armyRoot = go
    self.alive = true
    local armyRootTransform = go.transform
    local pos = Vector3.New(0, 0, (sceneIndex - 1) * DEFAULT_SEGMENT_LENGTH + ARMY_BIRTH_POSITION_Z)
    armyRootTransform:Set_position(pos.x, 0, pos.z)
    armyRootTransform:Set_eulerAngles(0, 180, 0)
    armyRootTransform:Set_localScale(0.8, 0.8, 0.8)
    self.armyRootAnim = armyRootTransform:Find("Root"):GetComponent(typeof(CS.SimpleAnimation))
    self.platoonGoList = {}
    self.heroReqList = {}
    self.qualitySlots = {}
    for i = 1, ArmyFormationSlot.Dominator do
      local index = i + 5
      if i == ArmyFormationSlot.Dominator then
        index = PVPBattleSlot.EnemyDominator
        if not self.heroDataList[i] then
          goto lbl_195
        end
      end
      local platoonGo = armyRootTransform:Find("Root/PlatoonRoot" .. index)
      self.platoonGoList[i] = platoonGo
      local platoonTransform = platoonGo.transform
      platoonTransform:Set_localEulerAngles(ResetPosition.x, ResetPosition.y, ResetPosition.z)
      if i == ArmyFormationSlot.Dominator then
        platoonTransform:Set_localScale(0.8, 0.8, 0.8)
      else
        platoonTransform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
      end
      local localPosition = self.sceneData.platoonLocalPos[index]
      platoonTransform:Set_localPosition(localPosition.x, localPosition.y, localPosition.z)
      local sprite
      if i ~= ArmyFormationSlot.Dominator then
        local obj = CS.UnityEngine.GameObject("QualitySlot" .. index)
        obj.transform:SetParent(self.platoonGoList[i].transform, false)
        obj.transform:Set_localEulerAngles(90, 0, 0)
        obj.transform.localPosition = Vector3.New(0, 0.2, 0)
        obj.transform.localScale = Vector3.New(1.5, 1.5, 1)
        sprite = obj:AddComponent(typeof(CS.UnityEngine.SpriteRenderer))
        obj:SetActive(not self.sweeping)
        self.qualitySlots[i] = sprite
      end
      local hero = self.heroDataList[i]
      if hero then
        local path = hero.appearanceMeta.model_path
        self.heroReqList[i] = Resource:InstantiateAsync(path)
        self.heroReqList[i]:completed("+", function(request)
          local gameObject = request.gameObject
          local transform = gameObject.transform
          transform:SetParent(self.platoonGoList[i].transform)
          transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
          transform:Set_localEulerAngles(ResetPosition.x, ResetPosition.y, ResetPosition.z)
          transform:Set_localPosition(0, 0, 0)
          local appearanceMeta = self.heroDataList[i].appearanceMeta
          transform:Set_localScale(appearanceMeta.model_size, appearanceMeta.model_size, appearanceMeta.model_size)
          DisableTrackEffects(gameObject)
          local animator = gameObject:GetComponentInChildren(typeof(CS.SimpleAnimation))
          if not IsNull(animator) then
            animator:Play(AnimName.Idle)
          end
        end)
        if sprite then
          sprite:LoadSprite(string.format("Assets/Main/Sprites/UI/UILWHeroSquad/zyf_biandui_dige_%d.png", hero.meta.quality))
        end
      elseif sprite then
        sprite:LoadSprite("Assets/Main/Sprites/UI/UILWHeroSquad/zyf_biandui_dige_kong.png")
      end
      ::lbl_195::
    end
  end)
end

function LWSeasonTowerEnemyLogic:DestroyFakeEnemy()
  self.alive = false
  if self.heroDataList then
    for k, v in pairs(self.heroDataList) do
      self.heroDataList[k]:Delete()
    end
    self.heroDataList = nil
  end
  if self.heroReqList then
    for k, v in pairs(self.heroReqList) do
      self.heroReqList[k]:Destroy()
    end
    self.heroReqList = nil
  end
  self.platoonGoList = nil
  if self.armyRootReq then
    self.armyRootReq:Destroy()
    self.armyRootReq = nil
  end
  if self.qualitySlots then
    for _, v in pairs(self.qualitySlots) do
      if not IsNull(v) then
        CS.UnityEngine.GameObject.Destroy(v.gameObject)
      end
    end
    self.qualitySlots = nil
  end
  if self.destroyTimer then
    self.destroyTimer:Stop()
    self.destroyTimer = nil
  end
  self:ReleaseDestroySound()
end

function LWSeasonTowerEnemyLogic:CreateFakeEnemyHeroData()
  self.heroDataList = {}
  local lwArmyTemplate = DataCenter.LWSeasonTowerArmyTemplateManager:GetArmyTemplate(self.param.levelId)
  if not lwArmyTemplate then
    return
  end
  for i = 1, ArmyFormationSlot.Dominator do
    local armyData = lwArmyTemplate.line_up[i]
    if armyData and armyData.heroData then
      self.heroDataList[i] = HeroInfo.New()
      self.heroDataList[i]:UpdateFromMailData(armyData.heroData.metaId, armyData.heroData.level, {}, armyData.heroData.weaponLevel)
    end
  end
end

function LWSeasonTowerEnemyLogic:ExecuteDestroyAnim(level, levelFloor)
  self.alive = false
  if self.armyRootAnim == nil then
    self:DestroyFakeEnemy()
    return
  end
  local index = (self.sceneIndex - 1) % 3
  local name = "Level" .. index + 1
  self.armyRootAnim:Play(name)
  self:PlayDestroySound()
  EventManager:GetInstance():Broadcast(EventId.SeasonTowerDestroyEnemy, {level = level, levelFloor = levelFloor})
  if self.destroyTimer then
    self.destroyTimer:Stop()
    self.destroyTimer = nil
  end
  self.destroyTimer = TimerManager:GetInstance():DelayInvoke(function()
    self:DestroyFakeEnemy()
  end, self.armyRootAnim:GetClipLength(name))
end

function LWSeasonTowerEnemyLogic:PlayDestroySound()
  self.destroySoundsTimerList = {}
  self.destroySounds = {}
  for i = 1, 6 do
    local index = i
    self.destroySoundsTimerList[index] = TimerManager:GetInstance():DelayInvoke(function()
      self.destroySounds[index] = DataCenter.LWSoundManager:PlaySound(SeasonTowerConfig.Sound.HitBoom, false, true)
    end, 0.5 + i * 0.05)
  end
end

function LWSeasonTowerEnemyLogic:ReleaseDestroySound()
  for _, v in ipairs(self.destroySoundsTimerList) do
    v:Stop()
  end
  self.destroySoundsTimerList = {}
  for _, v in ipairs(self.destroySounds) do
    DataCenter.LWSoundManager:StopSound(v)
  end
  self.destroySounds = {}
end

function LWSeasonTowerEnemyLogic:ChangeSweepingState(sweeping)
  if not table.IsNullOrEmpty(self.qualitySlots) then
    for _, v in pairs(self.qualitySlots) do
      v.gameObject:SetActive(not sweeping)
    end
  end
end

return LWSeasonTowerEnemyLogic
