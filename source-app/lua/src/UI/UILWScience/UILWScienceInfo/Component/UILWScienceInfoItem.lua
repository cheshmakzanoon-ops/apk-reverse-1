local Item = BaseClass("Item", UIBaseContainer)
local base = UIBaseContainer
local UIGray = CS.UIGray
local Localization = CS.GameEntry.Localization
local bg1_go_path = "Bg1"
local bg2_go_path = "Bg2"
local bg3_go_path = "Bg3"
local name_text_path = "Name"
local value_text_path = "Value"
local power_text_path = "Power"

function Item:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function Item:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function Item:ComponentDefine()
  self.bg1Go = self:AddComponent(UIBaseContainer, bg1_go_path)
  self.bg2Go = self:AddComponent(UIBaseContainer, bg2_go_path)
  self.bg3Go = self:AddComponent(UIBaseContainer, bg3_go_path)
  self.nameText = self:AddComponent(UIText, name_text_path)
  self.valueText = self:AddComponent(UIText, value_text_path)
  self.powerText = self:AddComponent(UIText, power_text_path)
end

function Item:ComponentDestroy()
  self.bg1Go = nil
  self.bg2Go = nil
  self.bg3Go = nil
  self.nameText = nil
  self.valueText = nil
  self.powerText = nil
end

function Item:DataDefine()
  self.params = {}
end

function Item:DataDestroy()
  self.params = nil
end

function Item:OnEnable()
  base.OnEnable(self)
end

function Item:OnDisable()
  base.OnDisable(self)
end

function Item:OnAddListener()
  base.OnAddListener(self)
end

function Item:OnRemoveListener()
  base.OnRemoveListener(self)
end

function Item:SetData(param)
  self.params = param
  self.nameText:SetText(param.name)
  self.valueText:SetText(param.value)
  self.powerText:SetText(param.power)
  local showBg = param.showBg
  self.bg1Go:SetActive(showBg == 1)
  self.bg2Go:SetActive(showBg == 2)
  self.bg3Go:SetActive(showBg == 3)
end

return Item
