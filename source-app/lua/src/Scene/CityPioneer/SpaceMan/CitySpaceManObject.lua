local CitySpaceManObject = BaseClass("CitySpaceManObject", Singleton)
local Resource = CS.GameEntry.Resource
local CitySpaceMan = require("Scene.CityPioneer.SpaceMan.CitySpaceMan2")
local _prefabPath = "Assets/Main/Prefabs/CityScene/CitySpaceManPrologue.prefab"
local CloseUITutorialAnimationTime = 1
local StartMoveTriggerGuideTime = 1.5
local InitSpaceManPos = {x = 66, y = 58}
local ExtraManPos = {
  Vector3.New(0, 0, -1.5),
  Vector3.New(-1.5, 0, 0),
  Vector3.New(1.5, 0, 0),
  Vector3.New(0, 0, 1.5),
  Vector3.New(1.5, 0, 1.5),
  Vector3.New(-1.5, 0, 1.5),
  Vector3.New(1.5, 0, -1.5),
  Vector3.New(-1.5, 0, -1.5)
}
local GameState = {
  Normal = 0,
  HoldFlag = 1,
  SubmitFlag = 2,
  Jump = 3,
  None = 4
}

function CitySpaceManObject:__init()
  self.m_req = nil
  self.m_model = nil
  self.m_deltaT = 0
  self.m_updateTimer = nil
  self.m_curGameState = GameState.Normal
  self.subRed = {}
  self.subModel = {}
end

function CitySpaceManObject:__delete()
  self:Destroy()
end

function CitySpaceManObject:GetTransform()
  if self.m_model == nil then
    return nil
  end
  return self.m_model.transform
end

function CitySpaceManObject:GetInstantiateObj()
  return self.m_model
end

function CitySpaceManObject:AddTimer()
  if self.m_updateTimer == nil then
    function self.m_updateTimer()
      self:OnUpdate()
    end
    
    UpdateManager:GetInstance():AddUpdate(self.m_updateTimer)
  end
end

function CitySpaceManObject:RemoveTimer()
  if self.m_updateTimer then
    UpdateManager:GetInstance():RemoveUpdate(self.m_updateTimer)
    self.m_updateTimer = nil
  end
end

function CitySpaceManObject:InitScript()
end

function CitySpaceManObject:SaveArchive()
  local tbl = {}
  tbl.finish_state = self:IsFinalState()
  if self.idle_pos then
    tbl.pos = {}
    tbl.pos.x = self.idle_pos.x
    tbl.pos.y = self.idle_pos.y
  end
  local archive = CityPioneerArchive:GetInstance()
  archive:SetUserState(tbl)
end

function CitySpaceManObject:LoadArchive(archive)
  if table.IsNullOrEmpty(archive) then
    return
  end
  if archive.finish_state then
    self.m_curGameState = GameState.HoldFlag
  end
  self.old_pos = archive.pos
end

function CitySpaceManObject:HandFlag()
  self.m_curGameState = GameState.HoldFlag
  if self.m_model ~= nil then
    self.m_model:HandFlag()
  end
end

function CitySpaceManObject:WaveFlag()
  self.m_curGameState = GameState.SubmitFlag
  if self.m_model ~= nil then
    self.m_model:WaveFlag()
  end
end

function CitySpaceManObject:SetGameStateToNormal()
  self.m_curGameState = GameState.Normal
  if self.m_model ~= nil then
    self.m_model:SetGameStateToNormal()
  end
end

function CitySpaceManObject:RemoveAllFlag()
  if self.m_model ~= nil then
    self.m_model:RemoveAllFlag()
  end
end

function CitySpaceManObject:GetFlyPos()
  if self.m_model ~= nil then
    return self.m_model:GetFlyPos()
  end
end

function CitySpaceManObject:InstantiateObj(pos, rot)
  if self.m_req == nil then
    local param = {}
    param.isMain = true
    param.pos = pos
    param.rot = rot
    self.m_req = Resource:InstantiateAsync(_prefabPath)
    self.m_req:completed("+", function(request)
      if request.isError then
        return
      end
      request.gameObject:SetActive(true)
      request.gameObject.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
      local effect = CitySpaceMan.New()
      effect:OnCreate(request)
      self.m_model = effect
      effect:ReInit(param)
    end)
  end
  local num = DataCenter.GuideManager:GetSpaceManExtraNum()
  if 0 < num then
    local subRedNum = table.count(self.subRed)
    local posCount = table.count(ExtraManPos)
    for i = 1, num do
      local param = {}
      param.isMain = false
      param.index = i
      param.allSubNum = num
      if i <= posCount then
        param.extraPos = ExtraManPos[i]
      else
        param.extraPos = Vector3.New(-0.7 * (i - posCount), 0, -2)
      end
      param.pos = pos + param.extraPos
      param.rot = rot
      if i > subRedNum then
        self.subRed[i] = Resource:InstantiateAsync(_prefabPath)
        self.subRed[i]:completed("+", function(request)
          if request.isError then
            return
          end
          request.gameObject:SetActive(true)
          request.gameObject.transform:Set_localScale(0.8, 0.8, 0.8)
          local effect = CitySpaceMan.New()
          effect:OnCreate(request)
          self.subModel[param.index] = effect
          effect:ReInit(param)
        end)
      end
    end
    if num < subRedNum then
      for i = num, subRedNum do
        self:DestroySubByIndex(i)
      end
    end
  end
  self:AddTimer()
