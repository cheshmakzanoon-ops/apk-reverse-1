local base = UIBaseContainer
local SeasonPhotoCanva = BaseClass("SeasonPhotoCanva", base)
local SeasonPhotoHead = require("UI.LWSeason.LWSeasonPhoto.Component.SeasonPhotoHead")
local UIGray = CS.UIGray
local ContentHead_path = "ScrollView/Viewport/Content/ContentHead"
local SeasonPhotoHead_path = "ScrollView/Viewport/Content/ContentHead/SeasonPhotoHead"
local Content_path = "ScrollView/Viewport/Content"
local TextName_path = "ScrollView/Viewport/Content/TextName"
local Check_path = "ScrollView/Viewport/Content/ContentHead/Check"
local BtnOk_path = "ScrollView/Viewport/Content/ContentHead/Check/BtnOk"
local BtnCancel_path = "ScrollView/Viewport/Content/ContentHead/Check/BtnCancel"
local CheckBg_path = "CheckBg"
local GridBg_path = "ScrollView/Viewport/Content/GridBg"
local ContentGrid_path = "ScrollView/Viewport/Content/ContentHead/ContentGrid"
local Grid_path = "ScrollView/Viewport/Content/ContentHead/ContentGrid/Grid"
local Trigger_path = "ScrollView/Viewport/Content"
local ScrollView_path = "ScrollView"
local BgSmall_path = "ScrollView/Viewport/Content/BgSmall"
local Frame_path = "ScrollView/Viewport/Content/Frame"
local Code_path = "ScrollView/Viewport/Content/Frame/Code"
local Logo_path = "ScrollView/Viewport/Content/Frame/Logo"
local Reward_path = "ScrollView/Viewport/Content/Frame/RewardIcon/Reward"
local AllianceIcon_path = "ScrollView/Viewport/Content/Frame/Alliance/AllianceIcon"
local AllianceName_path = "ScrollView/Viewport/Content/Frame/Alliance/AllianceName"
local Date_path = "ScrollView/Viewport/Content/Frame/Alliance/Date"
local ArrowLeft_path = "ScrollView/Viewport/Content/ContentHead/ContentGrid/ArrowLeft"
local ArrowRight_path = "ScrollView/Viewport/Content/ContentHead/ContentGrid/ArrowRight"
local ArrowUp_path = "ScrollView/Viewport/Content/ContentHead/ContentGrid/ArrowUp"
local ArrowDown_path = "ScrollView/Viewport/Content/ContentHead/ContentGrid/ArrowDown"
local BtnHelp_path = "ScrollView/Viewport/Content/BtnHelp"
local GridHelp_path = "ScrollView/Viewport/Content/GridHelp"
local txtPosLeft_path = "ScrollView/Viewport/Content/GridHelp/txtPosLeft"
local txtPosRight_path = "ScrollView/Viewport/Content/GridHelp/txtPosRight"
local txtPosBot_path = "ScrollView/Viewport/Content/GridHelp/txtPosBot"
local txtPosTop_path = "ScrollView/Viewport/Content/GridHelp/txtPosTop"

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
  self.ContentHead = self:AddComponent(UIBaseContainer, ContentHead_path)
  self.SeasonPhotoHead = self:AddComponent(UIBaseContainer, SeasonPhotoHead_path)
  self.Content = self:AddComponent(UIBaseContainer, Content_path)
  self.TextName = self:AddComponent(UIText, TextName_path)
  self.Check = self:AddComponent(UIBaseContainer, Check_path)
  self.BtnOk = self:AddComponent(UIButton, BtnOk_path)
  self.BtnCancel = self:AddComponent(UIButton, BtnCancel_path)
  self.CheckBg = self:AddComponent(UIButton, CheckBg_path)
  self.GridBg = self:AddComponent(UIRawImage, GridBg_path)
  self.ContentGrid = self:AddComponent(UIBaseContainer, ContentGrid_path)
  self.Grid = self:AddComponent(UIBaseContainer, Grid_path)
  self.Trigger = self:AddComponent(UIEventTrigger, Trigger_path)
  self.ScrollView = self:AddComponent(UIScrollRect, ScrollView_path)
  self.BgSmall = self:AddComponent(UIRawImage, BgSmall_path)
  self.Frame = self:AddComponent(UIBaseContainer, Frame_path)
  self.Code = self:AddComponent(UIImage, Code_path)
  self.Logo = self:AddComponent(UIRawImage, Logo_path)
  self.Reward = self:AddComponent(UIRawImage, Reward_path)
  self.AllianceIcon = self:AddComponent(UIImage, AllianceIcon_path)
  self.AllianceName = self:AddComponent(UIText, AllianceName_path)
  self.Date = self:AddComponent(UIText, Date_path)
  self.ArrowLeft = self:AddComponent(UIImage, ArrowLeft_path)
  self.ArrowRight = self:AddComponent(UIImage, ArrowRight_path)
  self.ArrowUp = self:AddComponent(UIImage, ArrowUp_path)
  self.ArrowDown = self:AddComponent(UIImage, ArrowDown_path)
  self.BtnHelp = self:AddComponent(UIButton, BtnHelp_path)
  self.GridHelp = self:AddComponent(UIBaseContainer, GridHelp_path)
  self.txtPosLeft = self:AddComponent(UIText, txtPosLeft_path)
  self.txtPosRight = self:AddComponent(UIText, txtPosRight_path)
  self.txtPosBot = self:AddComponent(UIText, txtPosBot_path)
  self.txtPosTop = self:AddComponent(UIText, txtPosTop_path)
  self.BtnCancel:SetOnClick(BindCallback(self, self.CancelMove))
  self.CheckBg:SetOnClick(BindCallback(self, self.CancelMove))
  self.BtnOk:SetOnClick(BindCallback(self, self.OkMove))
  self.HeadObj = self.SeasonPhotoHead.gameObject
  self.HeadObj:GameObjectCreatePool()
  self.HeadObj:SetActive(false)
  self.GridLayout = self:AddComponent(UIGridLayoutGroup, ContentGrid_path)
  self.GridObj = self.Grid.gameObject
  self.GridObj:GameObjectCreatePool()
  self.GridObj:SetActive(false)
  self.ContentRect = self.ContentHead.rectTransform
  self.Trigger:OnPointerClick(function(eventData)
    if self.selectHead and not self.hasDrag then
      self:OnDrag(eventData.position)
    end
  end)
  self.Trigger:OnBeginDrag(function(eventData)
    self.hasDrag = true
    self.ScrollView:OnBeginDrag(eventData)
  end)
  self.Trigger:OnDrag(function(eventData)
    self.ScrollView:OnDrag(eventData)
  end)
  self.Trigger:OnEndDrag(function(eventData)
    self.hasDrag = false
    self.ScrollView:OnEndDrag(eventData)
  end)
  self.GridHelp:SetActive(false)
  if CS.SDKManager.IS_UNITY_EDITOR() and Setting:GetPrivateBool("GM_PHOTO_SHOW_GRID_BTN", false) then
    self.BtnHelp:SetActive(true)
    self.BtnHelp:SetOnClick(function()
      if self.GridHelp.activeSelf then
        self.GridHelp:SetActive(false)
        self.GridBg:SetActive(false)
      else
        self:RefreshGridHelp()
        self.GridHelp:SetActive(true)
      end
    end)
  else
    self.BtnHelp:SetActive(false)
  end
