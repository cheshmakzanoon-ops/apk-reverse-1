local UICD_ScheduleSign = BaseClass("UICD_ScheduleSign", UIBaseContainer)
local base = UIBaseContainer
local UIChampionDuelLimitDi = require("UI.UIChampionDuel.Component.UIChampionDuelLimitDi")
local UIChampionDuelTime = require("UI.UIChampionDuel.Component.UIChampionDuelTime")
local time_path = "Time"
local limit_di_path = "Limit/LimitDi"
local btn_sign_path = "BtnSign"
local text_btn_sign_path = "BtnSign/TextBtnSign"
local red_path = "BtnSign/Red"

function UICD_ScheduleSign:OnCreate()
  base.OnCreate(self)
  self.anim = self:AddComponent(UIAnimator, "")
  self.anim:Enable(false)
  self.time_group = self:AddComponent(UIChampionDuelTime, time_path)
  self.limitDis = {}
  for i = 1, 3 do
    local comp = self:AddComponent(UIChampionDuelLimitDi, limit_di_path .. i)
    comp:ReInit(i)
    self.limitDis[i] = comp
  end
  self.btn_sign = self:AddComponent(UIButton, btn_sign_path)
  self.btn_sign:SetOnClick(BindCallback(self, self.OnBtnSignClick))
  self.text_btn_sign = self:AddComponent(UIText, text_btn_sign_path)
  self.text_btn_sign:SetLocalText("champion_duel_tips1006")
  self.red = self:AddComponent(UIBaseComponent, red_path)
end

function UICD_ScheduleSign:OnDestroy()
  if self.timer then
    self.timer:Stop()
  end
  self.timer = nil
  self.anim = nil
  self.time_group = nil
  self.limitDis = nil
  self.btn_sign = nil
  self.text_btn_sign = nil
  self.red = nil
  base.OnDestroy(self)
end

function UICD_ScheduleSign:OnBtnSignClick()
  DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
  local actInfo = DataCenter.ChampionDuelManager:GetActInfo()
  local sign = actInfo ~= nil and actInfo.sign or false
  if sign then
    return
  end
  local mainBuildLV = DataCenter.BuildManager.MainLv or 0
  local actData = DataCenter.ActivityListDataManager:GetOneOpenActivityByType(EnumActivity.ChampionDuelMain.Type)
  local checkLv = actData ~= nil and actData.needMainCityLevel or 0
  if checkLv <= 0 then
    checkLv = 15
  end
  if mainBuildLV < checkLv then
    UIUtil.ShowTipsId("champion_duel_tips1057")
    return
  end
  local curTime = UITimeManager:GetInstance():GetServerTime()
  if self.lastBtnSignClickTime == nil or curTime - self.lastBtnSignClickTime > 3000 then
    DataCenter.ChampionDuelManager:SendSignUp()
    self.lastBtnSignClickTime = curTime
  end
end

function UICD_ScheduleSign:ReInit()
  self.time_group:ReInit()
  local redFlag = DataCenter.ChampionDuelManager:GetSignRed() > 0
  self.red:SetActive(redFlag)
  DataCenter.ChampionDuelManager:SaveSignFlag()
  self.anim:Enable(true)
  self.anim:Play("Eff_ui_schedulesignShow", 0, 0)
end

function UICD_ScheduleSign:PlaySignAnim(cb)
  if self.timer then
    self.timer:Stop()
  end
  self.timer = nil
  self.anim:Enable(true)
  local ret, time = self.anim:PlayAnimationReturnTime("Eff_ui_schedulesign")
  if ret then
    self.timer = TimerManager:GetInstance():DelayInvoke(function()
      if self.timer then
        self.timer:Stop()
      end
      self.timer = nil
      if cb then
        cb()
      end
    end, time)
  end
end

return UICD_ScheduleSign
