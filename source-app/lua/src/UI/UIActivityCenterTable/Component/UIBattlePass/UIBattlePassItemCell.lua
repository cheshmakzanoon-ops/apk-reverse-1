local UIBattlePassItemCell = BaseClass("UIBattlePassItemCell", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local day_text_path = "day_text"
local lock_icon_path = "lock_icon"
local reward_get_icon_path = "reward_get_icon"
local commonResItem_path = "UICommonResItem"
local reward_effect_path = "reward_effect"
local btn_path = "btn"
local cover_path = "cover"
local obj_path = ""
local blackBg_path = "BlackBg"
local hero_debris_path = "HeroDebris"
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
end

local function ComponentDestroy(self)
  self.lock_icon = nil
  self.reward = nil
  self.reward_effect = nil
  self.resItem = nil
  self.blackBg = nil
end

local function DataDefine(self)
  self.day = 1
end

local function DataDestroy(self)
  self.day = nil
  if self.effectObj ~= nil then
    self:GameObjectDestroy(self.effectObj)
  end
  self.effectObj = nil
end

local function OnAddListener(self)
  base.OnAddListener(self)
  self:AddUIListener(EventId.RefreshHeroMonthCardSingle, self.DoWhenDayDataChange)
end

local function OnRemoveListener(self)
  self:RemoveUIListener(EventId.RefreshHeroMonthCardSingle, self.DoWhenDayDataChange)
  base.OnRemoveListener(self)
end

local function SetItem(self, day)
  self.day = day
  self:RefreshUI()
end

local function SetData(self, param)
  self.param = param
  self.resItem:ReInit(param.reward)
  self.isGetReward = false
  if param.isTop then
    if param.state == 1 then
      self.lock_icon:SetActive(false)
      self:SetEffectState(false)
      self.blackBg:SetActive(true)
    else
      self.blackBg:SetActive(false)
      if param.locked then
        self.lock_icon:SetActive(false)
        self:SetEffectState(false)
      else
        self.lock_icon:SetActive(false)
        self.isGetReward = true
        self:SetEffectState(false)
      end
    end
  elseif param.state == 1 then
    self.lock_icon:SetActive(false)
    self:SetEffectState(false)
    self.blackBg:SetActive(true)
  else
    self.blackBg:SetActive(false)
    if param.unlock == 1 then
      if param.locked then
        self.lock_icon:SetActive(false)
        self:SetEffectState(true)
      else
        self.lock_icon:SetActive(false)
        self.isGetReward = true
        self:SetEffectState(true)
      end
    elseif param.locked then
      self.lock_icon:SetActive(true)
      self:SetEffectState(true)
    else
      self.lock_icon:SetActive(true)
      self:SetEffectState(true)
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

local function SetFlagText(self, value)
  self.flag_text:SetText(value)
end

local function SetBuyData(self, param)
  self.isGetReward = false
  self.param = {}
  self.param.reward = param
  self.resItem:ReInit(param.reward)
  self.lock_icon:SetActive(false)
end

local function OnRewardClick(self)
  if self.isGetReward then
    local type = 0
    if self.param.isTop then
      type = 0
    else
      type = 1
    end
    self.isGetReward = false
    SFSNetwork.SendMessage(MsgDefines.ReceiveBattlePassStageReward, self.param.actId, self.param.lv, type)
    return
  end
  if self.param.state == 0 then
    if self.param.isTop then
      UIUtil.ShowTips(Localization:GetString("320443", self.param.lv))
    elseif self.param.unlock == 0 then
      local activityData = DataCenter.ActivityListDataManager:GetActivityDataById(tonumber(self.param.actId))
      if activityData and activityData.subViewType == BattlePassType.Christmas then
        UIManager:GetInstance():OpenWindow(UIWindowNames.UIBattlePassGiftPackagePopUpChristmas, tonumber(self.param.actId))
      else
        UIManager:GetInstance():OpenWindow(UIWindowNames.UIBattlePassGiftPackagePopUp, self.param.actId)
      end
      return
    else
      UIUtil.ShowTips(Localization:GetString("320443", self.param.lv))
    end
  end
end

local function DoWhenDayDataChange(self, day)
  self:RefreshUI()
end

UIBattlePassItemCell.OnCreate = OnCreate
UIBattlePassItemCell.OnDestroy = OnDestroy
UIBattlePassItemCell.ComponentDefine = ComponentDefine
UIBattlePassItemCell.ComponentDestroy = ComponentDestroy
UIBattlePassItemCell.DataDefine = DataDefine
UIBattlePassItemCell.DataDestroy = DataDestroy
UIBattlePassItemCell.OnAddListener = OnAddListener
UIBattlePassItemCell.OnRemoveListener = OnRemoveListener
UIBattlePassItemCell.DoWhenDayDataChange = DoWhenDayDataChange
UIBattlePassItemCell.SetItem = SetItem
UIBattlePassItemCell.SetData = SetData
UIBattlePassItemCell.SetEffectState = SetEffectState
UIBattlePassItemCell.SetBuyData = SetBuyData
UIBattlePassItemCell.OnRewardClick = OnRewardClick
UIBattlePassItemCell.SetFlagText = SetFlagText
return UIBattlePassItemCell