end

local function ComponentDestroy(self)
  self.ContentHead:RemoveComponents(SeasonPhotoHead)
  self.HeadObj:GameObjectRecycleAll()
  self.ContentGrid:RemoveComponents(UIImage)
  self.GridObj:GameObjectRecycleAll()
  self.ContentHead = nil
  self.SeasonPhotoHead = nil
  self.Content = nil
  self.TextName = nil
  self.Check = nil
  self.BtnOk = nil
  self.BtnCancel = nil
  self.CheckBg = nil
  self.GridBg = nil
  self.ContentGrid = nil
  self.Grid = nil
  self.Trigger = nil
  self.ScrollView = nil
  self.BgSmall = nil
  self.Frame = nil
  self.Code = nil
  self.Logo = nil
  self.Reward = nil
  self.AllianceIcon = nil
  self.AllianceName = nil
  self.Date = nil
  self.ArrowLeft = nil
  self.ArrowRight = nil
  self.ArrowUp = nil
  self.ArrowDown = nil
  self.BtnHelp = nil
  self.GridHelp = nil
  self.txtPosLeft = nil
  self.txtPosRight = nil
  self.txtPosBot = nil
  self.txtPosTop = nil
end

local function DataDefine(self)
  self.data = nil
  self.HeadItemDic = {}
  self.GridItemDic = {}
  self.GridInfoDic = {}
