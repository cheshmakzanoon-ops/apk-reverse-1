local UIMainThanksGivingActivityBtn = BaseClass("UIMainThanksGivingActivityBtn", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local this_path = ""
local actThanksGivingRedDot_path = "RedPoint"
local actThanksGivingNameTxt_path = "NameText"
local actThanksGivingStart_path = "TimeBg"
local actThanksGivingStartTime_path = "TimeBg/TimeText"
local actThanksGivingImg_path = "BG/Img"

function UIMainThanksGivingActivityBtn:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UIMainThanksGivingActivityBtn:OnDestroy()
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

function UIMainThanksGivingActivityBtn:ComponentDefine()
  self.actThanksGivingBtn = self:AddComponent(UIButton, this_path)
  self.actThanksGivingBtn:SetOnClick(function()
    self:OnBtnClick()
  end)
  self.actThanksGivingRedDot = self:AddComponent(UIBaseContainer, actThanksGivingRedDot_path)
  self.actThanksGivingOpenTime = self:AddComponent(UIBaseContainer, actThanksGivingStart_path)
  self.actThanksGivingOpenTimeTxt = self:AddComponent(UIText, actThanksGivingStartTime_path)
  self.actThanksGivingNameTxt = self:AddComponent(UIText, actThanksGivingNameTxt_path)
  self.actThanksGivingImg = self:AddComponent(UIImage, actThanksGivingImg_path)
end

function UIMainThanksGivingActivityBtn:ComponentDestroy()
end

function UIMainThanksGivingActivityBtn:DataDefine()
end

function UIMainThanksGivingActivityBtn:DataDestroy()
  self:RemoveTimer()
end

function UIMainThanksGivingActivityBtn:ReInit()
  self:RefreshactThanksGivingBtn()
end

function UIMainThanksGivingActivityBtn:Refresh()
  local dataList = DataCenter.ActivityListDataManager:GetActivityDataByGroupId(tonumber(CommonActivityGroupEnum.ThanksGiving))
  local cookingList = table.choose(dataList, function(k, v)
    if v.type == EnumActivity.Cooking.Type then
      return true
    end
  end)
  if not table.IsNullOrEmpty(cookingList) then
    for k, v in pairs(cookingList) do
      self.actInfo = v
      break
    end
  end
  local unlock = DataCenter.LWFunctionUnlockManager:CheckCanShow(LWFunctionUnlockType.MainUI_Activity)
  local curTime = UITimeManager:GetInstance():GetServerTime()
  self.actThanksGivingBtn:SetActive(self.actInfo and unlock and curTime < self.actInfo.endTime)
  if self.actInfo == nil then
    return
  end
  self:RemoveTimer()
  self:AddTimer()
  if not string.IsNullOrEmpty(self.actInfo.festival_icon) then
    self.actThanksGivingImg:LoadSprite(string.format(LoadPath.ActivityIconPath, self.actInfo.festival_icon))
  end
  self.actThanksGivingNameTxt:SetLocalText(self.actInfo.festivalEntranceName)
  local redNum = 0
  if not table.IsNullOrEmpty(dataList) then
    table.walk(dataList, function(k, v)
      redNum = redNum + DataCenter.ActivityListDataManager:GetRewardNumByTypeAndId(v.type, v.id)
    end)
  end
  self.actThanksGivingRedDot:SetActive(0 < redNum)
end

function UIMainThanksGivingActivityBtn:OnEnable()
  base.OnEnable(self)
end

function UIMainThanksGivingActivityBtn:OnDisable()
  base.OnDisable(self)
end

function UIMainThanksGivingActivityBtn:RefreshActThanksGivingBtn()
end

function UIMainThanksGivingActivityBtn:TryShowActThanksGivingNoticeTime()
end

function UIMainThanksGivingActivityBtn:AddTimer()
  local curTime = UITimeManager:GetInstance():GetServerTime()
  if curTime < self.actInfo.endTime then
    if self.timer == nil then
      self.timer = TimerManager:GetInstance():DelayInvoke(function()
        self:Refresh()
      end, (self.actInfo.endTime - curTime) / 1000)
    end
    self.timer:Start()
  end
end

function UIMainThanksGivingActivityBtn:RemoveTimer()
  if self.timer ~= nil then
    self.timer:Stop()
    self.timer = nil
  end
end

function UIMainThanksGivingActivityBtn:RefreshPerSecond()
end

function UIMainThanksGivingActivityBtn:OnBtnClick()
  if DataCenter.ActivityListDataManager:IsContainActivityGroup(CommonActivityGroupEnum.ThanksGiving) then
    local actInfo = DataCenter.ActivityListDataManager:GetActivityDataByType(EnumActivity.Cooking)
    if actInfo then
      GoToUtil.OpenActivityCommonGroupWindow(CommonActivityGroupEnum.ThanksGiving, actInfo.id)
    else
      UIManager:GetInstance():OpenWindow(UIWindowNames.UIFestivalActivityCommonGroupShow, CommonActivityGroupEnum.ThanksGiving)
    end
  else
    local actInfo = DataCenter.ActivityListDataManager:GetActivityDataByType(EnumActivity.Cooking)
    if actInfo then
      GoToUtil.GotoOpenView(UIWindowNames.UIActivityCenterTable, actInfo.id)
    end
  end
end

return UIMainThanksGivingActivityBtn
