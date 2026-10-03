local UIBattlePassNewYearItemCell = BaseClass("UIBattlePassNewYearItemCell", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local lock_icon_path = "lock_icon"
local commonResItem_path = "UICommonResItem"
local obj_path = ""
local blackBg_path = "BlackBg"
local lockBg_path = "LockBg"
local UIGray = CS.UIGray

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
  self.obj = self:AddComponent(UIBaseContainer, obj_path)
  self.lock_icon = self:AddComponent(UIImage, lock_icon_path)
  self.resItem = self:AddComponent(UICommonResItem, commonResItem_path)
  self.blackBg = self:AddComponent(UIImage, blackBg_path)
  self.lockBg = self:AddComponent(UIImage, lockBg_path)
end

local function ComponentDestroy(self)
  self.lock_icon = nil
  self.reward = nil
  self.reward_effect = nil
  self.resItem = nil
  self.blackBg = nil
end

local function DataDefine(self)
end

local function DataDestroy(self)
  if self.effectObj ~= nil then
    self:GameObjectDestroy(self.effectObj)
  end
  self.effectObj = nil
end

local function OnAddListener(self)
  base.OnAddListener(self)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
end

local function SetData(self, param)
  self.param = DeepCopy(param)
  if param.state == 0 and not param.locked and (param.isFree or param.isPay and param.unlock or param.isHighPay and param.high_unlock) then
    function param.reward.clickCallBack()
      if self.holder then
        self.holder:OnClckRewardItem(self.param)
      end
    end
  end
  self.resItem:ReInit(param.reward)
  local isEffectShow = param.effectShow == nil or param.effectShow == true
  if param.state == 1 then
    self.lock_icon:SetActive(false)
    self:SetEffectState(false)
    self.blackBg:SetActive(true)
    self.lockBg:SetActive(false)
  else
    self.blackBg:SetActive(false)
    self.lockBg:SetActive(param.locked)
    if param.isFree then
      self.lock_icon:SetActive(false)
      self:SetEffectState(false)
      self.lockBg:SetActive(param.locked)
    elseif param.isPay then
      self:SetEffectState(isEffectShow)
      self.lock_icon:SetActive(param.unlock == 0)
    elseif param.isHighPay then
      self:SetEffectState(isEffectShow)
      self.lock_icon:SetActive(param.high_unlock == 0)
    end
  end
end

local function SetEffectState(self, state)
  if state then
    if self.Effect then
      self.Effect:SetActive(true)
    else
      if self.isCreate then
        return
      end
      self.isCreate = true
      self.effectObj = self:GameObjectInstantiateAsync(UIAssets.BattlePassEffect, function(request)
        if request.isError then
          return
        end
        local go = request.gameObject
        go.gameObject:SetActive(true)
        go.transform:SetParent(self.obj.transform)
        go.transform:Set_localPosition(0, 0, 0)
        go.transform:Set_localScale(0.73, 0.73, 0.73)
        go.name = NameCount
        NameCount = NameCount + 1
        local cell = self.obj:AddComponent(UIBaseContainer, go.name)
        self.Effect = cell
      end)
    end
  elseif self.Effect then
    self.Effect:SetActive(false)
  end
end

UIBattlePassNewYearItemCell.OnCreate = OnCreate
UIBattlePassNewYearItemCell.OnDestroy = OnDestroy
UIBattlePassNewYearItemCell.ComponentDefine = ComponentDefine
UIBattlePassNewYearItemCell.ComponentDestroy = ComponentDestroy
UIBattlePassNewYearItemCell.DataDefine = DataDefine
UIBattlePassNewYearItemCell.DataDestroy = DataDestroy
UIBattlePassNewYearItemCell.OnAddListener = OnAddListener
UIBattlePassNewYearItemCell.OnRemoveListener = OnRemoveListener
UIBattlePassNewYearItemCell.SetData = SetData
UIBattlePassNewYearItemCell.SetEffectState = SetEffectState
return UIBattlePassNewYearItemCell
