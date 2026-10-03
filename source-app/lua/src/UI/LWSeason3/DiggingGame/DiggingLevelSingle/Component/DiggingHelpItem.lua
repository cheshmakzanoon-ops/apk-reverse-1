local base = UIBaseContainer
local DiggingHelpItem = BaseClass("DiggingHelpItem", base)
local Localization = CS.GameEntry.Localization
local Head_path = "bg/Head/UIPlayerHead"
local Des_path = "bg/Txt_Des"
local Title_path = "bg/Txt_Title"
local Bg_path = "bg"

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
  self.Head = self:AddComponent(UIBaseContainer, Head_path)
  self.Des = self:AddComponent(UIText, Des_path)
  self.Title = self:AddComponent(UIText, Title_path)
  self.Bg = self:AddComponent(UIBaseContainer, Bg_path)
  self.canvas = self:AddComponent(UICanvasGroup, Bg_path)
  self.PlayerHead = self.Head:AddComponent(UICommonHead, "")
end

local function ComponentDestroy(self)
  self.Head = nil
  self.Des = nil
  self.Title = nil
  self.Bg = nil
  self.canvas = nil
end

local function DataDefine(self)
end

local function DataDestroy(self)
end

function DiggingHelpItem:ReInit(data, text, lifeTime, isUseDataDirectly)
  if not data then
    return
  end
  local playerInfo
  if isUseDataDirectly then
    playerInfo = data
  else
    playerInfo = data.playerInfo
    if not playerInfo then
      return
    end
  end
  self.lifeTime = lifeTime
  self.Des:SetText(Localization:GetString(text))
  self.Title:SetText(playerInfo.name)
  if isUseDataDirectly then
    self.PlayerHead:SetHeadAndFrame(playerInfo.uid, playerInfo.headPic, playerInfo.headPicVer, false, playerInfo.headSkinId)
  else
    self.PlayerHead:SetHeadAndFrame(playerInfo.uid, playerInfo.pic, playerInfo.picVer, false, playerInfo.headSkinId)
  end
end

function DiggingHelpItem:ShowFadeInEffect()
  self.canvas:SetAlpha(0)
  self:SetLocalScaleXYZ(0.8, 0.8, 1)
  self.Bg:SetLocalPositionXYZ(360, 0, 0)
  local sequence = DOTween.Sequence()
  sequence:Append(self.transform:DOScale(Vector3.New(1.02, 1.02, 1), 0.133))
  sequence:Append(self.transform:DOScale(Vector3.New(1, 1, 1), 0.333))
  sequence:Join(self.canvas.unity_canvas_group:DOFade(1, 0.14))
  sequence:Join(self.Bg.transform:DOLocalMoveX(0, 0.3))
  if self.lifeTime and ComponentIsValid(self.canvas) and ComponentIsValid(self.Bg) then
    sequence:AppendInterval(self.lifeTime)
    
    function sequence.onComplete()
      if self.canvas ~= nil and self.Bg ~= nil then
        local sequenceHide = DOTween.Sequence()
        sequenceHide:Join(self.canvas.unity_canvas_group:DOFade(0, 0.25))
        sequenceHide:Join(self.Bg.transform:DOLocalMoveY(200, 0.2))
        
        function sequenceHide.onComplete()
          self.gameObject:GameObjectRecycle()
        end
      end
    end
  end
end

DiggingHelpItem.OnCreate = OnCreate
DiggingHelpItem.OnDestroy = OnDestroy
DiggingHelpItem.OnEnable = OnEnable
DiggingHelpItem.OnDisable = OnDisable
DiggingHelpItem.ComponentDefine = ComponentDefine
DiggingHelpItem.ComponentDestroy = ComponentDestroy
DiggingHelpItem.DataDefine = DataDefine
DiggingHelpItem.DataDestroy = DataDestroy
return DiggingHelpItem
