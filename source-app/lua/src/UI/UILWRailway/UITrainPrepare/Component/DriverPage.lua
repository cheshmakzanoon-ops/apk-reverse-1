local DriverPage = BaseClass("DriverPage", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local Park = require("UI.UILWRailway.UITrainPrepare.Component.PreparePark")

function DriverPage:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function DriverPage:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function DriverPage:ComponentDefine()
  self.park = {}
  self.park[1] = self:AddComponent(Park, "PreparePark1")
  self.park[2] = self:AddComponent(Park, "PreparePark2")
  self.park[3] = self:AddComponent(Park, "PreparePark3")
  self.bubble = self:AddComponent(UIBaseComponent, "GameObject/Bubble")
  self.official = self:AddComponent(UIImage, "GameObject/Bubble/Official")
  self.level = self:AddComponent(UIText, "GameObject/Bubble/Level")
  self.name = self:AddComponent(UIText, "GameObject/Bubble/Name")
  self.power = self:AddComponent(UIText, "GameObject/Bubble/Power")
  self.VipTrain = self:AddComponent(UIImage, "GameObject/VipTrain")
  self.VipTrainIcon = self:AddComponent(UIImage, "GameObject/VipTrain/icon")
  self.VipTrainTitleText = self:AddComponent(UIText, "GameObject/VipTrain/vipTitle")
  self.VipTrainHead = self:AddComponent(UICommonHead, "GameObject/VipTrain/vipHead")
  self.VipTrainHead:SetEnableClickShowInfo(true, true)
  self.add = self:AddComponent(UIButton, "Driver/Add")
  self.add:SetOnClick(function()
    self:OnClickAdd()
  end)
  self.head = self:AddComponent(UICommonHead, "Driver/Head")
  self.head:SetEnableClickShowInfo(true, true)
  self.rewardContent = self:AddComponent(UIBaseContainer, "Goods")
end

function DriverPage:ComponentDestroy()
  self:ClearReward()
  self.head = nil
  self.VipTrain = nil
  self.VipTrainIcon = nil
  self.VipTrainTitleText = nil
  self.VipTrainHead = nil
end

function DriverPage:DataDefine()
end

function DriverPage:DataDestroy()
end

function DriverPage:OnEnable()
  base.OnEnable(self)
end

function DriverPage:OnDisable()
  base.OnDisable(self)
end

function DriverPage:OnAddListener()
  base.OnAddListener(self)
end

function DriverPage:OnRemoveListener()
  base.OnRemoveListener(self)
end

function DriverPage:update()
end

function DriverPage:Refresh(trainData, showTeleportEffect)
  self.openType = trainData and TrainUIOpenType.Departure or TrainUIOpenType.Prepare
  trainData = trainData or DataCenter.LWAllyStationDataManager:GetTrainByPlatformId(1)
  if not trainData then
    return
  end
  if string.IsNullOrEmpty(trainData.ownerId) then
    self.bubble:SetActive(false)
    self.head:SetActive(false)
    self.add:SetActive(true)
  else
    self.head:SetActive(true)
    self.add:SetActive(false)
    self.head:SetHeadAndFrame(trainData.ownerId, trainData.pic, trainData.picVer, false, trainData.headSkinId, trainData.headSkinET)
    if trainData.vipInfo then
      self.bubble:SetActive(false)
      self.VipTrain.gameObject:SetActive(true)
      if trainData.vipInfo.vipType == 0 then
        self.VipTrain:LoadSprite("Assets/Main/Sprites/UI/UILWRailwayTrain/zxl_huochevip_fen.png")
        self.VipTrainIcon:LoadSprite("Assets/Main/Sprites/UI/UILWRailwayTrain/zxl_huochevip_xingyun.png")
        self.VipTrainTitleText:SetLocalText("alliance_train_vip002")
      elseif trainData.vipInfo.vipType == 1 then
        self.VipTrain:LoadSprite("Assets/Main/Sprites/UI/UILWRailwayTrain/zxl_huochevip_huang.png")
        self.VipTrainIcon:LoadSprite("Assets/Main/Sprites/UI/UILWRailwayTrain/zxl_huochevip_baobiao.png")
        self.VipTrainTitleText:SetLocalText("alliance_train_vip003")
      end
      self.VipTrainHead:SetHeadAndFrame(trainData.vipInfo.vipId, trainData.vipInfo.headPic, trainData.vipInfo.headPicVer, false, trainData.vipInfo.headSkinId, trainData.vipInfo.headSkinET)
    else
      self.VipTrain:SetActive(false)
      self.bubble:SetActive(true)
      self.name:SetText(trainData:GetAbbrAndName())
      self.level:SetText("Level." .. (trainData.ownerLv or LuaEntry.Player.level))
      self.power:SetText(string.GetFormattedSeperatorNum(math.floor(trainData.power)))
    end
  end
  for i = 1, 3 do
    self.park[i]:Refresh(i, trainData.teamList[i], self.openType, showTeleportEffect)
  end
  self:RefreshReward(trainData)
end

function DriverPage:OnClickAdd()
  RailwayUtil.OpenUIDriverInvite()
end

function DriverPage:ClearReward()
  self.rewardContent:RemoveComponents(UICommonResItem)
  if self.rewardReqs then
    for _, req in pairs(self.rewardReqs) do
      req:Destroy()
    end
  end
  self.rewardItems = {}
  self.rewardReqs = {}
end

function DriverPage:RefreshReward(trainData)
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

function DriverPage:AddOneReward(i, data, isLost)
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

return DriverPage
