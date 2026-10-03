local UIMainInfiniteGiftBtn = BaseClass("UIMainInfiniteGiftBtn", UIBaseContainer)
local base = UIBaseContainer
local this_path = ""
local time_txt_path = "TimeBg/TimeText"
local img_path = "PiggyBg"

function UIMainInfiniteGiftBtn:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UIMainInfiniteGiftBtn:OnDestroy()
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

function UIMainInfiniteGiftBtn:ComponentDefine()
  self.timeText = self:AddComponent(UIText, time_txt_path)
  self.piggyBankBtn = self:AddComponent(UIButton, this_path)
  self.piggyBankBtn:SetOnClick(function()
    self:OnBtnClick()
  end)
  self.actImg = self:AddComponent(UIImage, img_path)
end

function UIMainInfiniteGiftBtn:ComponentDestroy()
  self.timeText = nil
  self.piggyBankBtn = nil
end

function UIMainInfiniteGiftBtn:DataDefine()
  function self.timer_call_back()
    self:RefreshPerSecond()
  end
end

function UIMainInfiniteGiftBtn:DataDestroy()
  self.pack = nil
  self.endTime = nil
end

function UIMainInfiniteGiftBtn:ReInit()
  self:Refresh()
end

function UIMainInfiniteGiftBtn:Refresh()
  self:RemoveTimer()
  local unlock = DataCenter.LWFunctionUnlockManager:CheckCanShow(LWFunctionUnlockType.MainUI_Activity)
  if not unlock then
    self:SetActive(false)
    return
  end
  local infiniteGiftActDatas = DataCenter.ActivityListDataManager:GetActivityDataByType(EnumActivity.InfiniteGift.Type)
  local activeActId, activeActData
  if not table.IsNullOrEmpty(infiniteGiftActDatas) then
    for _, v in pairs(infiniteGiftActDatas) do
      if v:IsValid() then
        activeActId = v.id
        activeActData = v
        break
      end
    end
  end
  if activeActData then
    self:SetActive(true)
    self.endTime = activeActData.endTime
    self.activeActId = activeActId
    self:RemoveTimer()
    self:AddTimer()
    if not string.IsNullOrEmpty(activeActData.festival_icon) then
      self.actImg:LoadSprite(string.format(LoadPath.ActivityIconPath, activeActData.festival_icon))
    end
  else
    self:SetActive(false)
  end
end

function UIMainInfiniteGiftBtn:OnEnable()
  base.OnEnable(self)
end

function UIMainInfiniteGiftBtn:OnDisable()
  base.OnDisable(self)
end

function UIMainInfiniteGiftBtn:AddTimer()
  if self.timer == nil then
    self.timer = TimerManager:GetInstance():GetTimer(1, self.timer_call_back, self, false, false, false)
  end
  self.timer:Start()
end

function UIMainInfiniteGiftBtn:RemoveTimer()
  if self.timer ~= nil then
    self.timer:Stop()
    self.timer = nil
  end
end

function UIMainInfiniteGiftBtn:RefreshPerSecond()
  if not self.endTime then
    return
  end
  local curTime = UITimeManager:GetInstance():GetServerTime()
  local restTime = self.endTime - curTime
  if restTime < 0 then
    self.piggyBankBtn:SetActive(false)
    self:RemoveTimer()
    return
  end
  local restTimeStr = UITimeManager:GetInstance():MilliSecondToFmtString(restTime)
  self.timeText:SetText(restTimeStr)
end

function UIMainInfiniteGiftBtn:OnBtnClick()
  if self.activeActId then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UILWInfiniteGift, {anim = false}, self.activeActId, 2)
  end
end

return UIMainInfiniteGiftBtn
