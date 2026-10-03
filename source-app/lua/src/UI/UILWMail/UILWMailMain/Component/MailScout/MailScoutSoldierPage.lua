local base = UIBaseContainer
local MailScoutSoldierPage = BaseClass("MailScoutSoldierPage", base)
local UISoldierItem = require("UI/UIBuildDispatching/Component/UISoldierItem")
local MailScoutSoldierInfoLine = require("UI/UILWMail/UILWMailMain/Component/MailScout/MailScoutSoldierInfoLine")
local incity_slider_path = "incitySoldiers/OverContent/totalsoldiers/incity_slider"
local incity_capacity_path = "incitySoldiers/OverContent/totalsoldiers/incity_capacity"
local incity_soldierContent_path = "incitySoldiers/OverContent/inCityContenet/incity_soldierContent"
local incity_txt_path = "incitySoldiers/OverContent/inCityContenet/incity_txt"
local hospital_slider_path = "hospitalSoldiers/OverContent/totalsoldiers/hospital_slider"
local soldierEffect_path = "soldierEffect"
local soldierEffect_container_path = "soldierEffect/view"
local hospital_txt_path = "hospitalSoldiers/OverContent/hospitalContent/hospital_txt"
local hospital_soldierContent_path = "hospitalSoldiers/OverContent/hospitalContent/hospital_soldierContent"
local hospital_capacity_path = "hospitalSoldiers/OverContent/totalsoldiers/hospital_capacity"
local incity_content_path = "incitySoldiers/OverContent/inCityContenet"
local hospital_content_path = "hospitalSoldiers/OverContent/hospitalContent"
local incitySoldiers_path = "incitySoldiers"
local hospitalSoldiers_path = "hospitalSoldiers"

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

local function OnDestroy(self)
  self:RemoveSoldiers()
  self:DataDestroy()
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
  self.incity_slider = self:AddComponent(UISlider, incity_slider_path)
  self.incity_capacity = self:AddComponent(UIText, incity_capacity_path)
  self.incity_soldierContent = self:AddComponent(UIBaseContainer, incity_soldierContent_path)
  self.incity_txt = self:AddComponent(UIText, incity_txt_path)
  self.hospital_slider = self:AddComponent(UISlider, hospital_slider_path)
  self.soldierEffect = self:AddComponent(UIBaseContainer, soldierEffect_path)
  self.soldierEffect_container = self:AddComponent(UIBaseContainer, soldierEffect_container_path)
  self.hospital_txt = self:AddComponent(UIBaseContainer, hospital_txt_path)
  self.hospital_soldierContent = self:AddComponent(UIBaseContainer, hospital_soldierContent_path)
  self.hospital_capacity = self:AddComponent(UIText, hospital_capacity_path)
  self.incity_content = self:AddComponent(UIBaseContainer, incity_content_path)
  self.hospital_content = self:AddComponent(UIBaseContainer, hospital_content_path)
  self.incitySoldiers = self:AddComponent(UIBaseContainer, incitySoldiers_path)
  self.hospitalSoldiers = self:AddComponent(UIBaseContainer, hospitalSoldiers_path)
end

local function ComponentDestroy(self)
  self.incity_slider = nil
  self.incity_capacity = nil
  self.incity_soldierContent = nil
  self.incity_txt = nil
  self.hospital_slider = nil
  self.soldierEffect = nil
  self.soldierEffect_container = nil
  self.hospital_txt = nil
  self.hospital_soldierContent = nil
  self.hospital_capacity = nil
  self.incity_content = nil
  self.hospital_content = nil
  self.incitySoldiers = nil
  self.hospitalSoldiers = nil
end

local function DataDefine(self)
  self.citySoldierReqs = {}
  self.hospitalSoldierReqs = {}
  self.soldierEffectReqs = {}
end

local function DataDestroy(self)
end