end

local function DataDestroy(self)
  self.data = nil
end

function SeasonPhotoCanva:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.SeasonPhotoOneView, self.OnSeasonPhotoOneView)
  self:AddUIListener(EventId.SeasonPhotoHeadBeginDrag, self.OnBeginDrag)
  self:AddUIListener(EventId.SeasonPhotoHeadEndDrag, self.OnEndDrag)
  self:AddUIListener(EventId.SeasonPhotoHeadDrag, self.OnDrag)
end

function SeasonPhotoCanva:OnRemoveListener()
  self:RemoveUIListener(EventId.SeasonPhotoOneView, self.OnSeasonPhotoOneView)
  self:RemoveUIListener(EventId.SeasonPhotoHeadBeginDrag, self.OnBeginDrag)
  self:RemoveUIListener(EventId.SeasonPhotoHeadEndDrag, self.OnEndDrag)
  self:RemoveUIListener(EventId.SeasonPhotoHeadDrag, self.OnDrag)
  base.OnRemoveListener(self)
end

function SeasonPhotoCanva:SetPhotoInfo(season, allianceId, isEdit, useOld, useSmall, picData_)
  self.season = season
  self.allianceId = allianceId
  self.isEdit = isEdit
  self.useSmall = useSmall
  if not useOld then
    DataCenter.SeasonPhotoManager:RequestSeasonPhotoOneView(season, allianceId)
  end
  self:SetData(picData_)
  return self.data, self.userSettleRecord, self.picData
end

function SeasonPhotoCanva:OnSeasonPhotoOneView(userData)
  if userData.season ~= self.season or userData.allianceId ~= self.allianceId then
    return
  end
  self.autoPic = self.isEdit
  self:SetData()
end

function SeasonPhotoCanva:GetData()
  return self.data, self.userSettleRecord, self.picData
end

function SeasonPhotoCanva:SetData(picData_)
  self.data, self.userSettleRecord = DataCenter.SeasonPhotoManager:GetSeasonPhotoData(self.season, self.allianceId)
  if picData_ then
    self.picData = picData_
  elseif self.data then
    self.picData = self.isEdit and self.data:GetTempPicData() or self.data.picData
  end
  self:RefreshView()
end

function SeasonPhotoCanva:SetPhotoData(data, userSettleRecord, picData, isEdit)
  self.season = data.season
  self.allianceId = data.allianceId
  self.isEdit = isEdit
  self.data = data
  self.userSettleRecord = userSettleRecord
  self.picData = picData
  self:RefreshView()
end

function SeasonPhotoCanva:RefreshView()
  self:RefreshSize()
  self:RefreshHeads()
  self:RemoveGrids()
  self:SetFrameInfo()
  self:CancelMove()
  if self.autoPic then
    self.autoPic = nil
    self:AutoPhotoSelf()
  end
  EventManager:GetInstance():Broadcast(EventId.SeasonPhotoRefresh, self)
end

