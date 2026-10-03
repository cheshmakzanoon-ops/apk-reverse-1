local UIMonsterInvasionShopItem = BaseClass("UIMonsterInvasionShopItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local UIGray = CS.UIGray
local UICitySkinExchangeCostItem = require("UI.UIActivityCenterTable.Component.UICitySkin.UICitySkinExchangeCostItem")
local needItemsContainerPath = "Rect_NeedItems/Viewport/Content"
local rewardBtnPath = "Btn_Reward"
local exchangedTimesTextPath = "ExchangedTimes"
local targetItemPath = "TargetItem"
local gotoBtnPath = "Btn_Goto"
local templateItemPath = "Rect_NeedItems/UICommonResItem"
local arrowIconPath = "ArrowIcon"
local bgPath = "Bg"
local rawBgPath = "RawBg"

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

local function OnDestroy(self)
  self:ClearRewardItems()
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function ComponentDefine(self)
  self.needItemsContainer = self:AddComponent(UIBaseContainer, needItemsContainerPath)
  self.rewardBtn = self:AddComponent(UIButton, rewardBtnPath)
  self.rewardBtn:SetOnClick(function()
    if not self.data then
      return
    end
    if self.exchangeCallBack then
      self.exchangeCallBack(self.data)
    end
  end)
  self.exchangedTimesText = self:AddComponent(UIText, exchangedTimesTextPath)
  self.targetItem = self:AddComponent(UICommonResItem, targetItemPath)
  self.gotoBtn = self:AddComponent(UIButton, gotoBtnPath)
  self.gotoBtn:SetOnClick(function()
    if self.gotoCallBack then
      self.gotoCallBack()
    end
  end)
  self.templateItem = self:AddComponent(UIBaseContainer, templateItemPath)
  self.templateItem.gameObject:GameObjectCreatePool()
  self.arrowIcon = self:AddComponent(UIImage, arrowIconPath)
  self.bg = self:AddComponent(UIImage, bgPath)
  self.rawBg = self:AddComponent(UIRawImage, rawBgPath)
end

local function ComponentDestroy(self)
  self.needItemsContainer = nil
  self.rewardBtn = nil
  self.exchangedTimesText = nil
  self.targetItem = nil
  self.gotoBtn = nil
  self.arrowIcon = nil
  self.bg = nil
end

local function DataDefine(self)
  self.view = nil
  self.data = nil
  self.onClick = nil
end

local function DataDestroy(self)
  self.view = nil
  self.data = nil
  self.onClick = nil
  self.exchangeCallBack = nil
  self.gotoCallBack = nil
end

local function OnAddListener(self)
  base.OnAddListener(self)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
end

local function RefreshBtns(self)
  if not self.data then
    self.rewardBtn:SetActive(false)
    self.gotoBtn:SetActive(false)
    return
  end
  self.rewardBtn:SetActive(true)
  self.gotoBtn:SetActive(false)
  if self.data.count >= self.data.maxCount then
    UIGray.SetGray(self.rewardBtn.transform, true, false)
  else
    UIGray.SetGray(self.rewardBtn.transform, false, true)
    local needItems = self.data.needItems
    for id, count in pairs(needItems) do
      local haveCount = DataCenter.ItemData:GetItemCount(id)
      if count > haveCount then
        self.rewardBtn:SetActive(false)
        self.gotoBtn:SetActive(true)
        return
      end
    end
  end
end

local function ClearRewardItems(self)
  if self.needItemsContainer then
    self.needItemsContainer:RemoveComponents(UICitySkinExchangeCostItem)
  end
  if self.templateItem and not IsNull(self.templateItem.gameObject) then
    self.templateItem.gameObject:GameObjectRecycleAll()
  end
  self.needItemsObj = {}
end

local function RefreshShowItems(self)
  self:ClearRewardItems()
  if not self.data then
    return
  end
  local needItems = self.data.needItems
  local i = 1
  for id, count in pairs(needItems) do
    local obj = self.templateItem.gameObject:GameObjectSpawn(self.needItemsContainer.transform)
    local go = obj.gameObject
    local transform = obj.transform
    transform:SetParent(self.needItemsContainer.transform)
    transform:Set_localScale(0.78, 0.78, 1)
    transform:Set_sizeDelta(92, 92)
    transform:Set_pivot(0.5, 0.5)
    go.name = "item" .. i
    local cell = self.needItemsContainer:AddComponent(UICitySkinExchangeCostItem, go.name)
    local data = {}
    data.id = id
    data.count = count
    data.onlyShowNeedCount = true
    cell:SetData(data)
    self.needItemsObj[i] = cell
    i = i + 1
  end
  if not table.IsNullOrEmpty(self.data.reward) then
    self.targetItem:SetActive(true)
    self.targetItem:ReInit(self.data.reward[1])
  else
    self.targetItem:SetActive(false)
  end
end

local function SetData(self, data, exchangeCallBack, gotoCallBack, actId)
  self.data = data
  self:RefreshBtns()
  self:RefreshShowItems()
  local remainCount = 0
  if data.count >= data.maxCount then
    remainCount = 0
  else
    remainCount = data.maxCount - data.count
  end
  self.exchangedTimesText:SetLocalText(2000843, remainCount)
  self.exchangeCallBack = exchangeCallBack
  self.gotoCallBack = gotoCallBack
  self.actId = actId
  self.arrowIcon:LoadSprite("Assets/Main/Sprites/UI/UICitySkinActivity/zyf_qingjiaohuodong_jiantou.png")
  self.arrowIcon:SetNativeSize()
  self.rawBg:SetActive(false)
  self.bg:SetActive(true)
end

UIMonsterInvasionShopItem.OnCreate = OnCreate
UIMonsterInvasionShopItem.OnDestroy = OnDestroy
UIMonsterInvasionShopItem.OnEnable = OnEnable
UIMonsterInvasionShopItem.OnDisable = OnDisable
UIMonsterInvasionShopItem.ComponentDefine = ComponentDefine
UIMonsterInvasionShopItem.ComponentDestroy = ComponentDestroy
UIMonsterInvasionShopItem.DataDefine = DataDefine
UIMonsterInvasionShopItem.DataDestroy = DataDestroy
UIMonsterInvasionShopItem.OnAddListener = OnAddListener
UIMonsterInvasionShopItem.OnRemoveListener = OnRemoveListener
UIMonsterInvasionShopItem.SetData = SetData
UIMonsterInvasionShopItem.RefreshBtns = RefreshBtns
UIMonsterInvasionShopItem.ClearRewardItems = ClearRewardItems
UIMonsterInvasionShopItem.RefreshShowItems = RefreshShowItems
return UIMonsterInvasionShopItem
