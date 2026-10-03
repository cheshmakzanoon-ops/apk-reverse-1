local UICD_ScheduleGuessStart = BaseClass("UICD_ScheduleGuessStart", UIBaseContainer)
local base = UIBaseContainer
local UIChampionDuelLimitDi = require("UI.UIChampionDuel.Component.UIChampionDuelLimitDi")
local UIChampionDuelTime = require("UI.UIChampionDuel.Component.UIChampionDuelTime")
local time_path = "Time"
local text_mid_path = "Mid/MidText"
local limit_di_path = "Limit/LimitDi"
local btn_guess_path = "GuessBtn"
local text_guess_path = "GuessBtn/TextGuessBtn"

function UICD_ScheduleGuessStart:OnCreate()
  base.OnCreate(self)
  self.btn_guess = self:AddComponent(UIButton, btn_guess_path)
  self.btn_guess:SetOnClick(BindCallback(self, self.OnGuessClick))
  self.text_guest = self:AddComponent(UIText, text_guess_path)
  self.text_guest:SetLocalText("champion_duel_tips1103")
  self.time_group = self:AddComponent(UIChampionDuelTime, time_path)
  self.text_mid = self:AddComponent(UIText, text_mid_path)
  self.text_mid:SetLocalText("champion_duel_tips1098")
  self.limitDis = {}
  for i = 1, 3 do
    local comp = self:AddComponent(UIChampionDuelLimitDi, limit_di_path .. i)
    comp:ReInit(i + 3)
    self.limitDis[i] = comp
  end
end

function UICD_ScheduleGuessStart:OnDestroy()
  self.time_group = nil
  self.limitDis = nil
  base.OnDestroy(self)
end

function UICD_ScheduleGuessStart:OnGuessClick()
  EventManager:GetInstance():Broadcast(EventId.ChampionDuelMainTabSel, 2)
end

function UICD_ScheduleGuessStart:ReInit()
  self.time_group:ReInit()
end

return UICD_ScheduleGuessStart