function SeasonPhotoCanva:RefreshSize()
  if not self.data then
    return
  end
  self.contentSize = self.ContentHead:GetSizeDeltaXY()
  if self.photoTileSize and self.photoTileSize ~= self.data:GetPhotoSize(self.picData) then
    self:RemoveGrids(true)
  end
  self.photoTileSize = self.data:GetPhotoSize(self.picData)
  self.tileSize = self.contentSize / self.photoTileSize
  self.totalSize = self.tileSize * self.photoTileSize
  if self.GridHelp and self.GridHelp.activeSelf then
    self:RefreshGridHelp()
  end
end

function SeasonPhotoCanva:RefreshHeads()
  self.HeadItemDic = {}
  self.ContentHead:RemoveComponents(SeasonPhotoHead)
  self.HeadObj:GameObjectRecycleAll()
  local playerArr = self.picData and self.picData.playerArr
  if playerArr then
    for i, data in ipairs(playerArr) do
      self:RefreshHead(data, i)
    end
  end
end

function SeasonPhotoCanva:RefreshHead(data, i)
  local head = self.HeadItemDic[data.uid]
  local member = self.data.memberDic[data.uid]
  if not head then
    local goItem = self.HeadObj:GameObjectSpawn(self.ContentHead.transform)
    goItem:SetActive(true)
    goItem.name = string.format("Head_%d", i)
    head = self.ContentHead:AddComponent(SeasonPhotoHead, goItem.name)
    local size = member.headSize * self.tileSize
    head:SetSizeDeltaXY(size, size)
    self:OnAddHead(data, member.headSize)
    self.HeadItemDic[data.uid] = head
  end
  head:ReInit(i, data, member, self.tileSize, self.isEdit)
  return head
end

function SeasonPhotoCanva:GetPointId(tileX, tileY)
  return tileX * 1000 + tileY
end

function SeasonPhotoCanva:GetPoint(tileId)
  local tileX = math.floor(tileId / 1000)
  local tileY = tileId % 1000
  return tileX, tileY
end

function SeasonPhotoCanva:OnAddHead(data, headSize)
  local posX, posY, pointId = data.posX, data.posY
  for x = posX, posX + headSize - 1 do
    for y = posY, posY + headSize - 1 do
      pointId = self:GetPointId(x, y)
      local uid = self.GridInfoDic[pointId]
      if uid and uid ~= data.uid then
        Logger.LogWarning(string.format("OnAddHead, pointId is occupied, x:%d, y:%d", x, y))
      end
      self.GridInfoDic[pointId] = data.uid
    end
  end
end

function SeasonPhotoCanva:OnRemoveHead(data, headSize)
  local posX, posY, pointId = data.posX, data.posY
  for x = posX, posX + headSize - 1 do
    for y = posY, posY + headSize - 1 do
      pointId = self:GetPointId(x, y)
      if self.GridInfoDic[pointId] == data.uid then
        self.GridInfoDic[pointId] = nil
      else
        Logger.LogWarning(string.format("OnRemoveHead, pointId is not occupied, x:%d, y:%d", x, y))
      end
    end
  end
end

function SeasonPhotoCanva:GetGridInfo(tileX, tileY)
  return self.GridInfoDic[self:GetPointId(tileX, tileY)]
end

function SeasonPhotoCanva:IsPhotoDirty()
  return DataCenter.SeasonPhotoManager:IsPhotoDirty(self.data, self.picData)
end

function SeasonPhotoCanva:GetTempPicData()
  if self.data and self.data.picData == self.picData then
    self.picData = self.data:GetTempPicData()
  end
  return self.picData
end

function SeasonPhotoCanva:SetPhotoSize(sizeConfigId)
  if not self.data then
    return
  end
  if self.picData.sizeConfigId == sizeConfigId then
    return
  end
  local config = DataCenter.SeasonPhotoTemplateManager:GetConfigDataSize(sizeConfigId)
  local photoTileSizeNew = config and config.size or 10
  if photoTileSizeNew < self.photoTileSize then
    for _, head in pairs(self.HeadItemDic) do
      if self:IsOverlap(head.data.posX, head.data.posY, head.member.headSize, head.data.uid, photoTileSizeNew) then
        UIUtil.ShowTipsId("season_alliance_photo_tips_34")
        EventManager:GetInstance():Broadcast(EventId.SeasonPhotoRefresh, self)
        return
      end
    end
  end
  if not self.isEdit then
    self.picData = self:GetTempPicData()
  end
  self.picData.sizeConfigId = sizeConfigId
  self:RefreshView()
