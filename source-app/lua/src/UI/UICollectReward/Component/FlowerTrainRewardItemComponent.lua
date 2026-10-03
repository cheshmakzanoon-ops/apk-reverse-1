local base = UIBaseContainer
local FlowerTrainRewardItemComponent = BaseClass("FlowerTrainRewardItemComponent", UIBaseContainer)
local Localization = CS.GameEntry.Localization

function FlowerTrainRewardItemComponent:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function FlowerTrainRewardItemComponent:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function FlowerTrainRewardItemComponent:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.btnCoord = self.viewSkin:AddComponent(self, UIButton, 1)
  self.btnCoord:SetOnClick(function()
    self:OnBtnCoordClick()
  end)
  self.btnClaim = self.viewSkin:AddComponent(self, UIButton, 2)
  self.btnClaim:SetOnClick(function()
    self:OnBtnClaimClick()
  end)
  self.textDesc = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 3)
  self.textTitle = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 4)
  self.textTypePointTxt = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 5)
  self.imgIcon = self.viewSkin:AddComponent(self, UIImage, 6)
  self.compTypePoint = self.viewSkin:AddComponent(self, UIBaseComponent, 7)
  self.imgTypePoint = self.viewSkin:AddComponent(self, UIImage, 8)
  self.imgTypePoint:LoadSpriteAsync("Assets/Main/Sprites/UI/FlowerTrain_Sprite/FlowerTrainCommon/wxy_25shengdan_huache_lan.png")
end

function FlowerTrainRewardItemComponent:ComponentDestroy()
  self.viewSkin = nil
  self.btnCoord = nil
  self.btnClaim = nil
  self.textDesc = nil
  self.textTitle = nil
  self.textTypePointTxt = nil
  self.imgIcon = nil
  self.compTypePoint = nil
  self.imgTypePoint = nil
end

function FlowerTrainRewardItemComponent:DataDefine()
end

function FlowerTrainRewardItemComponent:DataDestroy()
end

function FlowerTrainRewardItemComponent:OnAddListener()
  base.OnAddListener(self)
end

function FlowerTrainRewardItemComponent:OnRemoveListener()
  base.OnRemoveListener(self)
end

function FlowerTrainRewardItemComponent:OnBtnCoordClick()
  if self.singlePlayerFlowerTrainData == nil then
    return
  end
  local marchUuid = self.singlePlayerFlowerTrainData:GetMarchUuid()
  local serverId = self.singlePlayerFlowerTrainData.serverId
  local worldId = LuaEntry.Player:GetCurWorldId()
  FlowerTrainUtils.JumpToFlowerTrainByMarchUuid(marchUuid, serverId, worldId)
  self.view.ctrl:CloseSelf()
end

function FlowerTrainRewardItemComponent:OnBtnClaimClick()
  if not self.singlePlayerFlowerTrainData then
    Logger.LogError("FlowerTrainRewardItemComponent:OnBtnClaimClick singlePlayerFlowerTrainData is nil")
    return
  end
  local trainUuid = self.singlePlayerFlowerTrainData:GetFlowerTrainUuid()
  SFSNetwork.SendMessage(MsgDefines.FlowerTrainReceiveReward, trainUuid, 1)
end

function FlowerTrainRewardItemComponent:SetItem(index, singlePlayerFlowerTrainData)
  if not singlePlayerFlowerTrainData then
    return
  end
  self.singlePlayerFlowerTrainData = singlePlayerFlowerTrainData
  self.isArrived = self.singlePlayerFlowerTrainData:GetIsArrived()
  self:RefreshBaseInfo()
  self:RefreshFlowerTrainIcon()
  self:RefreshByArrivedState()
end

function FlowerTrainRewardItemComponent:RefreshBaseInfo()
  self.textTitle:SetLocalText(self.singlePlayerFlowerTrainData:GetFlowerTrainName())
  self:RefreshFlowerTrainIcon()
end

function FlowerTrainRewardItemComponent:RefreshFlowerTrainIcon()
  local iconPath = self.singlePlayerFlowerTrainData:GetFlowerTrainIcon4CollectRewardView()
  if not iconPath or iconPath == "" then
    Logger.LogError("FlowerTrainRewardItemComponent:RefreshFlowerTrainIcon iconPath is nil")
    return
  end
  self.imgIcon:LoadSpriteAsync(iconPath)
end

function FlowerTrainRewardItemComponent:RefreshByArrivedState()
  self.state = self.singlePlayerFlowerTrainData:GetCurState()
  if self.state == FlowerTrainState.Arrived then
    self:RefreshArrivedState()
  elseif self.state == FlowerTrainState.WaitingReward then
    self:RefreshWaitingRewardState()
  else
    self:RefreshNormalState()
  end
  self.compTypePoint:SetActive(self.state == FlowerTrainState.Arrived)
end

function FlowerTrainRewardItemComponent:RefreshNormalState()
  self.btnCoord:SetActive(true)
  self.btnClaim:SetActive(false)
  if not self.singlePlayerFlowerTrainData then
    return
  end
  local arriveTime = self.singlePlayerFlowerTrainData:GetArrivedTime() or 0
  local remainTime = arriveTime - UITimeManager:GetInstance():GetServerTime()
  local remainTimeStr = UITimeManager:GetInstance():SecondToFmtString(remainTime / 1000)
  self.textDesc:SetLocalText("2025halloween_rewardboard_desc2", remainTimeStr)
end

function FlowerTrainRewardItemComponent:RefreshWaitingRewardState()
  self.btnCoord:SetActive(true)
  self.btnClaim:SetActive(false)
  if not self.singlePlayerFlowerTrainData then
    return
  end
  local nextThrowLvBoxTime = self.singlePlayerFlowerTrainData:GetNextThrowLvBoxTime() or 0
  local remainTime = nextThrowLvBoxTime - UITimeManager:GetInstance():GetServerTime()
  local remainTimeStr = UITimeManager:GetInstance():SecondToFmtString(remainTime / 1000)
  self.textDesc:SetLocalText("2025halloween_treasure_list_desc3", remainTimeStr)
end

function FlowerTrainRewardItemComponent:RefreshArrivedState()
  self.btnCoord:SetActive(false)
  self.btnClaim:SetActive(true)
  self.textDesc:SetLocalText("2025halloween_rewardboard_desc3")
  if not self.singlePlayerFlowerTrainData then
    return
  end
end

function FlowerTrainRewardItemComponent:Update1000MS()
  if self.singlePlayerFlowerTrainData == nil then
    return
  end
  self:RefreshByArrivedState()
end

return FlowerTrainRewardItemComponent
