local base = UIBaseContainer
local WorldSuppliesRewardItem = BaseClass("WorldSuppliesRewardItem", base)
local image_path = "rewadIcon"
local rewardInfo_path = "rewadIcon"
local btnMask_path = "playerRoot/Mask"
local playerHead_path = "playerRoot/UIPlayerHead"

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
end

local function ComponentDestroy(self)
  self.image = nil
  self.rewardInfo = nil
  self.btnMask = nil
  self.playerHead = nil
end

local function DataDefine(self)
end

local function DataDestroy(self)
end

function WorldSuppliesRewardItem:SetData(data, isLuck, player, index, redFlag)
  self.rewardData = data
  self.playerData = player
  self.isLuck = isLuck
  self.index = index
  local normal = "Assets/Main/Sprites/UI/UISeason/UISeason2/FX_S2saiji_baoxiang02_icon.png"
  local specia = "Assets/Main/Sprites/UI/UISeason/UISeason2/FX_S2saiji_baoxiang03_icon.png"
  if self.isLuck then
    self.image:LoadSprite(specia)
  else
    self.image:LoadSprite(normal)
  end
  if player then
    self.playerIcon:SetHeadAndFrame(player.uid, player.pic, player.picver or player.picVer, false, player.headSkinId, player.headSkinET)
    self.playerIcon:SetActive(true)
    self.playerIcon:SetEnableClickShowInfo(true, true)
    self.image:SetActive(true)
    self.btnMask:SetActive(true)
  else
    self.btnMask:SetActive(false)
    self.playerIcon:SetActive(false)
    self.image:SetActive(true)
  end
end

function WorldSuppliesRewardItem:OnClick()
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

WorldSuppliesRewardItem.OnCreate = OnCreate
WorldSuppliesRewardItem.OnDestroy = OnDestroy
WorldSuppliesRewardItem.OnEnable = OnEnable
WorldSuppliesRewardItem.OnDisable = OnDisable
WorldSuppliesRewardItem.ComponentDefine = ComponentDefine
WorldSuppliesRewardItem.ComponentDestroy = ComponentDestroy
WorldSuppliesRewardItem.DataDefine = DataDefine
WorldSuppliesRewardItem.DataDestroy = DataDestroy
return WorldSuppliesRewardItem
