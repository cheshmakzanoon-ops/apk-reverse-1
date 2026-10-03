local MailRewardItem = require("UI.UIMailNew.UIMailMainPanel.Component.MailRewardItem")
local MailPlayerResResult = BaseClass("MailPlayerResResult", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local Setting = CS.GameEntry.Setting
local _cp_txtRewardTitle = "title/Des"
local _cp_ObjRewardNode = "Content"
local _cp_txtPlunder = "title/Plunder"
local _cp_btnPlunder = "title/PlunderBtn"

function MailPlayerResResult:DataDefine()
  self._totalItemCnt = 0
  self.battleResult = FightResult.DEFAULT
end

function MailPlayerResResult:OnCreate()
  base.OnCreate(self)
  self:DataDefine()
  self._txtRewardTitle = self:AddComponent(UIText, _cp_txtRewardTitle)
  self._objRewardNode = self:AddComponent(UIBaseContainer, _cp_ObjRewardNode)
  self._txtPlunder = self:AddComponent(UIText, _cp_txtPlunder)
  self._btnPlunder = self:AddComponent(UIButton, _cp_btnPlunder)
  self._btnPlunder:SetOnClick(function()
    self:OnPlunderClick()
  end)
  self.item_prefab = self.transform:Find("mailRewardItem").gameObject
  self.item_prefab:GameObjectCreatePool()
end

function MailPlayerResResult:OnEnable()
  base.OnEnable(self)
end

function MailPlayerResResult:OnDisable()
  self:ReleaseAllRewardItem()
  base.OnDisable(self)
end

function MailPlayerResResult:ReleaseAllRewardItem()
  self._objRewardNode:RemoveComponents(MailRewardItem)
  self.item_prefab.gameObject:GameObjectRecycleAll()
end

function MailPlayerResResult:GetResCount()
  return self._totalItemCnt
end

function MailPlayerResResult:SetData(leftFightData, rightFightData, bigRoundIndex, maildata, leftUuid, rightUuid)
  self._mailInfo = maildata
  self.leftFightData = leftFightData
  self.rightFightData = rightFightData
  self._targetBattleType = rightFightData.battleType
  self.leftUuid = leftUuid
  self.rightUuid = rightUuid
  self.selfMarchUuid = 0
  self._totalItemCnt = 0
  self:ReleaseAllRewardItem()
  local roundBattle = self._mailInfo:GetMailExt():GetFightReportByRoundIndex(bigRoundIndex)
  if roundBattle == nil then
    return
  end
  local battleResult = roundBattle:GetBattleResult()
  self.battleResult = battleResult
  self._targetBattleType = roundBattle:GetTargetBattleType()
  self._txtRewardTitle:SetText("")
  self._txtPlunder:SetText("")
  self._btnPlunder:SetActive(false)
  local plunderResRate = roundBattle:GetPlunderResRate(leftUuid)
  if plunderResRate ~= nil then
    self._txtPlunder:SetLocalText(300132, plunderResRate)
    self._btnPlunder:SetActive(true)
  end
  self:ShowNormalMode(roundBattle, self.leftUuid)
  self:ShowResReward(roundBattle:GetResRewardItemArr(self.leftUuid))
  if 0 >= self._totalItemCnt then
    self:ShowLostMode(self._mailInfo, self.rightUuid)
  end
end

function MailPlayerResResult:ShowNormalMode(roundBattle, leftUuid)
  local fightRes = roundBattle:GetFightResItemArr(leftUuid)
  if table.count(fightRes) > 0 then
    self:ShowResRewardByType(fightRes)
    self._txtRewardTitle:SetLocalText(310140)
  end
end

function MailPlayerResResult:ShowLostMode(maildata, rightUuid)
  local fightRes = maildata:GetMailExt():GetResLostListByTargetUuid(rightUuid)
  self._txtPlunder:SetText("")
  self._btnPlunder:SetActive(false)
  if table.count(fightRes) > 0 then
    self:ShowResRewardByType(fightRes)
    self._txtRewardTitle:SetLocalText(311137)
  end
  local fightResItem = maildata:GetMailExt():GetResItemLostListByTargetUuid(rightUuid)
  if table.count(fightResItem) > 0 then
    self:ShowResReward(fightResItem)
    self._txtRewardTitle:SetLocalText(311137)
  end
end

function MailPlayerResResult:ShowResRewardByType(resArray)
  for resType, cnt in pairs(resArray) do
    local itemInfo = {
      resourceType = resType,
      itemId = resType,
      count = cnt
    }
    self._totalItemCnt = self._totalItemCnt + 1
    self:AddItemNode(itemInfo)
  end
end

function MailPlayerResResult:ShowResReward(resArray)
  table.walksort(resArray, function(leftKey, rightKey)
    return rightKey < leftKey
  end, function(itemId, cnt)
    local itemInfo = {
      rewardType = RewardType.RESOURCE_ITEM,
      itemId = itemId,
      count = cnt
    }
    self._totalItemCnt = self._totalItemCnt + 1
    self:AddItemNode(itemInfo)
  end)
  if self._totalItemCnt > 0 then
    self._txtRewardTitle:SetLocalText(310140)
  end
end

function MailPlayerResResult:ShowReward(itemArray)
  for itemId, cnt in pairs(itemArray) do
    local itemInfo = {
      rewardType = RewardType.GOODS,
      itemId = itemId,
      count = cnt
    }
    self._totalItemCnt = self._totalItemCnt + 1
    self:AddItemNode(itemInfo)
  end
  if self._totalItemCnt > 0 then
    self._txtRewardTitle:SetLocalText(310140)
  end
end

function MailPlayerResResult:AddItemNode(itemInfo)
  local item = self.item_prefab:GameObjectSpawn(self._objRewardNode.transform)
  NameCount = NameCount + 1
  item.name = NameCount
  local obj = self._objRewardNode:AddComponent(MailRewardItem, item.name)
  obj:RefreshData(itemInfo, true)
end

function MailPlayerResResult:OnPlunderClick()
  local param = {}
  param.type = "desc"
  param.title = ""
  param.desc = Localization:GetString("300144")
  param.alignObject = self._btnPlunder
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIItemTips, {anim = true}, param)
end

return MailPlayerResResult
