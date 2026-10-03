local UIActMonopolyGridTipView = BaseClass("UIActMonopolyGridTipView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local UIActMonopolyEventItem = require("UI.UIActMonopoly.UIActMonopolyGridTip.Component.UIActMonopolyEventItem")
local bullet_content_path = "content/bulletContent"
local title_bullet_content_path = "content/bulletContent/TitleBulletContent"
local bullet_scroll_view_path = "content/bulletContent/conBulletContent/bulletScrollView"
local event_list_content_path = "content/eventListContent"
local event_scroll_view_path = "content/eventListContent/eventListContentBg/eventScrollView"
local event_list_content_bg_path = "content/eventListContent/eventListContentBg"
local ParamData = {
  targetPos = Vector2.zero,
  showTitle = nil,
  showTxt = nil,
  boxReward = nil,
  bossDamageTitle = nil,
  bossDamageReward = nil,
  gridData = nil,
  gridCurRewarrd = nil,
  gridNextRewarrd = nil,
  eventList = nil
}
local ParamDataClass = DataClass("ParamDataClass", ParamData)

local function OnCreate(self)
  base.OnCreate(self)
  self.data = self:GetUserData()
  self:ComponentDefine()
  self:RefreshView()
end

local function OnDestroy(self)
  self:ComponentDestroy()
  base.OnDestroy(self)
end

local function ComponentDefine(self)
  local btnPanel = self:AddComponent(UIButton, "Panel")
  btnPanel:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.imgArrow = self:AddComponent(UIBaseContainer, "ImgArrow")
  self.content = self:AddComponent(UIBaseContainer, "content")
  self.midPos = self:AddComponent(UIBaseContainer, "midPos")
  self.targetPos = self:AddComponent(UIBaseContainer, "targetPos")
  self.textContent = self:AddComponent(UIBaseContainer, "content/textContent")
  self.conTextContent = self:AddComponent(UIText, "content/textContent/conTextContent")
  self.titleTextContent = self:AddComponent(UIText, "content/textContent/TitleTextContent")
  self.bullet_content = self:AddComponent(UIBaseContainer, bullet_content_path)
  self.title_bullet_content = self:AddComponent(UIText, title_bullet_content_path)
  self.bullet_scroll_view = self:AddComponent(UIScrollView, bullet_scroll_view_path)
  self.bullet_scroll_view:SetOnItemMoveIn(function(itemObj, index)
    self:OnBulletItemMoveIn(itemObj, index)
  end)
  self.bullet_scroll_view:SetOnItemMoveOut(function(itemObj, index)
    self:OnBulletItemMoveOut(itemObj, index)
  end)
  self.boxContent = self:AddComponent(UIBaseContainer, "content/boxContent")
  self.boxScrollView = self:AddComponent(UIScrollView, "content/boxContent/conBoxContent/boxScrollView")
  self.boxScrollView:SetOnItemMoveIn(function(itemObj, index)
    self:OnItemMoveIn(itemObj, index)
  end)
  self.boxScrollView:SetOnItemMoveOut(function(itemObj, index)
    self:OnItemMoveOut(itemObj, index)
  end)
  self.curContent = self:AddComponent(UIBaseContainer, "content/curContent")
  self.curScrollView = self:AddComponent(UIScrollView, "content/curContent/conCurContent/curScrollView")
  self.curScrollView:SetOnItemMoveIn(function(itemObj, index)
    self:OnCurItemMoveIn(itemObj, index)
  end)
  self.curScrollView:SetOnItemMoveOut(function(itemObj, index)
    self:OnCurItemMoveOut(itemObj, index)
  end)
  self.nextContent = self:AddComponent(UIBaseContainer, "content/nextContent")
  self.nextScrollView = self:AddComponent(UIScrollView, "content/nextContent/conNextContent/nextScrollView")
  self.nextScrollView:SetOnItemMoveIn(function(itemObj, index)
    self:OnNextItemMoveIn(itemObj, index)
  end)
  self.nextScrollView:SetOnItemMoveOut(function(itemObj, index)
    self:OnNextItemMoveOut(itemObj, index)
  end)
  self.event_list_content = self:AddComponent(UIBaseContainer, event_list_content_path)
  self.event_scroll_view = self:AddComponent(UIScrollView, event_scroll_view_path)
  self.event_scroll_view:SetOnItemMoveIn(function(itemObj, index)
    self:OnEventItemMoveIn(itemObj, index)
  end)
  self.event_scroll_view:SetOnItemMoveOut(function(itemObj, index)
    self:OnEventItemMoveOut(itemObj, index)
  end)
  self.event_list_content_bg = self:AddComponent(UILayoutElement, event_list_content_bg_path)
  self.infoContent = self:AddComponent(UIBaseContainer, "content/infoContent")
  self.lvNum = self:AddComponent(UIText, "content/infoContent/conInfoContent/lvNum")
  self.expNum = self:AddComponent(UIText, "content/infoContent/conInfoContent/expNum")
end

local function ComponentDestroy(self)
  self:ClearScroll()
  self:ClearBulletScroll()
  self:ClearCurScroll()
  self:ClearNextScroll()
  self:ClearEventScroll()
end

local function RefreshView(self)
  if self.data.showTxt then
    self.textContent:SetActive(true)
    self.titleTextContent:SetText(self.data.showTitle)
    self.conTextContent:SetText(self.data.showTxt)
  else
    self.textContent:SetActive(false)
  end
  self:RefreshList()
  self:RefreshBulletList()
  self:RefreshCurList()
  self:RefreshNextList()
  self:RefreshEventList()
  if self.data.gridData then
    self.infoContent:SetActive(true)
    self.lvNum:SetText(self.data.gridData.curLv)
    local expStr = self.data.gridData.curMaxExp <= 0 and Localization:GetString("151091") or string.format("%d/%d", self.data.gridData.curExp, self.data.gridData.curMaxExp)
    self.expNum:SetText(expStr)
  else
    self.infoContent:SetActive(false)
  end
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.content.transform)
  self.midPos:SetAnchoredPositionXY(0, 0)
  self.targetPos:SetPositionXYZ(self.data.targetPos.x, self.data.targetPos.y, 0)
  local midPosAnchoredPos = self.midPos:GetAnchoredPosition()
  local targetPosAnchoredPos = self.targetPos:GetAnchoredPosition()
  local contentSize = self.content:GetSizeDelta()
  local imgArrowSize = self.imgArrow:GetSizeDelta()
  if targetPosAnchoredPos.y > midPosAnchoredPos.y then
    self.imgArrow:SetEulerAnglesXYZ(0, 0, 0)
    self.imgArrow:SetAnchoredPositionXY(targetPosAnchoredPos.x, targetPosAnchoredPos.y - imgArrowSize.y / 2)
  else
    self.imgArrow:SetEulerAnglesXYZ(0, 0, 180)
    self.imgArrow:SetAnchoredPositionXY(targetPosAnchoredPos.x, targetPosAnchoredPos.y + imgArrowSize.y / 2)
  end
  local contentPosY = 0
  local contentPosX = 0
  if targetPosAnchoredPos.y > midPosAnchoredPos.y then
    local yd = targetPosAnchoredPos.y - imgArrowSize.y - midPosAnchoredPos.y + 3
    contentPosY = yd - contentSize.y / 2
  else
    local yd = targetPosAnchoredPos.y + imgArrowSize.y - midPosAnchoredPos.y - 6
    contentPosY = yd + contentSize.y / 2
  end
  if targetPosAnchoredPos.x > midPosAnchoredPos.x then
    local xd = targetPosAnchoredPos.x + imgArrowSize.x - midPosAnchoredPos.x
    contentPosX = xd - contentSize.x / 2
  else
    local xd = targetPosAnchoredPos.x - imgArrowSize.x - midPosAnchoredPos.x
    contentPosX = xd + contentSize.x / 2
  end
  self.content:SetAnchoredPositionXY(contentPosX, contentPosY)
