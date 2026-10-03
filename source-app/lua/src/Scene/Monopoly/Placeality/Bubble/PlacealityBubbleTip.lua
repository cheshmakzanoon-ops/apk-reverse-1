local PlacealityBubbleTip = BaseClass("PlacealityBubbleTip")
local ResourceManager = CS.GameEntry.Resource
local Localization = CS.GameEntry.Localization
local bg_path = "Go/Bg"
local trigger_path = "Go/Trigger"
local icon_path = "Go/Bg/Icon"
local icon_go_path = "Go"
local time_path = "Go/Bg/text"
local PositionDelta2 = Vector3.New(-1, 0, -1)
local PositionDelta4 = Vector3.New(0.3, 0, -0.8)
local PositionDelta7 = Vector3.New(-0.5, 0, -1)
local AnimName = {
  Enter = "EnterBubble",
  Hide = "HideBubble",
  Normal = "NormalBubble",
  ResourceItem = "goodsBubble",
  Default = "Default"
}

function PlacealityBubbleTip:OnCreate(go)
  if go ~= nil then
    self.request = go
    self.gameObject = go.gameObject
    self.transform = go.gameObject.transform
  end
  self:DataDefine()
end

function PlacealityBubbleTip:OnDestroy()
  self:ComponentDestroy()
  self:DataDestroy()
end

function PlacealityBubbleTip:ComponentDefine()
  if not self.defend then
    self.bg_color = self.transform:Find(bg_path).gameObject
    self.time_text = self.transform:Find(time_path):GetComponent(typeof(CS.TextMeshProEx))
    self.icon_go = self.transform:Find(icon_go_path):GetComponent(typeof(CS.SimpleAnimation))
    self.icon_sprite = self.transform:Find(icon_path):GetComponent(typeof(CS.SpriteMeshRenderer))
    self.defend = true
  end
end

function PlacealityBubbleTip:ComponentDestroy()
  self.tweenAnimations = nil
  if not IsNull(self.bg) then
    self.bg.onPointerClick = nil
    self.bg.onPointerDoubleClick = nil
    self.bg.onPointerDown = nil
    self.bg.onPointerUp = nil
    self.bg = nil
  end
  self.icon_sprite = nil
  self.gameObject = nil
  self.transform = nil
  self.model_go = nil
  self.bg_color = nil
  self.icon_go = nil
  self.obj = nil
end

function PlacealityBubbleTip:DataDefine()
  self.param = nil
  self.defend = nil
  self.animationAlreadyShow = false
  self.isShow = false
  self.cdTimer = nil
  self.oldParam = nil
  self.tween = nil
  
  function self.fix_bug_timer_action(temp)
    self:FixBugTimeCallBack()
  end
  
  function self.click_cd_timer_callback(temp)
    self:ClickCdTimerCallBack()
  end
  
  self.heightDeltaPos = Vector3.New(0, 0, 0)
  self.state = nil
end

function PlacealityBubbleTip:DataDestroy()
  self.isShow = nil
  self.param = nil
  self.defend = nil
  self.animationAlreadyShow = nil
  self.cdTimer = nil
  self.oldParam = nil
  self.fix_bug_timer_action = nil
  self.tween = nil
  self.state = nil
  self.buildData = nil
  self.queueData = nil
end

function PlacealityBubbleTip:ReInit(param)
  self.oldParam = self.param
  self.param = param
  self.buildData = nil
  self:ComponentDefine()
  self:ShowPanel()
  self:Show()
end

function PlacealityBubbleTip:ShowPanel()
  self.state = nil
  if self.time_text ~= nil then
    self.time_text.text = ""
  end
  if (self.oldParam == nil or self.param.bgScale ~= self.oldParam.bgScale) and self.param.bgScale ~= nil then
    local v = self.param.bgScale
    self.bg_color.transform:Set_localScale(v.x, v.y, v.z)
  end
  if (self.oldParam == nil or self.param.iconScale ~= self.oldParam.iconScale) and self.param.iconScale ~= nil and self.icon_sprite ~= nil then
    local v = self.param.iconScale
    self.icon_sprite.transform:Set_localScale(v.x, v.y, v.z)
  end
  if self.oldParam == nil or self.param.buildId ~= self.oldParam.buildId or self.param.buildLevel ~= self.oldParam.buildLevel then
    if self.param.buildId == -1000 then
      self.time_text.text = Localization:GetString("city_unlock_tips_1")
    else
      local buildingTemplate = DataCenter.BuildTemplateManager:GetBuildingDesTemplate(self.param.buildId)
      if buildingTemplate ~= nil then
        self.time_text.text = Localization:GetString(800371, Localization:GetString(buildingTemplate.name), self.param.buildLevel)
      end
    end
  end
  if (self.oldParam == nil or self.param.pos ~= self.oldParam.pos or self.oldParam.modelHeight ~= self.param.modelHeight) and self.param.pos ~= nil then
    self:SetPosition(self.param.pos)
  end
