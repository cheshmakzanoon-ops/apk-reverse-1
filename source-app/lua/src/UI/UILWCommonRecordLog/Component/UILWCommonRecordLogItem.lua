local base = UIBaseContainer
local UILWCommonRecordLogItem = BaseClass("UILWCommonRecordLogItem", base)
local bg_path = "bg"
local bg_icon_path = "bgIcon"
local txt_time_path = "Txt_Time"
local txt_des_path = "Txt_Des"
local head_icon_prefab_path = "PlayerBtn/UIPlayerHead"
local point_text_path = "pointText"

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
  self.bg = self:AddComponent(UIButton, bg_path)
  self.bg_icon = self:AddComponent(UIImage, bg_icon_path)
  self.txt_time = self:AddComponent(UIText, txt_time_path)
  self.txt_des = self:AddComponent(UIText, txt_des_path)
  self.head_icon_prefab = self:AddComponent(UIBaseContainer, head_icon_prefab_path)
  self.point_text = self:AddComponent(UIText, point_text_path)
  self.head_icon = self:AddComponent(UICommonHead, head_icon_prefab_path)
  self.bg:SetOnClick(function()
    self:onJumpToPos()
  end)
end

local function ComponentDestroy(self)
  self.bg = nil
  self.bg_icon = nil
  self.txt_time = nil
  self.txt_des = nil
  self.head_icon_prefab = nil
  self.point_text = nil
  self.head_icon = nil
end

local function DataDefine(self)
end

local function DataDestroy(self)
end

function UILWCommonRecordLogItem:SetItem(logInfo)
  self.point_text:SetActive(false)
  self.serverId = logInfo.serverId or LuaEntry.Player:GetSourceServerId()
  if logInfo.type == 2 then
    self.txt_des:SetLocalText("season_alliance_mail_history001", logInfo:GetSenderName(), logInfo:GetRankName(), logInfo:GetReceiverName(), logInfo.count)
    self.txt_time:SetText(UITimeManager:GetInstance():TimeStampToTimeForServerMinute(logInfo.time))
    self.bg_icon:LoadSprite("Assets/Main/Sprites/UI/UIActivity/lyp_paiqian_jilu_02")
    local headInfo = logInfo:GetSenderHeadInfo()
    self.head_icon:SetHeadAndFrame(headInfo.uid, headInfo.pic, headInfo.picVer, false, headInfo.headSkinId, headInfo.headSkinET)
    return
  elseif logInfo.type == 3 then
    self:RefreshUserDesertRecord(logInfo)
    return
  end
  if logInfo == nil then
    return
  end
  self.pos = logInfo.pointId
  local langKey
  if logInfo.isAssist == true then
    langKey = 456212
    self.bg_icon:LoadSprite("Assets/Main/Sprites/UI/UIActivity/lyp_paiqian_jilu_02")
  else
    langKey = 456213
    self.bg_icon:LoadSprite("Assets/Main/Sprites/UI/UIActivity/lyp_paiqian_jilu_01")
  end
  local name = logInfo.name
  if not string.IsNullOrEmpty(logInfo.abbr) then
    name = "[" .. logInfo.abbr .. "]" .. name
  end
  local posVec2 = SceneUtils.IndexToTilePos(logInfo.pointId, ForceChangeScene.World)
  local posStr = Localization:GetString(GameDialogDefine.SHOW_POS, posVec2.x, posVec2.y)
  self.txt_des:SetLocalText(langKey, name, posStr)
  self.txt_time:SetText(UITimeManager:GetInstance():TimeStampToTimeForServerMinute(logInfo.time))
  self.head_icon:SetData(logInfo.uid, logInfo.headPic, logInfo.headPicVer)
end

