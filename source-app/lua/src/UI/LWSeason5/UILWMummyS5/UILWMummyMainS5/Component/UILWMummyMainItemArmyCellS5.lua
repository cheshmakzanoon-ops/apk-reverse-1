local UILWMummyMainItemArmyCellS5 = BaseClass("UILWMummyMainItemArmyCellS5", UIButton)
local base = UIButton
local Localization = CS.GameEntry.Localization

function UILWMummyMainItemArmyCellS5:OnCreate()
  base.OnCreate(self)
  self.AnimSoldierInfoTip = nil
  self.army_node = self:AddComponent(UICommonResItem, "bg/Army")
  self.army_level = self:AddComponent(UITextMeshProUGUIEx, "bg/ArmyLevel")
  self.army_count = self:AddComponent(UITextMeshProUGUIEx, "bg/ArmyCount")
  self:SetOnClick(function()
    if self.theView then
      self.theView:TryShowSoldierInfoTip(self.theIndex % 3, self.gameObject, self.soldierId)
    end
  end)
end

function UILWMummyMainItemArmyCellS5:OnDestroy()
  if self.AnimSoldierInfoTip then
    self.AnimSoldierInfoTip:Kill()
    self.AnimSoldierInfoTip = nil
  end
  self.army_node = nil
  self.army_level = nil
  self.army_count = nil
  base.OnDestroy(self)
end

function UILWMummyMainItemArmyCellS5:ReInit(theIndex, soldierId, soldierCount, soldierLevel, view, theSoldierType)
  if soldierLevel == nil and soldierId ~= nil then
    local soldierMeta = DataCenter.SoldierDataManager:GetTemplate(soldierId)
    if soldierMeta then
      soldierLevel = soldierMeta.lv
    end
  end
  self.theIndex = theIndex
  self.theSoldierType = theSoldierType
  self.theView = view
  self.soldierId = soldierId
  if soldierLevel == nil then
    self.army_level:SetText("")
  else
    self.army_level:SetLocalText("140002", soldierLevel)
  end
  self.army_count:SetText(string.GetFormattedSeparatorNum(soldierCount or 0))
  self.army_node:ReInit({
    rewardType = RewardType.RESOURCE_ITEM,
    itemId = soldierId,
    count = soldierCount
  })
  self.army_node:SetItemCountActive(false)
  self.army_node.theSoldierType = theSoldierType
  self.army_node.fetchMummyDesc = true
end

return UILWMummyMainItemArmyCellS5
