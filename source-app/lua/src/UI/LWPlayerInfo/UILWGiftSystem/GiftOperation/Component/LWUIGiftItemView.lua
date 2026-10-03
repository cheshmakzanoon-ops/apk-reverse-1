local base = UIBaseContainer
local LWUIGiftItemView = BaseClass("LWUIGiftItemView", base)
local qualityImg_path = "Corner"
local giftIconImg_path = "Icon"
local giftNumTxt_path = "Num"
local giftNameTxt_path = "Name"
local addCharmTxt_path = "AddCharm"
local selectGo_path = "SelectGo"
local selectBtn_path = "SelectBtn"
local blackMask_path = "BlackMask"
local detailBtn_path = "DetailBtn"
local recycleGo_path = "RecycleGo"

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
  self.qualityImg = self:AddComponent(UIImage, qualityImg_path)
  self.giftIconImg = self:AddComponent(UIImage, giftIconImg_path)
  self.giftNumTxt = self:AddComponent(UIText, giftNumTxt_path)
  self.giftNameTxt = self:AddComponent(UIText, giftNameTxt_path)
  self.addCharmTxt = self:AddComponent(UIText, addCharmTxt_path)
  self.selectGo = self:AddComponent(UIBaseContainer, selectGo_path)
  self.selectBtn = self:AddComponent(UIButton, selectBtn_path)
  self.blackMask = self:AddComponent(UIBaseContainer, blackMask_path)
  self.detailBtn = self:AddComponent(UIButton, detailBtn_path)
  self.recycleGo = self:AddComponent(UIBaseContainer, recycleGo_path)
  self.selectBtn:SetOnClick(function()
    if type(self.selectFunc) == "function" then
      self.selectFunc(self.template)
    end
  end)
  self.detailBtn:SetOnClick(function()
    self:OnDetailBtnClick()
  end)
end

local function ComponentDestroy(self)
  self.qualityImg = nil
  self.giftIconImg = nil
  self.giftNumTxt = nil
  self.giftNameTxt = nil
  self.addCharmTxt = nil
  self.selectGo = nil
  self.selectBtn = nil
  self.blackMask = nil
  self.detailBtn = nil
  self.recycleGo = nil
end

local function DataDefine(self)
end

local function DataDestroy(self)
end

function LWUIGiftItemView:SetData(data)
  self.template = data
  local quality = self.template.color
  local num = DataCenter.GiftSystemManager:GetGiftNum(data.id)
  local goods = DataCenter.GiftSystemManager:GetGiftGoods(data.id)
  self.qualityImg:LoadSprite(GiftSystemConst.GetGiftDetailQualityIcon(quality))
  self.giftIconImg:LoadSprite(GiftSystemConst.GetIconPath(goods.icon_mid))
  self.giftIconImg:SetNativeSize()
  self.giftNameTxt:SetLocalText(self.template.name)
  self.giftNumTxt:SetText("x" .. string.GetFormattedStr(num))
  self.addCharmTxt:SetText("+" .. goods.add_exp)
  self.selectGo:SetActive(false)
  self.blackMask:SetActive(num == 0)
  self.detailBtn:SetActive(false)
  self.recycleGo:SetActive(false)
end

function LWUIGiftItemView:SetOnSelect(func)
  self.selectFunc = func
end

function LWUIGiftItemView:SetSelect(state)
  self.selectGo:SetActive(state)
end

function LWUIGiftItemView:SetShowType(windowType)
  self.windowType = windowType
  self.detailBtn:SetActive(windowType == GiftSystemConst.WindowType.Show)
  local showExpired = DataCenter.ItemExchangeManager:IsShowWillExpired(tonumber(self.template.id))
  self.recycleGo:SetActive(windowType == GiftSystemConst.WindowType.Send and showExpired)
end

function LWUIGiftItemView:OnDetailBtnClick()
  if self.windowType ~= GiftSystemConst.WindowType.Show then
    return
  end
  if self.template == nil then
    return
  end
  local originId = DataCenter.GiftSystemManager:GetOriginId(self.template.id)
  if originId == nil then
    Logger.LogError("\230\137\190\228\184\141\229\136\176\231\164\188\231\137\169\229\142\159\229\167\139id " .. tostring(self.template.id))
    return
  end
  UIManager:GetInstance():OpenWindow(UIWindowNames.LWUIGiftHistory, {anim = true}, {
    targetUid = LuaEntry.Player.uid,
    itemId = originId
  })
end

LWUIGiftItemView.OnCreate = OnCreate
LWUIGiftItemView.OnDestroy = OnDestroy
LWUIGiftItemView.OnEnable = OnEnable
LWUIGiftItemView.OnDisable = OnDisable
LWUIGiftItemView.ComponentDefine = ComponentDefine
LWUIGiftItemView.ComponentDestroy = ComponentDestroy
LWUIGiftItemView.DataDefine = DataDefine
LWUIGiftItemView.DataDestroy = DataDestroy
return LWUIGiftItemView
