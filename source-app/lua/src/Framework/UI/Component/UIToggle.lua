local UIToggle = BaseClass("UIToggle", UIBaseContainer)
local base = UIBaseContainer
local UnityToggle = typeof(CS.UnityEngine.UI.Toggle)
local ButtonRef = {}

function UIToggle.AddRef(btn)
  local ref = (ButtonRef[btn] or 0) + 1
  ButtonRef[btn] = ref
  return ref
end

function UIToggle.DecRef(btn)
  local ref = (ButtonRef[btn] or 0) - 1
  if ref <= 0 then
    ref = 0
    ButtonRef[btn] = nil
  else
    ButtonRef[btn] = ref
  end
  return ref
end

function UIToggle:OnCreate(relative_path)
  base.OnCreate(self)
  self.unity_uitoggle = self.gameObject:GetComponent(UnityToggle)
  if self.unity_uitoggle then
    UIToggle.AddRef(self.unity_uitoggle)
  end
  self.__onvaluechanged = nil
end

function UIToggle:SetIsOn(tf)
  if self.selecting == nil then
    self.selecting = true
  else
    self.selecting = tf
  end
  self.unity_uitoggle.isOn = tf
end

function UIToggle:SetIsOnWithoutNotify(tf)
  self.unity_uitoggle:SetIsOnWithoutNotify(tf)
end

function UIToggle:GetIsOn()
  return self.unity_uitoggle.isOn
end

function UIToggle:SetOnValueChanged(action)
  if action then
    if self.__onvaluechanged then
      self.unity_uitoggle.onValueChanged:RemoveListener(self.__onvaluechanged)
    end
    self.__onvaluechanged = action
    self.unity_uitoggle.onValueChanged:AddListener(self.__onvaluechanged)
  elseif self.__onvaluechanged then
    self.unity_uitoggle.onValueChanged:RemoveListener(self.__onvaluechanged)
    self.__onvaluechanged = nil
  end
end

function UIToggle:SetGroup(group)
  self.unity_uitoggle.group = group
end

function UIToggle:OnDestroy()
  if self.__onvaluechanged ~= nil then
    self.unity_uitoggle.onValueChanged:RemoveListener(self.__onvaluechanged)
  end
  if self.unity_uitoggle then
    local ref = UIToggle.DecRef(self.unity_uitoggle)
    if ref <= 0 then
      pcall(function()
        self.unity_uitoggle.onValueChanged:Clear()
      end)
    end
  end
  self.unity_uitoggle = nil
  self.__onvaluechanged = nil
  base.OnDestroy(self)
end

function UIToggle:SetInteractable(value)
  self.unity_uitoggle.interactable = value
end

function UIToggle:SetEnable(enable)
  if self.unity_uitoggle == nil then
    return
  end
  self.unity_uitoggle.enabled = enable
end

return UIToggle
