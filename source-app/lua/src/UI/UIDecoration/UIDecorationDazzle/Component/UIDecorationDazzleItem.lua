local base = UIBaseContainer
local UIDecorationDazzleItem = BaseClass("UIDecorationDazzleItem", base)
local UIGray = CS.UIGray
local UIDecorationMainCity = require("UI.UIDecoration.UIDecorationMain.Component.UIDecorationMainCity")
local BuildingIcon_path = "BuildingIcon"
local ItemNameText_path = "ItemNameText"
local ItemUseText_path = "ItemUseText"
local BtnUse_path = "BtnUse"
local BtnName_path = "BtnUse/BtnName"
local RemainTimeText_path = "RemainTimeText"

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
  self.BuildingIcon = self:AddComponent(UIRawImage, BuildingIcon_path)
  self.ItemNameText = self:AddComponent(UIText, ItemNameText_path)
  self.ItemUseText = self:AddComponent(UIText, ItemUseText_path)
  self.BtnUse = self:AddComponent(UIButton, BtnUse_path)
  self.BtnName = self:AddComponent(UIText, BtnName_path)
  self.RemainTimeText = self:AddComponent(UIText, RemainTimeText_path)
  self.BuildingIcon:SetColorRGBA(1, 1, 1, 0)
  self.main_city = self:AddComponent(UIDecorationMainCity, BuildingIcon_path)
  self.BtnUse:SetOnClick(function()
    self:OnBtnUseClick()
  end)
end

local function ComponentDestroy(self)
  self.BuildingIcon = nil
  self.ItemNameText = nil
  self.ItemUseText = nil
  self.BtnUse = nil
  self.BtnName = nil
  self.RemainTimeText = nil
end

local function DataDefine(self)
  self.camera = nil
  self.rtLen = 256
end

local function DataDestroy(self)
end

function UIDecorationDazzleItem:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.UserSkinUpdate, self.RefreshShow)
end

function UIDecorationDazzleItem:OnRemoveListener()
  base.OnRemoveListener(self)
  self:RemoveUIListener(EventId.UserSkinUpdate, self.RefreshShow)
end

function UIDecorationDazzleItem:Update1000MS()
  if self.EndTime then
    UIUtil.SetLeftTimeText(self.RemainTimeText, nil, self.EndTime)
  end
end

function UIDecorationDazzleItem:InitData(index, decorationId, wearData, config, isUpdate)
  self.decorationId = decorationId
  self.wearData = wearData
  self.config = config
  self.ItemNameText:SetLocalText(config.name)
  if self.config.type == 1 then
    self:InitCollaborationData(isUpdate, index)
  elseif self.config.type == 2 then
    self:InitItemData(isUpdate, index)
  end
end

function UIDecorationDazzleItem:InitCollaborationData(isUpdate, index)
  local isWear = self.wearData and self.wearData:IsWear()
  local isUsing = self.wearData and self.wearData:IsWearDazzleSkin(self.config.id)
  if isUsing then
    self.ItemUseText:SetActive(true)
    self.BtnUse:SetActive(false)
  else
    self.ItemUseText:SetActive(false)
    if isWear then
      if self.config:HasOpen() then
        self.BtnName:SetLocalText("decoration_colorful_skin_UI_4")
        UIGray.SetGray(self.BtnUse.transform, false, true)
        self.BtnUse:SetInteractable(true)
      else
        self.BtnName:SetLocalText("decoration_colorful_skin_UI_5")
        UIGray.SetGray(self.BtnUse.transform, true, true)
        self.BtnUse:SetInteractable(false)
      end
      self.BtnUse:SetActive(true)
    elseif self.config:HasOpen() then
      self.BtnName:SetLocalText("decoration_colorful_skin_UI_4")
      self.BtnUse:SetActive(true)
      UIGray.SetGray(self.BtnUse.transform, false, true)
      self.BtnUse:SetInteractable(true)
    else
      self.BtnUse:SetActive(false)
    end
  end
  local now = UITimeManager:GetInstance():GetServerTime()
  local startTime, endTime = self.config:GetShowTime()
  if endTime and now >= startTime and now < endTime then
    self.EndTime = endTime
    self.RemainTimeText:SetActive(true)
    self:Update1000MS()
  else
    self.EndTime = nil
    self.RemainTimeText:SetActive(false)
  end
  if isUpdate then
    if not self.isUsing and isUsing then
      self:PlayUseAnim()
    end
  else
    self.main_city:SetRTLen(256)
    self.main_city:SetFov(self.config.fov or 20)
    self.main_city:ReInit({
      decorationId = self.decorationId,
      posIndex = index,
      colourId = self.config.id,
      cameraY = self.config.cameraY or 16.6
    })
  end
  self.isUsing = isUsing
end

