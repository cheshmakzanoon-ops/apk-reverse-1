local UIActCrazyRockGameSettlementView = BaseClass("UIActCrazyRockGameSettlementView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local M = UIActCrazyRockGameSettlementView
local gradeMap = {
  [1] = "Assets/Main/Sprites/UI/ActCrazyRockGameSettlement/LXY_HD_yinyuejie02_b_banner.png",
  [2] = "Assets/Main/Sprites/UI/ActCrazyRockGameSettlement/LXY_HD_yinyuejie02_1_banner.png",
  [3] = "Assets/Main/Sprites/UI/ActCrazyRockGameSettlement/LXY_HD_yinyuejie02_S_banner.png"
}

function M:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self.settleData = self:GetUserData()
  self:InitView()
end

function M:OnDestroy()
  self:ClearScroll()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function M:OnDisable()
  if UIManager:GetInstance():IsWindowOpen(UIWindowNames.CrazyRockGame) then
    UIManager:GetInstance():DestroyWindow(UIWindowNames.CrazyRockGame)
  end
  base.OnDisable(self)
end

function M:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.textFinishText1 = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 1)
  self.textFinishText2 = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 2)
  self.textFinishText3 = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 3)
  self.textFinishText4 = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 4)
  self.imgGrade = self.viewSkin:AddComponent(self, UIImage, 5)
  self.textScore = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 6)
  self.textScoreNum = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 7)
  self.textRate = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 8)
  self.textRewardTitle = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 9)
  self.btnGoTo = self.viewSkin:AddComponent(self, UIButton, 10)
  self.btnGoTo:SetOnClick(function()
    self:OnBtnGoToClick()
  end)
  self.textGoToBtn = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 11)
  self.btnShare = self.viewSkin:AddComponent(self, UIButton, 12)
  self.btnShare:SetOnClick(function()
    self:OnBtnShareClick()
  end)
  self.compNewRecordNode = self.viewSkin:AddComponent(self, UIBaseComponent, 13)
  self.textNewRecord = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 14)
  self.rewardScroll = self.viewSkin:AddComponent(self, UILoopListView2, 15)
  self.compContent = self.viewSkin:AddComponent(self, UIBaseContainer, 16)
  self.rewardScroll:InitListView(0, function(loopView, index)
    return self:OnGetItemByIndex(loopView, index)
  end)
end

function M:ComponentDestroy()
  self.viewSkin = nil
  self.textFinishText1 = nil
  self.textFinishText2 = nil
  self.textFinishText3 = nil
  self.textFinishText4 = nil
  self.imgGrade = nil
  self.textScore = nil
  self.textScoreNum = nil
  self.textRate = nil
  self.textRewardTitle = nil
  self.btnGoTo = nil
  self.textGoToBtn = nil
  self.btnShare = nil
  self.compNewRecordNode = nil
  self.textNewRecord = nil
  self.rewardScroll = nil
  self.compContent = nil
end

function M:DataDefine()
  self.settleData = {}
  self.rewardList = {}
end

function M:DataDestroy()
  self.settleData = nil
  self.rewardList = nil
end

function M:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.OpenUI, self.OnOpenUIAction)
end

function M:OnRemoveListener()
  base.OnRemoveListener(self)
  self:RemoveUIListener(EventId.OpenUI, self.OnOpenUIAction)
end

function M:OnBtnGoToClick()
  self.ctrl:CloseSelf()
end

function M:OnBtnShareClick()
  local ifShare = DataCenter.ActCrazyRockDataManager:GetIfShareScore(self.settleData.activityId)
  if ifShare then
    local score = self.settleData and self.settleData.score or 0
    local rate = self.settleData and self.settleData.surpass or 0
    DataCenter.ActCrazyRockDataManager:ShareToChat(score, rate)
  else
    local cd = DataCenter.ActCrazyRockDataManager:GetDeltaTime(self.settleData.activityId)
    UIUtil.ShowTips(Localization:GetString("activity_concert_65", cd))
  end
end

function M:InitView()
  self:InitLocalization()
  self:RefreshView()
end

function M:OnGetItemByIndex(loopScroll, index)
  index = index + 1
  if index < 1 or index > #self.rewardList then
    return nil
  end
  self.itemIndex = self.itemIndex or 0
  local data = self.rewardList[index]
  local item = loopScroll:NewListViewItem("UICommonResItem")
  local cell = self.compContent:GetComponent(item.gameObject.name, UICommonResItem)
  if cell == nil then
    item.name = tostring(self.itemIndex)
    self.itemIndex = self.itemIndex + 1
    if not item.IsInitHandlerCalled then
      item.IsInitHandlerCalled = true
    end
    cell = self.compContent:AddComponent(UICommonResItem, item.name)
  end
  cell:SetLocalScaleXYZ(0.75, 0.8, 1)
  cell:SetSizeDelta(Vector2.New(118, 118))
  cell:SetActive(true)
  cell:ParseInfo(data)
  return item
end

function M:InitLocalization()
  self.textFinishText1:SetLocalText("activity_concert_45")
  self.textFinishText2:SetLocalText("activity_concert_45")
  self.textFinishText3:SetLocalText("activity_concert_45")
  self.textFinishText4:SetLocalText("activity_concert_45")
  self.textRewardTitle:SetLocalText("activity_concert_41")
  self.textGoToBtn:SetLocalText("activity_concert_42")
  self.textScore:SetLocalText("activity_concert_38")
  self.textNewRecord:SetLocalText("activity_concert_39")
end

function M:RefreshView()
  if not self.settleData then
    Logger.LogError("SettleData is nil")
    return
  end
  self.textScoreNum:SetText(self.settleData.score)
  self.compNewRecordNode:SetActive(self.settleData.isNew)
  local rateNum = string.format("<color=#FFCC00>%s</color>", self.settleData.surpass)
  local rate = Localization:GetString("activity_concert_40", rateNum)
  self.textRate:SetText(rate)
  local level = DataCenter.ActCrazyRockDataManager:GetGarde(self.settleData.score, self.settleData.activityId)
  local path = gradeMap[1]
  if level and table.containsKey(gradeMap, level) then
    path = gradeMap[level]
  end
  self.imgGrade:LoadSprite(path)
  self.rewardList = self.settleData.clientReward
  self:RefreshReward()
  self:CheckAndPlayBGMByLevel(level)
end

function M:RefreshReward()
  if not self.rewardList then
    Logger.LogError("rewardList is nil")
    return
  end
  self.rewardScroll:SetListItemCount(#self.rewardList, false, false)
  self.rewardScroll:RefreshAllShownItem()
end

function M:CheckAndPlayBGMByLevel(level)
  local activityId = self.settleData.activityId
  if not activityId or activityId < 0 then
    return
  end
  local musicConfig = DataCenter.ActCrazyRockDataManager:GetMusicConfig(activityId)
  if not musicConfig then
    return
  end
  local showTmp = LocalController:instance():getLine(TableName.CRAZY_ROCK_SHOW, musicConfig.showId)
  if not showTmp then
    Logger.LogError("showTmp is nil")
    return
  end
  if not (showTmp and showTmp.over_bgm_arr) or level > #showTmp.over_bgm_arr then
    return
  end
  DataCenter.LWSoundManager:PlaySound(showTmp.over_bgm_arr[level], false)
end

function M:ClearScroll()
  self.compContent:RemoveComponents(UICommonResItem)
  self.rewardScroll:ClearAllItems()
end

function M:OnOpenUIAction(uiName)
  if uiName == UIWindowNames.UIDisconnect then
    self.ctrl:CloseSelf()
  end
end

return M
