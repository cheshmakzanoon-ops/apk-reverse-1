local base = UIBaseContainer
local LWUIGiftShowItemNew = BaseClass("LWUIGiftShowItemNew", base)
local GiftIconShowContent = require("UI/LWPlayerInfo/UILWGiftSystem/Common/GiftIconShowContent")
local bgImg_path = "Content/Bg"
local iconImg_path = "Content/IconContent/Icon"
local deleteBtn_path = "CloseIcon"
local numTxt_path = "Num"
local emptyGo_path = "Empty"
local button_path = "Button"
local contentCom_path = "Content"
local selectGo_path = "Select"
local emptyIconImg_path = "Empty/EmptyIcon"
local gift_icon_show_content_path = "Content/IconContent/GiftIconShowContent"
local icon_content_path = "Content/IconContent"
local lock_path = "Lock"
local eff_gift_unlock_path = "Empty/Eff_Gift_unlock"
local eff_ui_gift_select_path = "Content/IconContent/Eff_ui_Gift_select"
local eff_ui_Gift_show_path = "Content/IconContent/Eff_ui_Gift_show"
local eff_ui_gift_select_low_path = "Content/IconContent/Eff_ui_Gift_select_purple"

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

function LWUIGiftShowItemNew:ComponentDefine()
  self.bgImg = self:AddComponent(UIImage, bgImg_path)
  self.iconImg = self:AddComponent(UIImage, iconImg_path)
  self.deleteBtn = self:AddComponent(UIButton, deleteBtn_path)
  self.numTxt = self:AddComponent(UIText, numTxt_path)
  self.emptyGo = self:AddComponent(UIBaseContainer, emptyGo_path)
  self.button = self:AddComponent(UIButton, button_path)
  self.contentCom = self:AddComponent(UIBaseContainer, contentCom_path)
  self.selectGo = self:AddComponent(UIBaseContainer, selectGo_path)
  self.emptyIconImg = self:AddComponent(UIImage, emptyIconImg_path)
  self.selectEffect = self:AddComponent(UIBaseComponent, eff_ui_gift_select_path)
  self.selectEffect_low = self:AddComponent(UIBaseComponent, eff_ui_gift_select_low_path)
  self.gift_icon_show_content = self:AddComponent(GiftIconShowContent, gift_icon_show_content_path)
  self.icon_content = self:AddComponent(UIBaseContainer, icon_content_path)
  self.animator = self:AddComponent(UISimpleAnimation, icon_content_path)
  self.button:SetOnClick(function()
    self:OnItemClick()
  end)
  self.deleteBtn:SetOnClick(function()
    self:OnDeleteClick()
  end)
  self.lock = self:AddComponent(UIBaseContainer, lock_path)
  self.emptyGoAni = self:AddComponent(UISimpleAnimation, emptyGo_path)
  self.eff_gift_unlock = self:AddComponent(UIVfx, eff_gift_unlock_path, VfxAssets.GiftUnlockShowEffect, {
    lifeType = UIVfxLifeType.Stay
  })
end

function LWUIGiftShowItemNew:SetShowData(showData, showType)
  self.data = showData
  self.showType = showType
end

function LWUIGiftShowItemNew:ReInit()
  if not self.showType then
    self.showType = GiftShowType.Basics
  end
  self:RefreshView()
  self:SwitchoverCom()
end

function LWUIGiftShowItemNew:SetOnSelect(selectFunc)
  self.selectFunc = selectFunc
end

function LWUIGiftShowItemNew:RefreshView()
  if self.data and self.data.giftShowItemType then
    if self.data.giftShowItemType == GiftShowItemType.Lock then
      self.numTxt:SetText("")
    end
  elseif self.data and self.data.itemId and self.data.count and self.data.count > 0 then
    local template = DataCenter.ItemTemplateManager:GetItemTemplate(self.data.itemId)
    local goods = DataCenter.GiftSystemManager:GetGiftGoods(template.id)
    self.bgImg:LoadSprite(GiftSystemConst.GetPlayerInfoQualityBottomBg(template.color))
    local hOffset, minScale, midScale, maxScale = DataCenter.GiftSystemManager.GetGiftIconParam(goods)
    if 0 < #goods.show_fx then
      self.iconImg:SetActive(false)
      self.gift_icon_show_content:SetActive(true)
      self.gift_icon_show_content:SetShowData(goods.id, self.data.unlockNum and self.data.unlockNum or 1)
      self.gift_icon_show_content:SetAnchoredPositionXY(0, hOffset)
      self.gift_icon_show_content:SetLocalScaleXYZ(midScale, midScale, midScale)
    else
      self.iconImg:SetActive(true)
      self.gift_icon_show_content:SetActive(false)
      local iconName = goods.icon_big
      if self.data.unlockNum and 0 < self.data.unlockNum and 0 < #goods.group_id then
        local groupIndex = 1
        for i, v in ipairs(goods.group_id) do
          if self.data.unlockNum >= tonumber(v) then
            groupIndex = i
          else
            break
          end
        end
        iconName = goods.group_pic[groupIndex]
      end
      self.iconImg:LoadSpriteAsyncWithCallback(GiftSystemConst.GetIconPathNew(iconName), function()
        if self.iconImg then
          self.iconImg:SetNativeSize()
        end
      end)
      self.iconImg:SetAnchoredPositionXY(0, hOffset)
      self.iconImg:SetLocalScaleXYZ(midScale, midScale, midScale)
    end
    local countStr = string.GetFormattedStr(self.data.count or 0)
    self.numTxt:SetText(countStr)
  else
    self.numTxt:SetText("")
  end
  self:SetSelect(false)
