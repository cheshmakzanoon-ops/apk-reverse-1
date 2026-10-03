local PlaneTrain = BaseClass("PlaneTrain")
local PlaneCoach = require("Scene.LWRailway.PlaneTrain.PlaneCoach")
local PlaneLocomotive = require("Scene.LWRailway.PlaneTrain.PlaneLocomotive")
local GameObject = CS.UnityEngine.GameObject

function PlaneTrain:__init(trainData, parent, onlyShow)
  self.trainData = trainData
  self.uuid = self.trainData.uuid
  self.parent = parent
  self.onlyShow = onlyShow == true and true or false
  self:Init()
end

function PlaneTrain:__delete()
  self:Destroy()
end

function PlaneTrain:Destroy()
  if self.carriages then
    for _, carriage in pairs(self.carriages) do
      carriage:Destroy()
    end
    self.carriages = nil
    self.locomotive = nil
  end
  if self.gameObject then
    GameObject.Destroy(self.gameObject)
    self.gameObject = nil
    self.transform = nil
  end
  self.parent = nil
end

function PlaneTrain:Init()
  local data = self.trainData
  self.gameObject = GameObject("PlaneTrain" .. data.uuid)
  self.transform = self.gameObject.transform
  self.transform:SetParent(self.parent)
  self.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
  self.transform:Set_localEulerAngles(ResetPosition.x, ResetPosition.y, ResetPosition.z)
  self.transform:Set_localPosition(0, 0, 0)
  self.carriages = {}
  self.locomotive = PlaneLocomotive.New(self, 1, self.transform, self.onlyShow)
  self.carriages[1] = self.locomotive
  for i = 2, data.carriageCount do
    self.carriages[i] = PlaneCoach.New(self, i, self.transform, self.onlyShow)
  end
end

function PlaneTrain:Refresh(trainData, parent)
  self.trainData = trainData
  self.uuid = self.trainData.uuid
  self.parent = parent
  if self.carriages then
    for _, carriage in pairs(self.carriages) do
      carriage:RefreshView()
    end
  end
end

function PlaneTrain:GetPosition()
  if self.transform then
    return self.transform.position
  end
  local now = UITimeManager:GetInstance():GetServerTime()
  return self.trainData:CalculateTransform(now)
end

function PlaneTrain:OnUpdate()
end

function PlaneTrain:SetLocalPosition(x, y, z)
  self.transform:Set_localPosition(x, y, z)
end

function PlaneTrain:SetPositionIndex(index)
  self.positionIndex = index
end

function PlaneTrain:GetPositionIndex()
  return self.positionIndex
end

function PlaneTrain:ShowSelectRing(bool)
  if self.locomotive then
    self.locomotive:ShowSelectRing(bool)
  end
end

function PlaneTrain:SetActive(bool)
  if not IsNull(self.gameObject) then
    self.gameObject:SetActive(bool)
  end
end

return PlaneTrain
