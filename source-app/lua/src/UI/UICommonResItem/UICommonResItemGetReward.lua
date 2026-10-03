local base = UICommonResItem
local UICommonResItemGetReward = BaseClass("UICommonResItemGetReward", base)
local effectGet_path = "effectGet"
local hasGet_Path = "hasGet"

local function ComponentDefine(self)
  base.ComponentDefine(self)
  self.effectBtn = self:AddComponent(UIButton, effectGet_path)
  self.effectGet = self:AddComponent(UIVfx, effectGet_path, EffectAssets.ItemCanGetEffect)
  self.hasGet = self:AddComponent(UIImage, hasGet_Path)
  self.effectBtn:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    if self.clickCallback then
      self.clickCallback(self.callbackOwner, self)
    end
  end)
end

local function ComponentDestroy(self)
  self.effectGet:Stop()
  self.effectGet = nil
  self.hasGet = nil
  self.effectBtn = nil
  base.ComponentDestroy(self)
end

function UICommonResItemGetReward:ReInit(param, clickCallback, callbackOwner, state)
  base.ReInit(self, param)
  self.clickCallback = clickCallback
  self.callbackOwner = callbackOwner
  self:SetState(state)
end

function UICommonResItemGetReward:SetState(state)
  self.state = state or 0
  if state == 1 then
    self.effectGet:SetActive(true)
    self.effectGet:PlayByStay(EffectAssets.ItemCanGetEffect)
    self.hasGet:SetActive(false)
  elseif state == 2 then
    self.effectGet:Stop()
    self.effectGet:SetActive(false)
    self.hasGet:SetActive(true)
  else
    self.effectGet:Stop()
    self.effectGet:SetActive(false)
    self.hasGet:SetActive(false)
  end
end

UICommonResItemGetReward.ComponentDefine = ComponentDefine
UICommonResItemGetReward.ComponentDestroy = ComponentDestroy
return UICommonResItemGetReward
