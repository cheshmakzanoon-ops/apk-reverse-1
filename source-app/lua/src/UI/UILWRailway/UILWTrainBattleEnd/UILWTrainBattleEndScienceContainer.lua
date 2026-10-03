local UILWTrainBattleEndScienceContainer = BaseClass("UILWTrainBattleEndScienceContainer", UIBaseContainer)
local base = UIBaseContainer
local UILWTrainBattleEndScienceItemRender = require("UI.UILWRailway.UILWTrainBattleEnd.UILWTrainBattleEndScienceItemRender")
local tips_text_path = "TipsText"
local science_content_path = "ScienceContent"
local lw_train_battle_end_science_item_render_path = "UILWTrainBattleEndScienceItemRender"

function UILWTrainBattleEndScienceContainer:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
end

function UILWTrainBattleEndScienceContainer:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UILWTrainBattleEndScienceContainer:ComponentDefine()
  self.tips_text = self:AddComponent(UIText, tips_text_path)
  self.science_content = self:AddComponent(UIBaseContainer, science_content_path)
  self.science_item = self.transform:Find(lw_train_battle_end_science_item_render_path).gameObject
  self.science_item:GameObjectCreatePool()
end

function UILWTrainBattleEndScienceContainer:ComponentDestroy()
  self:ClearScienceList()
  self.tips_text = nil
  self.science_content = nil
  self.science_item = nil
end

function UILWTrainBattleEndScienceContainer:ReInit(showTips)
  local trainDepartureScienceId = 13
  local tabState = DataCenter.ScienceTemplateManager:GetTabState(trainDepartureScienceId)
  if tabState == ScienceTabState.UnLock then
    self.tips_text:SetActive(showTips)
    if showTips then
      self.tips_text:SetLocalText("trade_person_tips1008")
    end
    self.science_content:SetActive(true)
    self:ClearScienceList()
    self:CreateScienceItem()
  else
    self.tips_text:SetActive(false)
    self.science_content:SetActive(false)
  end
end

function UILWTrainBattleEndScienceContainer:CreateScienceItem()
  local metaId = 36
  local metaVal = DataCenter.LWAllyStationDataManager:GetMeta(metaId)
  if metaVal ~= nil then
    self.science_content:SetActive(true)
    local scienceIdArr = string.split_ss_array(metaVal, ",")
    for i = 1, #scienceIdArr do
      local scienceId = tonumber(scienceIdArr[i])
      local curLevel = DataCenter.ScienceManager:GetScienceLevel(scienceId)
      local maxLevel = DataCenter.ScienceManager:GetScienceMaxLevel(scienceId)
      if curLevel < maxLevel then
        local goItem = self.science_item:GameObjectSpawn(self.science_content.transform)
        goItem.name = "item_" .. i
        goItem:SetActive(true)
        local itemRender = self.science_content:AddComponent(UILWTrainBattleEndScienceItemRender, goItem.name)
        itemRender:SetData(scienceId)
      end
    end
  else
    self.science_content:SetActive(false)
    Logger.LogError("\230\178\161\230\156\137\232\142\183\229\143\150\229\136\176\229\143\175\230\152\190\231\164\186\231\154\132\231\167\145\230\138\128\233\133\141\231\189\174\230\149\176\230\141\174")
  end
end

function UILWTrainBattleEndScienceContainer:ClearScienceList()
  self.science_content:RemoveComponents(UILWTrainBattleEndScienceItemRender)
  self.science_item:GameObjectRecycleAll()
end

return UILWTrainBattleEndScienceContainer
