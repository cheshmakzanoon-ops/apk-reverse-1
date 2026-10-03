local ActMonopolyEffectContent = BaseClass("ActMonopolyEffectContent", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local LevelUpEffectItem = require("UI.UIActivityCenterTable.Component.ActMonopoly.ActMonopolyMainUIEffect.LevelUpEffectItem")
local GoodsNumEffectItem = require("UI.UIActivityCenterTable.Component.ActMonopoly.ActMonopolyMainUIEffect.GoodsNumEffectItem")
local effect_content_path = "CenterMonopolyContent/effectContent"
local eff_ui_up_txt_path = "CenterMonopolyContent/effectItems/Eff_ui_up_txt"
local eff_ui_levelup_txt_path = "CenterMonopolyContent/effectItems/Eff_ui_levelup_txt"
local LevelUpEffectItemExpiredTime = 1000

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

local function OnDestroy(self)
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

local function ComponentDefine(self)
  self.effect_content = self:AddComponent(UIBaseContainer, effect_content_path)
  self.eff_ui_up_txt_list = {}
  self.eff_ui_up_txt = self:AddComponent(UIBaseContainer, eff_ui_up_txt_path)
  self.eff_ui_up_txt:SetActive(false)
  self.eff_ui_up_txt.gameObject:GameObjectCreatePool()
  self.eff_ui_levelup_txt_list = {}
  self.eff_ui_levelup_txt = self:AddComponent(UIBaseContainer, eff_ui_levelup_txt_path)
  self.eff_ui_levelup_txt:SetActive(false)
  self.eff_ui_levelup_txt.gameObject:GameObjectCreatePool()
end

local function ComponentDestroy(self)
  self:ClearAllEffect()
  self.effect_content = nil
  self.eff_ui_up_txt = nil
  self.eff_ui_levelup_txt = nil
end

local function DataDefine(self)
  self.nextRefreshTime = -1
end

local function DataDestroy(self)
  self.nextRefreshTime = nil
end

local function ClearAllEffect(self)
  self.effect_content:RemoveComponents(LevelUpEffectItem)
  self.effect_content:RemoveComponents(GoodsNumEffectItem)
  for _, v in ipairs(self.effect_content.transform) do
    if v ~= nil then
      CS.UnityEngine.GameObject.Destroy(v.gameObject)
    end
  end
  self.eff_ui_up_txt.gameObject:GameObjectRecycleAll()
  self.eff_ui_up_txt_list = {}
  self.eff_ui_levelup_txt.gameObject:GameObjectRecycleAll()
  self.eff_ui_levelup_txt_list = {}
end

local function SetData(self, mainView, activityId, activityInfo, activityDetailData, costData, isBoss)
  self.mainView = mainView
  self.activityId = activityId
  self.activityInfo = activityInfo
  self.activityDetailData = activityDetailData
  self.costData = costData
  self.isBoss = isBoss
  self.nextRefreshTime = -1
  self:ClearAllEffect()
end

local function Update100MS(self, forceRefresh)
  local curTime = UITimeManager:GetInstance():GetServerTime()
  if forceRefresh == true then
    self.nextRefreshTime = -1
    for i = 1, #self.eff_ui_levelup_txt_list do
      if self.eff_ui_levelup_txt_list[i].isExpired == false and (self.nextRefreshTime < 0 or self.nextRefreshTime < self.eff_ui_levelup_txt_list[i].expiredTime) then
        self.nextRefreshTime = self.eff_ui_levelup_txt_list[i].expiredTime
      end
    end
    for i = 1, #self.eff_ui_up_txt_list do
      if self.eff_ui_up_txt_list[i].isExpired == false and (self.nextRefreshTime < 0 or self.nextRefreshTime < self.eff_ui_up_txt_list[i].expiredTime) then
        self.nextRefreshTime = self.eff_ui_up_txt_list[i].expiredTime
      end
    end
  end
  if self.nextRefreshTime < 0 or curTime < self.nextRefreshTime then
    return
  end
  self.nextRefreshTime = -1
  for i = 1, #self.eff_ui_levelup_txt_list do
    if self.eff_ui_levelup_txt_list[i].isExpired == false then
      if curTime >= self.eff_ui_levelup_txt_list[i].expiredTime then
        self.eff_ui_levelup_txt_list[i].isExpired = true
        self.eff_ui_levelup_txt_list[i].item:SetActive(false)
      elseif self.nextRefreshTime < 0 or self.nextRefreshTime < self.eff_ui_levelup_txt_list[i].expiredTime then
        self.nextRefreshTime = self.eff_ui_levelup_txt_list[i].expiredTime
      end
    end
  end
  for i = 1, #self.eff_ui_up_txt_list do
    if self.eff_ui_up_txt_list[i].isExpired == false then
      if curTime >= self.eff_ui_up_txt_list[i].expiredTime then
        self.eff_ui_up_txt_list[i].isExpired = true
        self.eff_ui_up_txt_list[i].item:SetActive(false)
      elseif self.nextRefreshTime < 0 or self.nextRefreshTime < self.eff_ui_up_txt_list[i].expiredTime then
        self.nextRefreshTime = self.eff_ui_up_txt_list[i].expiredTime
      end
    end
  end
end

local function TryPlayLevelUpEffect(self, data, sAnchoredPosX, sAnchoredPosY)
  local curTime = UITimeManager:GetInstance():GetServerTime()
  local canUseIndex = -1
  for i = 1, #self.eff_ui_levelup_txt_list do
    if self.eff_ui_levelup_txt_list[i].isExpired == true then
      canUseIndex = i
      break
    end
  end
  if canUseIndex < 0 then
    canUseIndex = #self.eff_ui_levelup_txt_list + 1
    local item = self.eff_ui_levelup_txt.gameObject:GameObjectSpawn(self.effect_content.transform)
    item.name = "Eff_ui_levelup_txt_" .. canUseIndex
    item:SetActive(true)
    local obj = self.effect_content:AddComponent(LevelUpEffectItem, item.name)
    self.eff_ui_levelup_txt_list[canUseIndex] = {
      index = canUseIndex,
      expiredTime = 0,
      isExpired = true,
      item = obj,
      data = nil
    }
  end
  self.eff_ui_levelup_txt_list[canUseIndex].expiredTime = curTime + LevelUpEffectItemExpiredTime
  self.eff_ui_levelup_txt_list[canUseIndex].isExpired = false
  self.eff_ui_levelup_txt_list[canUseIndex].data = data
  self.eff_ui_levelup_txt_list[canUseIndex].item:SetAnchoredPositionXY(sAnchoredPosX, sAnchoredPosY)
  self.eff_ui_levelup_txt_list[canUseIndex].item:SetActive(true)
  self.eff_ui_levelup_txt_list[canUseIndex].item:SetData(data)
  self:Update100MS(true)
end

local function TryPlayGoodsNumEffect(self, data, sAnchoredPosX, sAnchoredPosY)
  local curTime = UITimeManager:GetInstance():GetServerTime()
  local canUseIndex = -1
  for i = 1, #self.eff_ui_up_txt_list do
    if self.eff_ui_up_txt_list[i].isExpired == true then
      canUseIndex = i
      break
    end
  end
  if canUseIndex < 0 then
    canUseIndex = #self.eff_ui_up_txt_list + 1
    local item = self.eff_ui_up_txt.gameObject:GameObjectSpawn(self.effect_content.transform)
    item.name = "Eff_ui_up_txt_" .. canUseIndex
    item:SetActive(true)
    local obj = self.effect_content:AddComponent(GoodsNumEffectItem, item.name)
    self.eff_ui_up_txt_list[canUseIndex] = {
      index = canUseIndex,
      expiredTime = 0,
      isExpired = true,
      item = obj,
      data = nil
    }
  end
  self.eff_ui_up_txt_list[canUseIndex].expiredTime = curTime + LevelUpEffectItemExpiredTime
  self.eff_ui_up_txt_list[canUseIndex].isExpired = false
  self.eff_ui_up_txt_list[canUseIndex].data = data
  self.eff_ui_up_txt_list[canUseIndex].item:SetAnchoredPositionXY(sAnchoredPosX, sAnchoredPosY)
  self.eff_ui_up_txt_list[canUseIndex].item:SetActive(true)
  self.eff_ui_up_txt_list[canUseIndex].item:SetData(data)
  self:Update100MS(true)
end

ActMonopolyEffectContent.OnCreate = OnCreate
ActMonopolyEffectContent.OnDestroy = OnDestroy
ActMonopolyEffectContent.ComponentDefine = ComponentDefine
ActMonopolyEffectContent.ComponentDestroy = ComponentDestroy
ActMonopolyEffectContent.DataDefine = DataDefine
ActMonopolyEffectContent.DataDestroy = DataDestroy
ActMonopolyEffectContent.ClearAllEffect = ClearAllEffect
ActMonopolyEffectContent.SetData = SetData
ActMonopolyEffectContent.Update100MS = Update100MS
ActMonopolyEffectContent.TryPlayLevelUpEffect = TryPlayLevelUpEffect
ActMonopolyEffectContent.TryPlayGoodsNumEffect = TryPlayGoodsNumEffect
return ActMonopolyEffectContent
