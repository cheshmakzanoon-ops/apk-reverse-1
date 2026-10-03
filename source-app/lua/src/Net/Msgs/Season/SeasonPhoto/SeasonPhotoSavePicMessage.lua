local SeasonPhotoSavePicMessage = BaseClass("SeasonPhotoSavePicMessage", SFSBaseMessage)
local base = SFSBaseMessage

function SeasonPhotoSavePicMessage:OnCreate(param)
  base.OnCreate(self)
  self.sfsObj:PutInt("curVer", param.curVer)
  self.sfsObj:PutInt("nextVer", param.nextVer)
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

function SeasonPhotoSavePicMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
    DataCenter.SeasonPhotoManager:SeasonPhotoSavePicMessage()
    return
  end
  DataCenter.SeasonPhotoManager:SeasonPhotoSavePicMessage(t.nextVer, t.userSeasonSettleRecordInfo)
end

return SeasonPhotoSavePicMessage