end

function SeasonPhotoCanva:SetFrameInfo()
  if not self.data then
    self.Frame:SetActive(false)
    self.Reward:SetActive(false)
    local defaultPhotoConfig = DataCenter.SeasonPhotoTemplateManager:GetDefaultBorderConfig(self.season)
    if defaultPhotoConfig then
      self.BgSmall:LoadSpriteAsync(defaultPhotoConfig.resource)
      self.Frame:SetAnchoredPositionXY(0, 95)
    end
    return
  end
  if self.TextName.activeSelf then
    self.TextName:SetText(string.format("#%d [%s] %s", self.data.serverId, self.data.abbr, self.data.allianceName))
  else
    self.TextName:SetText("")
  end
  local photoConfig = DataCenter.SeasonPhotoTemplateManager:GetConfigData(self.data.photoConfigId)
  if photoConfig then
    if self.Code.activeSelf then
      self.Code:LoadSpriteAsyncEx(photoConfig.qr_code)
    end
    if self.Logo.activeSelf then
      self.Logo:LoadSpriteAsync(photoConfig.season_icon)
    end
    local icon = photoConfig:GetTierIcon(self.data.settleRank, self.data.seasonRewardConfigId, self.data.settleType)
    if string.IsNullOrEmpty(icon) then
      self.Reward:SetActive(false)
    else
      self.Reward:LoadSpriteAsync(icon)
      self.Reward:SetActive(true)
    end
  end
  local borderConfig = self.data:GetPhotoBorderConfig(self.picData)
  if borderConfig then
    self.BgSmall:LoadSpriteAsync(borderConfig.resource)
    self.Frame:SetAnchoredPositionXY(0, 95)
  end
  self.AllianceIcon:LoadSprite(string.format(AL_FLAG_SPRITE_PATH, self.data.icon))
  self.AllianceName:SetText(string.format("#%d [%s] %s", self.data.serverId, self.data.abbr, self.data.allianceName))
  if self.userSettleRecord and self.userSettleRecord.recordTime then
    local year, month, day = UITimeManager:GetInstance():TimeStampToDayTbForLocal(self.userSettleRecord.recordTime)
    self.Date:SetLocalText("season_alliance_photo_UI_40", self.data.season, year, month, day)
  else
    self.Date:SetText("")
  end
  self.Frame:SetActive(true)
end

function SeasonPhotoCanva:SetPhotoFrame(borderConfigId)
  if not self.data then
    return
  end
  if self.picData.borderConfigId == borderConfigId then
    return
  end
  if not self.isEdit then
    self.picData = self:GetTempPicData()
  end
  self.picData.borderConfigId = borderConfigId
  self:RefreshView()
end

function SeasonPhotoCanva:AutoPhotoSelf()
  if not self.isEdit then
    return
  end
  local memberDic = self.data and self.data.memberDic
  if not memberDic then
    return
  end
  local selfUid = LuaEntry.Player.uid
  for uid, member in pairs(memberDic) do
    if uid == selfUid then
      self:AutoPhoto(member, true)
      return
    end
  end
end

function SeasonPhotoCanva:AutoPhotoAll()
end

