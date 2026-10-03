local base = UIBaseContainer
local SeasonAllianceRewardTop = BaseClass("SeasonAllianceRewardTop", base)
local SeasonAllianceRewardTopTier = require("UI.LWSeason.LWSeasonReward.Component.SeasonAllianceRewardTopTier")
local Count = 8
local selectAnimator_path = ""
local tierCom_path = {
  "Level1",
  "Level1 (1)",
  "Level1 (2)",
  "Level1 (3)",
  "Level1 (4)",
  "Level1 (5)",
  "Level1 (6)",
  "Level1 (7)"
}

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
  if self.selectAnimator then
    self.selectAnimator:Play("_S3_jiangbei_in3_jiangbei_in")
  end
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function ComponentDefine(self)
  self.selectAnimator = self:AddComponent(UIAnimator, selectAnimator_path)
  self.tierCom = {
    self:AddComponent(SeasonAllianceRewardTopTier, tierCom_path[1]),
    self:AddComponent(SeasonAllianceRewardTopTier, tierCom_path[2]),
    self:AddComponent(SeasonAllianceRewardTopTier, tierCom_path[3]),
    self:AddComponent(SeasonAllianceRewardTopTier, tierCom_path[4]),
    self:AddComponent(SeasonAllianceRewardTopTier, tierCom_path[5]),
    self:AddComponent(SeasonAllianceRewardTopTier, tierCom_path[6]),
    self:AddComponent(SeasonAllianceRewardTopTier, tierCom_path[7]),
    self:AddComponent(SeasonAllianceRewardTopTier, tierCom_path[8])
  }
end

local function ComponentDestroy(self)
  self.selectAnimator = nil
  self.tierCom = nil
end

local function DataDefine(self)
end

local function DataDestroy(self)
  self.isInit = nil
  self.click = nil
end

function SeasonAllianceRewardTop:Init(clickCall)
  if not self.isInit then
    self.isInit = true
    self.click = clickCall
    for index, value in ipairs(self.tierCom) do
      value:Init(index, function(i)
        if self.click then
          self.click(i)
          if self.selectAnimator then
            self.selectAnimator:Play("Eff_SeasonAllianceRewardLight_in")
          end
        end
      end)
    end
  end
end

function SeasonAllianceRewardTop:RefreshTierBg(i)
  if not self.isInit then
    return
  end
  for index, value in ipairs(self.tierCom) do
    value:RefreshTierBg(i)
  end
end

function SeasonAllianceRewardTop:SelectTitle(i)
  if not self.isInit then
    return
  end
  for index, value in ipairs(self.tierCom) do
    value:SelectTitle(i)
  end
end

function SeasonAllianceRewardTop:RefreshBtnRed(rewardTier, flag)
  for index, value in ipairs(self.tierCom) do
    value:RefreshBtnRed(rewardTier, flag)
  end
end

SeasonAllianceRewardTop.OnCreate = OnCreate
SeasonAllianceRewardTop.OnDestroy = OnDestroy
SeasonAllianceRewardTop.OnEnable = OnEnable
SeasonAllianceRewardTop.OnDisable = OnDisable
SeasonAllianceRewardTop.ComponentDefine = ComponentDefine
SeasonAllianceRewardTop.ComponentDestroy = ComponentDestroy
SeasonAllianceRewardTop.DataDefine = DataDefine
SeasonAllianceRewardTop.DataDestroy = DataDestroy
return SeasonAllianceRewardTop
