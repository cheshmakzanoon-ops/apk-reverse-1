local BanquetAttackMonsterLevelRewardView = BaseClass("BanquetAttackMonsterLevelRewardView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local UIGray = CS.UIGray
local BanquetAttackMonsterLevelRewardItem = require("UI.BanquetAttackMonster.BanquetAttackMonsterLevelReward.Component.BanquetAttackMonsterLevelRewardItem")
local Screen = CS.UnityEngine.Screen
local back_btn_path = "content/backBtn"
local level_reward_item_path = "content/levelRewardItem"
local item_content_path = "content/itemContent"

local function OnCreate(self)
  base.OnCreate(self)
  self.activityId, self.targetPos = self:GetUserData()
  self:ComponentDefine()
  self:RefreshView()
end

local function OnDestroy(self)
  self:ComponentDestroy()
  base.OnDestroy(self)
end

local function OnAddListener(self)
  base.OnAddListener(self)
  self:AddUIListener(EventId.ActBanquetScoreRewardReceive, self.OnGetScoreRewardMsg)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
  self:RemoveUIListener(EventId.ActBanquetScoreRewardReceive, self.OnGetScoreRewardMsg)
end

local function ComponentDefine(self)
  local btnPanel = self:AddComponent(UIButton, "Panel")
  btnPanel:SetOnClick(function()
    self.ctrl.CloseSelf(self.ctrl)
  end)
  self.imgArrow = self:AddComponent(UIBaseContainer, "ImgArrow")
  self.content = self:AddComponent(UIBaseContainer, "content")
  self.back_btn = self:AddComponent(UIButton, back_btn_path)
  self.level_reward_item = self:AddComponent(UIImage, level_reward_item_path)
  self.item_content = self:AddComponent(UIBaseContainer, item_content_path)
  self.level_reward_item:SetActive(false)
  self.level_reward_item.gameObject:GameObjectCreatePool()
  self.rewardItemList = {}
end

local function ComponentDestroy(self)
  self:ClearAllItem()
  self.imgArrow = nil
  self.content = nil
  self.back_btn = nil
  self.level_reward_item = nil
  self.item_content = nil
end

local function RefreshView(self)
  self.imgArrow:SetPositionXYZ(self.targetPos.x, self.targetPos.y, 0)
  local anchoredPosition = self.imgArrow:GetAnchoredPosition()
  self.imgArrow:SetAnchoredPositionXY(anchoredPosition.x + 50, anchoredPosition.y)
  self.content:SetAnchoredPositionXY(anchoredPosition.x + 380, anchoredPosition.y + 231)
  local level = DataCenter.ActBanquetV2Data.banquetLevel
  local boxDataList = DataCenter.ActBanquetV2Data:GetActScoreList()
  if #self.rewardItemList ~= #boxDataList then
    self:ClearAllItem()
    for i = 1, #boxDataList do
      local item = self.level_reward_item.gameObject:GameObjectSpawn(self.item_content.transform)
      item.name = i
      local obj = self.item_content:AddComponent(BanquetAttackMonsterLevelRewardItem, item.name)
      obj:SetActive(true)
      self.rewardItemList[i] = obj
    end
  end
  for i = 1, #boxDataList do
    self.rewardItemList[i]:SetData(boxDataList[i], level, self.activityId)
  end
end

local function ClearAllItem(self)
  self.item_content:RemoveComponents(BanquetAttackMonsterLevelRewardItem)
  for _, v in ipairs(self.item_content.transform) do
    if v ~= nil then
      CS.UnityEngine.GameObject.Destroy(v.gameObject)
    end
  end
  self.level_reward_item.gameObject:GameObjectRecycleAll()
  self.rewardItemList = {}
end

local function OnGetScoreRewardMsg(self, msg)
  self:RefreshView()
end

BanquetAttackMonsterLevelRewardView.OnCreate = OnCreate
BanquetAttackMonsterLevelRewardView.OnDestroy = OnDestroy
BanquetAttackMonsterLevelRewardView.ComponentDefine = ComponentDefine
BanquetAttackMonsterLevelRewardView.ComponentDestroy = ComponentDestroy
BanquetAttackMonsterLevelRewardView.OnAddListener = OnAddListener
BanquetAttackMonsterLevelRewardView.OnRemoveListener = OnRemoveListener
BanquetAttackMonsterLevelRewardView.RefreshView = RefreshView
BanquetAttackMonsterLevelRewardView.ClearAllItem = ClearAllItem
BanquetAttackMonsterLevelRewardView.OnGetScoreRewardMsg = OnGetScoreRewardMsg
return BanquetAttackMonsterLevelRewardView
