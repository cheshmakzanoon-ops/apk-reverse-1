local UIGrowthPlan = BaseClass("UIGrowthPlan", UIBaseView)
local base = UIBaseView
local UIGrowthPlanItem = require("UI.UIGiftPackage.Component.UIGrowthPlanItem")
local UIGiftPackagePoint = require("UI.UIGiftPackage.Component.UIGiftPackagePoint")
local CellPos = UIGrowthPlanItem.CellPos
local Localization = CS.GameEntry.Localization
local title_path = "Root/TitleBg/Title"
local subtitle_path = "Root/TitleBg/Subtitle"
local buy_btn_path = "Root/TitleBg/BuyBtn"
local buy_text_path = "Root/TitleBg/BuyBtn/BuyText"
local buy_glow_path = "Root/TitleBg/BuyGlow"
local scroll_view_path = "Root/Mask/ScrollView"
local box_lock_path = "Root/BoxBg/BoxBottom/BoxLock"
local yellow_line_path = "Root/Mask/YellowLine"
local black_mask_path = "Root/Mask/BlackMask"
local mask_path = "Root/Mask"
local caidai_path = "Root/Caidai"
local point_path = "Root/TitleBg/BuyBtn/UIGiftPackagePoint"
local BLANK_COUNT = 2
local SHOW_COUNT = 6
local GetRewardType = {
  None = -1,
  Normal = 0,
  Special = 1
}

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

local function OnDestroy(self)
  self:ClearScroll()
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
  if self.inited then
    self:ScrollToAvailableIndex()
  end
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function ComponentDefine(self)
  self.title_text = self:AddComponent(UIText, title_path)
  self.subtitle_text = self:AddComponent(UIText, subtitle_path)
  self.buy_btn = self:AddComponent(UIButton, buy_btn_path)
  self.buy_btn:SetOnClick(function()
    self:OnBuyClick()
  end)
  self.buy_text = self:AddComponent(UIText, buy_text_path)
  self.buy_glow_go = self:AddComponent(UIBaseContainer, buy_glow_path)
  self.scroll_view = self:AddComponent(UIScrollView, scroll_view_path)
  self.scroll_view:SetOnItemMoveIn(function(itemObj, index)
    self:OnCreateCell(itemObj, index)
  end)
  self.scroll_view:SetOnItemMoveOut(function(itemObj, index)
    self:OnDeleteCell(itemObj, index)
  end)
  self.box_lock_go = self:AddComponent(UIBaseContainer, box_lock_path)
  self.yellow_line_go = self:AddComponent(UIBaseContainer, yellow_line_path)
  self.black_mask_go = self:AddComponent(UIBaseContainer, black_mask_path)
  self.mask_go = self:AddComponent(UIBaseContainer, mask_path)
  self.caidai_partile = self.transform:Find(caidai_path):GetComponent(typeof(CS.UnityEngine.ParticleSystem))
  self.point_rect = self:AddComponent(UIGiftPackagePoint, point_path)
end

local function ComponentDestroy(self)
  self.title_text = nil
  self.subtitle_text = nil
  self.buy_btn = nil
  self.buy_text = nil
  self.buy_glow_go = nil
  self.buy_desc_text = nil
  self.scroll_view = nil
  self.box_lock_go = nil
  self.yellow_line_go = nil
  self.black_mask_go = nil
  self.mask_go = nil
  self.caidai_partile = nil
  self.point_rect = nil
end

local function DataDefine(self)
  self.view = nil
  self.pack = nil
  self.specialUnlocked = nil
  self.dataList = {}
  self.itemList = {}
  self.curLevel = 0
  self.nextLevel = 0
  self.curIndex = 0
  self.inited = false
end

local function DataDestroy(self)
  self.view = nil
  self.pack = nil
  self.specialUnlocked = nil
  self.dataList = nil
  self.itemList = nil
  self.curLevel = nil
  self.nextLevel = nil
  self.curIndex = nil
  self.inited = nil
end

local function OnAddListener(self)
  base.OnAddListener(self)
  self:AddUIListener(EventId.GrowthPlanGetInfo, self.OnGetInfo)
  self:AddUIListener(EventId.GrowthPlanGetReward, self.OnGetReward)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
  self:RemoveUIListener(EventId.GrowthPlanGetInfo, self.OnGetInfo)
  self:RemoveUIListener(EventId.GrowthPlanGetReward, self.OnGetReward)
