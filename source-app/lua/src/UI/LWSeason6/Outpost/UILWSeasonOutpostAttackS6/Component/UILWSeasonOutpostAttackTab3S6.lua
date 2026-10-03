local UILWSeasonOutpostAttackTab3S6 = BaseClass("UILWSeasonOutpostAttackTab3S6", UIAsyncContainer)
local base = UIAsyncContainer
local FetchHeroEventCfgInfo = require("Net.Msgs.FetchHeroEventCfgInfoMessage")
local PlayerReward = require("UI.LWSeason6.Outpost.UILWSeasonOutpostAttackS6.Component.UILWSeasonOutpostAttackS6PlayerReward")

function UILWSeasonOutpostAttackTab3S6:OnCreate()
  base.OnCreate(self)
  local offsetMin = self.rectTransform.offsetMin
  local offsetMax = self.rectTransform.offsetMax
  self.rectTransform:Set_offsetMin(offsetMin.x, 0)
  self.rectTransform:Set_offsetMax(offsetMax.x, 0)
  self:ComponentDefine()
end

function UILWSeasonOutpostAttackTab3S6:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UILWSeasonOutpostAttackTab3S6:ComponentDefine()
  self.scroll_view = self:AddComponent(PlayerReward, "ScrollView")
end

function UILWSeasonOutpostAttackTab3S6:ComponentDestroy()
  self.scroll_view = nil
end

function UILWSeasonOutpostAttackTab3S6:ReInit(debugMode, attackActData, battleInfo, battleStartTime, battleEndTime)
  self.debugMode = debugMode
  self.attackActData = attackActData
  self.battleStartTime = battleStartTime
  self.battleEndTime = battleEndTime
  if self.scroll_view ~= nil then
    self.scroll_view:SetVerticalNormalizedPosition(1)
  end
  if self.debugMode and (battleInfo == nil or battleInfo.stage == nil) then
    local data = FetchHeroEventCfgInfo.GetCfgInfo(400001, false, false)
    if data then
      battleInfo = {
        user = {
          scoreIds = data.scoreIds,
          score = 1234,
          scoreRewardIndex = {},
          scoreBox = data.scoreBox
        }
      }
    else
      return
    end
  end
  self.battleInfo = battleInfo
  self:UpdateData()
end

function UILWSeasonOutpostAttackTab3S6:UpdateData()
  if self.scroll_view == nil or self.battleInfo == nil or not self:AsyncLoadDone() then
    return
  end
  self.scroll_view:ReInit(self, self.battleInfo, self.battleStartTime)
end

return UILWSeasonOutpostAttackTab3S6
