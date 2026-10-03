local base = require("UI.UIActivityCenterTable.Component.ActivityContentBase")
local UIContinuePayMain = BaseClass("UIContinuePayMain", base)
local Localization = CS.GameEntry.Localization
local UIContinuePayItem = require("UI.UIActivityCenterTable.Component.ContinuePay.UIContinuePayItem")
local title_path = "Content/Top/title"
local info_btn_path = "Content/Top/InfoBtn"
local openTime_path = "Content/Top/TimeBg/openTime"
local resourceNum_path = "Content/Top/ResBar/root/resourceNum"
local resourceIcon_path = "Content/Top/ResBar/root/resourceIcon"
local addBtn_path = "Content/Top/ResBar/addBtn"
local task_red_dot_path = "Content/Top/ResBar/taskRedDot"
local rewardBtn_path = "Content/Top/RewardBtn"
local rewardBtnText_path = "Content/Top/RewardBtn/RewardBtnText"
local bagBtn_path = "Content/Bottom/BagBtn"
local bagBtnText_path = "Content/Bottom/BagBtn/BagBtnText"
local totalValueText_path = "Content/Top/DescContent/TotalValueText"
local descText_path = "Content/Top/DescContent/DescText"
local remainTimes_path = "Content/Top/ResBar/root/RemainTimesText"
local reset_btn_path = "Content/Bottom/ResetBtn"
local reset_btn_txt_path = "Content/Bottom/ResetBtn/BG/ResetBtnText"

function UIContinuePayMain:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UIContinuePayMain:OnDestroy()
  self:CloseAniSeq()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIContinuePayMain:ComponentDefine()
  self.title = self:AddComponent(UIText, title_path)
  self.info_btn = self:AddComponent(UIButton, info_btn_path)
  self.info_btn:SetOnClick(function()
    self:OnHelpBtnClick()
  end)
  self.addBtn = self:AddComponent(UIButton, addBtn_path)
  self.addBtn:SetOnClick(function()
    self:OnAddBtnClick()
  end)
  self.bagBtn = self:AddComponent(UIButton, bagBtn_path)
  self.bagBtnText = self:AddComponent(UIText, bagBtnText_path)
  self.bagBtnText:SetLocalText("\231\188\186Key")
  self.bagBtn:SetOnClick(function()
    self:OnBagBtnClick()
  end)
  self.rewardBtn = self:AddComponent(UIButton, rewardBtn_path)
  self.rewardBtnText = self:AddComponent(UIText, rewardBtnText_path)
  self.rewardBtnText:SetLocalText("\231\188\186Key")
  self.rewardBtn:SetOnClick(function()
    self:OnRewardBtnClick()
  end)
  self.resetBtn = self:AddComponent(UIButton, reset_btn_path)
  self.resetBtnText = self:AddComponent(UIText, reset_btn_txt_path)
  self.resetBtnText:SetLocalText("\231\188\186Key")
  self.resetBtn:SetOnClick(function()
    self:OnResetBtnClick()
  end)
  self.resourceNum = self:AddComponent(UIText, resourceNum_path)
  self.resourceIcon = self:AddComponent(UIImage, resourceIcon_path)
  self.openTime = self:AddComponent(UIText, openTime_path)
  self.cardPosList = {}
  for i = 1, 12 do
    local cardPosItemName = string.format("Content/cardContent/cardPos%d", i)
    local cardPosItem = self:AddComponent(UIBaseContainer, cardPosItemName)
    cardPosItem.cardItem = cardPosItem:AddComponent(UIContinuePayItem, "UIContinuePayItem")
    table.insert(self.cardPosList, cardPosItem)
  end
  self.animN = self:AddComponent(UIAnimator, "")
  self.animN:Enable(false)
  self.taskRedDot = self:AddComponent(UIBaseContainer, task_red_dot_path)
  self.totalValueText = self:AddComponent(UIText, totalValueText_path)
  self.totalValueText:SetLocalText("\231\188\186Key")
  self.descText = self:AddComponent(UIText, descText_path)
  self.descText:SetLocalText("\231\188\186Key")
  self.remainTimesText = self:AddComponent(UIText, remainTimes_path)
  self.remainTimesText:SetLocalText("\231\188\186Key")
end

