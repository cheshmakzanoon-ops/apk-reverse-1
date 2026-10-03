local BanquetAttackMonsterRateRewardView = BaseClass("BanquetAttackMonsterRateRewardView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local BanquetAttackMonsterRateRewardItem = require("UI.BanquetAttackMonster.BanquetAttackMonsterRateReward.Component.BanquetAttackMonsterRateRewardItem")
local Screen = CS.UnityEngine.Screen
local btn_close_path = "BgContent/bg/BtnClose"
local reward_rate_item_path = "mainObj/rewardRateItem"
local monster_icon_path = "mainObj/monsterIcon"
local monster_name_path = "mainObj/monsterName"
local monster_desc_path = "mainObj/monsterDesc"
local content1_path = "mainObj/rewardRateShowItem1/Scroll/Viewport/Content1"
local content2_path = "mainObj/rewardRateShowItem2/Scroll/Viewport/Content2"
local content3_path = "mainObj/rewardRateShowItem3/Scroll/Viewport/Content3"
local next_monster_icon_path = "mainObj/nextMonsterIcon"
local next_monster_name_path = "mainObj/nextMonsterName"

local function OnCreate(self)
  base.OnCreate(self)
  self.activityId = self:GetUserData()
  self:ComponentDefine()
  self:RefreshView()
end

local function OnDestroy(self)
  self:ComponentDestroy()
  base.OnDestroy(self)
end

local function OnAddListener(self)
  base.OnAddListener(self)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
end

local function ComponentDefine(self)
  local btnPanel = self:AddComponent(UIButton, "Panel")
  btnPanel:SetOnClick(function()
    self.ctrl.CloseSelf(self.ctrl)
  end)
  self.btn_close = self:AddComponent(UIButton, btn_close_path)
  self.reward_rate_item = self:AddComponent(UIBaseContainer, reward_rate_item_path)
  self.monster_icon = self:AddComponent(UIImage, monster_icon_path)
  self.monster_name = self:AddComponent(UITextMeshProUGUIEx, monster_name_path)
  self.monster_desc = self:AddComponent(UITextMeshProUGUIEx, monster_desc_path)
  self.content1 = self:AddComponent(UIBaseContainer, content1_path)
  self.content2 = self:AddComponent(UIBaseContainer, content2_path)
  self.content3 = self:AddComponent(UIBaseContainer, content3_path)
  self.next_monster_icon = self:AddComponent(UIImage, next_monster_icon_path)
  self.next_monster_name = self:AddComponent(UITextMeshProUGUIEx, next_monster_name_path)
  self.btn_close:SetOnClick(function()
    self.ctrl.CloseSelf(self.ctrl)
  end)
  self.reward_rate_item:SetActive(false)
  self.reward_rate_item.gameObject:GameObjectCreatePool()
  self.rateItemList = {}
end

local function ComponentDestroy(self)
  self:ClearAllItem()
end

local function OnEnable(self)
end

local function OnDisable(self)
end

local function RefreshView(self)
  self.actBanquetTemplate = DataCenter.ActBanquetV2Data.actBanquetTemplate
  if self.actBanquetTemplate == nil then
    return
  end
  local monsterIds = self.actBanquetTemplate.monster_order
  local curMonsterIndex = DataCenter.ActBanquetV2Data.index + 1
  local nextMonsterIndex = curMonsterIndex + 1
  nextMonsterIndex = math.min(nextMonsterIndex, #monsterIds)
  local curMonsterId = self.actBanquetTemplate.monster_order[curMonsterIndex]
  local nextMonsterId = self.actBanquetTemplate.monster_order[nextMonsterIndex]
  local curMonsterTemp = DataCenter.ActivityPartyMonsterTemplateManager:GetTemplate(curMonsterId)
  local nextMonsterTemp = DataCenter.ActivityPartyMonsterTemplateManager:GetTemplate(nextMonsterId)
  self:ClearAllItem()
  local show1TotalWidth = 0
  local show2TotalWidth = 0
  local show3TotalWidth = 0
  self.show1Data = {}
  self.show2Data = {}
  self.show3Data = {}
  local show1Temp = curMonsterTemp.show_reward3
  local show1RewardTip = curMonsterTemp.show_reward3_tip
  for i = 1, #show1Temp do
    show1TotalWidth = show1TotalWidth + show1Temp[i][4]
  end
  for i = 1, #show1Temp do
    local showData = {}
    if show1Temp[i][1] == 1 then
      showData = {
        rewardType = ResTypeToReward[show1Temp[i][2]],
        count = show1Temp[i][3]
      }
    else
      showData = {
        rewardType = show1Temp[i][1],
        itemId = show1Temp[i][2],
        count = show1Temp[i][3]
      }
    end
    local rateNum = show1Temp[i][4] / show1TotalWidth * 100
    showData.rateNum = rateNum
    showData.isTip = show1RewardTip[i] or 0
    table.insert(self.show1Data, showData)
  end
  local show2Temp = curMonsterTemp.show_reward1
  local show2RewardTip = curMonsterTemp.show_reward1_tip
  for i = 1, #show2Temp do
    show2TotalWidth = show2TotalWidth + show2Temp[i][4]
  end
  for i = 1, #show2Temp do
    local showData = {}
    if show2Temp[i][1] == 1 then
      showData = {
        rewardType = ResTypeToReward[show2Temp[i][2]],
        count = show2Temp[i][3]
      }
    else
      showData = {
        rewardType = show2Temp[i][1],
        itemId = show2Temp[i][2],
        count = show2Temp[i][3]
      }
    end
    local rateNum = show2Temp[i][4] / show2TotalWidth * 100
    showData.rateNum = rateNum
    showData.isTip = show2RewardTip[i] or 0
    table.insert(self.show2Data, showData)
  end
  local show3Temp = curMonsterTemp.show_reward2
  local show3RewardTip = curMonsterTemp.show_reward2_tip
  for i = 1, #show3Temp do
    show3TotalWidth = show3TotalWidth + show3Temp[i][4]
  end
  for i = 1, #show3Temp do
    local showData = {}
    if show3Temp[i][1] == 1 then
      showData = {
        rewardType = ResTypeToReward[show3Temp[i][2]],
        count = show3Temp[i][3]
      }
    else
      showData = {
        rewardType = show3Temp[i][1],
        itemId = show3Temp[i][2],
        count = show3Temp[i][3]
      }
    end
    local rateNum = show3Temp[i][4] / show3TotalWidth * 100
    showData.rateNum = rateNum
    showData.isTip = show3RewardTip[i] or 0
    table.insert(self.show3Data, showData)
  end
  for i = 1, #self.show1Data do
    local item = self.reward_rate_item.gameObject:GameObjectSpawn(self.content1.transform)
    item.name = i
    local obj = self.content1:AddComponent(BanquetAttackMonsterRateRewardItem, item.name)
    obj:SetActive(true)
    obj:SetData(self.show1Data[i])
    table.insert(self.rateItemList, obj)
  end
  for i = 1, #self.show2Data do
    local item = self.reward_rate_item.gameObject:GameObjectSpawn(self.content2.transform)
    item.name = i
    local obj = self.content2:AddComponent(BanquetAttackMonsterRateRewardItem, item.name)
    obj:SetActive(true)
    obj:SetData(self.show2Data[i])
    table.insert(self.rateItemList, obj)
  end
  for i = 1, #self.show3Data do
    local item = self.reward_rate_item.gameObject:GameObjectSpawn(self.content3.transform)
    item.name = i
    local obj = self.content3:AddComponent(BanquetAttackMonsterRateRewardItem, item.name)
    obj:SetActive(true)
    obj:SetData(self.show3Data[i])
    table.insert(self.rateItemList, obj)
  end
  self.monster_icon:LoadSprite(string.format(UIAssets.UIActChristmasTreeSpritePath, curMonsterTemp.pic_name))
  self.monster_name:SetLocalText(curMonsterTemp.name)
  self.monster_desc:SetLocalText(curMonsterTemp.desc)
  self.next_monster_icon:LoadSprite(string.format(UIAssets.UIActChristmasTreeSpritePath, nextMonsterTemp.pic_name))
  self.next_monster_name:SetLocalText("activity_newparty_desc3", Localization:GetString(nextMonsterTemp.name))
end

local function ClearAllItem(self)
  self.content1:RemoveComponents(BanquetAttackMonsterRateRewardItem)
  for _, v in ipairs(self.content1.transform) do
    if v ~= nil then
      CS.UnityEngine.GameObject.Destroy(v.gameObject)
    end
  end
  self.content2:RemoveComponents(BanquetAttackMonsterRateRewardItem)
  for _, v in ipairs(self.content2.transform) do
    if v ~= nil then
      CS.UnityEngine.GameObject.Destroy(v.gameObject)
    end
  end
  self.content3:RemoveComponents(BanquetAttackMonsterRateRewardItem)
  for _, v in ipairs(self.content3.transform) do
    if v ~= nil then
      CS.UnityEngine.GameObject.Destroy(v.gameObject)
    end
  end
  self.reward_rate_item.gameObject:GameObjectRecycleAll()
  self.rateItemList = {}
end

BanquetAttackMonsterRateRewardView.OnCreate = OnCreate
BanquetAttackMonsterRateRewardView.OnDestroy = OnDestroy
BanquetAttackMonsterRateRewardView.OnEnable = OnEnable
BanquetAttackMonsterRateRewardView.OnDisable = OnDisable
BanquetAttackMonsterRateRewardView.ComponentDefine = ComponentDefine
BanquetAttackMonsterRateRewardView.ComponentDestroy = ComponentDestroy
BanquetAttackMonsterRateRewardView.OnAddListener = OnAddListener
BanquetAttackMonsterRateRewardView.OnRemoveListener = OnRemoveListener
BanquetAttackMonsterRateRewardView.RefreshView = RefreshView
BanquetAttackMonsterRateRewardView.ClearAllItem = ClearAllItem
return BanquetAttackMonsterRateRewardView
