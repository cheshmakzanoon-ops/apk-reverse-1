local DominatorTrainSceneManager = BaseClass("DominatorTrainSceneManager")
local Localization = CS.GameEntry.Localization
local RenderTextureFormat = CS.UnityEngine.RenderTextureFormat
local RenderTexture = CS.UnityEngine.RenderTexture
local ResourceManager = CS.GameEntry.Resource
local Camera = CS.UnityEngine.Camera
local Screen = CS.UnityEngine.Screen
local FSMachine = require("Common/FSMachine")
local Const = require("DataCenter/Dominator/Train/DominatorTrainSceneConstant")
local UnitManager = require("Scene.LWBattle.BarrageBattle.Unit.UnitManager")
local EffectObjManager = require("Scene.LWBattle.EffectObj.EffectObjManager")
local BulletManager = require("Scene.LWBattle.Bullet.BulletManager")
local BattleMember = require("DataCenter/Dominator/Train/DominatorTrainSceneBattleMember")
local IdleMember = require("DataCenter/Dominator/Train/DominatorTrainSceneIdleMember")
local Zombie = require("DataCenter/Dominator/Train/DominatorTrainSceneZombie")
DominatorTrainSceneManager.State = {
  None = 0,
  Battle = 1,
  Idle = 2
}

function DominatorTrainSceneManager:__init()
  self.unitMgr = UnitManager.New(self)
  self.effectObjMgr = EffectObjManager.New(self)
  self.bulletManager = BulletManager.New(self)
  self.curState = self.State.None
  self.nextObjId = 1
  self.param = nil
  self.sceneCamera = nil
  self.virtualCamera01 = nil
  self.virtualCamera02 = nil
  self.sceneRequest = nil
  self.idleMembers = nil
end

function DominatorTrainSceneManager:__delete()
  self:Destroy()
  self.curState = nil
  self.param = nil
end

function DominatorTrainSceneManager:Destroy()
  self:RemoveUpdateTimer()
  if self.fsm ~= nil then
    self.fsm:Dispose()
    self.fsm = nil
  end
  if self.bulletManager then
    self.bulletManager:Delete()
  end
  if self.unitMgr then
    self.unitMgr:Delete()
  end
  if self.effectObjMgr then
    self.effectObjMgr:Delete()
  end
  self:ReleaseScene()
  self:ReleaseTexture()
  DataCenter.CityLightManager:DecreaseDeactiveRef()
  self.sceneCamera = nil
  self.virtualCamera01 = nil
  self.virtualCamera02 = nil
end

function DominatorTrainSceneManager:Enter(param)
  if param == nil then
    return
  end
  if table.IsNullOrEmpty(param.uuidList) then
    return
  end
  self.param = param
  self.nextObjId = 1
  self.curState = self.State.None
  self.fsm = FSMachine.Create(self)
  self.fsm:Add(self.State.Idle, require("DataCenter/Dominator/Train/SceneState/DominatorTrainSceneIdleState").Create())
  self.fsm:Add(self.State.Battle, require("DataCenter/Dominator/Train/SceneState/DominatorTrainSceneBattleState").Create())
  self:LoadScene()
  self:SwitchToBattle()
  DataCenter.CityLightManager:AddDeactiveRef()
end

function DominatorTrainSceneManager:AddUpdateTimer()
  if self.updateTimer == nil then
    function self.updateTimer()
      self:OnUpdate()
    end
    
    UpdateManager:GetInstance():AddUpdate(self.updateTimer)
  end
end

function DominatorTrainSceneManager:RemoveUpdateTimer()
  if self.updateTimer then
    UpdateManager:GetInstance():RemoveUpdate(self.updateTimer)
    self.updateTimer = nil
  end
end

function DominatorTrainSceneManager:OnUpdate()
  if self.fsm then
    local deltaTime = Time.deltaTime
    self.fsm:Update(deltaTime)
  end
end

