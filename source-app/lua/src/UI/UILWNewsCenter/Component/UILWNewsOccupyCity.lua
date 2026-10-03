local base = require("UI.UILWNewsCenter.Component.UILWNewsBase")
local LWNewsOccupyCity = BaseClass("LWNewsOccupyCity", base)
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
    path = "imgBanner/btnCoordinate",
    name = "btnCoordinate",
    type = UIButton
  },
  {
    path = "imgBanner/btnCoordinate/txtCoordinate",
    name = "txtCoordinate",
    type = UIText
  },
  {
    path = "imgBanner/imgCity",
    name = "imgCity",
    type = UIImage
  },
  {
    path = "imgBanner/txtWinLeft",
    name = "txtWinLeft",
    type = UIText
  },
  {
    path = "imgBanner/txtLostRight",
    name = "txtLostRight",
    type = UIText
  },
  {
    path = "imgBanner/txtLeaderLeft",
    name = "txtLeaderLeft",
    type = UIText
  },
  {
    path = "imgBanner/txtLeaderRight",
    name = "txtLeaderRight",
    type = UIText
  }
}

function LWNewsOccupyCity:ComponentDefine()
  base.ComponentDefine(self)
  self:DefineCompsByBook(compBook)
  self.txtTitle:SetText(Localization:GetString("800905"))
  self.btnCoordinate:SetOnClick(function()
    local pos = SceneUtils.TileIndexToWorld(self.info.dataObj.pointId, ForceChangeScene.World)
    GoToUtil.GotoWorldPos(pos)
    UIManager:GetInstance():DestroyWindow(UIWindowNames.UILWNewsCenter)
    UIManager:GetInstance():DestroyWindow(UIWindowNames.UIChatNew_v2)
  end)
end

function LWNewsOccupyCity:ComponentDestroy()
  self:ClearCompsByBook(compBook)
  base.ComponentDestroy(self)
end

function LWNewsOccupyCity:SetContentViewScript(chatMainView)
  self._contentViewScript = chatMainView
end

function LWNewsOccupyCity:UpdateItem(info)
  base.RefreshView(self, info)
  local atk = self.info.dataObj.atk
  local def = self.info.dataObj.def
  local atkAbbr = string.IsNullOrEmpty(atk.alAbbr) and " " or "[" .. atk.alAbbr .. "]"
  local defAbbr = string.IsNullOrEmpty(def.alAbbr) and " " or "[" .. def.alAbbr .. "]"
  local atkServer = LuaEntry.Player.serverId == atk.serverId and "" or "#" .. atk.serverId
  local defServer = LuaEntry.Player.serverId == def.serverId and "" or "#" .. def.serverId
  local atkName = atkServer .. atkAbbr .. atk.alName
  local defName = defServer .. defAbbr .. def.alName
  local cityCfg = DataCenter.AllianceCityTemplateManager:GetTemplate(self.info.dataObj.cityId)
  local comment = Localization:GetString("800920", atkName, defName, cityCfg.level, Localization:GetString(cityCfg.name))
  self.txtComment:SetText(comment)
  self.txtLeaderLeft:SetText(atkName)
  self.txtLeaderRight:SetText(defName)
  self.txtOwner:SetText(atkAbbr .. " Lv" .. cityCfg.level .. " " .. Localization:GetString(cityCfg.name))
  local coordinates = string.split(cityCfg.location, "|")
  self.txtCoordinate:SetText("x:" .. coordinates[1] .. " y:" .. coordinates[2])
  self.imgCity:LoadSprite(cityCfg:GetIconPath(false))
end

return LWNewsOccupyCity
