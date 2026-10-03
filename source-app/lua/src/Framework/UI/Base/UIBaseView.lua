local UIBaseView = BaseClass("UIBaseView", UIBaseContainer)
local base = UIBaseContainer

local function __init(self, holder, var_arg, ctrl)
  self.ctrl = ctrl
end

local function OnCreate(self)
  base.OnCreate(self)
  self.rectTransform:Set_offsetMax(0, 0)
  self.rectTransform:Set_offsetMin(0, 0)
  self.rectTransform:Set_anchorMin(0, 0)
  self.rectTransform:Set_anchorMax(1, 1)
  self.rectTransform:Set_localScale(1, 1, 1)
  self.rectTransform:Set_localPosition(0, 0, 0)
  self.rectTransform:SetAsLastSibling()
end

local function OnDestroy(self)
  self.ctrl = nil
  base.OnDestroy(self)
end

local function SetUserData(self, userData)
  self.userData = userData
end

local function GetUserData(self)
  return SafeUnpack(self.userData)
end

local function ReopenWithoutCreate(self)
  self.rectTransform:SetAsLastSibling()
end

UIBaseView.__init = __init
UIBaseView.GetUserData = GetUserData
UIBaseView.SetUserData = SetUserData
UIBaseView.OnCreate = OnCreate
UIBaseView.OnDestroy = OnDestroy
UIBaseView.ReopenWithoutCreate = ReopenWithoutCreate
return UIBaseView
