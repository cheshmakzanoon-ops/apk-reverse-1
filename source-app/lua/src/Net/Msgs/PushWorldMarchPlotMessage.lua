local PushWorldMarchPlotMessage = BaseClass("PushWorldMarchPlotMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self)
  base.OnCreate(self)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  if CS.SceneManager.World == nil then
    return
  end
  local uuid = t.uuid
  local plotId = t.plot
  if uuid ~= nil and plotId ~= nil then
    local troop = CS.SceneManager.World:GetTroop(uuid)
    if troop then
      local marchInfo = troop:GetMarchInfo()
      if marchInfo and marchInfo:IsWanderBoss() and plotId then
        local bubbleParams = {}
        bubbleParams.plotGroupId = plotId
        local trans = troop:GetTransform()
        if trans then
          bubbleParams.followTarget = trans
          bubbleParams.mode = "3DFollow"
          bubbleParams.anchor = Vector3.New(0, 3.7, 0)
        else
          local targetPos = troop:GetPosition()
          bubbleParams.anchor = Vector3.New(targetPos.x, targetPos.y + 3.7, targetPos.z)
          bubbleParams.mode = "3D"
        end
        EventManager:GetInstance():Broadcast(EventId.PlayPlotBubbleRandomly, bubbleParams)
      end
    end
  end
end

PushWorldMarchPlotMessage.OnCreate = OnCreate
PushWorldMarchPlotMessage.HandleMessage = HandleMessage
return PushWorldMarchPlotMessage
