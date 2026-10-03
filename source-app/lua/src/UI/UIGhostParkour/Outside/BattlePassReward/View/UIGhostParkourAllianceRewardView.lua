local UIGhostParkourAllianceRewardView = BaseClass("UIGhostParkourAllianceRewardView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local TargetItem = require("UI.UIGhostParkour.Outside.BattlePassReward.Component.GhostTargetItem")

function UIGhostParkourAllianceRewardView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:InitUI()
  self:SendMsg()
end

function UIGhostParkourAllianceRewardView:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIGhostParkourAllianceRewardView:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.textBigTitle = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 1)
  self.rawImgTitle = self.viewSkin:AddComponent(self, UIRawImage, 2)
  self.textTitle = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 3)
  self.textRemainTime = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 4)
  self.textSubTitle = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 5)
  self.textResourceNum = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 6)
  self.imgResourceIcon = self.viewSkin:AddComponent(self, UIImage, 7)
  self.targetList = self.viewSkin:AddComponent(self, UILoopListView2, 8)
  self.targetListContent = self.viewSkin:AddComponent(self, UIBaseContainer, 9)
  self.slider = self.viewSkin:AddComponent(self, UISlider, 10)
  self.btnBack = self.viewSkin:AddComponent(self, UIButton, 11)
  self.btnBack:SetOnClick(function()
    self:OnBtnBackClick()
  end)
  self.btnReceiveAll = self.viewSkin:AddComponent(self, UIButton, 12)
  self.btnReceiveAll:SetOnClick(function()
    self:OnBtnReceiveAllClick()
  end)
  self.textBtnReceiveAll = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 13)
  self.btnRank = self.viewSkin:AddComponent(self, UIButton, 14)
  self.btnRank:SetOnClick(function()
    self:OnBtnRankClick()
  end)
  self.textBtnRank = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 15)
  self.btnInfo = self.viewSkin:AddComponent(self, UIButton, 16)
  self.btnInfo:SetOnClick(function()
    self:OnBtnInfoClick()
  end)
  self.btnResBar = self.viewSkin:AddComponent(self, UIButton, 17)
  self.btnResBar:SetOnClick(function()
    self:OnBtnResBarClick()
  end)
  self.imgResourceIcon:LoadSpriteAsync("Assets/Main/Sprites/ItemIcons/lrb_YZPK_icon_yinliao.png")
  self.targetList:InitListView(0, function(loopView, index)
    return self:OnGetItemByIndex(loopView, index)
  end)
end

function UIGhostParkourAllianceRewardView:ComponentDestroy()
  self:ClearScroll()
  self.viewSkin = nil
  self.textBigTitle = nil
  self.rawImgTitle = nil
  self.textTitle = nil
  self.textRemainTime = nil
  self.textSubTitle = nil
  self.textResourceNum = nil
  self.imgResourceIcon = nil
  self.targetList = nil
  self.targetListContent = nil
  self.slider = nil
  self.btnBack = nil
  self.btnReceiveAll = nil
  self.textBtnReceiveAll = nil
  self.btnRank = nil
  self.textBtnRank = nil
  self.btnInfo = nil
  self.btnResBar = nil
end

function UIGhostParkourAllianceRewardView:DataDefine()
  self.itemIndex = 0
  self.endTime = DataCenter.LWGhostParkourDataManager:GetRoundEndTime()
end

function UIGhostParkourAllianceRewardView:DataDestroy()
  self.itemIndex = nil
  self.rechargeStages = nil
  self.curScore = nil
  self.endTime = nil
end

function UIGhostParkourAllianceRewardView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.GhostParkourAllianceBPRefresh, self.RefreshUI)
  self:AddUIListener(EventId.GhostParkourRefreshActInfoByRound, self.SendMsg)
end

function UIGhostParkourAllianceRewardView:OnRemoveListener()
  self:RemoveUIListener(EventId.GhostParkourAllianceBPRefresh, self.RefreshUI)
  self:RemoveUIListener(EventId.GhostParkourRefreshActInfoByRound, self.SendMsg)
  base.OnRemoveListener(self)
end

function UIGhostParkourAllianceRewardView:OnBtnInfoClick()
  local param = {}
  param.activityRulesStr = Localization:GetString("ghost_parkour_alliance_reward_rule")
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIActivityDetail, {anim = true}, param)
end

function UIGhostParkourAllianceRewardView:OnBtnBackClick()
  self.ctrl:CloseSelf()
end

function UIGhostParkourAllianceRewardView:OnBtnReceiveAllClick()
  DataCenter.LWGhostParkourDataManager:SendRewardGhostParkourBattlePassMessage(self.round, 0, GhostParkourPassType.Alliance)
end

function UIGhostParkourAllianceRewardView:OnBtnRankClick()
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIGhostParkourAllianceRewardRankView)
end

function UIGhostParkourAllianceRewardView:InitUI()
  self:RefreshUI()
end

function UIGhostParkourAllianceRewardView:SendMsg()
  self.round = DataCenter.LWGhostParkourDataManager:GetGhostParkourRound()
  DataCenter.LWGhostParkourDataManager:SendGetGhostParkourAllianceBattlePassMessage(self.round)
end

