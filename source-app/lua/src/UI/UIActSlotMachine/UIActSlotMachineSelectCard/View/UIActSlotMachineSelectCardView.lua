local UIActSlotMachineSelectCardView = BaseClass("UIActSlotMachineSelectCardView", UIBaseView)
local M = UIActSlotMachineSelectCardView
local base = UIBaseView
local UIActSlotMachineSelectCardItem = require("UI.UIActSlotMachine.UIActSlotMachineSelectCard.Component.UIActSlotMachineSelectCardItem")
local UIActSlotMachineSelectCardItemRewardFly = require("UI.UIActSlotMachine.UIActSlotMachineSelectCard.Component.UIActSlotMachineSelectCardItemRewardFly")
local UIActSlotMachineSelectCardItemRewardPreview = require("UI.UIActSlotMachine.UIActSlotMachineSelectCard.Component.UIActSlotMachineSelectCardItemRewardPreview")
local effectFlyPath = "Assets/Main/ActivityFestival/ActSlotMachine/Prefab/UIActSlotMachineSelectCardItemTrail.prefab"
local SEGMENT_COUNT = 20
local ControlPointOffset = Vector3.New(0, 100, 0)
local MinRange = -100.0
local MaxRange = 100.0
local paths = CS.System.Array.CreateInstance(typeof(CS.UnityEngine.Vector3), SEGMENT_COUNT)
local rewardStayShowTime = 1
local flyTime = 0.6
local waitHideMulitTime = 1.6
local waitClickClosePanelTime = 3
local waitOpenAni = 0
local waitSendTime = 0

function M:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self.activityId, self.boxUuid, self.isSkipApproachAnim = self:GetUserData()
  self:InitData()
  self:SetCardDefaultData()
  self.compContent:SetActive(false)
  self.titleBg:SetActive(false)
  if not self.isSkipApproachAnim then
    self.startVfx = self:AddComponent(UIVfx, "safeArea/vfxStart")
    local param = {}
    
    function param.onPlayEnd()
      self:RefreshView()
    end
    
    param.duration = 2.1
    local effectPath = VfxAssets.UIActSlotMachineSelectCard_box
    if self.activityDetailData and self.activityDetailData.infoTemp and self.activityDetailData.infoTemp.openbox_effect then
      effectPath = self.activityDetailData.infoTemp.openbox_effect
    end
    self.startVfx:PlayByOnce(effectPath, param)
    if self.animStartSoundHandle then
      DataCenter.LWSoundManager:StopSound(self.animStartSoundHandle)
      self.animStartSoundHandle = nil
    end
    self.animStartSoundHandle = DataCenter.LWSoundManager:PlaySound(202626, false)
  else
    self:RefreshView()
  end
  self.openTime = UITimeManager:GetInstance():GetServerSeconds()
  PostEventLog.Track(PostEventLog.Defines.ActSlotMachineBoxOpen, {})
end

function M:OnDestroy()
  if self.waitForceFlipCard then
    self.waitForceFlipCard:Stop()
  end
  self.isRewardFlying = nil
  self.activityId = nil
  self.boxUuid = nil
  self.isSkipApproachAnim = nil
  self.activityDetailData = nil
  self.openTime = nil
  self.boxData = nil
  self.compBoxItemList = nil
  self.compRewardPreviewList = nil
  if self.waitFlyTimer then
    self.waitFlyTimer:Stop()
    self.waitFlyTimer = nil
  end
  self:ComponentDestroy()
  self.canClickClosePanel = false
  if self.animStartSoundHandle then
    DataCenter.LWSoundManager:StopSound(self.animStartSoundHandle)
    self.animStartSoundHandle = nil
  end
  base.OnDestroy(self)
end

