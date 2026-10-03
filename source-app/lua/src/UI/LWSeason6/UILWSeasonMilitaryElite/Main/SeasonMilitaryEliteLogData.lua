local rapidjson = require("rapidjson")
local base64 = require("Framework.Common.base64")
local SeasonMilitaryEliteLogData = BaseClass("SeasonMilitaryEliteLogData")

function SeasonMilitaryEliteLogData:__init(logType)
  self.LogTransType = {
    Text = 0,
    Loc = 1,
    Pos = 2,
    Abbr = 3,
    Time = 4,
    PosWithServer = 5
  }
  self.LogType = logType
end

function SeasonMilitaryEliteLogData:__delete()
end

function SeasonMilitaryEliteLogData:SetData(data)
  self.Data = data
  self.Time = data.time
  self.Key = data.code
  self.Trans = data.trans
  self.Params = data.params
end

function SeasonMilitaryEliteLogData:GetColorImg()
  return ""
end

function SeasonMilitaryEliteLogData:GetIcon()
  local logTypeEnum = DataCenter.SeasonMilitaryEliteManager.LogType
  if self.LogType == logTypeEnum.BankTrans then
    return "Assets/Main/SeasonRes/S5/Sprites/SeasonMoneyRank/LXYS5_Jingjin_Icon2_banner.png"
  elseif self.LogType == logTypeEnum.BankRob then
    return "Assets/Main/SeasonRes/S5/Sprites/SeasonMoneyRank/LXYS5_Jingjin_Icon8_banner.png"
  elseif self.LogType == logTypeEnum.Shoot then
    return "Assets/Main/SeasonRes/S5/Sprites/SeasonMoneyRank/LXYS5_Jingjin_Icon3_banner.png"
  elseif self.LogType == logTypeEnum.Train then
    return "Assets/Main/SeasonRes/S5/Sprites/SeasonMoneyRank/LXYS5_Jingjin_Icon1_banner.png"
  end
  return ""
end

function SeasonMilitaryEliteLogData:GetDesc()
  if string.IsNullOrEmpty(self.Key) then
    return ""
  end
  local params = {}
  for i = 1, #self.Params do
    local param = self.Params[i]
    if self.Trans[i] == self.LogTransType.Text then
      params[i] = param
    elseif self.Trans[i] == self.LogTransType.Loc then
      params[i] = CS.GameEntry.Localization:GetString(param)
    elseif self.Trans[i] == self.LogTransType.Pos then
      local pos = SceneUtils.IndexToTilePos(tonumber(param), ForceChangeScene.World)
      params[i] = CS.GameEntry.Localization:GetString(GameDialogDefine.SHOW_POS, pos.x, pos.y)
      self.Pos = tonumber(param)
    elseif self.Trans[i] == self.LogTransType.Abbr then
      if not string.IsNullOrEmpty(param) then
        params[i] = "[" .. param .. "]"
      else
        params[i] = param or ""
      end
    elseif self.Trans[i] == self.LogTransType.Time then
      if not string.IsNullOrEmpty(param) then
        params[i] = UITimeManager:GetInstance():TimeStampToTimeForServer(param)
      else
        params[i] = param or ""
      end
    elseif self.Trans[i] == self.LogTransType.PosWithServer then
      local split = string.split(param, "|")
      local pos = SceneUtils.IndexToTilePos(tonumber(split[2]), ForceChangeScene.World)
      local link = {
        action = "Jump",
        x = pos.x,
        y = pos.y,
        server = tonumber(split[1])
      }
      local json = rapidjson.encode(link)
      local linkId = base64.encode(json)
      params[i] = "<link='" .. linkId .. "'><u>(#" .. tonumber(split[1]) .. " X:" .. math.tointeger(pos.x) .. ", " .. "Y:" .. math.tointeger(pos.y) .. ")</u></link>"
    end
  end
  if next(params) then
    return CS.GameEntry.Localization:GetString(self.Key, table.unpack(params))
  end
  return CS.GameEntry.Localization:GetString(self.Key)
end

function SeasonMilitaryEliteLogData:GetTimeStr()
  return UITimeManager:GetInstance():TimeStampToTimeForServer(checknumber(self.Time))
end

function SeasonMilitaryEliteLogData:TryGotoPos()
  if self.Pos ~= nil then
    if not SceneUtils.CheckCanGotoWorld() then
      return
    end
    local rightPos = SceneUtils.TileIndexToWorld(self.Pos, ForceChangeScene.World)
    GoToUtil.CloseAllWindows()
    GoToUtil.GotoWorldPos(rightPos, CS.SceneManager.World.InitZoom, LookAtFocusTime, function()
    end)
  end
end

function SeasonMilitaryEliteLogData:TryJump(linkId)
  if linkId ~= nil then
    local linkMsg = base64.decode(linkId)
    linkMsg = rapidjson.decode(linkMsg)
    GoToUtil.TryJumpToWorld(linkMsg)
  end
end

return SeasonMilitaryEliteLogData
