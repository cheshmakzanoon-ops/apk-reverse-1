local UILWMailDetailTrainReward = BaseClass("UILWMailDetailTrainReward", UIBaseContainer)
local base = UIBaseContainer
local TrainData = require("DataCenter.LWRailway.Train.TrainData")
local rapidjson = require("rapidjson")
local MailRewardCommonItem = require("UI.UILWMail.UILWMailMain.Component.MailRewardCommonItem")

function UILWMailDetailTrainReward:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UILWMailDetailTrainReward:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UILWMailDetailTrainReward:DataDefine()
  self.mailUid = {}
  self.mailData = {}
end

function UILWMailDetailTrainReward:DataDestroy()
  self.mailUid = nil
  self.mailData = nil
end

function UILWMailDetailTrainReward:OnEnable()
  base.OnEnable(self)
end

function UILWMailDetailTrainReward:OnDisable()
  base.OnDisable(self)
end

function UILWMailDetailTrainReward:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.OnClickReceiveOneMailReward, self.OnClickReceiveReward)
end

function UILWMailDetailTrainReward:OnRemoveListener()
  base.OnRemoveListener(self)
  self:RemoveUIListener(EventId.OnClickReceiveOneMailReward, self.OnClickReceiveReward)
end

function UILWMailDetailTrainReward:ComponentDefine()
  self.title1 = self:AddComponent(UIText, "ScrollView/Viewport/Content/Title/title1")
  self.title2 = self:AddComponent(UIText, "ScrollView/Viewport/Content/Title/title2")
  self.quality = self:AddComponent(UIImage, "ScrollView/Viewport/Content/train/quality")
  self.name = self:AddComponent(UIText, "ScrollView/Viewport/Content/train/vert/name")
  self.level = self:AddComponent(UIText, "ScrollView/Viewport/Content/train/vert/level")
  self.power = self:AddComponent(UIBaseComponent, "ScrollView/Viewport/Content/train/vert/power")
  self.powerTxt = self:AddComponent(UIText, "ScrollView/Viewport/Content/train/vert/power/powerTxt")
  self.head = self:AddComponent(UICommonHead, "ScrollView/Viewport/Content/train/DriverHead")
  self.cap = self:AddComponent(UIBaseComponent, "ScrollView/Viewport/Content/train/cap")
  self.goodsContent = self:AddComponent(UIBaseContainer, "ScrollView/Viewport/Content/goods/goodsContent")
  self.reward = self:AddComponent(UIBaseComponent, "ScrollView/Viewport/Content/reward")
  self.rewardContent = self:AddComponent(UIBaseContainer, "ScrollView/Viewport/Content/reward/rewardContent")
  self.rewarditem = self.transform:Find("ScrollView/Viewport/Content/reward/rewardContent/UICommonResItem").gameObject
  self.rewarditem:GameObjectCreatePool()
  self.title3 = self:AddComponent(UIText, "ScrollView/Viewport/Content/reward/title3")
  self.trainIcon = self:AddComponent(UIRawImage, "ScrollView/Viewport/Content/train/RawImage")
end

function UILWMailDetailTrainReward:ComponentDestroy()
  self:RemoveGoods()
  self:RemoveReward()
  self.quality = nil
  self.tip1 = nil
  self.tip2 = nil
  self.heroContent = nil
  self.passengerContent = nil
  self.robItem = nil
  self.robContent = nil
end

function UILWMailDetailTrainReward:RefreshContent()
  self:RefreshData()
  self:RefreshView()
end

function UILWMailDetailTrainReward:RefreshData()
  self.mailUid = self.view.ctrl:GetCurrentMail()
  self.mailData = self.view.ctrl:GetCurrentMailData()
  local msg = rapidjson.decode(self.mailData.contents)
  self.trainData = TrainData.New(msg.obj)
  self.passenger, self.carriage, self.carriage_2 = self.trainData:GetPassengerByUid(self.mailData.toUser)
  if self.trainData.vipInfo and self.trainData.vipInfo.vipId == self.mailData.toUser then
    self.vipInfo = self.trainData.vipInfo
  end
  self.noGoods = true
end

function UILWMailDetailTrainReward:RefreshView()
  local _strTitle = MailShowHelper.GetMainTitle(self.mailData)
  self.title1:SetText(_strTitle)
  local _strSubTitle = MailShowHelper.GetMailSubTitle(self.mailData)
  self.title2:SetText(_strSubTitle)
  if self.vipInfo then
    local json = rapidjson.decode(self.mailData.contents)
    local desc = json.b.content.dialog.id
    self.title2:SetLocalText(desc, UIUtil.FormatAllianceAndName(self.trainData.abbr, self.trainData.name))
  end
  self:RefreshDriver()
  self:RefreshGoods()
  self:RefreshReward()
end

