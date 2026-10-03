local base = require("UI.UIActivityCenterTable.Component.ActivityContentBase")
local JungleTrialMain = BaseClass("JungleTrialMain", base)
local ChomperComponent = require("UI.UIJungleTrial.ChomperComponent")
local Localization = CS.GameEntry.Localization

function JungleTrialMain:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function JungleTrialMain:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function JungleTrialMain:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.btnTitle = self.viewSkin:AddComponent(self, UIButton, 1)
  self.btnTitle:SetOnClick(function()
    self:OnBtnTitleClick()
  end)
  self.textTitle = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 2)
  self.textDesc = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 3)
  self.textTime = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 4)
  self.textName1 = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 5)
  self.textDesc1 = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 6)
  self.textNumber1 = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 7)
  self.textName2 = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 8)
  self.textDesc2 = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 9)
  self.textNumber2 = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 10)
  self.textName3 = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 11)
  self.textDesc3 = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 12)
  self.textNumber3 = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 13)
  self.btnRank = self.viewSkin:AddComponent(self, UIButton, 14)
  self.btnRank:SetOnClick(function()
    self:OnBtnRankClick()
  end)
  self.btnTask = self.viewSkin:AddComponent(self, UIButton, 15)
  self.btnTask:SetOnClick(function()
    self:OnBtnTaskClick()
  end)
  self.compRedPointTask = self.viewSkin:AddComponent(self, UIBaseComponent, 16)
  self.btnRecord = self.viewSkin:AddComponent(self, UIButton, 17)
  self.btnRecord:SetOnClick(function()
    self:OnBtnRecordClick()
  end)
  self.textBotTitle = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 18)
  self.btnBotInfobtn = self.viewSkin:AddComponent(self, UIButton, 19)
  self.btnBotInfobtn:SetOnClick(function()
    self:OnBtnBotInfobtnClick()
  end)
  self.textBotDesc = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 20)
  self.sliderSimple = self.viewSkin:AddComponent(self, UISlider, 21)
  self.textProgress = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 22)
  self.compEmptyText = self.viewSkin:AddComponent(self, UIBaseComponent, 23)
  self.btnJoin = self.viewSkin:AddComponent(self, UIButton, 24)
  self.btnJoin:SetOnClick(function()
    self:OnBtnJoinClick()
  end)
  self.compReward = self.viewSkin:AddComponent(self, UIBaseComponent, 25)
  self.compChomper2 = self.viewSkin:AddComponent(self, ChomperComponent, 26)
  self.compChomper1 = self.viewSkin:AddComponent(self, ChomperComponent, 27)
  self.btnRewardInfo = self.viewSkin:AddComponent(self, UIButton, 28)
  self.btnRewardInfo:SetOnClick(function()
    self:OnBtnRewardInfoClick()
  end)
  self.btnBox = self.viewSkin:AddComponent(self, UIButton, 29)
  self.btnBox:SetOnClick(function()
    self:OnBtnBoxClick()
  end)
  self.compBoxRed = self.viewSkin:AddComponent(self, UIBaseComponent, 30)
  self.textBoxRed = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 31)
  self.compChomper3 = self.viewSkin:AddComponent(self, ChomperComponent, 32)
  self.compChomper4 = self.viewSkin:AddComponent(self, ChomperComponent, 33)
  self.compChomper5 = self.viewSkin:AddComponent(self, ChomperComponent, 34)
  self.compUIPlayerHead1 = self.viewSkin:AddComponent(self, UICommonHead, 35)
  self.compUIPlayerHead2 = self.viewSkin:AddComponent(self, UICommonHead, 36)
  self.compUIPlayerHead3 = self.viewSkin:AddComponent(self, UICommonHead, 37)
  self.compRank3 = self.viewSkin:AddComponent(self, UIBaseComponent, 38)
  self.compRank2 = self.viewSkin:AddComponent(self, UIBaseComponent, 39)
  self.compRank1 = self.viewSkin:AddComponent(self, UIBaseComponent, 40)
  self.compRank = self.viewSkin:AddComponent(self, UIBaseComponent, 41)
  self.btnBox:SetSafeClickMode(true)
  self.compUIPlayerHead1:SetEnableClickShowInfo(true, true)
  self.compUIPlayerHead2:SetEnableClickShowInfo(true, true)
  self.compUIPlayerHead3:SetEnableClickShowInfo(true, true)
end

