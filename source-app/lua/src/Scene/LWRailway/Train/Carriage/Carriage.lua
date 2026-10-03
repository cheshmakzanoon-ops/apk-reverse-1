local Carriage = BaseClass("Carriage")
local Resource = CS.GameEntry.Resource
local CarriageStatePullIn = require("Scene.LWRailway.Train.CarriageState.CarriageStatePullIn")
local CarriageStateHide = require("Scene.LWRailway.Train.CarriageState.CarriageStateHide")
local CarriageStatePullOut = require("Scene.LWRailway.Train.CarriageState.CarriageStatePullOut")
local CarriageStateStraight = require("Scene.LWRailway.Train.CarriageState.CarriageStateStraight")
local CarriageStateTurn = require("Scene.LWRailway.Train.CarriageState.CarriageStateTurn")
local FSM = require("Framework.Common.FSM")
local CarriageRendererPath = {
  [1] = "Model/A_build_train_01_chetou/A_build@Train_03_skin/To_unity/Geometry/A_build_Train_03",
  [2] = "Model/A_build_train_01_chexiang1/A_build@Car_01_skin/To_unity/Geometry/A_build_Car_01",
  [3] = "Model/A_build_train_01_daochetou/A_build@Train_03_skin/To_unity/Geometry/A_build_Train_03"
}
local CarriageRendererPathUR = {
  [1] = "Model/train_head_UR/A_build@chetou_UR_01_skin/To_unity/Geometry/train_head_UR1",
  [2] = "Model/train_cabin_UR/A_build@chexiang_UR_01_skin/To_unity/Geometry/train_cabin_UR1",
  [3] = "Model/train_head_UR/A_build@chetou_UR_01_skin/To_unity/Geometry/train_head_UR1"
}
local CarriagePrefabPath = {
  [1] = "Assets/Main/Prefabs/World/Train/Train_01_chetou.prefab",
  [2] = "Assets/Main/Prefabs/World/Train/Train_01_chexiang1.prefab",
  [3] = "Assets/Main/Prefabs/World/Train/Train_01_daochetou.prefab"
}
local CarriagePrefabPathUR = {
  [1] = "Assets/Main/Prefabs/World/Train/Train_01_chetou_UR.prefab",
  [2] = "Assets/Main/Prefabs/World/Train/Train_01_chexiang1_UR.prefab",
  [3] = "Assets/Main/Prefabs/World/Train/Train_01_daochetou_UR.prefab"
}

function Carriage:__init(train, index, parent)
  self.index = index
  self.train = train
  self.parent = parent
  self.prefabIndex = self:GetPrefabIndex()
  local cfgId = self.train.trainData.cfgId
  local ur = RailwayUtil.IsUR(cfgId)
  self.ur = ur
  self:InitView()
end

function Carriage:GetPrefabIndex()
  local count = self.train.trainData.carriageCount
  if self.index == 1 then
    return 1
  elseif self.index == count then
    return 3
  else
    return 2
  end
end

function Carriage:GetPrefabPath()
  if self.train.trainData.type == TrainType.Truck then
    return self.train.trainData:GetWorldModelPath(self.train.isFake and LuaEntry.Player:GetSourceServerId())
  else
    local cfgId = self.train.trainData.cfgId
    local ur = RailwayUtil.IsUR(cfgId)
    local path = ur and CarriagePrefabPathUR or CarriagePrefabPath
    return path[self.prefabIndex]
  end
end

function Carriage:__delete()
  self:Destroy()
end

function Carriage:Destroy()
  self:RemoveFire()
  self.fireParent = {}
  self.train = nil
  self.index = nil
  if self.req then
    self.req:Destroy()
  end
  if self.mpbShadow and self.rendererShadow then
    self.mpbShadow:SetInt("_FadeOn", 0)
    self.rendererShadow:SetPropertyBlock(self.mpbShadow)
  end
  if self.renderer and self.defaultMat then
    self.renderer.sharedMaterial = self.defaultMat
  end
  self.renderer = nil
  self.rendererShadow = nil
  self.mpb = nil
  self.mpbShadow = nil
  self.defaultMat = nil
  self.transparentMat = nil
  self.animator = nil
end

function Carriage:InitView()
  self.req = Resource:InstantiateAsync(self:GetPrefabPath())
  self.req:completed("+", function(request)
    self.gameObject = request.gameObject
    self.transform = request.gameObject.transform
    self.transform:SetParent(self.parent)
    self.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
    self.transform:Set_localEulerAngles(ResetPosition.x, ResetPosition.y, ResetPosition.z)
    self:ResetLocalPos()
    self:ComponentDefine()
    self:InitFSM()
    self:RefreshView()
  end)
