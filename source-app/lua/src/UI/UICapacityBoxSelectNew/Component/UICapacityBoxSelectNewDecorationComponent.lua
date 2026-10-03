local base = UIBaseContainer
local UICapacityBoxSelectNewDecorationComponent = BaseClass("UICapacityBoxSelectNewDecorationComponent", UIBaseContainer)
local Localization = CS.GameEntry.Localization
local UICapacityBoxSelectNewDecorationAttributeCellComponent = require("UI/UICapacityBoxSelectNew/Component/UICapacityBoxSelectNewDecorationAttributeCellComponent")

function UICapacityBoxSelectNewDecorationComponent:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UICapacityBoxSelectNewDecorationComponent:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UICapacityBoxSelectNewDecorationComponent:ComponentDefine()
  self.textName = self:AddComponent(UIText, "NameText")
  self.textDesc = self:AddComponent(UIText, "DescContent/DescText")
  self.btnInfo = self:AddComponent(UIButton, "DescContent/InfoBtn")
  self.btnInfo:SetOnClick(function()
    self:OnBtnInfoClick()
  end)
  self.compAttributeItem = self:AddComponent(UICapacityBoxSelectNewDecorationAttributeCellComponent, "AttributeItem")
  self.compAttributeItem.gameObject:GameObjectCreatePool()
  self.compAttributeItem:SetActive(false)
  self.compContent = self:AddComponent(UIBaseContainer, "Content")
  self.compCurrentContent = self:AddComponent(UIBaseContainer, "CurrentContent")
  self.textLeft = self:AddComponent(UIText, "CurrentContent/LeftText")
  self.textRight = self:AddComponent(UIText, "CurrentContent/RightText")
  self.compNotOwnContent = self:AddComponent(UIBaseContainer, "NotOwnContent")
  self.textNotOwn = self:AddComponent(UIText, "NotOwnContent/NotOwnText")
end

function UICapacityBoxSelectNewDecorationComponent:ComponentDestroy()
  self:ClearAttribute()
  self.textName = nil
  self.textDesc = nil
  self.btnInfo = nil
  self.compAttributeItem = nil
  self.compContent = nil
  self.compCurrentContent = nil
  self.textLeft = nil
  self.textRight = nil
  self.compNotOwnContent = nil
  self.textNotOwn = nil
end

function UICapacityBoxSelectNewDecorationComponent:DataDefine()
end

function UICapacityBoxSelectNewDecorationComponent:DataDestroy()
end

