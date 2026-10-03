local UIActValentineGetGiftUpAtEnterView = BaseClass("UIActValentineGetGiftUpAtEnterView", UIBaseView)
local GetGiftDetailItem = require("UI.LWUIActValentineGetGiftUpAtEnter.Component.UIActValentineGetGift1ContentComponent")
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local u_i_act_valentine_get_gift1_content_path = "rewardPage/InfoContent/GiftContent/UIActValentineGetGift1Content"
local gift_content_path = "rewardPage/InfoContent/GiftContent"
local claim_btn_path = "rewardPage/InfoContent/btnContent/ClaimBtn"
local GIFT_APPEAR_INTERVAL = 1.9

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self.param = self:GetUserData()
  self.rData = self.param
  self.fromLastReceiveGift = self.rData.fromLastReceiveGift
  self:ReInit()
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
  self.content = self:AddComponent(UIBaseContainer, gift_content_path)
  self.giftItem = self:AddComponent(UIBaseContainer, u_i_act_valentine_get_gift1_content_path)
  self.giftItem.gameObject:GameObjectCreatePool()
  self.simpleAni = self:AddComponent(UISimpleAnimation, "")
  self.confirmBtn = self:AddComponent(UIButton, claim_btn_path)
  self.confirmBtn:SetOnClick(function()
    self:CloseBtnClick()
  end)
end

local function ComponentDestroy(self)
  self.giftItem.gameObject:GameObjectRecycleAll()
end

local function DataDefine(self)
  self.timer = nil
  self.allGiftContentList = {}
end

local function DataDestroy(self)
  self:StopAllTimer()
  self.allGiftContentList = nil
end

local function OnAddListener(self)
  base.OnAddListener(self)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
end

function UIActValentineGetGiftUpAtEnterView:ReInit()
  self.allGiftContentList = {}
  self.giftItem.gameObject:GameObjectRecycleAll()
  self:StopAllTimer()
  if not (self.fromLastReceiveGift and self.fromLastReceiveGift.newGiftArr) or #self.fromLastReceiveGift.newGiftArr <= 0 then
    return
  end
  local giftDataList = self.fromLastReceiveGift.newGiftArr
  table.sort(giftDataList, function(a, b)
    local itemCfgA = DataCenter.ItemTemplateManager:GetItemTemplate(a.itemId)
    local itemCfgB = DataCenter.ItemTemplateManager:GetItemTemplate(b.itemId)
    return itemCfgA.color > itemCfgB.color
  end)
  for _, v in ipairs(giftDataList) do
    local gameObject = self.giftItem.gameObject:GameObjectSpawn(self.content.transform)
    local name = "item_" .. NameCount
    NameCount = NameCount + 1
    gameObject.name = name
    local giftDetailItem = self.content:AddComponent(GetGiftDetailItem, name)
    local param = {}
    param.data = v
    param.isSpecialGift = self:CheckSpecialGift(v.itemId)
    giftDetailItem:ReInit(param)
    table.insert(self.allGiftContentList, giftDetailItem)
  end
  local ret, time = self.simpleAni:PlayAnimationReturnTime("FadeIn")
  self.timer = TimerManager:GetInstance():DelayInvoke(function()
    self.timer = nil
    self:ShowSpecialGiftTimeLine()
    for index, v in ipairs(self.allGiftContentList) do
      v:ResetAni()
    end
  end, time)
end

function UIActValentineGetGiftUpAtEnterView:CheckIsNeedExistSpecialGift()
  if not self.fromLastReceiveGift or not self.fromLastReceiveGift.newGiftArr then
    return false
  end
  for _, v in pairs(self.fromLastReceiveGift.newGiftArr) do
    if self:CheckSpecialGift(v.itemId) then
      return true, v.itemId
    end
  end
  return false
end

function UIActValentineGetGiftUpAtEnterView:CheckSpecialGift(itemId)
  if not self.rData or not self.rData.activityGetData then
    return false
  end
  local specialGift = self.rData.activityGetData.anime_gift
  if not specialGift then
    return false
  end
  local specialItemId = toInt(specialGift)
  return specialItemId == itemId
end

function UIActValentineGetGiftUpAtEnterView:ShowSpecialGiftTimeLine()
  local ret, itemId = self:CheckIsNeedExistSpecialGift()
  if not ret then
    self:ShowReceiveGift()
    return
  end
  local data = {
    giftId = itemId,
    callback = function()
      self:ShowReceiveGift()
    end
  }
  if UIManager:GetInstance():IsWindowOpen(UIWindowNames.LWUIGiftSpecialAnimShow) then
    EventManager:GetInstance():Broadcast(EventId.GiftSystemPlayEffect, data)
  else
    UIManager:GetInstance():OpenWindow(UIWindowNames.LWUIGiftSpecialAnimShow, {anim = true}, data)
  end
end

function UIActValentineGetGiftUpAtEnterView:ShowReceiveGift()
  local ret, time = self.simpleAni:PlayAnimationReturnTime("ShowTitle")
  self.timer = TimerManager:GetInstance():DelayInvoke(function()
    self.timer = nil
    self:ShowReceiveGiftDetailInfo()
  end, 0.1)
end

function UIActValentineGetGiftUpAtEnterView:ShowReceiveGiftDetailInfo()
  for index, v in ipairs(self.allGiftContentList) do
    local isLastItem = index == #self.allGiftContentList
    local giftContent = v
    local delayTime = (index - 1) * GIFT_APPEAR_INTERVAL
    
    local function playAniFunc()
      giftContent:ShowDisplayAni()
      if isLastItem then
        self.timer = TimerManager:GetInstance():DelayInvoke(function()
          self.timer = nil
          self.simpleAni:Play("ShowBtn")
        end, 1.2)
      end
    end
    
    if 0 < delayTime then
      self.timer = TimerManager:GetInstance():DelayInvoke(function()
        self.timer = nil
        playAniFunc()
      end, delayTime)
    else
      playAniFunc()
    end
  end
end

function UIActValentineGetGiftUpAtEnterView:StopAllTimer()
  if self.timer then
    self.timer:Stop()
    self.timer = nil
  end
end

function UIActValentineGetGiftUpAtEnterView:CloseBtnClick()
  if self.timer then
    return
  end
  for index, v in ipairs(self.allGiftContentList) do
    v:ShowDisappearAni()
  end
  local ret, time = self.simpleAni:PlayAnimationReturnTime("FadeOut")
  self.timer = TimerManager:GetInstance():DelayInvoke(function()
    self.timer = nil
    self.ctrl:CloseSelf()
  end, time or 1)
end

UIActValentineGetGiftUpAtEnterView.OnCreate = OnCreate
UIActValentineGetGiftUpAtEnterView.OnDestroy = OnDestroy
UIActValentineGetGiftUpAtEnterView.OnEnable = OnEnable
UIActValentineGetGiftUpAtEnterView.OnDisable = OnDisable
UIActValentineGetGiftUpAtEnterView.ComponentDefine = ComponentDefine
UIActValentineGetGiftUpAtEnterView.ComponentDestroy = ComponentDestroy
UIActValentineGetGiftUpAtEnterView.DataDefine = DataDefine
UIActValentineGetGiftUpAtEnterView.DataDestroy = DataDestroy
UIActValentineGetGiftUpAtEnterView.OnAddListener = OnAddListener
UIActValentineGetGiftUpAtEnterView.OnRemoveListener = OnRemoveListener
return UIActValentineGetGiftUpAtEnterView
