local BanquetAttackNormalLogCard = BaseClass("BanquetAttackNormalLogCard", UIBaseContainer)
local BanquetAttackLogReward = require("UI.UIActBanquetAttackMonsterHistory.Component.BanquetAttackLogReward")
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local u_i_common_res_item_path = "RewardItem"
local reward_content_path = "RewardArea/Scroll View/Viewport/RewardContent"
local time_text_path = "TimeText"
local desc_text_path = "DescText"
local boss_b_g_path = "BossBG"

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
  self.commonResItem = self:AddComponent(UIBaseContainer, u_i_common_res_item_path)
  self.commonResItem.gameObject:GameObjectCreatePool()
  self.rewardContent = self:AddComponent(UIBaseContainer, reward_content_path)
  self.timeText = self:AddComponent(UIText, time_text_path)
  self.descText = self:AddComponent(UIText, desc_text_path)
  self.bossBg = self:AddComponent(UIImage, boss_b_g_path)
  if CommonUtil.IsArabic() and CommonUtil.ArabicAutoMirrorFactor() == -1 then
    self.bossBg:SetLocalScaleXYZ(-1, 1, 1)
  else
    self.bossBg:SetLocalScaleXYZ(1, 1, 1)
  end
end

local function ComponentDestroy(self)
  self.rewardContent:RemoveAllComponentes(BanquetAttackLogReward)
  self.commonResItem.gameObject:GameObjectRecycleAll()
  self.rewardContent = nil
  self.bossBg = nil
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

function BanquetAttackNormalLogCard:SetData(data)
  self.data = data
  self.timeStamp = data.createTime
  self.type = data.type
  self.confId = data.cfgId
  self:RefreshBaseInfo()
  self:RefreshReward()
end

function BanquetAttackNormalLogCard:RefreshBaseInfo()
  self.timeText:SetText(UITimeManager:GetInstance():TimeStampToTimeForServer(self.timeStamp * 1000))
  local curMonsterTemp = DataCenter.ActivityPartyMonsterTemplateManager:GetTemplate(self.confId)
  local tips = self:GetTips(self.confId, self.type)
  self.descText:SetLocalText(tips, Localization:GetString(curMonsterTemp.name))
end

function BanquetAttackNormalLogCard:GetTips(id, type)
  local curMonsterTemp = DataCenter.ActivityPartyMonsterTemplateManager:GetTemplate(id)
  if curMonsterTemp then
    local recordTips = curMonsterTemp.record_tips
    local index = 0
    for k, v in pairs(curMonsterTemp.record_config) do
      if type == v then
        index = k
        break
      end
    end
    local str = ""
    if 0 < index then
      str = recordTips[index]
    else
      str = recordTips[1]
    end
    return str
  end
end

function BanquetAttackNormalLogCard:RefreshReward()
  self.rewardContent:RemoveAllComponentes(BanquetAttackLogReward)
  self.commonResItem.gameObject:GameObjectRecycleAll()
  if not self.data or not self.data.reward then
    return
  end
  for _, v in ipairs(self.data.reward) do
    local obj = self.commonResItem.gameObject:GameObjectSpawn(self.rewardContent.transform)
    local name = tostring(NameCount)
    obj.name = name
    NameCount = NameCount + 1
    local rewardItem = self.rewardContent:AddComponent(BanquetAttackLogReward, name)
    rewardItem:ParseInfo(v)
  end
end

BanquetAttackNormalLogCard.OnCreate = OnCreate
BanquetAttackNormalLogCard.OnDestroy = OnDestroy
BanquetAttackNormalLogCard.OnEnable = OnEnable
BanquetAttackNormalLogCard.OnDisable = OnDisable
BanquetAttackNormalLogCard.ComponentDefine = ComponentDefine
BanquetAttackNormalLogCard.ComponentDestroy = ComponentDestroy
BanquetAttackNormalLogCard.DataDefine = DataDefine
BanquetAttackNormalLogCard.DataDestroy = DataDestroy
BanquetAttackNormalLogCard.OnAddListener = OnAddListener
BanquetAttackNormalLogCard.OnRemoveListener = OnRemoveListener
return BanquetAttackNormalLogCard
