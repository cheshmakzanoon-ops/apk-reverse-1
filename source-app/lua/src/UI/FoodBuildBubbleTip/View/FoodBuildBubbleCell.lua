local FoodBuildBubbleCell = BaseClass("FoodBuildBubbleCell")
local bg_path = "Bg"
local icon_path = "Bg/Icon"
local icon_go_path = ""
local time_txt_path = "Bg/Txt"
local PositionDeltaHeight = Vector3.New(0, 1, 0)
local AnimName = {
  Enter = "idle",
  Hide = "hide",
  Normal = "idle"
}

local function OnCreate(self, go)
  if go ~= nil then
    self.request = go
    self.gameObject = go.gameObject
    self.transform = go.gameObject.transform
  end
  self:DataDefine()
end

local function OnDestroy(self)
  self:ComponentDestroy()
  self:DataDestroy()
end

local function ComponentDefine(self)
  if not self.defend then
    self.icon_go = self.transform:Find(icon_go_path):GetComponent(typeof(CS.SimpleAnimation))
    self.icon_sprite = self.transform:Find(icon_path):GetComponent(typeof(CS.UnityEngine.SpriteRenderer))
    self.bg_color = self.transform:Find(bg_path):GetComponent(typeof(CS.UnityEngine.SpriteRenderer))
    self.bg = self.transform:Find(bg_path):GetComponent(typeof(CS.UIEventTrigger))
    
    function self.bg.onPointerClick()
      self:OnClick()
    end
    
    self.time_txt = self.transform:Find(time_txt_path):GetComponent(typeof(CS.SuperTextMesh))
    self.defend = true
    self.endTime = nil
  end
end

local function ComponentDestroy(self)
  self.bg.onPointerClick = nil
  self.bg = nil
  self.icon_sprite = nil
  self.gameObject = nil
  self.transform = nil
  self.model_go = nil
  self.bg_color = nil
  self.icon_go = nil
  self.time_txt = nil
end

local function DataDefine(self)
  self.param = nil
  self.curPosition = nil
  self.index = nil
  self.defend = nil
  self.showTimer = nil
  self.endTime = nil
  self.lastTime = nil
end

local function DataDestroy(self)
  self.param = nil
  self.curPosition = nil
  self.index = nil
  self.defend = nil
  if self.showTimer ~= nil then
    self.showTimer:Stop()
    self.showTimer = nil
  end
  self.endTime = nil
  self.lastTime = nil
end

local function ReInit(self, param)
  self.param = param
  self:ComponentDefine()
  self:ShowPanel()
end

local function ShowPanel(self)
  if self.param.iconName ~= nil then
    self.icon_sprite.gameObject:SetActive(true)
    self.icon_sprite:LoadSprite(self.param.iconName)
  else
    self.icon_sprite.gameObject:SetActive(false)
  end
  if self.param.iconScale ~= nil and self.icon_sprite ~= nil then
    self.icon_sprite.transform.localScale = self.param.iconScale
  end
  if self.icon_go ~= nil then
    self.icon_go.transform.localPosition = Vector3.New(0, self.param.modelHeight, 0)
    self.icon_go:Play(AnimName.Enter)
    self.icon_go:PlayQueued(AnimName.Normal)
  end
  self.time_txt.text = "X" .. self.param.count
  self.transform.localPosition = self.param.pos
  self:RefreshState()
end

local function UpdatePosition(self, index)
  if self.index ~= index then
    self.index = index
    local worldPos = BuildingUtils.GetBuildModelCenterVec(index, self.param.tileX, self.param.tileY) + PositionDeltaHeight
    self:SetPosition(worldPos)
  end
end

local function SetPosition(self, value)
  self.transform.position = value
end

local function OnClick(self)
  if not CS.SceneManager.World:CanUseInput() then
    return
  end
  if self.param.callBack ~= nil then
    self.param.callBack(self.param)
  end
end

local function RefreshState(self)
  if self.time ~= nil then
    self.time.gameObject:SetActive(false)
  end
end

local function GetBubblePosition(self)
  if self.icon_sprite ~= nil then
    return self.icon_sprite.transform.position
  elseif self.bg ~= nil then
    return self.bg.transform.position
  end
  return ResetPosition
end

FoodBuildBubbleCell.OnCreate = OnCreate
FoodBuildBubbleCell.OnDestroy = OnDestroy
FoodBuildBubbleCell.ComponentDefine = ComponentDefine
FoodBuildBubbleCell.ComponentDestroy = ComponentDestroy
FoodBuildBubbleCell.DataDefine = DataDefine
FoodBuildBubbleCell.DataDestroy = DataDestroy
FoodBuildBubbleCell.ReInit = ReInit
FoodBuildBubbleCell.ShowPanel = ShowPanel
FoodBuildBubbleCell.UpdatePosition = UpdatePosition
FoodBuildBubbleCell.SetPosition = SetPosition
FoodBuildBubbleCell.OnClick = OnClick
FoodBuildBubbleCell.RefreshState = RefreshState
FoodBuildBubbleCell.GetBubblePosition = GetBubblePosition
return FoodBuildBubbleCell
