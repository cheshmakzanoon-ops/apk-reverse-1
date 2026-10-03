local UIHeroListItem = BaseClass("UIHeroListItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local UIWorkerShowCell = require("UI.UILWWorker.UIWorkerOverviewList.Component.UIWorkerShowCell")
local uiWorkerShowCell_path = "panel/UIWorkerShowCell"
local name_path = "panel/text_name"
local level_path = "panel/text_level"
local place_path = "panel/place/text_place"
local pace_container_path = "panel/place"
local slider_path = "panel/imgSliderBG/Slider"
local percent_path = "panel/imgSliderBG/text_percent"
local bgBtn_path = "panel/btn_BG"
local garyImg_path = "panel/garyImg"
local gotoUnlockBtn_path = "panel/btn_unlock"
local btn_dispatch_path = "panel/btn_dispatch"
local txt_dispatch_path = "panel/btn_dispatch/txt_dispatch"
local txt_dispatched_path = "panel/txt_dispatched"
local effectShowNum = 3

function UIHeroListItem:OnCreate()
  base.OnCreate(self)
  self:DataDefine()
  self:ComponentDefine()
end

function UIHeroListItem:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIHeroListItem:ComponentDefine()
  self.uiWorkerShowCell = self:AddComponent(UIWorkerShowCell, uiWorkerShowCell_path)
  self.name = self:AddComponent(UIText, name_path)
  self.place = self:AddComponent(UIText, place_path)
  self.effectItems = {}
  for i = 1, effectShowNum do
    local itemRoot = self:AddComponent(UIBaseContainer, "panel/EffectContent/effect" .. i)
    self.effectItems[i] = {
      root = itemRoot,
      effectText = itemRoot:AddComponent(UIText, "effectText"),
      effectValueText = itemRoot:AddComponent(UIText, "effectValueText")
    }
  end
  self.bgBtn = self:AddComponent(UIButton, bgBtn_path)
  self.garyImg = self:AddComponent(UIButton, garyImg_path)
  self.bgBtn:SetOnClick(function()
    self:OnDispatchingBtnClick()
  end)
  self.gotoUnlockBtn = self:AddComponent(UIButton, gotoUnlockBtn_path)
  self.gotoUnlockBtn:SetOnClick(function()
    self:OnGotoUnlockBtnClick()
  end)
  self.placeContainer = self:AddComponent(UIBaseContainer, pace_container_path)
  self.btn_dispatch = self:AddComponent(UIButton, btn_dispatch_path)
  self.txt_dispatch = self:AddComponent(UITextMeshProUGUIEx, txt_dispatch_path)
  self.btn_dispatch:SetOnClick(function()
    self:OnDispatchingBtnClick()
  end)
  self.txt_dispatch:SetText(Localization:GetString("390146"))
  self.txt_dispatched = self:AddComponent(UITextMeshProUGUIEx, txt_dispatched_path)
  self.txt_dispatched:SetText(Localization:GetString("survivor_tips_01"))
end

function UIHeroListItem:ComponentDestroy()
  self.uiWorkerShowCell = nil
  self.level = nil
  self.name = nil
  self.place = nil
  self.slider = nil
  self.percent = nil
  self.bgBtn = nil
  self.garyImg = nil
  self.effectItems = nil
  self.btn_dispatch = nil
  self.txt_dispatch = nil
  self.txt_dispatched = nil
end

function UIHeroListItem:DataDefine()
  self.param = {}
  self.curBuildData = {}
  self.buildCurLevelTemplate = {}
  self.buildName = nil
end

function UIHeroListItem:DataDestroy()
  self.param = nil
  self.curBuildData = nil
  self.buildCurLevelTemplate = nil
  self.buildName = nil
  self.buildLine = nil
  self.percentStr = nil
end

function UIHeroListItem:OnDispatchingBtnClick()
  if self.param.dispatchingBuildUid ~= nil and self.param.dispatchingBuildUid ~= self.param.curBuildData.uuid and self.param.curBuildData.itemId ~= BuildingTypes.LW_BUILD_LIBRARY then
    UIUtil.ShowMessage(Localization:GetString(120095, self.param:GetName(), self.buildName), 2, GameDialogDefine.CONFIRM, GameDialogDefine.CANCEL, function()
      self:DispatchingHero()
    end)
  elseif self.param.dispatchingBuildUid == self.param.curBuildData.uuid then
    UIManager.Instance:DestroyWindow(UIWindowNames.UIBuildHeroList)
  else
    self:DispatchingHero()
  end
end

function UIHeroListItem:OnGotoUnlockBtnClick()
  UIManager.Instance:OpenWindow(UIWindowNames.UIWorkerOverviewList, {anim = true}, {
    jumpType = 1,
    jumpParam = self.param
  })
end

function UIHeroListItem:DispatchingHero()
  SFSNetwork.SendMessage(MsgDefines.BuildAssignHeroMessage, self.param.curBuildData.uuid, self.param.slot, self.param.uid)
  local text = ""
  for effectId, effectValue in pairs(self.param.effectDict) do
    if 0 < effectValue then
      local curTxt = WorkerUtil.GetEffectText(effectId, effectValue)
      text = text .. curTxt .. " "
    end
  end
  if not string.IsNullOrEmpty(text) then
    UIUtil.ShowTips(text)
  end
  UIManager.Instance:DestroyWindow(UIWindowNames.UIBuildHeroList)
end

function UIHeroListItem:ReInit(param)
  self.param = param
  if type(param) == "table" then
    self:Refresh(param)
  elseif type(param) == "number" then
    self:RefreshToUnlockWorker(param)
  end
end

function UIHeroListItem:Refresh(param)
  self.buildLine = LocalController:instance():getLine(LuaEntry.Player:GetABTestTableName(TableName.Building), self.param.curBuildData.itemId)
  self.percentStr = WorkerUtil.GetWorkerAdditionPropertyStr(param, self.param.curBuildData)
  if param.dispatchingBuildUid then
    self.curBuildData = DataCenter.BuildManager:GetBuildingDataByUuid(param.dispatchingBuildUid)
    self.buildCurLevelTemplate = DataCenter.BuildTemplateManager:GetBuildingLevelTemplate(self.curBuildData.itemId, self.curBuildData.level)
    self.buildName = Localization:GetString(self.buildCurLevelTemplate.name)
    self.btn_dispatch:SetActive(false)
    self.txt_dispatched:SetActive(true)
  else
    self.buildName = Localization:GetString(135190)
    self.btn_dispatch:SetActive(true)
    self.txt_dispatched:SetActive(false)
  end
  self.garyImg:SetActive(self.param.grey)
  local describe, text = WorkerUtil.GetEffectText(tonumber(self.param.peculiarity), tonumber(self.param.peculiarityVlue), true)
  self.uiWorkerShowCell:SetData(self.param.cfgId, self.param.rank)
  self.placeContainer:SetActive(true)
  self.gotoUnlockBtn:SetActive(false)
  self.place:SetText(self.buildName)
  self.name:SetText(param:GetName())
  for i = 1, effectShowNum do
    local effectItem = self.effectItems[i]
    effectItem.root:SetActive(false)
  end
  local effectItemIndex = 1
  for effectId, effectValue in pairs(self.param.effectDict) do
    if 0 < effectValue then
      local describe, text = WorkerUtil.GetEffectText(effectId, effectValue, true)
      if effectItemIndex <= effectShowNum then
        local effectItem = self.effectItems[effectItemIndex]
        effectItem.root:SetActive(true)
        effectItem.effectValueText:SetText(text)
        effectItem.effectText:SetText(describe)
        effectItemIndex = effectItemIndex + 1
      end
    end
  end
end

function UIHeroListItem:RefreshToUnlockWorker(param)
  self.placeContainer:SetActive(false)
  self.gotoUnlockBtn:SetActive(true)
  self.btn_dispatch:SetActive(false)
  self.txt_dispatched:SetActive(false)
  self.uiWorkerShowCell:SetData(param, 0)
  local workerTemplate = DataCenter.WorkerTemplateManager:GetTemplateById(param)
  if workerTemplate then
    self.name:SetText(workerTemplate:GetName())
  else
    self.name:SetText("")
  end
  self.garyImg:SetActive(false)
  local effects = {}
  
  local function insertEffect(effectId, effectValue)
    if effects[effectId] then
      effects[effectId] = effects[effectId] + effectValue
    else
      effects[effectId] = effectValue
    end
  end
  
  if workerTemplate then
    local workerEffect = workerTemplate.effects
    if workerEffect[1] and workerEffect[2] and 0 < workerEffect[1] then
      insertEffect(workerEffect[1], workerEffect[2])
    end
    if workerTemplate.star == 1 then
      local rankTemplate = DataCenter.WorkerRankTemplateManager:GetTemplateByIdAndRank(param, 1)
      if rankTemplate then
        if not table.IsNullOrEmpty(rankTemplate.effect_data) then
          for i = 1, #rankTemplate.effect_data do
            local effectData = rankTemplate.effect_data[i]
            insertEffect(effectData[1], effectData[2])
          end
        end
        if not table.IsNullOrEmpty(rankTemplate.rank_effect_data) and 0 < rankTemplate.rank_effect_data[1] then
          insertEffect(rankTemplate.rank_effect_data[1], rankTemplate.rank_effect_data[2])
        end
      end
    end
  end
  local sortedEffects = {}
  local count = 1
  for effectId, effectValue in pairs(effects) do
    sortedEffects[count] = {id = effectId, val = effectValue}
    count = count + 1
  end
  table.sort(sortedEffects, function(a, b)
    local aSeq = DataCenter.EffectNumberTemplateManager:GetEffectNumberTemplateSequence(a.id)
    local bSeq = DataCenter.EffectNumberTemplateManager:GetEffectNumberTemplateSequence(b.id)
    if aSeq == bSeq then
      return a.id < b.id
    else
      return aSeq < bSeq
    end
  end)
  for i = 1, effectShowNum do
    local effectItem = self.effectItems[i]
    effectItem.root:SetActive(false)
  end
  local effectItemIndex = 1
  for i = 1, #sortedEffects do
    local effectData = sortedEffects[i]
    local effectId = effectData.id
    local effectValue = effectData.val
    if 0 < effectValue then
      local describe, text = WorkerUtil.GetEffectText(effectId, effectValue, true)
      if effectItemIndex <= effectShowNum then
        local effectItem = self.effectItems[effectItemIndex]
        effectItem.root:SetActive(true)
        effectItem.effectValueText:SetText(text)
        effectItem.effectText:SetText(describe)
        effectItemIndex = effectItemIndex + 1
      end
    end
  end
end

return UIHeroListItem
