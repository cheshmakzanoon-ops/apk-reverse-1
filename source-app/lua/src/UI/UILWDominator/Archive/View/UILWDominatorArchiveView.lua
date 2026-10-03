local UILWDominatorArchiveView = BaseClass("UILWDominatorArchiveView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local UILWDominatorArchiveCellComponent = require("UI/UILWDominator/Archive/Component/UILWDominatorArchiveCellComponent")

function UILWDominatorArchiveView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:OnOpen()
end

function UILWDominatorArchiveView:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UILWDominatorArchiveView:OnOpen()
  self.uuid = self:GetUserData()
  self:UpdateAll()
end

function UILWDominatorArchiveView:UpdateAll()
  self.info = DataCenter.DominatorManager:GetInfoByUuid(self.uuid)
  if self.info == nil then
    self.ctrl:CloseSelf()
    return
  end
  self.mainTemplate = self.info:GetMainTemplate()
  if self.mainTemplate == nil then
    self.ctrl:CloseSelf()
    return
  end
  self.templates = DataCenter.DominatorTemplateManager:GetAllStoryShowTemplatesByGroupId(self.mainTemplate:GetStoryShowGroupId())
  if table.IsNullOrEmpty(self.templates) then
    self.ctrl:CloseSelf()
    return
  end
  self.textTitle:SetText(Localization:GetString(self.templates[1].title))
  self.textDes:SetText(Localization:GetString(self.templates[1].sub_title))
  self:ClearCells()
  self.items = {}
  for i, v in ipairs(self.templates) do
    local item = self.cellTemplate.gameObject:GameObjectSpawn(self.content.transform)
    item.name = "item" .. i
    local obj = self.content:AddComponent(UILWDominatorArchiveCellComponent, item.name)
    obj:SetActive(true)
    obj:ReInit(v, self.uuid)
    self.items[i] = obj
  end
end

function UILWDominatorArchiveView:ClearCells()
  self.content:RemoveComponents(UILWDominatorArchiveCellComponent)
  self.cellTemplate.gameObject:GameObjectRecycleAll()
  self.items = nil
end

function UILWDominatorArchiveView:OnUnlockCallback()
  self:UpdateAll()
end

function UILWDominatorArchiveView:ComponentDefine()
  self.btnPanel = self:AddComponent(UIButton, "Panel")
  self.btnPanel:SetOnClick(function()
    self:OnBtnPanelClick()
  end)
  self.textTitle = self:AddComponent(UIText, "Root/Top/TitleText")
  self.btnUICommonClose = self:AddComponent(UIButton, "Root/Top/UICommonCloseBtn")
  self.btnUICommonClose:SetOnClick(function()
    self:OnBtnUICommonCloseClick()
  end)
  self.textDes = self:AddComponent(UIText, "Root/Middle/DesText")
  self.content = self:AddComponent(UIBaseContainer, "Root/Middle/ScrollView/Viewport/Content")
  self.cellTemplate = self:AddComponent(UIBaseContainer, "Root/Middle/ScrollView/ArchiveCell")
  self.cellTemplate.gameObject:GameObjectCreatePool()
  self.cellTemplate:SetActive(false)
end

function UILWDominatorArchiveView:ComponentDestroy()
  self:ClearCells()
  self.btnPanel = nil
  self.textTitle = nil
  self.btnUICommonClose = nil
  self.textDes = nil
  self.content = nil
  self.cellTemplate = nil
end

function UILWDominatorArchiveView:DataDefine()
end

function UILWDominatorArchiveView:DataDestroy()
end

function UILWDominatorArchiveView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.DominatorArchiveUnlockSuccess, self.OnUnlockCallback)
end

function UILWDominatorArchiveView:OnRemoveListener()
  self:RemoveUIListener(EventId.DominatorArchiveUnlockSuccess, self.OnUnlockCallback)
  base.OnRemoveListener(self)
end

function UILWDominatorArchiveView:OnBtnPanelClick()
  self.ctrl:CloseSelf()
end

function UILWDominatorArchiveView:OnBtnUICommonCloseClick()
  self.ctrl:CloseSelf()
end

return UILWDominatorArchiveView