function UICapacityBoxSelectNewDecorationComponent:ReInit(itemId)
  self.itemId = itemId
  if self.itemId == nil then
    return
  end
  local name = DataCenter.RewardManager:GetNameByType(RewardType.GOODS, self.itemId)
  self.textName:SetText(name)
  local baseBuildingId = self.view.ctrl:ItemIdToBuildingBaseId(self.itemId)
  if baseBuildingId == nil then
    return
  end
  self.baseBuildingId = baseBuildingId
  local baseBuildTemplate = DataCenter.BuildTemplateManager:GetBuildingDesTemplate(self.baseBuildingId)
  if not baseBuildTemplate then
    return
  end
  local showCurLevel = 0
  local showNextLevel = 1
  local descId = "optional_box_desc4"
  local hasBuilding = DataCenter.BuildManager:HasBuilding(baseBuildingId, false)
  if hasBuilding then
    local buildData = DataCenter.BuildManager:GetMaxLvBuildDataByBuildId(baseBuildingId, true)
    if buildData ~= nil then
      showCurLevel = buildData.level
      if buildData.level >= baseBuildTemplate.max_level then
        descId = "optional_box_desc5"
        showNextLevel = showCurLevel
      else
        showNextLevel = buildData.level + 1
      end
    end
  end
  self.textDesc:SetLocalText(descId, tostring(showNextLevel))
  local attributes = self.view.ctrl:GetDecorationValue(baseBuildingId, showCurLevel, showNextLevel)
  local showAttribute = not table.IsNullOrEmpty(attributes)
  self.compContent:SetActive(showAttribute)
  if showAttribute then
    self:ClearAttribute()
    local showBlack = true
    for i, v in pairs(attributes) do
      local item = self.compAttributeItem.gameObject:GameObjectSpawn(self.compContent.transform)
      item.name = "item" .. i
      local obj = self.compContent:AddComponent(UICapacityBoxSelectNewDecorationAttributeCellComponent, item.name)
      obj:SetActive(true)
      v.showBlack = showBlack
      obj:ReInit(v)
      showBlack = not showBlack
    end
  end
  local curCount = BuildingUtils.GetDecorateCountByLevel(baseBuildingId, 1)
  local leftText = ""
  local rightText = ""
  if not hasBuilding then
    if curCount <= 0 then
      leftText = leftText .. Localization:GetString("optional_box_desc1") .. " "
      rightText = Localization:GetString("optional_box_desc3", tostring(curCount) .. "/" .. tostring(1))
    else
      leftText = leftText .. Localization:GetString("optional_box_desc14") .. " "
      rightText = Localization:GetString("optional_box_desc9", tostring(curCount))
    end
  else
    local buildData = DataCenter.BuildManager:GetMaxLvBuildDataByBuildId(baseBuildingId, true)
    if buildData then
      if buildData.level >= baseBuildTemplate.max_level then
        leftText = leftText .. Localization:GetString("optional_box_desc7", tostring(buildData.level)) .. " " .. Localization:GetString("optional_box_desc6")
        rightText = Localization:GetString("optional_box_desc9", tostring(curCount)) .. " " .. Localization:GetString("optional_box_desc2")
      else
        local curLevelTemplate = DataCenter.BuildTemplateManager:GetBuildingLevelTemplate(baseBuildingId, buildData.level)
        if curLevelTemplate then
          leftText = leftText .. Localization:GetString("optional_box_desc7", tostring(buildData.level))
          if curLevelTemplate.decorationUpgradeType == DecorationUpgradeType.AdvanceUpgrade then
            local needCount = tonumber(curLevelTemplate.para2) or 0
            local prodStatus = buildData.prodStatus or 0
            local combinedCurCount = curCount + prodStatus
            if needCount <= combinedCurCount then
              rightText = Localization:GetString("optional_box_desc9", tostring(combinedCurCount) .. "/" .. tostring(needCount))
            else
              rightText = Localization:GetString("optional_box_desc8", tostring(combinedCurCount) .. "/" .. tostring(needCount))
            end
          else
            local needCount = tonumber(curLevelTemplate.para2) or 0
            if curCount >= needCount then
              rightText = Localization:GetString("optional_box_desc9", tostring(curCount) .. "/" .. tostring(needCount))
            else
              rightText = Localization:GetString("optional_box_desc8", tostring(curCount) .. "/" .. tostring(needCount))
            end
          end
          if self.view.ctrl:IsDecorationUpgradeItemMax(self.baseBuildingId, baseBuildTemplate.max_level) then
            rightText = rightText .. " " .. Localization:GetString("optional_box_desc2")
          end
        end
      end
    end
  end
  self.compNotOwnContent:SetActive(false)
  self.compCurrentContent:SetActive(true)
  self.textLeft:SetText(leftText)
  self.textRight:SetText(rightText)
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.transform)
end

function UICapacityBoxSelectNewDecorationComponent:ClearAttribute()
  self.compContent:RemoveComponents(UICapacityBoxSelectNewDecorationAttributeCellComponent)
  self.compAttributeItem.gameObject:GameObjectRecycleAll()
end

function UICapacityBoxSelectNewDecorationComponent:OnAddListener()
  base.OnAddListener(self)
end

function UICapacityBoxSelectNewDecorationComponent:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UICapacityBoxSelectNewDecorationComponent:OnBtnInfoClick()
  local param = {}
  param.baseBuildingId = self.baseBuildingId
  param.alignObject = self.btnInfo
  UIManager:GetInstance():OpenWindow(UIWindowNames.LWDecorationBookProperty, {anim = false}, param)
end

return UICapacityBoxSelectNewDecorationComponent
