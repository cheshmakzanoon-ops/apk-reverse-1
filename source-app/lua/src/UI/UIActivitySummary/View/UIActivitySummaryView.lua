local base = UIBaseView
local UIActivitySummaryView = BaseClass("UIActivitySummaryView", base)
local Localization = CS.GameEntry.Localization
local ActivitySummaryItem = require("UI.UIActivitySummary.Component.ActivitySummaryItem")
local UIScrollPackContent = require("UI.UIScrollPack.Component.UIScrollPackContent")
local title_path = "ImgBg/Top/title"
local closeBtn_path = "ImgBg/BtnClose"
local remainTime_path = "ImgBg/Top/remainTime"
local infoBtn_path = "ImgBg/Top/title/infoBtn"
local resIcon_path = "ImgBg/Res1/resIcon1"
local resCount_path = "ImgBg/Res1/resNum1"
local activityMain_path = "ImgBg/Top/activityMain"
local activityItem_path = "ImgBg/Top/activityMain/activity"
local activityItem56_path = "ImgBg/layoutL/activity"
local pveImg_path = "ImgBg/Top/activityMain/pve/pveImg"
local pveName_path = "ImgBg/Top/activityMain/pve/pveName"
local package_path = "ImgBg/layoutL/package"
local packageImg_path = "ImgBg/layoutL/package/packageIcon"
local packageName_path = "ImgBg/layoutL/package/Image/packageName"
local tipTxt1_path = "ImgBg/Top/subTitle"
local tipTxt2_path = "ImgBg/Top/actTime"
local packagePanel_path = "ImgBg/packagePanel"
local hidePackPanelBtn_path = "ImgBg/packagePanel/Back"
local packageItem_path = "ImgBg/packagePanel/UIScrollPackContent"
local pveRankBtn_path = "ImgBg/Top/activityMain/pve/pveBtns/pveRank"
local pveRankNum_path = "ImgBg/Top/activityMain/pve/pveBtns/pveRank/RankNum"
local pveTaskBtn_path = "ImgBg/Top/activityMain/pve/pveBtns/pveTask"
local pveTaskRed_path = "ImgBg/Top/activityMain/pve/pveBtns/pveTask/MainRed"
local pveTaskRedNum_path = "ImgBg/Top/activityMain/pve/pveBtns/pveTask/MainRed/MainRedText"
local pveBtns_path = "ImgBg/Top/activityMain/pve/pveBtns"
local pveRed_path = "ImgBg/Top/activityMain/pve/pveNew"
local packageNew_path = "ImgBg/layoutL/package/NewDot"
local RewardStatus = {
  Locked = 1,
  CanClaim = 2,
  Claimed = 3
}
local ActivityStatus = {
  Notice = 1,
  Open = 2,
  Close = 3
}

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:InitUI()
end

local function OnDestroy(self)
  self:DelCountDownTimer()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

local function OnAddListener(self)
  base.OnAddListener(self)
  self:AddUIListener(EventId.RefreshItems, self.RefreshResCount)
  self:AddUIListener(EventId.UpdateGiftPackData, self.RefreshPackage)
  self:AddUIListener(EventId.PveActGetInfo, self.RefreshPve)
  self:AddUIListener(EventId.PveActTaskReward, self.RefreshPve)
  self:AddUIListener(EventId.PveActStageReward, self.RefreshPve)
end

local function OnRemoveListener(self)
  self:RemoveUIListener(EventId.RefreshItems, self.RefreshResCount)
  self:RemoveUIListener(EventId.UpdateGiftPackData, self.RefreshPackage)
  self:RemoveUIListener(EventId.PveActGetInfo, self.RefreshPve)
  self:RemoveUIListener(EventId.PveActTaskReward, self.RefreshPve)
  self:RemoveUIListener(EventId.PveActStageReward, self.RefreshPve)
  base.OnRemoveListener(self)
end

