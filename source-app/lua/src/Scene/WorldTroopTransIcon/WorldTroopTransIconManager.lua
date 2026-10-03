local WorldTroopTransIconManager = BaseClass("WorldTroopTransIconManager", Singleton)
local ResourceManager = CS.GameEntry.Resource
local WorldTroopTransIcon = require("Scene.WorldTroopTransIcon.WorldTroopTransIcon")

local function __init(self)
  self.allTips = {}
  self.OnCreateTips = {}
  self:AddListener()
end

local function __delete(self)
  self:RemoveListener()
  for k, v in pairs(self.allTips) do
    local request = v.request
    v:OnDestroy()
    request:Destroy()
  end
  self.allTips = nil
end

local function AddListener(self)
  EventManager:GetInstance():AddListener(EventId.ShowMarchTrans, self.ShowMarchTransIconSignal)
  EventManager:GetInstance():AddListener(EventId.HideMarchTrans, self.HideMarchTransIconSignal)
end

local function RemoveListener(self)
  EventManager:GetInstance():RemoveListener(EventId.ShowMarchTrans, self.ShowMarchTransIconSignal)
  EventManager:GetInstance():RemoveListener(EventId.HideMarchTrans, self.HideMarchTransIconSignal)
end

local function RemoveOneEffect(self, uuid)
  local temp = self.allTips[uuid]
  if temp ~= nil then
    local request = temp.request
    temp:OnDestroy()
    request:Destroy()
    self.allTips[uuid] = nil
  end
  temp = self.OnCreateTips[uuid]
  if temp ~= nil then
    temp:Destroy()
    self.OnCreateTips[uuid] = nil
  end
end

local function HideMarchTransIconSignal(uuid)
  WorldTroopTransIconManager:GetInstance():RemoveOneEffect(tonumber(uuid))
end

local function ShowMarchTransIconSignal(uuid)
  WorldTroopTransIconManager:GetInstance():CheckShowEffect(tonumber(uuid))
end

local function CheckShowEffect(self, marchUuid)
  local info = CS.SceneManager.World:GetMarch(marchUuid)
  if info ~= nil and info:GetMarchStatus() == MarchStatus.TRANSPORT_BACK_HOME then
    local troop = CS.SceneManager.World:GetTroop(marchUuid)
    if troop ~= nil then
      local startTime = info.startTime
      local endTime = info.endTime
      local transform = troop:GetTransform()
      if self.allTips[marchUuid] == nil and self.OnCreateTips[marchUuid] == nil then
        local request = ResourceManager:InstantiateAsync(UIAssets.TroopTransUI)
        self.OnCreateTips[marchUuid] = request
        request:completed("+", function()
          self.OnCreateTips[marchUuid] = nil
          if request.isError then
            return
          end
          if transform == nil then
            request:Destroy()
          end
          request.gameObject:SetActive(true)
          request.gameObject.transform:SetParent(transform)
          request.gameObject.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
          request.gameObject.transform:Set_localPosition(0, 0, 0)
          local labelUI = WorldTroopTransIcon.New()
          labelUI:OnCreate(request)
          self.allTips[marchUuid] = labelUI
          self.allTips[marchUuid]:SetShowTime(startTime, endTime)
        end)
      elseif self.allTips[marchUuid] ~= nil then
        self.allTips[marchUuid]:SetShowTime(startTime, endTime)
      end
    else
      self:RemoveOneEffect(marchUuid)
    end
  end
end

WorldTroopTransIconManager.__init = __init
WorldTroopTransIconManager.__delete = __delete
WorldTroopTransIconManager.AddListener = AddListener
WorldTroopTransIconManager.RemoveListener = RemoveListener
WorldTroopTransIconManager.RemoveOneEffect = RemoveOneEffect
WorldTroopTransIconManager.CheckShowEffect = CheckShowEffect
WorldTroopTransIconManager.HideMarchTransIconSignal = HideMarchTransIconSignal
WorldTroopTransIconManager.ShowMarchTransIconSignal = ShowMarchTransIconSignal
return WorldTroopTransIconManager
