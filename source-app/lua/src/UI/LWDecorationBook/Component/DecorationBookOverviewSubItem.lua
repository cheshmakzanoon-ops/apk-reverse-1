local DecorationBookOverviewSubItem = BaseClass("DecorationBookOverviewSubItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization

function DecorationBookOverviewSubItem:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function DecorationBookOverviewSubItem:OnDestroy()
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

function DecorationBookOverviewSubItem:ComponentDefine()
  self.root = self:AddComponent(UIBaseContainer, "")
  self.bg = self:AddComponent(UIBaseContainer, "BG")
  self.name = self:AddComponent(UIText, "Content/name")
  self.value = self:AddComponent(UIText, "Content/value")
  self.detailBtn = self:AddComponent(UIButton, "detailBtn")
  self.detailBtn:SetOnClick(function()
    self:OnBtnClick()
  end)
end

function DecorationBookOverviewSubItem:ComponentDestroy()
  self.root = nil
  self.name = nil
  self.value = nil
  self.detailBtn = nil
end

function DecorationBookOverviewSubItem:DataDefine()
end

function DecorationBookOverviewSubItem:DataDestroy()
end

function DecorationBookOverviewSubItem:OnBtnClick()
  local oneData = {}
  oneData.effectId = self.effectId
  oneData.totalValue = self.totalValue
  UIManager:GetInstance():OpenWindow(UIWindowNames.LWDecorationBookDetail, {anim = false}, oneData)
end

function DecorationBookOverviewSubItem:Refresh(effectId, value, index)
  self.effectId = effectId
  self.totalValue = value
  self.desc, self.val = WorkerUtil.GetEffectText(effectId, value, true)
  self.name:SetText(self.desc)
  self.value:SetText(self.val)
  self.bg:SetActive(index % 2 == 0)
end

return DecorationBookOverviewSubItem
