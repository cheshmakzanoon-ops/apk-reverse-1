local UISeasonTowerCardPanelView = BaseClass("UISeasonTowerCardPanelView", UIBaseView)
local UISeasonTowerCardItemComponent = require("UI.LWUISeasonTower.UISeasonTowerCard.Component.UISeasonTowerCardItemComponent")
local base = UIBaseView
local Localization = CS.GameEntry.Localization

function UISeasonTowerCardPanelView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:RefreshView()
end

function UISeasonTowerCardPanelView:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UISeasonTowerCardPanelView:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.textDesc1 = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 1)
  self.textDesc2 = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 2)
  self.scrollViewScrollView = self.viewSkin:AddComponent(self, UIScrollView, 3)
  self.compContent = self.viewSkin:AddComponent(self, UIBaseContainer, 4)
  self.btnCommon = self.viewSkin:AddComponent(self, UIButton, 5)
  self.btnCommon:SetOnClick(function()
    self:OnBtnCommonClick()
  end)
  self.btnMask = self.viewSkin:AddComponent(self, UIButton, 6)
  self.btnMask:SetOnClick(function()
    self:OnBtnMaskClick()
  end)
  self.btnClose = self.viewSkin:AddComponent(self, UIButton, 7)
  self.btnClose:SetOnClick(function()
    self:OnBtnCloseClick()
  end)
  self.btnLWInfo = self.viewSkin:AddComponent(self, UIButton, 8)
  self.btnLWInfo:SetOnClick(function()
    self:OnBtnLWInfoClick()
  end)
  self.scrollViewScrollView:SetOnItemMoveIn(function(itemObj, index)
    self:OnItemMoveIn(itemObj, index)
  end)
  self.scrollViewScrollView:SetOnItemMoveOut(function(itemObj, index)
    self:OnItemMoveOut(itemObj, index)
  end)
end

function UISeasonTowerCardPanelView:ClearScroll()
  self.scrollViewScrollView:ClearCells()
  self.scrollViewScrollView:RemoveComponents(UISeasonTowerCardItemComponent)
  self.showDataList = {}
end

function UISeasonTowerCardPanelView:OnItemMoveIn(itemObj, index)
  itemObj.name = tostring(index)
  local cellItem = self.scrollViewScrollView:AddComponent(UISeasonTowerCardItemComponent, itemObj)
  if cellItem ~= nil and self.showDataList ~= nil then
    cellItem:SetData(self.showDataList[index])
  end
end

function UISeasonTowerCardPanelView:OnItemMoveOut(itemObj, index)
  self.scrollViewScrollView:RemoveComponent(itemObj.name, UISeasonTowerCardItemComponent)
end

function UISeasonTowerCardPanelView:ComponentDestroy()
  self:ClearScroll()
  self.viewSkin = nil
  self.textDesc1 = nil
  self.textDesc2 = nil
  self.scrollViewScrollView = nil
  self.compContent = nil
  self.btnCommon = nil
  self.btnMask = nil
  self.btnClose = nil
  self.btnLWInfo = nil
end

function UISeasonTowerCardPanelView:DataDefine()
end

function UISeasonTowerCardPanelView:DataDestroy()
end

function UISeasonTowerCardPanelView:OnAddListener()
  base.OnAddListener(self)
end

function UISeasonTowerCardPanelView:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UISeasonTowerCardPanelView:RefreshView()
  self.showDataList = DataCenter.LWSeasonTowerManager:GetCardBuffs()
  self.scrollViewScrollView:SetTotalCount(#self.showDataList)
  local index = 1
  local currentLevel = DataCenter.LWSeasonTowerManager.battleCardTotalLevel
  for i, v in ipairs(self.showDataList) do
    if currentLevel < v.level then
      break
    end
    index = i
  end
  self.scrollViewScrollView:RefillCells(index, true)
  self.textDesc1:SetLocalText("season_tower_card_buff_info")
  self.textDesc2:SetText(Localization:GetString("season_tower_card_buff_level", currentLevel))
end

function UISeasonTowerCardPanelView:OnBtnCommonClick()
  DataCenter.LWSeasonTowerSceneManager:Exit(function()
    TacticalCardUtil.OpenTacticalCardMain()
  end)
  self.ctrl:CloseSelf()
end

function UISeasonTowerCardPanelView:OnBtnMaskClick()
  self.ctrl:CloseSelf()
end

function UISeasonTowerCardPanelView:OnBtnCloseClick()
  self.ctrl:CloseSelf()
end

function UISeasonTowerCardPanelView:OnBtnLWInfoClick()
  local param = {}
  param.activityRulesStr = Localization:GetString("season_tower_card_buff_info2")
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIActivityDetailPopup, {anim = true}, param)
end

return UISeasonTowerCardPanelView
