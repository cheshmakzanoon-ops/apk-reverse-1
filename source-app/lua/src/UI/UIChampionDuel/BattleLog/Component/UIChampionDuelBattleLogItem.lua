local UIChampionDuelBattleLogItem = BaseClass("UIChampionDuelBattleLogItem", UIBaseContainer)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local UIChampionDuelBattleLogPlayer = require("UI.UIChampionDuel.BattleLog.Component.UIChampionDuelBattleLogPlayer")
local root_path = "root"
local text_time_path = "root/TimeText"
local btn_info_path = "root/InfoBtn"
local left_path = "root/Left"
local right_path = "root/Right"

function UIChampionDuelBattleLogItem:OnCreate()
  base.OnCreate(self)
  self.logData = nil
  self.root = self:AddComponent(UIBaseContainer, root_path)
  self.text_time = self:AddComponent(UIText, text_time_path)
  self.btn_info = self:AddComponent(UIButton, btn_info_path)
  self.btn_info:SetOnClick(BindCallback(self, self.OnInfoClick))
  self.left = self:AddComponent(UIChampionDuelBattleLogPlayer, left_path)
  self.right = self:AddComponent(UIChampionDuelBattleLogPlayer, right_path)
end

function UIChampionDuelBattleLogItem:OnDestroy()
  self.root = nil
  self.text_time = nil
  self.btn_info = nil
  self.left = nil
  self.right = nil
  self.logData = nil
  base.OnDestroy(self)
end

function UIChampionDuelBattleLogItem:OnInfoClick()
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIChampionDuelBattleLogDetail, {anim = false}, self.logData.uuid)
end

function UIChampionDuelBattleLogItem:ReInit(logData, targetUid)
  local x, y = self.root.rectTransform:Get_sizeDelta()
  self.rectTransform:Set_sizeDelta(x, y)
  local minH = 60
  self.left.rectTransform:Set_sizeDelta(x / 2, y - minH)
  self.left.rectTransform:Set_anchoredPosition(0, -minH / 2)
  self.right.rectTransform:Set_sizeDelta(x / 2, y - minH)
  self.right.rectTransform:Set_anchoredPosition(0, -minH / 2)
  self.logData = logData
  local stageText = Localization:GetString(DataCenter.ChampionDuelManager:GetStageStrKey(logData.stageId)) or ""
  local date = UITimeManager:GetInstance():TimeSecToServerDate(logData.time)
  self.text_time:SetText(string.format("%s %d-%d-%d %02d:%02d:%02d", stageText, date.year, date.month, date.day, date.hour, date.min, date.sec))
  local myUid = logData.my ~= nil and logData.my.uid or nil
  local bSelf = logData.attacker == myUid
  local bWin = logData.isWin
  if not bSelf then
    bWin = not logData.isWin
  end
  local leftInfo = bSelf and logData.my or logData.target
  local rightInfo = bSelf and logData.target or logData.my
  self.left:ReInit(leftInfo, bWin, logData.stageId, targetUid)
  self.right:ReInit(rightInfo, not bWin, logData.stageId, targetUid)
end

return UIChampionDuelBattleLogItem
