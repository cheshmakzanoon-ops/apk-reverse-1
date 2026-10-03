local UICapacityAddView = BaseClass("UICapacityAddView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local CapacityProgress = require("UI.UICapacityAdd.Component.CapacityProgress")
local gather_list_path = "safeArea/gatherList"
local gather_icon_path = "safeArea/gatherList/iconObj"

local function OnCreate(self)
  base.OnCreate(self)
  self.gather_list = self:AddComponent(UIBaseContainer, gather_list_path)
  self.gather_icon = self:AddComponent(UIBaseContainer, gather_icon_path)
  self.gatherCells = {}
  self.model = {}
  self.onCreateCell = {}
end

local function OnDestroy(self)
  self.gather_list:RemoveComponents(CapacityProgress)
  if self.model ~= nil then
    for k, v in pairs(self.model) do
      if v ~= nil then
        self:GameObjectDestroy(v)
      end
    end
  end
  self.gather_list = nil
  self.gather_icon = nil
  self.gatherCells = nil
  self.model = nil
  base.OnDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function GetCapacityPos(self, itemType)
  local pos
  if self.gatherCells ~= nil and self.gatherCells[itemType] ~= nil then
    pos = self.gatherCells[itemType]:GetCapacityPos()
  end
  if pos == nil or pos.x < 0 then
    if self.gather_icon ~= nil then
      pos = Vector3.New(self.gather_icon.transform.position.x, self.gather_icon.transform.position.y - 60, self.gather_icon.transform.position.z)
    else
      pos = Vector3.New(0, 0, 0)
    end
  end
  return pos
end

local function ShowCapacity(self, itemType)
  if self.gatherCells ~= nil then
    if self.gatherCells[itemType] == nil and self.onCreateCell[itemType] == nil then
      self.onCreateCell[itemType] = 1
      self.model[itemType] = self:GameObjectInstantiateAsync(UIAssets.UIMainGatherItem, function(request)
        if request.isError then
          return
        end
        self.onCreateCell[itemType] = nil
        local go = request.gameObject
        go.gameObject:SetActive(true)
        go.transform:SetParent(self.gather_list.transform)
        CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.gather_list.transform)
        go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
        local nameStr = tostring(NameCount)
        go.name = nameStr
        NameCount = NameCount + 1
        local cell = self.gather_list:AddComponent(CapacityProgress, nameStr)
        self.gatherCells[itemType] = cell
        self.gatherCells[itemType]:ShowCapacity(itemType)
      end)
    elseif self.gatherCells[itemType] ~= nil then
      self.gatherCells[itemType]:ShowCapacity(itemType)
    end
  end
end

local function DestroyCapacityItemByItemId(self, itemType)
  if self.model[itemType] ~= nil then
    self.gatherCells[itemType] = nil
  end
  if self.gatherCells ~= nil and table.count(self.gatherCells) <= 0 then
    self.gather_list:RemoveComponents(CapacityProgress)
    if self.model ~= nil then
      for k, v in pairs(self.model) do
        if v ~= nil then
          self:GameObjectDestroy(v)
        end
      end
    end
    self.model = {}
    self.ctrl:CloseSelf()
  end
end

local function AddResourceItem(self, data)
  local strArr = string.split(data, ";")
  if 1 < #strArr then
    local itemType = tonumber(strArr[1])
    local num = tonumber(strArr[2])
    if self.gatherCells ~= nil and self.gatherCells[itemType] ~= nil then
      self.gatherCells[itemType]:AddResourceItem(num)
    end
  end
end

local function OnAddListener(self)
  base.OnAddListener(self)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
end

UICapacityAddView.OnCreate = OnCreate
UICapacityAddView.OnDestroy = OnDestroy
UICapacityAddView.OnEnable = OnEnable
UICapacityAddView.OnDisable = OnDisable
UICapacityAddView.GetCapacityPos = GetCapacityPos
UICapacityAddView.ShowCapacity = ShowCapacity
UICapacityAddView.DestroyCapacityItemByItemId = DestroyCapacityItemByItemId
UICapacityAddView.AddResourceItem = AddResourceItem
UICapacityAddView.OnAddListener = OnAddListener
UICapacityAddView.OnRemoveListener = OnRemoveListener
return UICapacityAddView
