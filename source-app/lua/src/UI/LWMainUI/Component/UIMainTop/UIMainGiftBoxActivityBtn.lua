local UIMainGiftBoxActivityBtn = BaseClass("UIMainGiftBoxActivityBtn", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local this_path = ""
local actGiftBoxRedDot_path = "RedPoint"
local actGiftBoxNameTxt_path = "NameText"
local actGiftBoxStart_path = "TimeBg"
local actGiftBoxStartTime_path = "TimeBg/TimeText"
local actGiftBoxImg_path = "BG/Img"

function UIMainGiftBoxActivityBtn:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UIMainGiftBoxActivityBtn:OnDestroy()
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

function UIMainGiftBoxActivityBtn:ComponentDefine()
  self.actGiftBoxBtn = self:AddComponent(UIButton, this_path)
  self.actGiftBoxBtn:SetOnClick(function()
    self:OnBtnClick()
  end)
  self.actGiftBoxRedDot = self:AddComponent(UIBaseContainer, actGiftBoxRedDot_path)
  self.actGiftBoxOpenTime = self:AddComponent(UIBaseContainer, actGiftBoxStart_path)
  self.actGiftBoxOpenTimeTxt = self:AddComponent(UIText, actGiftBoxStartTime_path)
  self.actGiftBoxNameTxt = self:AddComponent(UIText, actGiftBoxNameTxt_path)
  self.actGiftBoxImg = self:AddComponent(UIImage, actGiftBoxImg_path)
end

function UIMainGiftBoxActivityBtn:ComponentDestroy()
end

function UIMainGiftBoxActivityBtn:DataDefine()
end

function UIMainGiftBoxActivityBtn:DataDestroy()
  self:RemoveTimer()
end

function UIMainGiftBoxActivityBtn:ReInit()
  self:RefreshActGiftBoxBtn()
end

function UIMainGiftBoxActivityBtn:Refresh()
  local dataList = DataCenter.ActivityListDataManager:GetActivityDataByGroupId(tonumber(CommonActivityGroupEnum.GiftBox))
  local giftBoxList = table.choose(dataList, function(k, v)
    if v.type == EnumActivity.GiftBoxActivity.Type then
      return true
    end
  end)
  if not table.IsNullOrEmpty(giftBoxList) then
    self.actInfo = giftBoxList[1]
  end
  local unlock = DataCenter.LWFunctionUnlockManager:CheckCanShow(LWFunctionUnlockType.MainUI_Activity)
  local curTime = UITimeManager:GetInstance():GetServerTime()
  self.actGiftBoxBtn:SetActive(self.actInfo and unlock and curTime < self.actInfo.endTime)
  if self.actInfo == nil then
    return
  end
  self:RemoveTimer()
  self:AddTimer()
  if not string.IsNullOrEmpty(self.actInfo.festival_icon) then
    self.actGiftBoxImg:LoadSprite(string.format(LoadPath.ActivityIconPath, self.actInfo.festival_icon))
  end
  self.actGiftBoxNameTxt:SetLocalText(self.actInfo.festivalEntranceName)
  local redNum = 0
  if not table.IsNullOrEmpty(dataList) then
    table.walk(dataList, function(k, v)
      redNum = redNum + DataCenter.ActivityListDataManager:GetRewardNumByTypeAndId(v.type, v.id)
    end)
  end
  self.actGiftBoxRedDot:SetActive(0 < redNum)
end

function UIMainGiftBoxActivityBtn:OnEnable()
  base.OnEnable(self)
end

function UIMainGiftBoxActivityBtn:OnDisable()
  base.OnDisable(self)
end

function UIMainGiftBoxActivityBtn:RefreshActGiftBoxBtn()
end

function UIMainGiftBoxActivityBtn:TryShowActGiftBoxNoticeTime()
end

function UIMainGiftBoxActivityBtn:AddTimer()
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

function UIMainGiftBoxActivityBtn:RemoveTimer()
  if self.timer ~= nil then
    self.timer:Stop()
    self.timer = nil
  end
end

function UIMainGiftBoxActivityBtn:RefreshPerSecond()
end

function UIMainGiftBoxActivityBtn:OnBtnClick()
  if DataCenter.ActivityListDataManager:IsContainActivityGroup(CommonActivityGroupEnum.GiftBox) then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIActivityCommonGroupShow, CommonActivityGroupEnum.GiftBox)
  else
    local actInfo = DataCenter.ActivityListDataManager:GetActivityDataByType(EnumActivity.GiftBoxActivity)
    if actInfo then
      GoToUtil.GotoOpenView(UIWindowNames.UIActivityCenterTable, actInfo.id)
    end
  end
end

return UIMainGiftBoxActivityBtn
