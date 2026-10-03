local Resource = CS.GameEntry.Resource
local GameObject = CS.UnityEngine.GameObject
local LWSeasonTowerSquadLogic = BaseClass("LWSeasonTowerSquadLogic")
local SkirmishSceneData = require("DataCenter.LWBattle.Logic.Skirmish.SkirmishSceneData")
local ReadyEffect = "Assets/Main/Prefabs/UI/LWUISeasonTower/Effect/Prefab/Eff_S6_Runing_Ready.prefab"

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

function LWSeasonTowerSquadLogic:__init()
  self.param = nil
  self.sceneId = nil
  self.enterType = nil
  self.sweeping = false
  self.sceneData = nil
  self.squadRoot = nil
  self.platoonGoList = {}
  self.heroReqList = {}
  self.qualitySlots = {}
  self.heroDataList = {}
  self.vfxReq = nil
  self.vfxImpactReq = nil
  self.lastEffectPath = nil
  self.animatorList = {}
end

function LWSeasonTowerSquadLogic:__delete()
  self:DestroySquad()
  self.param = nil
  self.sceneId = nil
  self.enterType = nil
  self.sweeping = false
  self.sceneData = nil
  self.squadRoot = nil
  self.platoonGoList = {}
  self.heroReqList = {}
  self.qualitySlots = {}
  self.heroDataList = {}
  self.vfxReq = nil
  self.vfxImpactReq = nil
  self.lastEffectPath = nil
  self.animatorList = {}
end

function LWSeasonTowerSquadLogic:Init(param)
  self.param = param or {}
  self.sceneId = self.param.sceneId
  self.enterType = self.param.enterType
  self.sweeping = self.param.sweeping or false
  self:CreateSceneData()
  self:CreateSquad()
end

function LWSeasonTowerSquadLogic:CreateSceneData()
  self.sceneData = SkirmishSceneData.New()
  self.sceneData.MAX_MINION_PER_HERO = 0
  local sceneMeta = LocalController:instance():getLine(LuaEntry.Player:GetABTestTableName(TableName.LW_Scene), self.sceneId)
  self.sceneData.sceneName = sceneMeta.asset
  self.sceneData.enterType = self.enterType
  self.sceneData:InitData(true, true)
end

function LWSeasonTowerSquadLogic:GetRoot()
  return self.squadRoot
end

function LWSeasonTowerSquadLogic:CreateSquad()
  self:DestroySquad()
  self:CreateSquadHeroData()
  local go = GameObject("Squad")
  self.squadRoot = go
  local squadRootTransform = go.transform
  local pos = Vector3.New(0, 0, 0)
  squadRootTransform:Set_position(pos.x, 0, pos.z)
  squadRootTransform:Set_eulerAngles(0, 0, 0)
  squadRootTransform:Set_localScale(0.8, 0.8, 0.8)
  self.platoonGoList = {}
  self.heroReqList = {}
  self.qualitySlots = {}
  for i = 1, ArmyFormationSlot.Dominator do
    local index = i
    if i == ArmyFormationSlot.Dominator then
      index = PVPBattleSlot.SelfDominator
      if not self.heroDataList[i] then
        goto lbl_188
      end
    end
    local platoonGo = GameObject("PlatoonRoot" .. index)
    self.platoonGoList[i] = platoonGo
    local platoonTransform = platoonGo.transform
    platoonTransform:SetParent(squadRootTransform)
    if i == ArmyFormationSlot.Dominator then
      platoonTransform:Set_localScale(0.8, 0.8, 0.8)
    else
      platoonTransform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
    end
    platoonTransform:Set_localEulerAngles(ResetPosition.x, ResetPosition.y, ResetPosition.z)
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
        if self.platoonGoList == nil or self.platoonGoList[i] == nil or self.heroDataList == nil or self.heroDataList[i] == nil then
          return
        end
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
        table.insert(self.animatorList, animator)
        if not IsNull(animator) and animator:GetState(AnimName.Idle) then
          animator:Play(AnimName.Idle)
        end
      end)
      if sprite then
        sprite:LoadSprite(string.format("Assets/Main/Sprites/UI/UILWHeroSquad/zyf_biandui_dige_%d.png", hero.meta.quality))
      end
    elseif sprite then
      sprite:LoadSprite("Assets/Main/Sprites/UI/UILWHeroSquad/zyf_biandui_dige_kong.png")
    end
    ::lbl_188::
  end
end

function LWSeasonTowerSquadLogic:PlayRunAnim()
  for i, animator in ipairs(self.animatorList) do
    if not IsNull(animator) and animator:GetState(AnimName.Run) then
      animator:Play(AnimName.Run)
    end
  end
end

function LWSeasonTowerSquadLogic:PlayIdleAnim()
  for i, animator in ipairs(self.animatorList) do
    if not IsNull(animator) and animator:GetState(AnimName.Idle) then
      animator:Play(AnimName.Idle)
    end
  end
end

function LWSeasonTowerSquadLogic:CreateSquadHeroData()
  self.heroDataList = {}
  local stageData = DataCenter.LWSeasonTowerManager:GetSelectStage()
  local squadData = DataCenter.LWSeasonTowerManager:GetFormation(stageData.stageId)
  local dominatorUuid = squadData:GetLocalDominatorUuid()
  if dominatorUuid and 0 < dominatorUuid then
    local dominatorInfo = DataCenter.DominatorManager:GetInfoByUuid(dominatorUuid)
    if dominatorInfo then
      self.heroDataList[ArmyFormationSlot.Dominator] = DeepCopy(dominatorInfo:GetHeroInfo())
    end
  end
  self.sceneData:InitData(dominatorUuid and 0 < dominatorUuid, true)
  local heroes = squadData:GetAllHeroes()
  for i = 1, ArmyFormationSlot.Dominator do
    if heroes[i] then
      self.heroDataList[i] = DeepCopy(DataCenter.HeroDataManager:GetHeroByUuid(heroes[i]))
    end
  end