local function ComponentDefine(self)
  self.titleN = self:AddComponent(UIText, title_path)
  self.closeBtnN = self:AddComponent(UIButton, closeBtn_path)
  self.closeBtnN:SetOnClick(function()
    self:OnClickCloseBtn()
  end)
  self.remainTimeN = self:AddComponent(UIText, remainTime_path)
  self.infoBtnN = self:AddComponent(UIButton, infoBtn_path)
  self.infoBtnN:SetOnClick(function()
    self:OnClickInfoBtn()
  end)
  self.resIconN = self:AddComponent(UIImage, resIcon_path)
  self.resCountN = self:AddComponent(UIText, resCount_path)
  self.activityMainN = self:AddComponent(UIBaseContainer, activityMain_path)
  self.activityItemsTbN = {}
  for i = 1, 4 do
    local tempPath = activityItem_path .. i
    local tempItem = self:AddComponent(ActivitySummaryItem, tempPath)
    table.insert(self.activityItemsTbN, tempItem)
  end
  for i = 5, 6 do
    local tempPath = activityItem56_path .. i
    local tempItem = self:AddComponent(ActivitySummaryItem, tempPath)
    table.insert(self.activityItemsTbN, tempItem)
  end
  self.pveImgN = self:AddComponent(UIImage, pveImg_path)
  self.pveNameN = self:AddComponent(UIText, pveName_path)
  self.pveNameN:SetLocalText(372383)
  self.pveJumpBtnN = self:AddComponent(UIButton, pveImg_path)
  self.pveJumpBtnN:SetOnClick(function()
    self:OnClickJumptoPveBtn()
  end)
  self.packageN = self:AddComponent(UIBaseContainer, package_path)
  self.packageImgN = self:AddComponent(UIImage, packageImg_path)
  self.packageNameN = self:AddComponent(UIText, packageName_path)
  self.packageBtnN = self:AddComponent(UIButton, package_path)
  self.packageBtnN:SetOnClick(function()
    self:OnClickPackageBtn()
  end)
  self.tipTxt1N = self:AddComponent(UIText, tipTxt1_path)
  self.tipTxt1N:SetText(Localization:GetString("372338"))
  self.tipTxt2N = self:AddComponent(UIText, tipTxt2_path)
  self.tipTxt2N:SetText(Localization:GetString("372391"))
  self.packagePanelN = self:AddComponent(UIBaseContainer, packagePanel_path)
  self.packageItemN = self:AddComponent(UIScrollPackContent, packageItem_path)
  self.hidePackPanelBtnN = self:AddComponent(UIButton, hidePackPanelBtn_path)
  self.hidePackPanelBtnN:SetOnClick(function()
    self:ShowPackagePanel(false)
  end)
  self.pveRankBtnN = self:AddComponent(UIButton, pveRankBtn_path)
  self.pveRankBtnN:SetOnClick(function()
    self:OnClickPveRankBtn()
  end)
  self.pveRankNumN = self:AddComponent(UIText, pveRankNum_path)
  self.pveTaskBtnN = self:AddComponent(UIButton, pveTaskBtn_path)
  self.pveTaskBtnN:SetOnClick(function()
    self:OnClickPveTaskBtn()
  end)
  self.pveTaskRedN = self:AddComponent(UIBaseContainer, pveTaskRed_path)
  self.pveTaskRedNumN = self:AddComponent(UIText, pveTaskRedNum_path)
  self.pveBtnsN = self:AddComponent(UIBaseContainer, pveBtns_path)
  self.pveRedN = self:AddComponent(UIBaseContainer, pveRed_path)
  self.packageNewN = self:AddComponent(UIBaseContainer, packageNew_path)
end

local function ComponentDestroy(self)
  self.titleN = nil
  self.closeBtnN = nil
  self.remainTimeN = nil
  self.activityItemsTbN = nil
  self.infoBtnN = nil
  self.resIconN = nil
  self.resCountN = nil
end

local function DataDefine(self)
  self.activityInfo = nil
  self.activityStatus = nil
  self.endTime = nil
  self.endTimeTip = nil
  self.isShowPackPanel = false
  self.pveActStatus = EnumActivityStatus.Open
end

local function DataDestroy(self)
  self.activityInfo = nil
  self.activityStatus = nil
  self.endTime = nil
  self.endTimeTip = nil
  self.isShowPackPanel = nil
  self.pveActStatus = nil
end

local function InitUI(self)
  self.activityInfo = DataCenter.ThemeActivityManager:GetThemeActivityInfo(EnumActivity.ActivitySummary.Type)
  if not self.activityInfo then
    return
  end
  self:RefreshAll()
end

local function RefreshAll(self)
  self.titleN:SetText(Localization:GetString(self.activityInfo.name))
  local serverTime = UITimeManager:GetInstance():GetServerTime()
  if serverTime < self.activityInfo.endTime then
    self.activityStatus = ActivityStatus.Open
  else
    self.activityStatus = ActivityStatus.Close
  end
  if self.activityStatus == ActivityStatus.Open then
    self.endTime = self.activityInfo.endTime
    self.endTimeTip = "371061"
    self:AddCountDownTimer()
    self:RefreshRemainTime()
    self:ShowActivityMain()
  else
    self:DelCountDownTimer()
    self.remainTimeN:SetText(Localization:GetString("370100"))
  end
  self:RefreshResCount()
  self:RefreshPve()
  self:RefreshPackage()
