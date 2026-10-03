local base = UIBaseContainer
local UIMainFireworkBackBtnItem = BaseClass("UIMainFireworkBackBtnItem", base)
local Localization = CS.GameEntry.Localization
local leftPadding = 250
local topPadding = 250
local NamePosDelta = Vector3.New(-2, -125, 0)
local BgRotationDelta = Vector3.New(0, 0, 0)
local BackBtnShowDistance = 8
local world_world_center_back_arrow_path = "Root/WorldCenterBackArrow"
local world_world_center_back_name_path = "Root/WorldCenterBackBtnName"
local world_world_center_back_btn_path = ""
local root_path = "Root"
local extra_root_path = "ExtraRoot"
local arrow_path = "ExtraRoot/Arrow"
local extra_icon_path = "ExtraRoot/ExtraIcon"
local back_btn_name_path = "ExtraRoot/BackBtnName"
local EXTRA_ICON_PATH = "Assets/Main/Sprites/ItemIcons/LXY_tmjy_01.png"

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

local function OnDestroy(self)
  self:DataDestroy()
  self:ComponentDestroy()
  self:ExtraComponentDestroy()
  base.OnDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function ComponentDefine(self)
  self.world_world_center_back_arrow = self:AddComponent(UIBaseContainer, world_world_center_back_arrow_path)
  self.world_world_center_back_name = self:AddComponent(UIText, world_world_center_back_name_path)
  self.world_world_center_back_btn = self:AddComponent(UIButton, world_world_center_back_btn_path)
  self.world_world_center_back_btn:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    local finalPos
    if BattleFieldUtil.InBattleField() then
      return
    end
    if self.ConstructPos ~= nil then
      finalPos = self.ConstructPos
    end
    self.view.ctrl:OnClickJumpOtherPlayerBtn(finalPos, self.targetServerId)
  end)
  self.root = self:AddComponent(UIBaseContainer, root_path)
end

local function ComponentDestroy(self)
  self.world_world_center_back_arrow = nil
  self.world_world_center_back_name = nil
  self.world_world_center_back_btn = nil
  self.root = nil
end

local function ExtraComponentDefine(self)
  self.extra_root = self:AddComponent(UIBaseContainer, extra_root_path)
  self.arrow = self:AddComponent(UIImage, arrow_path)
  self.extra_icon = self:AddComponent(UIImage, extra_icon_path)
  self.extra_icon:LoadSpriteAuto(EXTRA_ICON_PATH)
  self.back_btn_name = self:AddComponent(UITextMeshProUGUIEx, back_btn_name_path)
end

local function ExtraComponentDestroy(self)
  self.extra_root = nil
  self.arrow = nil
  self.extra_icon = nil
  self.back_btn_name = nil
end

local function DataDefine(self)
  local x, y = self.transform:Get_lossyScale()
  self.lossyScale = y
  self.topPadding = topPadding
  self.leftPadding = leftPadding
  self.disText = Localization:GetString(GameDialogDefine.KILOMETRE)
  self.position = Vector3.New(self.transform:Get_position())
  self.type = 0
  self.arrowNode = self.world_world_center_back_arrow
  self.backNameNode = self.world_world_center_back_name
end

local function DataDestroy(self)
  self.lossyScale = nil
  self.topPadding = nil
  self.leftPadding = nil
  self.disText = nil
  self.position = nil
  self.type = nil
  self.arrowNode = nil
  self.backNameNode = nil
end

local function OnAddListener(self)
  base.OnAddListener(self)
  self:AddUIListener(EventId.FireworkGiftDataCsUpdate, self.OnFireworkDataCsUpdate)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
  self:RemoveUIListener(EventId.FireworkGiftDataCsUpdate, self.OnFireworkDataCsUpdate)
end

function UIMainFireworkBackBtnItem:OnFireworkDataCsUpdate()
  if not self.targetPlayerUid or not DataCenter.LWFireworkGiftManager:IsHasAvailableBoxForMeByUid(self.targetPlayerUid) then
    self:GetData()
    self:UpdateMilePointer(true)
  end
end

function UIMainFireworkBackBtnItem:ReInit()
  self.transform:Set_position(FalseVisiblePos.x, FalseVisiblePos.y, FalseVisiblePos.z)
  self:GetData()
  self:UpdateMilePointer(false)
end

