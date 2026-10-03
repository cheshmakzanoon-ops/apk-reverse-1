local base = UIBaseContainer
local LWUIBerserkBossRewardItemRender = BaseClass("LWUIBerserkBossRewardItemRender", base)
local bg_path = "Bg"
local titleBgIcon_path = "TitleBgIcon"
local titleText_path = "TitleText"
local curMark_path = "CurMark"
local rewardItem_path = "UICommonResItem"
local rewardContent_path = "RewardContent"

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

local function OnDestroy(self)
  self:ClearReward()
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
  self.bg = self:AddComponent(UIImage, bg_path)
  self.titleBgIcon = self:AddComponent(UIImage, titleBgIcon_path)
  self.titleText = self:AddComponent(UIText, titleText_path)
  self.curMark = self:AddComponent(UIBaseContainer, curMark_path)
  self.rewardItem = self:AddComponent(UIBaseContainer, rewardItem_path)
  self.rewardContent = self:AddComponent(UIBaseContainer, rewardContent_path)
  self.rewardObj = self.transform:Find(rewardItem_path).gameObject
  self.rewardObj:GameObjectCreatePool()
end

local function ComponentDestroy(self)
  self.bg = nil
  self.titleBgIcon = nil
  self.titleText = nil
  self.curMark = nil
  self.rewardItem = nil
  self.rewardContent = nil
end

local function DataDefine(self)
end

local function DataDestroy(self)
end

local function InitData(self, rewardData, curTargetId, curHpPercent, totalPercent, quality)
  self.rewardInfo = rewardData
  if self.rewardInfo.id == curTargetId then
    self.bg:LoadSprite(string.format(LoadPath.UILWBerserkBoss, "FX_wordboss_paihangbang_4"))
    self.curMark:SetActive(true)
  else
    self.bg:LoadSprite(string.format(LoadPath.LWCommonPath, "cfm_tongyong_erji_dichen_1"))
    self.curMark:SetActive(false)
  end
  local percentStr = ""
  if curHpPercent <= totalPercent then
    percentStr = "<color=#f97077>" .. string.formatDecimal(curHpPercent, 1) .. "%" .. "</color>"
  else
    percentStr = "<color=#ffffff>" .. string.formatDecimal(curHpPercent, 1) .. "%" .. "</color>"
  end
  local totalPercentStr = string.formatDecimal(totalPercent, 1) .. "%"
  self.titleText:SetLocalText("activity_berserkboss_desc_04", percentStr, totalPercentStr)
  self.titleBgIcon:LoadSprite(string.format(LoadPath.UIActivity, string.format("lyp_huodong_zqzhg_paihangbang_jiangli_%s", quality)))
  self:ShowReward()
end

local function ShowReward(self)
  self:ClearReward()
  local rewardCount = table.count(self.rewardInfo.reward)
  for i = 1, rewardCount do
    local goObj = self.rewardObj:GameObjectSpawn(self.rewardContent.transform)
    goObj.name = "item_" .. i
    goObj:SetActive(true)
    local itemRender = self.rewardContent:AddComponent(UICommonResItem, goObj.name)
    itemRender:SetLocalScaleXYZ(0.95, 0.95, 1)
    itemRender:ReInit(self.rewardInfo.reward[i])
  end
end

local function ClearReward(self)
  self.rewardContent:RemoveComponents(UICommonResItem)
  self.rewardObj:GameObjectRecycleAll()
end

LWUIBerserkBossRewardItemRender.OnCreate = OnCreate
LWUIBerserkBossRewardItemRender.OnDestroy = OnDestroy
LWUIBerserkBossRewardItemRender.OnEnable = OnEnable
LWUIBerserkBossRewardItemRender.OnDisable = OnDisable
LWUIBerserkBossRewardItemRender.ComponentDefine = ComponentDefine
LWUIBerserkBossRewardItemRender.ComponentDestroy = ComponentDestroy
LWUIBerserkBossRewardItemRender.DataDefine = DataDefine
LWUIBerserkBossRewardItemRender.DataDestroy = DataDestroy
LWUIBerserkBossRewardItemRender.InitData = InitData
LWUIBerserkBossRewardItemRender.ShowReward = ShowReward
LWUIBerserkBossRewardItemRender.ClearReward = ClearReward
return LWUIBerserkBossRewardItemRender