end

function PlacealityBubbleTip:UpdatePosition(index)
  self.heightDeltaPos.y = self.param.modelHeight
  if self.param.buildBubbleType == BuildBubbleType.ResidentOrder then
    self:SetPosition(SceneUtils.TileIndexToWorld(index) + PositionDelta2 + self.heightDeltaPos)
  elseif self.param.buildBubbleType == BuildBubbleType.PastureProduct then
    self:SetPosition(SceneUtils.TileIndexToWorld(index) + PositionDelta4 + self.heightDeltaPos)
  elseif self.param.buildBubbleType == BuildBubbleType.GetFoodProduct then
    self:SetPosition(SceneUtils.TileIndexToWorld(index) + PositionDelta7 + self.heightDeltaPos)
  elseif self.param.buildBubbleType == BuildBubbleType.FireExtinguisher then
    self:SetPosition(SceneUtils.TileIndexToWorld(index) + Vector3.New(-2, 6, 0))
  elseif self.param.buildBubbleType == BuildBubbleType.ParkingLotUnlock then
    self:SetPosition(BuildingUtils.GetBuildModelCenterVec(index, self.param.tileX, self.param.tileY) + Vector3.New(-2, -3, 0))
  elseif self.param.buildBubbleType == BuildBubbleType.TrainCanRob or self.param.buildBubbleType == BuildBubbleType.TrainFirstReward then
    self:SetPosition(BuildingUtils.GetBuildModelCenterVec(index, self.param.tileX, self.param.tileY) + Vector3.New(-15, 3.4, -20.4))
  else
    self:SetPosition(BuildingUtils.GetBuildModelCenterVec(index, self.param.tileX, self.param.tileY) + self.heightDeltaPos)
  end
end

function PlacealityBubbleTip:SetPosition(value)
  self.transform:Set_position(value.x, value.y, value.z)
end

function PlacealityBubbleTip:OnPointerDown()
  if self.tween ~= nil then
    self.tween:Kill()
  end
  self.tween = self.transform:DOScale(ResetScale * 0.8, 0.1)
end

function PlacealityBubbleTip:OnPointerUp()
  if self.tween ~= nil then
    self.tween:Kill()
  end
  self.tween = self.transform:DOScale(ResetScale, 0.1)
end

function PlacealityBubbleTip:GetBubblePosition()
  if self.icon_sprite ~= nil then
    return self.icon_sprite.transform.position
  elseif self.bg ~= nil then
    return self.bg.transform.position
  end
  return ResetPosition
end

function PlacealityBubbleTip:GetBubbleObj(isIgnore)
  if isIgnore then
    return self.obj
  end
  if self.bg ~= nil then
    return self.bg
  elseif self.icon_sprite ~= nil then
    return self.icon_sprite
  end
  return self.icon_go
end

function PlacealityBubbleTip:Show()
  if self.icon_go ~= nil then
    if self.isShow == true then
      if self.param.buildBubbleType == BuildBubbleType.GetFoodProduct then
        self.icon_go:Play(AnimName.ResourceItem)
      elseif self.param.dontShake then
        self.icon_go:Stop()
      else
        self.icon_go:Play(AnimName.Normal)
      end
    else
      self.icon_go:Play(AnimName.Enter)
      if self.param.buildBubbleType == BuildBubbleType.GetFoodProduct then
        self.icon_go:PlayQueued(AnimName.ResourceItem)
      elseif self.param.dontShake then
        self.icon_go:Stop()
      else
        self.icon_go:PlayQueued(AnimName.Normal)
      end
      self.isShow = true
    end
  end
end

function PlacealityBubbleTip:Hide()
  if self.isShow == false then
    return
  end
  if self.icon_go ~= nil then
    self.icon_go:Play(AnimName.Hide)
  end
  self.isShow = false
end

function PlacealityBubbleTip:ClearAllEffectAndTimer()
  if self.progressTimer then
    self.progressTimer:Stop()
    self.progressTimer = nil
  end
end

return PlacealityBubbleTip
