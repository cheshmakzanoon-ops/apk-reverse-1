local PushCampDestroySuccessMessage = BaseClass("PushCampDestroySuccessMessage", SFSBaseMessage)
local base = SFSBaseMessage

function PushCampDestroySuccessMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local cityId = toInt(t.cityId)
  if 0 < cityId then
    DataCenter.SeasonCampDestroyManager:OnDestroySuccess(t)
    if SceneUtils.GetIsInWorld() then
      local theWorld = CS.SceneManager.World
      if theWorld ~= nil then
        theWorld:SetFirstViewRequestFlag(true)
        theWorld:UpdateViewRequest(true)
      end
    end
  end
end

return PushCampDestroySuccessMessage