function UIContinuePayMain:ComponentDestroy()
  self.title = nil
  self.info_btn = nil
  self.addBtn = nil
  self.resourceNum = nil
  self.resourceIcon = nil
  self.openTime = nil
  self.cardPosList = nil
  self.animN = nil
  self.bagBtn = nil
  self.bagBtnText = nil
  self.rewardBtn = nil
  self.rewardBtnText = nil
  self.totalValueText = nil
  self.descText = nil
  self.remainTimesText = nil
  self.resetBtn = nil
  self.resetBtnText = nil
  self.taskRedDot = nil
end

function UIContinuePayMain:DataDefine()
  self.activityId = nil
  self.activityInfo = nil
  self.isDetailInfoExist = nil
end

function UIContinuePayMain:DataDestroy()
  self.activityId = nil
  self.activityInfo = nil
  self.isDetailInfoExist = nil
end

function UIContinuePayMain:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.OnPayActivityTaskUpdated, self.OnTaskUpdate)
  self:AddUIListener(EventId.OnPayActivityInfoUpdated, self.RefreshAll)
  self:AddUIListener(EventId.OnPayActivitySingleBoxUpdated, self.OnOpenOneBox)
  self:AddUIListener(EventId.OnPayActivityGetBigReward, self.OnGetBigReward)
  self:AddUIListener(EventId.OnPassDay, self.OnPassDay)
  self:AddUIListener(EventId.RefreshItems, self.UpdateItemNumView)
  self:AddUIListener(EventId.RefreshResourceItem, self.UpdateItemNumView)
end

function UIContinuePayMain:OnRemoveListener()
  self:RemoveUIListener(EventId.OnPayActivityTaskUpdated, self.OnTaskUpdate)
  self:RemoveUIListener(EventId.OnPayActivityInfoUpdated, self.RefreshAll)
  self:RemoveUIListener(EventId.OnPayActivitySingleBoxUpdated, self.OnOpenOneBox)
  self:RemoveUIListener(EventId.OnPayActivityGetBigReward, self.OnGetBigReward)
  self:RemoveUIListener(EventId.OnPassDay, self.OnPassDay)
  self:RemoveUIListener(EventId.RefreshItems, self.UpdateItemNumView)
  self:RemoveUIListener(EventId.RefreshResourceItem, self.UpdateItemNumView)
  base.OnRemoveListener(self)
end

function UIContinuePayMain:SetData(activityId)
  base.SetData(self, activityId)
  self.activityId = tonumber(activityId)
  if not self.activityId then
    return
  end
  DataCenter.ActivityListDataManager:SetActivityVisitedEndTime(activityId)
  self.activityInfo = DataCenter.ActivityListDataManager:GetActivityDataById(self.activityId)
  if self.activityInfo == nil then
    return
  end
  SFSNetwork.SendMessage(MsgDefines.ActivityEventInfoGet, tostring(self.activityId))
  self:RefreshAll()
end

function UIContinuePayMain:UpdateInfoView()
  self.title:SetLocalText(self.activityInfo.activityName)
end

function UIContinuePayMain:UpdateRedDot()
  self.taskRedDot:SetActive(DataCenter.ContinuePayActivityManager:GetRedPointCount() > 0)
end

function UIContinuePayMain:OnTaskUpdate()
  self:UpdateItemNumView()
  self:UpdateRedDot()
end

function UIContinuePayMain:UpdateItemNumView()
  if not self.activityId then
    return
  end
  if self.activityInfo == nil then
    return
  end
  local resItemId = DataCenter.ContinuePayActivityManager:GetOpenBoxResItem(self.activityId)
  if not resItemId then
    return
  end
  self.resourceIcon:LoadSprite(DataCenter.ResourceItemDataManager:GetIconPath(resItemId))
  local curNum = DataCenter.ResourceItemDataManager:GetCountByItemId(resItemId)
  self.resourceNum:SetText(curNum)
end

function UIContinuePayMain:Update1000MS()
  if not self.activityId then
    return
  end
  if self.activityInfo == nil then
    return
  end
  local curTime = UITimeManager:GetInstance():GetServerTime()
  local endTime = self.activityInfo.endTime
  local remainTime = endTime - curTime
  if 0 < remainTime then
    self.openTime:SetText(UITimeManager:GetInstance():MilliSecondToFmtString(remainTime))
  else
    self.openTime:SetText("")
  end
end