function M:ComponentDefine()
  self.simAnimRoot = self:AddComponent(UISimpleAnimation, "")
  self.textPanelTitle = self:AddComponent(UITextMeshProUGUIEx, "safeArea/titleBg/Layout/textPanelTitle")
  self.textPanelDesc = self:AddComponent(UITextMeshProUGUIEx, "safeArea/titleBg/textPanelDesc")
  self.titleBg = self:AddComponent(UIBaseContainer, "safeArea/titleBg")
  self.compBoxItemList = {}
  self.boxParent = self:AddComponent(UIBaseContainer, "safeArea/Content/BoxContent")
  for i = 0, self.boxParent.transform.childCount - 1 do
    local childTrans = self.boxParent.transform:GetChild(i)
    local boxItem = self.boxParent:AddComponent(UIActSlotMachineSelectCardItem, string.format("BoxItem0%s", i + 1))
    table.insert(self.compBoxItemList, boxItem)
  end
  self.textRewardTitle = self:AddComponent(UITextMeshProUGUIEx, "safeArea/Content/RewordContent/rewardTitle")
  self.textRemainTimes = self:AddComponent(UITextMeshProUGUIEx, "safeArea/Content/RemainingTimes/Times")
  self.btnDraw = self:AddComponent(UIButton, "safeArea/Content/BtnDraw")
  self.btnDraw:SetOnClick(function()
    self:OnBtnDrawClick()
  end)
  self.btnClose = self:AddComponent(UIButton, "safeArea/Content/BtnClose")
  self.btnClose:SetOnClick(function()
    self:OnBtnClaim()
  end)
  self.compRewardPreview01 = self:AddComponent(UIActSlotMachineSelectCardItemRewardPreview, "safeArea/Content/RewordContent/Rewards/BoxItem01")
  self.compRewardPreview02 = self:AddComponent(UIActSlotMachineSelectCardItemRewardPreview, "safeArea/Content/RewordContent/Rewards/BoxItem02")
  self.compRewardPreview03 = self:AddComponent(UIActSlotMachineSelectCardItemRewardPreview, "safeArea/Content/RewordContent/Rewards/BoxItem03")
  self.compRewardPreviewList = {
    self.compRewardPreview01,
    self.compRewardPreview02,
    self.compRewardPreview03
  }
  self.compEmptyFlag = self:AddComponent(UIBaseContainer, "safeArea/Content/RewordContent/EmptyFlag")
  self.compRewards = self:AddComponent(UIBaseContainer, "safeArea/Content/RewordContent/Rewards")
  self.compContent = self:AddComponent(UIBaseContainer, "safeArea/Content")
  self.lastShowMask = self:AddComponent(UIBaseContainer, "safeArea/Content/lastShowMask")
  self.lastShowMask:SetActive(false)
  for i, v in ipairs(self.compBoxItemList) do
    v:SetActive(true)
  end
end

function M:ComponentDestroy()
  self.cardRewardMap = nil
  self.boxParent:RemoveComponents(UIActSlotMachineSelectCardItem)
  self.boxParent = nil
  self.titleBg = nil
  self.simAnimRoot = nil
  self.textPanelTitle = nil
  self.textPanelDesc = nil
  self.textRewardTitle = nil
  self.textRemainTimes = nil
  self.btnDraw = nil
  self.btnClose = nil
  self.compRewardPreview01 = nil
  self.compRewardPreview02 = nil
  self.compRewardPreview03 = nil
  self.compEmptyFlag = nil
  self.compRewards = nil
  self.compContent:RemoveComponents(UIActSlotMachineSelectCardItemRewardFly)
  self.compContent = nil
  if self.flyRewardAsset then
    self:GameObjectDestroy(self.flyRewardAsset)
    self.flyRewardAsset = nil
  end
  self.flyRewardLua = nil
end

function M:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.ActSlotBoxUpdate, self.CardFlip)
  self:AddUIListener(EventId.ActSlotBlueCardBrokeApart, self.BlueCardBrokeApart)
  self:AddUIListener(EventId.ActSlotBlueCardRemainTimesEqualZero, self.RecoverResideCard)
  self:AddUIListener(EventId.ActSlotDetailData, self.ForceUpdateView)
