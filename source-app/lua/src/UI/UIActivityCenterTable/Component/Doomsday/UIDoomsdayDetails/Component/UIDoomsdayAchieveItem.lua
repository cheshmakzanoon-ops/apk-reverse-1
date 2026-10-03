local base = UIBaseContainer
local UIDoomsdayAchieveItem = BaseClass("UIDoomsdayAchieveItem", base)
local compBook = {
  {
    path = "txtAchieve",
    name = "txtAchieve",
    type = UIText,
    text = ""
  },
  {
    path = "btnRecieve",
    name = "btnRecieve",
    type = UIButton,
    onClick = function(self)
      self:Recieve()
    end
  },
  {
    path = "btnRecieve/imgGray",
    name = "imgGray",
    type = UIImage,
    active = false
  },
  {
    path = "iconDone",
    name = "iconDone",
    type = nil,
    active = false
  },
  {
    path = "scroll",
    name = "scroll",
    type = UIScrollRect
  },
  {
    path = "scroll/Viewport/Content",
    name = "content",
    type = UIBaseContainer
  },
  {
    path = "scroll/itemReward",
    name = "itemReward",
    type = nil,
    active = false
  },
  {
    path = "btnRecieve/txtRecieve",
    name = "btnReceiveText",
    type = UIText,
    text = ""
  }
}

function UIDoomsdayAchieveItem:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
end

function UIDoomsdayAchieveItem:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIDoomsdayAchieveItem:OnEnable()
  base.OnEnable(self)
end

function UIDoomsdayAchieveItem:OnDisable()
  base.OnDisable(self)
end

function UIDoomsdayAchieveItem:ComponentDefine()
  self:DefineCompsByBook(compBook)
  self.itemReward:GameObjectCreatePool()
  self.rewardItems = {}
end

function UIDoomsdayAchieveItem:ComponentDestroy()
  self.content:RemoveComponents(UICommonResItem)
  self.itemReward:GameObjectRecycleAll()
  self:ClearCompsByBook(compBook)
  self.rewardItems = nil
end

function UIDoomsdayAchieveItem:Refresh(vo)
  self.vo = vo
  self.txtAchieve:SetText(vo.achieveStr)
  self.imgGray:SetActive(not vo.canRecieve and not vo.hasRecieved)
  self.btnRecieve:SetInteractable(vo.canRecieve)
  self.btnRecieve:SetActive(not vo.hasRecieved)
  self.iconDone:SetActive(vo.hasRecieved)
  if not vo.hasRecieved then
    if vo.canRecieve then
      self.btnReceiveText:SetLocalText("129054")
    else
      self.btnReceiveText:SetLocalText("doomsday_quest_not_finish_btn")
    end
  end
  local idx = 0
  for i, reward in ipairs(vo.rewards) do
    local itemComp = self.rewardItems[i]
    if not itemComp then
      local newItem = self.itemReward:GameObjectSpawn(self.content.transform)
      local itemLbl = "item_" .. i
      newItem.name = itemLbl
      itemComp = self.content:AddComponent(UICommonResItem, itemLbl)
      self.rewardItems[i] = itemComp
    end
    if not reward.VO then
      reward.VO = {
        rewardType = reward.type,
        itemId = type(reward.value) == "table" and reward.value.id or 0,
        count = type(reward.value) == "table" and reward.value.num or reward.value
      }
    end
    itemComp:SetActive(true)
    itemComp:ReInit(reward.VO)
    idx = i
  end
  for i = idx + 1, #self.rewardItems do
    local itemComp = self.rewardItems[i]
    if itemComp then
      itemComp:SetActive(false)
    end
  end
  self.scroll:StopMovement()
  self.scroll:SetHorizontalNormalizedPosition(0)
  self.scroll:SetSizeDeltaXY(math.min(530, 7 + 96 * idx), 100)
end

function UIDoomsdayAchieveItem:Recieve()
  if self.vo and self.vo.uuid and self.vo.canRecieve then
    SFSNetwork.SendMessage(MsgDefines.ActivityDoomsdayQuestReward, self.vo.uuid)
  end
end

return UIDoomsdayAchieveItem
