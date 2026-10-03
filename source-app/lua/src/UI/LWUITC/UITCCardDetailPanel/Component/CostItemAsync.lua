local CostItemAsync = BaseClass("CostItemAsync", UIAsyncContainer)
local base = UIAsyncContainer
local Localization = CS.GameEntry.Localization
local Resource = CS.GameEntry.Resource
local UIGray = CS.UIGray

local function OnCreate(self)
  base.OnCreate(self)
  self:DataDefine()
  self:ComponentDefine()
end

local function OnDestroy(self)
  self:ClearCardItem()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

local function DataDefine(self)
end

local function DataDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
  self.active = true
end

local function OnDisable(self)
  base.OnDisable(self)
  self.active = false
end

local function ComponentDefine(self)
  self.icon = self:AddComponent(UIBaseContainer, "icon")
  self.costText = self:AddComponent(UIText, "costText")
end

local function ComponentDestroy(self)
  self.icon = nil
  self.costText = nil
end

local function SetData(self, cardId, cost, whiteColor)
  self.cardId = cardId
  self.cost = cost
  self.whiteColor = whiteColor
  self:RefreshView()
end

local CARD_DISPLAY_CONFIG = {
  isDeluxeShow = false,
  isShowLv = false,
  isShowStar = false
}

local function UpdateData(self)
  if not self.cardId or not self.cost then
    self.costText:SetText("")
    return
  end
  local have = DataCenter.TacticalCardDataManager:GetCoreFeedNumByCardId(self.cardId)
  local colorStr = ""
  if have < self.cost then
    if self.whiteColor then
      colorStr = "<color=#FFFFFF>"
    else
      colorStr = "<color=#F97077>"
    end
  else
    colorStr = "<color=#5FEF87>"
  end
  self.costText:SetText(string.format("%s%d</color>/%d", colorStr, have, self.cost))
  local cardTemplate = DataCenter.TacticalCardDataManager:GetTemplateData(self.cardId)
  if cardTemplate then
    if not self.cardRequest then
      self.cardRequest = TacticalCardUtil.CreateOneCardItem(self, cardTemplate.type, self.icon, function(cardItem)
        cardItem:SetConfigData(self.cardId, 1, 0, CARD_DISPLAY_CONFIG)
        cardItem:SetActive(true)
        self.cardItem = cardItem
      end)
    elseif self.cardItem then
      self.cardItem:SetActive(true)
      self.cardItem:SetConfigData(self.cardId, 1, 0, CARD_DISPLAY_CONFIG)
    end
  end
end

function CostItemAsync:ClearCardItem()
  if self.cardRequest then
    self.icon:RemoveAllComponentes()
    self.cardRequest:Destroy()
    self.cardRequest = nil
  end
  self.cardItem = nil
end

CostItemAsync.OnCreate = OnCreate
CostItemAsync.OnDestroy = OnDestroy
CostItemAsync.OnEnable = OnEnable
CostItemAsync.OnDisable = OnDisable
CostItemAsync.DataDefine = DataDefine
CostItemAsync.DataDestroy = DataDestroy
CostItemAsync.ComponentDefine = ComponentDefine
CostItemAsync.ComponentDestroy = ComponentDestroy
CostItemAsync.SetData = SetData
CostItemAsync.UpdateData = UpdateData
return CostItemAsync
