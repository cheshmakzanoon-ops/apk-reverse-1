local T11PowerInfoView = BaseClass("T11PowerInfoView", UIBaseView)
local M = T11PowerInfoView
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local T11PowerInfoCalculateDisplayItem = require("UI.T11PowerInfo.Component.T11PowerInfoCalculateDisplayItem")

function M:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:InitView()
end

function M:OnDestroy()
  self:ClearScroll()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function M:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.textDesc = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 1)
  self.textTitle = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 2)
  self.btnClose = self.viewSkin:AddComponent(self, UIButton, 3)
  self.btnClose:SetOnClick(function()
    self:OnBtnCloseClick()
  end)
  self.scroll = self.viewSkin:AddComponent(self, UILoopListView2, 4)
  self.compContent = self.viewSkin:AddComponent(self, UIBaseContainer, 5)
  self.btnPanel = self.viewSkin:AddComponent(self, UIButton, 6)
  self.btnPanel:SetOnClick(function()
    self:OnBtnPanelClick()
  end)
  self.scroll:InitListView(0, function(listview, index)
    return self:GetScrollItem(listview, index)
  end)
end

function M:ComponentDestroy()
  self.viewSkin = nil
  self.textDesc = nil
  self.textTitle = nil
  self.btnClose = nil
  self.scroll = nil
  self.compContent = nil
  self.btnPanel = nil
end

function M:DataDefine()
  self.powerMap = {}
  self.items = {}
end

function M:DataDestroy()
  self.powerMap = nil
  self.items = nil
end

function M:OnAddListener()
  base.OnAddListener(self)
end

function M:OnRemoveListener()
  base.OnRemoveListener(self)
end

function M:OnBtnCloseClick()
  self.ctrl:CloseSelf()
end

function M:GetScrollItem(listview, index)
  index = index + 1
  if index < 1 or index > #self.powerMap then
    return nil
  end
  local powerInfo = self.powerMap[index]
  local item = listview:NewListViewItem("T11PowerInfoCalculateDisplayItem")
  local script = self.compContent:GetComponent(item.gameObject.name, T11PowerInfoCalculateDisplayItem)
  if script == nil then
    local objectName = tostring(NameCount)
    NameCount = NameCount + 1
    item.gameObject.name = objectName
    script = self.compContent:AddComponent(T11PowerInfoCalculateDisplayItem, objectName)
  end
  script:SetActive(true)
  script:SetData(powerInfo)
  return item
end

function M:InitView()
  self.textTitle:SetLocalText("soldier_eleven_hero_title")
  self.textDesc:SetLocalText("soldier_eleven_hero_info")
  self.powerMap = self.ctrl:GetPowerMap()
  if #self.powerMap == 0 then
    self.scroll:SetActive(false)
  else
    self.scroll:SetActive(true)
    self.scroll:SetListItemCount(#self.powerMap, false, false)
    self.scroll:RefreshAllShownItem()
  end
end

function M:ClearScroll()
  self.compContent:RemoveComponents(T11PowerInfoCalculateDisplayItem)
  self.scroll:ClearAllItems()
end

function M:OnBtnPanelClick()
  self.ctrl:CloseSelf()
end

return T11PowerInfoView
