local UIZombieEliteBossRewardItem = BaseClass("UIZombieEliteBossRewardItem", UIBaseContainer)
local base = UIBaseContainer
local u_i_common_res_item_path = "UICommonResItem"

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
end

local function OnDestroy(self)
  self:ComponentDestroy()
  base.OnDestroy(self)
end

local function ComponentDefine(self)
  self.u_i_common_res_item = self:AddComponent(UICommonResItem, u_i_common_res_item_path)
end

local function ComponentDestroy(self)
  self.u_i_common_res_item = nil
end

local function ReInit(self, param)
  if not string.IsNullOrEmpty(param) then
    local arr = string.split(param, ";")
    if arr and 4 <= #arr then
      local para = {}
      para.rewardType = DataCenter.RewardManager:GetRewardTypeByDropType(tonumber(arr[1]))
      para.itemId = arr[2]
      para.count = tonumber(arr[3])
      self.u_i_common_res_item:ReInit(para)
      self:SetRateText(arr[4])
    end
  end
end

local function OnCloseClick(self)
  self:SetPanelShow(false)
end

local function SetRateText(self, rate)
end

UIZombieEliteBossRewardItem.OnCreate = OnCreate
UIZombieEliteBossRewardItem.OnDestroy = OnDestroy
UIZombieEliteBossRewardItem.ComponentDefine = ComponentDefine
UIZombieEliteBossRewardItem.ComponentDestroy = ComponentDestroy
UIZombieEliteBossRewardItem.OnCloseClick = OnCloseClick
UIZombieEliteBossRewardItem.ReInit = ReInit
UIZombieEliteBossRewardItem.SetRateText = SetRateText
return UIZombieEliteBossRewardItem
