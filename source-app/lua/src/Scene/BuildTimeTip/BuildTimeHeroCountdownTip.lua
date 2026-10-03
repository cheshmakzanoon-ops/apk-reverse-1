local BuildTimeHeroCountdownTip = BaseClass("BuildTimeHeroCountdownTip")
local pos_go_path = "Go"
local icon_path = "Go/Bg/Icon"
local txt_time_path = "Go/txtTime"
local trigger_path = "Go/Trigger"

function BuildTimeHeroCountdownTip:OnCreate(go)
  if go ~= nil then
    self.request = go
    self.gameObject = go.gameObject
    self.transform = go.gameObject.transform
  end
  self:ComponentDefine()
  self:DataDefine()
end

function BuildTimeHeroCountdownTip:OnDestroy()
  self:ComponentDestroy()
  self:DataDestroy()
end

function BuildTimeHeroCountdownTip:ComponentDefine()
  self.time_text = self.transform:Find(txt_time_path):GetComponent(typeof(CS.SuperTextMesh))
  self.icon_sprite = self.transform:Find(icon_path):GetComponent(typeof(CS.SpriteMeshRenderer))
  self.pos_go = self.transform:Find(pos_go_path)
  self.bg = self.transform:Find(trigger_path):GetComponent(typeof(CS.TouchObjectEventTrigger))
  
  function self.bg.onPointerClick()
    self:OnClick()
  end
end

function BuildTimeHeroCountdownTip:ComponentDestroy()
  self.time_text = nil
  self.icon_sprite = nil
  self.pos_go = nil
  if not IsNull(self.bg) then
    self.bg.onPointerClick = nil
    self.bg = nil
  end
end

function BuildTimeHeroCountdownTip:DataDefine()
  self.paramData = nil
  self.lastTime = 0
  self.sliderInterVal = 0
  self.curPosition = nil
  self.index = nil
  self.timeText = nil
  self.sliderSpriteSize = nil
  self.desText = nil
  self.costNum = 0
  self.precessSize = nil
  self.curSize = nil
  self.showIndex = 1
  self.showListType = {}
  self.waitChangeAlpha = 0
  self.iconName = nil
end

function BuildTimeHeroCountdownTip:DataDestroy()
  self.paramData = nil
  self.lastTime = nil
  self.sliderInterVal = nil
  self.sliderSize = nil
  self.curPosition = nil
  self.index = nil
  self.timeText = nil
  self.sliderSpriteSize = nil
  self.desText = nil
  self.request = nil
  self.precessSize = nil
  self.curSize = nil
  self.isShowTime = nil
  self.showIndex = nil
  self.showListType = nil
  self.waitChangeAlpha = nil
  self.iconName = nil
end

function BuildTimeHeroCountdownTip:ReInit(paramList)
  local param = paramList[1]
  self.paramData = param
  self:RefreshActive(true)
  self.lastTime = 0
  self.firstConfirm = false
  self.sendMessage = false
  self.time_text:SetColorAlpha(1)
  self.waitChangeAlpha = 0
  self:ShowPanel()
  if self.paramData.pos ~= nil then
    self:UpdatePosition(self.paramData.pos)
  end
  if self.paramData.heroId then
    local modelId = self.paramData.heroId
    local iconPath = HeroUtils.GetHeroIconPath(modelId)
    self:SetIconSprite(iconPath)
  end
end

function BuildTimeHeroCountdownTip:ShowPanel()
  self.iconName = nil
  if self.paramData.endTime ~= nil then
    local curTime = UITimeManager:GetInstance():GetServerTime()
    local changeTime = self.paramData.endTime - curTime
    local tempTimeSec = math.ceil(changeTime / 1000)
    if tempTimeSec ~= self.lastTime then
      self.lastTime = tempTimeSec
      if self.lastTime > 0 then
        self.hasRemainTime = true
        self:ShowText()
      end
      return
    end
  end
  if self.hasRemainTime and self.lastTime and self.lastTime <= 0 then
    self.hasRemainTime = nil
    local uuid = self.paramData.bUuid
    if uuid then
      EventManager:GetInstance():Broadcast(EventId.OnBuildHeroCountdownStateChange, uuid)
    end
  end
end

function BuildTimeHeroCountdownTip:UpdatePosition(index)
  if self.index ~= index then
    self.index = index
    local worldPos = BuildingUtils.GetBuildModelCenterVec(index, self.paramData.tileX, self.paramData.tileY) + Vector3.New(0, 3, 0)
    self.transform:Set_position(worldPos.x, worldPos.y, worldPos.z)
  end
end

function BuildTimeHeroCountdownTip:RefreshTime(value)
  if self.lastTime ~= value then
    self.lastTime = value
    self:ShowText()
  end
end

function BuildTimeHeroCountdownTip:CheckTime()
  self:ShowPanel()
end

function BuildTimeHeroCountdownTip:ShowText()
  local tempTimeValue = UITimeManager:GetInstance():MilliSecondToFmtString(self.lastTime * 1000)
  self.time_text.text = tempTimeValue
end

function BuildTimeHeroCountdownTip:SetIconSprite(iconName)
  if self.iconName ~= iconName then
    self.iconName = iconName
    UIUtil.LoadSpriteRenderAuto(self.icon_sprite, iconName)
  end
end

function BuildTimeHeroCountdownTip:RefreshActive(isActive)
  self.pos_go.gameObject:SetActive(isActive)
end

function BuildTimeHeroCountdownTip:OnClick()
  local uuid = self.paramData.bUuid
  if uuid then
    DataCenter.BuildHeroCountdownManager:TryFixHero(uuid)
  end
end

function BuildTimeHeroCountdownTip:CheckIfTimeTipExist(paramList)
  if paramList and 0 < #paramList then
    local tempParam = paramList[1]
    if self.paramData.model == tempParam.model then
      return true
    end
  end
  return false
end

return BuildTimeHeroCountdownTip
