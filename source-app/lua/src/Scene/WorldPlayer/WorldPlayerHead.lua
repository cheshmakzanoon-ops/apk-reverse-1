local WorldPlayerHead = BaseClass("WorldPlayerHead")
local player_name_path = "Transform/Name"
local player_nameBg_path = "Transform/NameBg"
local head_bg_path = "Transform/HeadBg"
local head_path = "Transform/Head"
local head_frame_path = "Transform/HeadFrame"

local function OnCreate(self, go)
  if go ~= nil then
    self.gameObject = go
    self.transform = go.transform
  end
  self:ComponentDefine()
end

local function OnDestroy(self)
  self:ComponentDestroy()
end

local function ComponentDefine(self)
  self.player_name = self.transform:Find(player_name_path):GetComponent(typeof(CS.SuperTextMesh))
  self.player_nameBg = self.transform:Find(player_nameBg_path)
  self.player_head = self.transform:Find(head_path):GetComponent(typeof(CS.UIPlayerHead))
  self.player_headSp = self.transform:Find(head_path):GetComponent(typeof(CS.UnityEngine.SpriteRenderer))
  self.player_headBg = self.transform:Find(head_bg_path):GetComponent(typeof(CS.UnityEngine.SpriteRenderer))
  self.player_headFrame = self.transform:Find(head_frame_path):GetComponent(typeof(CS.UnityEngine.SpriteRenderer))
end

local function ComponentDestroy(self)
  self.player_name = nil
  self.player_head = nil
  self.player_headSp = nil
  self.player_headBg = nil
  self.player_headFrame = nil
end

local function SetPlayerHeadVisible(self, visible)
  if self.player_head and self.player_head.gameObject then
    self.player_head.gameObject:SetActive(visible)
  end
  if self.player_headFrame and self.player_headFrame.gameObject then
    self.player_headFrame.gameObject:SetActive(visible)
  end
  if self.player_headBg and self.player_headBg.gameObject then
    self.player_headBg.gameObject:SetActive(visible)
  end
end

local function SetName(self, playerInfo)
  if IsNull(self.player_name) then
    return
  end
  if not string.IsNullOrEmpty(playerInfo.name) then
    if not string.IsNullOrEmpty(playerInfo.abbr) then
      self.player_name.text = "[" .. playerInfo.abbr .. "] " .. playerInfo.name
    else
      self.player_name.text = playerInfo.name
    end
  else
    self.player_name.text = ""
  end
end

local function SetData(self, playerInfo, serverId)
  self:SetName(playerInfo)
  self.player_head:SetData(playerInfo.uid, playerInfo.headPic, playerInfo.headPicVer)
  local headFramePath = DataCenter.DecorationDataManager:GetHeadFrame(playerInfo.headSkinId, playerInfo.headSkinET)
  headFramePath = headFramePath or DefaultHeadFramePath
  self.player_headFrame:LoadSprite(headFramePath)
  if playerInfo.uid == LuaEntry.Player.uid then
    self.player_name.color32 = WorldGreenColor32
  elseif not string.IsNullOrEmpty(LuaEntry.Player.allianceId) and serverId == LuaEntry.Player:GetSourceServerId() then
    local data = DataCenter.AllianceBaseDataManager:GetAllianceBaseData()
    if data ~= nil and data.abbr ~= nil and data.abbr ~= "" and playerInfo.abbr == data.abbr then
      self.player_name.color32 = WorldBlueColor32
    else
      self.player_name.color32 = WorldWhiteColor32
    end
  else
    self.player_name.color32 = WorldWhiteColor32
  end
  self.player_name.gameObject:SetActive(true)
  self.player_nameBg.gameObject:SetActive(true)
end

local function SetHeadData(self, playerInfo)
  self:SetName(playerInfo)
  self.player_head:SetData(playerInfo.uid, playerInfo.headPic or playerInfo.pic, playerInfo.headPicVer or playerInfo.picVer)
  local headFramePath = DataCenter.DecorationDataManager:GetHeadFrame(playerInfo.headSkinId, playerInfo.headSkinET)
  headFramePath = headFramePath or playerInfo.HeadBg or DefaultHeadFramePath
  self.player_headFrame:LoadSprite(headFramePath)
  self.player_name.gameObject:SetActive(false)
  self.player_nameBg.gameObject:SetActive(false)
end

local function SetHeadAndNameData(self, playerInfo)
  self:SetName(playerInfo)
  self.player_head:SetData(playerInfo.uid, playerInfo.headPic or playerInfo.pic, playerInfo.headPicVer or playerInfo.picVer)
  local headFramePath = DataCenter.DecorationDataManager:GetHeadFrame(playerInfo.headSkinId, playerInfo.headSkinET)
  headFramePath = headFramePath or playerInfo.HeadBg or DefaultHeadFramePath
  self.player_headFrame:LoadSprite(headFramePath)
  self.player_name.color32 = WorldBlueColor32
  self.player_name.gameObject:SetActive(true)
  self.player_nameBg.gameObject:SetActive(true)
end

local function SetHeadAndFrameLocal(self, playerInfo)
  self.player_headSp:LoadSprite(string.format("Assets/Main/Sprites/UI/UIHeadIcon/%s.png", playerInfo.headPic))
end

WorldPlayerHead.OnCreate = OnCreate
WorldPlayerHead.OnDestroy = OnDestroy
WorldPlayerHead.ComponentDefine = ComponentDefine
WorldPlayerHead.ComponentDestroy = ComponentDestroy
WorldPlayerHead.SetName = SetName
WorldPlayerHead.SetPlayerHeadVisible = SetPlayerHeadVisible
WorldPlayerHead.SetData = SetData
WorldPlayerHead.SetHeadData = SetHeadData
WorldPlayerHead.SetHeadAndNameData = SetHeadAndNameData
WorldPlayerHead.SetHeadAndFrameLocal = SetHeadAndFrameLocal
return WorldPlayerHead
