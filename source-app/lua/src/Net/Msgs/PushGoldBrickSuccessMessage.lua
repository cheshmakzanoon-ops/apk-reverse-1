local PushGoldBrickSuccessMessage = BaseClass("PushGoldBrickSuccessMessage", SFSBaseMessage)
local Localization = CS.GameEntry.Localization
local base = SFSBaseMessage

function PushGoldBrickSuccessMessage:OnCreate(param)
  base.OnCreate(self)
end

function PushGoldBrickSuccessMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  if not Config.IsPC() then
    return
  end
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    local content = Localization:GetString("E100076") .. [[

<sprite="item_icon_goldbrick" index=0>]]
    local amount = t.count + t.freeCount
    content = content .. amount
    UIUtil.ShowMessage(content, 1, "110006", "", function()
    end)
  end
end

return PushGoldBrickSuccessMessage
