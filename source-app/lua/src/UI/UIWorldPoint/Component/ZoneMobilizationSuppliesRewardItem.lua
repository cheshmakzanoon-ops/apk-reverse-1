local base = UIBaseContainer
local ZoneMobilizationSuppliesRewardItem = BaseClass("ZoneMobilizationSuppliesRewardItem", base)
local image_path = "rewadIcon"
local rewardInfo_path = "rewadIcon"
local btnMask_path = "playerRoot/Mask"
local playerHead_path = "playerRoot/UIPlayerHead"
local effect_root_path = "EffectRoot"
local DISSOLVE_EFFECT_PATH = "Assets/_Art_LastWar/Effect/Prefab/VX/Zone/Eff_ui_zone_box_dissolve.prefab"

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

local function OnDestroy(self)
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
  self.image = self:AddComponent(UIImage, image_path)
  self.rewardInfo = self:AddComponent(UIButton, rewardInfo_path)
  self.btnMask = self:AddComponent(UIBaseContainer, btnMask_path)
  self.playerHead = self:AddComponent(UIBaseContainer, playerHead_path)
  self.playerIcon = self:AddComponent(UICommonHead, playerHead_path)
  self.rewardInfo:SetOnClick(function()
    self:OnClick()
  end)
  self.effect_root = self:AddComponent(UIBaseContainer, effect_root_path)
end

local function ComponentDestroy(self)
  self.image = nil
  self.rewardInfo = nil
  self.btnMask = nil
  self.playerHead = nil
  self.effect_root = nil
end

local function DataDefine(self)
  self.redIcon = nil
end

local function DataDestroy(self)
  self.redIcon = nil
  self:RemoveEffect()
end

function ZoneMobilizationSuppliesRewardItem:SetData(data, isLuck, player, index, redFlag)
  if data then
    local item = data[#data]
    if item.rewardType == 40 then
      table.insert(data, 1, item)
      data[#data] = nil
    end
  end
  self.rewardData = data
  self.playerData = player
  self.isLuck = isLuck
  self.index = index
  if player and redFlag then
    self.image:LoadSprite(self.redIcon)
  else
    local normal = "Assets/Main/Sprites/UI/UISeason/UISeason2/FX_S2saiji_baoxiang02_icon.png"
    local specia = "Assets/Main/Sprites/UI/UISeason/UISeason2/FX_S2saiji_baoxiang03_icon.png"
    if self.isLuck then
      self.image:LoadSprite(specia)
    else
      self.image:LoadSprite(normal)
    end
  end
  if player then
    self.playerIcon:SetHeadAndFrame(player.uid, player.pic, player.picver or player.picVer, false, player.headSkinId, player.headSkinET)
    self.playerIcon:SetActive(true)
    self.playerIcon:SetEnableClickShowInfo(true, true)
    self.btnMask:SetActive(true)
    if redFlag then
      self:PlayEffect(DISSOLVE_EFFECT_PATH, 2)
    end
  else
    self.btnMask:SetActive(false)
    self.playerIcon:SetActive(false)
  end
end

local function OnClick(self)
  if self.rewardData then
    local parame = self.rewardData
    local mod = self.index % 4
    local isLeft = mod == 1 or mod == 2
    local x = self.image.transform.position.x
    local y = self.image.transform.position.y
    local btnAnchor = isLeft and CommonBoxShowRewardTipAnchor.Left or CommonBoxShowRewardTipAnchor.Right
    UIManager:GetInstance():OpenWindow(UIWindowNames.UILWCommonBoxShowRewardTip, "", x, y, btnAnchor, 0, 0, parame)
  end
end

local function GetRedIconPath(self)
  local str = LuaEntry.DataConfig:TryGetStr("zone_mobilization_donate", "k11")
  self.redIcon = str
  return self.redIcon
end

local function PlayEffect(self, path, duration, callback, finishCb)
  if path then
    if self.effectData and self.effectData.request then
      self:RemoveEffect()
    end
    local req = CS.GameEntry.Resource:InstantiateAsync(path)
    local data = {}
    data.request = req
    req:completed("+", function(request)
      if request.isError then
        request:Destroy()
        return
      end
      local go = request.gameObject
      local tf = go.transform
      tf.localScale = VecZero
      tf.parent = self.effect_root.transform
      tf:Set_localPosition(ResetPosition.x, ResetPosition.y, ResetPosition.z)
      tf:Set_localRotation(0, 0, 0, 1)
      go:SetActive(true)
      if callback then
        callback()
      end
      tf.localScale = ResetScale
      if duration and 0 < duration then
        local timer = TimerManager:GetInstance():DelayInvoke(function()
          if finishCb then
            finishCb()
          end
          self:RemoveEffect()
        end, duration)
        data.delayTimer = timer
      end
      data.effectObj = request.gameObject
    end)
    self.effectData = data
    return req
  end
end

local function RemoveEffect(self)
  if self.effectData ~= nil then
    if self.effectData.delayTimer then
      self.effectData.delayTimer:Stop()
      self.effectData.delayTimer = nil
    end
    if self.effectData.request then
      self.effectData.request:Destroy()
      self.effectData.request = nil
    end
    self.effectData.effectObj = nil
    self.effectData = nil
  end
end

ZoneMobilizationSuppliesRewardItem.OnCreate = OnCreate
ZoneMobilizationSuppliesRewardItem.OnDestroy = OnDestroy
ZoneMobilizationSuppliesRewardItem.OnEnable = OnEnable
ZoneMobilizationSuppliesRewardItem.OnDisable = OnDisable
ZoneMobilizationSuppliesRewardItem.ComponentDefine = ComponentDefine
ZoneMobilizationSuppliesRewardItem.ComponentDestroy = ComponentDestroy
ZoneMobilizationSuppliesRewardItem.DataDefine = DataDefine
ZoneMobilizationSuppliesRewardItem.DataDestroy = DataDestroy
ZoneMobilizationSuppliesRewardItem.getters.redIcon = GetRedIconPath
ZoneMobilizationSuppliesRewardItem.PlayEffect = PlayEffect
ZoneMobilizationSuppliesRewardItem.RemoveEffect = RemoveEffect
ZoneMobilizationSuppliesRewardItem.OnClick = OnClick
return ZoneMobilizationSuppliesRewardItem