end

local function RefreshResCount(self)
  local itemId = self.activityInfo.para2
  local goods = DataCenter.ItemTemplateManager:GetItemTemplate(itemId)
  self.resIconN:LoadSprite(string.format(LoadPath.ItemPath, goods.icon))
  local item = DataCenter.ItemData:GetItemById(itemId)
  local hasCount = item and item.count or 0
  self.resCountN:SetText(hasCount)
end

local function RefreshPve(self)
  self.pveActStatus = EnumActivityStatus.Open
  local days = 0
  local tempActId = self.pveActId or ActivitySummaryPveActId
  local pveActInfo = DataCenter.ActivityListDataManager:GetActivityDataById(tostring(tempActId))
  if pveActInfo then
    local curTime = UITimeManager:GetInstance():GetServerTime()
    local mainLv = DataCenter.BuildManager.MainLv
    if mainLv >= pveActInfo.needMainCityLevel then
      if curTime >= pveActInfo.endTime then
        self.pveActStatus = EnumActivityStatus.Close
      elseif curTime <= pveActInfo.startTime then
        self.pveActStatus = EnumActivityStatus.Preview
        days = math.ceil((pveActInfo.startTime - curTime) / (OneDayTime * 1000))
      end
    end
  else
    self.pveActStatus = EnumActivityStatus.Close
  end
  if self.pveActStatus == EnumActivityStatus.Open then
    local isOld = DataCenter.ThemeActivityManager:CheckIfIsOldActivity(EnumActivity.ActivitySummary.Type, tempActId)
    self.pveRedN:SetActive(not isOld)
  else
    self.pveRedN:SetActive(false)
  end
  if self.pveActStatus == EnumActivityStatus.Open then
    self.pveImgN:SetColor(WhiteColor)
    self.pveNameN:SetLocalText(372383)
    self.pveBtnsN:SetActive(true)
    local redCount = DataCenter.PveActManager:GetRedCount(tempActId)
    if 0 < redCount then
      self.pveTaskRedN:SetActive(true)
      self.pveTaskRedNumN:SetText(redCount)
    else
      self.pveTaskRedN:SetActive(false)
    end
    local rankData = DataCenter.PveActManager:GetRankData(tempActId)
    if rankData and rankData.selfRank and 0 < rankData.selfRank then
      self.pveRankNumN:SetText(rankData.selfRank)
    end
  else
    self.pveImgN:SetColor(GrayColor)
    self.pveBtnsN:SetActive(false)
    if self.pveActStatus == EnumActivityStatus.Preview then
      self.pveNameN:SetText(Localization:GetString(GameDialogDefine.SOMEDAY_AFTER_OPEN, days))
    else
      self.pveNameN:SetLocalText(370100)
    end
  end
end

local function RefreshPackage(self)
  local packageArr = string.split(self.activityInfo.para3, ";")
  for i, packageId in ipairs(packageArr) do
    local packInfo = GiftPackageData.get(packageId)
    if packInfo then
      self.curPackageInfo = packInfo
      self.packageN:SetActive(true)
      local strName = packInfo:getNameText()
      self.packageNameN:SetText(strName)
      if DataCenter.ThemeActivityManager:CheckIfPackageIsNew(self.activityInfo) then
        self.packageNewN:SetActive(true)
      else
        self.packageNewN:SetActive(false)
      end
      return
    end
  end
  self.curPackageInfo = nil
  self.packageN:SetActive(false)
end

local function ShowPackagePanel(self, isShow)
  DataCenter.ThemeActivityManager:SetPackageOld(self.activityInfo)
  self:RefreshPackage()
  if not isShow then
    self.packagePanelN:SetActive(false)
  else
    self.packagePanelN:SetActive(true)
    self.packageItemN:SetData(self.curPackageInfo, function()
      self:ShowPackagePanel(false)
    end)
  end
end