function SeasonPhotoCanva:AutoPhoto(member, playAnim)
  if not member then
    return
  end
  local head = self.HeadItemDic[member.uid]
  if head then
    return
  end
  local posX, posY = self:PlaceHeadFromCenter(member.headSize)
  if not posX then
    return
  end
  local aData
  if member.uid == LuaEntry.Player.uid then
    aData = LuaEntry.Player
  else
    aData = DataCenter.AllianceMemberDataManager:GetAllianceMemberByUid(member.uid)
  end
  local data = {}
  data.uid = member.uid
  data.posX = posX
  data.posY = posY
  if aData and (not string.IsNullOrEmpty(aData.pic) or aData.picVer > 0) then
    data.pic = aData.pic
    data.picVer = aData.picVer
  else
    data.pic = member.pic
    data.picVer = member.picVer
  end
  local index = #self.picData.playerArr + 1
  self.picData.playerArr[index] = data
  head = self:RefreshHead(data, index)
  if playAnim then
    head:SetActive(false)
    TimerManager:GetInstance():DelayInvoke(function()
      if head then
        head:SetActive(true)
        head:PlayAnim()
      end
    end, 3.8)
    EventManager:GetInstance():Broadcast(EventId.SeasonPhotoAddHead, head)
  end
  return head
end

function SeasonPhotoCanva:SavePhoto(param)
  DataCenter.SeasonPhotoManager:SavePhoto(self)
end

function SeasonPhotoCanva:UploadPhoto()
  if self.Check:GetActive() then
    UIUtil.ShowTipsId("season_alliance_photo_tips_28")
    return
  end
  DataCenter.SeasonPhotoManager:UploadPhoto(self.data, self.picData, self.userSettleRecord, self)
end

function SeasonPhotoCanva:SharePhoto()
  DataCenter.SeasonPhotoManager:SharePhoto(self.season, self.allianceId)
end

function SeasonPhotoCanva:ReplacePic(head)
  if not head then
    return
  end
  local player = LuaEntry.Player
  if not player then
    return
  end
  if head.data.uid == player.uid and (head.pic ~= player.pic or head.picVer ~= player.picVer) then
    head.data.pic = player.pic
    head.data.picVer = player.picVer
    head:SetHead(player.uid, head.data.pic, head.data.picVer)
  end
end

function SeasonPhotoCanva:OnBeginDrag(head)
  if not head or not self.isEdit then
    return
  end
  if self.selectHead then
    self.selectHead:ResetPosition(self.tileSize)
  end
  self.selectHead = head
  self:RefreshGrids()
  self:ShowMove(head)
  self:ReplacePic(head)
  self.Check:SetSiblingIndex(1000)
end

function SeasonPhotoCanva:OnEndDrag(position)
  if not self.selectHead or not self.isEdit then
    return
  end
  self:OnDrag(position)
end

function SeasonPhotoCanva:OnDrag(position)
  if not self.selectHead or not self.isEdit then
    return
  end
  local factor = 1
  if CommonUtil then
    factor = CommonUtil.ArabicAutoMirrorFactor()
    if factor == nil then
      factor = 1
    end
  end
  position = PosConverse.ScreenToUIPos(self.ContentRect, position)
  local halfSize = self.selectHead.member.headSize * 0.5 * self.tileSize
  local tileX = math.floor((position.x - halfSize) / self.tileSize)
  local tileY = math.floor((position.y - halfSize) / self.tileSize)
  self.selectHead:SetPosition(tileX, tileY, self.tileSize)
  self:ShowMove(self.selectHead, tileX, tileY)
  self.selectTileX = tileX
  self.selectTileY = tileY
end

function SeasonPhotoCanva:ShowMove(head, tileX, tileY)
  local factor = 1
  if CommonUtil then
    factor = CommonUtil.ArabicAutoMirrorFactor()
    if factor == nil then
      factor = 1
    end
  end
  self.Check:SetActive(true)
  self.CheckBg:SetActive(true)
  tileX = tileX or head.data.posX
  tileY = tileY or head.data.posY
  local halfSize = head.member.headSize * 0.5
  local x, y = (tileX + halfSize) * self.tileSize, (tileY + halfSize) * self.tileSize
  self.Check:SetLocalPositionXYZ(x * factor, y, 0)
  self.Check:SetSizeDeltaXY(100, halfSize * 2 * self.tileSize)
  self.ContentGrid:SetLocalPositionXYZ(x * factor, y, 0)
  local isOverlap = self:CheckGrids(tileX, tileY, head.member.headSize, head.data.uid)
  UIGray.SetGray(self.BtnOk.transform, isOverlap, true)
