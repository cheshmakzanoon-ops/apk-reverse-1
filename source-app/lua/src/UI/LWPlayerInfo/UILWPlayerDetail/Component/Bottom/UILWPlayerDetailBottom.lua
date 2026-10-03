local UILWPlayerDetailBottom = BaseClass("UILWPlayerDetailBottom", UIBaseContainer)
local UILWBottomFriendsCricle = require("UI.LWPlayerInfo.UILWPlayerDetail.Component.Bottom.FriendsCircle.UILWBottomFriendsCircle")
local UILWBottomGift = require("UI.LWPlayerInfo.UILWPlayerDetail.Component.Bottom.Gift.UILWGift")
local isOpen = true
local hasFriendCricleHight = 628
local notFriendCricleHight = 198
local giftItemH = 198
local base = UIBaseContainer

function UILWPlayerDetailBottom:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
end

function UILWPlayerDetailBottom:OnAddListener()
  base.OnAddListener(self)
end

function UILWPlayerDetailBottom:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UILWPlayerDetailBottom:ComponentDefine()
  self.friendsCircle = self:AddComponent(UILWBottomFriendsCricle, "FriendsCircle")
  self.gift = self:AddComponent(UILWBottomGift, "gift")
end

function UILWPlayerDetailBottom:ReInit(data, systemSwitch)
  if data then
    if systemSwitch and systemSwitch.friendsCirle then
      self.friendsCircle:ReInit(data)
    end
    if systemSwitch.gift then
      self.gift:ReInit(data.giftDataList, GiftShowType.Basics, data.uid)
    end
  end
  self:UpdateLayout(data, systemSwitch)
end

function UILWPlayerDetailBottom:UpdateLayout(data, systemSwitch)
  local friendsCircleSize = self.friendsCircle:GetSizeDelta()
  if not systemSwitch then
    return
  end
  local friendsCircleHigh = 0
  if systemSwitch.gift then
    self.gift:SetActive(true)
    friendsCircleHigh = 500
    hasFriendCricleHight = friendsCircleHigh + giftItemH - 5
  else
    self.gift:SetActive(false)
    friendsCircleHigh = 580
    hasFriendCricleHight = friendsCircleHigh
  end
  if systemSwitch.friendsCirle then
    self.friendsCircle:SetSizeDeltaXY(friendsCircleSize.x, friendsCircleHigh)
  end
  self.friendsCircle:SetActive(systemSwitch.friendsCirle)
  if not systemSwitch.friendsCirle and systemSwitch.gift then
    self.rectTransform:SetSizeWithCurrentAnchors(CS.UnityEngine.RectTransform.Axis.Vertical, notFriendCricleHight)
  else
    self.rectTransform:SetSizeWithCurrentAnchors(CS.UnityEngine.RectTransform.Axis.Vertical, hasFriendCricleHight)
  end
  if self.view and self.view.bg then
    CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.view.bg.rectTransform)
  end
end

function UILWPlayerDetailBottom:ComponentDestroy()
  self.friendsCircle = nil
end

function UILWPlayerDetailBottom:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UILWPlayerDetailBottom:DataDestroy()
end

return UILWPlayerDetailBottom
