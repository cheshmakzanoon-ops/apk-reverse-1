local UIHeroListItem = BaseClass("UIHeroListItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local UIWorkerShowCell = require("UI.UILWWorker.UIWorkerOverviewList.Component.UIWorkerShowCell")
local uiWorkerShowCell_path = "bg/WorkerCellContent/UIWorkerShowCell"
local name_path = "bg/name"
local effect_path = "bg/EffectContent/effect"
local state_icon_path = "bg/WorkerCellContent/stateIcon"
local first_name_path = "bg/WorkerCellContent/firstName"
local bg_path = "bg"
local garyImg_path = "bg/WorkerCellContent/workingContent"
local frag_content_path = "bg/WorkerCellContent/fragContent"
local frag_num_bg_path = "bg/WorkerCellContent/fragContent/fragNumContent/fragNumBg"
local frag_num_img_path = "bg/WorkerCellContent/fragContent/fragNumContent/fragNumBg/fragNumImg"
local frag_num_text_path = "bg/WorkerCellContent/fragContent/fragNumText"
local effectShowNum = 2

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
  self.effectItems = {}
  for i = 1, effectShowNum do
    local itemRoot = self:AddComponent(UIBaseContainer, effect_path .. i)
    self.effectItems[i] = {
      root = itemRoot,
      effectText = itemRoot:AddComponent(UIText, "effectText"),
      effectValueText = itemRoot:AddComponent(UIText, "effectValueText")
    }
  end
  self.garyImg = self:AddComponent(UIButton, garyImg_path)
  self.state_icon = self:AddComponent(UIImage, state_icon_path)
  self.first_name = self:AddComponent(UITextMeshProUGUIEx, first_name_path)
  self.bg = self:AddComponent(UIImage, bg_path)
  self.root = self:AddComponent(UIButton, "")
  self.root:SetOnClick(function()
    self:OnItemClick()
  end)
  self.frag_content = self:AddComponent(UIImage, frag_content_path)
  self.frag_num_bg = self:AddComponent(UIImage, frag_num_bg_path)
  self.frag_num_img = self:AddComponent(UIImage, frag_num_img_path)
  self.frag_num_text = self:AddComponent(UITextMeshProUGUIEx, frag_num_text_path)
end

function UIHeroListItem:ComponentDestroy()
  self.uiWorkerShowCell = nil
  self.name = nil
  self.garyImg = nil
  self.state_icon = nil
  self.first_name = nil
  self.frag_content = nil
  self.frag_num_bg = nil
  self.frag_num_img = nil
  self.frag_num_text = nil
end

function UIHeroListItem:DataDefine()
  self.param = {}
  self.itemIndex = nil
  self.beSelectIndex = nil
  self.bgBeSelectCallBack = nil
  self.curBuildData = {}
  self.buildCurLevelTemplate = {}
  self.buildName = nil
end

function UIHeroListItem:DataDestroy()
  self.param = nil
  self.itemIndex = nil
  self.beSelectIndex = nil
  self.bgBeSelectCallBack = nil
  self.curBuildData = nil
  self.buildCurLevelTemplate = nil
  self.buildName = nil
  self.buildLine = nil
  self.percentStr = nil
end

function UIHeroListItem:ReInit(param, itemIndex, beSelectIndex, bgBeSelectCallBack)
  self.param = param
  self.itemIndex = itemIndex
  self.beSelectIndex = beSelectIndex
  self.bgBeSelectCallBack = bgBeSelectCallBack
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
    self.state_icon:SetActive(true)
    self.state_icon:LoadSprite(string.format(LoadPath.UIWorkerSpritePath, "FX_XCZ_gongzuo_icon"))
  else
    self.buildName = Localization:GetString(135190)
    self.state_icon:SetActive(false)
  end
  self.garyImg:SetActive(self.param.grey)
  self.frag_content:SetActive(false)
  self.uiWorkerShowCell:SetData(self.param.cfgId, self.param.rank)
  self.name:SetLocalText(param.lastName)
  self.first_name:SetLocalText(param.firstName)
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
  if self.beSelectIndex == self.itemIndex then
    self.bg:LoadSprite(string.format(LoadPath.UIWorkerSpritePath, "Mjc_xcz_list_bg2"))
  else
    self.bg:LoadSprite(string.format(LoadPath.UIWorkerSpritePath, "Mjc_xcz_list_bg1"))
  end
end

function UIHeroListItem:RefreshToUnlockWorker(param)
  self.state_icon:SetActive(false)
  self.uiWorkerShowCell:SetData(param, 0)
  local workerTemplate = DataCenter.WorkerTemplateManager:GetTemplateById(param)
  if workerTemplate then
    self.name:SetLocalText(workerTemplate.last_name)
    self.first_name:SetLocalText(workerTemplate.first_name)
  else
    self.name:SetText("")
    self.first_name:SetText("")
  end
  self.garyImg:SetActive(false)
  self.frag_content:SetActive(true)
  local fragData = DataCenter.WorkerDataManager:GetFragDataById(param)
  if fragData then
    local needNum = fragData.needNum
    local goodsId = fragData.itemCfg.id
    local curNum = DataCenter.ItemData:GetItemCount(goodsId) or 0
    self.frag_num_text:SetText(string.format("%d/%d", curNum, needNum))
    local bgSize = self.frag_num_bg:GetSizeDelta()
    local numProgress = curNum / needNum
    if 1 <= numProgress then
      numProgress = 1
    end
    self.frag_num_img:SetSizeDeltaXY(bgSize.x * numProgress, bgSize.y - 2)
    local imgPath = "Assets/Main/Sprites/UI/LWDecorationBook/Mjc_zhuagnshiwugongfang_jindutiao_03.png"
    self.frag_num_img:LoadSprite(imgPath)
  end
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
  if self.beSelectIndex == self.itemIndex then
    self.bg:LoadSprite(string.format(LoadPath.UIWorkerSpritePath, "Mjc_xcz_list_bg2"))
  else
    self.bg:LoadSprite(string.format(LoadPath.UIWorkerSpritePath, "Mjc_xcz_list_bg1"))
  end
end

function UIHeroListItem:OnItemClick()
  if self.beSelectIndex == self.itemIndex then
    return
  end
  if self.bgBeSelectCallBack then
    self.bgBeSelectCallBack(self.itemIndex)
  end
end

return UIHeroListItem
