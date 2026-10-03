local base = UIBaseContainer
local SuppliesShowItem = BaseClass("SuppliesShowItem", base)
local Icon_path = "bg/Icon"
local Title_path = "bg/Txt_Title"
local Des_path = "bg/Txt_Des"
local Bg_path = "bg"
local Btn_path = "bg"

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
  self.Icon = self:AddComponent(UIBaseContainer, Icon_path)
  self.Title = self:AddComponent(UIText, Title_path)
  self.Des = self:AddComponent(UIText, Des_path)
  self.Bg = self:AddComponent(UIBaseContainer, Bg_path)
  self.Btn = self:AddComponent(UIButton, Btn_path)
  self.canvas = self:AddComponent(UICanvasGroup, Bg_path)
  self.Btn:SetOnClick(function()
    local pos = SceneUtils.TileIndexToWorld(self.data.pointId, ForceChangeScene.World)
    GoToUtil.GotoWorldPos(pos, CS.SceneManager.World.InitZoom, nil, nil, self.serverId)
  end)
end

local function ComponentDestroy(self)
  self.Icon = nil
  self.Title = nil
  self.Des = nil
  self.Bg = nil
  self.Btn = nil
end

local function DataDefine(self)
end

local function DataDestroy(self)
end

function SuppliesShowItem:ReInit(index, data)
  self.data = data
  self.Title:SetLocalText("season_s4_power_worker_tips_6")
  self.worldPosition = SceneUtils.IndexToTilePos(tonumber(data.pointId), ForceChangeScene.World)
  local contentParam = string.split(data.contentId, "|")
  self.serverId = contentParam[2] and tonumber(contentParam[2]) or nil
  if self.serverId then
    self.Des:SetText(string.format("<u>#%s(X:%s,Y:%s)</u>", self.serverId, self.worldPosition.x, self.worldPosition.y))
  else
    self.Des:SetText(string.format("<u>(X:%s,Y:%s)</u>", self.worldPosition.x, self.worldPosition.y))
  end
end

function SuppliesShowItem:ShowFadeInEffect(lifeTime)
  self.canvas:SetAlpha(0)
  self:SetLocalScaleXYZ(0.8, 0.8, 1)
  self.Bg:SetLocalPositionXYZ(360, 0, 0)
  local sequence = DOTween.Sequence()
  sequence:Append(self.transform:DOScale(Vector3.New(1.02, 1.02, 1), 0.133))
  sequence:Append(self.transform:DOScale(Vector3.New(1, 1, 1), 0.333))
  sequence:Join(self.canvas.unity_canvas_group:DOFade(1, 0.14))
  sequence:Join(self.Bg.transform:DOLocalMoveX(0, 0.3))
  if lifeTime and ComponentIsValid(self.canvas) and ComponentIsValid(self.Bg) then
    sequence:AppendInterval(lifeTime)
    
    function sequence.onComplete()
      local sequenceHide = DOTween.Sequence()
      sequenceHide:Join(self.canvas.unity_canvas_group:DOFade(0, 0.25))
      sequenceHide:Join(self.Bg.transform:DOLocalMoveY(200, 0.2))
      
      function sequenceHide.onComplete()
        self:SetActive(false)
      end
    end
  end
end

SuppliesShowItem.OnCreate = OnCreate
SuppliesShowItem.OnDestroy = OnDestroy
SuppliesShowItem.OnEnable = OnEnable
SuppliesShowItem.OnDisable = OnDisable
SuppliesShowItem.ComponentDefine = ComponentDefine
SuppliesShowItem.ComponentDestroy = ComponentDestroy
SuppliesShowItem.DataDefine = DataDefine
SuppliesShowItem.DataDestroy = DataDestroy
return SuppliesShowItem
