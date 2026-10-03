local base = UIBaseContainer
local UILWTruckSuperDepartureItemRender = BaseClass("UILWTruckSuperDepartureItemRender", UIBaseContainer)
local UICommonResItem = require("UI.UICommonResItem.UICommonResItemV2.UICommonResItem")
local FormationHeroItem = require("UI.UIFormation.UIFormationSelectListNew.Component.FormationHeroItem")
local Localization = CS.GameEntry.Localization
local ParamData = {
  truckIndex,
  unlock,
  truckData,
  showEffect
}
UILWTruckSuperDepartureItemRender.Param = DataClass("Param", ParamData)

function UILWTruckSuperDepartureItemRender:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UILWTruckSuperDepartureItemRender:OnDestroy()
  self:RemoveRewardList()
  self:RemoveHeroList()
  self:ClearDepartureSequence()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UILWTruckSuperDepartureItemRender:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.compLockContent = self.viewSkin:AddComponent(self, UIBaseContainer, 1)
  self.textLockNumber = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 2)
  self.textLockTips = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 3)
  self.rawImgTruckRawImage = self.viewSkin:AddComponent(self, UIRawImage, 4)
  self.textTruckNumber = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 5)
  self.imgCart = self.viewSkin:AddComponent(self, UIImage, 6)
  self.imgQuality = self.viewSkin:AddComponent(self, UIImage, 7)
  self.textTime = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 8)
  self.textArriveTips = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 9)
  self.btnSelect = self.viewSkin:AddComponent(self, UIButton, 10)
  self.btnSelect:SetOnClick(function()
    self:OnBtnSelectClick()
  end)
  self.imgSelectState = self.viewSkin:AddComponent(self, UIImage, 11)
  self.textNoQueueTips = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 12)
  self.imgFinishMask = self.viewSkin:AddComponent(self, UIImage, 13)
  self.btnReceiveReward = self.viewSkin:AddComponent(self, UIButton, 14)
  self.btnReceiveReward:SetOnClick(function()
    self:OnBtnReceiveRewardClick()
  end)
  self.scrollViewRewardScrollView = self.viewSkin:AddComponent(self, UIScrollView, 15)
  self.compSquadDispatchContent = self.viewSkin:AddComponent(self, UIBaseContainer, 16)
  self.textSquadNumber = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 17)
  self.textPower = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 18)
  self.btnSetting = self.viewSkin:AddComponent(self, UIButton, 19)
  self.btnSetting:SetOnClick(function()
    self:OnBtnSettingClick()
  end)
  self.btnDown = self.viewSkin:AddComponent(self, UIButton, 20)
  self.btnDown:SetOnClick(function()
    self:OnBtnDownClick()
  end)
  self.btnUp = self.viewSkin:AddComponent(self, UIButton, 21)
  self.btnUp:SetOnClick(function()
    self:OnBtnUpClick()
  end)
  self.scrollViewHeroScrollView = self.viewSkin:AddComponent(self, UIScrollView, 22)
  self.textEmptySquadTips = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 23)
  self.compNormalSquadContent = self.viewSkin:AddComponent(self, UIBaseContainer, 24)
  self.btnClickTruck = self.viewSkin:AddComponent(self, UIButton, 25)
  self.btnClickTruck:SetOnClick(function()
    self:OnBtnClickTruckClick()
  end)
  self.compVFXNode = self.viewSkin:AddComponent(self, UIBaseContainer, 26)
  self.simpleAnimationNormalContent = self.viewSkin:AddComponent(self, UISimpleAnimation, 27)
  self.compNormalContent = self.viewSkin:AddComponent(self, UIBaseContainer, 28)
  self.btnHighQualityTruckMark = self.viewSkin:AddComponent(self, UIButton, 29)
  self.btnHighQualityTruckMark:SetOnClick(function()
    self:OnBtnHighQualityTruckMarkClick()
  end)
  self.compVFXNode:SetActive(false)
  self.scrollViewRewardScrollView:SetOnItemMoveIn(function(itemObj, index)
    self:OnRewardItemMoveIn(itemObj, index)
  end)
  self.scrollViewRewardScrollView:SetOnItemMoveOut(function(itemObj, index)
    self:OnRewardItemMoveOut(itemObj, index)
  end)
  self.scrollViewHeroScrollView:SetFixedItemSize(93.5, 93.5)
  self.scrollViewHeroScrollView:SetOnItemMoveIn(function(itemObj, index)
    self:OnHeroItemMoveIn(itemObj, index)
  end)
  self.scrollViewHeroScrollView:SetOnItemMoveOut(function(itemObj, index)
    self:OnHeroItemMoveOut(itemObj, index)
  end)
