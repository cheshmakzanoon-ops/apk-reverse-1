local LWPlaneFeatureInfoMessage = BaseClass("LWPlaneFeatureInfoMessage", SFSBaseMessage)
local base = SFSBaseMessage

function LWPlaneFeatureInfoMessage:OnCreate(stageIds)
  base.OnCreate(self)
  local sfsStageIdsArray = SFSArray.New()
  for i, stageId in ipairs(stageIds) do
    sfsStageIdsArray:AddInt(stageId)
  end
  self.sfsObj:PutSFSArray("ids", sfsStageIdsArray)
end

function LWPlaneFeatureInfoMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.LWStageFeatureChapterManager:RefreshChapterStageInfo(t)
  end
end

return LWPlaneFeatureInfoMessage