end

function LWSeasonTowerSquadLogic:DestroySquad()
  self:ClearEffect()
  self:ClearReadyEffect()
  self:ClearImpactEffect()
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
  if self.platoonGoList then
    for i = 1, #self.platoonGoList do
      CS.UnityEngine.GameObject.Destroy(self.platoonGoList[i])
    end
    self.platoonGoList = nil
  end
  if self.squadRoot then
    CS.UnityEngine.GameObject.Destroy(self.squadRoot)
    self.squadRoot = nil
  end
  if self.qualitySlots then
    for _, v in pairs(self.qualitySlots) do
      if not IsNull(v) then
        CS.UnityEngine.GameObject.Destroy(v.gameObject)
      end
    end
    self.qualitySlots = nil
  end
end

function LWSeasonTowerSquadLogic:ClearEffect()
  if self.vfxReq then
    self.vfxReq:Destroy()
    self.vfxReq = nil
  end
end

function LWSeasonTowerSquadLogic:PlayEffect(effectPath, onComplete, force)
  if string.IsNullOrEmpty(effectPath) or self.squadRoot == nil then
    return
  end
  if self.lastEffectPath == effectPath and not force then
    return
  end
  self.lastEffectPath = effectPath
  self:ClearEffect()
  self:ClearReadyEffect()
  local req = Resource:InstantiateAsync(effectPath, ObjectPoolTag.Normal, AssetLoadPriority.High)
  self.vfxReq = req
  req:completed("+", function(request)
    if self.squadRoot == nil or self.vfxReq ~= request or request.gameObject == nil then
      return
    end
    local buffEffectObj = request.gameObject
    buffEffectObj:SetActive(false)
    buffEffectObj.transform:SetParent(self.squadRoot.transform)
    buffEffectObj.transform:Set_localPosition(0, 0, 0)
    buffEffectObj.transform:Set_localEulerAngles(0, 0, 0)
    buffEffectObj.transform:Set_localScale(1, 1, 1)
    local vfxCpts = buffEffectObj:GetComponentsInChildren(typeof(CS.UnityEngine.ParticleSystem))
    buffEffectObj:SetActive(true)
    for i = 0, vfxCpts.Length - 1 do
      vfxCpts[i]:Play()
    end
    if onComplete then
      onComplete()
    end
  end)
end

function LWSeasonTowerSquadLogic:ClearImpactEffect()
  if self.vfxImpactReq then
    self.vfxImpactReq:Destroy()
    self.vfxImpactReq = nil
  end
end

function LWSeasonTowerSquadLogic:PlayImpactEffect(effectPath)
  if string.IsNullOrEmpty(effectPath) or self.squadRoot == nil then
    return
  end
  self:ClearImpactEffect()
  local req = Resource:InstantiateAsync(effectPath, ObjectPoolTag.Normal, AssetLoadPriority.High)
  self.vfxImpactReq = req
  req:completed("+", function(request)
    if self.squadRoot == nil or self.vfxImpactReq ~= request or request.gameObject == nil then
      return
    end
    local buffEffectObj = request.gameObject
    buffEffectObj:SetActive(false)
    buffEffectObj.transform:SetParent(self.squadRoot.transform)
    buffEffectObj.transform:Set_localPosition(0, 0, 0)
    buffEffectObj.transform:Set_localEulerAngles(0, 0, 0)
    buffEffectObj.transform:Set_localScale(1, 1, 1)
    local vfxCpts = buffEffectObj:GetComponentsInChildren(typeof(CS.UnityEngine.ParticleSystem))
    buffEffectObj:SetActive(true)
    for i = 0, vfxCpts.Length - 1 do
      vfxCpts[i]:Play()
    end
  end)
end

function LWSeasonTowerSquadLogic:ChangeSweepingState(sweeping)
  self.sweeping = sweeping
  if not table.IsNullOrEmpty(self.qualitySlots) then
    for _, v in pairs(self.qualitySlots) do
      v.gameObject:SetActive(not sweeping)
    end
  end
end

function LWSeasonTowerSquadLogic:ClearReadyEffect()
  if self.readyEffectList then
    for _, v in pairs(self.readyEffectList) do
      v:Destroy()
    end
  end
  self.readyEffectList = {}
end

function LWSeasonTowerSquadLogic:ShowReadyEffect()
  self:ClearReadyEffect()
  for i, v in pairs(self.platoonGoList) do
    local hero = self.heroDataList[i]
    if hero then
      local req = Resource:InstantiateAsync(ReadyEffect, ObjectPoolTag.Normal, AssetLoadPriority.High)
      self.readyEffectList[i] = req
      req:completed("+", function(request)
        if request.gameObject == nil then
          return
        end
        local buffEffectObj = request.gameObject
        buffEffectObj:SetActive(false)
        buffEffectObj.transform:SetParent(v.transform)
        buffEffectObj.transform:Set_localPosition(0, 0, 0)
        buffEffectObj.transform:Set_localEulerAngles(0, 0, 0)
        buffEffectObj.transform:Set_localScale(1, 1, 1)
        local vfxCpts = buffEffectObj:GetComponentsInChildren(typeof(CS.UnityEngine.ParticleSystem))
        buffEffectObj:SetActive(true)
        for i = 0, vfxCpts.Length - 1 do
          vfxCpts[i]:Play()
        end
      end)
    end
  end
end

return LWSeasonTowerSquadLogic