end

function UILWTruckSuperDepartureItemRender:ComponentDestroy()
  self.viewSkin = nil
  self.compLockContent = nil
  self.textLockNumber = nil
  self.textLockTips = nil
  self.rawImgTruckRawImage = nil
  self.textTruckNumber = nil
  self.imgCart = nil
  self.imgQuality = nil
  self.textTime = nil
  self.textArriveTips = nil
  self.btnSelect = nil
  self.imgSelectState = nil
  self.textNoQueueTips = nil
  self.imgFinishMask = nil
  self.btnReceiveReward = nil
  self.scrollViewRewardScrollView = nil
  self.compSquadDispatchContent = nil
  self.textSquadNumber = nil
  self.textPower = nil
  self.btnSetting = nil
  self.btnDown = nil
  self.btnUp = nil
  self.scrollViewHeroScrollView = nil
  self.textEmptySquadTips = nil
  self.compNormalSquadContent = nil
  self.btnClickTruck = nil
  self.compVFXNode = nil
  self.simpleAnimationNormalContent = nil
  self.compNormalContent = nil
  self.btnHighQualityTruckMark = nil
end

function UILWTruckSuperDepartureItemRender:DataDefine()
  self.isUpdateTimer = false
  self.rewardShowViewDataList = nil
  self.heroShowViewDataList = nil
  self.formation = nil
  self.itemRenderIndex = 0
  self.isDuringMultiReward = false
end

function UILWTruckSuperDepartureItemRender:DataDestroy()
  self.showData = nil
  self.isUpdateTimer = nil
  self.rewardShowViewDataList = nil
  self.heroShowViewDataList = nil
  self.formation = nil
  self.itemRenderIndex = nil
  self.isDuringMultiReward = nil
end

function UILWTruckSuperDepartureItemRender:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.TruckSuperDepartureChangeFormation, self.RefreshSquadAfterChange)
  self:AddUIListener(EventId.RefreshTruckSelectShowState, self.RefreshSelectBtnState)
end

function UILWTruckSuperDepartureItemRender:OnRemoveListener()
  self:RemoveUIListener(EventId.TruckSuperDepartureChangeFormation, self.RefreshSquadAfterChange)
  self:RemoveUIListener(EventId.RefreshTruckSelectShowState, self.RefreshSelectBtnState)
  base.OnRemoveListener(self)
end

function UILWTruckSuperDepartureItemRender:InitData(itemRenderIndex, paramData)
  self:ClearDepartureSequence()
  self:SetActive(true)
  self.simpleAnimationNormalContent:Play("Default")
  self.itemRenderIndex = itemRenderIndex
  self.showData = paramData
  self.compLockContent:SetActive(not self.showData.unlock)
  self.compNormalContent:SetActive(self.showData.unlock)
  if self.showData.unlock then
    self:ShowTruckBaseInfo()
    self:ShowTruckStatus()
    local showTruckEffect = self.showData.showEffect ~= nil and self.showData.showEffect or false
    self.compVFXNode:SetActive(showTruckEffect)
    self.scrollViewRewardScrollView:SetActive(self.view.curTabType == TruckSuperDepartureTabType.Refresh)
    self.compSquadDispatchContent:SetActive(self.view.curTabType == TruckSuperDepartureTabType.Departure)
    local highQualityTruck = self.showData.truckData:GetIsContainHighGoods() or self.showData.truckData.isSpecialURQuality
    self.btnHighQualityTruckMark:SetActive(highQualityTruck)
    if self.view.curTabType == TruckSuperDepartureTabType.Refresh then
      self:ShowReward()
    else
      self:ShowSquad()
    end
  else
    self:ShowLockStatus()
  end
  self:RefreshSelectBtnState()
end

function UILWTruckSuperDepartureItemRender:Update1000MS()
  if self.showData.unlock ~= nil and self.isUpdateTimer then
    local curTime = UITimeManager:GetInstance():GetServerTime()
    local leftTime = self.showData.truckData.arriveTs - curTime
    if leftTime <= 0 then
      leftTime = 0
      self:ShowTruckStatus()
    end
    local timeStr = UITimeManager:GetInstance():MilliSecondToFmtStringWithoutDay(leftTime)
    self.textTime:SetText("<color=#61EF86>" .. timeStr .. "</color>")
  end
