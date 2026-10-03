local WorldTroopAttackBuildIconManager = BaseClass("WorldTroopAttackBuildIconManager", Singleton)
local ResourceManager = CS.GameEntry.Resource
local WorldTroopAttackBuildIcon = require("Scene.WorldTroopAttackBuildIcon.WorldTroopAttackBuildIcon")

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
  EventManager:GetInstance():AddListener(EventId.ShowTroopAtkBuildIcon, self.ShowTroopAtkBuildIconSignal)
  EventManager:GetInstance():AddListener(EventId.HideTroopAtkBuildIcon, self.HideTroopAtkBuildIconSignal)
end

local function RemoveListener(self)
  EventManager:GetInstance():RemoveListener(EventId.ShowTroopAtkBuildIcon, self.ShowTroopAtkBuildIconSignal)
  EventManager:GetInstance():RemoveListener(EventId.HideTroopAtkBuildIcon, self.HideTroopAtkBuildIconSignal)
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

local function HideTroopAtkBuildIconSignal(uuid)
  WorldTroopAttackBuildIconManager:GetInstance():RemoveOneEffect(tonumber(uuid))
end

local function ShowTroopAtkBuildIconSignal(uuid)
  WorldTroopAttackBuildIconManager:GetInstance():CheckShowEffect(tonumber(uuid))
end

local function CheckShowEffect(self, marchUuid)
  local info = CS.SceneManager.World:GetMarch(marchUuid)
  if info ~= nil and info:GetMarchStatus() == MarchStatus.DESTROY_WAIT then
    local troop = CS.SceneManager.World:GetTroop(marchUuid)
    if troop ~= nil and troop:IsBattle() == false then
      local startTime = info.startTime
      local endTime = info.endTime
      local transform = troop:GetTransform()
      if self.allTips[marchUuid] == nil and self.OnCreateTips[marchUuid] == nil then
        local request = ResourceManager:InstantiateAsync(UIAssets.TroopAttackBuildUI)
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
          local labelUI = WorldTroopAttackBuildIcon.New()
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

WorldTroopAttackBuildIconManager.__init = __init
WorldTroopAttackBuildIconManager.__delete = __delete
WorldTroopAttackBuildIconManager.AddListener = AddListener
WorldTroopAttackBuildIconManager.RemoveListener = RemoveListener
WorldTroopAttackBuildIconManager.RemoveOneEffect = RemoveOneEffect
WorldTroopAttackBuildIconManager.CheckShowEffect = CheckShowEffect
WorldTroopAttackBuildIconManager.HideTroopAtkBuildIconSignal = HideTroopAtkBuildIconSignal
WorldTroopAttackBuildIconManager.ShowTroopAtkBuildIconSignal = ShowTroopAtkBuildIconSignal
return WorldTroopAttackBuildIconManager
