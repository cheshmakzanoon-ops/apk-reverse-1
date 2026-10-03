local PveSelectionManager = BaseClass("SelectionManager")
local Resource = CS.GameEntry.Resource

local function __init(self)
  self.selection = nil
  self.allSelections = {}
  self.canRefresh = false
end

local function __delete(self)
  self.selection = nil
  self.allSelections = nil
  self.canRefresh = nil
end

local function Create(self)
  self.selection = nil
  self.allSelections = {}
  self.canRefresh = false
  self.req = Resource:InstantiateAsync("Assets/Main/Prefabs/PVELevel/TriggerSelect.prefab")
  self.req:completed("+", function(req)
    req.gameObject:SetActive(false)
  end)
end

local function Destroy(self)
  self.selection = nil
  self.allSelections = {}
  self.canRefresh = false
  if self.req then
    self.req:Destroy()
    self.req = nil
  end
end

local function Enabled(self)
  local joystick = DataCenter.BattleLevel.joystick
  if joystick == nil then
    return false
  end
  return true
end

local function GetSelection(self)
  return self.selection
end

local function IsSelection(self, type, id)
  return self.selection and self.selection.type == type and self.selection.id == id
end

local function GetData(self, type, id)
  if type == PveSelectionType.Trigger then
    return DataCenter.BattleLevel:GetTriggerByTriggerId(id)
  elseif type == PveSelectionType.DropReward then
    return DataCenter.BattleLevel.dropRewardMgr:GetDropReward(id)
  end
  return nil
end

local function Contains(self, type, id)
  for _, v in ipairs(self.allSelections) do
    if v.type == type and v.id == id then
      return true
    end
  end
  return false
end

local function Add(self, type, id)
  if not self:Contains(type, id) then
    table.insert(self.allSelections, {type = type, id = id})
    self:Refresh()
  end
end

local function Remove(self, type, id)
  for i, v in ipairs(self.allSelections) do
    if v.type == type and v.id == id then
      table.remove(self.allSelections, i)
      self:Refresh()
      break
    end
  end
end

local function Refresh(self)
  self.canRefresh = true
end

local function RefreshInternal(self)
  self.selection = nil
  local selectionPos = Vector3.zero
  if not table.IsNullOrEmpty(self.allSelections) then
    local playerPos = DataCenter.BattleLevel:GetPosition()
    local forward = DataCenter.BattleLevel.player:GetForward()
    local maxCos = -2
    for _, v in ipairs(self.allSelections) do
      local data = self:GetData(v.type, v.id)
      if data then
        local pos = data:GetPosition()
        local vec = Vector3.Normalize(pos - playerPos)
        local cos = Vector3.Dot(vec, forward)
        if maxCos < cos then
          maxCos = cos
          selectionPos = pos
          self.selection = v
        end
      end
    end
  end
  for _, v in ipairs(self.allSelections) do
    local data = self:GetData(v.type, v.id)
    if data then
      local showBubble = self:IsSelection(v.type, v.id)
      data:ShowBubble(showBubble)
    end
  end
  local joystick = DataCenter.BattleLevel.joystick
  if joystick ~= nil and self.req and not IsNull(self.req.gameObject) then
    if self.selection then
      self.req.gameObject:SetActive(true)
      self.req.gameObject.transform.position = selectionPos
      joystick:ShowCollect(true)
    else
      self.req.gameObject:SetActive(false)
      joystick:ShowCollect(false)
    end
  end
end

local function Do(self)
  if self.selection then
    local data = self:GetData(self.selection.type, self.selection.id)
    if data then
      data:DoSelectBubble()
    end
  end
end

local function OnUpdate(self)
  if self.canRefresh then
    self.canRefresh = false
    self:RefreshInternal()
  end
end

PveSelectionManager.__init = __init
PveSelectionManager.__delete = __delete
PveSelectionManager.Create = Create
PveSelectionManager.Destroy = Destroy
PveSelectionManager.Enabled = Enabled
PveSelectionManager.GetSelection = GetSelection
PveSelectionManager.IsSelection = IsSelection
PveSelectionManager.GetData = GetData
PveSelectionManager.Contains = Contains
PveSelectionManager.Add = Add
PveSelectionManager.Remove = Remove
PveSelectionManager.Refresh = Refresh
PveSelectionManager.RefreshInternal = RefreshInternal
PveSelectionManager.Do = Do
PveSelectionManager.OnUpdate = OnUpdate
return PveSelectionManager
