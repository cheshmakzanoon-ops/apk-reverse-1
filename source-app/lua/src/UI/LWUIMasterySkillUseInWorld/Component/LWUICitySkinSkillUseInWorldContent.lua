local LWUICitySkinSkillUseInWorldContent = BaseClass("LWUICitySkinSkillUseInWorldContent", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local UIGray = CS.UIGray
local LWUICitySkinSkillUseInWorldCell = require("UI.LWUIMasterySkillUseInWorld.Component.LWUICitySkinSkillUseInWorldCell")
local city_skin_skill_item_path = "CitySkinSkillItem"
local content_path = "ScrollView/Viewport/Content"

function LWUICitySkinSkillUseInWorldContent:OnCreate()
  base.OnCreate(self)
  self:DataDefine()
  self:ComponentDefine()
end

function LWUICitySkinSkillUseInWorldContent:OnDestroy()
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

function LWUICitySkinSkillUseInWorldContent:ComponentDefine()
  self.city_skin_skill_item = self:AddComponent(UIBaseComponent, city_skin_skill_item_path)
  self.city_skin_skill_item:SetActive(false)
  self.city_skin_skill_item.gameObject:GameObjectCreatePool()
  self.content = self:AddComponent(UIBaseContainer, content_path)
  self.allItems = {}
end

function LWUICitySkinSkillUseInWorldContent:ComponentDestroy()
  self:ClearAllItem()
  self.content = nil
  self.city_skin_skill_item = nil
end

function LWUICitySkinSkillUseInWorldContent:DataDefine()
  self.isInit = false
  self.homeId = nil
  self.usePos = nil
  self.pointId = nil
  self.showData = {}
end

function LWUICitySkinSkillUseInWorldContent:DataDestroy()
  self.isInit = nil
  self.homeId = nil
  self.usePos = nil
  self.pointId = nil
  self.showData = nil
end

function LWUICitySkinSkillUseInWorldContent:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.CitySkinSkillUse, self.Refresh)
end

function LWUICitySkinSkillUseInWorldContent:OnRemoveListener()
  self:RemoveUIListener(EventId.CitySkinSkillUse, self.Refresh)
  base.OnRemoveListener(self)
end

function LWUICitySkinSkillUseInWorldContent:SetData(usePos, pointId, serverId)
  self:TryInit(usePos, pointId, serverId)
  self:Refresh()
  PostEventLog.Track(PostEventLog.Defines.OpenCitySkinSkillView, {})
end

function LWUICitySkinSkillUseInWorldContent:TryInit(usePos, pointId, serverId)
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

function LWUICitySkinSkillUseInWorldContent:InitShowData()
  self.allShowData = DataCenter.CitySkinSkillManager:GetSkillShowData()
end

function LWUICitySkinSkillUseInWorldContent:InitView()
  local showNum = #self.allShowData
  if 0 < showNum then
    for i = 1, showNum do
      local item = self.city_skin_skill_item.gameObject:GameObjectSpawn(self.content.transform)
      item.name = i
      local obj = self.content:AddComponent(LWUICitySkinSkillUseInWorldCell, item.name)
      obj:SetActive(true)
      self.allItems[i] = obj
    end
  end
end

function LWUICitySkinSkillUseInWorldContent:Refresh()
  for i = 1, #self.allItems do
    local item = self.allItems[i]
    local itemShowData = self.allShowData[i]
    item:SetData(itemShowData, self.usePos, self.serverId)
  end
end

function LWUICitySkinSkillUseInWorldContent:ClearAllItem()
  self.content:RemoveComponents(LWUICitySkinSkillUseInWorldCell)
  self.city_skin_skill_item.gameObject:GameObjectRecycleAll()
  self.allItems = {}
end

return LWUICitySkinSkillUseInWorldContent