function UIMainFireworkBackBtnItem:GetData()
  if SceneUtils.GetIsInWorld() then
    local giftData
    self.targetPlayerUid, giftData = DataCenter.LWFireworkGiftManager:GetRandomAvailableFireworkBoxPlayerUid()
    if self.targetPlayerUid then
      if giftData then
        local type = giftData.type
        if type ~= self.type then
          self.type = type
          if type == 1 then
            if self.arrow == nil then
              self:ExtraComponentDefine()
            end
            self.arrowNode = self.arrow
            self.backNameNode = self.back_btn_name
            self.root:SetActive(false)
            self.extra_root:SetActive(true)
          else
            self.arrowNode = self.world_world_center_back_arrow
            self.backNameNode = self.world_world_center_back_name
            self.root:SetActive(true)
            self.extra_root:SetActive(false)
          end
        end
      end
      local mainInfo = CS.SceneManager.World:GetBaseMainInfoByOwnerUid(self.targetPlayerUid)
      if mainInfo then
        Logger.LogInfo(string.format("[UIMainFireworkBackBtnItem] targetPlayerUid is %s", self.targetPlayerUid))
        self.ConstructPos = SceneUtils.TileIndexToWorld(mainInfo.pointIndex, ForceChangeScene.World, mainInfo.serverId)
        self.targetServerId = mainInfo.serverId
      else
        self.targetPlayerUid = nil
        self.ConstructPos = nil
        self.targetServerId = nil
      end
    else
      self.ConstructPos = nil
      self.targetServerId = nil
    end
  else
    self.targetPlayerUid = nil
    self.ConstructPos = nil
    self.targetServerId = nil
  end
end

function UIMainFireworkBackBtnItem:UpdateMilePointer(isShow)
  if isShow and self.ConstructPos then
    local show, dist, refDistance, refDist, pos_x, pos_y, eulerAngles_z
    if not CS.SceneManager:IsInWorld() then
      show = false
    else
      refDistance = 0
      show, dist, pos_x, pos_y, eulerAngles_z = UIUtil.CalcConstructMilePointer(leftPadding * self.lossyScale, self.topPadding * self.lossyScale, self.ConstructPos, CS.SceneManager.World.CurTarget)
      pos_y = pos_y + 60
      refDist = dist
    end
    if show and dist > refDistance then
      self:SetWorldWorldCenterActive(true)
      self:SetWorldWorldCenterBackBtnRotation(eulerAngles_z)
      self:SetWorldWorldCenterBackBtnPosition(pos_x, pos_y)
      self:SetWorldWorldCenterBackName(refDist .. self.disText)
    else
      self:SetWorldWorldCenterActive(false)
    end
  else
    self:SetWorldWorldCenterActive(false)
  end
end

function UIMainFireworkBackBtnItem:SetWorldWorldCenterActive(value)
  if not LuaEntry.Player:IsInSelfServer() or BattleFieldUtil.InBattleField() then
    value = false
  end
  if self.worldWorldCenterActive ~= value then
    self.worldWorldCenterActive = value
    self.world_world_center_back_btn:SetActive(value)
    self.backNameNode:SetActive(value)
  end
end

function UIMainFireworkBackBtnItem:SetWorldWorldCenterBackBtnPosition(x, y)
  if self.worldWorldCenterBackBtnPositionX == x and self.worldWorldCenterBackBtnPositionY == y then
    return
  end
  self.worldWorldCenterBackBtnPositionX = x
  self.worldWorldCenterBackBtnPositionY = y
  self.world_world_center_back_btn:SetPositionXYZ(x, y, 0)
end

function UIMainFireworkBackBtnItem:SetWorldWorldCenterBackBtnRotation(value)
  if self.worldWorldCenterBackBtnRotation ~= value then
    self.worldWorldCenterBackBtnRotation = value
    self.arrowNode:SetEulerAnglesXYZ(0, 0, BgRotationDelta.z + value)
  end
end

function UIMainFireworkBackBtnItem:SetWorldWorldCenterBackName(value)
  if self.worldWorldCenterBackName ~= value then
    self.worldWorldCenterBackName = value
    self.backNameNode:SetText(value)
  end
end

UIMainFireworkBackBtnItem.OnCreate = OnCreate
UIMainFireworkBackBtnItem.OnDestroy = OnDestroy
UIMainFireworkBackBtnItem.OnEnable = OnEnable
UIMainFireworkBackBtnItem.OnDisable = OnDisable
UIMainFireworkBackBtnItem.ComponentDefine = ComponentDefine
UIMainFireworkBackBtnItem.ComponentDestroy = ComponentDestroy
UIMainFireworkBackBtnItem.DataDefine = DataDefine
UIMainFireworkBackBtnItem.DataDefine = DataDefine
UIMainFireworkBackBtnItem.DataDestroy = DataDestroy
UIMainFireworkBackBtnItem.OnAddListener = OnAddListener
UIMainFireworkBackBtnItem.OnRemoveListener = OnRemoveListener
UIMainFireworkBackBtnItem.ExtraComponentDefine = ExtraComponentDefine
UIMainFireworkBackBtnItem.ExtraComponentDestroy = ExtraComponentDestroy
return UIMainFireworkBackBtnItem