end

function CitySpaceManObject:GetCitySpaceManGameObject()
  return self.m_model
end

function CitySpaceManObject:CreateGameObject()
  local pos, rot
  if self.m_model == nil then
    self.world = CS.SceneManager.World
    local archive = CityPioneerArchive:GetInstance()
    if self.idle_pos == nil then
      self.idle_pos = archive.load_data.user and archive.load_data.user.pos
    end
    pos = self.idle_pos
    rot = nil
    pos = pos == nil and InitSpaceManPos or pos
    rot = rot == nil and Quaternion.LookRotation(Vector3.back) or rot
    pos = SceneUtils.TileToWorld(pos)
    pos.y = 0
    self.world:Lookat(pos)
  else
    pos = self.m_model:GetPosition()
    rot = self.m_model:GetRotation()
  end
  self:InstantiateObj(pos, rot)
end

function CitySpaceManObject:SetPosition(pos)
  if self.m_model == nil then
    self.old_pos = SceneUtils.WorldToTile(pos)
    self.idle_pos = self.old_pos
    return
  end
  if not DataCenter.GuideManager:InGuide() then
    self.world:Lookat(pos)
  end
  self.m_model:SetPosition(pos)
end

function CitySpaceManObject:GetPosition()
  if self.m_model == nil then
    return Vector3.New(0, 0, 0)
  end
  return self.m_model:GetPosition()
end

function CitySpaceManObject:SetTilePos(v)
  self:SetPosition(SceneUtils.TileToWorld(v))
  self.idle_pos = v
end

function CitySpaceManObject:GetTilePos()
  local worldPos = self:GetPosition()
  local x, y = SceneUtils.WorldToTileXZ(worldPos.x, worldPos.z)
  return {x = x, y = y}
end

function CitySpaceManObject:IsFarmMode()
  if self.m_model ~= nil then
    return self.m_model:IsFarmMode()
  end
end

function CitySpaceManObject:IsSlowMode()
  if self.m_model ~= nil then
    return self.m_model:IsSlowMode()
  end
end

local velocity = Vector3.unity_vector3(0, 0, 0)
local smoothTime = 0.3
local tmpV1 = Vector3.New(0, 0, 0)
local tmpV2 = Vector3.New(0, 0, 0)
local tmpV3 = Vector3.New(0, 0, 0)

function CitySpaceManObject:OnUpdate()
  if self.m_model ~= nil and self.m_curGameState ~= GameState.None then
    local trans = self:GetTransform()
    if trans ~= nil then
      if not DataCenter.GuideManager:InGuide() then
        local v1 = self.world.CurTarget
        local v2 = trans.position
        local v3 = trans.forward
        tmpV1:Set(v1.x, v1.y, v1.z)
        tmpV2:Set(v2.x, v2.y, v2.z)
        tmpV3:Set(v3.x, v3.y, v3.z)
        tmpV2.x = tmpV2.x + tmpV3.x * 0.3
        tmpV2.y = tmpV2.y + tmpV3.y * 0.3
        tmpV2.z = tmpV2.z + tmpV3.z * 0.3
        local distance = true
        if math.abs(tmpV1.x - tmpV2.x) < 0.01 and math.abs(tmpV1.y - tmpV2.y) < 0.01 and math.abs(tmpV1.z - tmpV2.z) < 0.01 then
          distance = false
        end
        if distance then
          local targetPos, v = Vector3.SmoothDamp(v1, tmpV2, velocity, smoothTime)
          velocity = v
          self.world:Lookat(targetPos)
        end
      end
      self.m_model:OnUpdate()
      for k, v in pairs(self.subModel) do
        v:OnUpdate()
      end
    end
  end
end

function CitySpaceManObject:CloseTutorialWindow()
  local t = UIManager:GetInstance():IsWindowOpen(UIWindowNames.UITutorialAnimation)
  if t and not self.timer then
    self.timer = TimerManager:GetInstance():DelayInvoke(function()
      UIManager:GetInstance():DestroyWindow(UIWindowNames.UITutorialAnimation)
      self.timer = nil
    end, CloseUITutorialAnimationTime)
  end
  if self.startMoveTimer == nil then
    self.startMoveTimer = TimerManager:GetInstance():DelayInvoke(function()
      self.startMoveTimer = nil
      DataCenter.GuideManager:CheckDoTriggerGuide(GuideTriggerType.PrologueStartMove, SaveGuideDoneValue)
    end, StartMoveTriggerGuideTime)
  end
