local MailRewardItem = require("UI.UIMailNew.UIMailMainPanel.Component.MailRewardItem")
local MailBattleUserResult = BaseClass("MailBattleUserResult", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local Setting = CS.GameEntry.Setting
local _cp_ObjUserWin = "ObjUserWin"
local _cp_txtRewardTitle = "ObjUserWin/txtRewardTitle"
local _cp_ObjRewardNode = "ObjUserWin/ScrollView/Viewport/ObjRewardNode"
local OriginHeight = 30
local ItemCellHeight = 100
local OneRowCellCnt = 3
local OriginSize_Width = 765

function MailBattleUserResult:DataDefine()
  self._totalItemCnt = 0
  self.battleResult = FightResult.DEFAULT
end

function MailBattleUserResult:OnCreate()
  base.OnCreate(self)
  self:DataDefine()
  self._objUserWin = self:AddComponent(UIBaseContainer, _cp_ObjUserWin)
  self._txtRewardTitle = self:AddComponent(UIText, _cp_txtRewardTitle)
  self._objRewardNode = self:AddComponent(UIBaseContainer, _cp_ObjRewardNode)
  self.item_prefab = self.transform:Find("mailRewardItem").gameObject
  self.item_prefab:GameObjectCreatePool()
end

function MailBattleUserResult:OnEnable()
  base.OnEnable(self)
end

function MailBattleUserResult:OnDisable()
  self:ReleaseAllRewardItem()
  base.OnDisable(self)
end

function MailBattleUserResult:ReleaseAllRewardItem()
  self._objRewardNode:RemoveComponents(MailRewardItem)
  self.item_prefab.gameObject:GameObjectRecycleAll()
end

function MailBattleUserResult:SetData(roundBattle, maildata)
  self._roundBattle = roundBattle
  self._mailInfo = maildata
  self._totalItemCnt = 0
  self:ReleaseAllRewardItem()
  local battleResult = roundBattle:GetBattleResult()
  self.battleResult = battleResult
  self._targetBattleType = roundBattle:GetTargetBattleType()
  self._txtRewardTitle:SetText("")
  if battleResult == FightResult.OTHER_WIN then
    self._objUserWin:SetActive(false)
    self._objUserWin:SetActive(false)
  elseif battleResult == FightResult.DRAW then
    self._objUserWin:SetActive(false)
  elseif self:IsMonsterMode() then
    self:ShowMonsterMode(roundBattle)
  else
    self:ShowNormalMode(roundBattle)
  end
  self:SetRealSize()
end

function MailBattleUserResult:IsMonsterMode()
  if self._targetBattleType == BattleType.Monster or self._targetBattleType == BattleType.Boss then
    return true
  end
  return false
end

function MailBattleUserResult:ShowMonsterMode(roundBattle)
  self._objUserWin:SetActive(true)
  self:ShowReward(roundBattle:GetRewardItemArr())
  self:ShowResReward(roundBattle:GetResRewardItemArr())
end

function MailBattleUserResult:ShowNormalMode(roundBattle)
  local fightRes = roundBattle:GetFightResItemArr()
  if table.count(fightRes) > 0 then
    self._objUserWin:SetActive(true)
    self:ShowResRewardByType(fightRes)
    if self._mailInfo:GetMailExt():IsMyAttackCity() then
      self._txtRewardTitle:SetLocalText(390033)
    elseif self._mailInfo:GetMailExt():IsMyProtectCity() then
      self._txtRewardTitle:SetLocalText(311137)
    else
      self._txtRewardTitle:SetText("")
    end
  else
    self._objUserWin:SetActive(false)
  end
end

function MailBattleUserResult:SetRealSize()
  local realHeight = self:GetComponentHeight()
  self.rectTransform:Set_sizeDelta(OriginSize_Width, realHeight)
end

function MailBattleUserResult:ShowResRewardByType(resArray)
  for resType, cnt in pairs(resArray) do
    local itemInfo = {
      resourceType = resType,
      itemId = resType,
      count = cnt
    }
    self._totalItemCnt = self._totalItemCnt + 1
    self:AddItemNode(itemInfo)
  end
  if self._totalItemCnt > 0 then
    self._txtRewardTitle:SetLocalText(311052)
  end
end

function MailBattleUserResult:ShowResReward(resArray)
  for itemId, cnt in pairs(resArray) do
    local itemInfo = {
      rewardType = RewardType.RESOURCE_ITEM,
      itemId = itemId,
      count = cnt
    }
    self._totalItemCnt = self._totalItemCnt + 1
    self:AddItemNode(itemInfo)
  end
  if self._totalItemCnt > 0 then
    self._txtRewardTitle:SetLocalText(311052)
  end
end

function MailBattleUserResult:ShowReward(itemArray)
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
    self._txtRewardTitle:SetLocalText(311052)
  end
end

function MailBattleUserResult:AddItemNode(itemInfo)
  local item = self.item_prefab:GameObjectSpawn(self._objRewardNode.transform)
  NameCount = NameCount + 1
  item.name = NameCount
  local obj = self._objRewardNode:AddComponent(MailRewardItem, item.name)
  obj:RefreshData(itemInfo)
end

function MailBattleUserResult:GetComponentHeight()
  if self.battleResult == FightResult.OTHER_WIN or self.battleResult == FightResult.DRAW then
    return 0
  elseif self:IsMonsterMode() then
    if self._totalItemCnt == 0 then
      return 0
    else
      return OriginHeight + ItemCellHeight
    end
  else
    local fightRes = self._roundBattle:GetFightResItemArr()
    if 0 < table.count(fightRes) then
      return OriginHeight + ItemCellHeight
    else
      return 0
    end
  end
end

return MailBattleUserResult
