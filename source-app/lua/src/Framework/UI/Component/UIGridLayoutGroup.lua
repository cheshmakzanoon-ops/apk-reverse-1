local UIGridLayoutGroup = BaseClass("UIGridLayoutGroup", UIBaseContainer)
local base = UIBaseContainer
local UnityGridLayoutGroup = typeof(CS.UnityEngine.UI.GridLayoutGroup)

local function OnCreate(self)
  base.OnCreate(self)
  self.unity_layout = self.gameObject:GetComponent(UnityGridLayoutGroup)
end

local function OnDestroy(self)
  self.unity_layout = nil
  base.OnDestroy(self)
end

local function SetConstraintCount(self, value)
  if not self.unity_layout then
    return
  end
  self.unity_layout.constraintCount = value
end

local function GetConstraintCount(self)
  if not self.unity_layout then
    return
  end
  return self.unity_layout.constraintCount
end

local function GetCellSize(self)
  if not self.unity_layout then
    return
  end
  return self.unity_layout.cellSize
end

local function GetCellSpacing(self)
  if not self.unity_layout then
    return
  end
  return self.unity_layout.spacing
end

local function SetCellSpacing(self, x, y)
  if not self.unity_layout then
    return
  end
  self.unity_layout.spacing = Vector2.New(x or 0, y or 0)
end

local function GetCellPadding(self)
  if not self.unity_layout then
    return
  end
  return self.unity_layout.padding
end

local function SetCellSize(self, x, y)
  if not self.unity_layout then
    return
  end
  self.unity_layout.cellSize = Vector2.New(x or 0, y or 0)
end

function UIGridLayoutGroup:SetEnable(enable)
  if self.unity_layout == nil then
    return
  end
  self.unity_layout.enabled = enable
end

UIGridLayoutGroup.OnCreate = OnCreate
UIGridLayoutGroup.OnDestroy = OnDestroy
UIGridLayoutGroup.SetConstraintCount = SetConstraintCount
UIGridLayoutGroup.GetConstraintCount = GetConstraintCount
UIGridLayoutGroup.GetCellSize = GetCellSize
UIGridLayoutGroup.GetCellSpacing = GetCellSpacing
UIGridLayoutGroup.SetCellSpacing = SetCellSpacing
UIGridLayoutGroup.GetCellPadding = GetCellPadding
UIGridLayoutGroup.SetCellSize = SetCellSize
return UIGridLayoutGroup