function DominatorTrainSceneManager:LoadScene()
  if self.sceneRequest ~= nil then
    if not IsNull(self.sceneRequest.gameObject) then
      self:OnSceneLoaded()
    else
    end
    return
  end
  local request = ResourceManager:InstantiateAsync(Const.SceneAssetPath)
  self.sceneRequest = request
  self.sceneRequest:completed("+", function()
    if request.isError then
      return
    end
    request.gameObject:SetActive(true)
    request.gameObject.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
    request.gameObject.transform:Set_position(Const.DefaultScenePos.x, Const.DefaultScenePos.y, Const.DefaultScenePos.z)
    local cameraTrans = request.gameObject.transform:Find("Camera")
    if not IsNull(cameraTrans) then
      local camera = cameraTrans:GetComponentInChildren(typeof(Camera))
      self.sceneCamera = camera
    end
    local virtualCamera01Trans = request.gameObject.transform:Find("VirtualCamera01")
    if not IsNull(virtualCamera01Trans) then
      self.virtualCamera01 = virtualCamera01Trans.gameObject
    end
    local virtualCamera02Trans = request.gameObject.transform:Find("VirtualCamera02")
    if not IsNull(virtualCamera02Trans) then
      self.virtualCamera02 = virtualCamera02Trans.gameObject
    end
    self:OnSceneLoaded()
  end)
end

function DominatorTrainSceneManager:OnSceneLoaded()
  self:SetSceneCameraActive(true)
  self:UpdateCameraAngle()
  self:AddUpdateTimer()
end

function DominatorTrainSceneManager:ReleaseScene()
  if self.sceneRequest ~= nil then
    self.sceneRequest:Destroy()
  end
  self.sceneRequest = nil
end

function DominatorTrainSceneManager:ReleaseTexture()
  if self.sceneCamera ~= nil then
    self.sceneCamera.targetTexture = nil
  end
  if self.renderTexture ~= nil then
    RenderTexture.ReleaseTemporary(self.renderTexture)
    self.renderTexture = nil
  end
end

function DominatorTrainSceneManager:ReleaseDominatorBattle()
  self.unitMgr:RemoveAllUnitByType(UnitType.Member)
end

function DominatorTrainSceneManager:ReloadDominatorBattle()
  if self.param == nil or table.IsNullOrEmpty(self.param.uuidList) then
    return
  end
  
  local function GetWorldPos(index)
    local totalCount = #self.param.uuidList
    local offsetData = Const.DominatorPosOffset[totalCount]
    if not offsetData then
      return nil
    end
    return offsetData[index] + Const.DefaultScenePos
  end
  
  local totalCount = #self.param.uuidList
  for i, v in ipairs(self.param.uuidList) do
    local index = i
    local dominatorInfo = DataCenter.DominatorManager:GetInfoByUuid(v)
    if dominatorInfo then
      local template = DataCenter.AppearanceTemplateManager:GetTemplate(dominatorInfo:GetAppearanceId())
      if template then
        local path = template.model_path
        if not string.IsNullOrEmpty(path) then
          local req = ResourceManager:InstantiateAsync(path)
          local objId = self:GetNextObjId()
          local worldPos = GetWorldPos(index)
          local member = ObjectPool:GetInstance():Load(BattleMember)
          member:Init(self, objId, req, index, dominatorInfo)
          member.curWorldPos = worldPos
          self:AddUnit(member)
          req:completed("+", function(request)
            if request.isError then
              return
            end
            member:OnCreate()
            request.gameObject.transform.position = worldPos
            if index == totalCount then
              self:OnDominatorBattleLoaded()
            end
          end)
        end
      end
    end
  end
end

function DominatorTrainSceneManager:ReleaseDominatorIdle()
  if self.idleMembers ~= nil then
    for i, v in pairs(self.idleMembers) do
      v:Destroy()
      ObjectPool:GetInstance():Save(v)
    end
    self.idleMembers = nil
  end
end

function DominatorTrainSceneManager:ReloadDominatorIdle(defaultAnim)
  if self.param == nil or table.IsNullOrEmpty(self.param.uuidList) then
    return
  end
  
  local function GetWorldPos(index)
    local totalCount = #self.param.uuidList
    local offsetData = Const.DominatorPosOffset[totalCount]
    if not offsetData then
      return nil
    end
    return offsetData[index] + Const.DefaultScenePos
  end
  
  local totalCount = #self.param.uuidList
  for i, v in ipairs(self.param.uuidList) do
    local index = i
    local dominatorInfo = DataCenter.DominatorManager:GetInfoByUuid(v)
    if dominatorInfo then
      local path = Const.TempIdleModelPath
      local rankShowTemplate = dominatorInfo:GetCurRankShowTemplate()
      if rankShowTemplate then
        path = rankShowTemplate.train_show_perfab
      end
      if not string.IsNullOrEmpty(path) then
        local worldPos = GetWorldPos(index)
        local member = ObjectPool:GetInstance():Load(IdleMember)
        member:Init(path, worldPos, defaultAnim)
        if self.idleMembers == nil then
          self.idleMembers = {}
        end
        table.insert(self.idleMembers, member)
      end
    end
  end
