local ZombieRushActSetPlanInfoMessage = BaseClass("ZombieRushActSetPlanInfoMessage", SFSBaseMessage)
local base = SFSBaseMessage

function ZombieRushActSetPlanInfoMessage:OnCreate(Id, longTime, planLevel)
  base.OnCreate(self)
  self.sfsObj:PutInt("id", Id)
  self.sfsObj:PutLong("planTimeStamp", longTime)
  self.sfsObj:PutInt("planLevel", planLevel)
end

function ZombieRushActSetPlanInfoMessage:HandleMessage(message)
  base.HandleMessage(self, message)
  local errCode = message.errorCode
  if errCode ~= nil then
    if errCode == "zombierush_err_seasonWrong" then
      local errorMsg = message.errorMsg
      if errorMsg ~= nil and errorMsg ~= "" then
        local arr = string.split(errorMsg, "|")
        if arr and #arr == 2 then
          UIUtil.ShowTips(CS.GameEntry.Localization:GetString(errCode, arr[1], arr[2]))
          return
        end
      end
    end
    UIUtil.ShowTipsId(errCode)
  else
    UIUtil.ShowTipsId("zombierush_plan_tips_01")
  end
end

return ZombieRushActSetPlanInfoMessage
