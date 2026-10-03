local base = UIBaseView
local FarmerRewardCompareView = BaseClass("FarmerRewardCompareView", base)
local UICommonTipsView = require("UI.UICommonTips.View.UICommonTipsView")
local Localization = CS.GameEntry.Localization
local reward_image_path_s1 = "Assets/Main/Sprites/UI/UISeason/UISeason1/UISeasonReward/ljq_s1_jiangli_jiangbei_0%s.png"
local reward_image_path_s2 = "Assets/Main/Sprites/UI/UISeasonReward/trophy/ljq_sj2_jiangli_jiangbei_0%s.png"
local reward_image_path_s3 = "Assets/Main/SeasonRes/S3/Sprites/UI/SeasonRewardTrophy/ljq_s3_jiangli_jiangbei_0%s.png"
local reward_image_path_s4 = "Assets/Main/SeasonRes/S4/Sprites/UI/SeasonRewardTrophy/ljq_s4_jiangli_jiangbei_0%s.png"
local CommonSelectCom = require("UI.LWSeason.LWSeasonRank.Component.CommonSelectCom")
local rewardTierSelect_path = "bg_2/CommonSelectCom"
local clostBtn_path = "bg/bg_top/btnClose"
local mask_path = "black"
local itemPrefab_path = "bg_2/normalReward/AllianceRewardItem/bg/UICommonResItem"
local normalRewardParent_path = "bg_2/normalReward/AllianceRewardItem/bg/rewardScroll/Viewport/Content"
local normalTierIcon_path = "bg_2/normalReward/bg/rewardTierIcon"
local normalIntroBtn_path = "bg_2/normalReward/normalIntroBtn"
local rewardIndexSelect_path = "bg_2/CommonSelectComIndex"
local farmerRewardParent_path = "bg_2/farmerReward/AllianceRewardItem/bg/rewardScroll/Viewport/farmerContent"
local farmerIntroBtn_path = "bg_2/farmerReward/farmerIntroBtn"
local farmerRewardPrefab_path = "bg_2/farmerReward/UICommonResItem1"

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:InitRewardData()
  self:RefreshFarmerReward()
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
  self.rewardTierSelect = self:AddComponent(CommonSelectCom, rewardTierSelect_path)
  self.clostBtn = self:AddComponent(UIButton, clostBtn_path)
  self.mask = self:AddComponent(UIButton, mask_path)
  self.itemPrefab = self:AddComponent(UIBaseContainer, itemPrefab_path)
  self.normalRewardParent = self:AddComponent(UIBaseContainer, normalRewardParent_path)
  self.normalTierIcon = self:AddComponent(UIImage, normalTierIcon_path)
  self.normalIntroBtn = self:AddComponent(UIButton, normalIntroBtn_path)
  self.rewardIndexSelect = self:AddComponent(CommonSelectCom, rewardIndexSelect_path)
  self.farmerRewardParent = self:AddComponent(UIBaseContainer, farmerRewardParent_path)
  self.farmerIntroBtn = self:AddComponent(UIButton, farmerIntroBtn_path)
  self.farmerRewardPrefab = self:AddComponent(UIBaseContainer, farmerRewardPrefab_path)
  self.commonResItem = self.transform:Find(itemPrefab_path).gameObject
  self.commonResItem:GameObjectCreatePool()
  self.farmerReardItem = self.transform:Find(farmerRewardPrefab_path).gameObject
  self.farmerReardItem:GameObjectCreatePool()
  self.clostBtn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.mask:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.normalIntroBtn:SetOnClick(function()
    self:OnNormalIntroBtnClick()
  end)
  self.farmerIntroBtn:SetOnClick(function()
    self:OnFarmerIntroBtnClick()
  end)
end

local function ComponentDestroy(self)
  if self.commonResItem then
    self.commonResItem:GameObjectRecycleAll()
  end
  self.commonResItem = nil
  if self.farmerReardItem then
    self.farmerReardItem:GameObjectRecycleAll()
  end
  self.farmerReardItem = nil
  self.normalRewardParent:RemoveComponents(UICommonResItem)
  self.rewardTierSelect = nil
  self.clostBtn = nil
  self.mask = nil
  self.itemPrefab = nil
  self.normalRewardParent = nil
  self.normalTierIcon = nil
  self.normalIntroBtn = nil
  self.rewardIndexSelect = nil
  self.farmerRewardParent = nil
  self.farmerIntroBtn = nil
  self.farmerRewardPrefab = nil
end

local function DataDefine(self)
end

local function DataDestroy(self)
end

function FarmerRewardCompareView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.LWSeasonAllianceRewardInfoUpdate, self.InitRewardData)
end

function FarmerRewardCompareView:OnRemoveListener()
  self:RemoveUIListener(EventId.LWSeasonAllianceRewardInfoUpdate, self.InitRewardData)
  base.OnRemoveListener(self)
end

function FarmerRewardCompareView:InitRewardData()
  self.curTier = 1
  self.curRewardIndex = 1
  local count = DataCenter.SeasonRewardDataManager:GetAllianceRewardTierCount()
  if 0 < count then
    self.rewardTierSelect:SetActive(true)
    self.rewardIndexSelect:SetActive(true)
    local tierDate = DataCenter.SeasonRewardDataManager:GetAllianceRewardTierData()
    local theData = {}
    theData.isTop = false
    theData.itemList = {}
    for i, v in ipairs(tierDate) do
      table.insert(theData.itemList, {type = i, des = v})
    end
    self.rewardTierSelect:Init(theData, function(d, i)
      local result = self:SelectTierChange(d, i)
      return result
    end)
    local curTierData = DataCenter.SeasonRewardDataManager:GenerateAllianceRewardTier()
    if curTierData == 0 then
      curTierData = 4
    end
    self.curTier = nil
    self.rewardTierSelect:SetIndex(curTierData)
    self:SelectTierChange(nil, curTierData)
  else
    self.rewardTierSelect:SetActive(false)
    self.rewardIndexSelect:SetActive(false)
    DataCenter.SeasonRewardDataManager:CheckAllianceRewardData()
  end
