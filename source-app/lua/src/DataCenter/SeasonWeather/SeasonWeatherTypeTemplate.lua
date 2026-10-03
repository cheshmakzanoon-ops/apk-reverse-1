local SeasonWeatherTypeTemplate = BaseClass("SeasonWeatherTypeTemplate")

function SeasonWeatherTypeTemplate:__init(info)
  self.id = info.id
  self.type = info:getIntValue("type", self.id)
  self.is_close_ui = info:getIntValue("is_close_ui", 0) ~= 0
  self.name = info:getValue("name", "")
  self.desc = info:getValue("desc", "")
  self.order = info:getIntValue("order", 0)
  local color = info:getValue("color", "")
  if not string.IsNullOrEmpty(color) then
    self.color = UIUtil.HexToColor(color)
  else
    self.color = Color.white
  end
  self.buff = info:getIntValue("buff", 0)
  local buff_para = info:getValue("para", "")
  self.buff_para = string.split(buff_para, "|")
  for i, v in ipairs(self.buff_para) do
    self.buff_para[i] = tonumber(v) or 0
  end
  self.plot = info:getIntValue("plot", 0)
  self.plot_pre = info:getIntValue("plot_pre", 0)
  self.sound_2 = info:getValue("sound_2", "")
  self.sound_3 = info:getValue("sound_3", "")
  self.world_assets = info:getValue("world_assets", "")
  local absolute_xy = info:getValue("absolute_xy", "")
  self.absolute_xy = {}
  if not string.IsNullOrEmpty(absolute_xy) then
    local absoluteList = string.split(absolute_xy, "|")
    for _, v in ipairs(absoluteList) do
      local xy = string.split(v, ";")
      if #xy == 2 then
        local tileX = tonumber(xy[1]) or 0
        local tileY = tonumber(xy[2]) or 0
        table.insert(self.absolute_xy, SceneUtils.TileToWorld({x = tileX, y = tileY}, ForceChangeScene.World))
      end
    end
  end
  self.isFollow = info:getIntValue("follow", 0) == 1
  self.screen_assets = info:getValue("screen_assets", "")
  self.screen_assets_loop = info:getValue("screen_assets_loop", "")
  self.icon = info:getValue("icon", "")
  self.icon_bg = info:getValue("icon_bg", "")
  self.image = info:getValue("image", "")
  self.image_act = info:getValue("image_act", "")
  self.fog_mat = info:getValue("fog_mat", "")
  local city_rgba = info:getValue("city_rgba", "")
  self.city_color = self:ReadColor(city_rgba)
  local city_fog_rgba = info:getValue("city_fog_rgba", "")
  self.city_fog_color = self:ReadColor(city_fog_rgba)
  self.sound = info:getIntValue("sound_2", 0)
  self.bgm = info:getIntValue("sound_3", 0)
end

function SeasonWeatherTypeTemplate:UpdateData(netData)
end

function SeasonWeatherTypeTemplate:ReadColor(rgba)
  if not string.IsNullOrEmpty(rgba) then
    local rgbaList = string.split(rgba, ";")
    if 3 <= #rgbaList then
      return Color.New(tonumber(rgbaList[1] or 0) / 255, tonumber(rgbaList[2] or 0) / 255, tonumber(rgbaList[3] or 0) / 255, tonumber(rgbaList[4] or 255) / 255)
    end
  end
  return Color.clear
end

function SeasonWeatherTypeTemplate:ShowBuffTips(trans)
  local statusInfo = LocalController:instance():getLine(TableName.StatusTab, self.buff)
  if statusInfo and not string.IsNullOrEmpty(statusInfo.description) then
    UIUtil.ShowBubbleTips(CS.GameEntry.Localization:GetString(statusInfo.description), trans.position, 0, -30, 0, nil, CS.GameEntry.Localization:GetString(statusInfo.name))
  end
end

function SeasonWeatherTypeTemplate:GetBgPath()
  if self:CloserToRed(self.color) then
    return "Assets/Main/Sprites/UI/UISeason/UISeason1_Remote/Weather/zxl_s1_tianqi_jintian_hong.png"
  else
    return "Assets/Main/Sprites/UI/UISeason/UISeason1_Remote/Weather/zxl_s1_tianqi_jintian.png"
  end
end

local refRed, refGreen

function SeasonWeatherTypeTemplate:CloserToRed(color)
  if not refRed or not refGreen then
    refRed = Color.RGBToHSV(UIUtil.HexToColor("fccdce"))
    refGreen = Color.RGBToHSV(UIUtil.HexToColor("cdf3d2"))
  end
  local h, s, v = Color.RGBToHSV(color)
  local dhRed = math.abs(h - refRed)
  local dhGreen = math.abs(h - refGreen)
  return dhRed < dhGreen
end

return SeasonWeatherTypeTemplate