end

local function ClearScroll(self)
  self.boxScrollView:ClearCells()
  self.boxScrollView:RemoveComponents(UICommonResItem)
end

local function RefreshList(self)
  self:ClearScroll()
  if self.data.boxReward and #self.data.boxReward > 0 then
    self.boxContent:SetActive(true)
    self.boxScrollView:SetTotalCount(#self.data.boxReward)
    self.boxScrollView:RefillCells()
  else
    self.boxContent:SetActive(false)
  end
end

local function OnItemMoveIn(self, itemObj, index)
  itemObj.name = tostring(index)
  local cellItem = self.boxScrollView:AddComponent(UICommonResItem, itemObj)
  cellItem:ReInit(self.data.boxReward[index])
end

local function OnItemMoveOut(self, itemObj, index)
  self.boxScrollView:RemoveComponent(itemObj.name, UICommonResItem)
end

local function ClearBulletScroll(self)
  self.bullet_scroll_view:ClearCells()
  self.bullet_scroll_view:RemoveComponents(UICommonResItem)
end

local function RefreshBulletList(self)
  self:ClearBulletScroll()
  if self.data.bossDamageReward and #self.data.bossDamageReward > 0 then
    self.bullet_content:SetActive(true)
    self.bullet_scroll_view:SetTotalCount(#self.data.bossDamageReward)
    self.bullet_scroll_view:RefillCells()
    self.title_bullet_content:SetText(self.data.bossDamageTitle)
  else
    self.bullet_content:SetActive(false)
  end
end

local function OnBulletItemMoveIn(self, itemObj, index)
  itemObj.name = tostring(index)
  local cellItem = self.bullet_scroll_view:AddComponent(UICommonResItem, itemObj)
  cellItem:ReInit(self.data.bossDamageReward[index])
end

local function OnBulletItemMoveOut(self, itemObj, index)
  self.bullet_scroll_view:RemoveComponent(itemObj.name, UICommonResItem)
end

local function ClearCurScroll(self)
  self.curScrollView:ClearCells()
  self.curScrollView:RemoveComponents(UICommonResItem)
end

local function RefreshCurList(self)
  self:ClearCurScroll()
  if self.data.gridCurRewarrd and #self.data.gridCurRewarrd > 0 then
    self.curContent:SetActive(true)
    self.curScrollView:SetTotalCount(#self.data.gridCurRewarrd)
    self.curScrollView:RefillCells()
  else
    self.curContent:SetActive(false)
  end
end

local function OnCurItemMoveIn(self, itemObj, index)
  itemObj.name = tostring(index)
  local cellItem = self.curScrollView:AddComponent(UICommonResItem, itemObj)
  cellItem:ReInit(self.data.gridCurRewarrd[index])
end

local function OnCurItemMoveOut(self, itemObj, index)
  self.curScrollView:RemoveComponent(itemObj.name, UICommonResItem)
end

local function ClearNextScroll(self)
  self.nextScrollView:ClearCells()
  self.nextScrollView:RemoveComponents(UICommonResItem)
end

local function RefreshNextList(self)
  self:ClearNextScroll()
  if self.data.gridNextRewarrd and #self.data.gridNextRewarrd > 0 then
    self.nextContent:SetActive(true)
    self.nextScrollView:SetTotalCount(#self.data.gridNextRewarrd)
    self.nextScrollView:RefillCells()
  else
    self.nextContent:SetActive(false)
  end
end

local function OnNextItemMoveIn(self, itemObj, index)
  itemObj.name = tostring(index)
  local cellItem = self.nextScrollView:AddComponent(UICommonResItem, itemObj)
  cellItem:ReInit(self.data.gridNextRewarrd[index])
end

local function OnNextItemMoveOut(self, itemObj, index)
  self.nextScrollView:RemoveComponent(itemObj.name, UICommonResItem)
end

local function ClearEventScroll(self)
  self.event_scroll_view:ClearCells()
  self.event_scroll_view:RemoveComponents(UIActMonopolyEventItem)
end

local function RefreshEventList(self)
  self:ClearEventScroll()
  if self.data.eventList and #self.data.eventList > 0 then
    local itemNum = #self.data.eventList
    local maxHeight = 360
    local itemHeight = 102
    local spaceH = 6
    local allItemH = itemHeight * itemNum + spaceH * (itemNum - 1)
    local setHeight = maxHeight < allItemH and maxHeight or allItemH
    self.event_list_content:SetActive(true)
    self.event_list_content_bg:SetMinHeight(setHeight)
    self.event_list_content_bg:SetPreferredHeight(setHeight)
    CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.event_list_content.transform)
    self.event_scroll_view:SetTotalCount(#self.data.eventList)
    self.event_scroll_view:RefillCells()
  else
    self.event_list_content:SetActive(false)
  end
end

local function OnEventItemMoveIn(self, itemObj, index)
  itemObj.name = tostring(index)
  itemObj:SetActive(true)
  local cellItem = self.event_scroll_view:AddComponent(UIActMonopolyEventItem, itemObj)
  cellItem:ReInit(self.data.eventList[index].eventId, self.data.eventList[index].rateNum)
end

local function OnEventItemMoveOut(self, itemObj, index)
  self.event_scroll_view:RemoveComponent(itemObj.name, UIActMonopolyEventItem)
end

UIActMonopolyGridTipView.ParamDataClass = ParamDataClass
UIActMonopolyGridTipView.OnCreate = OnCreate
UIActMonopolyGridTipView.OnDestroy = OnDestroy
UIActMonopolyGridTipView.ComponentDefine = ComponentDefine
UIActMonopolyGridTipView.ComponentDestroy = ComponentDestroy
UIActMonopolyGridTipView.RefreshView = RefreshView
UIActMonopolyGridTipView.ClearScroll = ClearScroll
UIActMonopolyGridTipView.RefreshList = RefreshList
UIActMonopolyGridTipView.OnItemMoveIn = OnItemMoveIn
UIActMonopolyGridTipView.OnItemMoveOut = OnItemMoveOut
UIActMonopolyGridTipView.ClearBulletScroll = ClearBulletScroll
UIActMonopolyGridTipView.RefreshBulletList = RefreshBulletList
UIActMonopolyGridTipView.OnBulletItemMoveIn = OnBulletItemMoveIn
UIActMonopolyGridTipView.OnBulletItemMoveOut = OnBulletItemMoveOut
UIActMonopolyGridTipView.ClearCurScroll = ClearCurScroll
UIActMonopolyGridTipView.RefreshCurList = RefreshCurList
UIActMonopolyGridTipView.OnCurItemMoveIn = OnCurItemMoveIn
UIActMonopolyGridTipView.OnCurItemMoveOut = OnCurItemMoveOut
UIActMonopolyGridTipView.ClearNextScroll = ClearNextScroll
UIActMonopolyGridTipView.RefreshNextList = RefreshNextList
UIActMonopolyGridTipView.OnNextItemMoveIn = OnNextItemMoveIn
UIActMonopolyGridTipView.OnNextItemMoveOut = OnNextItemMoveOut
UIActMonopolyGridTipView.ClearEventScroll = ClearEventScroll
UIActMonopolyGridTipView.RefreshEventList = RefreshEventList
UIActMonopolyGridTipView.OnEventItemMoveIn = OnEventItemMoveIn
UIActMonopolyGridTipView.OnEventItemMoveOut = OnEventItemMoveOut
return UIActMonopolyGridTipView
