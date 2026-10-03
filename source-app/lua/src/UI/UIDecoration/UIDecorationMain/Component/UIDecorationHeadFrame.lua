local UIDecorationHeadFrame = BaseClass("UIDecorationHeadFrame", UIBaseContainer)
local base = UIBaseContainer
local head_path = "UIPlayerHead/HeadIcon"
local frame_path = "UIPlayerHead/Foreground"

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

local function ComponentDefine(self)
  self.player_head = self:AddComponent(UIPlayerHead, head_path)
  self.frame = self:AddComponent(UIImage, frame_path)
end

local function ComponentDestroy(self)
end

local function DataDefine(self)
end

local function DataDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function ReInit(self, data)
  self.data = data
  self:RefreshView()
end

local function RefreshView(self)
  local userPic = LuaEntry.Player:GetPic() or ""
  local userPicVer = LuaEntry.Player.picVer or 0
  self:SetHead(LuaEntry.Player:GetUid(), userPic, userPicVer)
  self:SetFrame(self.data.frame)
end

local function SetFrame(self, frame)
  if self.frame then
    if not string.IsNullOrEmpty(frame) then
      self.frame:LoadSpriteAuto(frame)
    else
      self.frame:LoadSpriteAuto(DefaultHeadFramePath)
    end
  end
end

local function SetHead(self, uid, userPic, userPicVer)
  self.player_head:SetData(uid, userPic, userPicVer)
end

local function UseSystemHead(self)
  self.player_head:UseSystemHead()
end

UIDecorationHeadFrame.OnCreate = OnCreate
UIDecorationHeadFrame.OnDestroy = OnDestroy
UIDecorationHeadFrame.OnEnable = OnEnable
UIDecorationHeadFrame.OnDisable = OnDisable
UIDecorationHeadFrame.ComponentDefine = ComponentDefine
UIDecorationHeadFrame.ComponentDestroy = ComponentDestroy
UIDecorationHeadFrame.DataDefine = DataDefine
UIDecorationHeadFrame.DataDestroy = DataDestroy
UIDecorationHeadFrame.ReInit = ReInit
UIDecorationHeadFrame.RefreshView = RefreshView
UIDecorationHeadFrame.SetFrame = SetFrame
UIDecorationHeadFrame.SetHead = SetHead
UIDecorationHeadFrame.UseSystemHead = UseSystemHead
return UIDecorationHeadFrame
