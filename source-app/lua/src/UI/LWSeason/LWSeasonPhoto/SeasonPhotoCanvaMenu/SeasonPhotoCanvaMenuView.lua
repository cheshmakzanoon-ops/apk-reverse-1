local base = UIBaseView
local SeasonPhotoCanvaMenu = BaseClass("SeasonPhotoCanvaMenu", base)
local SeasonPhotoCanva = require("UI.LWSeason.LWSeasonPhoto.Component.SeasonPhotoCanva")
local btnBack_path = "safeArea/BottomBar/BtnBack"
local txtTitle_path = "safeArea/TopBar/TextTitle"
local bg_path = "ImgBg"
local PhotoCanva_path = "safeArea/SeasonPhotoCanva"
local BtnAuto_path = "safeArea/BottomBar/Menu/Button/BtnAuto"
local BtnSave_path = "safeArea/BottomBar/Menu/Button/BtnSave"
local MenuFrame_path = "safeArea/BottomBar/Menu/MenuFrame"
local ToggleFrame_path = "safeArea/BottomBar/Menu/MenuFrame/ToggleFrame"
local MenuSize_path = "safeArea/BottomBar/Menu/MenuSize"
local ToggleSize_path = "safeArea/BottomBar/Menu/MenuSize/ToggleSize"

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self.season, self.allianceId, self.picData = self:GetUserData()
  self:RefreshView()
  DataCenter.SeasonPhotoManager:ChangeSkin(self, self.season)
  DataCenter.SeasonPhotoTemplateManager:LoadDeco(self, self.bg, bg_path, self.season, "decoPath", function(go, rect)
    rect:SetSizeDeltaXY(0, 0)
  end)
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
  EventManager:GetInstance():Broadcast(EventId.SeasonPhotoMenuClose)
end

local function ComponentDefine(self)
  self.btnBack = self:AddComponent(UIButton, btnBack_path)
  self.txtTitle = self:AddComponent(UIText, txtTitle_path)
  self.bg = self:AddComponent(UIBaseContainer, bg_path)
  self.PhotoCanva = self:AddComponent(UIBaseContainer, PhotoCanva_path)
  self.BtnAuto = self:AddComponent(UIButton, BtnAuto_path)
  self.BtnSave = self:AddComponent(UIButton, BtnSave_path)
  self.MenuFrame = self:AddComponent(UIBaseContainer, MenuFrame_path)
  self.ToggleFrame = self:AddComponent(UIBaseContainer, ToggleFrame_path)
  self.MenuSize = self:AddComponent(UIBaseContainer, MenuSize_path)
  self.ToggleSize = self:AddComponent(UIBaseContainer, ToggleSize_path)
  self.btnBack:SetOnClick(BindCallback(self.ctrl, self.ctrl.CloseSelf))
  self.PhotoCanva = self:AddComponent(SeasonPhotoCanva, PhotoCanva_path)
  self.BtnAuto:SetActive(false)
  self.BtnSave:SetOnClick(BindCallback(self.PhotoCanva, self.PhotoCanva.UploadPhoto))
  self.SizeObj = self.ToggleSize.gameObject
  self.SizeObj:GameObjectCreatePool()
  self.SizeObj:SetActive(false)
  self.FrameObj = self.ToggleFrame.gameObject
  self.FrameObj:GameObjectCreatePool()
  self.FrameObj:SetActive(false)
end

local function ComponentDestroy(self)
  self.MenuSize:RemoveComponents(UIToggle)
  self.SizeObj:GameObjectRecycleAll()
  self.MenuFrame:RemoveComponents(UIToggle)
  self.FrameObj:GameObjectRecycleAll()
  self.btnBack = nil
  self.txtTitle = nil
  self.bg = nil
  self.PhotoCanva = nil
  self.BtnAuto = nil
  self.BtnSave = nil
  self.MenuFrame = nil
  self.ToggleFrame = nil
  self.MenuSize = nil
  self.ToggleSize = nil
end

local function DataDefine(self)
  self.toggleSizeList = {}
  self.toggleFrameList = {}
end

local function DataDestroy(self)
end

function SeasonPhotoCanvaMenu:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.SeasonPhotoRefresh, self.SeasonPhotoRefresh)
end

function SeasonPhotoCanvaMenu:OnRemoveListener()
  self:RemoveUIListener(EventId.SeasonPhotoRefresh, self.SeasonPhotoRefresh)
  base.OnRemoveListener(self)
