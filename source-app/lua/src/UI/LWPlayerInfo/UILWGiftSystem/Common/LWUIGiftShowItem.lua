local base = UIBaseContainer
local LWUIGiftShowItem = BaseClass("LWUIGiftShowItem", base)
local iconPath = "Assets/Main/Prefabs/UI/LWPlayerInfo/GiftSystem/UI/Icon/"
local qualityPath = "Assets/Main/Prefabs/UI/LWPlayerInfo/GiftSystem/UI/"
local bgImg_path = "Content/Bg"
local iconImg_path = "Content/Icon"
local deleteBtn_path = "CloseIcon"
local numTxt_path = "Num"
local emptyGo_path = "Empty"
local button_path = "Button"
local contentCom_path = "Content"
local selectGo_path = "Select"
local emptyIconImg_path = "Empty/EmptyIcon"

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

function LWUIGiftShowItem:ComponentDefine()
  self.bgImg = self:AddComponent(UIImage, bgImg_path)
  self.iconImg = self:AddComponent(UIImage, iconImg_path)
  self.deleteBtn = self:AddComponent(UIButton, deleteBtn_path)
  self.numTxt = self:AddComponent(UIText, numTxt_path)
  self.emptyGo = self:AddComponent(UIBaseContainer, emptyGo_path)
  self.button = self:AddComponent(UIButton, button_path)
  self.contentCom = self:AddComponent(UIBaseContainer, contentCom_path)
  self.selectGo = self:AddComponent(UIBaseContainer, selectGo_path)
  self.emptyIconImg = self:AddComponent(UIImage, emptyIconImg_path)
  self.button:SetOnClick(function()
    self:OnItemClick()
  end)
  self.deleteBtn:SetOnClick(function()
    self:OnDeleteClick()
  end)
end

function LWUIGiftShowItem:SetShowData(showData, showType)
  self.data = showData
  self.showType = showType
end

function LWUIGiftShowItem:ReInit()
  if not self.showType then
    self.showType = GiftShowType.Basics
  end
  self:RefreshView()
  self:SwitchoverCom()
end

function LWUIGiftShowItem:SetOnSelect(selectFunc)
  self.selectFunc = selectFunc
end

function LWUIGiftShowItem:RefreshView()
  if self.data and self.data.itemId and self.data.count and self.data.count > 0 then
    local template = DataCenter.ItemTemplateManager:GetItemTemplate(self.data.itemId)
    local goods = DataCenter.GiftSystemManager:GetGiftGoods(template.id)
    self.bgImg:LoadSprite(GiftSystemConst.GetPlayerInfoQualityIcon(template.color))
    self.iconImg:LoadSprite(GiftSystemConst.GetIconPath(goods.icon_small))
    self.iconImg:SetNativeSize()
    local countStr = string.GetFormattedStr(self.data.count or 0)
    if string.len(countStr) == 1 then
      self.numTxt:SetLocalPositionXYZ(0, -34, 0)
    else
      self.numTxt:SetLocalPositionXYZ(15, -34, 0)
    end
    self.numTxt:SetText(countStr)
  else
    self.numTxt:SetLocalPositionXYZ(15, -34, 0)
    self.emptyIconImg:LoadSprite(GiftSystemConst.GetEmptyIconPath(self.showType))
    self.emptyIconImg:SetNativeSize()
  end
  self:SetSelect(false)
end

function LWUIGiftShowItem:SwitchoverCom()
  if self.showType == GiftShowType.Basics then
    local show = (self.data and self.data.itemId) ~= nil
    self.bgImg:SetActive(show)
    self.iconImg:SetActive(show)
    self.numTxt:SetActive(show)
    self.contentCom:SetActive(show)
    self.deleteBtn:SetActive(false)
    self.emptyGo:SetActive(not show)
  elseif self.showType == GiftShowType.Edit then
    local show = (self.data and self.data.itemId) ~= nil
    self.bgImg:SetActive(show)
    self.iconImg:SetActive(show)
    self.numTxt:SetActive(show)
    self.contentCom:SetActive(show)
    self.deleteBtn:SetActive(show)
    self.emptyGo:SetActive(not show)
  end
end

local function ComponentDestroy(self)
  self.bgImg = nil
  self.iconImg = nil
  self.deleteBtn = nil
  self.numTxt = nil
  self.emptyGo = nil
  self.button = nil
  self.contentCom = nil
  self.selectGo = nil
  self.emptyIconImg = nil
end

local function DataDefine(self)
  self.data = nil
end

local function DataDestroy(self)
  self.data = nil
end

function LWUIGiftShowItem:OnItemClick()
  if type(self.selectFunc) == "function" then
    self.selectFunc(self.data, self.showType)
  end
end

function LWUIGiftShowItem:OnDeleteClick()
  local info = DataCenter.PlayerInfoDataManager.selfPlayerData
  if info == nil then
    return
  end
  local posIndex = self.data.pos
  local giftDataList = info and info.giftDataList or {}
  for i, v in pairs(giftDataList) do
    if v.pos == tonumber(posIndex) then
      table.remove(giftDataList, i)
      break
    end
  end
  DataCenter.GiftSystemManager:RequestSetGiftShow(giftDataList)
end

function LWUIGiftShowItem:SetSelect(state)
  self.selectGo:SetActive(state)
end

LWUIGiftShowItem.OnCreate = OnCreate
LWUIGiftShowItem.OnDestroy = OnDestroy
LWUIGiftShowItem.OnEnable = OnEnable
LWUIGiftShowItem.OnDisable = OnDisable
LWUIGiftShowItem.ComponentDestroy = ComponentDestroy
LWUIGiftShowItem.DataDefine = DataDefine
LWUIGiftShowItem.DataDestroy = DataDestroy
return LWUIGiftShowItem
