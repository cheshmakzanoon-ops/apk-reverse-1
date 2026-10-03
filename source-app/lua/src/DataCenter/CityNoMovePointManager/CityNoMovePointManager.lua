local CityNoMovePointManager = BaseClass("CityNoMovePointManager")
local Resource = CS.GameEntry.Resource

function CityNoMovePointManager:__init()
  self.points = nil
end

function CityNoMovePointManager:__delete()
  self.points = nil
end

function CityNoMovePointManager:AddOnePoint(pointId)
  if self.points == nil then
    self.points = {}
    self.rootNode = CS.UnityEngine.GameObject("BorderRoot").transform
    self.rootNode.transform:SetParent(CS.SceneManager.World.DynamicObjNode)
  end
  self.points[pointId] = {}
  self.points[pointId].pointId = pointId
  self.points[pointId].inst = Resource:InstantiateAsync(UIAssets.CityPrologueNoMovePoint)
  self.points[pointId].inst:completed("+", function(req)
    req.gameObject.transform:SetParent(self.rootNode.transform)
    req.gameObject.transform.position = SceneUtils.TileIndexToWorld(pointId)
  end)
end

function CityNoMovePointManager:RemoveOnePoint(pointId)
  if self.points[pointId] ~= nil then
    self.points[pointId].inst:Destroy()
    self.points[pointId] = nil
  end
end

function CityNoMovePointManager:SaveArchive()
  local archive = CityPioneerArchive:GetInstance()
  if self.points then
    for t, n in pairs(self.points) do
      archive:SetNoMovePoint(n.pointId)
    end
  end
end

function CityNoMovePointManager:InitNoMovePoint()
  local archive = CityPioneerArchive:GetInstance()
  local points = archive:GetNoMovePoint()
  if points ~= nil then
    for k, v in pairs(points) do
      self:AddOnePoint(v.point)
    end
  end
end

function CityNoMovePointManager:RemoveAll()
  if self.points then
    for t, n in pairs(self.points) do
      self:RemoveOnePoint(t)
    end
    self.points = nil
  end
end

return CityNoMovePointManager