end

function SeasonPhotoCanvaMenu:RefreshView()
  self.PhotoCanva:SetPhotoInfo(self.season, self.allianceId, false, true, nil, self.picData)
  self.txtTitle:SetLocalText("season_alliance_photo_UI_2")
  self:SeasonPhotoRefresh(self.PhotoCanva, true)
end

function SeasonPhotoCanvaMenu:SeasonPhotoRefresh(target, isInit)
  if target ~= self.PhotoCanva then
    return
  end
  local data, _, picData = self.PhotoCanva:GetData()
  self:InitMenu(data)
  if picData then
    local toggle = self.toggleSizeList[picData.sizeConfigId]
    if toggle then
      if isInit then
        toggle:SetIsOn(true)
      else
        toggle:SetIsOnWithoutNotify(true)
      end
    end
    toggle = self.toggleFrameList[picData.borderConfigId]
    if toggle then
      if isInit then
        toggle:SetIsOn(true)
      else
        toggle:SetIsOnWithoutNotify(true)
      end
    end
  end
  CS.UIGray.SetGray(self.BtnSave.transform, not self.PhotoCanva:IsPhotoDirty(), true)
end

function SeasonPhotoCanvaMenu:InitMenu(data)
  if not data or self.hasInit then
    return
  end
  local photoConfig = DataCenter.SeasonPhotoTemplateManager:GetConfigData(data.photoConfigId)
  if not photoConfig then
    return
  end
  self.hasInit = true
  local config, toggle, text, lock, frame
  if photoConfig.season_alliance_photo_size then
    for i, v in ipairs(photoConfig.season_alliance_photo_size) do
      local goItem = self.SizeObj:GameObjectSpawn(self.MenuSize.transform)
      goItem:SetActive(true)
      goItem.name = string.format("Size_%d", i)
      toggle = self.MenuSize:AddComponent(UIToggle, goItem.name)
      self.toggleSizeList[v] = toggle
      toggle:SetOnValueChanged(function(isOn)
        if isOn then
          self.PhotoCanva:SetPhotoSize(v)
        end
      end)
      text = toggle:AddComponent(UIText, "Text")
      config = DataCenter.SeasonPhotoTemplateManager:GetConfigDataSize(v)
      if config then
        text:SetLocalText(config.name)
        text:SetActive(true)
      end
    end
  end
  if photoConfig.season_alliance_photo_border then
    for i, v in ipairs(photoConfig.season_alliance_photo_border) do
      local goItem = self.FrameObj:GameObjectSpawn(self.MenuFrame.transform)
      goItem:SetActive(true)
      goItem.name = string.format("Frame_%d", i)
      toggle = self.MenuFrame:AddComponent(UIToggle, goItem.name)
      self.toggleFrameList[v] = toggle
      toggle:SetOnValueChanged(function(isOn)
        if isOn then
          self.PhotoCanva:SetPhotoFrame(v)
        end
      end)
      text = toggle:AddComponent(UIText, "Text")
      frame = toggle:AddComponent(UIImage, "Background")
      lock = toggle:AddComponent(UIButton, "Lock")
      config = DataCenter.SeasonPhotoTemplateManager:GetConfigDataBorder(v)
      if config then
        text:SetLocalText(config.name)
        frame:LoadSpriteAsyncEx(config.resource_icon)
        if config:IsLock(data.settleRank, data.seasonRewardConfigId) then
          lock:SetActive(true)
          toggle:SetInteractable(false)
        else
          lock:SetActive(false)
          toggle:SetInteractable(true)
        end
        lock:SetOnClick(function()
          UIUtil.ShowTipsId("season_alliance_photo_tips_21")
        end)
      end
    end
  end
end

SeasonPhotoCanvaMenu.OnCreate = OnCreate
SeasonPhotoCanvaMenu.OnDestroy = OnDestroy
SeasonPhotoCanvaMenu.OnEnable = OnEnable
SeasonPhotoCanvaMenu.OnDisable = OnDisable
SeasonPhotoCanvaMenu.ComponentDefine = ComponentDefine
SeasonPhotoCanvaMenu.ComponentDestroy = ComponentDestroy
SeasonPhotoCanvaMenu.DataDefine = DataDefine
SeasonPhotoCanvaMenu.DataDestroy = DataDestroy
return SeasonPhotoCanvaMenu
