local UIJeepAdventureFirstRewardItem = BaseClass("UIJeepAdventureFirstRewardItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local UIGray = CS.UIGray

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

local function OnDestroy(self)
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function ComponentDefine(self)
  self.textTitle = self:AddComponent(UITextMeshProUGUIEx, "TitleText")
  self.btnReceive = self:AddComponent(UIButton, "ReceiveBtn")
  self.btnReceive:SetOnClick(function()
    self:OnBtnReceiveClick()
  end)
  self.textNotReached = self:AddComponent(UITextMeshProUGUIEx, "NotReachedText")
  self.compContent = self:AddComponent(UIBaseContainer, "ScrollRewards/Viewport/Content")
  self.imgRewardItem = self:AddComponent(UIImage, "")
  self.scrollView = self:AddComponent(UIScrollView, "ScrollRewards")
  self.textReceive = self:AddComponent(UITextMeshProUGUIEx, "ReceiveBtn/ReceiveText")
  self.scrollCellPool = {}
  self.itemIndex = 1
  self.scrollView:SetOnItemMoveIn(function(itemObj, index)
    self:OnItemMoveIn(itemObj, index)
  end)
  self.scrollView:SetOnItemMoveOut(function(itemObj, index)
    self:OnItemMoveOut(itemObj, index)
  end)
  self.textNotReached:SetLocalText("armed_truck_reward_not_achieved")
end

local function ComponentDestroy(self)
  self.textTitle = nil
  self.btnReceive = nil
  self.textNotReached = nil
  self.compContent = nil
  self.imgRewardItem = nil
  self.scrollView = nil
  self.textReceive = nil
end

local function DataDefine(self)
end

local function DataDestroy(self)
  self:ClearScroll()
end

local function OnAddListener(self)
  base.OnAddListener(self)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
end

local function OnBtnReceiveClick(self)
  self.view.ctrl:SendGetFirstReward(self.view.pageType, self.template.id)
end

local function SetData(self, data)
  self.template = data.template
  if data.rewardType == JeepStageFirstRewardType.CanClaim then
    self.btnReceive:SetActive(true)
    self.textReceive:SetLocalText("armed_truck_reward_get_btn")
    self.textNotReached:SetActive(false)
    UIGray.SetGray(self.btnReceive.transform, false, true)
    self.imgRewardItem:LoadSprite("Assets/Main/Sprites/UI/LWCommon/Sprite/FX_common_diban_lv.png")
  elseif data.rewardType == JeepStageFirstRewardType.NotReached then
    self.btnReceive:SetActive(false)
    self.textNotReached:SetActive(true)
    self.imgRewardItem:LoadSprite("Assets/Main/Sprites/UI/LWCommon/Sprite/FX_common_diban_bai.png")
  else
    self.btnReceive:SetActive(true)
    self.textReceive:SetLocalText("armed_truck_reward_claimed")
    self.textNotReached:SetActive(false)
    UIGray.SetGray(self.btnReceive.transform, true, false)
    self.imgRewardItem:LoadSprite("Assets/Main/Sprites/UI/LWCommon/Sprite/FX_common_diban_bai.png")
  end
  self.textTitle:SetLocalText("armed_truck_reward_level", self.template:GetName())
  self.showDatalist = self.template:GetStageRewardShowData()
  self.scrollView:SetTotalCount(#self.showDatalist)
  self.scrollView:RefillCells()
end

local function OnItemMoveIn(self, itemObj, index)
  local item = self.scrollCellPool[itemObj.name]
  if not item then
    local name = tostring(self.itemIndex)
    itemObj.name = name
    item = self.scrollView:AddComponent(UICommonResItem, itemObj)
    self.scrollCellPool[name] = item
    self.itemIndex = self.itemIndex + 1
    item:SetLocalScaleXYZ(0.9, 0.9, 1)
  end
  item:ParseInfo(self.showDatalist[index])
end

local function OnItemMoveOut(self, itemObj, index)
end

local function ClearScroll(self)
  self.scrollView:ClearCells()
  self.scrollView:RemoveComponents(UICommonResItem)
  self.scrollCellPool = {}
  self.itemIndex = 1
  self.showDatalist = {}
end

UIJeepAdventureFirstRewardItem.OnCreate = OnCreate
UIJeepAdventureFirstRewardItem.OnDestroy = OnDestroy
UIJeepAdventureFirstRewardItem.OnEnable = OnEnable
UIJeepAdventureFirstRewardItem.OnDisable = OnDisable
UIJeepAdventureFirstRewardItem.ComponentDefine = ComponentDefine
UIJeepAdventureFirstRewardItem.ComponentDestroy = ComponentDestroy
UIJeepAdventureFirstRewardItem.DataDefine = DataDefine
UIJeepAdventureFirstRewardItem.DataDestroy = DataDestroy
UIJeepAdventureFirstRewardItem.OnAddListener = OnAddListener
UIJeepAdventureFirstRewardItem.OnRemoveListener = OnRemoveListener
UIJeepAdventureFirstRewardItem.OnBtnReceiveClick = OnBtnReceiveClick
UIJeepAdventureFirstRewardItem.SetData = SetData
UIJeepAdventureFirstRewardItem.OnItemMoveIn = OnItemMoveIn
UIJeepAdventureFirstRewardItem.OnItemMoveOut = OnItemMoveOut
UIJeepAdventureFirstRewardItem.ClearScroll = ClearScroll
return UIJeepAdventureFirstRewardItem