function JungleTrialMain:ComponentDestroy()
  self.viewSkin = nil
  self.btnTitle = nil
  self.textTitle = nil
  self.textDesc = nil
  self.textTime = nil
  self.textName1 = nil
  self.textDesc1 = nil
  self.textNumber1 = nil
  self.textName2 = nil
  self.textDesc2 = nil
  self.textNumber2 = nil
  self.textName3 = nil
  self.textDesc3 = nil
  self.textNumber3 = nil
  self.btnRank = nil
  self.btnTask = nil
  self.compRedPointTask = nil
  self.btnRecord = nil
  self.textBotTitle = nil
  self.btnBotInfobtn = nil
  self.textBotDesc = nil
  self.sliderSimple = nil
  self.textProgress = nil
  self.compEmptyText = nil
  self.btnJoin = nil
  self.compReward = nil
  self.compChomper2 = nil
  self.compChomper1 = nil
  self.btnRewardInfo = nil
  self.btnBox = nil
  self.compBoxRed = nil
  self.textBoxRed = nil
  self.compChomper3 = nil
  self.compChomper4 = nil
  self.compChomper5 = nil
  self.compUIPlayerHead1 = nil
  self.compUIPlayerHead2 = nil
  self.compUIPlayerHead3 = nil
  self.compRank3 = nil
  self.compRank2 = nil
  self.compRank1 = nil
  self.compRank = nil
end

function JungleTrialMain:DataDefine()
  DataCenter.JungleTrialDataManager:FetchRankData()
  DataCenter.JungleTrialDataManager:FetchActivityData()
end

function JungleTrialMain:DataDestroy()
end

function JungleTrialMain:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.OnJungleTrialRewardRefresh, self.RefreshTaskRedPoint)
  self:AddUIListener(EventId.OnJungleTrialBoxRefresh, self.RefreshBoxRedPoint)
  self:AddUIListener(EventId.JungleTrialRankRefresh, self.RefreshRank)
  self:AddUIListener(EventId.JungleTrialActivityDataRefresh, self.OnDataRefresh)
  self:AddUIListener(EventId.JungleTrialMonsterRefresh, self.RefreshBottom)
end

function JungleTrialMain:OnRemoveListener()
  self:RemoveUIListener(EventId.OnJungleTrialRewardRefresh, self.RefreshTaskRedPoint)
  self:RemoveUIListener(EventId.OnJungleTrialBoxRefresh, self.RefreshBoxRedPoint)
  self:RemoveUIListener(EventId.JungleTrialRankRefresh, self.RefreshRank)
  self:RemoveUIListener(EventId.JungleTrialActivityDataRefresh, self.OnDataRefresh)
  self:RemoveUIListener(EventId.JungleTrialMonsterRefresh, self.RefreshBottom)
  base.OnRemoveListener(self)
end

function JungleTrialMain:SetData(activityId)
  base.SetData(self, activityId)
  self.activityId = activityId
  if not self.activityId then
    return
  end
  DataCenter.ActivityListDataManager:SetActivityVisitedEndTime(activityId)
  self.data = DataCenter.ActivityListDataManager:GetActivityDataById(activityId)
  self:RefreshTop()
  self:RefreshRank()
  self:RefreshBottom()
end

function JungleTrialMain:OnDataRefresh()
  self:RefreshTop()
  self:RefreshBottom()
end

function JungleTrialMain:RefreshTop()
  self.textTitle:SetLocalText(self.data.activityName)
  self.textDesc:SetLocalText(self.data.bannerTittle)
  self:Update1000MS()
  self:RefreshTaskRedPoint()
end

function JungleTrialMain:RefreshTaskRedPoint()
  self.compRedPointTask:SetActive(DataCenter.JungleTrialDataManager:GetCanReceive())
end

function JungleTrialMain:RefreshBoxRedPoint()
  local num = DataCenter.JungleTrialDataManager:GetCanOpenBoxNum()
  self.compBoxRed:SetActive(0 < num)
  self.textBoxRed:SetText(num)
end

function JungleTrialMain:Update1000MS()
  local endTime = DataCenter.JungleTrialDataManager:GetEndTime()
  if endTime >= MANY_YEARS_LATER then
    self.textTime:SetText("")
    return
  end
  local now = UITimeManager:GetInstance():GetServerTime()
  local countdown = UITimeManager:GetInstance():MilliSecondToFmtString(endTime - now)
  self.textTime:SetText(countdown)
end

