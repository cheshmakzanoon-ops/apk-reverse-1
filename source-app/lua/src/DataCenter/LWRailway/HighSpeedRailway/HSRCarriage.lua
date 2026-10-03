local HSRCarriage = BaseClass("HSRCarriage")
local Resource = CS.GameEntry.Resource
local HSRHead = require("DataCenter.LWRailway.HighSpeedRailway.HSRHead")
local PrefabPath = {
  "Assets/Main/SeasonRes/S5/Prefabs/World/HSR_Locomotive_East.prefab",
  "Assets/Main/SeasonRes/S5/Prefabs/World/HSR_Locomotive_West.prefab",
  "Assets/Main/SeasonRes/S5/Prefabs/World/HSR_Locomotive_South.prefab",
  "Assets/Main/SeasonRes/S5/Prefabs/World/HSR_Locomotive_North.prefab",
  "Assets/Main/SeasonRes/S5/Prefabs/World/HSR_Carriage_East.prefab",
  "Assets/Main/SeasonRes/S5/Prefabs/World/HSR_Carriage_West.prefab",
  "Assets/Main/SeasonRes/S5/Prefabs/World/HSR_Carriage_South.prefab",
  "Assets/Main/SeasonRes/S5/Prefabs/World/HSR_Carriage_North.prefab"
}
local MAX_CARRIAGE_COUNT = 50

function HSRCarriage:__init()
  self.showingHeads = false
  self.hasTransform = false
end

function HSRCarriage:__delete()
  self:Destroy()
end

function HSRCarriage:Destroy()
  self:RemoveHead()
  self:RemoveCarriage()
  self.hsrData = nil
  self.parent = nil
  self.index = nil
  self.timeOffset = nil
end

function HSRCarriage:Init(hsrData, index, parent)
  self.hsrData = hsrData
  self.index = index
  self.parent = parent
  self.timeOffset = hsrData:GetDelay(index)
  self.carriagePos = index == 0 and CarriagePos.Locomotive or CarriagePos.Carriage
end

function HSRCarriage:OnUpdate(now)
  now = now - self.timeOffset
  local pos, dir = self.hsrData:GetPosition(now)
  self:SetDirection(dir)
  self:SetPosition(pos)
end

function HSRCarriage:SetDirection(dir)
  if self.direction == dir then
    return
  end
  self.direction = dir
  self:Instantiate()
end

function HSRCarriage:SetPosition(pos)
  self.position = pos
  self:SetViewPosition(pos)
end

function HSRCarriage:SetViewPosition(pos)
  if self.hasTransform then
    self.transform:Set_position(pos.x, 0, pos.z)
  end
end

function HSRCarriage:GetPrefabPath()
  local index = self.carriagePos * 4 + self.direction + 1
  if not PrefabPath[index] then
    Log.Error("HSRCarriage GetPrefabPath \230\149\176\231\187\132\232\182\138\231\149\140:{0},{1}", self.direction, self.carriagePos)
    return PrefabPath[1]
  end
  return PrefabPath[index]
end

function HSRCarriage:RemoveCarriage()
  if self.req then
    self.req:Destroy()
    self.req = nil
    self.transform = nil
    self.hasTransform = false
    self.headRoot1 = nil
    self.headRoot2 = nil
  end
end

function HSRCarriage:Instantiate()
  self:RemoveCarriage()
  self.req = Resource:InstantiateAsync(self:GetPrefabPath())
  if self.req then
    self.req:completed("+", function(request)
      local go = request.gameObject
      if IsNull(go) then
        return
      end
      local transform = go.transform
      self.transform = transform
      self.hasTransform = true
      transform:SetParent(self.parent)
      transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
      transform:Set_rotation(Quaternion.identity)
      if self.position then
        self:SetViewPosition(self.position)
      end
      if self.direction == HSRDirection.North then
        local meshRenderer = transform:GetComponentInChildren(typeof(CS.UnityEngine.MeshRenderer))
        if meshRenderer then
          meshRenderer.sortingOrder = self.index
        end
      elseif self.direction == HSRDirection.South then
        local meshRenderer = transform:GetComponentInChildren(typeof(CS.UnityEngine.MeshRenderer))
        if meshRenderer then
          meshRenderer.sortingOrder = MAX_CARRIAGE_COUNT - self.index
        end
      end
      self:InitHead()
    end)
  end
end

function HSRCarriage:InitHead()
  self:RemoveHead()
  self:LazyRefreshHead()
end

function HSRCarriage:RemoveHead()
  if self.hsrHeads then
    for _, v in pairs(self.hsrHeads) do
      v:Destroy()
    end
  end
  self.hsrHeads = {}
  self.showingHeads = false
end

function HSRCarriage:CreatHead()
  self.showingHeads = true
  local maxPassengerPerCarriage = DataCenter.HSRDataManager:GetMaxPassengerPerCarriage()
  local first = maxPassengerPerCarriage * (self.index - 1) + 1
  local headInfos = self.hsrData:GetHeadInfos()
  if first <= #headInfos then
    local last = math.min(#headInfos, maxPassengerPerCarriage * self.index)
    for i = first, last do
      local head = HSRHead.New()
      head:Init(i - first + 1, headInfos[i], self)
      table.insert(self.hsrHeads, head)
    end
  end
end

function HSRCarriage:OnHSRHeadDataRefresh()
  if self.showingHeads then
    self:RemoveHead()
    self:CreatHead()
  end
end

function HSRCarriage:LazyRefreshHead()
  if self.index <= 0 or not self.hasTransform then
    return
  end
  local isInView = DataCenter.HSRViewManager:IsInViewRect(self.position)
  if self.showingHeads and not isInView then
    self:RemoveHead()
  elseif not self.showingHeads and isInView and DataCenter.HSRViewManager:GetCurLod() <= 2 then
    self:CreatHead()
  end
end

function HSRCarriage:GetHeadRoot(index)
  local maxPassengerPerCarriage = DataCenter.HSRDataManager:GetMaxPassengerPerCarriage()
  if index <= maxPassengerPerCarriage / 2 then
    if not self.headRoot1 and self.hasTransform then
      self.headRoot1 = self.transform:Find("HeadRoot/HeadLayout1")
    end
    return self.headRoot1
  else
    if not self.headRoot2 and self.hasTransform then
      self.headRoot2 = self.transform:Find("HeadRoot/HeadLayout2")
    end
    return self.headRoot2
  end
end

return HSRCarriage
