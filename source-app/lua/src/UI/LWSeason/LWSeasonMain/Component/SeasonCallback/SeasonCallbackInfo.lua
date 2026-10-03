local base = UIBaseContainer
local SeasonCallbackInfo = BaseClass("SeasonCallbackInfo", base)
local Localization = CS.GameEntry.Localization
local IconImg_path = "IconImg"
local TitleText_path = "TitleText"
local InfoBtn_path = "IconImg"

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

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function ComponentDefine(self)
  self.IconImg = self:AddComponent(UIImage, IconImg_path)
  self.TitleText = self:AddComponent(UIText, TitleText_path)
  self.InfoBtn = self:AddComponent(UIButton, InfoBtn_path)
  self.ShowFx = self.transform:Find("IconImg/VFX_ui_level")
  self.ShowAnim = self:AddComponent(UIAnimator, "")
  self.InfoBtn:SetOnClick(function()
    self:ShowInfo()
  end)
end

local function ComponentDestroy(self)
  self.IconImg = nil
  self.TitleText = nil
  self.InfoBtn = nil
end

local function DataDefine(self)
end

local function DataDestroy(self)
  self.index = nil
  self.info = nil
end

local function SetItem(self, info)
  self.data = info
  if self.isSimple then
    self.TitleText:SetActive(false)
    self.ShowFx.gameObject:SetActive(false)
  else
    self.TitleText:SetLocalText(info.icon_name)
    self.TitleText:SetActive(true)
    self.ShowFx.gameObject:SetActive(true)
  end
  self.IconImg:LoadSpriteAsyncWithCallback(info.icon, function(texture)
    if self.IconImg ~= nil then
      self.IconImg:SetNativeSize()
    end
  end)
end

local function TrySetItemById(self, callbackType, callbackId, isSimple, openType, activityOpen, includePrepare)
  local data = DataCenter.SeasonCallbackManager:GetConfigDataByCallbackId(callbackType, callbackId, true, includePrepare)
  if not data then
    self:SetActive(false)
    return
  end
  self.isSimple = isSimple
  self.openType = openType
  self.activityOpen = activityOpen
  self:SetItem(data)
  self:SetActive(true)
  return true
end

local function TrySetItemByData(self, data, isSimple, openType, activityOpen)
  if not data then
    self:SetActive(false)
    return
  end
  self.isSimple = isSimple
  self.openType = openType
  self.activityOpen = activityOpen
  self:SetItem(data)
  self:SetActive(true)
  return true
end

local function ShowInfo(self)
  if self.openType and self.openType == UISeasonCallBackInfoOpenType.DecorationPreview and (SeasonUtil.IsInSeasonPrepareMode(true) or not self.activityOpen) then
    local desc = self.isSimple and self.data.desc_2 or self.data.desc
    local season = SeasonUtil.GetSeason() + 1
    local content = Localization:GetString("skin_preview_desc1", season)
    UIUtil.ShowBubbleTips(content, self.IconImg.transform.position, 0, -30, 0, nil, Localization:GetString(desc), {
      contentAlignment = CS.UnityEngine.TextAnchor.MiddleCenter
    })
  else
    local desc = self.isSimple and self.data.desc_2 or self.data.desc
    UIUtil.ShowBubbleTips(nil, self.IconImg.transform.position, 0, -30, 0, nil, Localization:GetString(desc), nil, self.data.endTime)
  end
end

SeasonCallbackInfo.OnCreate = OnCreate
SeasonCallbackInfo.OnDestroy = OnDestroy
SeasonCallbackInfo.OnEnable = OnEnable
SeasonCallbackInfo.OnDisable = OnDisable
SeasonCallbackInfo.ComponentDefine = ComponentDefine
SeasonCallbackInfo.ComponentDestroy = ComponentDestroy
SeasonCallbackInfo.DataDefine = DataDefine
SeasonCallbackInfo.DataDestroy = DataDestroy
SeasonCallbackInfo.SetItem = SetItem
SeasonCallbackInfo.ShowInfo = ShowInfo
SeasonCallbackInfo.TrySetItemById = TrySetItemById
SeasonCallbackInfo.TrySetItemByData = TrySetItemByData
return SeasonCallbackInfo