end

function DominatorTrainSceneManager:OnDominatorBattleLoaded()
end

function DominatorTrainSceneManager:OnDominatorIdleLoaded()
end

function DominatorTrainSceneManager:ReleaseMonster()
  self.unitMgr:RemoveAllUnitByType(UnitType.Zombie)
end

function DominatorTrainSceneManager:ReloadMonster()
  if self.param == nil then
    return
  end
  local monsterId = self.param.monsterId or Const.DefaultMonsterId
  local monsterRect = Const.DefaultMonsterRect
  local width = monsterRect[1] or 3
  local height = monsterRect[2] or 3
  self.monsterSpacing = monsterRect[3] or 1
  self.monsterRectWidth = (width - 1) / 2
  self.monsterRectWidth = math.floor(self.monsterRectWidth)
  self.monsterRectHeight = (height - 1) / 2
  self.monsterRectHeight = math.floor(self.monsterRectHeight)
  self.monsterRectPosition = Vector2.New()
  self.monsterRectPosition.x = Const.DefaultMonsterCenterPos[1]
  self.monsterRectPosition.z = Const.DefaultMonsterCenterPos[2]
  for i = -self.monsterRectWidth, self.monsterRectWidth do
    for j = -self.monsterRectHeight, self.monsterRectHeight do
      local realX = self.monsterRectPosition.x + i * self.monsterSpacing + Const.DefaultScenePos.x
      local realZ = self.monsterRectPosition.z + j * self.monsterSpacing + Const.DefaultScenePos.z
      self:CreateSingleMonster(monsterId, Vector3.New(realX, 0, realZ))
    end
  end
end

function DominatorTrainSceneManager:CreateSingleMonster(monsterId, pos, delayTime)
  local meta = DataCenter.PveMonsterTemplateManager:GetTemplate(monsterId)
  local objId = Const.MonsterObjectIdMin + self:GetNextObjId()
  if objId > Const.MonsterObjectIdMax then
    Logger.LogError("objId > Const.MonsterObjectIdMax")
  end
  local zombie = ObjectPool:GetInstance():Load(Zombie)
  zombie:Init(self, objId, meta)
  zombie:Create(pos, Const.DefaultScenePos, delayTime)
  self:AddUnit(zombie)
end

function DominatorTrainSceneManager:ChangeState(state, ...)
  if self.curState == state then
    return
  end
  self.curState = state
  self.fsm:Switch(state, ...)
end

function DominatorTrainSceneManager:FinishRound()
  if self.fsm then
    self.fsm:Reset()
    self.curState = self.State.None
  end
end

function DominatorTrainSceneManager:SetSceneCameraActive(isActive)
  local sceneCamera = self.sceneCamera
  if sceneCamera ~= nil then
    sceneCamera.gameObject:SetActive(isActive)
    if isActive then
      self:SetRenderTexture()
    else
      sceneCamera.targetTexture = nil
    end
  end
end

function DominatorTrainSceneManager:SetRenderTexture()
  if self.sceneCamera == nil or self.param == nil then
    return
  end
  if self.renderTexture == nil then
    local rtWidth = self.param.rtWidth
    local rtHeight = self.param.rtHeight
    local rtFormat = RenderTextureFormat.ARGB32
    self.renderTexture = RenderTexture.GetTemporary(rtWidth, rtHeight, 24, rtFormat)
    self.renderTexture.name = "DominatorTrainShow" .. rtWidth .. "*" .. rtHeight
  end
  if self.param and self.param.renderTexture then
    self.param.renderTexture:SetTexture(self.renderTexture)
    self.param.renderTexture:SetEnable(true)
    self.param.renderTexture:SetColor(Color.New(1, 1, 1, 1))
  end
  self.sceneCamera.targetTexture = self.renderTexture
end

function DominatorTrainSceneManager:GetNextObjId()
  local nextObjId = self.nextObjId
  self.nextObjId = nextObjId + 1
  return nextObjId
end

function DominatorTrainSceneManager:GetPVEType()
  return PVEType.DominatorTrain
end

function DominatorTrainSceneManager:AddUnit(unit)
  self.unitMgr:AddUnit(unit)
end

function DominatorTrainSceneManager:GetUnit(id)
  return self.unitMgr:GetUnit(id)
end

function DominatorTrainSceneManager:RemoveUnit(unit)
  self.unitMgr:RemoveUnit(unit)