function UIGhostParkourAllianceRewardView:RefreshUI()
  self.endTime = DataCenter.LWGhostParkourDataManager:GetRoundEndTime()
  self.round = DataCenter.LWGhostParkourDataManager:GetGhostParkourRound()
  self.bpInfo = DataCenter.LWGhostParkourDataManager:GetAllianceBattlePassInfo(self.round)
  if self.bpInfo and self.bpInfo.allianceProgress then
    self.curScore = self.bpInfo.allianceProgress
    self:RefreshRewardList()
    self:UpdateReceiveAllBtnState()
  end
end

local itemHeight = 145
local spacing = 10

function UIGhostParkourAllianceRewardView:InitProgress(count)
  if self.slider then
    local height = count * itemHeight + spacing * (count - 1) - 60
    height = height < 0 and 0 or height
    self.slider.transform:Set_sizeDelta(36, height)
  end
end

function UIGhostParkourAllianceRewardView:OnGetItemByIndex(loopScroll, index)
  index = index + 1
  if index < 1 or index > #self.rechargeStages then
    return nil
  end
  local packData = self.rechargeStages[index]
  local item = loopScroll:NewListViewItem("TargetItem")
  local script = self.targetListContent:GetComponent(item.gameObject.name, TargetItem)
  if script == nil then
    local objectName = tostring(self.itemIndex)
    self.itemIndex = self.itemIndex + 1
    item.gameObject.name = objectName
    script = self.targetListContent:AddComponent(TargetItem, objectName)
  end
  script:SetActive(true)
  script:RefreshData(packData, self.curScore, index, #self.rechargeStages)
  return item
end

function UIGhostParkourAllianceRewardView:RefreshScore()
  self.textResourceNum:SetText(self.curScore)
  local progress = 0
  if not table.IsNullOrEmpty(self.rechargeStages) and self.targetList then
    self.targetList:RefreshAllShownItem()
    local step = 1 / #self.rechargeStages
    local firstStep = step / 2
    local num = #self.rechargeStages - 1
    if num == 0 then
      num = 1
    end
    local otherStep = (1 - firstStep) / num
    local lastNeedScore = 0
    for i, v in ipairs(self.rechargeStages) do
      local curStageStep = i == 1 and firstStep or otherStep
      local needScore = GetTableData(TableName.lw_parkour_battle_pass, v.id, "score")
      if v.state == 1 or needScore <= self.curScore then
        progress = progress + curStageStep
        lastNeedScore = needScore
      else
        progress = progress + curStageStep * (self.curScore - lastNeedScore) / (needScore - lastNeedScore)
        break
      end
    end
    progress = 1 < progress and 1 or progress
  end
  self.slider:SetValue(progress)
end

function UIGhostParkourAllianceRewardView:RefreshRewardList(jump)
  self.rechargeStages = self.bpInfo.list
  self.round = DataCenter.LWGhostParkourDataManager:GetGhostParkourRound()
  if table.IsNullOrEmpty(self.rechargeStages) then
    self.targetList:SetActive(false)
  else
    self.targetList:SetActive(true)
    self.targetList:SetListItemCount(#self.rechargeStages, false, false)
    self.targetList:RefreshAllShownItem()
    if not self.initProgress then
      self:InitProgress(#self.rechargeStages)
      self.initProgress = true
    end
    if jump then
      local jumpIndex = 1
      for i, v in ipairs(self.rechargeStages) do
        if v.state == 0 then
          jumpIndex = i
          break
        end
      end
      jumpIndex = math.max(0, jumpIndex - 1)
      self.targetList:MovePanelToItemIndex(jumpIndex)
    end
  end
  if self.curScore then
    self:RefreshScore()
  end
end

function UIGhostParkourAllianceRewardView:ClearScroll()
  self.targetListContent:RemoveComponents(TargetItem)
  self.targetList:ClearAllItems()
end

function UIGhostParkourAllianceRewardView:UpdateReceiveAllBtnState()
  local bpInfo = DataCenter.LWGhostParkourDataManager:GetAllianceBattlePassInfo(self.round)
  if bpInfo == nil then
    return
  end
  self.rechargeStages = bpInfo.list
  if table.IsNullOrEmpty(self.rechargeStages) then
    self.btnReceiveAll.gameObject:SetActive(false)
  else
    for i, v in ipairs(self.rechargeStages) do
      if v.state == TaskState.CanReceive then
        self.btnReceiveAll.gameObject:SetActive(true)
        return
      end
    end
    self.btnReceiveAll.gameObject:SetActive(false)
  end
end

function UIGhostParkourAllianceRewardView:Update1000MS()
  if not self.endTime then
    return
  end
  local curTime = UITimeManager:GetInstance():GetServerTime()
  local leftTime = self.endTime - curTime
  if leftTime < 0 then
    leftTime = 0
  end
  local countDownTimeStr = UITimeManager:GetInstance():MilliSecondToFmtString(leftTime)
  self.textRemainTime:SetText(countDownTimeStr)
end

function UIGhostParkourAllianceRewardView:OnBtnResBarClick()
  local param = DataCenter.ArrowTipParamManager:Get(ArrowTipEnumtype.Type.HeroSimpleTip)
  param.content = Localization:GetString("ghost_parkour_gold_score_rule")
  param.alignObject = self.btnResBar
  param.yPosFix = -60
  param.addPosX = 15 * CommonUtil.ArabicAutoMirrorFactor()
  param.showArrow = true
  param.preferTop = true
  param.width = 600
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroSimpleTip, {anim = true}, param)
end

return UIGhostParkourAllianceRewardView
