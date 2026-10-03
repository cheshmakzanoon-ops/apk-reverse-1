local pro_path = "pro"
local pro_fill_path = "pro/FillArea/pro_fill"
local pro_abbr_path = "pro_abbr"
local pro_num_path = "pro_num"
local pro_time_path = "pro_time"
local icon_path = "icon"
local base = UIBaseContainer
local SeasonCityAltarCityTipCell = BaseClass("SeasonCityAltarCityTipCell", base)

function SeasonCityAltarCityTipCell:ComponentDefine()
  self.pro = self:AddComponent(UISlider, pro_path)
  self.pro_fill = self:AddComponent(UIImage, pro_fill_path)
  self.pro_abbr = self:AddComponent(UITextMeshProUGUIEx, pro_abbr_path)
  self.pro_num = self:AddComponent(UITextMeshProUGUIEx, pro_num_path)
  self.canvas_pro_num = self:AddComponent(UICanvasGroup, pro_num_path)
  self.pro_time = self:AddComponent(UITextMeshProUGUIEx, pro_time_path)
  self.canvas_pro_time = self:AddComponent(UICanvasGroup, pro_time_path)
  self.icon = self:AddComponent(UIImage, icon_path)
end

function SeasonCityAltarCityTipCell:ComponentDestroy()
  self.pro = nil
  self.pro_fill = nil
  self.pro_abbr = nil
  self.pro_num = nil
  self.pro_time = nil
  self.icon = nil
end

function SeasonCityAltarCityTipCell:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
end

function SeasonCityAltarCityTipCell:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function SeasonCityAltarCityTipCell:OnEnable()
  base.OnEnable(self)
end

function SeasonCityAltarCityTipCell:ReInit(data)
  if self:InitData(data) then
    self:InitUi()
    self:Tick()
  end
end

function SeasonCityAltarCityTipCell:InitData(data)
  if data ~= nil then
    self.Data = data
    self.BaseTime = UITimeManager:GetInstance():GetServerTime()
    self.MaxScore = DataCenter.SeasonCityAltarManager:GetAltarMaxScore()
    return true
  end
  return false
end

function SeasonCityAltarCityTipCell:InitUi()
  local now = UITimeManager:GetInstance():GetServerTime()
  local curScore = self.Data.score + Mathf.Floor((now - self.Data.st) / 1000) * self.Data.speed
  local percent = Mathf.Clamp01(curScore / self.MaxScore)
  self.pro:SetValue(percent)
  self.pro_num:SetTextFormat("%.2f%s", percent * 100, "%")
  if self.Data.userInfo ~= nil then
    self.pro_abbr:SetTextFormat("[%s]", self.Data.userInfo.alAbbr)
    self.icon:LoadSpriteAsync(string.format(AL_FLAG_SPRITE_PATH, self.Data.userInfo.alIcon))
    if self.Data.userInfo.allianceId == LuaEntry.Player.allianceId then
      self.pro_fill:SetColorRGBA(0, 1, 0, 1)
    else
      self.pro_fill:SetColorRGBA(1, 0, 0, 1)
    end
  end
  self.canvas_pro_num:SetAlpha(1)
  self.canvas_pro_time:SetAlpha(0)
end

function SeasonCityAltarCityTipCell:Tick()
  if self.Data == nil then
    return
  end
  if checknumber(self.Data.speed) > 0 then
    local now = UITimeManager:GetInstance():GetServerTime()
    local curScore = self.Data.score + Mathf.Floor((now - self.Data.st) / 1000) * self.Data.speed
    local percent = Mathf.Clamp01(curScore / self.MaxScore)
    self.pro:SetValue(percent)
    self.pro_num:SetTextFormat("%.2f%s", percent * 100, "%")
    if 0 < checknumber(self.Data.et) then
      local timeToOccupy = Mathf.Max(0, checknumber(self.Data.et) - now)
      self.pro_time:SetText(UITimeManager:GetInstance():MilliSecondToFmtString(timeToOccupy))
    end
    local pastTime = Mathf.Floor((now - checknumber(self.BaseTime)) / 1000)
    if pastTime % 10 == 0 then
      self:Fade(self.canvas_pro_time, self.canvas_pro_num)
    elseif pastTime % 5 == 0 then
      self:Fade(self.canvas_pro_num, self.canvas_pro_time)
    end
  end
end

function SeasonCityAltarCityTipCell:Fade(from, to)
  if from ~= nil then
    from:FadeOut(1)
  end
  if to ~= nil then
    to:FadeIn(1)
  end
end

return SeasonCityAltarCityTipCell
