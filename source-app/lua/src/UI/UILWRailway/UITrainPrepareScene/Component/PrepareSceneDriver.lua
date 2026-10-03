local PrepareSceneDriver = BaseClass("PrepareSceneDriver", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization

function PrepareSceneDriver:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
end

function PrepareSceneDriver:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function PrepareSceneDriver:ComponentDefine()
  self.bubble = self:AddComponent(UIBaseComponent, "BubbleRoot/Bubble")
  self.official = self:AddComponent(UIImage, "BubbleRoot/Bubble/Official")
  self.level = self:AddComponent(UIText, "BubbleRoot/Bubble/Level")
  self.name = self:AddComponent(UIText, "BubbleRoot/Bubble/Name")
  self.power = self:AddComponent(UIText, "BubbleRoot/Bubble/Power")
  self.add = self:AddComponent(UIButton, "Add")
  self.add:SetOnClick(function()
    self:OnClickAdd()
  end)
  self.head = self:AddComponent(UICommonHead, "Head")
  self.head:SetEnableClickShowInfo(true, true)
  self.rewardContent = self:AddComponent(UIBaseContainer, "Goods")
  local layout = self.rewardContent.transform:GetComponent(typeof(CS.UnityEngine.UI.GridLayoutGroup))
  if CommonUtil.IsArabicAutoMirrorOpen() then
    layout.padding.left = 0
  else
    layout.padding.left = 33
  end
  self.bubble:SetActive(false)
  self.bubbleTipRoot = self:AddComponent(UIBaseComponent, "BubbleTip")
  self.bubbleTipText = self:AddComponent(UITextMeshProUGUIEx, "BubbleTip/BubbleTipBg/BubbleTipText")
  self.bubbleTipRoot:SetActive(false)
  self.bubbleTipText:SetText(Localization:GetString("alliance_train_014"))
  self.haveVipTipRoot = self:AddComponent(UIBaseComponent, "haveVipTip")
  self.haveVipTipRoot:SetActive(false)
  self.inviteBtn = self:AddComponent(UIButton, "InviteBtn")
  self.inviteBtn:SetOnClick(function()
    self:OnClickInvite()
  end)
  self.waitImage = self:AddComponent(UIBaseContainer, "InviteBtn/waitImage")
  self.timeText = self:AddComponent(UIText, "InviteBtn/timeText")
  self.vipImage = self:AddComponent(UIImage, "InviteBtn/Image")
  self.rect_effect = self:AddComponent(UIBaseComponent, "InviteBtn/rect_effect")
  self.canShow = true
  self.value = self:TryAddComponent(UIBaseContainer, "BubbleRoot/Value")
  self.value_text = self:TryAddComponent(UITextMeshProUGUIEx, "BubbleRoot/Value/ValueGroup/ValueText")
  if self.value then
    self.value:SetActive(false)
  end
end

function PrepareSceneDriver:ComponentDestroy()
  self:ClearReward()
  self.head = nil
  self.platform = nil
  self.trainData = nil
  self.canShow = nil
  self.value = nil
  self.value_text = nil
end

function PrepareSceneDriver:Refresh(trainData, showTeleportEffect)
  self.openType = trainData and TrainUIOpenType.Departure or TrainUIOpenType.Prepare
  trainData = trainData or DataCenter.LWAllyStationDataManager:GetTrainByPlatformId(1)
  if not trainData then
    Logger.LogInfo("PrepareSceneDriver Refresh trainData is nil")
    return
  end
  if string.IsNullOrEmpty(trainData.ownerId) then
    self.bubble:SetActive(false)
    self.head:SetActive(false)
    self.add:SetActive(true)
    self.inviteBtn:SetActive(false)
  else
    self.head:SetActive(true)
    self.add:SetActive(false)
    self.head:SetHeadAndFrame(trainData.ownerId, trainData.pic, trainData.picVer, false, trainData.headSkinId, trainData.headSkinET)
    self.name:SetText(trainData:GetAbbrAndName())
    self.level:SetText("Level." .. (trainData.ownerLv or LuaEntry.Player.level))
    self.power:SetText(string.GetFormattedSeperatorNum(math.floor(trainData.power)))
    self.inviteBtn:SetActive(self:GetVipButtonState())
  end
  self:RefreshReward(trainData)
  local platformData = DataCenter.LWAllyStationDataManager:GetPlatform(1)
  self.platformState = platformData.state
  if self.value_text and self.value and self.value:GetActive() then
    local diamondPrice = trainData:GetFullReward2DiamondPrice()
    self.value_text:SetText(string.GetFormattedSeparatorNum(diamondPrice))
  end
  self.trainData = trainData
end

function PrepareSceneDriver:HeadVisible(visible)
  if self.head then
    self.head:SetActive(visible)
  end
end

function PrepareSceneDriver:Update1000MS()
  if self.trainData and self.trainData.vipInfo then
    return
  end
  if self.platform and self.platform.vipInvite then
    local curTime = UITimeManager:GetInstance():GetServerTime()
    if self.platform.vipInvite.endTime then
      local diff = self.platform.vipInvite.endTime - curTime
      if 0 < diff then
        self.timeText:SetText(UITimeManager:GetInstance():MilliSecondToFmtString(diff))
      end
      if curTime >= self.platform.vipInvite.endTime then
        if self.inviteBtn:GetActive() and self.waitImage:GetActive() then
          self:GetVipButtonState()
        end
        return
      end
    end
  end
end

function PrepareSceneDriver:GetVipButtonState()
  local platform = DataCenter.LWAllyStationDataManager:GetPlatform(1)
  self.platform = platform
  if platform.state == TrainPlatformState.TrainWithPassenger then
    return false
  end
  local rightsOpenState = LuaEntry.DataConfig:CheckSwitch("alliance_train_vip")
  if not rightsOpenState then
    return false
  end
  self.trainData = self.trainData or DataCenter.LWAllyStationDataManager:GetTrainByPlatformId(1)
  if self.trainData == nil then
    Logger.LogInfo("PrepareSceneDriver GetVipButtonState trainData is nil")
  end
  local template = DataCenter.LWAllianceRightShowTemplateManager:GetTemplate(2001)
  local nowGiftLevel = DataCenter.AllianceGiftDataManager:GetCurLevel()
  if nowGiftLevel < tonumber(template.gift_lv) and self.trainData and self.trainData.buyFlag == 0 then
    return false
  end
  local isMyTrain = self.trainData and self.trainData:IsMyTrain()
  if isMyTrain then
    if self.trainData.vipInfo then
      return false
    elseif platform.vipInvite then
      local curTime = UITimeManager:GetInstance():GetServerTime()
      if platform.vipInvite.endTime and curTime < platform.vipInvite.endTime then
        self.waitImage:SetActive(true)
        self.timeText:SetActive(true)
        self.rect_effect:SetActive(false)
        CS.UIGray.SetGrayWithIgnore(self.inviteBtn.transform, true, "")
        return true
      else
        self.vipImage:SetMaterial(nil)
        self.waitImage:SetActive(false)
        self.timeText:SetActive(false)
        self.rect_effect:SetActive(true)
        return true
      end
    else
      self.vipImage:SetMaterial(nil)
      self.waitImage:SetActive(false)
      self.timeText:SetActive(false)
      self.rect_effect:SetActive(true)
      return true
    end
  else
    return false
  end
end

function PrepareSceneDriver:RefreshPage(curPage)
  self.rewardContent:SetActive(curPage == TrainPreparePage.Driver)
  self.inviteBtn:SetActive(curPage ~= TrainPreparePage.Driver and self:GetVipButtonState())
  local isShow = self.trainData and self.trainData:IsUR() and curPage ~= TrainPreparePage.Driver
  if self.value then
    self.value:SetActive(isShow)
  end
  if isShow and self.value_text then
    local diamondPrice = self.trainData:GetFullReward2DiamondPrice()
    self.value_text:SetText(string.GetFormattedSeparatorNum(diamondPrice))
  end
end

function PrepareSceneDriver:SetTipsState(value)
  self.canShow = value
end

function PrepareSceneDriver:OnClickAdd()
  if LuaEntry.Player:IsInAlliance() and DataCenter.AllianceBaseDataManager:IsR4orR5() then
    RailwayUtil.OpenUIDriverInvite()
  else
    UIUtil.ShowTips(Localization:GetString("alliance_train_028"))
  end
end

function PrepareSceneDriver:OnClickInvite()
  if self.waitImage:GetActive() then
    local platform = DataCenter.LWAllyStationDataManager:GetPlatform(1)
    UIUtil.ShowTips(Localization:GetString("alliance_train_vip025", platform.vipInvite.name))
    self:GetVipButtonState()
  else
    UIManager:GetInstance():OpenWindow(UIWindowNames.UITrainVIPInvitePopView, {anim = true})
  end
end

function PrepareSceneDriver:OnClickLike()
  if not self.trainData then
    return
  end
end

function PrepareSceneDriver:ClearReward()
  self.rewardContent:RemoveComponents(UICommonResItem)
  if self.rewardReqs then
    for _, req in pairs(self.rewardReqs) do
      req:Destroy()
    end
  end
  self.rewardItems = {}
  self.rewardReqs = {}
end

function PrepareSceneDriver:RefreshReward(trainData)
  self:ClearReward()
  local curRewardList = trainData:GetCurRewardByCarriageId(1)
  local lostRewardList = trainData:GetLostRewardByCarriageId(1)
  local curRewardListLength = #curRewardList
  for i, data in ipairs(curRewardList) do
    self:AddOneReward(i, data)
  end
  for i, data in ipairs(lostRewardList) do
    self:AddOneReward(i + curRewardListLength, data, true)
  end
end

function PrepareSceneDriver:AddOneReward(i, data, isLost)
  self.rewardReqs[i] = self:GameObjectInstantiateAsync(UIAssets.UICommonResItem, function(req)
    if IsNull(req.gameObject) then
      return
    end
    local go = req.gameObject
    local index = i
    local nameStr = "UICommonResItem" .. index
    go.name = nameStr
    go:SetActive(true)
    local transform = go.transform
    transform:SetParent(self.rewardContent.transform)
    transform:Set_sizeDelta(150, 150)
    local scale = self.openType == TrainUIOpenType.Prepare and 0.7 or 0.55
    transform:Set_localScale(scale, scale, 1)
    transform:Set_pivot(CommonUtil.IsArabicAutoMirrorOpen() and 1 or 0, 1)
    local item = self.rewardContent:AddComponent(UICommonResItem, nameStr)
    local param = UICommonResItem.Param.New()
    param.rewardType = data.type
    if type(data.value) == "table" then
      param.itemId = data.value.id
      param.count = data.value.num
    else
      param.itemId = data.type
      param.count = data.value
    end
    param.rewardType = data.type
    param.heroUuid = data.heroUuid
    param.isHeroBox = data.isHeroBox
    param.isDelete = isLost
    item:ReInit(param)
    self.rewardItems[index] = item
  end)
end

return PrepareSceneDriver
