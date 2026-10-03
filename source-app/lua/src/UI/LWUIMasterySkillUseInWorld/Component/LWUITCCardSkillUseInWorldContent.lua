local LWUITCCardSkillUseInWorldContent = BaseClass("LWUITCCardSkillUseInWorldContent", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local UIGray = CS.UIGray
local LWUIMasterySkillUseInWorldCell = require("UI.LWUIMasterySkillUseInWorld.Component.LWUITCCardSkillUseInWorldCell")
local tc_card_skill_use_in_world_item_path = "TCCardUseInWorldItem"
local content_path = "ScrollView/Viewport/Content"
local empty_tip_text_path = "EmptyTipText"

function LWUITCCardSkillUseInWorldContent:OnCreate()
  base.OnCreate(self)
  self:DataDefine()
  self:ComponentDefine()
end

function LWUITCCardSkillUseInWorldContent:OnDestroy()
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

function LWUITCCardSkillUseInWorldContent:ComponentDefine()
  self.mastery_skill_use_in_world_item = self:AddComponent(UIBaseComponent, tc_card_skill_use_in_world_item_path)
  self.mastery_skill_use_in_world_item:SetActive(false)
  self.mastery_skill_use_in_world_item.gameObject:GameObjectCreatePool()
  self.content = self:AddComponent(UIBaseContainer, content_path)
  self.emptyTipTextObj = self:AddComponent(UIBaseContainer, empty_tip_text_path)
  self.allItems = {}
end

function LWUITCCardSkillUseInWorldContent:ComponentDestroy()
  self:ClearAllItem()
  self.content = nil
  self.mastery_skill_use_in_world_item = nil
end

function LWUITCCardSkillUseInWorldContent:DataDefine()
  self.isInit = false
  self.homeId = nil
  self.usePos = nil
  self.pointId = nil
  self.showData = {}
end

function LWUITCCardSkillUseInWorldContent:DataDestroy()
  self.isInit = nil
  self.homeId = nil
  self.usePos = nil
  self.pointId = nil
  self.showData = nil
end

function LWUITCCardSkillUseInWorldContent:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.TacticalCardDataChanged, self.Refresh)
end

function LWUITCCardSkillUseInWorldContent:OnRemoveListener()
  self:RemoveUIListener(EventId.TacticalCardDataChanged, self.Refresh)
  base.OnRemoveListener(self)
end

function LWUITCCardSkillUseInWorldContent:SetData(usePos, pointId, serverId)
  self:TryInit(usePos, pointId, serverId)
  self:Refresh()
end

function LWUITCCardSkillUseInWorldContent:TryInit(usePos, pointId, serverId)
  if self.isInit then
    return
  end
  self.isInit = true
  self.usePos = usePos
  self.pointId = pointId
  self.serverId = serverId
  self:ClearAllItem()
  self:InitShowData()
  self:InitView()
end

function LWUITCCardSkillUseInWorldContent:UsePosReCal()
  if self.usePos == MasterySkillUsePosType.Field and self.pointId then
    local worldTileInfo = CS.SceneManager.World:GetWorldTileInfo(self.pointId)
    if worldTileInfo ~= nil and worldTileInfo.ownerUid ~= LuaEntry.Player.uid then
      self.usePos = MasterySkillUsePosType.MyDesert
    end
  end
end

local state2Order = {
  [TCCardSkillState.Effect] = 101,
  [TCCardSkillState.Normal] = 102,
  [TCCardSkillState.CD] = 103,
  [TCCardSkillState.NotUseInCurPos] = 104,
  [TCCardSkillState.NoUse] = 201,
  [TCCardSkillState.Locked] = 202,
  [TCCardSkillState.NotUseInBattleField] = 203,
  [TCCardSkillState.UnKnownReason] = 999
}

function LWUITCCardSkillUseInWorldContent:InitShowData()
  self.allActiveSkillDataList = TacticalCardUtil.GetAllActiveSkillDataList()
  self.allShowData = {}
  self.emptyTipTextObj:SetActive(#self.allActiveSkillDataList <= 0)
  local castSkillParams = {}
  castSkillParams.usePos = self.usePos
  castSkillParams.pointId = self.pointId
  for _, skillData in ipairs(self.allActiveSkillDataList) do
    local skillState = skillData:GetCastSkillState(castSkillParams)
    local showData = {
      skillData = skillData,
      skillTemp = skillData.template,
      pointId = self.pointId,
      tempState = skillState
    }
    table.insert(self.allShowData, showData)
  end
  table.sort(self.allShowData, function(a, b)
    local orderA = state2Order[a.tempState] or 999
    local orderB = state2Order[b.tempState] or 999
    if orderA ~= orderB then
      return orderA < orderB
    else
      return a.skillTemp.id < b.skillTemp.id
    end
  end)
end

function LWUITCCardSkillUseInWorldContent:InitView()
  local showNum = #self.allShowData
  if 0 < showNum then
    for i = 1, showNum do
      local item = self.mastery_skill_use_in_world_item.gameObject:GameObjectSpawn(self.content.transform)
      item.name = i
      local obj = self.content:AddComponent(LWUIMasterySkillUseInWorldCell, item.name)
      obj:SetActive(true)
      self.allItems[i] = obj
    end
  end
end

function LWUITCCardSkillUseInWorldContent:Refresh()
  for i = 1, #self.allItems do
    local item = self.allItems[i]
    local itemShowData = self.allShowData[i]
    item:SetData(itemShowData, self.usePos, self.serverId)
  end
end

function LWUITCCardSkillUseInWorldContent:ClearAllItem()
  self.content:RemoveComponents(LWUIMasterySkillUseInWorldCell)
  self.mastery_skill_use_in_world_item.gameObject:GameObjectRecycleAll()
  self.allItems = {}
end

return LWUITCCardSkillUseInWorldContent
