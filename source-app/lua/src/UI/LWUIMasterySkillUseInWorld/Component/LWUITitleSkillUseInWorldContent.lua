local LWUITitleSkillUseInWorldContent = BaseClass("LWUITitleSkillUseInWorldContent", UIBaseContainer)
local base = UIBaseContainer
local LWUITitleSkillUseInWorldCell = require("UI.LWUIMasterySkillUseInWorld.Component.LWUITitleSkillUseInWorldCell")
local title_skill_use_in_world_item_path = "TitleSkillUseInWorldItem"
local content_path = "ScrollView/Viewport/Content"

function LWUITitleSkillUseInWorldContent:OnCreate()
  base.OnCreate(self)
  self:DataDefine()
  self:ComponentDefine()
end

function LWUITitleSkillUseInWorldContent:OnDestroy()
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

function LWUITitleSkillUseInWorldContent:ComponentDefine()
  self.title_skill_use_in_world_item = self:AddComponent(UIBaseComponent, title_skill_use_in_world_item_path)
  self.title_skill_use_in_world_item:SetActive(false)
  self.title_skill_use_in_world_item.gameObject:GameObjectCreatePool()
  self.content = self:AddComponent(UIBaseContainer, content_path)
  self.allItems = {}
end

function LWUITitleSkillUseInWorldContent:ComponentDestroy()
  self:ClearAllItem()
  self.content = nil
  self.title_skill_use_in_world_item = nil
end

function LWUITitleSkillUseInWorldContent:DataDefine()
  self.isInit = false
  self.usePos = nil
  self.pointId = nil
  self.showData = {}
end

function LWUITitleSkillUseInWorldContent:DataDestroy()
  self.isInit = nil
  self.usePos = nil
  self.pointId = nil
  self.showData = nil
end

function LWUITitleSkillUseInWorldContent:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.LWUseSkill, self.Refresh)
end

function LWUITitleSkillUseInWorldContent:OnRemoveListener()
  self:RemoveUIListener(EventId.LWUseSkill, self.Refresh)
  base.OnRemoveListener(self)
end

function LWUITitleSkillUseInWorldContent:SetData(usePos, pointId, serverId)
  self:TryInit(usePos, pointId, serverId)
  self:Refresh()
end

function LWUITitleSkillUseInWorldContent:TryInit(usePos, pointId, serverId)
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

function LWUITitleSkillUseInWorldContent:InitShowData()
  local titleList = DataCenter.PlayerInfoDataManager:GetTitleList()
  self.allShowData = DataCenter.MasteryManager:GetTitleShowSkillList(titleList, self.pointId, self.usePos, true)
end

function LWUITitleSkillUseInWorldContent:InitView()
  local showNum = #self.allShowData
  if 0 < showNum then
    for i = 1, showNum do
      local item = self.title_skill_use_in_world_item.gameObject:GameObjectSpawn(self.content.transform)
      item.name = i
      local obj = self.content:AddComponent(LWUITitleSkillUseInWorldCell, item.name)
      obj:SetActive(true)
      self.allItems[i] = obj
    end
  end
end

function LWUITitleSkillUseInWorldContent:Refresh()
  for i = 1, #self.allItems do
    local item = self.allItems[i]
    local itemShowData = self.allShowData[i]
    item:SetData(itemShowData, self.usePos, self.serverId)
  end
end

function LWUITitleSkillUseInWorldContent:ClearAllItem()
  self.content:RemoveComponents(LWUITitleSkillUseInWorldCell)
  self.title_skill_use_in_world_item.gameObject:GameObjectRecycleAll()
  self.allItems = {}
end

return LWUITitleSkillUseInWorldContent