function MailScoutSoldierPage:RemoveSoldiers()
  self.incity_soldierContent:RemoveComponents(UISoldierItem)
  for i = 1, #self.citySoldierReqs do
    self:GameObjectDestroy(self.citySoldierReqs[i])
  end
  self.citySoldierReqs = {}
  self.hospital_soldierContent:RemoveComponents(UISoldierItem)
  for i = 1, #self.hospitalSoldierReqs do
    self:GameObjectDestroy(self.hospitalSoldierReqs[i])
  end
  self.hospitalSoldierReqs = {}
  self.soldierEffect_container:RemoveComponents(MailScoutSoldierInfoLine)
  for i = 1, #self.soldierEffectReqs do
    self:GameObjectDestroy(self.soldierEffectReqs[i])
  end
  self.soldierEffectReqs = {}
end

function MailScoutSoldierPage:Refresh(mailExt)
  self.extData = mailExt:GetExtData()
  if mailExt then
    mailExt:ParsePlayer()
  end
  self.scoutLv = mailExt.scoutLv or 1
  self.disturbedScoutLv = mailExt.disturbedScoutLv or 1
  self.army = self.extData.army
  self.target = self.army.target
  self:RefreshView(self.extData)
end

local SOLDIER_EFFECT_CONFIG = {
  {
    id = 50065,
    icon = "Assets/Main/Sprites/UI/UILWScience/science_icon30.png"
  },
  {
    id = 50076,
    icon = "Assets/Main/Sprites/UI/UILWScience/science_icon30.png"
  },
  {
    id = 50067,
    icon = "Assets/Main/Sprites/UI/UILWScience/science_icon28.png"
  },
  {
    id = 50077,
    icon = "Assets/Main/Sprites/UI/UILWScience/science_icon28.png"
  },
  {
    id = 50069,
    icon = "Assets/Main/Sprites/UI/UILWScience/science_icon29.png"
  },
  {
    id = 50078,
    icon = "Assets/Main/Sprites/UI/UILWScience/science_icon29.png"
  },
  {
    id = 50080,
    icon = "Assets/Main/Sprites/UI/UILWScience/zyf_kejitubiao_20.png"
  }
}
local SOLDIER_ITEM_PATH = "Assets/Main/Prefabs/UI/LWMail/MailScout/MailScoutSoldierDetail_Item.prefab"

