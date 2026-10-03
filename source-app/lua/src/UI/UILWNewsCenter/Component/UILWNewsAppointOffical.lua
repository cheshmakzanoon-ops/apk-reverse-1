local base = require("UI.UILWNewsCenter.Component.UILWNewsBase")
local UILWNewsAppointOffical = BaseClass("UILWNewsAppointOffical", base)
local Localization = CS.GameEntry.Localization
local UIHead = require("UI.UILWNewsCenter.Component.UILWNewsUserCell")
local compBook = {
  {
    path = "imgBanner",
    name = "imgBanner",
    type = UIImage
  },
  {
    path = "imgBanner/imgOffical",
    name = "imgOffical",
    type = UIImage
  },
  {
    path = "imgBanner/txtPlayerName",
    name = "txtPlayerName",
    type = UIText
  },
  {
    path = "imgBanner/txtOffical",
    name = "txtOffical",
    type = UIText
  },
  {
    path = "imgBanner/ChatHead",
    name = "head",
    type = UIHead
  }
}
local Lang_Key = {
  [10001] = 800921,
  [10002] = 800922,
  [10003] = 800923,
  [10004] = 800924,
  [10005] = 800925,
  [10006] = 800926,
  [10007] = 800927,
  [10008] = 800924,
  [10009] = 800923
}

function UILWNewsAppointOffical:ComponentDefine()
  base.ComponentDefine(self)
  self:DefineCompsByBook(compBook)
  self.txtTitle:SetText(Localization:GetString("800906"))
end

function UILWNewsAppointOffical:ComponentDestroy()
  self:ClearCompsByBook(compBook)
  base.ComponentDestroy(self)
end

function UILWNewsAppointOffical:SetContentViewScript(chatMainView)
  self._contentViewScript = chatMainView
end

function UILWNewsAppointOffical:UpdateItem(info)
  base.RefreshView(self, info)
  local king = self.info.dataObj.king
  local target = self.info.dataObj.target or king
  local kingAbbr = string.IsNullOrEmpty(king.abbr) and " " or "[" .. king.abbr .. "] "
  local tarAbbr = string.IsNullOrEmpty(target.abbr) and " " or "[" .. target.abbr .. "] "
  local kingServer = LuaEntry.Player.serverId == king.serverId and "" or "#" .. king.serverId
  local tarServer = LuaEntry.Player.serverId == target.serverId and "" or "#" .. target.serverId
  local showNameKing = DataCenter.PlayerInfoDataManager:GetRemarkOrRealName(king.uid, king.name)
  local showNameTar = DataCenter.PlayerInfoDataManager:GetRemarkOrRealName(target.uid, target.name)
  local kingName = kingServer .. kingAbbr .. showNameKing
  local tarName = tarServer .. tarAbbr .. showNameTar
  local jobId = tonumber(self.info.dataObj.positionId)
  local kingJobId = tonumber(self.info.dataObj.kingPosition or 10001)
  local jobCfg = LocalController:instance():getLine(TableName.Government, jobId)
  local jobName = Localization:GetString(jobCfg:getValue("name"))
  local kingJobCfg = LocalController:instance():getLine(TableName.Government, kingJobId)
  local kingJobName = Localization:GetString(kingJobCfg:getValue("name"))
  local comment
  if jobId == 10001 then
    comment = Localization:GetString(Lang_Key[jobId], kingServer .. kingAbbr .. king.allianceName, kingName)
  else
    comment = Localization:GetString(Lang_Key[jobId], tarName, kingName, jobName, kingJobName)
  end
  self.txtComment:SetText(comment)
  self.txtPlayerName:SetText(tarName)
  self.txtOffical:SetText(jobName)
  self.imgOffical:LoadSprite(string.format(LoadPath.UIGovernment, jobCfg:getValue("icon")))
  self.imgOffical:SetNativeSize()
  self.head:Refresh(target.uid, target.pic, target.picver, target.headSkinId, target.headSkinET, target.countryflag)
end

return UILWNewsAppointOffical
