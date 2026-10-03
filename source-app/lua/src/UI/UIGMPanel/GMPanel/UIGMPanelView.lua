local base = UIBaseView
local UIGMPanelView = BaseClass("UIGMPanelView", base)
local Localization = CS.GameEntry.Localization
local UIGMPanelPageToggle = require("UI.UIGMPanel.GMPanel.UIGMPanelPageToggle")

function UIGMPanelView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self.selected = -1
  self:InitPageStyles()
  self:InitToggles()
  self:RefreshToggles()
  self:RefreshSelected(self:GetDefaultSelection())
end

function UIGMPanelView:OnDestroy()
  self:ClearPageStyles()
  self:ClearToggles()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIGMPanelView:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.compMainRect = self.viewSkin:AddComponent(self, UIBaseComponent, 1)
  self.gridInfinityScrollViewContent = self.viewSkin:AddComponent(self, GridInfinityScrollView, 2)
  self.compToggleRect = self.viewSkin:AddComponent(self, UIBaseContainer, 3)
  self.btnImgBg = self.viewSkin:AddComponent(self, UIButton, 4)
  self.btnImgBg:SetOnClick(function()
    self:OnBtnImgBgClick()
  end)
  self.textTmpTitle = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 5)
  self.compRoot = self.viewSkin:AddComponent(self, UIBaseComponent, 6)
  self.imgBg0 = self.viewSkin:AddComponent(self, UIImage, 7)
  self.textTmpTitle:SetText("GM\232\174\190\231\189\174")
end

function UIGMPanelView:GetDefaultSelection()
  local _data = self:GetUserData()
  local default = GMUtils.lastPageName or "Favorite"
  local defaultPage = _data and _data.default or default
  if self.pageData then
    for k, v in ipairs(self.pageData) do
      if v and v.pageName == defaultPage then
        return k
      end
    end
  end
  return 1
end

function UIGMPanelView:ClearPageStyles()
  if self.pageStyles then
    for k, v in ipairs(self.pageStyles) do
      self[v] = nil
    end
    self.pageStyles = nil
  end
end

function UIGMPanelView:ClearToggles()
  self.compToggleRect:RemoveComponents(UIGMPanelPageToggle)
  self.gridInfinityScrollViewContent:DestroyChildNode()
  self.pageToggles = {}
  self.pageToggleList = {}
end

function UIGMPanelView:InitToggles()
  self:ClearToggles()
  self.gridInfinityScrollViewContent:Init(BindCallback(self, self.OnInitToggleCell), BindCallback(self, self.OnUpdateToggleCell), BindCallback(self, self.OnDestroyToggleCell))
end

function UIGMPanelView:RefreshToggles()
  self.pageData = self.ctrl:GetPages()
  self.gridInfinityScrollViewContent:SetItemCount(#self.pageData)
end

function UIGMPanelView:ComponentDestroy()
  self.viewSkin = nil
  self.compMainRect = nil
  self.gridInfinityScrollViewContent = nil
  self.compToggleRect = nil
  self.btnImgBg = nil
  self.textTmpTitle = nil
  self.compRoot = nil
  self.imgBg0 = nil
end

function UIGMPanelView:DataDefine()
end

function UIGMPanelView:DataDestroy()
end

function UIGMPanelView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.GM_Skin_Changed, self.RefreshSkin)
end

function UIGMPanelView:OnRemoveListener()
  self:RemoveUIListener(EventId.GM_Skin_Changed, self.RefreshSkin)
  base.OnRemoveListener(self)
end

function UIGMPanelView:InitPageStyles()
  if self.pageStyles then
    return
  end
  self.pageStyles = {}
  local styles = GMUtils.GetPageStyles()
  for k, v in pairs(styles) do
    self[v.name] = UIAsyncLoaderBridge.New(self, v.name, self.compRoot.transform, v.prefab, v.lua, false, Bind(self, self.RefreshPage))
    table.insert(self.pageStyles, v.name)
  end
end

function UIGMPanelView:OnInitToggleCell(go, index)
  local toggle = self.compToggleRect:AddComponent(UIGMPanelPageToggle, go)
  toggle:Setup(self)
  toggle:SetActive(false)
  self.pageToggles[go] = toggle
end

function UIGMPanelView:OnUpdateToggleCell(go, index)
  local cellItem = self.pageToggles[go]
  if cellItem then
    local theIndex = index + 1
    cellItem:SetActive(true)
    cellItem:ReInit(theIndex, self.pageData[theIndex])
    self.pageToggleList[theIndex] = cellItem
  end
end

function UIGMPanelView:OnDestroyToggleCell(go, index)
end

function UIGMPanelView:ClickedToggle(index, toggle)
  self:RefreshSelected(index)
end

function UIGMPanelView:RefreshSelected(index)
  if self.selected == index then
    return
  end
  self.selected = index
  for k, v in pairs(self.pageToggleList) do
    v:UpdateSelected(k == self.selected)
  end
  local currentPageData = self.pageData[index]
  self:RefreshPage()
end

function UIGMPanelView:RefreshPage()
  if not self.pageStyles then
    return
  end
  if not self.selected then
    return
  end
  local currentPageData = self.pageData[self.selected]
  if not currentPageData then
    return
  end
  local pageActivated
  for k, v in ipairs(self.pageStyles) do
    local page = self[v]
    if page then
      local active = v == currentPageData.style.name
      page:SetActive(active)
      if active then
        pageActivated = page
      end
    end
  end
  if pageActivated then
    pageActivated:Refresh(currentPageData)
  end
  GMUtils.lastPageName = currentPageData.pageName
end

function UIGMPanelView:RefreshSkin()
  local skin = GMUtils.GetSkinPath()
  self.imgBg0:LoadSpriteAuto(skin.panelBg)
  if self.pageToggleList then
    for k, v in pairs(self.pageToggleList) do
      v:RefreshSkin(skin)
    end
  end
end

function UIGMPanelView:OnBtnImgBgClick()
  self.ctrl:CloseSelf()
end

return UIGMPanelView
