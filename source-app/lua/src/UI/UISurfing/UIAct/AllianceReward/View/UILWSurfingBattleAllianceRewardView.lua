local UILWSurfingBattleAllianceRewardView = BaseClass("UILWSurfingBattleAllianceRewardView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local TargetItem = require("UI.UISurfing.UIAct.AllianceReward.Component.TargetItem")

function UILWSurfingBattleAllianceRewardView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:InitUI()
end

function UILWSurfingBattleAllianceRewardView:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UILWSurfingBattleAllianceRewardView:ComponentDefine()
  self.textTopTitle = self:AddComponent(UITextMeshProUGUIEx, "TopBar/TextTitle")
  self.btnBack = self:AddComponent(UIButton, "BottomBar/BtnBack")
  self.btnBack:SetOnClick(function()
    self:OnBtnBackClick()
  end)
  self.textTitle = self:AddComponent(UITextMeshProUGUIEx, "ContentRoot/RightView/Top/title")
  self.textRemainTime = self:AddComponent(UITextMeshProUGUIEx, "ContentRoot/RightView/Top/TimeBase/RemainTime")
  self.textSubTitle = self:AddComponent(UITextMeshProUGUIEx, "ContentRoot/RightView/Top/subTitle")
  self.btnInfo = self:AddComponent(UIButton, "ContentRoot/RightView/Top/InfoBtn")
  self.btnInfo:SetOnClick(function()
    self:OnBtnInfoClick()
  end)
  self.resourceBtn = self:AddComponent(UIButton, "ContentRoot/RightView/Top/ResBar")
  self.resourceBtn:SetOnClick(function()
    self:BtnResourceOnClick()
  end)
  self.textResourceNum = self:AddComponent(UITextMeshProUGUIEx, "ContentRoot/RightView/Top/ResBar/root/resourceNum")
  self.imgResourceIcon = self:AddComponent(UIImage, "ContentRoot/RightView/Top/ResBar/root/resourceIcon")
  self.compResetTime = self:AddComponent(UIBaseComponent, "ContentRoot/RightView/Top/ResetTime")
  self.textResetDesc = self:AddComponent(UITextMeshProUGUIEx, "ContentRoot/RightView/Top/ResetTime/ResetDescText")
  self.imgResetTimeIcon = self:AddComponent(UIImage, "ContentRoot/RightView/Top/ResetTime/ResetTimeIcon")
  self.textResetCountDown = self:AddComponent(UITextMeshProUGUIEx, "ContentRoot/RightView/Top/ResetTime/ResetCountDownText")
  self.targetList = self:AddComponent(UILoopListView2, "ContentRoot/RightView/Rect_Bottom/ScrollView")
  self.targetList:InitListView(0, function(loopView, index)
    return self:OnGetItemByIndex(loopView, index)
  end)
  self.targetListContent = self:AddComponent(UILoopListView2, "ContentRoot/RightView/Rect_Bottom/ScrollView/Viewport/Content")
  self.imgViewport = self:AddComponent(UIImage, "ContentRoot/RightView/Rect_Bottom/ScrollView/Viewport")
  self.compContent = self:AddComponent(UIBaseComponent, "ContentRoot/RightView/Rect_Bottom/ScrollView/Viewport/Content")
  self.slider = self:AddComponent(UISlider, "ContentRoot/RightView/Rect_Bottom/ScrollView/Viewport/Content/Slider")
  self.compTargetItem = self:AddComponent(UIBaseComponent, "ContentRoot/RightView/Rect_Bottom/TargetItem")
  self.btnReceiveAll = self:AddComponent(UIButton, "BottomBar/btnReceiveAll")
  self.btnReceiveAll:SetOnClick(function()
    self:OnBtnReceiveAllClick()
  end)
  self.textBtnReceiveAll = self:AddComponent(UITextMeshProUGUIEx, "BottomBar/btnReceiveAll/LW_Btn_Common_New_Base/btnReceiveAllText")
  self.btnRank = self:AddComponent(UIButton, "BottomBar/BtnRank")
  self.btnRank:SetOnClick(function()
    self:OnBtnRankClick()
  end)
  self.textBtnRank = self:AddComponent(UITextMeshProUGUIEx, "BottomBar/BtnRank/BtnRankIcon/BtnRankText")
  self.imgMvp = self:AddComponent(UIButton, "BottomBar/imgMvp")
  self.imgMvp:SetOnClick(function()
    self:OnBtnRankClick()
  end)
  self.compPlayer = self:AddComponent(UICommonHead, "BottomBar/imgMvp/player")
end

function UILWSurfingBattleAllianceRewardView:ComponentDestroy()
  self:ClearScroll()
  self.textTopTitle = nil
  self.btnBack = nil
  self.textTitle = nil
  self.textRemainTime = nil
  self.textSubTitle = nil
  self.btnInfo = nil
  self.textResourceNum = nil
  self.imgResourceIcon = nil
  self.compResetTime = nil
  self.textResetDesc = nil
  self.imgResetTimeIcon = nil
  self.textResetCountDown = nil
  self.targetList = nil
  self.targetListContent = nil
  self.imgViewport = nil
  self.compContent = nil
  self.slider = nil
  self.compTargetItem = nil
  self.btnReceiveAll = nil
  self.textBtnReceiveAll = nil
  self.btnRank = nil
  self.textBtnRank = nil
  self.imgMvp = nil
  self.compPlayer = nil
end

function UILWSurfingBattleAllianceRewardView:DataDefine()
  self.itemIndex = 0
  self.mvpPlayer = nil
  self.endTime = DataCenter.LWSurfingDataManager:GetAllianceBattleEndTime()
end

function UILWSurfingBattleAllianceRewardView:DataDestroy()
  self.itemIndex = nil
  self.mvpPlayer = nil
  self.rechargeStages = nil
  self.curScore = nil
  self.endTime = nil
end

function UILWSurfingBattleAllianceRewardView:InitUI()
  self.imgResourceIcon:LoadSprite("Assets/Main/Sprites/ItemIcons/lrb_paoku_jifen_daojv.png")
  self:RefreshUI()
end

function UILWSurfingBattleAllianceRewardView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.SurfingUpdateAllianceBattlePass, self.RefreshUI)
  self:AddUIListener(EventId.SurfingRefreshActInfoByRound, self.SendMsg)
