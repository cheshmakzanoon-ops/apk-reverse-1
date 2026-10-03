local base = UIBaseContainer
local UILWMailBattleSkinViewComponent = BaseClass("UILWMailBattleSkinViewComponent", UIBaseContainer)
local UILWMailBattleSkinItemComponent = require("UI.UILWMail.UILWMailMain.Component.MailSkin.UILWMailBattleSkinItemComponent")
local Localization = CS.GameEntry.Localization
local EffectDropdown = require("UI.UILWMail.UILWMailMain.Component.MailBattle.EffectDropdown")
local BarViewParam = EffectDropdown.BarViewParam

function UILWMailBattleSkinViewComponent:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UILWMailBattleSkinViewComponent:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UILWMailBattleSkinViewComponent:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.textPower1Txt = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 1)
  self.textPower2Txt = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 2)
  self.compContent = self.viewSkin:AddComponent(self, UIBaseContainer, 3)
  self.compBattleReportEffectDropdown = self.viewSkin:AddComponent(self, EffectDropdown, 4)
  self.compBattleReportEffectDropdown:SetTitle(Localization:GetString("100233"))
  self.compBattleReportEffectDropdown:SetDataFunc(function()
    return self:GetEffectData()
  end)
end

function UILWMailBattleSkinViewComponent:ComponentDestroy()
  self:ClearAllItems()
  self.viewSkin = nil
  self.textPower1Txt = nil
  self.textPower2Txt = nil
  self.compContent = nil
  self.compBattleReportEffectDropdown = nil
end

function UILWMailBattleSkinViewComponent:DataDefine()
  self.extData = nil
  self.progress1 = nil
  self.progress2 = nil
  self.progressSingleDict = nil
  self.effectData = {}
end

function UILWMailBattleSkinViewComponent:DataDestroy()
  self.extData = nil
  self.progress1 = nil
  self.progress2 = nil
  self.progressSingleDict = nil
  self.effectData = nil
end

function UILWMailBattleSkinViewComponent:ReInit(extData)
  self.extData = extData
  self.progress1 = extData.player[1].progress
  self.progress2 = extData.player[2].progress
  self.progressSingleDict = {}
  if self.progress1.skinProgress and not table.IsNullOrEmpty(self.progress1.skinProgress.skinProgressSingle) then
    for i, v in pairs(self.progress1.skinProgress.skinProgressSingle) do
      local skinType = v.type
      if self.progressSingleDict[skinType] == nil then
        self.progressSingleDict[skinType] = {}
      end
      self.progressSingleDict[skinType][1] = v
    end
  end
  if self.progress2.skinProgress and not table.IsNullOrEmpty(self.progress2.skinProgress.skinProgressSingle) then
    for i, v in pairs(self.progress2.skinProgress.skinProgressSingle) do
      local skinType = v.type
      if self.progressSingleDict[skinType] == nil then
        self.progressSingleDict[skinType] = {}
      end
      self.progressSingleDict[skinType][2] = v
    end
  end
  for skinType, singleData in pairs(self.progressSingleDict) do
    local leftSkinId = checknumber(singleData[1] and singleData[1].skinId or 0)
    local rightSkinId = checknumber(singleData[2] and singleData[2].skinId or 0)
    local leftNum = checknumber(singleData[1] and singleData[1].num or 0)
    local rightNum = checknumber(singleData[2] and singleData[2].num or 0)
    local isLeftOnlyDefault = leftSkinId == 0 and leftNum == 1
    local isRightOnlyDefault = rightSkinId == 0 and rightNum == 1
    if isLeftOnlyDefault and isRightOnlyDefault then
      self.progressSingleDict[skinType] = nil
    end
  end
  for skinType, singleData in pairs(self.progressSingleDict) do
    if singleData[1] == nil then
      singleData[1] = {}
    end
    if singleData[1].skinId == nil or singleData[1].skinId <= 0 then
      singleData[1].skinId = self:GetDefaultSkinIdByType(skinType)
    end
    if singleData[2] == nil then
      singleData[2] = {}
    end
    if singleData[2].skinId == nil or singleData[2].skinId <= 0 then
      singleData[2].skinId = self:GetDefaultSkinIdByType(skinType)
    end
  end
  local skinPower1 = 0
  if self.progress1 and self.progress1.skinProgress then
    skinPower1 = self.progress1.skinProgress.power
  end
  local skinPower2 = 0
  if self.progress2 and self.progress2.skinProgress then
    skinPower2 = self.progress2.skinProgress.power
  end
  self.textPower1Txt:SetText(Localization:GetString("100253") .. " " .. string.GetFormattedStr(math.floor(skinPower1)))
  self.textPower2Txt:SetText(Localization:GetString("100253") .. " " .. string.GetFormattedStr(math.floor(skinPower2)))
  self:ClearAllItems()
  for skinType, data in pairs(self.progressSingleDict) do
    self.reqs[skinType] = self:GameObjectInstantiateAsync(UIAssets.UILWMailBattleSkinItem, function(request)
      if request.isError then
        return
      end
      local go = request.gameObject
      go.transform:SetParent(self.compContent.transform)
      go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
      go.name = "UILWMailBattleSkinItem_" .. skinType
      local cell = self.compContent:AddComponent(UILWMailBattleSkinItemComponent, go.name)
      cell:ReInit(skinType, data)
    end)
  end
  self.effectData = nil