end

local function ShowCells(self)
  local count = #self.dataList + BLANK_COUNT
  if 0 < count then
    self.scroll_view:SetTotalCount(count)
    self.scroll_view:RefillCells()
  end
end

local function ClearScroll(self)
  self.cells = {}
  self.scroll_view:ClearCells()
  self.scroll_view:RemoveComponents(UIGrowthPlanItem)
end

local function OnCreateCell(self, itemObj, index)
  itemObj.name = tostring(index)
  local item = self.scroll_view:AddComponent(UIGrowthPlanItem, itemObj)
  if index <= #self.dataList then
    local data = self.dataList[index]
    data.isFirst = index == 1
    data.isLast = index == #self.dataList
    if index == 1 then
      data.pro = self.curLevel / data.needLevel
      data.showBallLeft = false
      if self.curLevel < data.needLevel then
        self.curIndex = index
      end
    else
      local lastData = self.dataList[index - 1]
      data.pro = (self.curLevel - lastData.needLevel) / (data.needLevel - lastData.needLevel)
      data.showBallLeft = self.curLevel >= lastData.needLevel
      if self.curLevel < data.needLevel and self.curLevel >= lastData.needLevel then
        self.curIndex = index
      end
    end
    data.showBallRight = self.curLevel >= data.needLevel
    item:SetData(data, self)
    item:SetOnClick(function(cellPos)
      self:OnCellClick(index, cellPos)
    end)
    self.itemList[index] = item
  else
    item:SetBlank(data)
    self.itemList[index] = item
  end
end

local function OnDeleteCell(self, itemObj, index)
  self.itemList[index] = nil
  self.scroll_view:RemoveComponent(itemObj.name, UIGrowthPlanItem)
end

local function ReInit(self, view)
  if self.inited then
    return
  end
  self.inited = true
  self.view = view
  local pack = GiftPackageData.getGrowthPlanPack()
  self.pack = pack
  self.title_text:SetLocalText(tonumber(pack:getName()))
  self.buy_text:SetText(DataCenter.PayManager:GetDollarText(pack:getPrice(), pack:getProductID()))
  self.yellow_line_go:SetActive(false)
  self.black_mask_go:SetActive(false)
  local messageCache = WelfareController.getWelfareCache(WelfareMessageKey.GrowthPlanInfo)
  if messageCache then
    self:OnGetInfo(messageCache)
  else
    SFSNetwork.SendMessage(MsgDefines.GrowthPlanGetInfo)
  end
  self.point_rect:RefreshPoint(self.pack)
end

local function Update(self)
  if table.IsNullOrEmpty(self.dataList) then
    return
  end
  local curItem = self.itemList[self.curIndex]
  if curItem and curItem.gameObject then
    self.yellow_line_go:SetActive(true)
    self.black_mask_go:SetActive(true)
    local standardScale = GetStandardScale()
    local curCellPos = curItem.transform.position
    local yellowPos = curCellPos + Vector3.New(-80 * standardScale, 0, 0)
    local blackRight = self.mask_go.transform.position.x + self.mask_go.rectTransform.sizeDelta.x / 2 * standardScale
    local blackWidth = (blackRight - yellowPos.x) / standardScale
    self.yellow_line_go.transform.position = yellowPos
    self.black_mask_go.rectTransform.sizeDelta = Vector2.New(blackWidth, 430)
  else
    self.yellow_line_go:SetActive(false)
    self.black_mask_go:SetActive(false)
    for _, item in pairs(self.itemList) do
      if item.data and item.data.needLevel > self.curLevel then
        self.black_mask_go:SetActive(true)
        self.black_mask_go.rectTransform.sizeDelta = Vector2.New(self.mask_go.rectTransform.sizeDelta.x, 430)
        break
      end
    end
  end
end

