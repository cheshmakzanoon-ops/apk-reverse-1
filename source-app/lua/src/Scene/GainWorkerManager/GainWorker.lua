local GuideNpcUnit = require("DataCenter.LWGuideManager.GuideModel.GuideNpcUnit")
local GainWorker = BaseClass("GainWorker", GuideNpcUnit)
local p_entryPath = "ModelGo/point/p_entry"
local Resource = CS.GameEntry.Resource
local speedConst = 4

function GainWorker:OnCreate()
  if not self.data.isGoworker and self.data.targetPos then
    self:Jump()
  else
    self:GoToWork()
  end
end

function GainWorker:Jump()
  local fly = self.transform:GetComponent(typeof(CS.UIGoodsFly))
  fly:DoParabolaAnim(self.data.targetPos, Vector3.New(self.transform.position.x, 0, self.transform.position.z), function()
    local vfxHandle = Resource:InstantiateAsync("Assets/_Art_LastWar/Effect/Prefab/Arms/APS/VFX_animal_grow.prefab")
    vfxHandle:completed("+", function(handle)
      if handle.isError then
        return
      end
      handle.gameObject.transform.position = self.data.targetPos
      TimerManager:GetInstance():DelayInvoke(function()
        vfxHandle:Destroy()
      end, 2)
    end)
    self:GoToWork()
  end)
end

function GainWorker:GoToWork()
  self.isFinish = true
  if IsNull(CS.SceneManager.World) then
    return
  end
  local cityObj = CS.SceneManager.World:GetBuildingByPoint(self.data.buildData.pointId)
  local p_entry = cityObj.gameObject.transform:Find(p_entryPath)
  p_entry = p_entry or self.data.buildData:GetCenterVec()
  local pathList = DataCenter.InnerCityMapManager:FindPath(self.transform.position, p_entry.transform.position)
  if pathList and 2 <= #pathList then
    table.remove(pathList, 1)
    pathList[#pathList] = Vector3.New(p_entry.transform.position.x, p_entry.transform.position.y, p_entry.transform.position.z)
  else
    pathList = {}
    table.insert(pathList, Vector3.New(p_entry.transform.position.x, p_entry.transform.position.y, p_entry.transform.position.z))
  end
  self:SetTargetEndPos(pathList)
  self:ShowCourse(self.transform.position, self.data.buildData:GetCenterVec())
  self.speed = speedConst
end

function GainWorker:ShowCourse(startPos, endPos)
  self.course = Resource:InstantiateAsync("Assets/Main/Prefabs/March/WorkerLine.prefab")
  self.course:completed("+", function(req)
    self.troopLine = req.gameObject:GetComponent(typeof(CS.WorldTroopLine))
    self.troopLine:SetDragPath(startPos, endPos)
  end)
end

function GainWorker:OnFinish()
  if self.course then
    self.course:Destroy()
  end
  if self.data.workerData and self.data.workerData.uid then
    DataCenter.GainWorkerManager:RemoveWorkerModel(self.data.workerData.uid)
  else
    self:Delete()
  end
end

function GainWorker:DoWork()
  if not self.data.workerData then
    if self.data.buildData.level == 0 then
      local param = {}
      param.uuid = tostring(self.data.buildData.uuid)
      param.gold = BuildUpgradeUseGoldType.No
      param.upLevel = 1
      param.clientParam = ""
      param.truckId = 0
      param.pathTime = 0
      param.robotUuid = 0
      SFSNetwork.SendMessage(MsgDefines.FreeBuildingUpNew, param)
    end
  else
    SFSNetwork.SendMessage(MsgDefines.WorkerChangeStateMessgae, self.data.workerData.uid, 1)
    if self.data.workerData:IsCanWork(self.data.buildData.itemId) then
      if self.data.buildData.level == 0 then
        local param = {}
        param.uuid = tostring(self.data.buildData.uuid)
        param.gold = BuildUpgradeUseGoldType.No
        param.upLevel = 1
        param.clientParam = ""
        param.truckId = 0
        param.pathTime = 0
        param.robotUuid = 0
        param.workerId = self.data.workerData.uid
        SFSNetwork.SendMessage(MsgDefines.FreeBuildingUpNew, param)
      else
        SFSNetwork.SendMessage(MsgDefines.BuildAssignHeroMessage, self.data.buildData.uuid, self.data.workingSlot - 1, self.data.workerData.uid)
      end
    end
    local vfxHandle = CS.GameEntry.Resource:InstantiateAsync("Assets/_Art_LastWar/Effect/Prefab/xinshou/Eff_xinshou_gongzuo.prefab")
    vfxHandle:completed("+", function(handle)
      handle.gameObject.transform.position = self.data.buildData:GetCenterVec()
      TimerManager:GetInstance():DelayInvoke(function()
        if not IsNull(handle) then
          handle:Destroy()
        end
      end, 2)
    end)
  end
end

function GainWorker:OnUpdate()
  if self.troopLine and self.transform then
    self.troopLine:SetDragPath(self.transform.position, self.data.buildData:GetCenterVec())
  end
end

function GainWorker:OnDelete()
  self:DoWork()
  if self.course then
    self.course:Destroy()
  end
end

return GainWorker
