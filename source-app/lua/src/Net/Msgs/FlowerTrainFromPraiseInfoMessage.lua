local FlowerTrainFromPraiseInfoMessage = BaseClass("FlowerTrainFromPraiseInfoMessage", SFSBaseMessage)
local base = SFSBaseMessage

function FlowerTrainFromPraiseInfoMessage:OnCreate(param)
  base.OnCreate(self)
end

function FlowerTrainFromPraiseInfoMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    local fromPraiseInfo = t.fromPraiseInfo
    if fromPraiseInfo and (fromPraiseInfo.praiseNum and fromPraiseInfo.praiseNum > 0 or fromPraiseInfo.cheerNum and 0 < fromPraiseInfo.cheerNum) then
      UIManager:GetInstance():OpenWindow(UIWindowNames.UIFlowerTrainThumbsUpGlory, {anim = true}, fromPraiseInfo)
    end
  end
end

return FlowerTrainFromPraiseInfoMessage
