local TacticalCardView = BaseClass("TacticalCardView", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local TacticalCardRow = require("UI.UILWMail.UILWMailMain.Component.MailBattle.TacticalCard.TacticalCardRow")
local EffectDropdown = require("UI.UILWMail.UILWMailMain.Component.MailBattle.EffectDropdown")
local BarViewParam = EffectDropdown.BarViewParam

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
end

local function OnDestroy(self)
  self.effectData = nil
  self.extData = nil
  self:RemoveCards()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function ComponentDefine(self)
  self.cards = self:AddComponent(UIBaseContainer, "cards")
  self.power1_txt = self:AddComponent(UIText, "title/power1_txt")
  self.power2_txt = self:AddComponent(UIText, "title/power2_txt")
  self.rowTemplate = self:AddComponent(UIBaseContainer, "cardsRow")
  self.rowTemplate.gameObject:GameObjectCreatePool()
  self.effectDropdown = self:AddComponent(EffectDropdown, "dropdown")
  self.effectDropdown:SetTitle(Localization:GetString("100233"))
  self.effectDropdown:SetDataFunc(function()
    return self:GetEffectData()
  end)
  self.rows = {}
end

function TacticalCardView:GetEffectData()
  if self.effectData then
    return self.effectData
  end
  self.effectData = {}
  local player1Attrs, player2Attrs, player1SkillAttrs, player2SkillAttrs
  local battleReportEffect = DataCenter.TacticalCardDataManager:GetBattleReportEffect()
  if self.extData.version >= NEW_CARD_EFFECT_VERSION then
    local function ArrayToMap(arr)
      local tempMap = {}
      
      for _, effect in pairs(arr) do
        local val = tempMap[effect.id] or 0
        tempMap[effect.id] = val + effect.val
      end
      return tempMap
    end
    
    if self.extData.player[1] and self.extData.player[1].battleCard then
      player1Attrs = self.extData.player[1].battleCard.effects
      player1SkillAttrs = self.extData.player[1].battleCard.skillEffects
      if player1Attrs and 0 < #player1Attrs then
        player1Attrs = ArrayToMap(player1Attrs)
      end
      if player1SkillAttrs and 0 < #player1SkillAttrs then
        player1SkillAttrs = ArrayToMap(player1SkillAttrs)
      end
    else
      player1Attrs = {}
      player1SkillAttrs = {}
    end
    if self.extData.player[2] and self.extData.player[2].battleCard then
      player2Attrs = self.extData.player[2].battleCard.effects
      player2SkillAttrs = self.extData.player[2].battleCard.skillEffects
      if player2Attrs and 0 < #player2Attrs then
        player2Attrs = ArrayToMap(player2Attrs)
      end
      if player2SkillAttrs and 0 < #player2SkillAttrs then
        player2SkillAttrs = ArrayToMap(player2SkillAttrs)
      end
    else
      player2Attrs = {}
      player2SkillAttrs = {}
    end
  else
    player1Attrs = self.extData:ParsecCardAttrs(1)
    player2Attrs = self.extData:ParsecCardAttrs(2)
    player1SkillAttrs = self.extData:GetEffectFromPlayer(1)
    player2SkillAttrs = self.extData:GetEffectFromPlayer(2)
  end
  local myCamp = self.extData:GetMyCamp()
  for id, effectData in pairs(battleReportEffect) do
    local leftTotal = 0
    local rightTotal = 0
    local effectIdMap = effectData.effectId
    local skillEffectIdMap = effectData.skillEffectId
    local effectType
    for effectId, _ in pairs(effectIdMap) do
      if player1Attrs[effectId] then
        leftTotal = leftTotal + player1Attrs[effectId]
      end
      if player2Attrs[effectId] then
        rightTotal = rightTotal + player2Attrs[effectId]
      end
      effectType = effectType or DataCenter.EffectNumberTemplateManager:GetEffectNumberType(effectId)
    end
    for skillEffectId, _ in pairs(skillEffectIdMap) do
      if player1SkillAttrs[skillEffectId] then
        leftTotal = leftTotal + player1SkillAttrs[skillEffectId]
      end
      if player2SkillAttrs[skillEffectId] then
        rightTotal = rightTotal + player2SkillAttrs[skillEffectId]
      end
      effectType = effectType or DataCenter.EffectNumberTemplateManager:GetEffectNumberType(skillEffectId)
    end
    if 0 < leftTotal or 0 < rightTotal then
      local effectData = BarViewParam.New(Localization:GetString(effectData.desc), effectType, leftTotal, rightTotal, myCamp)
      table.insert(self.effectData, effectData)
    end
  end
  return self.effectData
end

local function ComponentDestroy(self)
  self.cards = nil
  self.rowTemplate = nil
  self.rows = nil
end

function TacticalCardView:SetData(extData)
  self:RefreshData(extData)
  self.extData = extData
  self.effectData = nil
  local power1 = 0
  local power2 = 0
  if extData.player[1] and extData.player[1].battleCard then
    power1 = extData.player[1].battleCard.power
  end
  if extData.player[2] and extData.player[2].battleCard then
    power2 = extData.player[2].battleCard.power
  end
  self.power1_txt:SetText(Localization:GetString("100253") .. " " .. string.GetFormattedStr(math.floor(power1)))
  self.power2_txt:SetText(Localization:GetString("100253") .. " " .. string.GetFormattedStr(math.floor(power2)))
  self:RefreshCards()
end

function TacticalCardView:RefreshData(extData)
  self.hero = extData.hero
  self.progress1 = extData.player[1].progress
  self.progress2 = extData.player[2].progress
  self.leftCardMap, self.rightCardMap = extData:ParseCardMap()
  self.rows = self:CardMapToViewRow(self.leftCardMap, self.rightCardMap)
end

local ROW_LIMIT = 4

function TacticalCardView:CardMapToViewRow(leftCardMap, rightCardMap)
  local rows = {}
  for rowType, slots in pairs(TacticalCardUtil.ROW_SLOT_MAP) do
    local oneTypeRows = {}
    local arr1 = {}
    local arr2 = {}
    for _, slot in pairs(slots) do
      local leftCard = leftCardMap[slot]
      local rightCard = rightCardMap[slot]
      if leftCard then
        table.insert(arr1, leftCard)
      end
      if rightCard then
        table.insert(arr2, rightCard)
      end
    end
    local maxCount = math.max(#arr1, #arr2)
    if rowType ~= TacticalCardType.Economy then
      for i = maxCount, 1, -ROW_LIMIT do
        local row = {
          left = {},
          right = {}
        }
        local start = i - ROW_LIMIT + 1
        if start < 1 then
          start = 1
        end
        for j = start, i do
          table.insert(row.left, arr1[j])
          local reverseJ = #arr2 - j + 1
          table.insert(row.right, arr2[reverseJ])
        end
        table.insert(oneTypeRows, 1, row)
      end
    else
      for i = 1, maxCount, ROW_LIMIT do
        local row = {
          left = {},
          right = {}
        }
        local startId = i
        local endId = i + ROW_LIMIT - 1
        if maxCount < endId then
          endId = maxCount
        end
        for j = startId, endId do
          table.insert(row.left, arr1[j])
          local reverseJ = #arr2 - j + 1
          table.insert(row.right, arr2[reverseJ])
        end
        table.insert(oneTypeRows, 1, row)
      end
    end
    if not table.IsNullOrEmpty(oneTypeRows) then
      table.extendArray(rows, oneTypeRows)
    end
  end
  return rows
end

function TacticalCardView:RemoveCards()
  self.cards:RemoveAllComponentes()
  self.rowTemplate.gameObject:GameObjectRecycleAll()
end

function TacticalCardView:RefreshCards()
  local hasCards = not table.IsNullOrEmpty(self.leftCardMap) or not table.IsNullOrEmpty(self.rightCardMap)
  if not hasCards then
    self:SetActive(false)
    return
  end
  self:SetActive(true)
  self:RemoveCards()
  for index, row in pairs(self.rows) do
    local rowObj = self.rowTemplate.gameObject:GameObjectSpawn()
    rowObj.name = string.format("row_%d", index)
    rowObj:SetActive(true)
    rowObj.transform:SetParent(self.cards.transform)
    rowObj.transform:Set_localPosition(0, 0, 0)
    rowObj.transform:Set_localScale(1, 1, 1)
    local rowItem = self.cards:AddComponent(TacticalCardRow, rowObj)
    rowItem:RefreshCards(row)
  end
end

TacticalCardView.OnCreate = OnCreate
TacticalCardView.OnDestroy = OnDestroy
TacticalCardView.OnEnable = OnEnable
TacticalCardView.OnDisable = OnDisable
TacticalCardView.ComponentDefine = ComponentDefine
TacticalCardView.ComponentDestroy = ComponentDestroy
return TacticalCardView