end

function M:OnRemoveListener()
  base.OnRemoveListener(self)
  self:RemoveUIListener(EventId.ActSlotBoxUpdate, self.CardFlip)
  self:RemoveUIListener(EventId.ActSlotBlueCardBrokeApart, self.BlueCardBrokeApart)
  self:RemoveUIListener(EventId.ActSlotBlueCardRemainTimesEqualZero, self.RecoverResideCard)
  self:RemoveUIListener(EventId.ActSlotDetailData, self.ForceUpdateView)
end

function M:InitData()
  self.activityDetailData = DataCenter.ActSlotMachineDataManager:GetActData(tonumber(self.activityId))
  self.boxData = nil
  for i = 1, #self.activityDetailData.eventBox do
    if self.activityDetailData.eventBox[i].uuid == self.boxUuid then
      self.boxData = self.activityDetailData.eventBox[i]
      break
    end
  end
  if self.boxData == nil then
    Logger.LogError("UIActSlotMachineSelectCardView \230\178\161\230\156\137\229\189\147\229\137\141\231\149\140\233\157\162\229\175\185\229\186\148\231\154\132\229\174\157\231\174\177\230\149\176\230\141\174")
  end
  self.waitFlyTimer = nil
  self.flyRewardLua = nil
  self.canClickClosePanel = false
end

function M:SetCardDefaultData()
  local infoTemp = self.activityDetailData.infoTemp
  local groupId = infoTemp.eventid
  local boxTemp = DataCenter.ActSlotMachineDataManager.boxTempDict[groupId][self.boxData.id]
  local cardShowDataList = {}
  local rewardQualityDataList = string.string2array_num(boxTemp.box_reward, ";", "|")
  local rewardQualityTypeList = string.split(boxTemp.box_reward_show_para1, "|")
  local rewardQualityNumList = string.split(boxTemp.box_reward_show_para2, "|")
  local cardIndex = 1
  for i = 1, #rewardQualityNumList do
    local curRewardNum = tonumber(rewardQualityNumList[i])
    local rewardQualityData = rewardQualityDataList[i]
    local rewardQualityType = rewardQualityTypeList[i]
    for j = 1, curRewardNum do
      local cardShowData = {}
      cardShowData.rewardType = rewardQualityData[1]
      cardShowData.itemId = rewardQualityData[2]
      cardShowData.count = rewardQualityData[3]
      cardShowData.qualityType = tonumber(rewardQualityType)
      cardShowData.cardIndex = cardIndex
      cardIndex = cardIndex + 1
      cardShowData.boxData = self.boxData
      cardShowData.activityId = self.activityId
      table.insert(cardShowDataList, cardShowData)
      if self.cardRewardMap == nil then
        self.cardRewardMap = {}
      end
      if self.cardRewardMap[cardShowData.qualityType] == nil then
        self.cardRewardMap[cardShowData.qualityType] = {}
      end
      table.insert(self.cardRewardMap[cardShowData.qualityType], cardShowData)
    end
  end
  for i, v in ipairs(cardShowDataList) do
    local index = v.cardIndex
    self.compBoxItemList[index]:SetData(v)
    if self:IsCardFlippedOrBroken(index) then
      self.compBoxItemList[index]:SetActive(false)
    end
  end
end

function M:GetRewardIndex(qualityType, index)
  if self.boxData == nil then
    return nil
  end
  if qualityType == 1 then
    return self.boxData.blueBoxArr[index]
  elseif qualityType == 2 then
    return self.boxData.purpleBoxArr[index]
  elseif qualityType == 3 then
    return self.boxData.orangeBoxArr[index]
  end
end