end

function Carriage:ComponentDefine()
  local skinnedMeshRenderer = self.gameObject:GetComponentsInChildren(typeof(CS.UnityEngine.SkinnedMeshRenderer))
  local meshRenderer = self.gameObject:GetComponentsInChildren(typeof(CS.UnityEngine.MeshRenderer))
  if skinnedMeshRenderer then
    for i = 0, skinnedMeshRenderer.Length - 1 do
      skinnedMeshRenderer[i].enabled = true
    end
  end
  if meshRenderer then
    for i = 0, meshRenderer.Length - 1 do
      meshRenderer[i].enabled = true
    end
  end
  local trailRenderer = self.gameObject:GetComponentsInChildren(typeof(CS.UnityEngine.TrailRenderer))
  for i = 0, trailRenderer.Length - 1 do
    trailRenderer[i]:Clear()
  end
  if self.train.trainData.type == TrainType.Truck then
    self.fireParent = {}
    self.fireParent[1] = self.transform:Find("Model/fire1")
    self.fireParent[2] = self.transform:Find("Model/fire2")
  else
    self.opposite = self.index == self.train.trainData.carriageCount and -1 or 1
    self.mpb = CS.UnityEngine.MaterialPropertyBlock()
    self.mpbShadow = CS.UnityEngine.MaterialPropertyBlock()
    if self.ur then
      self.transparentMat = DataCenter.LWTrainManager:GetURTransparentMat(self.prefabIndex)
    else
      self.transparentMat = DataCenter.LWTrainManager:GetTransparentMat(self.prefabIndex)
    end
    local renderPath = self.ur and CarriageRendererPathUR or CarriageRendererPath
    self.renderer = self.transform:Find(renderPath[self.prefabIndex]):GetComponent(typeof(CS.UnityEngine.SkinnedMeshRenderer))
    if self.renderer then
      self.defaultMat = self.renderer.sharedMaterial
    end
    self.fireParent = {}
    for i = 1, 6 do
      self.fireParent[i] = self.transform:Find("Model/trainFire/fire" .. i)
    end
  end
end

function Carriage:InitFSM()
  self.fsm = FSM.New()
  self.fsm:AddState(CarriageState.PullIn, CarriageStatePullIn.New(self))
  self.fsm:AddState(CarriageState.Hide, CarriageStateHide.New(self))
  self.fsm:AddState(CarriageState.PullOut, CarriageStatePullOut.New(self))
  self.fsm:AddState(CarriageState.Straight, CarriageStateStraight.New(self))
  self.fsm:ChangeState(CarriageState.Straight)
end

function Carriage:RefreshView()
  if not self.transform then
    return
  end
  self:RemoveFire()
  local fireCount = 0
  if self.train.trainData.type == TrainType.Train then
    fireCount = self.train.trainData:GetFireCountByCarriageId(self.index)
  else
    fireCount = self.train.trainData.marchInfo.robTimes
  end
  for i = 1, fireCount do
    self.fireReq[i] = Resource:InstantiateAsync("Assets/Main/Prefabs/World/Eff_daditu_zhucheng_fire.prefab")
    self.fireReq[i]:completed("+", function(req)
      local go = req.gameObject
      if IsNull(go) then
        return
      end
      go:SetActive(true)
      local transform = go.transform
      transform:SetParent(self.fireParent[i])
      transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
      transform:Set_localPosition(0, 0, 0)
    end)
  end
end

function Carriage:OnUpdate(ts)
  if self.fsm then
    self.fsm:OnUpdate(ts)
  end
end

function Carriage:SetActive(active)
  if self.gameObject then
    self.gameObject:SetActive(active)
    if active then
      self:ResetLocalPos()
    end
  end
end

function Carriage:ResetLocalPos()
  self.transform:Set_localPosition(0, 0, (1 - self.index) * DataCenter.LWMyStationDataManager:GET_CARRIAGE_LENGTH())
end

function Carriage:RemoveFire()
  if self.fireReq then
    for _, req in pairs(self.fireReq) do
      req:Destroy()
    end
  end
  self.fireReq = {}
end

function Carriage:PlayAnim()
  if self.animator then
    self.animator:Play("Move")
  end
end

return Carriage
