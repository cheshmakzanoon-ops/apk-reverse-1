local DominatorSkillNodeComponent = BaseClass("DominatorSkillNodeComponent", UIBaseContainer)
local base = UIBaseContainer
local DominatorSkillItem = require("UI.UISkirmish.Main.Component.DominatorSkillItem")

function DominatorSkillNodeComponent:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
end

function DominatorSkillNodeComponent:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function DominatorSkillNodeComponent:ComponentDefine()
  self.skillItem = self.transform:Find("DominatorSkillItem").gameObject
  local skillItemRectTransform = self.skillItem:GetComponent(typeof(CS.UnityEngine.RectTransform))
  local size_x, size_y = skillItemRectTransform:Get_sizeDelta()
  self.skillItemHeight = size_y
  self.space = 0 + self.skillItemHeight
  self.skillItem:GameObjectCreatePool()
  self.index = 1
  self.itemList = {}
  self.waitList = {}
  self.maxCount = 4
  self.cacheSkillTime = {}
end

function DominatorSkillNodeComponent:ComponentDestroy()
  self.skillItem.gameObject:GameObjectRecycleAll()
  self.skillItem = nil
  self.itemList = {}
  self.waitList = {}
  self.cacheSkillTime = {}
end

function DominatorSkillNodeComponent:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.OnPVPDominatorCastSkill, self.OnDominatorCastSkill)
end

function DominatorSkillNodeComponent:OnRemoveListener()
  self:RemoveUIListener(EventId.OnPVPDominatorCastSkill, self.OnDominatorCastSkill)
  base.OnRemoveListener(self)
end

function DominatorSkillNodeComponent:OnDominatorCastSkill(skill)
  local id = skill.skillInfo.skillId
  local time = Time.realtimeSinceStartup
  if self.cacheSkillTime[id] and time - self.cacheSkillTime[id] < 1 then
    return
  end
  self.cacheSkillTime[id] = time
  local item = self.skillItem:GameObjectSpawn(self.transform)
  item.name = "skillItem" .. self.index
  self.index = self.index + 1
  local obj = self:AddComponent(DominatorSkillItem, item.name)
  obj:SetActive(true)
  obj:SetData(skill.skillInfo)
  obj.rectTransform:Set_anchoredPosition(0, 0)
  local allFinish = true
  for _, v in ipairs(self.itemList) do
    if not v:IsEnterFinish() then
      allFinish = false
      break
    end
  end
  if not allFinish then
    table.insert(self.waitList, obj)
  else
    obj:Enter()
    local itemCount = #self.itemList
    if itemCount >= self.maxCount then
      for i = itemCount, self.maxCount, -1 do
        self.itemList[i]:End()
      end
    end
    for i = itemCount, 1, -1 do
      self.itemList[i]:MoveUp(self.space * i)
    end
    table.insert(self.itemList, 1, obj)
  end
end

function DominatorSkillNodeComponent:OnSkillEnterFinish(item)
  local allFinish = true
  for _, v in ipairs(self.itemList) do
    if not v:IsEnterFinish() then
      allFinish = false
      break
    end
  end
  if allFinish and #self.waitList > 0 then
    local obj = self.waitList[1]
    table.remove(self.waitList, 1)
    obj:Enter()
    local itemCount = #self.itemList
    if itemCount >= self.maxCount then
      for i = itemCount, self.maxCount, -1 do
        self.itemList[i]:End()
      end
    end
    for i = itemCount, 1, -1 do
      self.itemList[i]:MoveUp(self.space * i)
    end
    table.insert(self.itemList, 1, obj)
  end
end

function DominatorSkillNodeComponent:OnSkillItemEnd(item)
  local go = item.gameObject
  table.removebyvalue(self.itemList, item)
  self:RemoveComponent(item:GetName(), DominatorSkillItem)
  go:GameObjectRecycle()
end

return DominatorSkillNodeComponent
