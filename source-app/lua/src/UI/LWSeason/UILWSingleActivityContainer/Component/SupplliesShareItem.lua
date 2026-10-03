local base = UIBaseContainer
local SupplliesShareItem = BaseClass("SupplliesShareItem", base)
local Localization = CS.GameEntry.Localization
local bgImg_path = "bg"
local title_path = "title"
local position_path = "pos"
local playerHead_path = "headRoot/UIPlayerHead"
local name_path = "name"
local gotoBtn_path = "gotoBtn"
local gotoBtnText_path = "gotoBtn/ConfirmBtnText"
local posGotoBtn_path = "posGoto"

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
  self.bgImg = self:AddComponent(UIImage, bgImg_path)
  self.title = self:AddComponent(UIText, title_path)
  self.position = self:AddComponent(UIText, position_path)
  self.playerHead = self:AddComponent(UIBaseContainer, playerHead_path)
  self.name = self:AddComponent(UIText, name_path)
  self.gotoBtn = self:AddComponent(UIButton, gotoBtn_path)
  self.gotoBtnText = self:AddComponent(UIText, gotoBtnText_path)
  self.posGotoBtn = self:AddComponent(UIButton, posGotoBtn_path)
  self.playerIcon = self:AddComponent(UICommonHead, playerHead_path)
  self.playerIcon:SetEnableClickShowInfo(true, true)
  self.gotoBtn:SetOnClick(function()
    self:Jump()
  end)
  self.posGotoBtn:SetOnClick(function()
    self:Jump()
  end)
end

local function ComponentDestroy(self)
  self.bgImg = nil
  self.title = nil
  self.position = nil
  self.playerHead = nil
  self.name = nil
  self.gotoBtn = nil
  self.gotoBtnText = nil
  self.posGotoBtn = nil
end

local function DataDefine(self)
end

local function DataDestroy(self)
end

function SupplliesShareItem:SetData(data)
  self.data = data
  if self.data.state == 1 then
    self.bgImg:LoadSprite("Assets/Main/Sprites/UI/UISeasonReward/Mjc_saijijiangli_list.png")
    self.gotoBtnText:SetLocalText("season_s2_ice_supplies_21")
    CS.UIGray.SetGray(self.gotoBtn.transform, false, true)
  else
    CS.UIGray.SetGray(self.gotoBtn.transform, true, false)
    self.bgImg:LoadSprite("Assets/Main/Sprites/UI/LWCommon/Sprite/mjc_s2_wuzishouji_list01.png")
    if self.data.state == 2 then
      self.gotoBtnText:SetLocalText("season_s2_ice_supplies_22")
    elseif self.data.state == 3 then
      self.gotoBtnText:SetLocalText("season_s2_ice_supplies_23")
    end
  end
  self.playerIcon:SetHeadAndFrame(self.data.uid, self.data.pic, self.data.picver, false, self.data.headSkinId, self.data.headSkinET)
  local configData = LocalController:instance():getLine(TableName.LWIceSupplies, self.data.configId)
  local data = {}
  data[1] = Localization:GetString("season_s2_ice_supplies_3", tostring(configData.level))
  data[2] = Localization:GetString(configData.name)
  local count = 12 - self.data.progress
  if 0 < count then
    data[3] = "<color=#0aa032>" .. tostring(count) .. "</color>"
  else
    data[3] = tostring(count)
  end
  data[4] = "12"
  local title = string.format("%s %s %s/%s", SafeUnpack(data))
  self.title:SetText(title)
  self.name:SetText(self.data.userName)
  local pos = SceneUtils.IndexToTilePos(self.data.pointId, ForceChangeScene.World)
  self.position:SetText(string.format("#%s %s,%s", tostring(self.data.pointServerid), tostring(pos.x), tostring(pos.y)))
end

function SupplliesShareItem:Jump()
  if not self.data then
    return
  end
  GoToUtil.CloseAllWindows()
  local pos = SceneUtils.TileIndexToWorld(self.data.pointId, ForceChangeScene.World)
  GoToUtil.GotoWorldPos(pos, CS.SceneManager.World.InitZoom, LookAtFocusTime, nil, self.data.pointServerid)
end

SupplliesShareItem.OnCreate = OnCreate
SupplliesShareItem.OnDestroy = OnDestroy
SupplliesShareItem.OnEnable = OnEnable
SupplliesShareItem.OnDisable = OnDisable
SupplliesShareItem.ComponentDefine = ComponentDefine
SupplliesShareItem.ComponentDestroy = ComponentDestroy
SupplliesShareItem.DataDefine = DataDefine
SupplliesShareItem.DataDestroy = DataDestroy
return SupplliesShareItem