end

function UILWSurfingBattleAllianceRewardView:OnRemoveListener()
  self:RemoveUIListener(EventId.SurfingUpdateAllianceBattlePass, self.RefreshUI)
  self:RemoveUIListener(EventId.SurfingRefreshActInfoByRound, self.SendMsg)
  base.OnRemoveListener(self)
end

function UILWSurfingBattleAllianceRewardView:OnBtnBackClick()
  self.ctrl:CloseSelf()
end

function UILWSurfingBattleAllianceRewardView:OnBtnInfoClick()
  local param = {}
  param.activityRulesStr = Localization:GetString("parkour_alliance_reward_rule")
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIActivityDetail, {anim = true}, param)
end

function UILWSurfingBattleAllianceRewardView:OnBtnReceiveAllClick()
  DataCenter.LWSurfingDataManager:ReceiveRewardParkourBattlePassMessage(self.round, SurfingBattlePassType.Alliance, 0)
end

function UILWSurfingBattleAllianceRewardView:OnBtnRankClick()
  UIManager:GetInstance():OpenWindow(UIWindowNames.UILWSurfingAllianceSumRankView)
end

function UILWSurfingBattleAllianceRewardView:SendMsg()
  local round = DataCenter.LWSurfingDataManager:GetRound()
  DataCenter.LWSurfingDataManager:SendGetParkourAllianceBattlePassInfoMessage(round)
end

function UILWSurfingBattleAllianceRewardView:RefreshUI()
  self.curScore = DataCenter.LWSurfingDataManager:GetAllianceScore()
  self:RefreshRewardList()
  self:UpdateReceiveAllBtnState()
  self:UpdateMvpInfo()
end

local itemHeight = 145
local spacing = 10

function UILWSurfingBattleAllianceRewardView:InitProgress(count)
  if self.slider then
    local height = count * itemHeight + spacing * (count - 1) - 60
    height = height < 0 and 0 or height
    self.slider.transform:Set_sizeDelta(36, height)
  end
end

function UILWSurfingBattleAllianceRewardView:OnGetItemByIndex(loopScroll, index)
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

function UILWSurfingBattleAllianceRewardView:RefreshScore()
  self.textResourceNum:SetText(self.curScore)
  local progress = 0
  if not table.IsNullOrEmpty(self.rechargeStages) and self.targetList then
    local count = #self.rechargeStages
    local step = 1 / count
    local firstStep = step / 2
    local otherStep = (1 - firstStep) / (count - 1)
    local lastNeedScore = 0
    for i, v in pairs(self.rechargeStages) do
      local curStageStep = i == 1 and firstStep or otherStep
      local needScore = v.needScore
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

function UILWSurfingBattleAllianceRewardView:RefreshRewardList(jump)
  self.rechargeStages = DataCenter.LWSurfingDataManager:GetAllianceBattlePassInfo()
  self.round = DataCenter.LWSurfingDataManager:GetAllianceBattlePassRound()
  if not table.IsNullOrEmpty(self.rechargeStages) then
    for _, v in ipairs(self.rechargeStages) do
      v.needScore = DataCenter.LWSurfingDataManager:GetBattlePassScoreById(v.id)
    end
  end
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

function UILWSurfingBattleAllianceRewardView:ClearScroll()
  self.targetListContent:RemoveComponents(TargetItem)
  self.targetList:ClearAllItems()
end

function UILWSurfingBattleAllianceRewardView:UpdateReceiveAllBtnState()
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

function UILWSurfingBattleAllianceRewardView:UpdateMvpInfo()
  self.mvpPlayer = DataCenter.LWSurfingDataManager:GetMvpPlayer()
  if self.mvpPlayer then
    self.imgMvp.gameObject:SetActive(true)
    self.compPlayer:SetHeadAndFrame(self.mvpPlayer.uid, self.mvpPlayer.headPic, self.mvpPlayer.headPicVer)
  else
    self.imgMvp.gameObject:SetActive(false)
  end
end

function UILWSurfingBattleAllianceRewardView:Update1000MS()
  local curTime = UITimeManager:GetInstance():GetServerTime()
  local leftTime = self.endTime - curTime
  if leftTime < 0 then
    leftTime = 0
  end
  local countDownTimeStr = UITimeManager:GetInstance():MilliSecondToFmtString(leftTime)
  self.textRemainTime:SetText(countDownTimeStr)
end

function UILWSurfingBattleAllianceRewardView:BtnResourceOnClick()
  local param = DataCenter.ArrowTipParamManager:Get(ArrowTipEnumtype.Type.HeroSimpleTip)
  param.content = Localization:GetString("parkour_gold_score_rule")
  param.alignObject = self.resourceBtn
  param.yPosFix = -60
  param.addPosX = 15 * CommonUtil.ArabicAutoMirrorFactor()
  param.showArrow = true
  param.preferTop = true
  param.width = 600
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroSimpleTip, {anim = true}, param)
end

return UILWSurfingBattleAllianceRewardView
