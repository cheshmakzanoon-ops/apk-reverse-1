local LWUIMasterySkillUseInWorldContent = BaseClass("LWUIMasterySkillUseInWorldContent", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local UIGray = CS.UIGray
local LWUIMasterySkillUseInWorldCell = require("UI.LWUIMasterySkillUseInWorld.Component.LWUIMasterySkillUseInWorldCell")
local mastery_skill_use_in_world_item_path = "MasterySkillUseInWorldItem"
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
  self.mastery_skill_use_in_world_item = self:AddComponent(UIBaseComponent, mastery_skill_use_in_world_item_path)
  self.mastery_skill_use_in_world_item:SetActive(false)
  self.mastery_skill_use_in_world_item.gameObject:GameObjectCreatePool()
  self.content = self:AddComponent(UIBaseContainer, content_path)
  self.allItems = {}
end

function LWUIMasterySkillUseInWorldContent:ComponentDestroy()
  self:ClearAllItem()
  self.content = nil
  self.mastery_skill_use_in_world_item = nil
end

function LWUIMasterySkillUseInWorldContent:DataDefine()
  self.isInit = false
  self.homeId = nil
  self.usePos = nil
  self.pointId = nil
  self.showData = {}
end

function LWUIMasterySkillUseInWorldContent:DataDestroy()
  self.isInit = nil
  self.homeId = nil
  self.usePos = nil
  self.pointId = nil
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

function LWUIMasterySkillUseInWorldContent:SetData(usePos, pointId, serverId)
  self:TryInit(usePos, pointId, serverId)
  self:Refresh()
end

function LWUIMasterySkillUseInWorldContent:TryInit(usePos, pointId, serverId)
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
  self.allShowData = {}
  for _, masteryId in ipairs(self.homeDict) do
    local skillState, endTime, masteryTemp, skillTemp = DataCenter.MasteryManager:GetMasteryGroupSkillState(masteryId)
    if masteryTemp and skillTemp and not skillTemp:CheckUsePosition(MasterySkillUsePosType.SkillView) and skillTemp.active_skills and skillState ~= MasterySkillState.Covered then
      local tempState = skillState
      if tempState == MasterySkillState.Normal then
        if self.usePos == MasterySkillUsePosType.Field and skillTemp:CheckUsePosition(MasterySkillUsePosType.MyDesert) then
          local desertInfo = SeasonUtil.GetDesertIfoByPointId(self.pointId)
          if not desertInfo or desertInfo.ownerUid ~= LuaEntry.Player.uid then
            tempState = MasterySkillState.NoUse
          end
        elseif not skillTemp:CheckUsePosition(self.usePos) then
          tempState = MasterySkillState.NoUse
        elseif skillTemp.use_target == 1 then
          tempState = self.pointId == LuaEntry.Player:GetMainWorldPos() and tempState or MasterySkillState.NoUse
        elseif skillTemp.type == MasterySkill.FriendshipShield then
          local pointInfo = CS.SceneManager.World:GetPointInfo(self.pointId)
          local myAllianceId = LuaEntry.Player:GetAllianceUid()
          if pointInfo == nil or pointInfo.allianceId ~= myAllianceId or string.IsNullOrEmpty(myAllianceId) then
            tempState = MasterySkillState.NoUse
          end
        elseif skillTemp.type == MasterySkill.ReinforceWall then
          local pointInfo = CS.SceneManager.World:GetPointInfo(self.pointId)
          if not (pointInfo and pointInfo.wallBarInfo) or not pointInfo.wallBarInfo:IsValid() then
            tempState = MasterySkillState.NoUse
          else
            local fortifyData = DataCenter.MasteryManager:GetFortifyDailyCount(pointInfo.ownerUid)
            if fortifyData and fortifyData.usedCount >= fortifyData.dailyLimit then
              tempState = MasterySkillState.NoUse
            end
          end
        end
      end
      local showData = {
        masteryTemp = masteryTemp,
        skillTemp = skillTemp,
        endTime = endTime,
        pointId = self.pointId,
        tempState = tempState
      }
      table.insert(self.allShowData, showData)
    end
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
      local item = self.mastery_skill_use_in_world_item.gameObject:GameObjectSpawn(self.content.transform)
      item.name = i
      local obj = self.content:AddComponent(LWUIMasterySkillUseInWorldCell, item.name)
      obj:SetActive(true)
      self.allItems[i] = obj
    end
  end
end

function LWUIMasterySkillUseInWorldContent:Refresh()
  for i = 1, #self.allItems do
    local item = self.allItems[i]
    local itemShowData = self.allShowData[i]
    item:SetData(itemShowData, self.usePos, self.serverId)
  end
end

function LWUIMasterySkillUseInWorldContent:ClearAllItem()
  self.content:RemoveComponents(LWUIMasterySkillUseInWorldCell)
  self.mastery_skill_use_in_world_item.gameObject:GameObjectRecycleAll()
  self.allItems = {}
end

return LWUIMasterySkillUseInWorldContent
