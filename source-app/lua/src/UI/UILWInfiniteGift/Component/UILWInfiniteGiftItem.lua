local UILWInfiniteGiftItem = BaseClass("UILWInfiniteGiftItem", UIBaseContainer)
local base = UIBaseContainer
local UIGiftPackagePoint = require("UI.UIGiftPackage.Component.UIGiftPackagePoint")
local UILWInfiniteGiftRewardItem = require("UI.UILWInfiniteGift.Component.UILWInfiniteGiftRewardItem")
local LWBtnBuyRefundRemind = require("UI.LWBtnBuyRefundRemind.LWBtnBuyRefundRemind")
local Localization = CS.GameEntry.Localization
local UIGray = CS.UIGray
local rewardsScroll_path = "RewardsScroll/RewardsViewport/RewardsContent"
local diamondValueText_path = "ValueGroup/ValueText"
local rewardTypeContent_path = "RewardTypeContent"
local rewardTypeClaimBtn_path = "RewardTypeContent/ClaimBtn"
local rewardTypeClaimBtnLockIcon_path = "RewardTypeContent/ClaimBtn/ClaimBtnLockIcon"
local giftPackageContent_path = "GiftPackageTypeContnet"
local giftPackageBuyBtn_path = "GiftPackageTypeContnet/BuyBtn"
local giftPackageBuyBtnTxt_path = "GiftPackageTypeContnet/BuyBtn/Txt_Cost"
local giftPackageGiftPackPoint_path = "GiftPackageTypeContnet/BuyBtn/UIGiftPackagePoint"
local giftPackageBuyBtnLockIcon_path = "GiftPackageTypeContnet/BuyBtn/BuyBtnLockIcon"
local giftPackageRefreshBtn_path = "GiftPackageTypeContnet/RefreshBtn"
local giftPackageRefreshBtnText_path = "GiftPackageTypeContnet/RefreshBtn/RefreshBtnText"
local arrowIcon_path = "ArrowIcon"

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

local function OnDestroy(self)
  self:RemoveCountDownTimer()
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

local function OnAddListener(self)
  base.OnAddListener(self)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function ComponentDefine(self)
  self.rewardsScroll = self:AddComponent(UIBaseContainer, rewardsScroll_path)
  self.diamondValueText = self:AddComponent(UIText, diamondValueText_path)
  self.rewardTypeContent = self:AddComponent(UIBaseContainer, rewardTypeContent_path)
  self.rewardTypeClaimBtn = self:AddComponent(UIButton, rewardTypeClaimBtn_path)
  self.rewardTypeClaimBtn:SetOnClick(function()
    self:OnClaimBtnClick()
  end)
  self.rewardTypeClaimBtnLockIcon = self:AddComponent(UIImage, rewardTypeClaimBtnLockIcon_path)
  self.giftPackageContent = self:AddComponent(UIBaseContainer, giftPackageContent_path)
  self.giftPackageBuyBtn = self:AddComponent(LWBtnBuyRefundRemind, giftPackageBuyBtn_path)
  self.giftPackageBuyBtn:SetBuyClickAction(function()
    self:OnBuyBtnClick()
  end)
  self.giftPackageBuyBtnLockIcon = self:AddComponent(UIImage, giftPackageBuyBtnLockIcon_path)
  self.giftPackageRefreshBtn = self:AddComponent(UIButton, giftPackageRefreshBtn_path)
  self.giftPackageRefreshBtn:SetOnClick(function()
    self:OnRefreshBtnClick()
  end)
  self.giftPackageRefreshBtnText = self:AddComponent(UIText, giftPackageRefreshBtnText_path)
  self.bg = self:AddComponent(UIRawImage, "")
  self.arrowIcon = self:AddComponent(UIImage, arrowIcon_path)
end

local function ComponentDestroy(self)
  self.rewardsScroll = nil
  self.diamondValueText = nil
  self.rewardTypeContent = nil
  self.rewardTypeClaimBtn = nil
  self.rewardTypeClaimBtnLockIcon = nil
  self.giftPackageContent = nil
  self.giftPackageBuyBtn = nil
  self.giftPackageBuyBtnLockIcon = nil
  self.giftPackageRefreshBtn = nil
  self.bg = nil
  self.arrowIcon = nil
end

local function DataDefine(self)
  self.reqList = {}
  self.timer_call_back = BindCallback(self, self.RefreshTime)
end

local function DataDestroy(self)
  self.timer_call_back = nil
end

local function OnBuyBtnClick(self)
  if not self.giftPackData then
    return
  end
  if not self.data.unlock then
    UIUtil.ShowTipsId(2010806)
    return
  end
  DataCenter.PayManager:BuyGift(self.giftPackData)
end

local function OnRefreshBtnClick(self)
  if not self.data then
    return
  end
  if self.data.type ~= InfiniteGiftType.GiftPackage then
    return
  end
  if not self.data.unlock then
    return
  end
  if self.view then
    self.view:RefreshGroup(self.data)
  end
end

local function OnClaimBtnClick(self)
  if not self.data then
    return
  end
  if self.data.type ~= InfiniteGiftType.Reawrd then
    return
  end
  if not self.data.unlock then
    UIUtil.ShowTipsId(2010806)
    return
  end
  if self.view then
    self.view:ClaimReward(self.data)
  end
end

local function ClearRewards(self)
  if self.reqList then
    self.rewardsScroll:RemoveComponents(UILWInfiniteGiftRewardItem)
    for i, v in pairs(self.reqList) do
      if v then
        v:Destroy()
      end
    end
    self.reqList = {}
  end
end

