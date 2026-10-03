local base = UIBaseContainer
local CommonResultTabComponent = BaseClass("CommonResultTabComponent", UIBaseContainer)
local Localization = CS.GameEntry.Localization
local TabItem = require("UI.UIBattleResultComponents.CommonResultTabItemComponent")

function CommonResultTabComponent:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function CommonResultTabComponent:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function CommonResultTabComponent:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.imgHighlight = self.viewSkin:AddComponent(self, UIImage, 1)
  self.compTabItem = self.viewSkin:AddComponent(self, UIBaseComponent, 2)
  self.compImgBg = self.viewSkin:AddComponent(self, UIBaseContainer, 3)
  self.compTabItem.gameObject:SetActive(false)
  self.compTabItem.gameObject:GameObjectCreatePool()
end

function CommonResultTabComponent:ComponentDestroy()
  self.viewSkin = nil
  self.imgHighlight = nil
  self.compTabItem = nil
  self.compImgBg = nil
end

function CommonResultTabComponent:DataDefine()
  self.tabItems = {}
  
  function self.OnTabItemClickBind(index, itemData)
    self:OnTabItemClick(index, itemData)
  end
  
  self.parentSizeData = self.compImgBg:GetSizeDelta()
end

function CommonResultTabComponent:DataDestroy()
  if not IsNull(self.tabTween) then
    self.tabTween:Kill()
    self.tabTween = nil
  end
  self.itemSizeData = nil
  self.tabItems = nil
  self.curSelectIndex = nil
  self.compImgBg:RemoveComponents(TabItem)
  self.compTabItem.gameObject:GameObjectRecycleAll()
  self.parentSizeData = nil
  self.index = 0
end

function CommonResultTabComponent:ReInit(tabDatas, onTabClick)
  self.datas = tabDatas
  self.onTabClick = onTabClick
  self.compImgBg:RemoveComponents(TabItem)
  self.compTabItem.gameObject:GameObjectRecycleAll()
  if not self.datas then
    return
  end
  self.tabItems = {}
  self.index = 0
  for i = 1, #tabDatas do
    self.index = self.index + 1
    local go = self.compTabItem.gameObject:GameObjectSpawn(self.compImgBg.transform)
    go.name = "Tab" .. tostring(self.index)
    go:SetActive(true)
    local tabItem = self.compImgBg:AddComponent(TabItem, go.name)
    tabItem:ReInit(self.index, tabDatas[i], self.OnTabItemClickBind)
    self.tabItems[self.index] = tabItem
  end
  self.itemSizeData = Vector2.New(self.parentSizeData.x, self.parentSizeData.y)
  if 0 < #tabDatas then
    self.imgHighlight:SetActive(true)
    self.itemSizeData.x = self.parentSizeData.x / #tabDatas
    self.imgHighlight:SetSizeDeltaXY(self.itemSizeData.x, self.itemSizeData.y)
    self.tabItems[1]:SetIsOn(true)
  else
    self.curSelectIndex = nil
    self.imgHighlight:SetActive(false)
  end
end

function CommonResultTabComponent:OnTabItemClick(index, itemData)
  if self.curSelectIndex == index then
    return
  end
  if self.curSelectIndex and self.tabItems[self.curSelectIndex] then
    self.tabItems[self.curSelectIndex]:SetIsOn(false)
  end
  self.curSelectIndex = index
  if self.onTabClick then
    self.onTabClick(index, itemData)
  end
  if not IsNull(self.tabTween) then
    self.tabTween:Kill()
    self.tabTween = nil
  end
  self.tabTween = CS.DG.Tweening.DOTween.To(function()
    return self.imgHighlight:GetAnchoredPositionX()
  end, function(value)
    self.imgHighlight:SetAnchoredPositionXY(value, 0)
  end, (self.curSelectIndex - 1) * self.itemSizeData.x, 0.5):SetEase(CS.DG.Tweening.Ease.OutQuint)
end

return CommonResultTabComponent
