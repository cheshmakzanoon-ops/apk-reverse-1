local PlayerThumbsUpGloryHeadItemComponent = BaseClass("PlayerThumbsUpGloryHeadItemComponent", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local u_i_player_head_path = "UIPlayerHead"
local icon_path = "Icon"

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
  self.u_i_player_head = self:AddComponent(UICommonHead, u_i_player_head_path)
  self.icon = self:AddComponent(UIImage, icon_path)
end

local function ComponentDestroy(self)
  self.u_i_player_head = nil
  self.icon = nil
end

local function DataDefine(self)
end

local function DataDestroy(self)
end

local function OnAddListener(self)
  base.OnAddListener(self)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
end

function PlayerThumbsUpGloryHeadItemComponent:RefreshView(info, headInfo)
  self.u_i_player_head:ParseHeadInfo(headInfo)
  if info.giftId then
    local giftId = info.giftId or 990001
    local goods = DataCenter.GiftSystemManager:GetGiftGoods(giftId)
    self.icon:SetActive(true)
    local hOffset, minScale, midScale, maxScale = DataCenter.GiftSystemManager.GetGiftIconParam(goods)
    self.icon:LoadSpriteAsyncWithCallback(GiftSystemConst.GetIconPathNew(goods.icon_big), function()
      if self.icon then
        self.icon:SetNativeSize()
      end
    end)
    self.icon:SetLocalScaleXYZ(midScale, midScale, midScale)
  else
    self.icon:SetActive(false)
  end
end

PlayerThumbsUpGloryHeadItemComponent.OnCreate = OnCreate
PlayerThumbsUpGloryHeadItemComponent.OnDestroy = OnDestroy
PlayerThumbsUpGloryHeadItemComponent.OnEnable = OnEnable
PlayerThumbsUpGloryHeadItemComponent.OnDisable = OnDisable
PlayerThumbsUpGloryHeadItemComponent.ComponentDefine = ComponentDefine
PlayerThumbsUpGloryHeadItemComponent.ComponentDestroy = ComponentDestroy
PlayerThumbsUpGloryHeadItemComponent.DataDefine = DataDefine
PlayerThumbsUpGloryHeadItemComponent.DataDestroy = DataDestroy
PlayerThumbsUpGloryHeadItemComponent.OnAddListener = OnAddListener
PlayerThumbsUpGloryHeadItemComponent.OnRemoveListener = OnRemoveListener
return PlayerThumbsUpGloryHeadItemComponent
