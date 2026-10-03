local UIVip18HistoryItemComponent = BaseClass("UIVip18HistoryItemComponent", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local UIVip18HistoryMessageComponent = require("UI.UIVipExtend.UIVip18History.UIVip18HistoryMessageComponent")

function UIVip18HistoryItemComponent:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UIVip18HistoryItemComponent:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIVip18HistoryItemComponent:OnEnable()
  base.OnEnable(self)
end

function UIVip18HistoryItemComponent:OnDisable()
  base.OnDisable(self)
end

function UIVip18HistoryItemComponent:ComponentDefine()
  self.compGSystem = self:AddComponent(UIVip18HistoryMessageComponent, "gSystem")
  self.compGMyself = self:AddComponent(UIVip18HistoryMessageComponent, "gMyself")
end

function UIVip18HistoryItemComponent:ComponentDestroy()
  self.compGSystem = nil
  self.compGMyself = nil
end

function UIVip18HistoryItemComponent:DataDefine()
end

function UIVip18HistoryItemComponent:DataDestroy()
end

function UIVip18HistoryItemComponent:OnAddListener()
  base.OnAddListener(self)
end

function UIVip18HistoryItemComponent:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UIVip18HistoryItemComponent:SetData(data)
  if data.sender == "system" then
    self.compGSystem:SetActive(true)
    self.compGMyself:SetActive(false)
    self.compGSystem:SetData(data)
  else
    self.compGSystem:SetActive(false)
    self.compGMyself:SetActive(true)
    self.compGMyself:SetData(data)
  end
end

return UIVip18HistoryItemComponent