end

function SeasonPhotoCanva:CancelMove()
  self.Check:SetActive(false)
  self.CheckBg:SetActive(false)
  if self.selectHead then
    self.selectHead:ResetPosition(self.tileSize)
  end
  self.selectHead = nil
  self:RemoveGrids(true)
end

function SeasonPhotoCanva:OkMove()
  if not self:IsOverlap(self.selectTileX, self.selectTileY, self.selectHead.member.headSize, self.selectHead.data.uid, nil, true) then
    self:OnRemoveHead(self.selectHead.data, self.selectHead.member.headSize)
    self.selectHead:SetPosition(self.selectTileX, self.selectTileY, self.tileSize, true)
    self:OnAddHead(self.selectHead.data, self.selectHead.member.headSize)
    self.selectHead:PlayAnim()
    self:CancelMove()
    EventManager:GetInstance():Broadcast(EventId.SeasonPhotoEditChange)
  end
end

function SeasonPhotoCanva:RefreshGrids()
  if self.hasGrid then
    self.GridBg:SetActive(true)
    self.ContentGrid:SetActive(true)
    self.ContentGrid:SetSiblingIndex(998)
    return
  end
  self.hasGrid = true
  self.GridItemDic = {}
  self.ContentGrid:RemoveComponents(UIImage)
  self.GridObj:GameObjectRecycleAll()
  local headTileSize = self.selectHead and self.selectHead.member.headSize
  local gridsRealSize = headTileSize * self.tileSize
  self.ContentGrid:SetSizeDeltaXY(gridsRealSize, gridsRealSize)
  local parent, goItem = self.ContentGrid.transform
  for y = 0, headTileSize - 1 do
    for x = 0, headTileSize - 1 do
      goItem = self.GridObj:GameObjectSpawn(parent)
      goItem.name = string.format("Grid_%d_%d", x, y)
      goItem:SetActive(true)
      self.GridItemDic[self:GetPointId(x, y)] = self.ContentGrid:AddComponent(UIImage, goItem.name)
    end
  end
  self.GridLayout:SetCellSize(self.tileSize, self.tileSize)
  self.GridLayout:SetConstraintCount(headTileSize)
  self.ContentGrid:SetActive(true)
  self.GridBg:SetUVRectPositionAndSize(0, 0, self.photoTileSize, self.photoTileSize)
  self.GridBg:SetActive(true)
end

function SeasonPhotoCanva:RemoveGrids(delete)
  self.GridBg:SetActive(false)
  self.ContentGrid:SetActive(false)
  if delete then
    self.ContentGrid:RemoveComponents(UIImage)
    self.GridObj:GameObjectRecycleAll()
    self.hasGrid = false
  end
end

local L_COLOR_RED = Color.New(1, 0.435, 0.259, 1)
local L_COLOR_GREEN = Color.New(0.533, 0.675, 0.235, 1)
local L_COLOR_GREEN_S1 = Color.New(0.659, 0.9254903, 0.796, 1)