end

function FarmerRewardCompareView:SelectTierChange(itemData, index)
  if self.curTier == index then
    return true
  end
  self.curTier = index
  self.curRewardIndex = 4
  local imagePathPrefix = reward_image_path_s2
  local severInfo = DataCenter.SeasonDataManager:GetUserSeasonInfo()
  local configId = severInfo.seasonConfigId
  if severInfo:InPreviewMode() then
    configId = severInfo.nextSeasonConfigId
  end
  local seasonConfig = LocalController:instance():getLine(TableName.LW_Season, configId)
  if seasonConfig and seasonConfig.type == SeasonMapType.CityStronghold then
    imagePathPrefix = reward_image_path_s1
  end
  if seasonConfig and seasonConfig.type == SeasonMapType.Mummy then
    imagePathPrefix = reward_image_path_s3
  end
  if seasonConfig and seasonConfig.type == SeasonMapType.Darkness then
    imagePathPrefix = reward_image_path_s4
  end
  local iconPath = string.format(imagePathPrefix, self.curTier)
  self.normalTierIcon:LoadSprite(iconPath)
  local rewardInfo = DataCenter.SeasonRewardDataManager:GetAllianceRewardData(self.curTier)
  local theData = {}
  theData.itemList = {}
  for i, v in ipairs(rewardInfo) do
    table.insert(theData.itemList, {
      type = i,
      des = v.tittle
    })
  end
  theData.isTop = false
  self.rewardIndexSelect:Init(theData, function(d, i)
    local result = self:SelectRewardIndexChange(d, i)
    return result
  end)
  self.rewardIndexSelect:SetIndex(self.curRewardIndex)
  self:RefreshNormalReward()
  return true
end

function FarmerRewardCompareView:SelectRewardIndexChange(itemData, index)
  if self.curRewardIndex == index then
    return true
  end
  self.curRewardIndex = index
  self:RefreshNormalReward()
  return true
end

function FarmerRewardCompareView:RefreshNormalReward()
  self.commonResItem:GameObjectRecycleAll()
  self.normalRewardParent:RemoveComponents(UICommonResItem)
  self.curReward = DataCenter.SeasonRewardDataManager:GetAllianceRewardData(self.curTier)
  if self.curReward == nil or #self.curReward == 0 then
    DataCenter.SeasonRewardDataManager:CheckAllianceRewardData()
    return
  end
  local reward = self.curReward[self.curRewardIndex].reward
  self.normalRewardParent:SetAnchoredPositionXY(0, 0)
  if reward then
    for index, value in ipairs(reward) do
      local go = self.commonResItem:GameObjectSpawn(self.normalRewardParent.transform)
      go.gameObject:SetActive(true)
      go.transform:Set_localScale(0.86, 0.86, 0.86)
      go.name = "item" .. tostring(index)
      local cell = self.normalRewardParent:AddComponent(UICommonResItem, go.name)
      cell:ReInit(value)
    end
  end
end

function FarmerRewardCompareView:RefreshFarmerReward()
  local rewardShow = DataCenter.SeasonFarmerTemplateManager:GetMainCfg().reward_show
  local reward = DataCenter.RewardManager:ParseRewardsStr(rewardShow)
  self.farmerReardItem:GameObjectRecycleAll()
  self.farmerRewardParent:RemoveComponents(UICommonResItem)
  self.farmerRewardParent:SetAnchoredPositionXY(0, 0)
  if reward then
    for index, value in ipairs(reward) do
      local go = self.farmerReardItem:GameObjectSpawn(self.farmerRewardParent.transform)
      go.gameObject:SetActive(true)
      go.transform:Set_localScale(0.86, 0.86, 0.86)
      go.name = "item" .. tostring(index)
      local cell = self.farmerRewardParent:AddComponent(UICommonResItem, go.name)
      cell:ReInit(value)
    end
  end
end

function FarmerRewardCompareView:OnNormalIntroBtnClick()
  local param = UICommonTipsView.ParamDataClass.New()
  param.content = Localization:GetString("season_builders_alliance_tips_37")
  param.position = self.normalIntroBtn:GetPosition()
  param.deltaY = -20
  param.contentX = -20
  UIManager:GetInstance():OpenWindow(UIWindowNames.UICommonTips, {anim = false}, param)
end

function FarmerRewardCompareView:OnFarmerIntroBtnClick()
  local param = UICommonTipsView.ParamDataClass.New()
  param.content = Localization:GetString("season_builders_alliance_tips_38")
  param.position = self.farmerIntroBtn:GetPosition()
  param.deltaY = -20
  param.contentX = -20
  UIManager:GetInstance():OpenWindow(UIWindowNames.UICommonTips, {anim = false}, param)
end

FarmerRewardCompareView.OnCreate = OnCreate
FarmerRewardCompareView.OnDestroy = OnDestroy
FarmerRewardCompareView.OnEnable = OnEnable
FarmerRewardCompareView.OnDisable = OnDisable
FarmerRewardCompareView.ComponentDefine = ComponentDefine
FarmerRewardCompareView.ComponentDestroy = ComponentDestroy
FarmerRewardCompareView.DataDefine = DataDefine
FarmerRewardCompareView.DataDestroy = DataDestroy
return FarmerRewardCompareView
