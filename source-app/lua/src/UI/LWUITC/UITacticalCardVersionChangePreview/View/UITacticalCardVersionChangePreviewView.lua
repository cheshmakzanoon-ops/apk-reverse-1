local UITacticalCardVersionChangePreviewView = BaseClass("UITacticalCardVersionChangePreviewView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local TCCardVersionChangePreviewItem = require("UI.LWUITC.Component.TCCardVersionChangePreviewItem")

function UITacticalCardVersionChangePreviewView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:ReInit()
end

function UITacticalCardVersionChangePreviewView:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UITacticalCardVersionChangePreviewView:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.loopListView2ScrollRect = self.viewSkin:AddComponent(self, UILoopListView2, 1)
  self.compContent = self.viewSkin:AddComponent(self, UIBaseContainer, 2)
  self.btnClose = self.viewSkin:AddComponent(self, UIButton, 3)
  self.btnClose:SetOnClick(function()
    self:OnBtnCloseClick()
  end)
  self.btnConfirm = self.viewSkin:AddComponent(self, UIButton, 4)
  self.btnConfirm:SetOnClick(function()
    self:OnBtnConfirmClick()
  end)
end

function UITacticalCardVersionChangePreviewView:ComponentDestroy()
  self.viewSkin = nil
  self.loopListView2ScrollRect = nil
  self.compContent = nil
  self.btnClose = nil
  self.btnConfirm = nil
end

function UITacticalCardVersionChangePreviewView:DataDefine()
  self.itemIndex = 0
end

function UITacticalCardVersionChangePreviewView:DataDestroy()
  self.itemIndex = nil
end

function UITacticalCardVersionChangePreviewView:OnAddListener()
  base.OnAddListener(self)
end

function UITacticalCardVersionChangePreviewView:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UITacticalCardVersionChangePreviewView:ReInit()
  self.loopListView2ScrollRect:InitListView(0, function(loopView, index)
    return self:OnGetItemByIndex(loopView, index)
  end)
  self.changeList = self:GetUserData()
  if not self.changeList or 0 >= #self.changeList then
    self.ctrl:CloseSelf()
    return
  end
  self.loopListView2ScrollRect:SetListItemCount(#self.changeList, false, false)
  self.loopListView2ScrollRect:RefreshAllShownItem()
end

function UITacticalCardVersionChangePreviewView:OnBtnCloseClick()
  self.ctrl:CloseSelf()
end

function UITacticalCardVersionChangePreviewView:OnBtnConfirmClick()
  self.ctrl:CloseSelf()
end

function UITacticalCardVersionChangePreviewView:OnGetItemByIndex(listview, index)
  local count = table.count(self.changeList)
  index = index + 1
  if index < 1 or count < index then
    return nil
  end
  local cardId = self.changeList[index].newCardId
  local cardTemplate = DataCenter.TacticalCardDataManager:GetTemplateData(cardId)
  if cardTemplate == nil then
    return nil
  end
  local item = listview:NewListViewItem(self:GetPrefabName(cardTemplate))
  local script = self.compContent:GetComponent(item.gameObject.name, TCCardVersionChangePreviewItem)
  if script == nil then
    local objectName = tostring(self.itemIndex)
    self.itemIndex = self.itemIndex + 1
    item.gameObject.name = objectName
    script = self.compContent:AddComponent(TCCardVersionChangePreviewItem, objectName)
  end
  script:SetData(self.changeList[index])
  script:SetActive(true)
  return item
end

function UITacticalCardVersionChangePreviewView:GetPrefabName(cardTemplate)
  if cardTemplate.type == TacticalCardType.Core then
    return "TCCoreCardVersionChangePreviewItem"
  else
    return "TCNormalCardVersionChangePreviewItem"
  end
end

return UITacticalCardVersionChangePreviewView
