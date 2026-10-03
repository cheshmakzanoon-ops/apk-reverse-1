local SeasonPhotoApplyPicverMessage = BaseClass("SeasonPhotoApplyPicverMessage", SFSBaseMessage)
local base = SFSBaseMessage

function SeasonPhotoApplyPicverMessage:OnCreate(param)
  base.OnCreate(self)
  self.sfsObj:PutInt("curVer", param.curVer)
  self.sfsObj:PutInt("targetSeason", param.targetSeason)
  self.sfsObj:PutUtfString("targetAllianceId", param.targetAllianceId)
  self.sfsObj:PutUtfStringArray("moveMemberArr", param.moveMemberArr)
  self.sfsObj:PutUtfStringArray("addMemberArr", param.addMemberArr)
  local rapidjson = require("rapidjson")
  if table.IsNullOrEmpty(param.picData.playerArr) then
    param.picData.playerArr = nil
  end
  self.sfsObj:PutUtfString("picData", rapidjson.encode(param.picData))
end

function SeasonPhotoApplyPicverMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
    DataCenter.SeasonPhotoManager:SeasonPhotoApplyPicverMessage()
    return
  end
  DataCenter.SeasonPhotoManager:SeasonPhotoApplyPicverMessage(t.applyVer, t.targetSeason, t.targetAllianceId)
end

return SeasonPhotoApplyPicverMessage
