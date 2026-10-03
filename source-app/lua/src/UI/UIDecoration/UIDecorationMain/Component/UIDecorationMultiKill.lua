local UIDecorationMultiKill = BaseClass("UIDecorationMultiKill", UIBaseContainer)
local UIMultiKill = require("UI.UIDecoration.UIDecorationMain.Component.UIMultiKill")
local base = UIBaseContainer

function UIDecorationMultiKill:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UIDecorationMultiKill:OnDestroy()
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

function UIDecorationMultiKill:ComponentDefine()
end

function UIDecorationMultiKill:ComponentDestroy()
  if self.req then
    self:RemoveComponents(UIMultiKill)
    self:GameObjectDestroy(self.req)
    self.req = nil
  end
end

function UIDecorationMultiKill:DataDefine()
  self.decorationId = nil
  self.template = nil
end

function UIDecorationMultiKill:DataDestroy()
  self.decorationId = nil
  self.template = nil
end

function UIDecorationMultiKill:OnEnable()
  base.OnEnable(self)
end

function UIDecorationMultiKill:OnDisable()
  base.OnDisable(self)
end

function UIDecorationMultiKill:ReInit(decorationId)
  if self.decorationId == decorationId then
    return
  end
  self.decorationId = decorationId
  self.template = DataCenter.DecorationTemplateManager:GetTemplate(decorationId)
  if self.req then
    self:RemoveComponents(UIMultiKill)
    self:GameObjectDestroy(self.req)
    self.req = nil
  end
  self.req = self:GameObjectInstantiateAsync(self.template.model, function(req)
    local go = req.gameObject
    go:SetActive(true)
    go.transform:SetParent(self.transform)
    go.transform:Set_localScale(1, 1, 1)
    go.transform:Set_localPosition(0, 0, 0)
    local cell = self:AddComponent(UIMultiKill, go.name)
    cell:RefreshView()
  end)
end

return UIDecorationMultiKill