function JungleTrialMain:RefreshRank()
  if LuaEntry.Player:IsInAlliance() then
    self.compRank:SetActive(true)
    local rankList = DataCenter.JungleTrialDataManager:GetRankData() or {}
    for i = 1, 3 do
      local rank = rankList[i]
      if rank then
        self["compUIPlayerHead" .. i]:ParseHeadInfo(rank)
        self["textNumber" .. i]:SetText(rank.score)
        self["textName" .. i]:SetText(rank.name)
        self["compRank" .. i]:SetActive(true)
      else
        self["compRank" .. i]:SetActive(false)
      end
    end
  else
    self.compRank:SetActive(false)
  end
end

function JungleTrialMain:RefreshBottom()
  if not LuaEntry.Player:IsInAlliance() then
    self.compEmptyText:SetActive(true)
    self.compReward:SetActive(false)
    self.sliderSimple:SetValue(0)
    self.textProgress:SetText(string.percentage(0, 1, 0))
    return
  else
    self.compEmptyText:SetActive(false)
    self.compReward:SetActive(true)
  end
  local progress = DataCenter.JungleTrialDataManager:GetFillAmount()
  self.sliderSimple:SetValue(progress)
  self.textProgress:SetText(string.percentage(progress, 1, 0))
  local killNum = DataCenter.JungleTrialDataManager:GetKilledChomperCount()
  local chomperList = DataCenter.JungleTrialDataManager:GetChomperList()
  table.sort(chomperList, function(a, b)
    return a.createTime < b.createTime
  end)
  for i = 1, 5 do
    if i <= tonumber(self.data.para_3) then
      self["compChomper" .. i]:SetActive(true)
      if i <= killNum then
        self["compChomper" .. i]:SetData(1)
      elseif i - killNum <= #chomperList then
        self["compChomper" .. i]:SetData(2, chomperList[i - killNum])
      else
        self["compChomper" .. i]:SetData(3)
      end
    else
      self["compChomper" .. i]:SetActive(false)
    end
  end
  self:RefreshBoxRedPoint()
end

function JungleTrialMain:OnBtnTitleClick()
  if self.data then
    local param = {}
    param.howToPlayList = self.data.howtoplay
    param.story = self.data.story
    param.defaultTitle = self.data.name
    UIManager:GetInstance():OpenWindow(UIWindowNames.UILWHowToPlay, {anim = true}, param)
  end
end

function JungleTrialMain:OnBtnRankClick()
  if not LuaEntry.Player:IsInAlliance() then
    UIUtil.ShowTipsId(2010218)
  else
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIJungleTrialRank, {anim = true})
  end
end

function JungleTrialMain:OnBtnTaskClick()
  if not LuaEntry.Player:IsInAlliance() then
    UIUtil.ShowTipsId(2010218)
  else
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIJungleTrialTask, {anim = true})
  end
end

function JungleTrialMain:OnBtnRecordClick()
  if not LuaEntry.Player:IsInAlliance() then
    UIUtil.ShowTipsId(2010218)
  else
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIJungleTrialHistory, {anim = true})
  end
end

function JungleTrialMain:OnBtnBotInfobtnClick()
  UIUtil.ShowBubbleTips(Localization:GetString("season6_piranha_activity_kill_box_desc", tonumber(self.data.para_3)), self.btnBotInfobtn.transform.position, -26, -50, 0)
end

function JungleTrialMain:OnBtnJoinClick()
  self.view.ctrl:OnCustomKeyCodeEscape()
  UIUtil.OnJoinAllianceBtnClick()
end

function JungleTrialMain:OnBtnRewardInfoClick()
  UIUtil.ShowBubbleTips(Localization:GetString("season6_piranha_activity_kill_box_desc", tonumber(self.data.para_3)), self.btnRewardInfo.transform.position, -23, -50, 0)
end

function JungleTrialMain:OnBtnBoxClick()
  if DataCenter.JungleTrialDataManager:GetCanOpenBoxNum() > 0 then
    DataCenter.JungleTrialDataManager:FetchOpenBox()
  else
    self:ShowRewardTips()
  end
end

function JungleTrialMain:ShowRewardTips()
  local x = self.btnBox.transform.position.x
  local y = self.btnBox.transform.position.y
  local offset = 30
  local width = self.btnBox.rectTransform.rect.width * 0.75
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIActivityRewardTip, nil, EnumActivity.JungleTrial.Type, x, y, true, nil, width, offset)
end

return JungleTrialMain