end

function UILWTruckSuperDepartureItemRender:ShowTruckBaseInfo()
  local bgPath = TruckSuperDepartureQualityImagePath[self.showData.truckData.quality]
  self.rawImgTruckRawImage:LoadSpriteAsync(bgPath)
  self.textTruckNumber:SetLocalText("super_trucklaunch_02", self.showData.truckData.index)
  self.imgCart:LoadSpriteAsyncWithCallback(self.showData.truckData:GetIcon(), function(sprite)
    if self.imgCart then
      self.imgCart:SetNativeSize()
    end
  end)
  self.imgQuality:LoadSpriteAsyncWithCallback(self.showData.truckData:GetQualityPath(), function(sprite)
    if self.imgQuality then
      self.imgQuality:SetNativeSize()
    end
  end)
end

function UILWTruckSuperDepartureItemRender:ShowTruckStatus()
  self.isUpdateTimer = false
  local state = self.showData.truckData:GetTrainState()
  self.textTime:SetActive(state ~= TrainState.ArrivedFinal)
  self.textArriveTips:SetActive(state == TrainState.ArrivedFinal)
  self.imgFinishMask:SetActive(state == TrainState.ArrivedFinal)
  self.btnReceiveReward:SetActive(state == TrainState.ArrivedFinal)
  if state == TrainState.BeforeDeparture then
    local time = self.showData.truckData:GetTravelTotalTime()
    local timeStr = UITimeManager:GetInstance():MilliSecondToFmtStringWithoutDay(time)
    self.textTime:SetText("<color=#FFFFFF>" .. timeStr .. "</color>")
  elseif state == TrainState.Travelling then
    if self.showData.truckData.arriveTs ~= nil then
      self.isUpdateTimer = true
      local curTime = UITimeManager:GetInstance():GetServerTime()
      local leftTime = self.showData.truckData.arriveTs - curTime
      local timeStr = UITimeManager:GetInstance():MilliSecondToFmtStringWithoutDay(leftTime)
      self.textTime:SetText("<color=#61EF86>" .. timeStr .. "</color>")
    end
  else
    self.textArriveTips:SetLocalText("super_trucklaunch_limit_03")
  end
end

function UILWTruckSuperDepartureItemRender:RefreshSelectBtnState()
  if self.showData.unlock then
    local show = self.view:GetCanSelectTruckByIndex(self.showData.truckIndex)
    self.btnSelect:SetActive(show)
    if show then
      local hasSelect = self.view:HasOption(self.showData.truckIndex)
      self.imgSelectState:SetActive(hasSelect)
    end
  else
    self.btnSelect:SetActive(false)
  end
end

function UILWTruckSuperDepartureItemRender:ShowLockStatus()
  self.textLockNumber:SetLocalText("super_trucklaunch_02", self.showData.truckIndex)
  local unlockTipsStr = DataCenter.ArmyFormationDataManager:GetFormationUnlockTipStr(self.showData.truckIndex)
  self.textLockTips:SetText(unlockTipsStr)
end

function UILWTruckSuperDepartureItemRender:GetDepartureAniTime()
  local _, animLen = self.simpleAnimationNormalContent:GetAnimationReturnTime("moveout")
  return animLen
end

function UILWTruckSuperDepartureItemRender:PlayDepartureAnimation(delayTime)
  self:ClearDepartureSequence()
  self.sequence = CS.DG.Tweening.DOTween.Sequence()
  self.sequence:AppendInterval(delayTime)
  self.sequence:AppendCallback(function()
    self.simpleAnimationNormalContent:Play("moveout")
  end)
end

function UILWTruckSuperDepartureItemRender:ClearDepartureSequence()
  if self.sequence then
    self.sequence:Kill()
    self.sequence = nil
  end
end

