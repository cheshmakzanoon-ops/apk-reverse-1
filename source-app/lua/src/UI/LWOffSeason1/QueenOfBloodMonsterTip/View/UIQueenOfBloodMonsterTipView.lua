local UIQueenOfBloodMonsterTipView = BaseClass("UIQueenOfBloodMonsterTipView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local UIQueenOfBloodMonsterTipTab = require("UI.LWOffSeason1.QueenOfBloodMonsterTip.Component.UIQueenOfBloodMonsterTipTab")
local UIQueenOfBloodMonsterTipCell = require("UI.LWOffSeason1.QueenOfBloodMonsterTip.Component.UIQueenOfBloodMonsterTipCell")

function UIQueenOfBloodMonsterTipView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UIQueenOfBloodMonsterTipView:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIQueenOfBloodMonsterTipView:ComponentDefine()
  self.textTitle = self:AddComponent(UITextMeshProUGUIEx, "PopUpTitle/Common_img_title/titleText")
  self.btnClose = self:AddComponent(UIButton, "PopUpTitle/CloseBtn")
  self.btnClose:SetOnClick(function()
    self:OnBtnCloseClick()
  end)
  self.compTab1 = self:AddComponent(UIQueenOfBloodMonsterTipTab, "Root/TabContent/Tab1")
  self.compTab2 = self:AddComponent(UIQueenOfBloodMonsterTipTab, "Root/TabContent/Tab2")
  self.compTab3 = self:AddComponent(UIQueenOfBloodMonsterTipTab, "Root/TabContent/Tab3")
  self.scrollView = self:AddComponent(UIScrollView, "Root/ScrollView")
  self.btnPanel = self:AddComponent(UIButton, "panel")
  self.btnPanel:SetOnClick(function()
    self:OnBtnPanelClick()
  end)
  self.scrollCellPool = {}
  self.itemIndex = 1
  self.scrollView:SetOnItemMoveIn(function(itemObj, index)
    self:OnItemMoveIn(itemObj, index)
  end)
  self.scrollView:SetOnItemMoveOut(function(itemObj, index)
    self:OnItemMoveOut(itemObj, index)
  end)
end

function UIQueenOfBloodMonsterTipView:ComponentDestroy()
  self:ClearScroll()
  self.textTitle = nil
  self.btnClose = nil
  self.compTab1 = nil
  self.compTab2 = nil
  self.compTab3 = nil
  self.scrollView = nil
  self.btnPanel = nil
end

function UIQueenOfBloodMonsterTipView:DataDefine()
  self.jumpIndex = self:GetUserData()
  self:Init()
end

function UIQueenOfBloodMonsterTipView:DataDestroy()
  self.data = nil
end

function UIQueenOfBloodMonsterTipView:OnAddListener()
  base.OnAddListener(self)
end

function UIQueenOfBloodMonsterTipView:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UIQueenOfBloodMonsterTipView:OnBtnCloseClick()
  self.ctrl:CloseSelf()
end

function UIQueenOfBloodMonsterTipView:OnBtnPanelClick()
  self.ctrl:CloseSelf()
end

function UIQueenOfBloodMonsterTipView:Init()
  local count = DataCenter.OffSeason1QueenOfBloodManager.activityCount
  if count == nil then
    return
  end
  self.data = DataCenter.OffSeason1QueenOfBloodManager:GetChallengeMonsterIndexDataByCount(count)
  if self.data == nil then
    return
  end
  self.textTitle:SetLocalText("s1_QueenChallenge_preview_title", count)
  for i = 1, 3 do
    self["compTab" .. i]:SetData(i, Bind(self, self.SetSelect))
  end
  self:SetSelect(self.jumpIndex or 1)
end

function UIQueenOfBloodMonsterTipView:SetSelect(index)
  if self.selectIndex == index then
    return
  end
  self.selectIndex = index
  for i = 1, 3 do
    self["compTab" .. i]:SetSelect(i == self.selectIndex)
  end
  self:Refresh()
end

function UIQueenOfBloodMonsterTipView:OnItemMoveIn(itemObj, index)
  local item = self.scrollCellPool[itemObj.name]
  if not item then
    local name = tostring(self.itemIndex)
    itemObj.name = name
    item = self.scrollView:AddComponent(UIQueenOfBloodMonsterTipCell, itemObj)
    self.scrollCellPool[name] = item
    self.itemIndex = self.itemIndex + 1
  end
  item:SetData(self.showDatalist[index])
end

function UIQueenOfBloodMonsterTipView:OnItemMoveOut(itemObj, index)
end

function UIQueenOfBloodMonsterTipView:ClearScroll()
  self.scrollView:ClearCells()
  self.scrollView:RemoveComponents(UIQueenOfBloodMonsterTipCell)
  self.scrollCellPool = {}
  self.itemIndex = 1
  self.showDatalist = {}
end

function UIQueenOfBloodMonsterTipView:Refresh()
  local data = self.data[self.selectIndex]
  if data and 0 < #data then
    self.scrollView:SetActive(true)
    self.showDatalist = data
    self.scrollView:SetTotalCount(#self.showDatalist)
    self.scrollView:RefillCells()
  else
    self.scrollView:SetActive(false)
  end
end

return UIQueenOfBloodMonsterTipView