function UILWCommonRecordLogItem:onJumpToPos()
  if self.pos ~= nil then
    if not SceneUtils.CheckCanGotoWorld() then
      return
    end
    local serverId = self.serverId
    local cityPos = SceneUtils.TileIndexToWorld(self.pos, ForceChangeScene.World)
    GoToUtil.CloseAllWindows()
    GoToUtil.GotoWorldPos(cityPos, CS.SceneManager.World.InitZoom, LookAtFocusTime, function()
    end, serverId)
  end
end

function UILWCommonRecordLogItem:RefreshUserDesertRecord(logInfo)
  local uid = LuaEntry.Player:GetUid()
  local pic = LuaEntry.Player:GetPic()
  local picVer = LuaEntry.Player.picVer
  local fullName = LuaEntry.Player:GetFullNameWithSourceServer()
  local headSkinPath = LuaEntry.Player:GetHeadBgImg()
  self.head_icon:SetData(uid, pic, picVer, nil, headSkinPath)
  local level = GetTableData(TableName.Desert, logInfo.desId, "desert_level")
  local nameKey = GetTableData(TableName.Desert, logInfo.desId, "desert_name")
  local posVec2 = SceneUtils.IndexToTilePos(logInfo.pointId, ForceChangeScene.World)
  local posStr = Localization:GetString(GameDialogDefine.SHOW_POS, posVec2.x, posVec2.y)
  self.point_text:SetActive(true)
  self.point_text:SetText(string.format("#%d %s", logInfo.serverId, posStr))
  self.pos = logInfo.pointId
  if logInfo.eventType == 1 then
    if string.IsNullOrEmpty(logInfo.otherUid) then
      local des = Localization:GetString("season_record_ui_001", fullName, level, Localization:GetString(nameKey))
      self.txt_des:SetText(des)
      self.bg_icon:LoadSprite("Assets/Main/Sprites/UI/UIActivity/lyp_paiqian_jilu_02")
    else
      local otherName = logInfo:GetOtherUserFullName()
      local des = Localization:GetString("season_record_ui_003", fullName, otherName, level, Localization:GetString(nameKey))
      self.bg_icon:LoadSprite("Assets/Main/Sprites/UI/UIActivity/lyp_paiqian_jilu_02")
      self.txt_des:SetText(des)
    end
  elseif logInfo.eventType == 2 then
    local des = Localization:GetString("season_record_ui_002", fullName, level, Localization:GetString(nameKey))
    self.bg_icon:LoadSprite("Assets/Main/Sprites/UI/UIActivity/lyp_paiqian_jilu_02")
    self.txt_des:SetText(des)
  elseif logInfo.eventType == 3 then
    local otherName = logInfo:GetOtherUserFullName()
    local des = Localization:GetString("season_record_ui_003", otherName, fullName, level, Localization:GetString(nameKey))
    self.bg_icon:LoadSprite("Assets/Main/Sprites/UI/UIActivity/lyp_paiqian_jilu_01")
    self.txt_des:SetText(des)
    local otherInfo = logInfo:GetOtherUserInfo()
    if otherInfo then
      local uid = otherInfo.uid
      local pic = otherInfo.headPic
      local picVer = otherInfo.headPicVer
      local headBgImg = DataCenter.DecorationDataManager:GetHeadFrame(otherInfo.headSkinId, otherInfo.headSkinET)
      self.head_icon:SetData(uid, pic, picVer, nil, headBgImg)
    end
  end
  self.txt_time:SetText(UITimeManager:GetInstance():TimeStampToTimeForServerMinute(logInfo.time))
end

UILWCommonRecordLogItem.OnCreate = OnCreate
UILWCommonRecordLogItem.OnDestroy = OnDestroy
UILWCommonRecordLogItem.OnEnable = OnEnable
UILWCommonRecordLogItem.OnDisable = OnDisable
UILWCommonRecordLogItem.ComponentDefine = ComponentDefine
UILWCommonRecordLogItem.ComponentDestroy = ComponentDestroy
UILWCommonRecordLogItem.DataDefine = DataDefine
UILWCommonRecordLogItem.DataDestroy = DataDestroy
return UILWCommonRecordLogItem