local picTypeMap = {
  [1] = "Assets/Main/TextureEx/UILWInfiniteGift/zyf_lianhuanduobao_diban3.png",
  [2] = "Assets/Main/TextureEx/UILWInfiniteGift/zyf_lianhuanduobao_diban2.png",
  [3] = "Assets/Main/TextureEx/UILWInfiniteGift/zyf_lianhuanduobao_diban1.png"
}

local function AddCountDownTimer(self)
  if self.timer then
    self.timer:Stop()
    self.timer = nil
  end
  if self.timer == nil then
    self.timer = TimerManager:GetInstance():GetTimer(0.5, self.timer_call_back)
  end
  self.timer:Start()
end

local function RemoveCountDownTimer(self)
  if self.timer ~= nil then
    self.timer:Stop()
    self.timer = nil
  end
end

local function RefreshTime(self)
  if not self.endTime then
    return
  end
  local curTime = UITimeManager:GetInstance():GetServerTime()
  if curTime < self.endTime then
    self.giftPackageRefreshBtnText:SetText(UITimeManager:GetInstance():MilliSecondToFmtString(self.endTime - curTime))
  else
    self.giftPackageRefreshBtnText:SetLocalText(2010804)
    UIGray.SetGray(self.giftPackageRefreshBtn.transform, false, true)
    self:RemoveCountDownTimer()
  end
end

local function SetData(self, data)
  if not data then
    self:SetActive(false)
    return
  end
  self.data = data
  self.giftPackData = nil
  self.endTime = nil
  self:RemoveCountDownTimer()
  if self.data.type == InfiniteGiftType.GiftPackage then
    local giftPackData = GiftPackageData.get(tostring(self.data.id))
    if not giftPackData then
      self:SetActive(false)
      return
    end
    self.giftPackageContent:SetActive(true)
    self.rewardTypeContent:SetActive(false)
    self.giftPackData = giftPackData
    self.giftPackageBuyBtn:Init(self.giftPackData)
    self.giftPackageBuyBtn:RefreshPoint()
    self.giftPackageBuyBtnLockIcon:SetActive(not self.data.unlock)
    if self.data.canRefresh then
      self.endTime = self.view:GetRefreshTime()
      self.giftPackageRefreshBtn:SetActive(true)
      local curTime = UITimeManager:GetInstance():GetServerTime()
      self.giftPackageRefreshBtnText:SetText("")
      if curTime < self.endTime then
        self:AddCountDownTimer()
        UIGray.SetGray(self.giftPackageRefreshBtn.transform, true, true)
      else
        UIGray.SetGray(self.giftPackageRefreshBtn.transform, false, true)
      end
      self:RefreshTime()
    else
      self.giftPackageRefreshBtn:SetActive(false)
    end
  elseif self.data.type == InfiniteGiftType.Reawrd then
    self.giftPackageContent:SetActive(false)
    self.rewardTypeContent:SetActive(true)
    self.rewardTypeClaimBtnLockIcon:SetActive(not self.data.unlock)
  end
  self:SetActive(true)
  self.bg:LoadSprite(picTypeMap[self.data.pic])
  self.diamondValueText:SetLocalText(2010808, self.data.value)
  self.arrowIcon:SetActive(not self.data.unlock)
  local rewards = self.data.rewards
  if rewards and 0 < #rewards then
    if self.rewards and table.deep_compare(self.rewards, rewards) then
      return
    end
    self.rewards = rewards
    self.rewardsScroll:SetActive(true)
    ClearRewards(self)
    for i = 1, #self.rewards do
      self.reqList[i] = self:GameObjectInstantiateAsync(UIAssets.UILWInfiniteGiftRewardItem, function(request)
        if IsNull(request.gameObject) then
          return
        end
        local go = request.gameObject
        go.transform:SetParent(self.rewardsScroll.transform)
        go.transform:Set_localScale(0.9, 0.9, 1)
        go.transform:Set_sizeDelta(108, 108.4)
        go.transform.pivot = Vector2.New(0.5, 0.5)
        go.name = "item" .. i
        local cell = self.rewardsScroll:AddComponent(UILWInfiniteGiftRewardItem, go.name)
        cell:ReInit(self.rewards[i])
      end)
    end
  else
    self.rewardsScroll:SetActive(false)
  end
end

UILWInfiniteGiftItem.OnCreate = OnCreate
UILWInfiniteGiftItem.OnDestroy = OnDestroy
UILWInfiniteGiftItem.OnAddListener = OnAddListener
UILWInfiniteGiftItem.OnRemoveListener = OnRemoveListener
UILWInfiniteGiftItem.OnEnable = OnEnable
UILWInfiniteGiftItem.OnDisable = OnDisable
UILWInfiniteGiftItem.ComponentDefine = ComponentDefine
UILWInfiniteGiftItem.ComponentDestroy = ComponentDestroy
UILWInfiniteGiftItem.DataDefine = DataDefine
UILWInfiniteGiftItem.DataDestroy = DataDestroy
UILWInfiniteGiftItem.SetData = SetData
UILWInfiniteGiftItem.OnBuyBtnClick = OnBuyBtnClick
UILWInfiniteGiftItem.OnClaimBtnClick = OnClaimBtnClick
UILWInfiniteGiftItem.OnRefreshBtnClick = OnRefreshBtnClick
UILWInfiniteGiftItem.AddCountDownTimer = AddCountDownTimer
UILWInfiniteGiftItem.RemoveCountDownTimer = RemoveCountDownTimer
UILWInfiniteGiftItem.RefreshTime = RefreshTime
return UILWInfiniteGiftItem
