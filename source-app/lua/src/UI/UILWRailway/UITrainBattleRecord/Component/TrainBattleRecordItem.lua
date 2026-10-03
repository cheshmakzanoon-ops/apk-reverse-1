local TrainBattleRecordItem = BaseClass("TrainBattleRecordItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization

function TrainBattleRecordItem:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function TrainBattleRecordItem:OnDestroy()
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

function TrainBattleRecordItem:ComponentDefine()
  self.time = self:AddComponent(UIText, "time")
  self.head = self:AddComponent(UICommonHead, "head")
  self.name = self:AddComponent(UIText, "Name")
  self.level = self:AddComponent(UIText, "Level")
  self.power = self:AddComponent(UIText, "Power")
  self.replayBtn = self:AddComponent(UIButton, "ReplayBtn")
  self.replayBtn:SetOnClick(function()
    self:OnClickReplayBtn()
  end)
  self.rewardContent = self:AddComponent(UIBaseContainer, "ScrollRect/ViewPort/Content")
end

function TrainBattleRecordItem:ComponentDestroy()
end

function TrainBattleRecordItem:DataDefine()
end

function TrainBattleRecordItem:DataDestroy()
end

function TrainBattleRecordItem:Refresh(data, trainOwnerId, trainVipInfo)
  local localTime = UITimeManager:GetInstance():TimeStampToTimeForLocal(data.time)
  self.time:SetText(localTime)
  self.uuid = data.uuid
  self.head:SetHeadAndFrame(data.uid, data.headPic, data.headPicVer, false, data.headSkinId, data.headSkinET)
  self.name:SetText(UIUtil.FormatAllianceAndName(data.abbr, data.name))
  self.level:SetText("#" .. data.serverId)
  self.power:SetText(string.GetFormattedSeparatorNum(data.power))
  if trainVipInfo and trainVipInfo.vipType == TrainVipType.isBigBro then
    self.replayBtn:SetActive(LuaEntry.Player.uid == trainVipInfo.vipId or LuaEntry.Player.uid == data.uid)
  else
    self.replayBtn:SetActive(LuaEntry.Player.uid == trainOwnerId or LuaEntry.Player.uid == data.uid)
  end
  self:RefreshReward(data)
end

function TrainBattleRecordItem:OnClickReplayBtn()
  self.view:GetDetail(self.uuid)
end

function TrainBattleRecordItem:ClearReward()
  self.rewardContent:RemoveComponents(UICommonResItem)
  if self.rewardReqs then
    for _, req in pairs(self.rewardReqs) do
      req:Destroy()
    end
  end
  self.rewardReqs = {}
end

function TrainBattleRecordItem:RefreshReward(data)
  self:ClearReward()
  local curRewardList = data.plunderReward or {}
  for i, reward in ipairs(curRewardList) do
    self:AddOneReward(i, reward)
  end
end

function TrainBattleRecordItem:AddOneReward(i, data, isLost)
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
    transform:Set_localScale(0.75, 0.75, 1)
    transform:Set_pivot(0, 1)
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
  end)
end

return TrainBattleRecordItem