local function ShowActivityMain(self)
  self.activityMainN:SetActive(true)
  local actIdList = string.split(self.activityInfo.para1, ";")
  self.pveActId = ActivitySummaryPveActId
  if 7 <= #actIdList and not string.IsNullOrEmpty(actIdList[7]) then
    self.pveActId = tonumber(actIdList[7])
  end
  for i, v in ipairs(self.activityItemsTbN) do
    if i <= #actIdList and not string.IsNullOrEmpty(actIdList[i]) then
      v:SetActive(true)
      v:SetItem(actIdList[i])
    else
      v:SetActive(false)
    end
  end
end

local function EndActivity(self)
  self.activityMainN:SetActive(false)
  self.activityNoticeN:SetActive(false)
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
  local remainTime = self.endTime - curTime
  if 0 < remainTime then
    self.remainTimeN:SetText(UITimeManager:GetInstance():MilliSecondToFmtString(remainTime))
  else
    self.remainTimeN:SetText("")
    self:DelCountDownTimer()
    self:RefreshAll()
  end
end

local function DelCountDownTimer(self)
  if self.countDownTimer ~= nil then
    self.countDownTimer:Stop()
    self.countDownTimer = nil
  end
end

local function OnClickInfoBtn(self)
  UIUtil.ShowIntro(Localization:GetString(tostring(self.activityInfo.name)), Localization:GetString("100239"), Localization:GetString(tostring(self.activityInfo.story)))
end

local function OnClickJumptoPveBtn(self)
  if self.pveActStatus == EnumActivityStatus.Close then
    UIUtil.ShowTips(Localization:GetString("370100"))
    return
  elseif self.pveActStatus == EnumActivityStatus.Preview then
    UIUtil.ShowTips(Localization:GetString("E100172"))
    return
  end
end

local function OnClickPackageBtn(self)
  self:ShowPackagePanel(true)
end

local function OnClickNoticeReward(self, day)
  local item = self.noticeRewardTbN[day]
  if item.rewardState == RewardStatus.CanClaim then
    DataCenter.ThemeActivityManager:RequestClaimNoticeReward(self.activityInfo.id, day)
  elseif item.rewardState == RewardStatus.Locked then
    UIUtil.ShowTips(item.descN:GetText())
  else
    UIUtil.ShowTipsId(170003)
  end
end

local function OnClickCloseBtn(self)
  self.ctrl:CloseSelf()
end

local function OnClickPveRankBtn(self)
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIPveActRank, self.pveActId)
end

local function OnClickPveTaskBtn(self)
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIPveActMain, self.pveActId, 0)
end

UIActivitySummaryView.OnCreate = OnCreate
UIActivitySummaryView.OnDestroy = OnDestroy
UIActivitySummaryView.OnAddListener = OnAddListener
UIActivitySummaryView.OnRemoveListener = OnRemoveListener
UIActivitySummaryView.ComponentDefine = ComponentDefine
UIActivitySummaryView.ComponentDestroy = ComponentDestroy
UIActivitySummaryView.DataDefine = DataDefine
UIActivitySummaryView.DataDestroy = DataDestroy
UIActivitySummaryView.InitUI = InitUI
UIActivitySummaryView.RefreshAll = RefreshAll
UIActivitySummaryView.ShowActivityMain = ShowActivityMain
UIActivitySummaryView.ShowPackagePanel = ShowPackagePanel
UIActivitySummaryView.ShowActivityNotice = ShowActivityNotice
UIActivitySummaryView.EndActivity = EndActivity
UIActivitySummaryView.RefreshResCount = RefreshResCount
UIActivitySummaryView.RefreshPve = RefreshPve
UIActivitySummaryView.RefreshPackage = RefreshPackage
UIActivitySummaryView.AddCountDownTimer = AddCountDownTimer
UIActivitySummaryView.RefreshRemainTime = RefreshRemainTime
UIActivitySummaryView.CheckIfNoticeRewardClaimed = CheckIfNoticeRewardClaimed
UIActivitySummaryView.DelCountDownTimer = DelCountDownTimer
UIActivitySummaryView.OnClickCloseBtn = OnClickCloseBtn
UIActivitySummaryView.OnClickPveRankBtn = OnClickPveRankBtn
UIActivitySummaryView.OnClickPveTaskBtn = OnClickPveTaskBtn
UIActivitySummaryView.OnClickNoticeReward = OnClickNoticeReward
UIActivitySummaryView.OnClickInfoBtn = OnClickInfoBtn
UIActivitySummaryView.OnClickJumptoPveBtn = OnClickJumptoPveBtn
UIActivitySummaryView.OnClickPackageBtn = OnClickPackageBtn
return UIActivitySummaryView
