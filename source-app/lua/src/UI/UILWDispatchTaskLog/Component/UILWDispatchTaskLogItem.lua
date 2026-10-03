local UILWDispatchTaskLogItem = BaseClass("UILWDispatchTaskLogItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local bg_path = "bg"
local bg_icon_path = "bgIcon"
local txt_time_path = "Txt_Time"
local txt_des_path = "Txt_Des"
local head_icon_path = "PlayerBtn/UIPlayerHead"
local point_text_path = "pointText"

function UILWDispatchTaskLogItem:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UILWDispatchTaskLogItem:OnDestroy()
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

function UILWDispatchTaskLogItem:ComponentDefine()
  self.bg = self:AddComponent(UIButton, bg_path)
  self.bg:SetOnClick(function()
    self:onJumpToPos()
  end)
  self.bg_icon = self:AddComponent(UIImage, bg_icon_path)
  self.txt_time = self:AddComponent(UIText, txt_time_path)
  self.txt_des = self:AddComponent(UIText, txt_des_path)
  self.head_icon = self:AddComponent(UICommonHead, head_icon_path)
  self.point_text = self:AddComponent(UIText, point_text_path)
end

function UILWDispatchTaskLogItem:ComponentDestroy()
  self.bg = nil
  self.bg_icon = nil
  self.txt_time = nil
  self.txt_des = nil
  self.head_icon = nil
  self.point_text = nil
end

function UILWDispatchTaskLogItem:DataDefine()
  self.pos = nil
end

function UILWDispatchTaskLogItem:DataDestroy()
  self.pos = nil
end

function UILWDispatchTaskLogItem:OnAddListener()
  base.OnAddListener(self)
end

function UILWDispatchTaskLogItem:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UILWDispatchTaskLogItem:SetItem(logInfo)
  self.point_text:SetActive(false)
  self.serverId = logInfo.serverId or LuaEntry.Player:GetSourceServerId()
  if logInfo.type == 2 then
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

function UILWDispatchTaskLogItem:onJumpToPos()
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

function UILWDispatchTaskLogItem:RefreshUserDesertRecord(logInfo)
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

return UILWDispatchTaskLogItem
