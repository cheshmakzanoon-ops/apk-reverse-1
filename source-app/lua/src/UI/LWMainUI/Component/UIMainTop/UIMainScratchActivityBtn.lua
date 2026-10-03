local UIMainScratchActivityBtn = BaseClass("UIMainScratchActivityBtn", UIBaseContainer)
local GroupView = require("UI.UIActivityCommonGroupShow.View.UIActivityCommonGroupShowView")
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local this_path = ""
local actScratchRedDot_path = "RedPoint"
local actScratchNameTxt_path = "NameText"
local actScratchStart_path = "TimeBg"
local actScratchStartTime_path = "TimeBg/TimeText"
local actScratchImg_path = "BG/Img"

function UIMainScratchActivityBtn:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UIMainScratchActivityBtn:OnDestroy()
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

function UIMainScratchActivityBtn:ComponentDefine()
  self.actScratchBtn = self:AddComponent(UIButton, this_path)
  self.actScratchBtn:SetOnClick(function()
    self:OnBtnClick()
  end)
  self.actScratchRedDot = self:AddComponent(UIBaseContainer, actScratchRedDot_path)
  self.actScratchOpenTime = self:AddComponent(UIBaseContainer, actScratchStart_path)
  self.actScratchOpenTimeTxt = self:AddComponent(UIText, actScratchStartTime_path)
  self.actScratchNameTxt = self:AddComponent(UIText, actScratchNameTxt_path)
  self.actScratchImg = self:AddComponent(UIImage, actScratchImg_path)
end

function UIMainScratchActivityBtn:ComponentDestroy()
end

function UIMainScratchActivityBtn:DataDefine()
end

function UIMainScratchActivityBtn:DataDestroy()
  self:RemoveTimer()
end

function UIMainScratchActivityBtn:ReInit()
  self:RefreshActScratchBtn()
end

function UIMainScratchActivityBtn:Refresh()
  local actInfoList = DataCenter.ActivityListDataManager:GetActivityDataByType(EnumActivity.ScratchOffGame.Type)
  if not table.IsNullOrEmpty(actInfoList) then
    self.actInfo = actInfoList[1]
  end
  local unlock = DataCenter.LWFunctionUnlockManager:CheckCanShow(LWFunctionUnlockType.MainUI_Activity)
  local curTime = UITimeManager:GetInstance():GetServerTime()
  self.actScratchBtn:SetActive(self.actInfo and unlock and curTime < self.actInfo.endTime)
  if self.actInfo == nil then
    return
  end
  self:RemoveTimer()
  self:AddTimer()
  if not string.IsNullOrEmpty(self.actInfo.festival_icon) then
    self.actScratchImg:LoadSprite(string.format(LoadPath.ActivityIconPath, self.actInfo.festival_icon))
  end
  self.actScratchNameTxt:SetLocalText(self.actInfo.festivalEntranceName)
  local dataList = DataCenter.ActivityListDataManager:GetActivityDataByGroupId(tonumber(CommonActivityGroupEnum.Scratch))
  local redNum = 0
  if not table.IsNullOrEmpty(dataList) then
    table.walk(dataList, function(k, v)
      redNum = redNum + GroupView:GetRedCountByTypeAndId(v.type, v.id)
    end)
  end
  self.actScratchRedDot:SetActive(0 < redNum)
end

function UIMainScratchActivityBtn:OnEnable()
  base.OnEnable(self)
end

function UIMainScratchActivityBtn:OnDisable()
  base.OnDisable(self)
end

function UIMainScratchActivityBtn:RefreshActScratchBtn()
end

function UIMainScratchActivityBtn:TryShowActScratchNoticeTime()
end

function UIMainScratchActivityBtn:AddTimer()
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

function UIMainScratchActivityBtn:RemoveTimer()
  if self.timer ~= nil then
    self.timer:Stop()
    self.timer = nil
  end
end

function UIMainScratchActivityBtn:RefreshPerSecond()
end

function UIMainScratchActivityBtn:OnBtnClick()
  if DataCenter.ActivityListDataManager:IsContainActivityGroup(CommonActivityGroupEnum.Scratch) then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIActivityCommonGroupShow, CommonActivityGroupEnum.Scratch)
  end
end

return UIMainScratchActivityBtn
