local UIDesertBattleHistoryItem = BaseClass("UIDesertBattleHistoryItem", UIBaseContainer)
local base = UIBaseContainer
local HistoryItemSide = require("UI.UIActivityCenterTable.Component.DesertBattle.BattleHistory.Component.UIDesertBattleHistoryItemSide")
local Localization = CS.GameEntry.Localization

function UIDesertBattleHistoryItem:OnCreate()
  base.OnCreate(self)
  self.title_text = self:AddComponent(UIText, "titleText")
  self.user_self = self:AddComponent(HistoryItemSide, "UserSelf")
  self.user_other = self:AddComponent(HistoryItemSide, "UserOther")
end

function UIDesertBattleHistoryItem:OnDestroy()
  self.title_text = nil
  self.user_self = nil
  self.user_other = nil
  base.OnDestroy(self)
end

function UIDesertBattleHistoryItem:ReInit(index, data)
  self.title_text:SetText(Localization:GetString("800811") .. UITimeManager:GetInstance():TimeStampToTimeForServer(data.battleTime))
  self.user_self:ReInit(data, true)
  self.user_other:ReInit(data, false)
end

return UIDesertBattleHistoryItem
