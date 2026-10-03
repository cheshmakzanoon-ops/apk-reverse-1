local MyMineCaveItem = BaseClass("MyMineCaveItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local empty_path = "empty"
local emptyBtn_path = "empty/Image"
local emptyDispatchTip_path = "empty/dispatchBg/dispatchTip"
local emptyDispatchBg_path = "empty/dispatchBg"
local reward_path = "reward"
local occupy_path = "occupy"
local occupyIcon_path = "occupy/mask/occupyIcon"
local occupyProg_path = "occupy/Slider"
local occupyTime_path = "occupy/occupyTime"
local display_path = "display"
local displayIcon_path = "display/displayIcon"
local locked_path = "locked"
local lockedAnim_path = "locked/lockImg"
local lockedEff_path = "locked/lockImg/VFX_ui_minelocked_daiji"
local unlockEff_path = "locked/VFX_ui_mineunlock"

local function OnCreate(self)
  base.OnCreate(self)
  self:DataDefine()
  self:ComponentDefine()
end

local function OnDestroy(self)
  if self.unlockEffTimer then
    self.unlockEffTimer:Stop()
    self.unlockEffTimer = nil
  end
  self:DelCountDownTimer()
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

local function ComponentDefine(self)
  self.emptyN = self:AddComponent(UIBaseContainer, empty_path)
  self.emptyBtnN = self:AddComponent(UIButton, emptyBtn_path)
  self.emptyBtnN:SetOnClick(function()
    self:OnClickEmptyBtn()
  end)
  self.emptyDispatchBgN = self:AddComponent(UIImage, emptyDispatchBg_path)
  self.emptyDispatchTipN = self:AddComponent(UIText, emptyDispatchTip_path)
  self.emptyDispatchTipN:SetLocalText(390146)
  self.emptyDispatchBgN:SetActive(false)
  self.rewardN = self:AddComponent(UIBaseContainer, reward_path)
  self.claimBtnN = self:AddComponent(UIButton, reward_path)
  self.claimBtnN:SetOnClick(function()
    self:OnClickClaimBtn()
  end)
  self.occupyN = self:AddComponent(UIBaseContainer, occupy_path)
  self.occupyBtnN = self:AddComponent(UIButton, occupy_path)
  self.occupyBtnN:SetOnClick(function()
    self:OnClickOccupyBtn()
  end)
  self.occupyIconN = self:AddComponent(UIImage, occupyIcon_path)
  self.occupySliderN = self:AddComponent(UISlider, occupyProg_path)
  self.occupyTimeN = self:AddComponent(UIText, occupyTime_path)
  self.displayN = self:AddComponent(UIBaseContainer, display_path)
  self.displayBtnN = self:AddComponent(UIButton, display_path)
  self.displayBtnN:SetOnClick(function()
    self:OnClickDisplayBtn()
  end)
  self.displayIconN = self:AddComponent(UIImage, displayIcon_path)
  self.lockedN = self:AddComponent(UIButton, locked_path)
  self.lockedN:SetOnClick(function()
    self:OnClickLockedBtn()
  end)
  self.lockedANimN = self:AddComponent(UIAnimator, lockedAnim_path)
  self.lockedEffN = self:AddComponent(UIBaseContainer, lockedEff_path)
  self.lockedEffN:SetActive(false)
  self.unlockEffN = self:AddComponent(UIBaseContainer, unlockEff_path)
  self.unlockEffN:SetActive(false)
end

local function ComponentDestroy(self)
  self.emptyN = nil
  self.emptyBtnN = nil
  self.rewardN = nil
  self.claimBtnN = nil
  self.occupyN = nil
  self.occupyBtnN = nil
  self.occupyIconN = nil
  self.occupySliderN = nil
  self.occupyTimeN = nil
  self.displayN = nil
  self.displayBtnN = nil
  self.displayIconN = nil
  self.lockedN = nil
end

local function DataDefine(self)
  self.mineConf = nil
  self.mineInfo = nil
  self.formationLocked = nil
  self.isToUnlock = nil
  self.toUnlockMinesInfo = nil
  self.mineIndex = nil
  self.OnDispatchCallback = nil
end

local function DataDestroy(self)
  self.mineConf = nil
  self.mineInfo = nil
  self.formationLocked = nil
  self.isToUnlock = nil
  self.toUnlockMinesInfo = nil
  self.mineIndex = nil
  self.OnDispatchCallback = nil
end

local function OnAddListener(self)
  base.OnAddListener(self)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
end

local function SetMineToUnlock(self, mineConf, toUnlockInfo)
  self.mineConf = mineConf
  self.formationLocked = false
  self.isToUnlock = true
  self.toUnlockMinesInfo = toUnlockInfo
  self:RefreshAll()
end

local function SetMinePreview(self, mineConf)
  self.mineConf = mineConf
  self.formationLocked = false
  self.isToUnlock = false
  self:RefreshAll()
end

local function SetMine(self, mineIndex, mineInfo, onDispatchCallback)
  self.mineIndex = mineIndex
  self.formationLocked = false
  self.isToUnlock = false
  self.mineInfo = mineInfo
  self.OnDispatchCallback = onDispatchCallback
  if mineInfo then
    self.mineConf = DataCenter.MineCaveManager:GetMineConf(self.mineInfo.mineId)
  else
    self.mineConf = nil
  end
  self:RefreshAll()
end

local function SetMineLocked(self)
  self.formationLocked = true
  self.isToUnlock = false
  self:RefreshAll()
end

local function RefreshAll(self)
  self:DelCountDownTimer()
  if self.formationLocked then
    self.displayN:SetActive(false)
    self.emptyN:SetActive(false)
    self.rewardN:SetActive(false)
    self.occupyN:SetActive(false)
    self.lockedN:SetActive(true)
    return
  end
  if self.mineConf then
    self.emptyN:SetActive(false)
    if not self.mineInfo then
      self.displayN:SetActive(true)
      self.displayIconN:LoadSprite(string.format("Assets/Main/Sprites/UI/UIMineCave/%s", self.mineConf.icon))
      self.rewardN:SetActive(false)
      self.occupyN:SetActive(false)
      if self.isToUnlock then
        self.lockedN:SetActive(true)
        local curScore = DataCenter.MineCaveManager:GetMyScore()
        if curScore >= self.toUnlockMinesInfo.score then
          self.lockedANimN:Play("mineCave_toUnlock", 0, 0)
          self.unlockEffN:SetActive(false)
        else
          self.lockedANimN:Play("mineCave_Locked", 0, 0)
          self.unlockEffN:SetActive(false)
        end
      else
        self.lockedN:SetActive(false)
      end
    else
      self.displayN:SetActive(false)
      self.lockedN:SetActive(false)
      local now = UITimeManager:GetInstance():GetServerTime()
      if now >= self.mineInfo.endTime then
        self.rewardN:SetActive(true)
        self.occupyN:SetActive(false)
      else
        self.occupyN:SetActive(true)
        self.rewardN:SetActive(false)
        self.occupyIconN:LoadSprite(string.format("Assets/Main/Sprites/UI/UIMineCave/%s", self.mineConf.picture))
        self:AddCountDownTimer()
        self:RefreshRemainTime()
      end
    end
  else
    self.displayN:SetActive(false)
    self.emptyN:SetActive(true)
    self.rewardN:SetActive(false)
    self.occupyN:SetActive(false)
    self.lockedN:SetActive(false)
  end
end

local function SetShowDispatch(self, isShow)
  self.emptyDispatchBgN:SetActive(isShow)
end

local function AddCountDownTimer(self)
  function self.CountDownTimerAction()
    self:RefreshRemainTime()
  end
  
  if self.countDownTimer == nil then
    self.countDownTimer = TimerManager:GetInstance():GetTimer(1, self.CountDownTimerAction, self, false, false, false)
  end
  self.countDownTimer:Start()
end

local function RefreshRemainTime(self)
  local curTime = UITimeManager:GetInstance():GetServerTime()
  local remainTime = self.mineInfo.endTime - curTime
  if 0 < remainTime then
    local totalTime = self.mineInfo.endTime - self.mineInfo.startTime
    local passedTime = curTime - self.mineInfo.startTime
    local prog = passedTime / totalTime
    self.occupySliderN:SetValue(prog)
    self.occupyTimeN:SetText(UITimeManager:GetInstance():MilliSecondToFmtString(remainTime))
  else
    self.occupyTimeN:SetText("")
    self:RefreshAll()
    self:DelCountDownTimer()
  end
end

local function DelCountDownTimer(self)
  if self.countDownTimer ~= nil then
    self.countDownTimer:Stop()
    self.countDownTimer = nil
  end
end

local function OnClickClaimBtn(self)
  if self.mineInfo then
    SFSNetwork.SendMessage(MsgDefines.ClaimMineCaveReward, self.mineInfo.uuid)
  end
  EventManager:GetInstance():Broadcast(EventId.MineCaveShowDispatch)
end

local function OnClickOccupyBtn(self)
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIMineCaveTips, {anim = true}, 3, self.mineInfo.uuid, self.occupyIconN)
  EventManager:GetInstance():Broadcast(EventId.MineCaveShowDispatch)
