local UIPlayerHead = BaseClass("UIPlayerHead", UIBaseComponent)
local base = UIBaseComponent

local function OnCreate(self)
  base.OnCreate(self)
  self.unityHead = self.gameObject:GetComponent(typeof(CS.UIPlayerHead))
end

local function OnDestroy(self)
  if self.unityHead ~= nil then
    self.unityHead:SetCustomLoadCallback(nil)
  end
  self.unityHead = nil
  base.OnDestroy(self)
end

function UIPlayerHead:ParseHeadInfo(cfg)
  if cfg then
    self:SetData(cfg.uid or cfg.ownerUid or cfg.Uid or cfg.tUid, cfg.pic or cfg.headPic or cfg.tPic or "", cfg.picVer or cfg.headPicVer or cfg.picver or cfg.tPicVer or 0)
  end
end

local function SetData(self, uid, pic, picVer, useBig)
  if useBig == nil then
    useBig = false
  end
  if not string.IsNullOrEmpty(uid) then
    if not (pic or picVer) or picVer == 0 and pic == "" then
      self.unityHead:UseSystemHead()
    else
      self.unityHead:SetData(uid, pic, tonumber(picVer), useBig)
    end
  end
end

local function SetBigData(self, uid, pic, picVer, useBig)
  if useBig == nil then
    useBig = false
  end
  if not string.IsNullOrEmpty(uid) then
    if not pic and not picVer then
      self.unityHead:UseSystemHead()
    else
      self.unityHead:SetBigData(uid, pic, tonumber(picVer), useBig)
    end
  end
end

local function UseSystemHead(self)
  self.unityHead:UseSystemHead()
end

local function UseSpecifiedRes(self, imgPath)
  if imgPath then
    self.unityHead:UseSpecifiedRes(imgPath)
  end
end

local function SetCustomLoadCallback(self, callback)
  self.unityHead:SetCustomLoadCallback(callback)
end

local function ShowWerewolf(self)
  self.unityHead:UseSpecifiedRes(WerewolfHeadPic)
end

UIPlayerHead.OnCreate = OnCreate
UIPlayerHead.OnDestroy = OnDestroy
UIPlayerHead.SetData = SetData
UIPlayerHead.SetCustomLoadCallback = SetCustomLoadCallback
UIPlayerHead.SetBigData = SetBigData
UIPlayerHead.UseSystemHead = UseSystemHead
UIPlayerHead.UseSpecifiedRes = UseSpecifiedRes
UIPlayerHead.ShowWerewolf = ShowWerewolf
return UIPlayerHead
