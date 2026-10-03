local UIHorizontalOrVerticalLayoutGroup = BaseClass("UIHorizontalOrVerticalLayoutGroup", UIBaseContainer)
local base = UIBaseContainer
local UnityHorizontalOrVerticalLayoutGroup = typeof(CS.UnityEngine.UI.HorizontalOrVerticalLayoutGroup)

local function OnCreate(self, ...)
  base.OnCreate(self)
  self.unity_horizontalOrVerticalLayoutGroup = self.gameObject:GetComponent(UnityHorizontalOrVerticalLayoutGroup)
end

local function OnDestroy(self)
  self.unity_horizontalOrVerticalLayoutGroup = nil
  base.OnDestroy(self)
end

local function GetPadding(self)
  return self.unity_horizontalOrVerticalLayoutGroup.padding
end

local function GetSpacing(self)
  return self.unity_horizontalOrVerticalLayoutGroup.spacing
end

local function SetSpacing(self, value)
  self.unity_horizontalOrVerticalLayoutGroup.spacing = value
end

local function SetPaddingLeft(self, value)
  self.unity_horizontalOrVerticalLayoutGroup.padding.left = value
end

local function SetPaddingRight(self, value)
  self.unity_horizontalOrVerticalLayoutGroup.padding.right = value
end

local function SetPaddingTop(self, value)
  self.unity_horizontalOrVerticalLayoutGroup.padding.top = value
end

local function SetPaddingBottom(self, value)
  self.unity_horizontalOrVerticalLayoutGroup.padding.bottom = value
end

function UIHorizontalOrVerticalLayoutGroup:ChildControlHeight(value)
  self.unity_horizontalOrVerticalLayoutGroup.childControlHeight = value
end

function UIHorizontalOrVerticalLayoutGroup:ChildControlWidth(value)
  self.unity_horizontalOrVerticalLayoutGroup.childControlWidth = value
end

function UIHorizontalOrVerticalLayoutGroup:SetEnable(enable)
  if IsNull(self.unity_horizontalOrVerticalLayoutGroup) then
    return
  end
  self.unity_horizontalOrVerticalLayoutGroup.enabled = enable
end

function UIHorizontalOrVerticalLayoutGroup:CalculateVerticalLayout()
  if IsNull(self.unity_horizontalOrVerticalLayoutGroup) then
    return
  end
  self.unity_horizontalOrVerticalLayoutGroup:CalculateLayoutInputVertical()
end

function UIHorizontalOrVerticalLayoutGroup:CalculateHorizontalLayout()
  if IsNull(self.unity_horizontalOrVerticalLayoutGroup) then
    return
  end
  self.unity_horizontalOrVerticalLayoutGroup:CalculateLayoutInputHorizontal()
end

function UIHorizontalOrVerticalLayoutGroup:SetChildAlignment(value)
  if self.unity_horizontalOrVerticalLayoutGroup then
    self.unity_horizontalOrVerticalLayoutGroup.childAlignment = value
  end
end

UIHorizontalOrVerticalLayoutGroup.OnCreate = OnCreate
UIHorizontalOrVerticalLayoutGroup.OnDestroy = OnDestroy
UIHorizontalOrVerticalLayoutGroup.GetPadding = GetPadding
UIHorizontalOrVerticalLayoutGroup.GetSpacing = GetSpacing
UIHorizontalOrVerticalLayoutGroup.SetSpacing = SetSpacing
UIHorizontalOrVerticalLayoutGroup.SetPaddingLeft = SetPaddingLeft
UIHorizontalOrVerticalLayoutGroup.SetPaddingRight = SetPaddingRight
UIHorizontalOrVerticalLayoutGroup.SetPaddingTop = SetPaddingTop
UIHorizontalOrVerticalLayoutGroup.SetPaddingBottom = SetPaddingBottom
return UIHorizontalOrVerticalLayoutGroup