end

local function OnClickDisplayBtn(self)
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIMineCaveTips, {anim = true}, 1, self.mineConf.id, self.displayIconN)
  EventManager:GetInstance():Broadcast(EventId.MineCaveShowDispatch)
end

local function OnClickEmptyBtn(self)
  if self.OnDispatchCallback then
    self.OnDispatchCallback(self.mineIndex)
  end
end

local function OnClickLockedBtn(self)
  if self.isToUnlock then
    local curScore = DataCenter.MineCaveManager:GetMyScore()
    if curScore >= self.toUnlockMinesInfo.score then
      self.lockedANimN:Play("mineCave_toUnlock_jiesuo", 0, 0)
      self.unlockEffN:SetActive(true)
      self.unlockEffTimer = TimerManager:GetInstance():DelayInvoke(function()
        UIManager:GetInstance():OpenWindow(UIWindowNames.UIMineCaveUnlock, {anim = true}, self.toUnlockMinesInfo)
        DataCenter.MineCaveManager:UpdateToUnlockList(true)
        EventManager:GetInstance():Broadcast(EventId.UpdateMineCaveInfo, true)
      end, 1)
    else
      UIManager:GetInstance():OpenWindow(UIWindowNames.UIMineCaveTips, {anim = true}, 4, self.mineConf.id, self.displayIconN)
    end
  end
