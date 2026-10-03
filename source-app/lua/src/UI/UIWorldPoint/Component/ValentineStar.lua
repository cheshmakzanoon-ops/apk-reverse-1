local ValentineStar = BaseClass("ValentineStar", UIAsyncContainer)
local base = UIAsyncContainer
local Localization = CS.GameEntry.Localization
local M = ValentineStar
local StarInfoItem = require("UI.UIActivityCenterTable.Component.UIActValentine.Component.ValentineStarItemComponent")
local level_text_path = "LevelText"
local valentine_star_item_path = "ValentineStarItem"

function M:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
end

function M:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function M:ComponentDefine()
  self.levelText = self:AddComponent(UITextMeshProUGUIEx, level_text_path)
  self.starItem = self:AddComponent(StarInfoItem, valentine_star_item_path)
end

function M:ComponentDestroy()
  self.levelText = nil
  self.starItem = nil
end

function M:OnAddListener()
  base.OnAddListener(self)
end

function M:OnRemoveListener()
  base.OnRemoveListener(self)
end

function M:Refresh(exp, rankId, activityId)
  self.exp = exp
  self.rankId = rankId
  self.activityId = activityId
  if not (self.exp and self.activityId) or not self.rankId then
    self:SetActive(false)
    return
  end
  self.activityInfo = DataCenter.ActivityListDataManager:GetActivityDataById(self.activityId)
  if self.activityInfo then
    self.actEndTime = self.activityInfo.endTime
  end
  local rankData = DataCenter.ValentineDataManager:GetRankDataById(self.rankId)
  if not (rankData and rankData.key_big and rankData.type) or not rankData.star then
    self:SetActive(false)
    return
  end
  self.levelText:SetLocalText(rankData.key_big)
  self.starItem:RefreshByActivityAndRankData(self.activityId, self.exp)
end

function M:Update1000MS()
  if not self.actEndTime then
    return
  end
  local curTime = UITimeManager:GetInstance():GetServerTime()
  if curTime >= self.actEndTime + 1000 then
    self:SetActive(false)
  end
end

return ValentineStar
