local SeasonSelectLocationActData = require("UI/LWSeason5/SeasonSelectLocation/Common/SeasonSelectLocationActData")
local SeasonSelectLocationPosData = require("UI/LWSeason5/SeasonSelectLocation/Common/SeasonSelectLocationPosData")
local SeasonSelectLocationManager = BaseClass("SeasonSelectLocationManager")

function SeasonSelectLocationManager:__init()
  self.ActId = 0
  self.ActCell = nil
  self.WorldSkinCells = {}
  self.ActData = nil
  self.PosData = nil
end

function SeasonSelectLocationManager:__delete()
  self.ActId = 0
  self.ActCell = nil
end

function SeasonSelectLocationManager:SetActId(actId)
  self.ActId = actId
  self.ActCell = LocalController:instance():getLine(TableName.Activity, checknumber(self.ActId))
end

function SeasonSelectLocationManager:GetActData()
  if self.ActData == nil then
    local actData = DataCenter.ActivityListDataManager:GetActivityDataById(self.ActId)
    if actData ~= nil then
      self.ActData = SeasonSelectLocationActData.New(actData)
    end
  end
  return self.ActData
end

function SeasonSelectLocationManager:GetActCell()
  return self.ActCell
end

function SeasonSelectLocationManager:GetWorldSkinCells()
  if table.IsNullOrEmpty(self.WorldSkinCells) then
    self.WorldSkinCells = {}
    local severInfo = DataCenter.SeasonDataManager:GetUserSeasonInfo()
    if severInfo ~= nil then
      local nextSeasonConfigId = severInfo.nextSeasonConfigId
      if nextSeasonConfigId ~= nil and severInfo:InPreviewMode() then
        local nextSeasonConfig = LocalController:instance():getLine(TableName.LW_Season, nextSeasonConfigId)
        if nextSeasonConfig ~= nil then
          local worldSkinIds = string.split(nextSeasonConfig.world_skin, "#")
          if table.count(worldSkinIds) >= 9 then
            for i = 1, 9 do
              local worldLineCell = LocalController:instance():getLine(TableName.World_Skin, worldSkinIds[i])
              table.insert(self.WorldSkinCells, worldLineCell)
            end
          end
        end
      end
    end
  end
  return self.WorldSkinCells
end

function SeasonSelectLocationManager:GetWorldSkinCell(pos)
  local cells = self:GetWorldSkinCells()
  if cells ~= nil and 1 <= pos and pos <= #cells then
    return cells[pos]
  end
  return nil
end

function SeasonSelectLocationManager:ClearPosData()
  self.PosData = nil
end

function SeasonSelectLocationManager:GetPosData(pos)
  if self.PosData == nil then
    return nil
  end
  return self.PosData:GetPosData(pos)
end

function SeasonSelectLocationManager:GetMyData()
  if self.PosData == nil then
    return nil
  end
  return self.PosData:GetMyData()
end

function SeasonSelectLocationManager:GetNextSetTime()
  if self.PosData ~= nil then
    local lastSetTime, nextSetTime = self.PosData:GetNextSetTime()
    return nextSetTime
  end
  return LongMaxValue
end

function SeasonSelectLocationManager:IsCdValid()
  if self.PosData ~= nil then
    return self.PosData:IsCdValid()
  end
  return false, LongMaxValue
end

function SeasonSelectLocationManager:CheckAuth()
  local isKing = LuaEntry.Player:IsPresident()
  return isKing
end

function SeasonSelectLocationManager:SendGetInfo()
  SFSNetwork.SendMessage(MsgDefines.ActivitySidposInfo)
end

function SeasonSelectLocationManager:OnGetInfoCallback(res)
  if res ~= nil then
    if self.PosData == nil then
      self.PosData = SeasonSelectLocationPosData.New()
    end
    self.PosData:Update(res, true)
  end
end

function SeasonSelectLocationManager:IsSelectStage()
  local actData = self:GetActData()
  if actData == nil then
    return false
  end
  return actData:IsSelectStage()
end

function SeasonSelectLocationManager:CheckSetPosValid(pos, toast)
  if not self:IsSelectStage() then
    if toast then
      UIUtil.ShowTips(CS.GameEntry.Localization:GetString("zone_selection_location_tips_9"))
    end
    return false
  end
  if not self:IsCdValid() then
    if toast then
      local timeLeft = UITimeManager:GetInstance():SecondToFmtString(self:GetNextSetTime() - UITimeManager:GetInstance():GetServerSeconds())
      UIUtil.ShowTips(CS.GameEntry.Localization:GetString("zone_selection_location_tips_1", timeLeft))
    end
    return false
  end
  if not self:CheckAuth() then
    if toast then
      UIUtil.ShowTips(CS.GameEntry.Localization:GetString("zone_selection_location_tips_6"))
    end
    return false
  end
  local myData = self:GetMyData()
  if myData == nil or myData.Score <= 0 then
    if toast then
      UIUtil.ShowTips(CS.GameEntry.Localization:GetString("zone_selection_location_tips_5"))
    end
    return false
  end
  if myData.Pos == pos then
    if toast then
      UIUtil.ShowTips(CS.GameEntry.Localization:GetString("zone_selection_location_tips_10"))
    end
    return false
  end
  local otherData = self:GetPosData(pos)
  if otherData == nil or otherData.Score <= 0 then
    return true
  end
  if myData.Score > otherData.Score or myData.Score == otherData.Score and myData.Time > otherData.Time then
    if toast then
      UIUtil.ShowTips(CS.GameEntry.Localization:GetString("zone_selection_location_tips_11"))
    end
    return false
  end
  return true
end

function SeasonSelectLocationManager:SendSetPos(pos)
  pos = checknumber(pos)
  if not self:CheckSetPosValid(pos, true) then
    return
  end
  local skinCell = self:GetWorldSkinCell(pos)
  local msg = CS.GameEntry.Localization:GetString("zone_selection_location_tips_2", CS.GameEntry.Localization:GetString(skinCell.aliases))
  local confirmText = "zone_selection_location_tips_3"
  local cancelText = "zone_selection_location_tips_4"
  
  local function confirmAction()
    local param = {}
    param.pos = pos
    SFSNetwork.SendMessage(MsgDefines.ActivitySidposSet, param)
  end
  
  UIUtil.ShowMessage(msg, 2, confirmText, cancelText, confirmAction, nil, nil, "zone_selection_location_UI_36")
end

function SeasonSelectLocationManager:OnSetCallback(res)
  if res ~= nil then
    if self.PosData == nil then
      self.PosData = SeasonSelectLocationPosData.New()
    end
    self.PosData:Update(res, true)
  end
end

return SeasonSelectLocationManager