function UILWTruckSuperDepartureItemRender:ShowReward()
  self:RemoveRewardList()
  if self.showData.truckData then
    self.isDuringMultiReward = MultiRewardDropUtils.GetTruckCurCanEnjoyMaxMultiValue() > 1
  end
  self.rewardShowViewDataList = {}
  local truckState = self.showData.truckData:GetTrainState()
  if truckState == TrainState.BeforeDeparture then
    local fullRewardList = self.showData.truckData:GetFullRewardData()
    for i, data in ipairs(fullRewardList) do
      local rewardParam = self:CreateOneRewardParamData(data, false, truckState)
      table.insert(self.rewardShowViewDataList, rewardParam)
    end
  else
    local curRewardList = self.showData.truckData:GetCurRewardData()
    local lostRewardList = self.showData.truckData:GetLostRewardData()
    for i, data in ipairs(curRewardList) do
      local rewardParam = self:CreateOneRewardParamData(data, false, truckState)
      table.insert(self.rewardShowViewDataList, rewardParam)
    end
    for i, data in ipairs(lostRewardList) do
      if data.type ~= RewardType.METAL and data.type ~= RewardType.FOOD and data.type ~= RewardType.WOOD then
        local rewardParam = self:CreateOneRewardParamData(data, true, truckState)
        table.insert(self.rewardShowViewDataList, rewardParam)
      end
    end
  end
  local count = table.count(self.rewardShowViewDataList)
  if 0 < count then
    self.scrollViewRewardScrollView:SetTotalCount(count)
    self.scrollViewRewardScrollView:RefillCells()
  end
end

function UILWTruckSuperDepartureItemRender:CreateOneRewardParamData(rewardData, isLost, truckState)
  local param = UICommonResItem.Param.New()
  param.rewardType = rewardData.type
  if type(rewardData.value) == "table" then
    param.itemId = rewardData.value.id
    param.count = rewardData.value.num
  else
    param.itemId = rewardData.type
    param.count = rewardData.value
    local effectValue = LuaEntry.Effect:GetGameEffect(EffectDefine.LW_BASIC_RESOURCE_PRODUCT_PROMOTION)
    param.isShowArrow = 0 < effectValue
    if truckState == TrainState.BeforeDeparture then
      param.count = self.showData.truckData:CorrectResourceRewardCount(rewardData.value)
    end
  end
  param.rewardType = rewardData.type
  param.heroUuid = rewardData.heroUuid
  param.isHeroBox = rewardData.isHeroBox
  param.isDelete = isLost
  return param
end

function UILWTruckSuperDepartureItemRender:OnRewardItemMoveIn(itemObj, index)
  itemObj.name = tostring(index)
  local itemRender = self.scrollViewRewardScrollView:AddComponent(UICommonResItem, itemObj)
  if itemRender ~= nil then
    itemRender:ReInit(self.rewardShowViewDataList[index])
    if self.showData.truckData then
      local curMultiVal = self.showData.truckData.multiple
      if curMultiVal and 1 < curMultiVal and self.isDuringMultiReward then
        itemRender:ShowMultiMark(curMultiVal)
      else
        itemRender:HideMultiMark()
      end
    end
  end
end

function UILWTruckSuperDepartureItemRender:OnRewardItemMoveOut(itemObj, index)
  self.scrollViewRewardScrollView:RemoveComponent(itemObj.name, UICommonResItem)
end

function UILWTruckSuperDepartureItemRender:RemoveRewardList()
  self.scrollViewRewardScrollView:ClearCells()
  self.scrollViewRewardScrollView:RemoveComponents(UICommonResItem)
end

function UILWTruckSuperDepartureItemRender:RefreshSquadAfterChange(param)
  if param.fromTruckIndex == self.showData.truckIndex or param.toTruckIndex == self.showData.truckIndex then
    self:RefreshSelectBtnState()
    self:ShowSquad()
  end
end

function UILWTruckSuperDepartureItemRender:ShowSquad()
  self.formation = self.view:GetTruckFormation(self.showData.truckIndex)
  self.compNormalSquadContent:SetActive(self.formation ~= nil)
  self.textEmptySquadTips:SetActive(self.formation == nil)
  if self.formation == nil then
    self.textEmptySquadTips:SetText("")
  else
    self.textSquadNumber:SetText(self.formation.index)
    local power = self.formation:GetTotalCapacity()
    self.textPower:SetText(string.GetFormattedStr2(power))
    self:RefreshUpOrDownBtnState()
    self:ShowHeroList()
  end
end

function UILWTruckSuperDepartureItemRender:ShowHeroList()
  self:RemoveHeroList()
  self.heroShowViewDataList = {}
  local dominatorUuid = self.formation:GetLocalDominatorUuid()
  if dominatorUuid and 0 < dominatorUuid then
    local dominatorInfo = DataCenter.DominatorManager:GetInfoByUuid(dominatorUuid)
    if dominatorInfo then
      local data = {}
      data.isDominator = true
      data.dominatorInfo = dominatorInfo
      table.insert(self.heroShowViewDataList, data)
    end
  end
  for i = 1, 5 do
    local heroUuid = self.formation.remoteIndexToHeroDic[i]
    local data = {}
    data.isDominator = false
    data.heroUuid = heroUuid
    table.insert(self.heroShowViewDataList, data)
  end
  local count = table.count(self.heroShowViewDataList)
  if 0 < count then
    self.scrollViewHeroScrollView:SetTotalCount(count)
    self.scrollViewHeroScrollView:RefillCells()
  end
