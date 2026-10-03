local PlatformBubble = BaseClass("PlatformBubble")
local Localization = CS.GameEntry.Localization

function PlatformBubble:__init(transform)
  self.transform = transform
  self:ComponentDefine()
  self:Refresh()
end

function PlatformBubble:__delete()
  self:Destroy()
end

function PlatformBubble:Destroy()
  self:ComponentDestroy()
end

function PlatformBubble:ComponentDefine()
  self.bg = self.transform:Find("Go").gameObject
  self.state = self.transform:Find("Go/state"):GetComponent(typeof(CS.TextMeshProEx))
  self.anim = self.transform:Find("Go"):GetComponent(typeof(CS.SimpleAnimation))
  self.sprite = self.transform:Find("Go"):GetComponent(typeof(CS.SpriteMeshRenderer))
  self.time = self.transform:Find("Go/time"):GetComponent(typeof(CS.TextMeshProEx))
  self.count = self.transform:Find("Go/count"):GetComponent(typeof(CS.TextMeshProEx))
  self.trigger = self.transform:Find("Go/Trigger"):GetComponent(typeof(CS.TouchObjectEventTrigger))
  
  function self.trigger.onPointerClick()
    self:OnClick()
  end
end

function PlatformBubble:ComponentDestroy()
  if not IsNull(self.trigger) then
    self.trigger.onPointerClick = nil
    self.trigger = nil
  end
  self.bg = nil
  self.state = nil
  self.time = nil
  self.transform = nil
end

function PlatformBubble:Refresh()
  local closed, closeEndTime = DataCenter.LWAllyStationDataManager:IsTrainClosed()
  if closed then
    self.bg:SetActive(false)
    return
  end
  local data = DataCenter.LWAllyStationDataManager:GetPlatform(1)
  if not data then
    self.bg:SetActive(false)
    return
  end
  if not LuaEntry.Player:IsInAlliance() then
    self.bg:SetActive(false)
    return
  end
  if not RailwayUtil.CheckCanBuyTrain() then
    self.bg:SetActive(false)
    return
  end
  if data.state == TrainPlatformState.NoTrain then
    self.bg:SetActive(true)
    local cur, max = DataCenter.LWAllyStationDataManager:BuyCount()
    if cur < max then
      self.anim:Play("Default")
      local isNew = DataCenter.LWAllyStationDataManager:IsNewTrainFunctionOn()
      if isNew then
        self.sprite:LoadSprite("Assets/Main/Sprites/UI/UIBuildBubble/zxl_huoche_tips.png")
      else
        self.sprite:LoadSprite("Assets/Main/Sprites/UI/UIBuildBubble/lrb_huoche_qipao_yellow.png")
      end
      self.state.text = ""
      self.time.text = ""
      self.count.text = cur .. "/" .. max
    else
      self.anim:Stop()
      self.sprite:LoadSprite("Assets/Main/Sprites/UI/UIBuildBubble/lrb_huoche_qipao_white.png")
      self.state.text = Localization:GetString(458630)
      self.time.text = cur .. "/" .. max
      self.count.text = ""
    end
  else
    self.bg:SetActive(false)
  end
end

function PlatformBubble:OnClick()
  RailwayUtil.BuyAllyTrain()
end

return PlatformBubble