local function ScrollToAvailableIndex(self)
  local toIndex = 0
  local lastIndex = #self.dataList
  for index, data in ipairs(self.dataList) do
    local canGet = false
    if self.curLevel >= data.needLevel then
      if data.normalState == 0 then
        canGet = true
      elseif self.specialUnlocked and data.specialState == 0 then
        canGet = true
      else
        lastIndex = index
      end
    end
    if canGet then
      toIndex = index
      break
    end
  end
  if toIndex == 0 then
    toIndex = math.min(lastIndex + 1, #self.dataList)
  end
  local totalCount = #self.dataList - SHOW_COUNT + 1
  toIndex = toIndex - SHOW_COUNT // 2
  if 1 < toIndex then
    local pos = (toIndex - 1) / totalCount
    self.scroll_view:SetHorizontalNormalizedPosition(pos)
    self.scroll_view:ScrollToCell(toIndex, 1000)
  end
end

local function OnGetInfo(self, message)
  local specialUnlocked = message.unlockSpecialReward == 1
  if self.specialUnlocked == false and specialUnlocked == true then
    self.caidai_partile:Play()
  end
  self.specialUnlocked = specialUnlocked
  self.dataList = message.stageInfo
  self.curLevel = DataCenter.BuildManager.MainLv
  local diamond = 0
  for _, data in ipairs(self.dataList) do
    if self.curLevel < data.needLevel then
      self.nextLevel = data.needLevel
      break
    end
  end
  for _, data in ipairs(self.dataList) do
    if not table.IsNullOrEmpty(data.specialReward) then
      for _, reward in ipairs(data.specialReward) do
        if reward.type == RewardType.GOLD then
          diamond = diamond + reward.value
        end
      end
    end
  end
  if tonumber(self.pack:getDescription()) and self.pack:getPercent() then
    self.subtitle_text:SetLocalText(tonumber(self.pack:getDescription()), self.pack:getPercent() .. "%", diamond)
  end
  self.buy_btn:SetActive(not self.specialUnlocked)
  self.buy_glow_go:SetActive(not self.specialUnlocked)
  self.box_lock_go:SetActive(not self.specialUnlocked)
  self:ShowCells()
  self:ScrollToAvailableIndex()
end

local function OnGetReward(self, message)
  DataCenter.RewardManager:ShowGiftReward(message, Localization:GetString("320320"))
  DataCenter.RewardManager:AddRewardsAndRes(message)
  for index, data in ipairs(self.dataList) do
    if data.id == message.id then
      if message.type == GetRewardType.Normal then
        data.normalState = 1
      elseif message.type == GetRewardType.Special then
        data.specialState = 1
      end
      self.itemList[index]:SetData(self.dataList[index], self)
      break
    end
  end
end

local function OnCellClick(self, index, cellPos)
  local data = self.dataList[index]
  local type = GetRewardType.None
  if self.curLevel >= data.needLevel then
    if cellPos == CellPos.Top and data.normalState == 0 then
      type = GetRewardType.Normal
    elseif cellPos ~= CellPos.Top and data.specialState == 0 then
      if self.specialUnlocked then
        type = GetRewardType.Special
      else
        UIUtil.ShowTipsId(320321)
      end
    end
  end
  if type == GetRewardType.Normal or type == GetRewardType.Special then
    local param = {
      id = data.id,
      type = type
    }
    SFSNetwork.SendMessage(MsgDefines.GrowthPlanGetReward, param)
  else
    self.itemList[index]:ShowCellTip(cellPos)
  end
end

local function OnBuyClick(self)
  if self.specialUnlocked then
    return
  end
  self.view.ctrl:BuyGift(self.pack)
end

UIGrowthPlan.OnCreate = OnCreate
UIGrowthPlan.OnDestroy = OnDestroy
UIGrowthPlan.OnEnable = OnEnable
UIGrowthPlan.OnDisable = OnDisable
UIGrowthPlan.ComponentDefine = ComponentDefine
UIGrowthPlan.ComponentDestroy = ComponentDestroy
UIGrowthPlan.DataDefine = DataDefine
UIGrowthPlan.DataDestroy = DataDestroy
UIGrowthPlan.OnAddListener = OnAddListener
UIGrowthPlan.OnRemoveListener = OnRemoveListener
UIGrowthPlan.ShowCells = ShowCells
UIGrowthPlan.ClearScroll = ClearScroll
UIGrowthPlan.OnCreateCell = OnCreateCell
UIGrowthPlan.OnDeleteCell = OnDeleteCell
UIGrowthPlan.ReInit = ReInit
UIGrowthPlan.Update = Update
UIGrowthPlan.ScrollToAvailableIndex = ScrollToAvailableIndex
UIGrowthPlan.OnGetInfo = OnGetInfo
UIGrowthPlan.OnGetReward = OnGetReward
UIGrowthPlan.OnCellClick = OnCellClick
UIGrowthPlan.OnBuyClick = OnBuyClick
return UIGrowthPlan