function M:SetFlipCardRealData()
  local flipIndex = self.boxData.indexArr[#self.boxData.indexArr]
  local cardShowData = {}
  local rewardData = string.split(self.boxData.rewardArr[#self.boxData.rewardArr], ";")
  cardShowData.rewardType = tonumber(rewardData[1])
  cardShowData.itemId = tonumber(rewardData[2])
  cardShowData.count = tonumber(rewardData[3])
  cardShowData.qualityType = self.boxData.qualityArr[#self.boxData.qualityArr] + 1
  cardShowData.cardIndex = flipIndex
  cardShowData.boxData = self.boxData
  cardShowData.activityId = self.activityId
  self.compBoxItemList[flipIndex]:SetData(cardShowData)
  return flipIndex
end

function M:RefreshView()
  local infoTemp = self.activityDetailData.infoTemp
  local groupId = infoTemp.eventid
  local boxTemp = DataCenter.ActSlotMachineDataManager.boxTempDict[groupId][self.boxData.id]
  self.textPanelDesc:SetLocalText(boxTemp.box_para2)
  self:RefreshCardState()
  self:RefreshRewardsPreview()
  self:RefreshRemainTimesAndBtns()
end

function M:RefreshCardState()
  if self.isSkipApproachAnim then
    self.simAnimRoot:SampleAnimationAtTime("Default", 1)
    self.simAnimRoot:Enable(false)
    for i = 1, #self.compBoxItemList do
      self.compBoxItemList[i]:SetMultiFlagState(false)
    end
  else
    self.simAnimRoot:Enable(true)
    local curTime = UITimeManager:GetInstance():GetServerTime()
    local _, aniTime = self.simAnimRoot:PlayAnimationReturnTime("Default")
    waitOpenAni = curTime + aniTime * 1000
    
    local function waitDisableAnimator()
      self.simAnimRoot:Enable(false)
    end
    
    TimerManager:GetInstance():DelayInvoke(waitDisableAnimator, aniTime)
    for i = 1, #self.compBoxItemList do
      self.compBoxItemList[i]:SetMultiFlagState(self.boxData.multiple ~= 1)
    end
    if self.boxData.multiple ~= 1 then
      local function waitHideMulitFlag()
        if self.compBoxItemList then
          for i = 1, #self.compBoxItemList do
            self.compBoxItemList[i]:SetMultiFlagState(false)
          end
        end
      end
      
      TimerManager:GetInstance():DelayInvoke(waitHideMulitFlag, waitHideMulitTime)
    end
  end
end

function M:RefreshRewardsPreview()
  self.isRewardFlying = false
  self.compEmptyFlag:SetActive(self.boxData.rewardArr == nil or #self.boxData.rewardArr == 0)
  self.compRewards:SetActive(self.boxData.rewardArr and #self.boxData.rewardArr > 0)
  if self.boxData.rewardArr == nil or #self.boxData.rewardArr == 0 then
    return
  end
  local previewDataList = {}
  for i = 1, #self.boxData.rewardArr do
    local rewardPreviewData = {}
    local rewardData = string.split(self.boxData.rewardArr[i], ";")
    rewardPreviewData.rewardType = tonumber(rewardData[1])
    rewardPreviewData.itemId = tonumber(rewardData[2])
    rewardPreviewData.count = tonumber(rewardData[3])
    rewardPreviewData.qualityType = self.boxData.qualityArr[i] + 1
    rewardPreviewData.multiple = self.boxData.multiple
    rewardPreviewData.index = i
    table.insert(previewDataList, rewardPreviewData)
  end
  table.sort(previewDataList, function(a, b)
    if a.qualityType == b.qualityType then
      return a.index < b.index
    else
      return a.qualityType < b.qualityType
    end
  end)
  local dataCount = #previewDataList
  local compCount = #self.compRewardPreviewList
  local max = math.max(dataCount, #self.compRewardPreviewList)
  for i = 1, max do
    local showState = i <= dataCount
    if i <= compCount then
      self.compRewardPreviewList[i]:SetActive(showState)
      if showState then
        self.compRewardPreviewList[i]:SetData(previewDataList[i])
      end
    end
  end
end

function M:RefreshRemainTimesAndBtns()
  local remainDrawTimes = self.boxData.totalTimes - #self.boxData.indexArr
  if remainDrawTimes == 0 then
    self.textRemainTimes:SetLocalText("activity_slot_box_tips107", remainDrawTimes)
  else
    self.textRemainTimes:SetLocalText("activity_slot_box_tips106", remainDrawTimes)
  end
  self.btnDraw:SetActive(0 < remainDrawTimes)
  self.btnClose:SetActive(remainDrawTimes <= 0)
  if remainDrawTimes <= 0 then
    local function waitChangeClickClosePanelState()
      self.canClickClosePanel = true
    end
    
    TimerManager:GetInstance():DelayInvoke(waitChangeClickClosePanelState, waitClickClosePanelTime)
  end
end

function M:CardFlip()
  self:InitData()
  local flipIndex = self:SetFlipCardRealData()
  
  local function flyRewardCallback(cardShowData)
    local cardIndex = cardShowData.cardIndex
    local cardWorldPos = self.compBoxItemList[cardIndex]:GetPosition()
    local startPos = cardWorldPos
    local endPos = self.compEmptyFlag:GetPosition()
    self:DoFlyReward(effectFlyPath, startPos, endPos, flyTime, self.compContent.transform, function()
      self:RefreshRewardsPreview()
    end, cardShowData)
  end
  
  self.compBoxItemList[flipIndex]:SetCardFlipState(flyRewardCallback)
  self:RefreshRemainTimesAndBtns()
  local remainDrawTimes = self.boxData.totalTimes - #self.boxData.indexArr
  if remainDrawTimes <= 0 then
    self.activityDetailData:RemoveBoxUuid(self.boxData.uuid)
  end
  EventManager:GetInstance():Broadcast(EventId.ActSlotBoxRemove)
end

function M:IsCardFlippedOrBroken(index)
  for i = 1, #self.boxData.orangeBoxArr do
    if index == self.boxData.orangeBoxArr[i] then
      return true, i
    end
  end
  for i = 1, #self.boxData.purpleBoxArr do
    if index == self.boxData.purpleBoxArr[i] then
      return true, i
    end
  end
  for i = 1, #self.boxData.blueBoxArr do
    if index == self.boxData.blueBoxArr[i] then
      return true, i
    end
  end
  return false, 0
end

function M:BlueCardBrokeApart(flipIndex)
  for i = 1, #self.boxData.blueBoxArr do
    local blueCardIndex = self.boxData.blueBoxArr[i]
    if blueCardIndex ~= flipIndex then
      self.compBoxItemList[blueCardIndex]:BlueCardBrokeApart()
    end
  end
end

function M:RecoverResideCard()
  if not self.compBoxItemList then
    return
  end
  local delayTime = 1.8
  if self.waitForceFlipCard then
    self.waitForceFlipCard:Stop()
  end
  self.waitForceFlipCard = TimerManager:GetInstance():DelayInvoke(function()
    self.lastShowMask:SetActive(true)
    local showflag = {}
    for i = 1, 9 do
      showflag[i] = false
    end
    local fakeQualityFlag = {}
    if #self.boxData.orangeBoxArr > 0 then
      for i = 1, #self.boxData.orangeBoxArr do
        local index = self.boxData.orangeBoxArr[i]
        showflag[index] = true
      end
    else
      table.insert(fakeQualityFlag, 1)
    end
    if 0 < #self.boxData.blueBoxArr then
      for i = 1, #self.boxData.blueBoxArr do
        local index = self.boxData.blueBoxArr[i]
        showflag[index] = true
      end
    else
      table.insert(fakeQualityFlag, 3)
    end
    if 0 < #self.boxData.purpleBoxArr then
      for i = 1, #self.boxData.purpleBoxArr do
        local index = self.boxData.purpleBoxArr[i]
        showflag[index] = true
      end
      if #self.boxData.purpleBoxArr < 2 then
        table.insert(fakeQualityFlag, 2)
      end
    else
      table.insert(fakeQualityFlag, 2)
    end
    local fakeDataList = {}
    for _, flag in ipairs(fakeQualityFlag) do
      local list = self.cardRewardMap[flag]
      for j, k in ipairs(list) do
        table.insert(fakeDataList, k)
      end
    end
    local hasShowFlag = false
    local fakeIndex = 1
    for i, v in ipairs(showflag) do
      if showflag[i] == false then
        hasShowFlag = true
        self.compBoxItemList[i]:SetData(fakeDataList[fakeIndex])
        self.compBoxItemList[i]:ForceFlipCard()
        self.compBoxItemList[i]:SetMultiFlagState(self.boxData.multiple ~= 1)
        fakeIndex = fakeIndex + 1
      end
    end
    if hasShowFlag then
      if self.selectOverFlipSoundHandle then
        DataCenter.LWSoundManager:StopSound(self.selectOverFlipSoundHandle)
        self.selectOverFlipSoundHandle = nil
      end
      self.selectOverFlipSoundHandle = DataCenter.LWSoundManager:PlaySound(202630, false)
    end
  end, delayTime)
end

function M:DoFlyReward(path, srcPos, destPos, moveTime, parent, callback, cardShowData)
  if path == nil then
    return
  end
  self.isRewardFlying = true
  self.flyRewardAsset = self:GameObjectInstantiateAsync(path)
  self.flyRewardAsset:completed("+", function(request)
    if request.isError then
      return
    end
    local tf = request.gameObject.transform
    tf:SetParent(parent or CS.GameEntry.UIContainer)
    tf:Set_position(srcPos.x, srcPos.y, srcPos.z)
    tf:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
    self.flyRewardLua = self.compContent:GetComponent(request.gameObject.name, UIActSlotMachineSelectCardItemRewardFly)
    if self.flyRewardLua == nil or IsNull(self.flyRewardLua.gameObject) then
      if self.flyRewardLua ~= nil then
        self.compContent:RemoveComponentOnly(request.gameObject.name, UIActSlotMachineSelectCardItemRewardFly)
      end
      self.flyRewardLua = self.compContent:AddComponent(UIActSlotMachineSelectCardItemRewardFly, request.gameObject.name)
    end
    self.flyRewardLua:SetData(cardShowData)
    self.flyRewardLua:SetActive(true)
    
    local function waitFlyCallback()
      local startPos = srcPos
      local cross = Vector3.Cross(startPos, destPos)
      local controlPos = Vector3.zero
      if cross.y > 0 then
        controlPos = (startPos + destPos) * 0.5 + ControlPointOffset + Vector3.New(math.random(MinRange, MaxRange), math.random(MinRange, MaxRange), 0)
      else
        controlPos = (startPos + destPos) * 0.5 - ControlPointOffset + Vector3.New(math.random(MinRange, MaxRange), math.random(MinRange, MaxRange), 0)
      end
      local pathVec = self:Bezier2Path(startPos, controlPos, destPos)
      local seq = CS.DG.Tweening.DOTween.Sequence()
      seq:Append(tf:DOPath(pathVec, moveTime)):SetEase(CS.DG.Tweening.Ease.InOutQuad)
      
      function seq.onComplete()
        self.flyRewardLua:SetActive(false)
        if callback ~= nil then
          callback()
        end
      end
      
      DataCenter.FlyController:AddToCheckList(request, moveTime)
    end
    
    if self.waitFlyTimer then
      self.waitFlyTimer:Stop()
    end
    self.waitFlyTimer = TimerManager:GetInstance():DelayInvoke(waitFlyCallback, rewardStayShowTime)
  end)
end

function M:Bezier2Path(startPos, controlPos, endPos)
  for i = 1, SEGMENT_COUNT do
    local t = i / SEGMENT_COUNT
    local pixel = self:CalculateCubicBezierPointFor2C(t, startPos, controlPos, endPos)
    paths[i - 1] = pixel
  end
  return paths
end

function M:CalculateCubicBezierPointFor2C(t, p0, p1, p2)
  local u = 1 - t
  local tt = t * t
  local uu = u * u
  local p = uu * p0
  p = p + 2 * u * t * p1
  p = p + tt * p2
  return p
end

function M:IsActivityOver()
  local activityInfo = DataCenter.ActivityListDataManager:GetActivityDataById(self.activityId)
  if activityInfo == nil or not activityInfo:IsValid() then
    UIUtil.ShowTipsId(2000409)
    self.ctrl:CloseSelf()
    return true
  end
  return false
end

function M:OnBtnDrawClick()
  if not self:CheckCanOpenBox() then
    return
  end
  if self:IsActivityOver() then
    return
  end
  local randomIndex = self:GetRandomDrawIndex()
  self:SetWaitSendTime()
  SFSNetwork.SendMessage(MsgDefines.SlotsOpenBoxNew, tonumber(self.activityId), self.boxData.uuid, randomIndex, self.openTime)
end

function M:OnBtnClaim()
  if not self.canClickClosePanel then
    UIUtil.ShowTipsId("btn_click_alert1")
    return
  end
  local rewardList = {}
  for i = 1, #self.boxData.rewardArr do
    local reward = {}
    local rewardData = string.split(self.boxData.rewardArr[i], ";")
    reward.rewardType = tonumber(rewardData[1])
    reward.itemId = tonumber(rewardData[2])
    reward.count = tonumber(rewardData[3]) * self.boxData.multiple
    table.insert(rewardList, reward)
  end
  table.sort(rewardList, function(a, b)
    return a.count > b.count
  end)
  local param = {
    rewardList = rewardList,
    title = CS.GameEntry.Localization:GetString("128027")
  }
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIGiftPackageRewardGet, {
    anim = true,
    UIMainAnim = UIMainAnimType.LeftRightBottomHide,
    playEffect = 61010
  }, param)
  self.ctrl:CloseSelf()
end

function M:GetRandomDrawIndex()
  local exists = {}
  for i = 1, #self.boxData.indexArr do
    local cardIndex = self.boxData.indexArr[i]
    exists[cardIndex] = true
  end
  for i = 1, #self.boxData.blueBoxArr do
    local cardIndex = self.boxData.blueBoxArr[i]
    exists[cardIndex] = true
  end
  while true do
    local randNum = math.random(1, 9)
    if not exists[randNum] then
      return randNum
    end
  end
end

function M:CheckCanOpenBox()
  local curTime = UITimeManager:GetInstance():GetServerTime()
  if curTime < waitOpenAni then
    return false
  end
  if curTime < waitSendTime then
    return false
  end
  if self.boxData == nil then
    Logger.LogError("boxData is nil!")
    return false
  end
  local remainDrawTimes = self.boxData.totalTimes - #self.boxData.indexArr
  if remainDrawTimes <= 0 then
    return false
  end
  if self.isRewardFlying then
    return false
  end
  return true
end

function M:SetWaitSendTime()
  local curTime = UITimeManager:GetInstance():GetServerTime()
  waitSendTime = curTime + (rewardStayShowTime + flyTime + 1.7) * 1000
end

function M:ForceUpdateView()
  if self.waitForceFlipCard then
    self.waitForceFlipCard:Stop()
  end
  if self.waitFlyTimer then
    self.waitFlyTimer:Stop()
    self.waitFlyTimer = nil
  end
  self:InitData()
  if self.boxData == nil then
    self.ctrl:CloseSelf()
    return
  end
  self:SetCardDefaultData()
  self:RefreshView()
end

return M
