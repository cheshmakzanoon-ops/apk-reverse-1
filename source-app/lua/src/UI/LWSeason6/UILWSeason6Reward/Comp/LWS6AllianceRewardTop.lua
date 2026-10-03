local base = UIBaseContainer
local LWS6AllianceRewardTop = BaseClass("LWS6AllianceRewardTop", base)
local SeasonAllianceRewardTopTier = require("UI.LWSeason.LWSeasonReward.Component.SeasonAllianceRewardTopTier")
local Count = 8
local selectAnimator_path = ""
local tierCom_path = {
  "root/Level1",
  "root/Level1 (1)",
  "root/Level1 (2)",
  "root/Level1 (3)",
  "root/Level1 (4)",
  "root/Level1 (5)",
  "root/Level1 (6)",
  "root/Level1 (7)"
}

function LWS6AllianceRewardTop:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function LWS6AllianceRewardTop:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function LWS6AllianceRewardTop:OnEnable()
  base.OnEnable(self)
  if self.selectAnimator then
    self.selectAnimator:Play("_S3_jiangbei_in3_jiangbei_in")
  end
end

function LWS6AllianceRewardTop:OnDisable()
  base.OnDisable(self)
end

function LWS6AllianceRewardTop:ComponentDefine()
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

function LWS6AllianceRewardTop:ComponentDestroy()
  self.selectAnimator = nil
  self.tierCom = nil
end

function LWS6AllianceRewardTop:DataDefine()
end

function LWS6AllianceRewardTop:DataDestroy()
  self.isInit = nil
  self.click = nil
end

function LWS6AllianceRewardTop:Init(clickCall)
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

function LWS6AllianceRewardTop:RefreshTierBg(i)
  if not self.isInit then
    return
  end
  for index, value in ipairs(self.tierCom) do
    value:RefreshTierBg(i)
  end
end

function LWS6AllianceRewardTop:SelectTitle(i)
  if not self.isInit then
    return
  end
  for index, value in ipairs(self.tierCom) do
    value:SelectTitle(i)
  end
end

function LWS6AllianceRewardTop:RefreshBtnRed(rewardTier, flag)
  for index, value in ipairs(self.tierCom) do
    value:RefreshBtnRed(rewardTier, flag)
  end
end

return LWS6AllianceRewardTop