end

function UILWMailBattleSkinViewComponent:ClearAllItems()
  self.compContent:RemoveComponents(UILWMailBattleSkinItemComponent)
  if self.reqs ~= nil then
    for _, v in pairs(self.reqs) do
      if v ~= nil then
        self:GameObjectDestroy(v)
      end
    end
  end
  self.reqs = {}
end

function UILWMailBattleSkinViewComponent:GetEffectData()
  if self.effectData then
    return self.effectData
  end
  self.effectData = {}
  local effectDictTmp = {}
  if self.progress1.skinProgress and self.progress1.skinProgress.skinEffects and not table.IsNullOrEmpty(self.progress1.skinProgress.skinEffects) then
    for _, effect in pairs(self.progress1.skinProgress.skinEffects) do
      local effectId = effect.id
      if effectId == HeroEffectDefine.SkillAllDamageAddRateSingle then
        effectId = HeroEffectDefine.SkillAllDamageAddRate
      end
      if effectDictTmp[effectId] == nil then
        effectDictTmp[effectId] = {leftTotal = 0, rightTotal = 0}
      end
      effectDictTmp[effectId].leftTotal = effectDictTmp[effectId].leftTotal + effect.val
    end
  end
  if self.progress2.skinProgress and self.progress2.skinProgress.skinEffects and not table.IsNullOrEmpty(self.progress2.skinProgress.skinEffects) then
    for _, effect in pairs(self.progress2.skinProgress.skinEffects) do
      local effectId = effect.id
      if effectId == HeroEffectDefine.SkillAllDamageAddRateSingle then
        effectId = HeroEffectDefine.SkillAllDamageAddRate
      end
      if effectDictTmp[effectId] == nil then
        effectDictTmp[effectId] = {leftTotal = 0, rightTotal = 0}
      end
      effectDictTmp[effectId].rightTotal = effectDictTmp[effectId].rightTotal + effect.val
    end
  end
  local myCamp = self.extData:GetMyCamp()
  for effectId, effectDataTmp in pairs(effectDictTmp) do
    local effectType = DataCenter.EffectNumberTemplateManager:GetEffectNumberType(effectId)
    if effectDataTmp.leftTotal > 0 or 0 < effectDataTmp.rightTotal then
      local effectName = DataCenter.EffectNumberTemplateManager:GetEffectNumberName(effectId)
      local effectData = BarViewParam.New(Localization:GetString(effectName), effectType, effectDataTmp.leftTotal, effectDataTmp.rightTotal, myCamp)
      table.insert(self.effectData, effectData)
    end
  end
  return self.effectData
end

function UILWMailBattleSkinViewComponent:GetDefaultSkinIdByType(skinType)
  local allId = DataCenter.DecorationTemplateManager:GetDefaultDecorationsByType(skinType)
  if allId == nil or allId[1] == nil then
    return 0
  end
  return allId[1]
end

return UILWMailBattleSkinViewComponent
