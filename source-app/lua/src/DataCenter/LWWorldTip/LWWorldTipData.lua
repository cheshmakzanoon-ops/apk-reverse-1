local LWWorldTipData = BaseClass("LWWorldTipData")

function LWWorldTipData:InitData(lineData)
  if lineData == nil then
    return
  end
  self.id = lineData:getValue("id")
  self.group = lineData:getValue("group")
  self.video_resource = lineData:getValue("video_resource")
  self.title_key = lineData:getValue("title_key")
  self.if_go = lineData:getValue("if_go") == "1"
  self.if_go_key = lineData:getValue("if_go_key")
  self.go_type = lineData:getValue("go_type")
  self.UI_title_key = lineData:getValue("UI_title_key")
  local bannerStr = lineData:getValue("banner") or ""
  local bannerSplit = string.split(bannerStr, "|")
  local long_keyStr = lineData:getValue("long_key") or ""
  local long_keySplit = string.split(long_keyStr, "|")
  local para_setStr = lineData:getValue("para_set") or ""
  local para_setSplit = string.split(para_setStr, "|")
  self.series = {}
  for i = 1, #bannerSplit do
    self.series[i] = {
      banner = bannerSplit[i],
      long_key = long_keySplit[i],
      para_set = para_setSplit[i]
    }
  end
  self.season_group = lineData:getValue("season_group")
  self.week = lineData:getValue("week")
  self.icon = lineData:getValue("icon")
  self.icon_name = lineData:getValue("icon_name")
  self.icon_des = lineData:getValue("icon_des")
  self.order = toInt(lineData:getValue("order"))
  self.cancel_turn = lineData:getIntValue("cancel_turn", 0)
  self.tab_group = lineData:getValue("tab_group")
end

return LWWorldTipData
