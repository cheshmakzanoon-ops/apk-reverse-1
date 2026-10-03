local UIBFDsbDuelActRewardView = BaseClass("UIBFDsbDuelActRewardView", UIBaseView)
local UIBFDsbDuelActRewardViewToggle = require("UI.BFDsbDuel.BFDsbDuelReward.Component.UIBFDsbDuelActRewardViewToggleItemRenderer")
local base = UIBaseView
local Localization = CS.GameEntry.Localization

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:RefreshTopTabs()
end

local function OnDestroy(self)
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
  self:RequestPlayerInfo()
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function ComponentDefine(self)
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.textTitle = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 1)
  self.btnClose = self.viewSkin:AddComponent(self, UIButton, 2)
  self.btnClose:SetOnClick(function()
    self:OnBtnCloseClick()
  end)
  self.toggleScrollView = self.viewSkin:AddComponent(self, UIScrollView, 3)
  self.compContent = self.viewSkin:AddComponent(self, UIBaseComponent, 4)
  self.compSheets = self.viewSkin:AddComponent(self, UIBaseComponent, 5)
  self.compSmallBg = self.viewSkin:AddComponent(self, UIBaseComponent, 6)
  self.btnPanel = self.viewSkin:AddComponent(self, UIButton, 7)
  self.btnPanel:SetOnClick(function()
    self:OnBtnPanelClick()
  end)
  self.toggleScrollView:SetOnItemMoveIn(function(itemObj, index)
    self:OnItemMoveIn(itemObj, index)
  end)
  self.toggleScrollView:SetOnItemMoveOut(function(itemObj, index)
    self:OnItemMoveOut(itemObj, index)
  end)
  self.textTitle:SetLocalText("YiBianJinQu_reward_tips_1")
end

local function ComponentDestroy(self)
  self.viewSkin = nil
  self.textTitle = nil
  self.btnClose = nil
  self.toggleScrollView = nil
  self.compContent = nil
  self.compSheets = nil
  self.compSmallBg = nil
  self.btnPanel = nil
end

function UIBFDsbDuelActRewardView:OnItemMoveIn(itemObj, index)
  itemObj.name = string.format("UIBFDsbDuelActRewardViewToggleItemRenderer_%s", index)
  local cellItem = self.toggleScrollView:AddComponent(UIBFDsbDuelActRewardViewToggle, itemObj)
  cellItem:SetData(index, self.tabDataList[index], self)
  self.tabCells[index] = cellItem
end

function UIBFDsbDuelActRewardView:OnToggleClicked(index)
  if not self.tabCells then
    return
  end
  if index == self.currentIndex then
    return
  end
  self.currentIndex = index
  self:RefreshTabCells()
  self:RefreshSheets()
end

function UIBFDsbDuelActRewardView:OnItemMoveOut(itemObj, index)
  self.toggleScrollView:RemoveComponent(itemObj.name, UIBFDsbDuelActRewardViewToggle)
  self.tabCells[index] = nil
end

function UIBFDsbDuelActRewardView:ClearScroll()
  if self.toggleScrollView then
    self.toggleScrollView:ClearCells()
    self.toggleScrollView:RemoveComponents(UIBFDsbDuelActRewardViewToggle)
  end
  self.tabCells = {}
end

function UIBFDsbDuelActRewardView:RefreshTabCells()
  for k, v in pairs(self.tabCells) do
    v:SetSelection(self.currentIndex)
  end
end

function UIBFDsbDuelActRewardView:RefreshSheets()
  if not self.sheets then
    return
  end
  if not self.sheets[self.currentIndex] then
    local tabData = self.tabDataList[self.currentIndex]
    if not tabData then
      return
    end
    local lua = tabData.lua
    local prefab = tabData.prefab
    self.sheets[self.currentIndex] = self:LoadComponentAsync(lua, prefab, self.compSheets.gameObject, function()
      self:RefreshSheets()
    end, nil, self)
    return
  end
  for k, v in pairs(self.sheets) do
    if v then
      v:SetActive(k == self.currentIndex)
      if k == self.currentIndex then
        v:RefreshSheet()
      end
    end
  end
end

function UIBFDsbDuelActRewardView:RefreshTopTabs()
  if #self.tabDataList > 0 then
    self.toggleScrollView:SetTotalCount(#self.tabDataList)
    self.toggleScrollView:RefillCells()
  end
  if self.currentIndex == nil then
    self.currentIndex = self:GetUserData() or 1
    self:RefreshTabCells()
    self:RefreshSheets()
  end
end

local function DataDefine(self)
  self.tabCells = self.tabCells or {}
  self.sheets = self.sheets or {}
  if self.tabDataList == nil then
    self.tabDataList = self.ctrl:GetTabs()
  end
end

local function DataDestroy(self)
  self.sheets = nil
  self.tabCells = nil
  self:ClearScroll()
end

local function OnAddListener(self)
  base.OnAddListener(self)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
end

local function OnBtnCloseClick(self)
  self.ctrl:CloseSelf()
end

function UIBFDsbDuelActRewardView:OnBtnPanelClick()
  self.ctrl:CloseSelf()
end

function UIBFDsbDuelActRewardView:RequestPlayerInfo()
  BattlefieldDsbDuelUtils.ActInfo:SendActInfoMsg()
end

UIBFDsbDuelActRewardView.OnCreate = OnCreate
UIBFDsbDuelActRewardView.OnDestroy = OnDestroy
UIBFDsbDuelActRewardView.OnEnable = OnEnable
UIBFDsbDuelActRewardView.OnDisable = OnDisable
UIBFDsbDuelActRewardView.ComponentDefine = ComponentDefine
UIBFDsbDuelActRewardView.ComponentDestroy = ComponentDestroy
UIBFDsbDuelActRewardView.DataDefine = DataDefine
UIBFDsbDuelActRewardView.DataDestroy = DataDestroy
UIBFDsbDuelActRewardView.OnAddListener = OnAddListener
UIBFDsbDuelActRewardView.OnRemoveListener = OnRemoveListener
UIBFDsbDuelActRewardView.OnBtnCloseClick = OnBtnCloseClick
return UIBFDsbDuelActRewardView
