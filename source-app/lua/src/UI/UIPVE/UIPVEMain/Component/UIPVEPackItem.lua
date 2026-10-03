local UIPVEPackItem = BaseClass("UIPVEPackItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local this_path = ""
local icon_path = "Icon"
local prefab_path = "Prefab"
local time_bg_path = "TimeBg"
local time_path = "TimeBg/Time"
local ICON_DEFAULT = "Assets/Main/Sprites/UI/UIMain/UIMainNew/UIMain_icon_Packstore"

local function OnCreate(self)
  base.OnCreate(self)
  self:DataDefine()
  self:ComponentDefine()
end

local function OnDestroy(self)
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

local function ComponentDefine(self)
  self.btn = self:AddComponent(UIButton, this_path)
  self.btn:SetOnClick(function()
    self:OnClick()
  end)
  self.icon_image = self:AddComponent(UIImage, icon_path)
  self.prefab_go = self:AddComponent(UIBaseContainer, prefab_path)
  self.time_bg_go = self:AddComponent(UIBaseContainer, time_bg_path)
  self.time_text = self:AddComponent(UIText, time_path)
end

local function ComponentDestroy(self)
  self.btn = nil
  self.icon_image = nil
  self.prefab_go = nil
  self.time_bg_go = nil
  self.time_text = nil
end

local function DataDefine(self)
  self.packId = nil
  self.req = nil
  self.timer = nil
end

local function DataDestroy(self)
  self.packId = nil
  self.req = nil
  if self.timer then
    self.timer:Stop()
    self.timer = nil
  end
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function TimerAction(self)
  local pack = GiftPackManager.get(self.packId)
  local endTime = pack:getEndTime()
  local curTime = UITimeManager:GetInstance():GetServerTime()
  local restTime = endTime - curTime
  if 0 <= restTime then
    self.time_text:SetText(UITimeManager:GetInstance():MilliSecondToFmtString(restTime))
  else
    if self.timer then
      self.timer:Stop()
      self.timer = nil
    end
    self.view:Refresh()
  end
end

local function SetData(self, data)
  self.packId = data.packId
  local tagInfo = data.tagInfo
  local pack = GiftPackManager.get(data.packId)
  local icon = ICON_DEFAULT
  local prefabName = ""
  if not string.IsNullOrEmpty(pack:getPopupImageH()) then
    icon = "Assets/Main/Sprites/UI/UIMain/UIMainNew/UIMain_icon_" .. pack:getPopupImageH()
    prefabName = pack:getPopupImageH()
  elseif not string.IsNullOrEmpty(tagInfo:getIconName()) then
    icon = "Assets/Main/Sprites/UI/UIMain/UIMainNew/" .. tagInfo:getIconName()
    prefabName = tagInfo:getIconName()
  end
  local prefabPath = UIMainIconPrefab[prefabName]
  if prefabPath then
    self.icon_image:SetActive(false)
    if self.oldName ~= prefabName then
      if self.req then
        self.req:Destroy()
      end
      self.req = self:GameObjectInstantiateAsync(prefabPath, function(req)
        if req.isError then
          return
        end
        req.gameObject:SetActive(true)
        local tf = req.gameObject.transform
        tf:SetParent(self.prefab_go.transform)
        tf:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
        tf:Set_localPosition(ResetPosition.x, ResetPosition.y, ResetPosition.z)
        local heroImageTf = tf:Find("HeroBg/Hero")
        if heroImageTf then
          local heroImage = heroImageTf:GetComponent(typeof(CS.UnityEngine.UI.Image))
          heroImage:LoadSprite(icon)
        end
      end)
      self.oldName = prefabName
    end
  else
    self.icon_image:SetActive(true)
    if self.oldName ~= icon then
      if self.req then
        self.req:Destroy()
      end
      self.icon_image:LoadSprite(icon)
      self.oldName = icon
    end
  end
  if self.timer then
    self.timer:Stop()
    self.timer = nil
  end
  if pack:getTimeType() ~= PackTimeType.AlwaysHideTime then
    self.time_bg_go:SetActive(true)
    self.timer = TimerManager:GetInstance():GetTimer(0.5, self.TimerAction, self, false, false, false)
    self.timer:Start()
  else
    self.time_bg_go:SetActive(false)
  end
end

local function OnClick(self)
  local pack = GiftPackManager.get(self.packId)
  if pack:isPvePack() then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIScrollPack, {anim = true}, pack)
  elseif pack:isEnergyBankPack() then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIEnergyBank)
  end
end

UIPVEPackItem.OnCreate = OnCreate
UIPVEPackItem.OnDestroy = OnDestroy
UIPVEPackItem.ComponentDefine = ComponentDefine
UIPVEPackItem.ComponentDestroy = ComponentDestroy
UIPVEPackItem.DataDefine = DataDefine
UIPVEPackItem.DataDestroy = DataDestroy
UIPVEPackItem.OnEnable = OnEnable
UIPVEPackItem.OnDisable = OnDisable
UIPVEPackItem.TimerAction = TimerAction
UIPVEPackItem.SetData = SetData
UIPVEPackItem.OnClick = OnClick
return UIPVEPackItem
