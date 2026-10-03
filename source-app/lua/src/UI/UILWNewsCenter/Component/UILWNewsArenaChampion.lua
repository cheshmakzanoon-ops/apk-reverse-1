local base = require("UI.UILWNewsCenter.Component.UILWNewsBase")
local UILWNewsArenaChampion = BaseClass("UILWNewsArenaChampion", base)
local Localization = CS.GameEntry.Localization
local UIHead = require("UI.UILWNewsCenter.Component.UILWNewsUserCell")
local compBook = {
  {
    path = "imgBanner",
    name = "imgBanner",
    type = UIImage
  },
  {
    path = "imgBanner/txtPlayerName",
    name = "txtPlayerName",
    type = UIText
  },
  {
    path = "imgBanner/ChatHead",
    name = "head",
    type = UIHead
  }
}

function UILWNewsArenaChampion:ComponentDefine()
  base.ComponentDefine(self)
  self:DefineCompsByBook(compBook)
  self.txtTitle:SetText(Localization:GetString("800936"))
end

function UILWNewsArenaChampion:ComponentDestroy()
  self:ClearCompsByBook(compBook)
  base.ComponentDestroy(self)
end

function UILWNewsArenaChampion:SetContentViewScript(chatMainView)
  self._contentViewScript = chatMainView
end

function UILWNewsArenaChampion:UpdateItem(info)
  base.RefreshView(self, info)
  local abbr = string.IsNullOrEmpty(self.info.dataObj.abbr) and " " or "[" .. self.info.dataObj.abbr .. "] "
  local server = LuaEntry.Player.serverId == self.info.dataObj.serverId and "" or "#" .. self.info.dataObj.serverId
  local showName = DataCenter.PlayerInfoDataManager:GetRemarkOrRealName(self.info.dataObj.uid, self.info.dataObj.name)
  local name = server .. abbr .. showName
  self.txtPlayerName:SetText(name)
  local comment = Localization:GetString("800937", name, self.info.dataObj.serverArrStr)
  self.txtComment:SetText(comment)
  self.head:Refresh(self.info.dataObj.uid, self.info.dataObj.pic, self.info.dataObj.picver, self.info.dataObj.headSkinId, self.info.dataObj.headSkinET, self.info.dataObj.countryflag)
end

return UILWNewsArenaChampion
