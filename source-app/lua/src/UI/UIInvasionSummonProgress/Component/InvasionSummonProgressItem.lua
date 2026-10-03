local base = require("UI.UIInvasionSummonProgress.Component.InvasionSummonProgressItemBase")
local InvasionSummonProgressItem = BaseClass("InvasionSummonProgressItem", base)
local DataCenter = _ENV.DataCenter
local UIUtil = _ENV.UIUtil
local CS = _ENV.CS
local Localization = CS.GameEntry.Localization
local UIGray = CS.UIGray
local monster_head_root = "Bg"
local monster_head_path = "Bg/MonsterHead"
local full_bubble_bg_path = "FullBubbleBg"
local challenge_btn_path = "FullBubbleBg/ChallengeBtn"
local eff_ui_zzz_loop_path = "Bg/MonsterHead/Eff_ui_zzz_loop"

local function OnCreate(self)
  base.OnCreate(self)
end

local function OnDestroy(self)
  base.OnDestroy(self)
end

local function ComponentDefine(self)
  self.monster_head_root = self:AddComponent(UIBaseContainer, monster_head_root)
  self.monster_head = self:AddComponent(UIImage, monster_head_path)
  self.full_bubble_bg = self:AddComponent(UIBaseContainer, full_bubble_bg_path)
  self.challenge_btn = self:AddComponent(UIButton, challenge_btn_path)
  self.challenge_btn:SetOnClick(BindCallback(self, self.OnItemClick))
  self.tweenRootAni = self.transform:GetComponent(typeof(CS.UnityEngine.Animator))
  self.eff_ui_zzz_loop = self:AddComponent(UIBaseContainer, eff_ui_zzz_loop_path)
  self.objCountDownArea = self:AddComponent(UIBaseContainer, "CountDownArea")
  self.btnCountDownArea = self:AddComponent(UIButton, "CountDownArea")
  self.btnCountDownArea:SetOnClick(function()
    self:OnItemClick()
  end)
  self.textCountDown = self:AddComponent(UITextMeshProUGUIEx, "CountDownArea/countDownText")
  self.textLocalTime = self:AddComponent(UITextMeshProUGUIEx, "CountDownArea/localTimeText")
end

local function ComponentDestroy(self)
  self.monster_head = nil
  self.full_bubble_bg = nil
  self.challenge_btn = nil
  self.tweenRootAni = nil
  self.eff_ui_zzz_loop = nil
end

local function DataDefine(self)
  self.cacheProgress = nil
  self.iconArr = nil
  self.isGray = nil
  self.outOfTime = nil
  self.isHideCountDown = nil
end

local function DataDestroy(self)
  self.cacheProgress = nil
  self.iconArr = nil
  self.isGray = nil
  self.outOfTime = nil
  self.isHideCountDown = nil
end

local function AddListeners(self)
end

local function RemoveListeners(self)
end

local function ReInit(self, progress)
  progress = progress or 0
  self.progress = progress
  local actData = DataCenter.ActivityMonsterInvasionDataManager:GetActivityData()
  if actData then
    local icons = actData.iconArr
    if icons then
      self.iconArr = icons
      local len = #icons
      if self.progress >= self.summon_score then
        if 1 < len then
          self:InitHeadIcon(icons, 2)
        end
      else
        self:InitHeadIcon(icons, 1)
      end
    end
    self:UpdateProgress()
  end
  self:RefreshItem()
  local curTime = UITimeManager:GetInstance():GetServerTime()
  local planTime = DataCenter.ActivityMonsterInvasionDataManager:GetBossPlanTimeFromServer()
  if planTime and curTime <= planTime then
    self:SetBossCountDownShow(true)
    local localTime = UITimeManager:GetInstance():TimeStampToTimeForLocalMinute(planTime)
    self.textLocalTime:SetLocalText("appointment_time_current_time", localTime)
  else
    self:SetBossCountDownShow(false)
  end
end

function InvasionSummonProgressItem:Update1000MS()
  local curTime = UITimeManager:GetInstance():GetServerTime()
  local planTime = DataCenter.ActivityMonsterInvasionDataManager:GetBossPlanTimeFromServer()
  if not planTime or curTime >= planTime then
    if not self.isHideCountDown then
      self:SetBossCountDownShow(false)
      self.isHideCountDown = true
    end
    return
  end
  local leftTime = planTime - curTime
  if 0 < leftTime then
    self.textCountDown:SetLocalText("appointment_time_preparation", UITimeManager:GetInstance():MilliSecondToFmtString(leftTime))
  else
    self.textCountDown:SetText("")
  end
end

function InvasionSummonProgressItem:SetBossCountDownShow(isShow)
  if isShow then
    self.objCountDownArea:SetActive(true)
    self:Update1000MS()
    self.monster_head_root.transform:SetLocalPositionY(112)
    self.full_bubble_bg.transform:SetLocalPositionY(157)
  else
    self.objCountDownArea:SetActive(false)
    self.monster_head_root.transform:SetLocalPositionY(3)
    self.full_bubble_bg.transform:SetLocalPositionY(48)
  end
end

