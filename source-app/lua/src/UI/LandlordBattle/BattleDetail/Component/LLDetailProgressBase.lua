local base = UIAsyncContainer
local LLDetailProgressBase = BaseClass("LLDetailProgressBase", UIAsyncContainer)
local Localization = CS.GameEntry.Localization

function LLDetailProgressBase:DataDestroy()
  self.data = nil
  self.textTime = nil
  self.destroyStr = nil
  self.clockImg = nil
end

function LLDetailProgressBase:OnBtnDetailClick()
  DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
  if self.btnDetail == nil then
    return
  end
  local x, y, z = self.btnDetail:GetLocalPositionXYZ(true)
  local worldPos = self.btnDetail.transform.parent:TransformPoint(x, y, z)
  EventManager:GetInstance():Broadcast(EventId.LandlordShowCityDetailSpeed, {
    isThroneCity = self.isThroneCity,
    x = worldPos.x,
    y = worldPos.y,
    z = worldPos.z,
    data = self.data
  })
end

function LLDetailProgressBase:SetData(data, textTime)
  self.data = data
  self.textTime = textTime
  self.destroyStr = Localization:GetString("zonewar_landlord_limit_1017")
  local icon = self.textTime.transform.parent:Find("Icon")
  if icon ~= nil then
    self.clockImg = icon:GetComponent_Image()
  else
    self.clockImg = nil
  end
  self:RefreshView()
end

function LLDetailProgressBase:UpdateData()
  self:Update1000MS()
end

function LLDetailProgressBase:Update1000MS()
  if self.data == nil then
    return
  end
  local p, time = self.data:GetPercent()
  local maxP = self.data.progressMax or 0
  local curP = maxP == 0 and 0 or p * 1.0 / maxP
  if self.slider ~= nil then
    self.slider:SetValue(curP)
  end
  if self.textProgress ~= nil then
    self.textProgress:SetText(string.format("%s/%s", p, maxP))
  end
  if self.textSpeed ~= nil then
    local group = DataCenter.LandlordMgr:GetMyGroup()
    local key = group == LLConst.LandLordGroup.LORD and "zonewar_landlord_limit_1053" or "zonewar_landlord_limit_1054"
    self.textSpeed:SetText(string.format("%s: +%s/s", Localization:GetString(key), self.data:GetSpeed()))
  end
  if self.textTime ~= nil then
    if 1 <= curP then
      if self.clockImg then
        self.clockImg:Set_color(1, 1, 1, 0)
      end
      self.textTime:SetText(self.destroyStr)
    else
      if self.clockImg then
        self.clockImg:Set_color(1, 1, 1, 1)
      end
      self.textTime:SetText(UITimeManager:GetInstance():SecondToFmtStringWithoutDay(time))
    end
  end
end

return LLDetailProgressBase
