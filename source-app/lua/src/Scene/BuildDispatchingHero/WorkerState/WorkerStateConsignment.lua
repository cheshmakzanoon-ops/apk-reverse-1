local WorkerStateConsignment = BaseClass("WorkerStateIdle")
local Const = require("Scene.BuildDispatchingHero.Const")

function WorkerStateConsignment:__init(worker)
  self.delayArray = {}
  self.worker = worker
end

function WorkerStateConsignment:__delete()
  self.worker = nil
  for i, v in pairs(self.delayArray) do
    if v then
      v:Stop()
    end
  end
end

function WorkerStateConsignment:OnEnter()
  local buildData = DataCenter.BuildManager:GetBuildingDataByUuid(self.worker.data.endBuildUuid)
  local index = 0
  local pos = buildData:GetCenterVec()
  for i = #self.worker.carryObj, 1, -1 do
    index = index + 1
    local createDelay = TimerManager:GetInstance():DelayInvoke(function()
      self.worker.carryObj[i]:FlyOut(Vector3.New(pos.x, pos.y, pos.z), function()
        if self.worker and self.worker.carryObj[i] ~= nil then
          self.worker.carryObj[i]:Destroy()
          if i == 1 then
            self.worker:OnConsignmentEnd()
          end
        end
      end)
    end, 0.3 * index)
    table.insert(self.delayArray, createDelay)
  end
end

function WorkerStateConsignment:OnExit()
  for i, v in pairs(self.delayArray) do
    if v then
      v:Stop()
    end
  end
end

function WorkerStateConsignment:OnUpdate(deltaTime)
end

return WorkerStateConsignment
