local base = UIAsyncDataContainer
local UICapacityBoxSelectNewDominatorComponent = BaseClass("UICapacityBoxSelectNewDominatorComponent", UIAsyncDataContainer)
local Localization = CS.GameEntry.Localization
UICapacityBoxSelectNewDominatorComponent.DataSchema = {"itemId"}
UICapacityBoxSelectNewDominatorComponent.PrefabPath = "Assets/Main/Prefabs/UI/LWBag/BoxSelectComponent/DominatorInfoContent.prefab"

function UICapacityBoxSelectNewDominatorComponent:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
end

function UICapacityBoxSelectNewDominatorComponent:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UICapacityBoxSelectNewDominatorComponent:ComponentDefine()
  self.textName = self:AddComponent(UIText, "NameText")
  self.textDesc = self:AddComponent(UIText, "DesContent/ContentScroll/Viewport/ContentTxt/DescText")
  self.textLevel = self:AddComponent(UIText, "LevelContent/LevelLayout/LevelText")
  self.btnInfo = self:AddComponent(UIButton, "LevelContent/InfoBtn")
  self.btnInfo:SetOnClick(function()
    self:OnBtnInfoClick()
  end)
  self.textOwn = self:AddComponent(UIText, "LevelContent/OwnText")
end

function UICapacityBoxSelectNewDominatorComponent:ComponentDestroy()
  self.textName = nil
  self.textDesc = nil
  self.textLevel = nil
  self.compHeroRankStar = nil
  self.btnInfo = nil
  self.textOwn = nil
end

function UICapacityBoxSelectNewDominatorComponent:UpdateData()
  if self.viewData.itemId then
    local name = DataCenter.RewardManager:GetNameByType(RewardType.GOODS, self.viewData.itemId)
    self.textName:SetText(name)
    local desc = DataCenter.RewardManager:GetDescByType(RewardType.GOODS, self.viewData.itemId)
    self.textDesc:SetText(desc)
    local itemTemplate = DataCenter.ItemTemplateManager:GetItemTemplate(self.viewData.itemId)
    if not itemTemplate then
      return
    end
    self:UpdateDominator()
  end
end

function UICapacityBoxSelectNewDominatorComponent:ReInit(itemId)
  self.viewData.itemId = itemId
  if self.viewData.itemId == nil then
    return
  end
  self:RefreshView()
end

function UICapacityBoxSelectNewDominatorComponent:UpdateDominator()
  local dominatorId = self.view.ctrl:ItemIdToDominatorId(self.viewData.itemId)
  if not dominatorId then
    return
  end
  local text1 = ""
  local text2 = ""
  local haveNum = DataCenter.ItemData:GetItemCount(self.viewData.itemId)
  local dominatorData = DataCenter.DominatorManager:GetInfoById(dominatorId)
  if dominatorData then
    local curRankTemplate = dominatorData:GetCurRankTemplate()
    if curRankTemplate then
      local isMaxRank = curRankTemplate:IsMaxRank()
      if isMaxRank then
        text1 = Localization:GetString("optional_box_desc_dominator_1", tostring(curRankTemplate:GetShowLevelText()))
      else
        local costFragCount = dominatorData:GetUpgradeRankCostItemNum()
        text1 = Localization:GetString("optional_box_desc_dominator_1", tostring(curRankTemplate:GetShowLevelText()))
        text2 = Localization:GetString("optional_box_desc_dominator_2", tostring(haveNum) .. "/" .. tostring(costFragCount))
      end
    end
  end
  self.textLevel:SetText(text1)
  self.textOwn:SetText(text2)
end

function UICapacityBoxSelectNewDominatorComponent:OnBtnInfoClick()
  if not self.viewData.itemId then
    return
  end
  local dominatorId = self.view.ctrl:ItemIdToDominatorId(self.viewData.itemId)
  if not dominatorId then
    return
  end
  DataCenter.DominatorManager:OpenDominatorMain(dominatorId, UILWDominatorMainPageTag.Rank)
end

return UICapacityBoxSelectNewDominatorComponent