end

function CitySpaceManObject:Walk(vx, vz)
  if DataCenter.GuideManager:InGuide() or self.m_model == nil then
    return
  end
  if self.m_curGameState == GameState.WaveFlag or self.m_curGameState == GameState.None then
    return
  end
  self:CloseTutorialWindow()
  if self.m_model ~= nil then
    self.m_model:Walk(vx, vz)
  end
  for k, v in pairs(self.subModel) do
    TimerManager:DelayInvoke(function()
      v:Walk(vx, vz)
    end, 0.2 * v.param.index / v.param.allSubNum)
  end
end

function CitySpaceManObject:StopWalk()
  if self.m_model ~= nil then
    self.m_model:StopWalk()
  end
  for k, v in pairs(self.subModel) do
    TimerManager:DelayInvoke(function()
      v:StopWalk()
    end, 0.2 * v.param.index / v.param.allSubNum)
  end
end

function CitySpaceManObject:ToPlant()
  if self.m_model ~= nil then
    self.m_model:ToPlant()
  end
  for k, v in pairs(self.subModel) do
    v:ToPlant()
  end
end

function CitySpaceManObject:ToWater()
  if self.m_model ~= nil then
    self.m_model:ToWater()
  end
  for k, v in pairs(self.subModel) do
    v:ToWater()
  end
end

function CitySpaceManObject:ToReap()
  if self.m_model ~= nil then
    self.m_model:ToReap()
  end
  for k, v in pairs(self.subModel) do
    v:ToReap()
  end
end

function CitySpaceManObject:ToReapWait()
  if self.m_model ~= nil then
    self.m_model:ToReapWait()
  end
end

function CitySpaceManObject:LeaveFarmMode()
  if self.m_model ~= nil then
    self.m_model:LeaveFarmMode()
  end
end

function CitySpaceManObject:Destroy()
  if self.m_model ~= nil then
    self.m_model:OnDestroy()
  end
  for k, v in pairs(self.subModel) do
    v:OnDestroy()
  end
  self.subModel = {}
  self.m_curGameState = GameState.Normal
  if self.m_req ~= nil then
    self.m_req:Destroy()
    self.m_req = nil
  end
  for k, v in pairs(self.subRed) do
    v:Destroy()
  end
  self.subRed = {}
  self.m_model = nil
  self:RemoveTimer()
end

function CitySpaceManObject:IsFinalState()
  if self.m_curGameState == GameState.HoldFlag or self.m_curGameState == GameState.Jump then
    return true
  end
  return false
end

function CitySpaceManObject:IsNeedCreate()
  return self.m_req == nil
end

function CitySpaceManObject:Jump()
  if self.m_model ~= nil then
    self.m_model:Jump()
  end
end

function CitySpaceManObject:LeaveJump()
  if self.m_model ~= nil then
    self.m_model:LeaveJump()
  end
end

function CitySpaceManObject:LookAtPos(pos)
  if self.m_model ~= nil then
    self.m_model:LookAtPos(pos)
  end
end

function CitySpaceManObject:SetRotation(rotation)
  if self.m_model ~= nil then
    self.m_model:SetRotation(rotation)
  end
end

function CitySpaceManObject:DestroySubByIndex(index)
  if self.subModel[index] ~= nil then
    self.subModel[index]:OnDestroy()
    self.subModel[index] = nil
  end
  if self.subRed[index] ~= nil then
    self.subRed[index]:Destroy()
    self.subRed[index] = nil
  end
end

function CitySpaceManObject:AddOneSpaceMan()
  local num = DataCenter.GuideManager:GetSpaceManExtraNum()
  DataCenter.GuideManager:SaveSpaceManExtraNum(num + 1)
  self:CreateGameObject()
end

function CitySpaceManObject:ClearSpaceMan()
  DataCenter.GuideManager:SaveSpaceManExtraNum(0)
  self:CreateGameObject()
end

function CitySpaceManObject:CarryOneObject(res)
  if self.m_model ~= nil then
    self.m_model:CarryOneObject(res)
  end
end

function CitySpaceManObject:SetVisible(active)
  if self.m_model ~= nil then
    self.m_model:SetVisible(active)
  end
end

function CitySpaceManObject:GetResTypeCount(resType)
  if self.m_model ~= nil then
    return self.m_model:GetResTypeCount(resType)
  end
  return 0
end

return CitySpaceManObject
