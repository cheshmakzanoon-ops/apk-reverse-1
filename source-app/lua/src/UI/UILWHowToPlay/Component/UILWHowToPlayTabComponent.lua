local base = UIBaseContainer
local UILWHowToPlayTabComponent = BaseClass("UILWHowToPlayTabComponent", UIBaseContainer)
local Localization = CS.GameEntry.Localization

function UILWHowToPlayTabComponent:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UILWHowToPlayTabComponent:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UILWHowToPlayTabComponent:ComponentDefine()
  self.compTabFg = self:AddComponent(UIBaseContainer, "tabFg")
end

function UILWHowToPlayTabComponent:ComponentDestroy()
  self.compTabFg = nil
end

function UILWHowToPlayTabComponent:DataDefine()
end

function UILWHowToPlayTabComponent:DataDestroy()
end

function UILWHowToPlayTabComponent:OnAddListener()
  base.OnAddListener(self)
end

function UILWHowToPlayTabComponent:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UILWHowToPlayTabComponent:SetData(visible)
  self.compTabFg:SetActive(visible)
end

return UILWHowToPlayTabComponent