local function OnItemClick(self)
  if string.IsNullOrEmpty(CS.GameEntry.Data.Player:GetAllianceId()) then
    return
  end
  local status = DataCenter.ActivityMonsterInvasionDataManager:GetAisillaActStatus()
  if status == InvasionAisillaActStatus.CREATE then
    DataCenter.ActivityMonsterInvasionDataManager:GotoInvasionAisillaPoint(true)
  elseif status == InvasionAisillaActStatus.KILL then
    if not self.isGray then
      self:SetItemState(true, false)
    end
    UIUtil.ShowTips(Localization:GetString("activity_godzilla_battle_finish"))
  elseif status == InvasionAisillaActStatus.ESCAPE then
    if not self.isGray then
      self:SetItemState(true, false)
    end
    UIUtil.ShowTips(Localization:GetString("activity_godzilla_lose_record"))
  elseif self.outOfTime then
    if not self.isGray then
      self:SetItemState(true, false)
    end
    UIUtil.ShowTips(Localization:GetString("godzilla_count_down_hour", self.notSummonTime))
  else
    if self.notSummonTime == nil then
      local actData = DataCenter.ActivityMonsterInvasionDataManager:GetActData()
      local activityData = DataCenter.ActivityMonsterInvasionDataManager:GetActivityData()
      if actData and activityData then
        self.notSummonTime = activityData.countDownHour
        self.endTime = actData.endTime
      end
    end
    if self.notSummonTime and self.endTime then
      local curTime = UITimeManager:GetInstance():GetServerTime()
      if self.endTime - curTime > self.notSummonTime * 60 * 60 * 1000 then
        if self.progress >= self.summon_score then
          if DataCenter.AllianceBaseDataManager:IsR4orR5() then
            self:SetItemState(false, true)
            if DataCenter.ActivityMonsterInvasionDataManager:GetPlanTimeFuncOpen() then
              UIManager:GetInstance():OpenWindow(UIWindowNames.UIMonsterInvasionPlanTime)
            else
              DataCenter.ActivityMonsterInvasionDataManager:RequestGetMonsterInvasionPoint()
            end
          else
            self:SetItemState(false, false)
            UIUtil.ShowTipsId("activity_godzilla_start_r4_tips")
          end
        else
          self:SetItemState(false, false)
          UIUtil.ShowTipsId("activity_godzilla_start_score_tips")
        end
      else
        self.outOfTime = true
        if not self.isGray then
          self:SetItemState(true, false)
        end
        UIUtil.ShowTips(Localization:GetString("godzilla_count_down_hour", self.notSummonTime))
      end
    end
  end
end

local function DisplayProgressTween(self, targetVal)
  local curVal = self.progress
  if targetVal and targetVal > curVal then
    self.tweenRootAni:Play("V_ui_jiesuo_invasion_jindu", 0, 0)
    self:DoProgressTween(curVal, targetVal)
    self.progress = targetVal
    self.cacheProgress = targetVal
  end
end

local function OnTweenFinished(self)
  if self.progress >= self.summon_score then
    if self.iconArr and #self.iconArr > 1 then
      self:InitHeadIcon(self.iconArr, 2)
    end
    self:RefreshItem()
  end
end

local function RefreshItem(self)
  local status = DataCenter.ActivityMonsterInvasionDataManager:GetAisillaActStatus()
  local showBubble = false
  local isGray = false
  local outOfTime = false
  if status == InvasionAisillaActStatus.NONE then
    if self.notSummonTime == nil then
      local actData = DataCenter.ActivityMonsterInvasionDataManager:GetActData()
      local activityData = DataCenter.ActivityMonsterInvasionDataManager:GetActivityData()
      if actData and activityData then
        self.notSummonTime = activityData.countDownHour
        self.endTime = actData.endTime
      end
    end
    if self.notSummonTime and self.endTime then
      local curTime = UITimeManager:GetInstance():GetServerTime()
      if self.endTime - curTime <= self.notSummonTime * 60 * 60 * 1000 then
        isGray = true
        outOfTime = true
      elseif DataCenter.AllianceBaseDataManager:IsR4orR5() and self.progress >= self.summon_score then
        showBubble = true
      end
    end
  elseif status == InvasionAisillaActStatus.KILL or status == InvasionAisillaActStatus.ESCAPE then
    isGray = true
  end
  self.outOfTime = outOfTime
  self:SetItemState(isGray, showBubble)
end

local function SetItemState(self, gray, showBubble)
  showBubble = showBubble and not gray
  self.full_bubble_bg:SetActive(showBubble)
  local sleep = self.progress < self.summon_score
  sleep = sleep and not gray
  self.eff_ui_zzz_loop:SetActive(sleep)
  self.isGray = gray
  UIGray.SetGray(self.bg.transform, gray, true)
end

InvasionSummonProgressItem.OnCreate = OnCreate
InvasionSummonProgressItem.OnDestroy = OnDestroy
InvasionSummonProgressItem.ComponentDefine = ComponentDefine
InvasionSummonProgressItem.ComponentDestroy = ComponentDestroy
InvasionSummonProgressItem.DataDefine = DataDefine
InvasionSummonProgressItem.DataDestroy = DataDestroy
InvasionSummonProgressItem.AddListeners = AddListeners
InvasionSummonProgressItem.RemoveListeners = RemoveListeners
InvasionSummonProgressItem.ReInit = ReInit
InvasionSummonProgressItem.OnItemClick = OnItemClick
InvasionSummonProgressItem.OnTweenFinished = OnTweenFinished
InvasionSummonProgressItem.DisplayProgressTween = DisplayProgressTween
InvasionSummonProgressItem.RefreshItem = RefreshItem
InvasionSummonProgressItem.SetItemState = SetItemState
return InvasionSummonProgressItem
