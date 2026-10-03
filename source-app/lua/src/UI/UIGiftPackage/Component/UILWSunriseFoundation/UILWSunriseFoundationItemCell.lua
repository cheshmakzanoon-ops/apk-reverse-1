local UILWSunriseFoundationItemCell = BaseClass("UILWSunriseFoundationItemCell", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local lock_icon_path = "lock_icon"
local commonResItem_path = "UICommonResItem"
local obj_path = ""
local blackBg_path = "BlackBg"
local btn_path = "btn"
local battle_pass_effect_path = "BattlePassEffect"
local can_get_img_path = "CanGetImg"
local lock_path = "lock"

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
  self.btn = self:AddComponent(UIButton, btn_path)
  self.btn:SetOnClick(function()
    self:OnRewardClick()
  end)
  self.battle_pass_effect = self:AddComponent(UIVfx, battle_pass_effect_path, UIAssets.BattlePassEffect, {
    lifeType = UIVfxLifeType.Stay
  })
  self.can_get_img = self:AddComponent(UIImage, can_get_img_path)
  self.lock = self:AddComponent(UIImage, lock_path)
end

local function ComponentDestroy(self)
  self.lock_icon = nil
  self.resItem = nil
  self.blackBg = nil
  self.btn = nil
  self.battle_pass_effect = nil
  self.can_get_img = nil
  self.lock = nil
end

local function DataDefine(self)
end

local function DataDestroy(self)
end

local function OnAddListener(self)
  base.OnAddListener(self)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
end

local function SetData(self, param, func)
  self.param = param
  self.func = func
  self.resItem:ReInit(param.reward)
  if param.isFree then
    if param.state == 1 then
      self.lock_icon:SetActive(false)
      self:SetEffectState(false)
      self.blackBg:SetActive(true)
      self.can_get_img:SetActive(false)
      self.lock:SetActive(false)
    else
      self.blackBg:SetActive(false)
      if param.locked then
        self.lock_icon:SetActive(false)
        self:SetEffectState(false)
        self.can_get_img:SetActive(false)
        self.lock:SetActive(true)
      else
        self.lock_icon:SetActive(false)
        self:SetEffectState(false)
        self.can_get_img:SetActive(true)
        self.lock:SetActive(false)
      end
    end
  else
    self.can_get_img:SetActive(false)
    if param.state == 1 then
      self.lock_icon:SetActive(false)
      self:SetEffectState(false)
      self.blackBg:SetActive(true)
      self.lock:SetActive(false)
    else
      self.blackBg:SetActive(false)
      if param.locked then
        self.lock_icon:SetActive(false)
        self:SetEffectState(true)
        self.lock:SetActive(true)
      else
        self.lock_icon:SetActive(false)
        self:SetEffectState(true)
        self.lock:SetActive(false)
      end
    end
  end
end

local function SetEffectState(self, state)
  if state then
    self.battle_pass_effect:SetActive(true)
    self.battle_pass_effect:Replay()
  else
    self.battle_pass_effect:SetActive(false)
  end
end

local function OnRewardClick(self)
  if self.param.state == 1 then
    self.resItem:OnBtnClick()
    return
  end
  if self.param.curLv < self.param.itemLv then
    self.resItem:OnBtnClick()
    return
  end
  if self.func then
    self.func(self.param)
  end
end

UILWSunriseFoundationItemCell.OnCreate = OnCreate
UILWSunriseFoundationItemCell.OnDestroy = OnDestroy
UILWSunriseFoundationItemCell.ComponentDefine = ComponentDefine
UILWSunriseFoundationItemCell.ComponentDestroy = ComponentDestroy
UILWSunriseFoundationItemCell.DataDefine = DataDefine
UILWSunriseFoundationItemCell.DataDestroy = DataDestroy
UILWSunriseFoundationItemCell.OnAddListener = OnAddListener
UILWSunriseFoundationItemCell.OnRemoveListener = OnRemoveListener
UILWSunriseFoundationItemCell.SetData = SetData
UILWSunriseFoundationItemCell.SetEffectState = SetEffectState
UILWSunriseFoundationItemCell.OnRewardClick = OnRewardClick
return UILWSunriseFoundationItemCell