function UILWMailDetailTrainReward:RefreshDriver()
  if not self.passenger then
    Logger.LogError("Passenger\228\184\141\229\173\152\229\156\168\239\188\159")
    return
  end
  local data = self.passenger
  self.quality:LoadSprite(self.trainData:GetQualityPath())
  self.trainIcon:LoadSprite(self.trainData:GetTrainIcon())
  self.head:SetHeadAndFrame(data.uid, data.headPic, data.headPicVer, false, data.headSkinId, data.headSkinET)
  self.name:SetText(UIUtil.FormatAllianceAndName(data.abbr, data.name))
  self.level:SetText("Lv." .. data.level)
  self.cap:SetActive(data.uid == self.trainData.ownerId)
  if self.trainData.power then
    self.power:SetActive(true)
    self.powerTxt:SetText(string.GetFormattedSeparatorNum(self.trainData.power))
  else
    self.power:SetActive(false)
  end
end

function UILWMailDetailTrainReward:RemoveGoods()
  self.goodsContent:RemoveComponents(MailRewardCommonItem)
  if self.goodsReqs then
    for _, req in pairs(self.goodsReqs) do
      req:Destroy()
    end
  end
  self.goodsReqs = {}
end

function UILWMailDetailTrainReward:RefreshGoods()
  self:RemoveGoods()
  local curRewardList, lostRewardList
  if self.trainData.ownerId == self.mailData.toUser then
    curRewardList = self.trainData:GetCurRewardData()
    lostRewardList = self.trainData:GetLostRewardData()
  elseif self.vipInfo and self.vipInfo.vipId == self.mailData.toUser then
    curRewardList = self.carriage.trainGoods.cur
    lostRewardList = self.carriage.plunder
    local curRewardList_2 = self.carriage_2.trainGoods.cur
    local lostRewardList_2 = self.carriage_2.plunder
    table.move(curRewardList_2, 1, #curRewardList_2, #curRewardList + 1, curRewardList)
    table.move(lostRewardList_2, 1, #lostRewardList_2, #lostRewardList + 1, lostRewardList)
  else
    curRewardList = self.carriage.trainGoods.cur
    lostRewardList = self.carriage.plunder
  end
  local curRewardListLength = #curRewardList
  for i, data in ipairs(curRewardList) do
    self:AddOneReward(i, data)
  end
  for i, data in ipairs(lostRewardList) do
    self:AddOneReward(i + curRewardListLength, data, true)
  end
end

function UILWMailDetailTrainReward:AddOneReward(i, data, isLost)
  self.goodsReqs[i] = self:GameObjectInstantiateAsync(UIAssets.MailRewardCommonItem, function(req)
    if IsNull(req.gameObject) then
      return
    end
    local go = req.gameObject
    local index = i
    local nameStr = "MailRewardCommonItem" .. index
    go.name = nameStr
    go:SetActive(true)
    go.transform:SetParent(self.goodsContent.transform)
    go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
    local item = self.goodsContent:AddComponent(MailRewardCommonItem, nameStr)
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
    item:ReInit(param, self.mailData.rewardStatus == 1)
  end)
end

function UILWMailDetailTrainReward:RemoveReward()
  self.rewardContent:RemoveComponents(UICommonResItem)
  self.rewarditem.gameObject:GameObjectRecycleAll()
end

function UILWMailDetailTrainReward:RefreshReward(maildata)
  if self.noGoods then
    self.reward:SetActive(false)
    return
  end
  self.reward:SetActive(true)
  self.title3:SetLocalText(458554, self.trainData.name)
  self:RemoveReward()
  local pay = maildata:GetMailPay()
  local reward = maildata:GetMailReward()
  local totalCnt = 0
  if pay ~= nil then
    local goldCnt = pay.gold or 0
    if 0 < goldCnt then
      totalCnt = totalCnt + 1
      self:ShowRewardItem({
        rewardType = RewardType.GOLD,
        itemId = "gold",
        count = goldCnt
      })
    end
  end
  if reward ~= nil and 0 < table.count(reward.rewardInfo) then
    local tabReward = reward.rewardInfo
    for _, iteminfo in pairs(tabReward) do
      if iteminfo.type == RewardType.GOODS then
        local itemId = iteminfo.id
        local itemCnt = iteminfo.num
        local param = {
          rewardType = RewardType.GOODS,
          itemId = itemId,
          count = itemCnt
        }
        totalCnt = totalCnt + 1
        self:ShowRewardItem(param)
      else
        local itemId = iteminfo.id
        local itemCnt = iteminfo.num
        local param = {
          rewardType = iteminfo.type,
          itemId = itemId,
          count = itemCnt
        }
        totalCnt = totalCnt + 1
        self:ShowRewardItem(param)
      end
    end
  end
  return totalCnt
end

function UILWMailDetailTrainReward:ShowRewardItem(rewardData)
  NameCount = NameCount + 1
  local objName = rewardData.rewardType .. NameCount
  local item = self.rewarditem:GameObjectSpawn(self.rewardContent.transform)
  item.name = objName
  local obj = self.rewardContent:AddComponent(UICommonResItem, item.name)
  obj:ReInit(rewardData)
end

function UILWMailDetailTrainReward:OnClickReceiveReward()
  DataCenter.MailDataManager:SetAllAndOne(true)
  RailwayUtil.OpenTrainInfoUI(self.trainData)
end

return UILWMailDetailTrainReward
