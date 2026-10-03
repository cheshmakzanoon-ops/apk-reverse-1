local PlaneCarriage = BaseClass("PlaneCarriage")
local Resource = CS.GameEntry.Resource
local PrefabPath = {
  [1] = "Assets/Main/Prefabs/LWRailway/PlaneLocomotive.prefab",
  [2] = "Assets/Main/Prefabs/LWRailway/PlaneCoach.prefab",
  [3] = "Assets/Main/Prefabs/LWRailway/PlaneTail.prefab"
}
local PrefabPathUR = {
  [1] = "Assets/Main/Prefabs/LWRailway/PlaneLocomotive_UR.prefab",
  [2] = "Assets/Main/Prefabs/LWRailway/PlaneCoach_UR.prefab",
  [3] = "Assets/Main/Prefabs/LWRailway/PlaneTail_UR.prefab"
}

function PlaneCarriage:__init(train, index, parent, onlyShow)
  self.index = index
  self.train = train
  self.parent = parent
  self.onlyShow = onlyShow
  self:InitView()
end

function PlaneCarriage:GetPrefabPath()
  if self.train.trainData.type == TrainType.Truck then
    return TruckPath[self.train.trainData.quality]
  else
    local count = self.train.trainData.carriageCount
    local cfgId = self.train.trainData.cfgId
    local ur = RailwayUtil.IsUR(cfgId)
    local path = ur and PrefabPathUR or PrefabPath
    if self.index == 1 then
      return path[1]
    elseif self.index == count then
      return path[3]
    else
      return path[2]
    end
  end
end

function PlaneCarriage:__delete()
  self:Destroy()
end

function PlaneCarriage:Destroy()
  self:ComponentDestroy()
  self.train = nil
  self.index = nil
  if self.req then
    self.req:Destroy()
    self.req = nil
  end
  self.gameObject = nil
  self.transform = nil
end

function PlaneCarriage:InitView()
  self.req = Resource:InstantiateAsync(self:GetPrefabPath())
  self.req:completed("+", function(request)
    self.gameObject = request.gameObject
    self.transform = request.gameObject.transform
    self.transform:SetParent(self.parent)
    self.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
    self.transform:Set_localEulerAngles(ResetPosition.x, ResetPosition.y, ResetPosition.z)
    self:ResetLocalPos()
    self:ComponentDefine()
    self:RefreshView()
  end)
end

function PlaneCarriage:ComponentDefine()
  if self.onlyShow then
    return
  end
  self.trigger = self.transform:GetComponent(typeof(CS.TouchObjectEventTrigger))
  
  function self.trigger.onPointerClick()
    self:OnClick()
  end
end

function PlaneCarriage:ComponentDestroy()
  if not IsNull(self.trigger) then
    self.trigger.onPointerClick = nil
    self.trigger = nil
  end
end

function PlaneCarriage:RefreshView()
  if self.bubble then
    self.bubble:Refresh()
  end
end

function PlaneCarriage:OnUpdate(ts)
end

function PlaneCarriage:SetActive(active)
  if self.gameObject then
    self.gameObject:SetActive(active)
    if active then
      self:ResetLocalPos()
    end
  end
end

function PlaneCarriage:ResetLocalPos()
  if not self.transform then
    return
  end
  local total = self.train.trainData.carriageCount
  if self.index == 1 then
    self.transform:Set_localPosition(-2.22, 0, -56.97)
  elseif self.index == total then
    self.transform:Set_localPosition(-2, 0, 9 * self.index - 66.66)
  else
    self.transform:Set_localPosition(-1.65, 0, 9 * self.index - 65.86)
  end
end

return PlaneCarriage
