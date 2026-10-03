local base = UIAsyncContainer
local UIGMPanelPageVerticalStyle = BaseClass("UIGMPanelPageVerticalStyle", base)
local Localization = CS.GameEntry.Localization
local UIGMPanelPageVerticalItem = require("UI.UIGMPanel.GMPanel.UIGMPanelPageVerticalItem")

function UIGMPanelPageVerticalStyle:OnCreate()
  base.OnCreate(self)
  self.listGO = {}
  self.itemList = {}
  self:ComponentDefine()
  self:DataDefine()
end

function UIGMPanelPageVerticalStyle:OnDestroy()
  self:ClearItems()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIGMPanelPageVerticalStyle:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.compUIGMPanelPageVertical = self.viewSkin:AddComponent(self, UIBaseContainer, 1)
  self.gridInfinityScrollViewContent = self.viewSkin:AddComponent(self, GridInfinityScrollView, 2)
  self.textTmpEmptyNotice = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 3)
  self:SetOffsetMinXY(0, 0)
  self:SetOffsetMaxXY(0, 0)
  self.gridInfinityScrollViewContent:Init(BindCallback(self, self.OnInitCell), BindCallback(self, self.OnUpdateCell), BindCallback(self, self.OnDestroyCell))
end

function UIGMPanelPageVerticalStyle:ComponentDestroy()
  self.viewSkin = nil
  self.compUIGMPanelPageVertical = nil
  self.gridInfinityScrollViewContent = nil
  self.textTmpEmptyNotice = nil
end

function UIGMPanelPageVerticalStyle:DataDefine()
end

function UIGMPanelPageVerticalStyle:DataDestroy()
end

function UIGMPanelPageVerticalStyle:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.GM_Fav_Refresh, self.OnFavRefreshed)
  self:AddUIListener(EventId.GM_Skin_Changed, self.RefreshSkin)
  self:AddUIListener(EventId.GM_Page_Rebuild, self.ForceRebuildPage)
end

function UIGMPanelPageVerticalStyle:OnRemoveListener()
  self:RemoveUIListener(EventId.GM_Fav_Refresh, self.OnFavRefreshed)
  self:RemoveUIListener(EventId.GM_Skin_Changed, self.RefreshSkin)
  self:RemoveUIListener(EventId.GM_Page_Rebuild, self.ForceRebuildPage)
  base.OnRemoveListener(self)
end

function UIGMPanelPageVerticalStyle:Refresh(pageData)
  if self.currentPageData == pageData then
    return
  end
  self.currentPageData = pageData
  self.itemData = GMUtils.GetPageItems(self.currentPageData)
  self:RebuildPageItems()
end

function UIGMPanelPageVerticalStyle:RebuildPageItems()
  self.gridInfinityScrollViewContent:SetItemCount(#self.itemData)
  if #self.itemData <= 0 then
    self.textTmpEmptyNotice:SetActive(true)
    self.textTmpEmptyNotice:SetText("\231\169\186\231\169\186\229\166\130\228\185\159\n\229\191\171\230\157\165\229\161\171\230\187\161\230\136\145\229\144\167\239\188\129")
  else
    self.textTmpEmptyNotice:SetActive(false)
  end
end

function UIGMPanelPageVerticalStyle:ClearItems()
  self.compUIGMPanelPageVertical:RemoveComponents(UIGMPanelPageVerticalItem)
  self.gridInfinityScrollViewContent:DestroyChildNode()
  self.listGO = {}
  self.itemList = {}
end

function UIGMPanelPageVerticalStyle:OnInitCell(go, index)
  local item = self.compUIGMPanelPageVertical:AddComponent(UIGMPanelPageVerticalItem, go)
  item:SetActive(false)
  self.listGO[go] = item
end

function UIGMPanelPageVerticalStyle:OnUpdateCell(go, index)
  local cellItem = self.listGO[go]
  if cellItem then
    local theIndex = index + 1
    cellItem:SetActive(true)
    cellItem:ReInit(theIndex, self.itemData[theIndex])
    self.itemList[theIndex] = cellItem
  end
end

function UIGMPanelPageVerticalStyle:OnFavRefreshed()
  if self.currentPageData and self.currentPageData.isFavorite then
    self.itemData = GMUtils.GetPageItems(self.currentPageData)
    self:RebuildPageItems()
  end
end

function UIGMPanelPageVerticalStyle:OnDestroyCell(go, index)
end

function UIGMPanelPageVerticalStyle:RefreshSkin()
  local skin = GMUtils.GetSkinPath()
  if self.itemList then
    for k, v in pairs(self.itemList) do
      if v then
        v:RefreshSkin(skin)
      end
    end
  end
end

function UIGMPanelPageVerticalStyle:ForceRebuildPage()
  if not self.currentPageData then
    return
  end
  self.itemData = GMUtils.GetPageItems(self.currentPageData)
  self:RebuildPageItems()
end

return UIGMPanelPageVerticalStyle
