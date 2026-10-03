local LWUIZombieRushItem = BaseClass("LWUIZombieRushItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization

function LWUIZombieRushItem:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function LWUIZombieRushItem:OnDestroy()
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

function LWUIZombieRushItem:ComponentDefine()
  self.checkmark = self:AddComponent(UIBaseComponent, "Checkmark")
  self.label = self:AddComponent(UIText, "Label")
  self.checkText = self:AddComponent(UIText, "Checkmark/CheckText")
  local btn = self:AddComponent(UIButton, "")
  btn:SetOnClick(function()
    self:OnBtnClick()
  end)
end

function LWUIZombieRushItem:ComponentDestroy()
  self.checkmark = nil
  self.label = nil
  self.checkText = nil
end

function LWUIZombieRushItem:DataDefine()
  self.level = 0
  self.callBack = nil
end

function LWUIZombieRushItem:DataDestroy()
  self.level = nil
  self.callBack = nil
end

function LWUIZombieRushItem:OnAddListener()
  base.OnAddListener(self)
end

function LWUIZombieRushItem:OnRemoveListener()
  base.OnRemoveListener(self)
end

function LWUIZombieRushItem:ExecuteCallback(callback, ...)
  if callback and type(callback) == "function" then
    self.callBack = callback
  else
    print("Invalid function provided")
  end
end

function LWUIZombieRushItem:Refresh(level)
  self.level = level
  self.label:SetText("Lv." .. level)
  self.checkText:SetText("Lv." .. level)
end

function LWUIZombieRushItem:SetCheckmark(isSelect)
  self.checkmark:SetActive(isSelect)
  self.label:SetActive(not isSelect)
end

function LWUIZombieRushItem:OnBtnClick()
  if self.callBack then
    self.callBack(self.level)
  end
end

return LWUIZombieRushItem