function UIContinuePayMain:RefreshCardView()
  for i = 1, #self.cardPosList do
    self.cardPosList[i]:SetActive(true)
    self.cardPosList[i]:SetEulerAnglesXYZ(0, 0, 0)
    self.cardPosList[i]:SetLocalScaleXYZ(1, 1, 1)
    self.cardPosList[i].cardItem:SetClickCallBack(function()
      self:OnCardItemClick(i)
    end)
  end
  for i, v in ipairs(self.cardPosList) do
    self.cardPosList[i].cardItem:ShowItem(self.activityId, i)
  end
end

function UIContinuePayMain:RefreshBottomView()
  self:RefreshResetBtn()
end

function UIContinuePayMain:OnPassDay()
  SFSNetwork.SendMessage(MsgDefines.ActivityEventInfoGet, tostring(self.activityId))
end

function UIContinuePayMain:RefreshAll()
  if not self.activityId then
    return
  end
  if self.activityInfo == nil then
    return
  end
  self.isDetailInfoExist = DataCenter.ContinuePayActivityManager:IsActDetailDataExist()
  if not self.isDetailInfoExist then
    return
  end
  self:UpdateRedDot()
  self:UpdateInfoView()
  self:UpdateItemNumView()
  self:RefreshCardView()
  self:RefreshBottomView()
  self:Update1000MS()
end

function UIContinuePayMain:UpdateData()
  self:RefreshAll()
end

function UIContinuePayMain.GetEventCanRewardCount()
  return 0
end

function UIContinuePayMain:OnCardItemClick(index)
  if not self.activityId then
    return
  end
  if self.activityInfo == nil then
    return
  end
  if not self.isDetailInfoExist then
    return
  end
  if not self.cardPosList[index].cardItem.reward then
    local resItemId = DataCenter.ContinuePayActivityManager:GetOpenBoxResItem(self.activityId)
    local curNum = DataCenter.ResourceItemDataManager:GetCountByItemId(resItemId)
    if 0 < curNum then
      DataCenter.ContinuePayActivityManager:RequestOpenOneBox(self.activityId, index)
    else
      UIUtil.ShowTipsId(120021)
      UIManager:GetInstance():OpenWindow(UIWindowNames.UIActContinuePayLackPanel, {anim = true})
    end
  end
end

function UIContinuePayMain:OnOpenOneBox(data)
  self:RefreshBottomView()
  self:RefreshCardView()
  self.cardPosList[data.index].cardItem:ShowItem(self.activityId, data.index)
  local pos = self.cardPosList[data.index].transform.position
  if not table.IsNullOrEmpty(data.reward) then
    local type = data.reward[1].type
    local icon
    if type == RewardType.GOODS then
      icon = DataCenter.ItemTemplateManager:GetIconPath(data.reward[1].value.itemId)
    elseif type == RewardType.RESOURCE_ITEM then
      icon = DataCenter.ResourceItemDataManager:GetIconPath(data.reward[1].value.itemId)
    end
    if icon then
      UIUtil.DoFly(type, 1, icon, pos, Vector3.New(self.bagBtn.transform.position.x, self.bagBtn.transform.position.y, self.bagBtn.transform.position.z))
    end
  end
end

function UIContinuePayMain:OnGetBigReward(data)
  self:RefreshResetBtn()
end

function UIContinuePayMain:RefreshResetBtn()
  self.resetBtn:SetActive(DataCenter.ContinuePayActivityManager:GetIsAllBoxOpen())
end

function UIContinuePayMain:CloseAniSeq()
  if self.aniSeq ~= nil then
    self.aniSeq:Kill()
    self.aniSeq = nil
  end
end

function UIContinuePayMain:OnHelpBtnClick()
  if self.activityInfo ~= nil and self.activityInfo.story ~= nil then
    local param = {}
    param.activityId = self.activityId
    param.activityRulesStr = Localization:GetString(self.activityInfo.story)
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIActivityDetailPopup, {anim = true}, param)
  end
end

function UIContinuePayMain:OnAddBtnClick()
  if self.isDetailInfoExist then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIActContinuePayLackPanel, {anim = true})
  end
end

function UIContinuePayMain:OnBagBtnClick()
  if self.isDetailInfoExist then
    GoToUtil.GotoOpenView(UIWindowNames.UILWBagMain)
  end
end

function UIContinuePayMain:OnRewardBtnClick()
  if self.isDetailInfoExist then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIActContinuePayRewardPreviewPanel, {anim = true})
  end
end

function UIContinuePayMain:OnResetBtnClick()
  if self.isDetailInfoExist then
    DataCenter.ContinuePayActivityManager:RequestManualReset()
  end
end

return UIContinuePayMain
