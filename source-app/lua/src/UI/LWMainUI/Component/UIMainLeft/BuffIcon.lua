local BuffIcon = BaseClass("BuffIcon", UIBaseContainer)
local base = UIBaseContainer
local RectTransformCSType = typeof(CS.UnityEngine.RectTransform)

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
end

local function OnDestroy(self)
  self:UnLoadBuffEffectView()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

local function ComponentDefine(self)
  self.buff_frame = self:AddComponent(UIImage, "BuffFrame")
  self.item_icon = self:AddComponent(UIImage, "BuffIcon")
  self.btn = self:AddComponent(UIButton, "")
  self.btn:SetOnClick(function()
    if self.param and type(self.param.OnClick) == "function" then
      pcall(self.param.OnClick, self)
    else
      UIManager:GetInstance():OpenWindow(UIWindowNames.UILWCityBuff, {anim = true})
    end
  end)
  if self.buff_frame then
    self.buff_frame:SetActive(true)
  end
  self.item_icon:SetActive(true)
  self.luaPlayerData = nil
  self.playerDataReq = nil
end

local function ComponentDestroy(self)
  self.luaPlayerData = nil
  self.playerDataReq = nil
  self.item_icon = nil
  self.btn = nil
  self.buff_frame = nil
end

local function ReInit(self, param)
  if param and param.meta and param.meta.icon then
    self.item_icon:SetActive(true)
    self.item_icon:LoadSprite(param.meta.icon)
  end
  self.param = param
end

local function SetIcon(self, theIconPath)
  if theIconPath then
    self.item_icon:SetActive(true)
    self.item_icon:LoadSprite(theIconPath)
  end
end

local function SetPlayerData(self, playerData, scale)
  if playerData and (playerData.uid or playerData.ownerUid or playerData.Uid or playerData.tUid) then
    local theSize = 216 * (scale or 0.3)
    self.item_icon:SetActive(false)
    if self.luaPlayerData == nil and self.playerDataReq == nil then
      self.playerDataReq = self:GameObjectInstantiateAsync(UIAssets.UIPlayerHead, function(request)
        if request.isError then
          self.luaPlayerData = nil
          self.playerDataReq = nil
          return
        end
        local go = request.gameObject
        local go_tf = go.transform
        go_tf:SetParent(self.transform)
        local luaPlayerData = self:AddComponent(UICommonHead, go.name)
        luaPlayerData:SetActive(true)
        luaPlayerData:ParseHeadInfo(playerData)
        luaPlayerData:SetFrameActive(false)
        luaPlayerData:SetEnableClickShowInfo(false, false)
        self.item_icon:SetActive(false)
        self.luaPlayerData = luaPlayerData
        go_tf:Set_localScale(1, 1, 1)
        go_tf:Set_localPosition(0, 0, 0)
        local rectTransform = go:GetComponent(RectTransformCSType)
        if rectTransform ~= nil then
          rectTransform:Set_sizeDelta(theSize, theSize)
        end
      end)
    elseif self.luaPlayerData then
      self.luaPlayerData:SetActive(true)
      self.luaPlayerData:ParseHeadInfo(playerData)
      self.luaPlayerData:SetFrameActive(false)
      self.luaPlayerData:SetEnableClickShowInfo(false, false)
      self.luaPlayerData:SetLocalPositionXYZ(0, 0, 0)
      self.luaPlayerData:SetLocalScaleXYZ(0, 0, 0)
      self.luaPlayerData:SetSizeDelta(theSize, theSize)
      self.item_icon:SetActive(false)
    end
  end
end

local function HideFrame(self, hide)
  if self.buff_frame then
    self.buff_frame:SetActive(not hide)
  end
end

local function ShowBuffEffectView(self, effectPath, scale)
  self:UnLoadBuffEffectView()
  self.effectReq = self:GameObjectInstantiateAsync(effectPath, function(request)
    if request.isError then
      return
    end
    local go = request.gameObject
    go.gameObject:SetActive(true)
    go.transform:SetParent(self.btn.transform)
    go.transform:Set_localPosition(0, 0, 0)
    if scale == nil then
      scale = 1
    end
    go.transform:Set_localScale(scale, scale, scale)
  end)
end

local function UnLoadBuffEffectView(self)
  if self.effectReq ~= nil then
    self:GameObjectDestroy(self.effectReq)
    self.effectReq = nil
  end
end

BuffIcon.OnCreate = OnCreate
BuffIcon.OnDestroy = OnDestroy
BuffIcon.ComponentDefine = ComponentDefine
BuffIcon.ComponentDestroy = ComponentDestroy
BuffIcon.ReInit = ReInit
BuffIcon.SetIcon = SetIcon
BuffIcon.SetPlayerData = SetPlayerData
BuffIcon.HideFrame = HideFrame
BuffIcon.ShowBuffEffectView = ShowBuffEffectView
BuffIcon.UnLoadBuffEffectView = UnLoadBuffEffectView
return BuffIcon