local function RefreshIncitySoldier(self)
  local incitySoldierIsDisturbed = self.disturbedScoutLv < ScoutLevel.InCitySoldierCount
  local allSoldier = self.target.allSoldier
  local allSoldierCount = 0
  for i = 1, #allSoldier do
    local soldier = allSoldier[i]
    if soldier.total and 0 < soldier.total.value then
      allSoldierCount = allSoldierCount + soldier.total.value
    end
  end
  local freeSoldier = self.target.freeSoldier
  local freeSoldierCount = 0
  local showSoldiers = {}
  for i = 1, #freeSoldier do
    local soldier = freeSoldier[i]
    if soldier.total and 0 < soldier.total.value then
      freeSoldierCount = freeSoldierCount + soldier.total.value
      if soldier.type ~= nil then
        showSoldiers[#showSoldiers + 1] = {
          id = soldier.type.value,
          count = soldier.total.value
        }
      end
    end
  end
  if incitySoldierIsDisturbed then
    self.incity_slider:SetValue(0)
    self.incity_capacity:SetText(GameDialogDefine.QUESTION_MARK)
  else
    self.incity_slider:SetValue(freeSoldierCount / allSoldierCount)
    self.incity_capacity:SetText(freeSoldierCount .. "/" .. math.modf(allSoldierCount))
  end
  local isIncitySoldierDetialUnlock = self.scoutLv >= ScoutLevel.InCitySoldierDetail
  if not isIncitySoldierDetialUnlock then
    self.incity_content:SetActive(false)
    return
  end
  self.incity_content:SetActive(true)
  local elevenData = self:GetElevenData()
  if table.IsNullOrEmpty(showSoldiers) then
    self.incity_soldierContent:SetActive(false)
    self.incity_txt:SetActive(true)
  else
    table.sort(showSoldiers, function(a, b)
      return a.id > b.id
    end)
    self.incity_soldierContent:SetActive(true)
    self.incity_txt:SetActive(false)
    local isInCitySoldierDetialDisturbed = self.disturbedScoutLv < ScoutLevel.InCitySoldierDetail
    for i = 1, #showSoldiers do
      local soldier = showSoldiers[i]
      local request = self:GameObjectInstantiateAsync(SOLDIER_ITEM_PATH, function(request)
        local go = request.gameObject
        if IsNull(go) then
          return
        end
        go.gameObject:SetActive(true)
        go.transform:SetParent(self.incity_soldierContent.transform)
        go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
        local nameStr = "UISoldierDetails_Item" .. i
        go.name = nameStr
        local cell = self.incity_soldierContent:AddComponent(UISoldierItem, nameStr)
        cell:SetData(soldier, elevenData)
        if isInCitySoldierDetialDisturbed then
          cell:SetCountText(GameDialogDefine.QUESTION_MARK)
        end
      end)
      self.citySoldierReqs[#self.citySoldierReqs + 1] = request
    end
  end
end

local function RefreshHospitalSoldier(self)
  local playerEffects = self.target.effect
  local isUnlockHospitalSoldierCount = self.scoutLv >= ScoutLevel.HospitalSoldierCount
  if not isUnlockHospitalSoldierCount then
    self.hospitalSoldiers:SetActive(false)
    return
  end
  local hospitalSoldier = self.target.hospitalSoldier
  local hospitalSoldierCount = 0
  local hospitalShowSoldiers = {}
  for i = 1, #hospitalSoldier do
    local soldier = hospitalSoldier[i]
    if soldier.total and 0 < soldier.total.value then
      hospitalSoldierCount = hospitalSoldierCount + soldier.total.value
      if soldier.type ~= nil or 0 < soldier.type.value then
        hospitalShowSoldiers[#hospitalShowSoldiers + 1] = {
          id = soldier.type.value,
          count = soldier.total.value
        }
      end
    end
  end
  local hospitalMax = playerEffects[EffectDefine.LW_HOSPITAL_MAX_STOCK] or 0
  local progerss = 0
  if 0 < hospitalMax then
    progerss = hospitalSoldierCount / hospitalMax
  end
  local isHospitalSoldierCoutnDisturbed = self.disturbedScoutLv < ScoutLevel.HospitalSoldierCount
  if isHospitalSoldierCoutnDisturbed then
    self.hospital_slider:SetValue(0)
    self.hospital_capacity:SetText(GameDialogDefine.QUESTION_MARK)
  else
    self.hospital_slider:SetValue(progerss)
    self.hospital_capacity:SetText(hospitalSoldierCount .. "/" .. math.modf(hospitalMax))
  end
  local isHospitalSoldierDetailUnlock = self.scoutLv >= ScoutLevel.HospitalSoldierDetail
  if not isHospitalSoldierDetailUnlock or table.IsNullOrEmpty(hospitalShowSoldiers) then
    self.hospital_content:SetActive(false)
    return
  end
  self.hospital_content:SetActive(true)
  table.sort(hospitalShowSoldiers, function(a, b)
    return a.id > b.id
  end)
  local elevenData = self:GetElevenData()
  local isHospitalSoldierDetailDisturbed = self.disturbedScoutLv < ScoutLevel.HospitalSoldierDetail
  for i = 1, #hospitalShowSoldiers do
    local soldier = hospitalShowSoldiers[i]
    local request = self:GameObjectInstantiateAsync(SOLDIER_ITEM_PATH, function(request)
      local go = request.gameObject
      if IsNull(go) then
        return
      end
      go.gameObject:SetActive(true)
      go.transform:SetParent(self.hospital_soldierContent.transform)
      go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
      local nameStr = "UISoldierDetails_Item" .. i
      go.name = nameStr
      local cell = self.hospital_soldierContent:AddComponent(UISoldierItem, nameStr)
      cell:SetData(soldier, elevenData)
      if isHospitalSoldierDetailDisturbed then
        cell:SetCountText(GameDialogDefine.QUESTION_MARK)
      end
    end)
    self.hospitalSoldierReqs[#self.hospitalSoldierReqs + 1] = request
  end
end

local function RefreshSoldierEffects(self)
  local playerEffects = self.target.effect
  local isSoldierEffectUnlock = self.scoutLv >= ScoutLevel.SoldierEffect
  if not isSoldierEffectUnlock then
    self.soldierEffect:SetActive(false)
    return
  end
  self.soldierEffect:SetActive(true)
  local showSoldierEffect = {}
  for i = 1, #SOLDIER_EFFECT_CONFIG do
    local effectId = SOLDIER_EFFECT_CONFIG[i].id
    local icon = SOLDIER_EFFECT_CONFIG[i].icon
    local value = playerEffects[effectId]
    showSoldierEffect[#showSoldierEffect + 1] = {
      id = effectId,
      value = value or 0,
      icon = icon
    }
  end
  if table.IsNullOrEmpty(showSoldierEffect) then
    self.soldierEffect:SetActive(false)
  else
    self.soldierEffect:SetActive(true)
    local isSoldierEffectDisturbed = self.disturbedScoutLv < ScoutLevel.SoldierEffect
    for i = 1, #showSoldierEffect do
      local effect = showSoldierEffect[i]
      local request = self:GameObjectInstantiateAsync("Assets/Main/Prefabs/UI/LWMail/MailScout/SoldierInoCell.prefab", function(request)
        local go = request.gameObject
        if IsNull(go) then
          return
        end
        go.gameObject:SetActive(true)
        local transform = go.transform
        transform:SetParent(self.soldierEffect_container.transform)
        transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
        transform:Set_localPosition(0, 0, 0)
        local nameStr = "MailScoutSoldierInfoLine" .. i
        go.name = nameStr
        local cell = self.soldierEffect_container:AddComponent(MailScoutSoldierInfoLine, nameStr)
        cell:SetData(effect.id, effect.value, effect.icon)
        if isSoldierEffectDisturbed then
          cell:SetValueStr(GameDialogDefine.QUESTION_MARK)
        end
      end)
      self.soldierEffectReqs[#self.soldierEffectReqs + 1] = request
    end
  end
end

function MailScoutSoldierPage:RefreshView(data)
  self:RemoveSoldiers()
  RefreshIncitySoldier(self)
  RefreshHospitalSoldier(self)
  RefreshSoldierEffects(self)
end

function MailScoutSoldierPage:GetElevenData()
  if not self.target or not self.target.formation then
    return {stage = 0, type = 0}
  end
  local formation = self.target.formation[1]
  local soldierType, stage
  if formation then
    local soldierEleven = formation.soldierEleven
    soldierType = T11Util.GetSoldierTypeByEffectList(soldierEleven and soldierEleven.effects or nil)
    stage = soldierEleven and soldierEleven.stage or 0
  end
  return {stage = stage, type = soldierType}
end

MailScoutSoldierPage.OnCreate = OnCreate
MailScoutSoldierPage.OnDestroy = OnDestroy
MailScoutSoldierPage.OnEnable = OnEnable
MailScoutSoldierPage.OnDisable = OnDisable
MailScoutSoldierPage.ComponentDefine = ComponentDefine
MailScoutSoldierPage.ComponentDestroy = ComponentDestroy
MailScoutSoldierPage.DataDefine = DataDefine
MailScoutSoldierPage.DataDestroy = DataDestroy
return MailScoutSoldierPage
