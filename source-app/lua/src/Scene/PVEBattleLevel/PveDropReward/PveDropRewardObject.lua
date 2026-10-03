local PveDropRewardObject = BaseClass("PveDropRewardObject")
local Resource = CS.GameEntry.Resource
local PveDropRewardBubble = require("Scene.PVEBattleLevel.PveDropReward.PveDropRewardBubble")

function PveDropRewardObject:__init()
  self:DataDefine()
  self:OnCreate()
end

function PveDropRewardObject:Destroy()
  self:ComponentDestroy()
  self:DataDestroy()
  self.transform = nil
  self.gameObject = nil
end

function PveDropRewardObject:OnCreate()
  if self.request == nil then
    self.request = Resource:InstantiateAsync(UIAssets.PveDropRewardBox)
    self.request:completed("+", function()
      if self.request.isError then
        return
      end
      self.gameObject = self.request.gameObject
      self.transform = self.gameObject.transform
      self.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
      self:ReInit(self.param)
    end)
  end
end

function PveDropRewardObject:ComponentDefine()
end

function PveDropRewardObject:ComponentDestroy()
end

function PveDropRewardObject:DataDefine()
  self.param = {}
  self.request = nil
end

function PveDropRewardObject:DataDestroy()
  self.param = {}
  if self.request ~= nil then
    self.request:Destroy()
    self.request = nil
  end
  if self.bubble ~= nil then
    self.bubble:Destroy()
    self.bubble = nil
  end
end

function PveDropRewardObject:ReInit(param)
  self.param = param
  self:ShowPanel()
end

function PveDropRewardObject:GetPosition()
  return self.param.position
end

function PveDropRewardObject:ShowPanel()
  if self.gameObject ~= nil then
    self.transform.position = self.param.position
    self.gameObject:SetActive(self.param.isShow)
  end
  local param = {}
  param.info = self.param.info
  param.visible = self.param.isShow
  param.position = self.param.position
  param.rotation = DataCenter.BattleLevel:GetCameraRotation()
  param.levelId = DataCenter.BattleLevel.levelId
  if self.bubble == nil then
    self.bubble = PveDropRewardBubble.New()
  end
  self.bubble:ReInit(param)
end

function PveDropRewardObject:SetVisible(isShow)
  self.param.isShow = isShow
  if self.gameObject ~= nil then
    self.gameObject:SetActive(self.param.isShow)
  end
end

function PveDropRewardObject:OnPlayerMoveSignal(pos)
  if self.bubble ~= nil then
    self.bubble:OnPlayerMoveSignal(pos)
  end
end

function PveDropRewardObject:RefreshCameraRotation(rotation)
  if self.bubble ~= nil then
    self.bubble:RefreshCameraRotation(rotation)
  end
end

function PveDropRewardObject:DoSelectBubble()
  if self.bubble ~= nil and not self.bubble.isOnInteract then
    self.bubble:OnTouchBubbleClick()
  end
end

function PveDropRewardObject:ShowBubble(show)
  if self.bubble ~= nil then
    self.bubble:Show(show)
  end
end

return PveDropRewardObject
