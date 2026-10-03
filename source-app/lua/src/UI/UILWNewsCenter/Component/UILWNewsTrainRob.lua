local base = require("UI.UILWNewsCenter.Component.UILWNewsBase")
local LWNewsTrainRob = BaseClass("LWNewsTrainRob", base)
local Localization = CS.GameEntry.Localization
local UIHead = require("UI.UILWNewsCenter.Component.UILWNewsUserCell")
local compBook = {
  {
    path = "imgBanner",
    name = "imgBanner",
    type = UIImage
  },
  {
    path = "imgBanner/txtOwner",
    name = "txtOwner",
    type = UIText
  },
  {
    path = "imgBanner/txtSeized",
    name = "txtSeized",
    type = UIText
  },
  {
    path = "imgBanner/txtSnatching",
    name = "txtSnatching",
    type = UIText
  },
  {
    path = "imgBanner/ChatHead",
    name = "head",
    type = UIHead
  }
}

function LWNewsTrainRob:ComponentDefine()
  base.ComponentDefine(self)
  self:DefineCompsByBook(compBook)
  self.txtTitle:SetText(Localization:GetString("800938"))
end

function LWNewsTrainRob:ComponentDestroy()
  self:ClearCompsByBook(compBook)
  base.ComponentDestroy(self)
end

function LWNewsTrainRob:SetContentViewScript(chatMainView)
  self._contentViewScript = chatMainView
end

function LWNewsTrainRob:UpdateItem(info)
  base.RefreshView(self, info)
  local abbr = string.IsNullOrEmpty(self.info.dataObj.abbr) and " " or "[" .. self.info.dataObj.abbr .. "] "
  local server = LuaEntry.Player.serverId == self.info.dataObj.serverId and "" or "#" .. self.info.dataObj.serverId
  local showName = DataCenter.PlayerInfoDataManager:GetRemarkOrRealName(self.info.dataObj.uid, self.info.dataObj.name)
  local name = server .. abbr .. showName
  local comment = Localization:GetString("800939", name, self.info.dataObj.robTime)
  self.txtComment:SetText(comment)
  self.txtOwner:SetText(name)
  self.txtSeized:SetText(Localization:GetString("801038") .. self.info.dataObj.robTime)
  self.txtSnatching:SetText(Localization:GetString("801039") .. (self.info.dataObj.winCount or 0))
  self.head:Refresh(self.info.dataObj.uid, self.info.dataObj.pic, self.info.dataObj.picver, self.info.dataObj.headSkinId, self.info.dataObj.headSkinET, self.info.dataObj.countryflag)
end

return LWNewsTrainRob
