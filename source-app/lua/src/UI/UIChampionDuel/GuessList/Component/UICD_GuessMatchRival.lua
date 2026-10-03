local UICD_GuessMatchRival = BaseClass("UICD_GuessMatchRival", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local UICD_GuessPlayer = require("UI.UIChampionDuel.GuessList.Component.UICD_GuessPlayer")
local root_path = "root"
local text_time_path = "root/TimeText"
local left_path = "root/Left"
local right_path = "root/Right"
local vs_path = "root/ImgVs"
local eff_path = "root/Eff"
local text_point_path = "root/PointText"

function UICD_GuessMatchRival:OnCreate()
  base.OnCreate(self)
  self.root = self:AddComponent(UIBaseContainer, root_path)
  self.text_time = self:AddComponent(UIText, text_time_path)
  self.left = self:AddComponent(UICD_GuessPlayer, left_path)
  self.right = self:AddComponent(UICD_GuessPlayer, right_path)
  self.eff = self:AddComponent(UIText, eff_path)
  self.vs = self:AddComponent(UIText, vs_path)
  self.text_point = self:AddComponent(UIText, text_point_path)
end

function UICD_GuessMatchRival:OnDestroy()
  self.root = nil
  self.text_time = nil
  self.left = nil
  self.right = nil
  self.eff = nil
  self.vs = nil
  self.text_point = nil
  base.OnDestroy(self)
end

function UICD_GuessMatchRival:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.ChampionDuelBetInfoRefresh, self.UpdateData)
end

function UICD_GuessMatchRival:OnRemoveListener()
  self:RemoveUIListener(EventId.ChampionDuelBetInfoRefresh, self.UpdateData)
  base.OnRemoveListener(self)
end

function UICD_GuessMatchRival:UpdateVS()
  local showVS = true
  if self.curTab == 1 then
    local curTime = UITimeManager:GetInstance():GetServerTime()
    local betMatchBattleTime = self.betMatchBattleTime or 0
    local remainTime = betMatchBattleTime - curTime / 1000
    local scoreFlag = self.myPoint == 0 and self.otherPoint == 0
    showVS = scoreFlag and 0 < remainTime
  end
  self.eff:SetActive(not showVS)
  self.vs:SetActive(showVS)
end

function UICD_GuessMatchRival:UpdateData(betMatchId)
  if betMatchId == nil or betMatchId ~= self.betMatchId then
    return
  end
  local guessList = DataCenter.ChampionDuelManager:GetGuessList(self.curTab)
  for _, v in ipairs(guessList) do
    if v.betMatchId == self.betMatchId then
      self:ReInit(v, self.curTab)
      break
    end
  end
end

function UICD_GuessMatchRival:ReInit(matchRival, curTab)
  self.curTab = curTab
  self.betMatchBattleTime = matchRival.betMatchBattleTime
  self.betMatchId = matchRival.betMatchId
  local stageText = Localization:GetString(DataCenter.ChampionDuelManager:GetStageStrKey(matchRival.stageId)) or ""
  local date = UITimeManager:GetInstance():TimeSecToServerDate(matchRival.betMatchBattleTime)
  self.text_time:SetText(string.format("%s %d-%d-%d %02d:%02d:%02d", stageText, date.year, date.month, date.day, date.hour, date.min, date.sec))
  self.left:ReInit(matchRival, self.curTab, true, BindCallback(self, self.UpdateVS))
  self.right:ReInit(matchRival, self.curTab, false, BindCallback(self, self.UpdateVS))
  local scoreL = matchRival.betMatchRivalA ~= nil and matchRival.betMatchRivalA.point or 0
  self.myPoint = scoreL
  local scoreR = matchRival.betMatchRivalB ~= nil and matchRival.betMatchRivalB.point or 0
  self.otherPoint = scoreR
  self.text_point:SetText(CommonUtil.IsArabicAutoMirrorOpen() and scoreR .. ":" .. scoreL or scoreL .. ":" .. scoreR)
  self:UpdateVS()
end

return UICD_GuessMatchRival