end

function LWUIGiftShowItemNew:SwitchoverCom()
  if self.showType == GiftShowType.Basics then
    local show = (self.data and self.data.itemId) ~= nil
    self.bgImg:SetActive(show)
    self.icon_content:SetActive(show)
    self.numTxt:SetActive(show)
    self.contentCom:SetActive(show)
    self.deleteBtn:SetActive(false)
    if show then
      self.emptyGo:SetActive(not show)
      self.lock:SetActive(not show)
    elseif self.data and self.data.giftShowItemType then
      self.emptyGo:SetActive(false)
      self.lock:SetActive(self.data.giftShowItemType == GiftShowItemType.Lock)
    else
      self.emptyGo:SetActive(true)
      self.lock:SetActive(false)
      if self.data.isNeedTip then
        self.emptyGoAni:SampleAnimationAtTime("Default", 0)
      else
        self.emptyGoAni:Play("idle")
      end
    end
  elseif self.showType == GiftShowType.Edit then
    local show = (self.data and self.data.itemId) ~= nil
    self.bgImg:SetActive(show)
    self.icon_content:SetActive(show)
    self.numTxt:SetActive(show)
    self.contentCom:SetActive(show)
    self.deleteBtn:SetActive(show)
    if show then
      self.emptyGo:SetActive(not show)
      self.lock:SetActive(not show)
    elseif self.data and self.data.giftShowItemType then
      self.emptyGo:SetActive(false)
      self.lock:SetActive(self.data.giftShowItemType == GiftShowItemType.Lock)
    else
      self.emptyGo:SetActive(true)
      self.lock:SetActive(false)
      if self.data.isNeedTip then
        self.emptyGoAni:SampleAnimationAtTime("Default", 0)
      else
        self.emptyGoAni:Play("idle")
      end
    end
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
  self.gift_icon_show_content = nil
  self.icon_content = nil
  self.lock = nil
  self.eff_gift_unlock = nil
end

local function DataDefine(self)
  self.data = nil
end

local function DataDestroy(self)
  self.data = nil
end

function LWUIGiftShowItemNew:OnItemClick()
  if type(self.selectFunc) == "function" then
    self.selectFunc(self.data, self.showType)
  end
end

function LWUIGiftShowItemNew:OnDeleteClick()
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

function LWUIGiftShowItemNew:SetSelect(state)
  self.selectGo:SetActive(state)
  self.selectEffect:SetActive(false)
  self.selectEffect_low:SetActive(false)
  if self.data and self.data.itemId and state then
    local template = DataCenter.ItemTemplateManager:GetItemTemplate(self.data.itemId)
    if template then
      if template.color > 4 then
        self.selectEffect:SetActive(true)
      else
        self.selectEffect_low:SetActive(true)
      end
    end
  end
end

function LWUIGiftShowItemNew:ShowEffect(state)
  if state then
    self.animator:Rewind("show")
    self.animator:Play("show")
  end
end

function LWUIGiftShowItemNew:SetTipRecord()
  if self.data and self.data.isNeedTip then
    self.data.isNeedTip = false
    local posIndex = self.data.pos
    local itemBaseNum = GiftSystemConst:GetDefaultGiftShowNum()
    local rIndex = posIndex - itemBaseNum
    if 0 < rIndex then
      if self.data.giftShowItemType then
        if self.data.giftShowItemType == GiftShowItemType.Lock then
          DataCenter.GiftSystemManager:SetGiftShowTipStateType(rIndex, GiftShowIndexTipStateType.LockTip)
        end
      else
        if self.data.itemId == nil then
          self.emptyGoAni:Play("Default")
          self.eff_gift_unlock:Replay()
        end
        DataCenter.GiftSystemManager:SetGiftShowTipStateType(rIndex, GiftShowIndexTipStateType.UnlockTip)
      end
    end
  end
end

LWUIGiftShowItemNew.OnCreate = OnCreate
LWUIGiftShowItemNew.OnDestroy = OnDestroy
LWUIGiftShowItemNew.OnEnable = OnEnable
LWUIGiftShowItemNew.OnDisable = OnDisable
LWUIGiftShowItemNew.ComponentDestroy = ComponentDestroy
LWUIGiftShowItemNew.DataDefine = DataDefine
LWUIGiftShowItemNew.DataDestroy = DataDestroy
return LWUIGiftShowItemNew
