local LWUIMasterySkillUseInWorldContent = BaseClass("LWUIMasterySkillUseInWorldContent", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local UIGray = CS.UIGray
local LWUIMasterySkillUseInChatCell = require("UI.LWUISkillUseInChat.Component.LWUIMasterySkillUseInChatCell")
local mastery_skill_use_in_chat_item_path = "MasterySkillUseInChatItem"
local content_path = "ScrollView/Viewport/Content"

function LWUIMasterySkillUseInWorldContent:OnCreate()
  base.OnCreate(self)
  self:DataDefine()
  self:ComponentDefine()
end

function LWUIMasterySkillUseInWorldContent:OnDestroy()
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

function LWUIMasterySkillUseInWorldContent:ComponentDefine()
  self.mastery_skill_use_in_chat_item = self:AddComponent(UIBaseComponent, mastery_skill_use_in_chat_item_path)
  self.mastery_skill_use_in_chat_item:SetActive(false)
  self.mastery_skill_use_in_chat_item.gameObject:GameObjectCreatePool()
  self.content = self:AddComponent(UIBaseContainer, content_path)
  self.allItems = {}
end

function LWUIMasterySkillUseInWorldContent:ComponentDestroy()
  self:ClearAllItem()
  self.content = nil
  self.mastery_skill_use_in_chat_item = nil
end

function LWUIMasterySkillUseInWorldContent:DataDefine()
  self.isInit = false
  self.homeId = nil
  self.usePos = nil
  self.playerUuid = nil
  self.showData = {}
end

function LWUIMasterySkillUseInWorldContent:DataDestroy()
  self.isInit = nil
  self.homeId = nil
  self.usePos = nil
  self.playerUuid = nil
  self.showData = nil
end

function LWUIMasterySkillUseInWorldContent:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.MasteryUseSkill, self.Refresh)
end

function LWUIMasterySkillUseInWorldContent:OnRemoveListener()
  self:RemoveUIListener(EventId.MasteryUseSkill, self.Refresh)
  base.OnRemoveListener(self)
end

function LWUIMasterySkillUseInWorldContent:SetData(playerUuid)
  self:TryInit(playerUuid)
  self:Refresh()
end

function LWUIMasterySkillUseInWorldContent:TryInit(playerUuid)
  if self.isInit then
    return
  end
  self.isInit = true
  self.usePos = MasterySkillUsePosType.Building
  self.playerUuid = playerUuid
  self:ClearAllItem()
  self:InitShowData()
  self:InitView()
end

local state2Order = {
  [MasterySkillState.Effect] = 1,
  [MasterySkillState.Normal] = 2,
  [MasterySkillState.CD] = 3,
  [MasterySkillState.NoUse] = 4,
  [MasterySkillState.Locked] = 5
}

function LWUIMasterySkillUseInWorldContent:InitShowData()
  local data = DataCenter.MasteryManager:GetData()
  if data == nil then
    return
  end
  self.homeId = data.home_id
  self.homeDict = DataCenter.MasteryManager:GetHomeDict(self.homeId)
  self.allShowData = DataCenter.MasteryManager:GetMasterySkillUseShowDataInChatView()
  for _, showData in ipairs(self.allShowData) do
    showData.playerUuid = self.playerUuid
  end
  table.sort(self.allShowData, function(a, b)
    local orderA = state2Order[a.tempState]
    local orderB = state2Order[b.tempState]
    if orderA ~= orderB then
      return orderA < orderB
    else
      return a.skillTemp.id < b.skillTemp.id
    end
  end)
end

function LWUIMasterySkillUseInWorldContent:InitView()
  local showNum = #self.allShowData
  if 0 < showNum then
    for i = 1, showNum do
      local item = self.mastery_skill_use_in_chat_item.gameObject:GameObjectSpawn(self.content.transform)
      item.name = i
      local obj = self.content:AddComponent(LWUIMasterySkillUseInChatCell, item.name)
      obj:SetActive(true)
      self.allItems[i] = obj
    end
  end
end

function LWUIMasterySkillUseInWorldContent:Refresh()
  for i = 1, #self.allItems do
    local item = self.allItems[i]
    local itemShowData = self.allShowData[i]
    item:SetData(itemShowData, self.usePos)
  end
end

function LWUIMasterySkillUseInWorldContent:ClearAllItem()
  self.content:RemoveComponents(LWUIMasterySkillUseInChatCell)
  self.mastery_skill_use_in_chat_item.gameObject:GameObjectRecycleAll()
  self.allItems = {}
end

return LWUIMasterySkillUseInWorldContent
