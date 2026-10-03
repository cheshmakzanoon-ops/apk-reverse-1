local KillZombieAlChallengeRankContentBase = BaseClass("KillZombieAlChallengeRankContentBase", UIBaseContainer)
local base = UIBaseContainer
local KillZombieAlChallengeRankItemBase = require("UI.KillZombieAlChallengeRank.Component.KillZombieAlChallengeRankItemBase")
local rank_des_path = "select/rankDes"
local name_des_path = "select/nameDes"
local value_des_path = "select/valueDes"
local self_data_path = "SelfData"
local ShowListPath = "ShowListScroll"
local ShowListContentPath = "ShowListScroll/Viewport/Content"
local empty_hint_text_path = "EmptyHintText"

function KillZombieAlChallengeRankContentBase:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function KillZombieAlChallengeRankContentBase:OnDestroy()
  self:ClearScroll()
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

function KillZombieAlChallengeRankContentBase:ComponentDefine()
  self.name_des = self:AddComponent(UIText, name_des_path)
  self.value_des = self:AddComponent(UIText, value_des_path)
  self.rank_des = self:AddComponent(UIText, rank_des_path)
  self.name_des:SetLocalText(100184)
  self.value_des:SetLocalText("challenge_zombie_rank_damage")
  self.rank_des:SetLocalText(456531)
  self.showList = self:AddComponent(UILoopListView2, ShowListPath)
  self.showList:InitListView(0, function(loopView, index)
    return self:OnGetItemByIndex(loopView, index)
  end)
  self.showListContent = self:AddComponent(UIBaseContainer, ShowListContentPath)
  self.empty_hint_text = self:AddComponent(UITextMeshProUGUIEx, empty_hint_text_path)
  self.empty_hint_text:SetActive(false)
  self.empty_hint_text:SetLocalText("challenge_zombie_rank_no_data")
end

function KillZombieAlChallengeRankContentBase:ComponentDestroy()
  self.name_des = nil
  self.value_des = nil
  self.rank_des = nil
  self.self_data = nil
  self.showList = nil
  self.showListContent = nil
  self.empty_hint_text = nil
end

function KillZombieAlChallengeRankContentBase:DataDefine()
  self.itemIndex = 0
end

function KillZombieAlChallengeRankContentBase:DataDestroy()
  self.itemIndex = nil
end

function KillZombieAlChallengeRankContentBase:SetData(rankData, selfInfo)
  if rankData == nil then
    return
  end
  self:RefreshView(rankData, selfInfo)
end

function KillZombieAlChallengeRankContentBase:RefreshView(rankData, selfInfo)
  self.rankData = rankData
  self.selfInfo = selfInfo
  if self.self_data == nil then
    self.self_data = self:AddComponent(KillZombieAlChallengeRankItemBase, self_data_path)
  end
  if self.selfInfo ~= nil and #self.rankData ~= 0 then
    self.self_data:SetActive(true)
    self.self_data:SetItemShow(self.selfInfo)
  else
    self.self_data:SetActive(false)
  end
  if #self.rankData == 0 then
    self.showList:SetActive(false)
    self.empty_hint_text:SetActive(true)
  else
    self.showList:SetActive(true)
    self.empty_hint_text:SetActive(false)
    self.showList:SetListItemCount(#self.rankData, false, false)
    self.showList:RefreshAllShownItem()
  end
end

function KillZombieAlChallengeRankContentBase:OnGetItemByIndex(loopScroll, index)
  index = index + 1
  if index < 1 or index > #self.rankData then
    return nil
  end
  local ShowInfo = self.rankData[index]
  local scriptName = "UILWAlRankItem"
  local item = loopScroll:NewListViewItem(scriptName)
  local script = self.showListContent:GetComponent(item.gameObject.name, KillZombieAlChallengeRankItemBase)
  if script == nil then
    local objectName = tostring(self.itemIndex)
    self.itemIndex = self.itemIndex + 1
    item.gameObject.name = objectName
    if not item.IsInitHandlerCalled then
      item.IsInitHandlerCalled = true
    end
    script = self.showListContent:AddComponent(KillZombieAlChallengeRankItemBase, objectName)
  end
  script:SetActive(true)
  script:SetItemShow(ShowInfo)
  return item
end

function KillZombieAlChallengeRankContentBase:ClearScroll()
  self.showListContent:RemoveComponents(KillZombieAlChallengeRankItemBase)
  self.showList:ClearAllItems()
end

return KillZombieAlChallengeRankContentBase
