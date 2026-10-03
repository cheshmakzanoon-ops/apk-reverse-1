local PickGarbageView = BaseClass("PickGarbageView", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local MailRewardItem = require("UI.UIMailNew.UIMailMainPanel.Component.MailRewardItem")
local rapidjson = require("rapidjson")
local _cp_txtMainTitle = "UIMailItemTitle/txtMainTitle"
local _cp_txtSubTitle = "UIMailItemTitle/txtSubTitle"
local _cp_txtTime = "Reward/Info/timeText"
local _cp_txtDesc = "Reward/Info/txtDesc"
local _cp_posText_path = "Reward/Info/posText"
local _cp_objReward = "Reward/objRewardNode"

function PickGarbageView:OnCreate()
  base.OnCreate(self)
  self._txtMainTitle = self:AddComponent(UIText, _cp_txtMainTitle)
  self._txtSubTitle = self:AddComponent(UIText, _cp_txtSubTitle)
  self._txtTime = self:AddComponent(UIText, _cp_txtTime)
  self._txtDesc = self:AddComponent(UIText, _cp_txtDesc)
  self._objReward = self:AddComponent(UIBaseContainer, _cp_objReward)
  self._posText = self:AddComponent(UIText, _cp_posText_path)
  self.cell_prefab = self.transform:Find("MailRewardItem").gameObject
  self.cell_prefab:GameObjectCreatePool()
end

function PickGarbageView:OnDisable()
  self._objReward:RemoveComponents(MailRewardItem)
  self.cell_prefab.gameObject:GameObjectRecycleAll()
  base.OnDisable(self)
end

function PickGarbageView:setData(maildata)
  self._mailData = maildata
  local _strTitle = MailShowHelper.GetMainTitle(maildata)
  self._txtMainTitle:SetText(_strTitle)
  local _strSubTitle = MailShowHelper.GetMailSubTitle(maildata)
  self._txtSubTitle:SetText(_strSubTitle)
  local _strTime = MailShowHelper.GetAbstractCreateTime(maildata)
  self._txtTime:SetText(_strTime)
  local _strContents = self:GetEventDescription(maildata)
  self._txtDesc:SetText(_strContents)
  self._objReward:SetActive(true)
  self.cell_prefab.gameObject:GameObjectRecycleAll()
  self:ShowReward(maildata)
end

function PickGarbageView:ShowRewardItem(rewardData)
  local objName = tostring(NameCount)
  NameCount = NameCount + 1
  local item = self.cell_prefab:GameObjectSpawn(self._objReward.transform)
  item.name = objName
  local obj = self._objReward:AddComponent(MailRewardItem, item.name)
  obj:RefreshData(rewardData)
end

function PickGarbageView:ShowReward(maildata)
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
  if reward ~= nil and reward.rewardInfo ~= nil then
    local rewardList = self:GetRewardItemList(reward.rewardInfo)
    for _, param in pairs(rewardList) do
      totalCnt = totalCnt + 1
      self:ShowRewardItem(param)
    end
  end
  return totalCnt
end

function PickGarbageView:GetRewardItemList(tabReward)
  local tabItemReward = {}
  if type(tabReward) ~= "table" then
    return tabItemReward
  end
  for _, iteminfo in pairs(tabReward) do
    local tmp = {}
    tmp.rewardType = iteminfo.type
    tmp.itemId = iteminfo.id
    tmp.count = iteminfo.num
    table.insert(tabItemReward, tmp)
  end
  return tabItemReward
end

function PickGarbageView:GetEventDescription(maildata)
  local mailExt = maildata:GetMailExt()
  if mailExt ~= nil then
    return mailExt:GetDescription()
  end
  return ""
end

return PickGarbageView
