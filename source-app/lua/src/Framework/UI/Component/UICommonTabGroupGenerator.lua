local UICommonTabGroupGenerator = BaseClass("UICommonTabGroupGenerator", UIBaseContainer)
local base = UIBaseContainer
local CSCommonTabGroupGenerator = typeof(CS.CommonTabGroupGenerator)
local ButtonRef = {}

function UICommonTabGroupGenerator.AddRef(btn)
  local ref = (ButtonRef[btn] or 0) + 1
  ButtonRef[btn] = ref
  return ref
end

function UICommonTabGroupGenerator.DecRef(btn)
  local ref = (ButtonRef[btn] or 0) - 1
  if ref <= 0 then
    ref = 0
    ButtonRef[btn] = nil
  else
    ButtonRef[btn] = ref
  end
  return ref
end

function UICommonTabGroupGenerator:OnCreate(relative_path)
  base.OnCreate(self)
  self.cs_tabGroup = self.gameObject:GetComponent(CSCommonTabGroupGenerator)
  if self.cs_tabGroup then
    UICommonTabGroupGenerator.AddRef(self.cs_tabGroup)
  end
  self.__ontabchanged = nil
end

function UICommonTabGroupGenerator:OnDestroy()
  self:ClearTabs()
  if self.__ontabchanged ~= nil then
    self.cs_tabGroup.onTabChanged:RemoveListener(self.__ontabchanged)
  end
  if self.cs_tabGroup then
    local ref = UICommonTabGroupGenerator.DecRef(self.cs_tabGroup)
    if ref <= 0 then
      pcall(function()
        self.cs_tabGroup.onTabChanged:Clear()
      end)
    end
  end
  self.cs_tabGroup = nil
  self.__ontabchanged = nil
  base.OnDestroy(self)
end

function UICommonTabGroupGenerator:SetOnTabChanged(action)
  if action then
    if self.__ontabchanged then
      self.cs_tabGroup.onTabChanged:RemoveListener(self.__ontabchanged)
    end
    self.__ontabchanged = action
    self.cs_tabGroup.onTabChanged:AddListener(self.__ontabchanged)
  elseif self.__ontabchanged then
    self.cs_tabGroup.onTabChanged:RemoveListener(self.__ontabchanged)
    self.__ontabchanged = nil
  end
end

function UICommonTabGroupGenerator:GenerateTabs(nameArray, spritePathArray, defaultSelectIndex)
  if self.cs_tabGroup == nil then
    return
  end
  if defaultSelectIndex == nil then
    defaultSelectIndex = -1
  end
  self.cs_tabGroup:GenerateTabs(nameArray, spritePathArray, defaultSelectIndex)
end

function UICommonTabGroupGenerator:ClearTabs()
  if self.cs_tabGroup == nil then
    return
  end
  self.cs_tabGroup:ClearTabs()
end

function UICommonTabGroupGenerator:SelectTab(index, immediate)
  if self.cs_tabGroup == nil then
    return
  end
  self.cs_tabGroup:SelectTab(index, immediate and true or false)
end

function UICommonTabGroupGenerator:ScrollToTab(index)
  if self.cs_tabGroup == nil then
    return
  end
  self.cs_tabGroup:ScrollToTab(index)
end

function UICommonTabGroupGenerator:SetAutoScrollEnabled(autoScrollEnabled)
  if self.cs_tabGroup == nil then
    return
  end
  self.cs_tabGroup:SetAutoScrollEnabled(autoScrollEnabled and true or false)
end

function UICommonTabGroupGenerator:SetTabInteractable(index, interactable)
  if self.cs_tabGroup == nil then
    return
  end
  self.cs_tabGroup:SetTabInteractable(index, interactable)
end

function UICommonTabGroupGenerator:SetTabRedPoint(index, redCount)
  if self.cs_tabGroup == nil then
    return
  end
  self.cs_tabGroup:SetTabRedPoint(index, redCount)
end

function UICommonTabGroupGenerator:GetCurrentSelectIndex()
  if self.cs_tabGroup == nil then
    return -1
  end
  return self.cs_tabGroup:GetCurrentSelectIndex()
end

return UICommonTabGroupGenerator
