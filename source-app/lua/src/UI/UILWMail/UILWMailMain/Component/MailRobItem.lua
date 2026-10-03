local MailRobItem = BaseClass("MailRobItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization

function MailRobItem:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function MailRobItem:OnDestroy()
  BattleReportUtil.Cancel()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function MailRobItem:ComponentDefine()
  self.time = self:AddComponent(UIText, "robber/time")
  self.name = self:AddComponent(UIText, "robber/name")
  self.power = self:AddComponent(UIText, "robber/power")
  self.win = self:AddComponent(UIText, "robber/win")
  self.win:SetLocalText("truck_tips10009")
  self.lose = self:AddComponent(UIText, "robber/lose")
  self.lose:SetLocalText("truck_tips10010")
  self.replayBtn = self:AddComponent(UIButton, "robber/ReplayBtn")
  self.replayBtn:SetOnClick(function()
    self:OnReplayBtnClick()
  end)
  self.head = self:AddComponent(UICommonHead, "robber/UIPlayerHead")
  self.head:SetEnableClickShowInfo(true, true)
  self.goods = self:AddComponent(UIBaseComponent, "goods")
  self.rewardContent = self:AddComponent(UIBaseContainer, "goods/reward/Viewport/Content")
end

function MailRobItem:ComponentDestroy()
  self.titleTxt = nil
  self.heroCells = nil
end

function MailRobItem:DataDefine()
end

function MailRobItem:DataDestroy()
end

function MailRobItem:OnEnable()
  base.OnEnable(self)
end

function MailRobItem:OnDisable()
  base.OnDisable(self)
end

function MailRobItem:OnAddListener()
  base.OnAddListener(self)
end

function MailRobItem:OnRemoveListener()
  base.OnRemoveListener(self)
end

function MailRobItem:OnReplayBtnClick()
end

function MailRobItem:SetData(data, trainUuid)
  self.data = data
  self.trainUuid = trainUuid
  self.time:SetText(UITimeManager:GetInstance():TimeStampToTimeForLocal(data.time))
  self.name:SetText(UIUtil.FormatAllianceAndName(data.abbr, data.name))
  local powerStr = Localization:GetString(GameDialogDefine.BATTLE_POWER, string.GetFormattedStr(data.power))
  self.power:SetText(powerStr)
  self.win:SetActive(not data.isWin)
  self.lose:SetActive(data.isWin)
  self.head:SetHead(data.uid, data.headPic, data.headPicVer)
  self:RefreshReward()
end

function MailRobItem:ClearReward()
  self.rewardContent:RemoveComponents(UICommonResItem)
  if self.rewardReqs then
    for _, req in pairs(self.rewardReqs) do
      req:Destroy()
    end
  end
  self.rewardItems = {}
  self.rewardReqs = {}
end

function MailRobItem:RefreshReward()
  self:ClearReward()
  local rewardList = {}
  if not table.IsNullOrEmpty(self.data.combinationPlunderReward) then
    for i, data in ipairs(self.data.combinationPlunderReward) do
      table.insert(rewardList, data)
    end
  end
  if not table.IsNullOrEmpty(self.data.retakeReward) then
    for i, data in ipairs(self.data.retakeReward) do
      data.trainRewardState = TrainRewardState.Recapture
      table.insert(rewardList, data)
    end
  end
  if rewardList and table.count(rewardList) > 0 then
    self.goods:SetActive(true)
    for i, data in ipairs(rewardList) do
      self:AddOneReward(i, data)
    end
  else
    self.goods:SetActive(false)
  end
end

function MailRobItem:AddOneReward(i, data)
  self.rewardReqs[i] = self:GameObjectInstantiateAsync(UIAssets.UICommonResItem, function(req)
    if IsNull(req.gameObject) then
      return
    end
    local go = req.gameObject
    local index = i
    local nameStr = "UICommonResItem" .. index
    go.name = nameStr
    go:SetActive(true)
    go.transform:SetParent(self.rewardContent.transform)
    go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
    go.transform:Set_sizeDelta(150, 150)
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
    if data.trainRewardState then
      param.trainRewardState = data.trainRewardState
      param.isDelete = param.trainRewardState == TrainRewardState.Recapture
    end
    item:ReInit(param)
    self.rewardItems[index] = item
  end)
end

return MailRobItem