end

MyMineCaveItem.OnCreate = OnCreate
MyMineCaveItem.OnDestroy = OnDestroy
MyMineCaveItem.ComponentDefine = ComponentDefine
MyMineCaveItem.ComponentDestroy = ComponentDestroy
MyMineCaveItem.DataDefine = DataDefine
MyMineCaveItem.DataDestroy = DataDestroy
MyMineCaveItem.OnAddListener = OnAddListener
MyMineCaveItem.OnRemoveListener = OnRemoveListener
MyMineCaveItem.SetMinePreview = SetMinePreview
MyMineCaveItem.SetMine = SetMine
MyMineCaveItem.SetMineLocked = SetMineLocked
MyMineCaveItem.SetMineToUnlock = SetMineToUnlock
MyMineCaveItem.RefreshAll = RefreshAll
MyMineCaveItem.SetShowDispatch = SetShowDispatch
MyMineCaveItem.AddCountDownTimer = AddCountDownTimer
MyMineCaveItem.RefreshRemainTime = RefreshRemainTime
MyMineCaveItem.DelCountDownTimer = DelCountDownTimer
MyMineCaveItem.OnClickClaimBtn = OnClickClaimBtn
MyMineCaveItem.OnClickOccupyBtn = OnClickOccupyBtn
MyMineCaveItem.OnClickDisplayBtn = OnClickDisplayBtn
MyMineCaveItem.OnClickEmptyBtn = OnClickEmptyBtn
MyMineCaveItem.OnClickLockedBtn = OnClickLockedBtn
return MyMineCaveItem
