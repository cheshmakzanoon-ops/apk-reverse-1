local WorkerAttrOverviewItem = BaseClass("WorkerAttrOverviewItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local WorkerAttrOverviewSubItem = require("UI.UILWWorker.UIWorkerOverviewList.Component.AttributeContent.WorkerAttrOverviewSubItem")
local u_i_worker_attr_overview_sub_item_path = "UIWorkerAttrOverviewSubItem"

function WorkerAttrOverviewItem:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function WorkerAttrOverviewItem:OnDestroy()
  self:SetAllCellDestroy()
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

function WorkerAttrOverviewItem:ComponentDefine()
  self.root = self:AddComponent(UIBaseContainer, "")
  self.titleText = self:AddComponent(UIText, "Title/TitleText")
  self.itemContent = self:AddComponent(UIBaseContainer, "ItemContent")
  self.u_i_worker_attr_overview_sub_item = self:AddComponent(UIBaseContainer, u_i_worker_attr_overview_sub_item_path)
  self.u_i_worker_attr_overview_sub_item:SetActive(false)
  self.u_i_worker_attr_overview_sub_item.gameObject:GameObjectCreatePool()
  self.itemList = {}
end

function WorkerAttrOverviewItem:ComponentDestroy()
  self.titleText = nil
  self.itemContent = nil
  self.u_i_worker_attr_overview_sub_item = nil
end

function WorkerAttrOverviewItem:DataDefine()
end

function WorkerAttrOverviewItem:DataDestroy()
end

function WorkerAttrOverviewItem:Refresh(data, scroll_view, index)
  self.data = data
  self.scroll_view = scroll_view
  self.index = index
  self.titleText:SetLocalText(self.data.buildindData.buildTemplate.name)
  self:SetShowData()
  local curItemLen = #self.itemList
  for i = curItemLen + 1, #self.attrList do
    local item = self.u_i_worker_attr_overview_sub_item.gameObject:GameObjectSpawn(self.itemContent.transform)
    local showIndex = tostring(i)
    item.name = showIndex
    local obj = self.itemContent:AddComponent(WorkerAttrOverviewSubItem, item.name)
    self.itemList[i] = obj
  end
  for i = 1, #self.itemList do
    if i <= #self.attrList then
      self.itemList[i]:SetActive(true)
      self.itemList[i]:Refresh(self.attrList[i], i)
    else
      self.itemList[i]:SetActive(false)
    end
  end
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.root.transform)
  self.scroll_view:OnItemSizeChanged(self.index)
end

function WorkerAttrOverviewItem:SetShowData()
  local buildTemp = self.data.buildindData.buildTemplate
  local attrData = self.data.attrData
  self.attrList = {}
  if buildTemp.id == BuildingTypes.LW_BUILD_HOSPITL then
    local effectValDict = {}
    local effectIdArray = {}
    for k, v in ipairs(attrData) do
      local effectDataArr = v.attrData
      for index, effectData in ipairs(effectDataArr) do
        local effectId = effectData.effectId
        local effectValue = effectData.effectValue
        if effectValDict[effectId] == nil then
          effectValDict[effectId] = effectValue
          table.insert(effectIdArray, effectId)
        else
          effectValDict[effectId] = effectValDict[effectId] + effectValue
        end
      end
    end
    for _, effectId in ipairs(effectIdArray) do
      local effectValue = effectValDict[effectId]
      local effectLine = LocalController:instance():getLine(TableName.LW_Effect_Number, tonumber(effectId))
      local effectName = Localization:GetString(effectLine.name)
      local addValue = HeroUtils.GetFormattedPropertyValue(effectId, effectValue)
      local showDataStr1 = string.format("%s", effectName)
      local showData = {name = showDataStr1, value = addValue}
      table.insert(self.attrList, showData)
    end
  else
    for k, v in ipairs(attrData) do
      local buildData = v.buildindData.data
      local buildLv = buildData.level
      local buildLvStr = Localization:GetString(GameDialogDefine.LEVEL_NUMBER, buildLv)
      local buildName = Localization:GetString(buildTemp.name)
      local effectDataArr = v.attrData
      for index, effectData in ipairs(effectDataArr) do
        local effectId = effectData.effectId
        local effectValue = effectData.effectValue
        local effectLine = LocalController:instance():getLine(TableName.LW_Effect_Number, tonumber(effectId))
        local effectName = Localization:GetString(effectLine.name)
        local addValue = HeroUtils.GetFormattedPropertyValue(effectId, effectValue)
        local showDataStr1 = string.format("(%s %s)%s", buildLvStr, buildName, effectName)
        local showData = {name = showDataStr1, value = addValue}
        table.insert(self.attrList, showData)
      end
    end
  end
end

function WorkerAttrOverviewItem:SetAllCellDestroy()
  self.itemContent:RemoveComponents(WorkerAttrOverviewSubItem)
  for _, v in ipairs(self.itemContent.transform) do
    if v ~= nil then
      CS.UnityEngine.GameObject.Destroy(v.gameObject)
    end
  end
  self.u_i_worker_attr_overview_sub_item.gameObject:GameObjectRecycleAll()
  self.itemList = {}
end

return WorkerAttrOverviewItem
