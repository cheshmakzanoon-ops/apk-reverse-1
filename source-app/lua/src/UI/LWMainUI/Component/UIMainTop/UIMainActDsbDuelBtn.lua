local UIMainActDsbDuelBtn = BaseClass("UIMainActDsbDuelBtn", UIBaseContainer)
local base = UIBaseContainer
local this_path = ""
local alCompeteRedDot_path = "RedPointNum"
local alCompeteRedNumTxt_path = "RedPointNum/Text"
local alCompeteStart_path = "TimeBg"
local alCompeteStartTime_path = "TimeBg/alCompeteOpenT"

function UIMainActDsbDuelBtn:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self.nextTime = 0
  
  function self.timer_call_back()
    self:RefreshPerSecond()
  end
end

function UIMainActDsbDuelBtn:OnDestroy()
  self:RemoveTimer()
  base.OnDestroy(self)
end

function UIMainActDsbDuelBtn:ComponentDefine()
  self.allianceCompeteBtn = self:AddComponent(UIButton, this_path)
  self.allianceCompeteBtn:SetOnClick(function()
    self:OnBtnClick()
  end)
  self.alCompeteRedDot = self:AddComponent(UIBaseContainer, alCompeteRedDot_path)
  self.alCompeteRedNumN = self:AddComponent(UIText, alCompeteRedNumTxt_path)
  self.alCompeteOpenTime = self:AddComponent(UIBaseContainer, alCompeteStart_path)
  self.alCompeteOpenTimeTxt = self:AddComponent(UIText, alCompeteStartTime_path)
  self.btnImg = self:AddComponent(UIImage, "Image")
end

function UIMainActDsbDuelBtn:ReInit()
  self:RefreshAlCompeteBtn()
end

function UIMainActDsbDuelBtn:RefreshAlCompeteBtn()
  self:RemoveTimer()
  if not RaceEntranceUtil.IsOldEntranceOpen() then
    self:SetActive(false)
    return
  end
  local actInfo = BattlefieldDsbDuelUtils.ActInfo
  local showBtn = actInfo:CheckIfActOpen()
  self:SetActive(showBtn)
end

function UIMainActDsbDuelBtn:AddTimer()
  self:RemoveTimer()
  self.timer = TimerManager:GetInstance():GetTimer(1, self.timer_call_back, self, false, false, false)
  self.timer:Start()
end

function UIMainActDsbDuelBtn:RemoveTimer()
  if self.timer ~= nil then
    self.timer:Stop()
    self.timer = nil
  end
end

function UIMainActDsbDuelBtn:RefreshPerSecond()
end

function UIMainActDsbDuelBtn:OnBtnClick()
  BattlefieldDsbDuelUtils.ActInfo:OpenActWindow()
end

function UIMainActDsbDuelBtn:RefreshRedPoint()
end

function UIMainActDsbDuelBtn:OnAddListener()
  base.OnAddListener(self)
end

function UIMainActDsbDuelBtn:OnRemoveListener()
  base.OnRemoveListener(self)
end

return UIMainActDsbDuelBtn
