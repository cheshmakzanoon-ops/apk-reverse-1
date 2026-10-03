local HeroTrialHeroItem = BaseClass("HeroTrialHeroItem", UIBaseContainer)
local HeroTrialHeroInnerItem = require("UI.UIActivityCenterTable.Component.HeroTrial.HeroTrialHeroInnerItem")
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization

function HeroTrialHeroItem:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function HeroTrialHeroItem:OnDestroy()
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

function HeroTrialHeroItem:ComponentDefine()
  self._ui_hero_cell_big = self:AddComponent(HeroTrialHeroInnerItem, "HeroTrialHeroInnerItem")
  self._name_txt = self:AddComponent(UIText, "NameText")
  self._task_txt = self:AddComponent(UIText, "TaskText")
  self._mask_btn = self:AddComponent(UIButton, "Mask")
  self._mask_btn:SetOnClick(function()
    self:OnHeroCellClick()
  end)
  self._effect1_go = self:AddComponent(UIBaseContainer, "Effect1")
  self._effect2_go = self:AddComponent(UIBaseContainer, "Effect2")
  self._desc_txt = self:AddComponent(UIText, "Mask/BG/DescText")
  self._desc_txt:SetLocalText(2000726)
end

function HeroTrialHeroItem:ComponentDestroy()
  self._ui_hero_cell_big = nil
  self._name_txt = nil
  self._task_txt = nil
  self._mask_btn = nil
  self._desc_txt = nil
  self._effect1_go = nil
  self._effect2_go = nil
end

function HeroTrialHeroItem:DataDefine()
  self._name_txt:SetActive(false)
end

function HeroTrialHeroItem:DataDestroy()
  self.heroUuid = nil
  self.questId = nil
end

local function OnHeroCellClick(self)
  if self.heroUuid == nil then
    return
  end
  local heroData = DataCenter.HeroDataManager:GetHeroByUuid(self.heroUuid)
  if heroData ~= nil then
    local fragId = heroData:GetHeroFragId()
    local haveFragCount = DataCenter.ItemData:GetItemCount(fragId)
    local commonFragId = DataCenter.HeroParamDataManager:GetQualityFragmentIdByQuality(heroData)
    local commonHeroFragCount = DataCenter.ItemData:GetItemCount(commonFragId)
    haveFragCount = commonHeroFragCount + haveFragCount
    local costFragCount = heroData:GetUpgradeRankCost()
    if not costFragCount then
      return
    end
    if haveFragCount >= costFragCount then
      UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroDetailPanel, {anim = false}, self.heroUuid, {
        self.heroUuid
      }, BindCallback(self, self.RefreshPage), {
        arrowType = HeroDetailGuideArrowType.Rank
      })
    else
      LWResourceLackUtil:GotoGoodsItemLack(fragId, costFragCount - haveFragCount)
    end
  else
    local need = HeroUtils.GetJigsawCost(self.heroUuid)
    local count = DataCenter.ItemData:GetItemCount(self.heroUuid)
    if need <= count then
      GoToUtil.GotoOpenView(UIWindowNames.UIHeroListPanel, {
        anim = false,
        UIMainAnim = UIMainAnimType.AllHide
      }, nil, nil, nil, self.heroUuid)
    else
      LWResourceLackUtil:GotoGoodsItemLack(self.heroUuid, 10 - count)
    end
  end
end

function HeroTrialHeroItem:ReInit(questId)
  self.questId = questId
  local questTemplate = DataCenter.QuestTemplateManager:GetQuestTemplate(questId)
  local heroId = tonumber(questTemplate.para1)
  self.heroUuid = DataCenter.HeroDataManager:GetHeroUuidByHeroId(heroId)
  if string.IsNullOrEmpty(self.heroUuid) then
    local type99Items = DataCenter.ItemTemplateManager:GetTypeListByType(GOODS_TYPE.GOODS_TYPE_99)
    table.walk(type99Items, function(k, v)
      local itemId = toInt(v.id)
      local itemTemplate = DataCenter.ItemTemplateManager:GetItemTemplate(itemId)
      local heroIdTemp = toInt(itemTemplate.para2)
      if heroId == heroIdTemp then
        self.heroUuid = itemId
      end
    end)
  end
  self:RefreshPage()
end

function HeroTrialHeroItem:RefreshPage()
  if self.heroUuid ~= nil then
    local heroData = DataCenter.HeroDataManager:GetHeroByUuid(self.heroUuid)
    local hasHero = heroData ~= nil
    if hasHero then
      self._ui_hero_cell_big:SetData(self.heroUuid)
    else
      self._ui_hero_cell_big:InitWithHeroPieceItem(self.heroUuid)
    end
  end
  if self.questId then
    local template = DataCenter.QuestTemplateManager:GetQuestTemplate(self.questId)
    if template then
      self._task_txt:SetText(template:GetDesc())
    end
    local taskValue = DataCenter.TaskManager:FindTaskInfo(self.questId)
    local state = taskValue.state
    self._effect1_go:SetActive(state ~= TaskState.NoComplete)
    self._effect2_go:SetActive(state ~= TaskState.NoComplete)
    self._mask_btn:SetActive(state == TaskState.NoComplete)
  end
end

HeroTrialHeroItem.OnHeroCellClick = OnHeroCellClick
return HeroTrialHeroItem
