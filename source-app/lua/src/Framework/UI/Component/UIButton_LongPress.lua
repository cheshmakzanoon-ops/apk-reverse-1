local UIButton_LongPress = BaseClass("UIButton_LongPress", UIBaseContainer)
local base = UIBaseContainer
local UnityButton = typeof(CS.UnityEngine.UI.Button_LongPress)

local function OnCreate(self)
  base.OnCreate(self)
  self.unity_uibutton = self.gameObject:GetComponent(UnityButton)
  if IsNull(self.unity_uibutton) then
    self.unity_uibutton = nil
  end
end

local function OnDestroy(self)
  if self.unity_uibutton then
    self.unity_uibutton:SetLongPressAction(nil)
    self.unity_uibutton:SetClickAction(nil)
  end
end

local function SetLongPressAction(self, callback)
  if not self.unity_uibutton then
    return
  end
  self.unity_uibutton:SetLongPressAction(callback)
end

local function SetClickAction(self, callback)
  if not self.unity_uibutton then
    return
  end
  self.unity_uibutton:SetClickAction(callback)
end

local function SetTouchBgGray(self, touchGray)
  if not self.unity_uibutton then
    return
  end
  self.unity_uibutton:SetTouchBgGray(touchGray)
end

UIButton_LongPress.OnCreate = OnCreate
UIButton_LongPress.OnDestroy = OnDestroy
UIButton_LongPress.SetLongPressAction = SetLongPressAction
UIButton_LongPress.SetClickAction = SetClickAction
UIButton_LongPress.SetTouchBgGray = SetTouchBgGray
return UIButton_LongPress