function SeasonPhotoCanva:CheckGrids(tileX, tileY, headSize, headUid)
  if not self.hasGrid then
    return
  end
  local isOverlap = false
  local halfCount = self.photoTileSize / 2
  local seasonType = SeasonUtil.GetSeasonType()
  local green = seasonType == SeasonMapType.CityStronghold and L_COLOR_GREEN_S1 or L_COLOR_GREEN
  for y = 0, headSize - 1 do
    for x = 0, headSize - 1 do
      local goItem = self.GridItemDic[self:GetPointId(x, y)]
      if goItem then
        local gridUid = self:GetGridInfo(x + tileX, y + tileY)
        if gridUid and gridUid ~= headUid or x + tileX < -halfCount or halfCount <= x + tileX or y + tileY < -halfCount or halfCount <= y + tileY then
          isOverlap = true
          goItem:SetColor(L_COLOR_RED)
        else
          goItem:SetColor(green)
        end
      end
    end
  end
  if isOverlap then
    self.ArrowLeft:SetColor(L_COLOR_RED)
    self.ArrowRight:SetColor(L_COLOR_RED)
    self.ArrowUp:SetColor(L_COLOR_RED)
    self.ArrowDown:SetColor(L_COLOR_RED)
  else
    self.ArrowLeft:SetColor(green)
    self.ArrowRight:SetColor(green)
    self.ArrowUp:SetColor(green)
    self.ArrowDown:SetColor(green)
  end
  return isOverlap
end

function SeasonPhotoCanva:IsOverlap(tileX, tileY, headSize, headUid, photoTileSize_, showTips_)
  photoTileSize_ = photoTileSize_ or self.photoTileSize
  local halfCount = photoTileSize_ / 2
  local halfCountWithSize = halfCount - headSize
  if tileX < -halfCount or tileX > halfCountWithSize or tileY < -halfCount or tileY > halfCountWithSize then
    if showTips_ then
      UIUtil.ShowTipsId("season_alliance_photo_tips_23")
    end
    return true
  end
  local overlapX, overlapY
  for x = tileX, tileX + headSize - 1 do
    for y = tileY, tileY + headSize - 1 do
      local uid = self:GetGridInfo(x, y)
      if uid and uid ~= headUid then
        overlapX = x
        overlapY = y
        break
      end
    end
  end
  local isOverlap = overlapX ~= nil
  if isOverlap and showTips_ then
    UIUtil.ShowTipsId("season_alliance_photo_tips_22")
  end
  return isOverlap, overlapX, overlapY
end

function SeasonPhotoCanva:PlaceHeadFromCenter(headSize)
  local halfCount = self.photoTileSize / 2
  local halfCountWithSize = halfCount - headSize
  local x, y = 0, 0
  local step = 1
  local maxStep = halfCountWithSize
  local stepX, stepY = 0, 1
  local isOverlap, overlapX, overlapY
  while step <= maxStep do
    for i = 1, step do
      x = x + stepX
      y = y + stepY
      isOverlap, overlapX, overlapY = self:IsOverlap(x, y, headSize)
      if not overlapX then
        return x, y
      end
    end
    stepX, stepY = -stepY, stepX
    for i = 1, step do
      x = x + stepX
      y = y + stepY
      isOverlap, overlapX, overlapY = self:IsOverlap(x, y, headSize)
      if not overlapX then
        return x, y
      end
    end
    step = step + 1
  end
  Logger.LogWarning("PlaceHeadFromCenter, can not find a place to place head")
end

function SeasonPhotoCanva:RefreshGridHelp()
  local halfSize = toInt(self.photoTileSize / 2)
  self.txtPosTop:SetText(string.format("(%s,%s)", 0, halfSize))
  self.txtPosBot:SetText(string.format("(%s,%s)", 0, -halfSize))
  self.txtPosLeft:SetText(string.format("(%s,%s)", -halfSize, 0))
  self.txtPosRight:SetText(string.format("(%s,%s)", halfSize, 0))
  self.GridBg:SetUVRectPositionAndSize(0, 0, self.photoTileSize, self.photoTileSize)
  self.GridBg:SetActive(true)
end

SeasonPhotoCanva.OnCreate = OnCreate
SeasonPhotoCanva.OnDestroy = OnDestroy
SeasonPhotoCanva.OnEnable = OnEnable
SeasonPhotoCanva.OnDisable = OnDisable
SeasonPhotoCanva.ComponentDefine = ComponentDefine
SeasonPhotoCanva.ComponentDestroy = ComponentDestroy
SeasonPhotoCanva.DataDefine = DataDefine
SeasonPhotoCanva.DataDestroy = DataDestroy
return SeasonPhotoCanva