function UIDecorationDazzleItem:InitItemData(isUpdate, index)
  local isUsing = self.wearData and self.wearData:IsWearDazzleSkin(self.config.id)
  if isUsing then
    self.ItemUseText:SetActive(true)
    self.BtnUse:SetActive(false)
  else
    self.BtnUse:SetActive(true)
    self.ItemUseText:SetActive(false)
    if self.config:HasOpen() then
      self.BtnName:SetLocalText("decoration_colorful_skin_UI_4")
      UIGray.SetGray(self.BtnUse.transform, false, true)
    else
      self.BtnName:SetLocalText(100547)
    end
  end
  local now = UITimeManager:GetInstance():GetServerTime()
  local _, expireTime = self.config:GetShowTime()
  if expireTime and 0 < expireTime and now < expireTime then
    self.EndTime = expireTime
    self.RemainTimeText:SetActive(true)
    self:Update1000MS()
  else
    self.EndTime = nil
    self.RemainTimeText:SetActive(false)
  end
  if isUpdate then
    if not self.isUsing and isUsing then
      self:PlayUseAnim()
    end
  else
    self.main_city:SetRTLen(256)
    self.main_city:SetFov(self.config.fov or 20)
    self.main_city:ReInit({
      decorationId = self.decorationId,
      posIndex = index,
      colourId = self.config.id,
      cameraY = self.config.cameraY or 16.6
    })
  end
  self.isUsing = isUsing
end

function UIDecorationDazzleItem:InitOrigin(index, decorationId, wearData, isUpdate)
  self.decorationId = decorationId
  self.wearData = wearData
  self.config = nil
  self.ItemNameText:SetLocalText("decoration_colorful_skin_name_0")
  local isWear = wearData and wearData:IsWear()
  local isUsing = not wearData or not wearData:IsWearDazzleSkin()
  if isUsing then
    self.ItemUseText:SetActive(true)
    self.BtnUse:SetActive(false)
  else
    self.ItemUseText:SetActive(false)
    if isWear then
      self.BtnName:SetLocalText("decoration_colorful_skin_UI_4")
      UIGray.SetGray(self.BtnUse.transform, false, true)
      self.BtnUse:SetInteractable(true)
      self.BtnUse:SetActive(true)
    else
      self.BtnUse:SetActive(false)
    end
  end
  self.EndTime = nil
  self.RemainTimeText:SetActive(false)
  if isUpdate then
    if not self.isUsing and isUsing then
      self:PlayUseAnim()
    end
  else
    local config = DataCenter.DecorationDazzleManager:GetDazzleSkinTemplateFirst(decorationId)
    local fov = config and config.fov or 20
    local cameraY = config and config.cameraY or 16.6
    self.main_city:SetRTLen(256)
    self.main_city:SetFov(fov)
    self.main_city:ReInit({
      decorationId = decorationId,
      posIndex = index,
      colourId = 0,
      cameraY = cameraY
    })
  end
  self.isUsing = isUsing
end

function UIDecorationDazzleItem:RefreshShow()
  if self.config then
    self:InitData(self.index, self.decorationId, self.wearData, self.config, true)
  else
    self:InitOrigin(self.index, self.decorationId, self.wearData, true)
  end
end

function UIDecorationDazzleItem:OnBtnUseClick()
  if not self.wearData then
    UIUtil.ShowTipsId("decoration_colorful_skin_tips1")
    return
  end
  if not self.config then
    if self.wearData:IsWearDazzleSkin() then
      SFSNetwork.SendMessage(MsgDefines.TakeOffSkinColour, self.wearData.skinId)
    end
    return
  end
  if self.config:HasOpen() and not self.wearData:IsWear() then
    UIUtil.ShowTipsId("decoration_colorful_skin_tips1")
    return
  end
  if not self.wearData:IsInExpireTime() then
    UIUtil.ShowTipsId("decoration_colorful_skin_tips2")
    return
  end
  if self.wearData:IsWearDazzleSkin(self.config.id) then
    UIUtil.ShowTipsId("decoration_colorful_skin_tips3")
    return
  end
  if self.config.type == 1 then
    self:ClickCollaboration()
  else
    self:ClickItem()
  end
end

function UIDecorationDazzleItem:ClickCollaboration()
  if not self.config:HasOpen() then
    UIUtil.ShowTipsId("decoration_colorful_skin_tips4")
    return
  end
  SFSNetwork.SendMessage(MsgDefines.ChangeSkinColour, self.config.decoration_id, self.config.id)
end

function UIDecorationDazzleItem:ClickItem()
  if not self.config:HasOpen() then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIDecorateUnlock, self.config.id, 2)
    self.view.ctrl:CloseSelf()
  else
    SFSNetwork.SendMessage(MsgDefines.ChangeSkinColour, self.config.decoration_id, self.config.id)
  end
end

function UIDecorationDazzleItem:PlayUseAnim()
  if not self.effectUse then
    self.effectUse = self:AddComponent(UIVfx, "effectUse", VfxAssets.DecorationDazzleChange)
  end
  self.effectUse:Replay()
end

UIDecorationDazzleItem.OnCreate = OnCreate
UIDecorationDazzleItem.OnDestroy = OnDestroy
UIDecorationDazzleItem.OnEnable = OnEnable
UIDecorationDazzleItem.OnDisable = OnDisable
UIDecorationDazzleItem.ComponentDefine = ComponentDefine
UIDecorationDazzleItem.ComponentDestroy = ComponentDestroy
UIDecorationDazzleItem.DataDefine = DataDefine
UIDecorationDazzleItem.DataDestroy = DataDestroy
return UIDecorationDazzleItem