end

function UILWTruckSuperDepartureItemRender:OnHeroItemMoveIn(itemObj, index)
  itemObj.name = tostring(index)
  local itemRender = self.scrollViewHeroScrollView:AddComponent(FormationHeroItem, itemObj)
  if itemRender ~= nil then
    itemRender:SetLocalScaleXYZ(0.8, 0.8, 0.8)
    local heroShowData = self.heroShowViewDataList[index]
    local isEmpty = false
    if heroShowData.isDominator then
      itemRender:InitWithConfigId(heroShowData.dominatorInfo.dominatorId, nil, nil, heroShowData.dominatorInfo:GetCurRankLv())
      if heroShowData.dominatorInfo.dominatorId == nil then
        isEmpty = true
      end
    else
      itemRender:InitData(heroShowData.heroUuid)
      if heroShowData.heroUuid == nil then
        isEmpty = true
      end
    end
    if isEmpty then
      itemRender:SetHeroEmptyState(true)
    end
  end
end

function UILWTruckSuperDepartureItemRender:OnHeroItemMoveOut(itemObj, index)
  self.scrollViewHeroScrollView:RemoveComponent(itemObj.name, FormationHeroItem)
end

function UILWTruckSuperDepartureItemRender:RemoveHeroList()
  self.scrollViewHeroScrollView:ClearCells()
  self.scrollViewHeroScrollView:RemoveComponents(FormationHeroItem)
end

function UILWTruckSuperDepartureItemRender:RefreshUpOrDownBtnState()
  local setUpBtnGray = false
  local setDownBtnGray = false
  local preIndex = self.itemRenderIndex - 1
  local preTruckShowData = self.view:GetTruckShowDataByIndex(preIndex)
  if preTruckShowData == nil or not preTruckShowData.unlock then
    setUpBtnGray = true
  end
  local nextIndex = self.itemRenderIndex + 1
  local nextTruckShowData = self.view:GetTruckShowDataByIndex(nextIndex)
  if nextTruckShowData == nil or not nextTruckShowData.unlock then
    setDownBtnGray = true
  end
  CS.UIGray.SetGray(self.btnUp.transform, setUpBtnGray, not setUpBtnGray)
  CS.UIGray.SetGray(self.btnDown.transform, setDownBtnGray, not setDownBtnGray)
end

function UILWTruckSuperDepartureItemRender:OnBtnSelectClick()
  local select = self.view:ToggleOption(self.showData.truckIndex)
  self.imgSelectState:SetActive(select)
end

function UILWTruckSuperDepartureItemRender:OnBtnReceiveRewardClick()
  RailwayUtil.ApplyArriveReward(self.showData.truckData)
end

function UILWTruckSuperDepartureItemRender:OnBtnSettingClick()
  if self.formation then
    local param = {}
    param.curDefenceFormationIndex = self.formation.index
    param.trainUuid = self.showData.truckData.uuid
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroPVPFormation, {anim = true}, EnterHeroSquadPanelWay.TruckDeparture, param)
  end
end

function UILWTruckSuperDepartureItemRender:OnBtnDownClick()
  local nextItemRenderIndex = self.itemRenderIndex + 1
  self.view:ChangeTruckFormation(self.itemRenderIndex, nextItemRenderIndex)
end

function UILWTruckSuperDepartureItemRender:OnBtnUpClick()
  local preItemRenderIndex = self.itemRenderIndex - 1
  self.view:ChangeTruckFormation(self.itemRenderIndex, preItemRenderIndex)
end

function UILWTruckSuperDepartureItemRender:OnBtnClickTruckClick()
  local position = self.btnClickTruck:GetPosition()
  self.view:ShowTruckShowRewardBubble(position, self.showData.truckData)
end

function UILWTruckSuperDepartureItemRender:OnBtnHighQualityTruckMarkClick()
  local position = self.btnHighQualityTruckMark:GetPosition()
  self.view:ShowHighQualityTruckBubble(position)
end

return UILWTruckSuperDepartureItemRender
