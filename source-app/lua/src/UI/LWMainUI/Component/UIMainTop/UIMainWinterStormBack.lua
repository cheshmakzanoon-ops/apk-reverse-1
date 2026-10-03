local UIMainWinterStormBack = BaseClass("UIMainWinterStormBack", UIBaseContainer)
local base = UIBaseContainer
local bg_path = "bg"
local go_btn_path = "bg/GoBtn"
local text_go_btn_path = "bg/GoBtn/GoBtnText"
local tip_text_path = "bg/TipText"
local time_text_path = "bg/TimeText"
local small_btn_path = "bg/SmallBtn"

function UIMainWinterStormBack:OnCreate()
  base.OnCreate(self)
  self.bg = self:AddComponent(UIBaseComponent, bg_path)
  self.tip_text = self:AddComponent(UIText, tip_text_path)
  self.tip_text:SetLocalText("winter_battlefield_interface_tips1037")
  self.time_text = self:AddComponent(UIText, time_text_path)
  self.text_go_btn = self:AddComponent(UIText, text_go_btn_path)
  self.text_go_btn:SetLocalText("winter_battlefield_interface_tips1038")
  self.Btn = self:AddComponent(UIButton, go_btn_path)
  self.Btn:SetOnClick(function()
    DataCenter.ActWinterStormManager:TryEnterBattlefield()
  end)
  self.SmallBtn = self:AddComponent(UIButton, small_btn_path)
  self.SmallBtn:SetOnClick(function()
    self.bSmall = true
    self.bg:SetActive(false)
    EventManager:GetInstance():Broadcast(EventId.ShowCrossServerTip)
  end)
  self.bSmall = false
  self.bg:SetActive(true)
end

function UIMainWinterStormBack:OnDestroy()
  self.tip_text = nil
  self.time_text = nil
  self.text_go_btn = nil
  self.Btn = nil
end

function UIMainWinterStormBack:OnEnable()
  base.OnEnable(self)
end

function UIMainWinterStormBack:OnDisable()
  base.OnDisable(self)
end

function UIMainWinterStormBack:Refresh()
  local remainTime = self:GetRemainTime()
  self:SetActive(0 < remainTime)
end

function UIMainWinterStormBack:Update1000MS()
  if not self:GetActive() then
    return
  end
  local remainTime = self:GetRemainTime()
  if remainTime <= 0 or BattleFieldUtil.InBattleField(BattleFieldType.WinterStorm) then
    self:SetActive(false)
  end
end

function UIMainWinterStormBack:GetRemainTime()
  local remainTime = DataCenter.ActWinterStormManager:GetInBattleWorldLeftTime()
  if 0 < remainTime then
    self.time_text:SetText(UITimeManager:GetInstance():SecondToFmtStringWithoutDay(remainTime))
  end
  return remainTime
end

function UIMainWinterStormBack:IsSmallShow()
  local flag = self:GetActive() and self.bSmall
  return flag
end

function UIMainWinterStormBack:SetMaxShow()
  self.bSmall = false
  self.bg:SetActive(true)
  EventManager:GetInstance():Broadcast(EventId.ShowCrossServerTip)
end

return UIMainWinterStormBack
