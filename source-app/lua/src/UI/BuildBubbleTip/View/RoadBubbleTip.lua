local RoadBubbleTip = BaseClass("RoadBubbleTip")
local Resource = CS.GameEntry.Resource
local bg_path = "Go/Bg"
local trigger_path = "Go/Trigger"
local icon_path = "Go/Bg/Icon"
local icon_go_path = "Go"
local PositionDelta4 = Vector3.New(0.3, 0, -0.8)
local AnimName = {
  Enter = "EnterBubble",
  Hide = "HideBubble",
  Normal = "NormalBubble"
}

function RoadBubbleTip:__init(param)
  self:DataDestroy()
  self.param = param
  self:Create()
end

function RoadBubbleTip:DataDefine()
  self.param = nil
  self.isDefined = false
  self.isClickCd = nil
end

function RoadBubbleTip:DataDestroy()
  if self.req ~= nil then
    self.req:Destroy()
    self.req = nil
  end
  self.param = nil
  self.gameObject = nil
  self.transform = nil
  self.isDefined = false
  self.isClickCd = nil
end

function RoadBubbleTip:ComponentDefine()
  if not self.isDefined then
    if self.param.model == UIAssets.BuildStateIcon then
      self.icon_go = self.transform:Find(icon_go_path):GetComponent(typeof(CS.SimpleAnimation))
      self.icon_sprite = self.transform:Find(icon_path):GetComponent(typeof(CS.SpriteMeshRenderer))
      self.bg_color = self.transform:Find(bg_path):GetComponent(typeof(CS.SpriteMeshRenderer))
      self.bg = self.transform:Find(trigger_path):GetComponent(typeof(CS.TouchObjectEventTrigger))
      self.bg_color:Set_color_a(1.0)
      self.icon_sprite:Set_color_a(1.0)
      
      function self.bg.onPointerClick()
        self:OnClick()
      end
    end
    self.isDefined = true
  end
end

function RoadBubbleTip:ComponentDestroy()
  if self.isDefined then
    self.bg.onPointerClick = nil
  end
  self.gameObject = nil
  self.transform = nil
end

function RoadBubbleTip:Destroy()
  self:ComponentDestroy()
  self:DataDestroy()
end

function RoadBubbleTip:Create()
  if self.req == nil then
    self.req = Resource:InstantiateAsync(self.param.model)
    self.req:completed("+", function()
      self.gameObject = self.req.gameObject
      self.transform = self.req.gameObject.transform
      self:ComponentDefine()
      self:ShowBubble()
    end)
  end
end

function RoadBubbleTip:ReInit(param)
  if self.param.model ~= param.model then
    self:Destroy()
    self:OnCreate()
  else
    self.param = param
    self:ShowBubble()
  end
end

function RoadBubbleTip:ShowBubble()
  self.state = nil
  if self.param.bgName ~= nil then
    self.bg_color.gameObject:SetActive(true)
    self.bg_color:LoadSprite(self.param.bgName)
  else
    self.bg_color.gameObject:SetActive(false)
  end
  if self.param.iconName ~= nil then
    self.icon_sprite.gameObject:SetActive(true)
    self.icon_sprite:LoadSprite(self.param.iconName)
  else
    self.icon_sprite.gameObject:SetActive(false)
  end
  if self.param.bgScale ~= nil and self.bg_color ~= nil then
    local v = self.param.bgScale
    self.bg_color.transform:Set_localScale(v.x, v.y, v.z)
  end
  if self.param.iconScale ~= nil and self.icon_sprite ~= nil then
    local v = self.param.iconScale
    self.icon_sprite.transform:Set_localScale(v.x, v.y, v.z)
  end
  if self.param.pointId ~= nil then
    self:UpdatePosition(self.param.pointId)
  end
  self:SetVisible(self.param.visible, true)
end

function RoadBubbleTip:UpdatePosition(index)
  if self.index ~= index then
    self.index = index
    local modelVec = Vector3.New(0, self.param.modelHeight, 0)
    self:SetPosition(BuildingUtils.GetBuildModelCenterVec(index, self.param.tileX, self.param.tileY) + modelVec)
  end
end

function RoadBubbleTip:SetPosition(value)
  self.transform:Set_position(value.x, value.y, value.z)
end

function RoadBubbleTip:OnClick()
  if not CS.SceneManager.World:CanUseInput() then
    return
  end
  if self.isClickCd then
    return
  end
  if self.param.callBack ~= nil then
    self.param:callBack(self.param)
    self.isClickCd = true
    self.cdTimer = TimerManager:GetInstance():DelayInvoke(function()
      self.isClickCd = false
      self.cdTimer = nil
    end, 0.5)
  end
end

function RoadBubbleTip:SetVisible(visible, isForce)
  if isForce or self.param.visible ~= visible then
    self.param.visible = visible
    if self.gameObject ~= nil then
      self.gameObject:SetActive(visible)
    end
    if visible then
      self:Show()
    else
      self:Hide()
    end
  end
end

function RoadBubbleTip:Show()
  if self.icon_go ~= nil then
    if self.isShow == true then
      self.icon_go:Play(AnimName.Normal)
    else
      self.icon_go:Play(AnimName.Enter)
      self.icon_go:PlayQueued(AnimName.Normal)
      self.isShow = true
    end
  end
end

function RoadBubbleTip:Hide()
  self.isShow = false
end

return RoadBubbleTip