end

function DominatorTrainSceneManager:UpdateCameraAngle()
  if self.curState == self.State.Battle then
    self:SetToTopAngle()
  elseif self.curState == self.State.Idle then
    self:SetToFrontAngle()
  end
end

function DominatorTrainSceneManager:SetToTopAngle()
  if not IsNull(self.virtualCamera01) then
    self.virtualCamera01:SetActive(true)
  end
  if not IsNull(self.virtualCamera02) then
    self.virtualCamera02:SetActive(false)
  end
end

function DominatorTrainSceneManager:SetToFrontAngle()
  if not IsNull(self.virtualCamera01) then
    self.virtualCamera01:SetActive(false)
  end
  if not IsNull(self.virtualCamera02) then
    self.virtualCamera02:SetActive(true)
  end
end

function DominatorTrainSceneManager:SwitchToIdle(defaultAnim)
  if self.curState == self.State.Idle then
    self:PlayModelAnimImmediately(defaultAnim)
    self:PlayIdleEffect()
  else
    self:ChangeState(self.State.Idle, defaultAnim)
  end
end

function DominatorTrainSceneManager:SwitchToBattle()
  self:ChangeState(self.State.Battle)
end

function DominatorTrainSceneManager:ShowEffectObj(path, pos, rot, time, parent, type)
  return self.effectObjMgr:ShowEffectObj(path, pos, rot, time, parent, type)
end

function DominatorTrainSceneManager:RemoveEffectObj(id)
  self.effectObjMgr:RemoveEffectObj(id)
end

function DominatorTrainSceneManager:IsBeRemove(id)
  return false
end

function DominatorTrainSceneManager:IsCarryType(resType)
  return false
end

function DominatorTrainSceneManager:IsResourceType(resType)
  return false
end

function DominatorTrainSceneManager:CanShowBlood()
  return false
end

function DominatorTrainSceneManager:RemoveOneArrowById()
end

function DominatorTrainSceneManager:RefreshCameraRotation()
end

function DominatorTrainSceneManager:GetPosId(pos)
  return pos.x .. " " .. pos.z
end

function DominatorTrainSceneManager:IsSkillLevel()
  return false
end

function DominatorTrainSceneManager:OnBattleReset(squadIndex, supply, heroes)
end

function DominatorTrainSceneManager:SetGameOver(v)
  self.gameOver = v
end

function DominatorTrainSceneManager:SetGamePause(v)
  self.gamePause = v
end

function DominatorTrainSceneManager:DealDamage(params)
  local defender = params.defender
  local hitPoint = params.hitPoint
  local hitDir = params.hitDir
  local whiteTime = params.whiteTime
  local stiffTime = params.stiffTime
  local hitBackDistance = params.hitBackDistance
  local hitEff = params.hitEff
  local skill = params.skill
  local hurt = Const.DefaultMissileDamage
  defender:BeAttack(hurt, hitPoint, hitDir, whiteTime, stiffTime, hitBackDistance, hitEff)
  defender:AfterBeAttack(hurt, hitPoint, hitDir, whiteTime, stiffTime, hitBackDistance, hitEff, skill)
end

function DominatorTrainSceneManager:OnMonsterDeath(monster)
end

function DominatorTrainSceneManager:PlayModelAnimQueueIfNotPlaying(animImmediately, animLater)
  if table.IsNullOrEmpty(self.idleMembers) then
    return
  end
  for i, v in ipairs(self.idleMembers) do
    if not v:IsPlayingModelAnim(animImmediately) then
      v:PlayModelAnimQueue(animImmediately, animLater)
    end
  end
end

function DominatorTrainSceneManager:PlayModelAnimImmediately(anim)
  if table.IsNullOrEmpty(self.idleMembers) then
    return
  end
  for i, v in ipairs(self.idleMembers) do
    v:ClearCurDelayPlayAnimTimer()
    v:PlayModelAnimImmediately(anim)
  end
end

function DominatorTrainSceneManager:PlayUpgradeEffect(trainGroupId)
  if table.IsNullOrEmpty(self.idleMembers) then
    return
  end
  for i, v in ipairs(self.idleMembers) do
    v:PlayUpgradeEffect(trainGroupId)
  end
end

function DominatorTrainSceneManager:PlayIdleEffect()
  if table.IsNullOrEmpty(self.idleMembers) then
    return
  end
  for i, v in ipairs(self.idleMembers) do
    v:PlayIdleEffect()
  end
end

return DominatorTrainSceneManager
