local UIChampionDuelStateInfo = BaseClass("UIChampionDuelStateInfo", UIBaseContainer)
local base = UIBaseContainer
local UIChampionDuelStateDi = require("UI.UIChampionDuel.Component.UIChampionDuelStateDi")
local btn_info_path = "BtnInfo"
local text_state_path = "LeftDi/StateText"
local state_di_path = "MidDi/StateDi"

function UIChampionDuelStateInfo:OnCreate()
  base.OnCreate(self)
  self.btn_info = self:AddComponent(UIButton, btn_info_path)
  self.btn_info:SetOnClick(BindCallback(self, self.OnBtnInfoClick))
  self.text_state = self:AddComponent(UIText, text_state_path)
  self.text_state:SetLocalText("champion_duel_tips1009")
  self.stateDis = {}
  for i = 1, 9 do
    local comp = self:AddComponent(UIChampionDuelStateDi, state_di_path .. i)
    self.stateDis[i] = comp
  end
end

function UIChampionDuelStateInfo:OnDestroy()
  self.btn_info = nil
  self.text_state = nil
  self.stateDis = {}
  base.OnDestroy(self)
end

function UIChampionDuelStateInfo:OnBtnInfoClick()
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIChampionDuelDetail)
end

function UIChampionDuelStateInfo:ReInit()
  for i, v in ipairs(self.stateDis) do
    v:ReInit(i)
  end
end

return UIChampionDuelStateInfo
