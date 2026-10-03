local OccupyRankDetailItem = BaseClass("OccupyRankDetailItem", UIBaseContainer)
local base = UIBaseContainer
local bg_path = "bg"
local bg_self_path = "bgSelf"
local flag_path = "flag"
local first_img_path = "firstImg"
local second_img_path = "secondImg"
local third_img_path = "thirdImg"
local num_txt_path = "numTxt"
local name_txt_path = "nameTxt"
local slider_path = "Slider"
local power_txt_path = "Slider/powerTxt"

function OccupyRankDetailItem:OnCreate()
  base.OnCreate(self)
  self.bg = self:AddComponent(UIButton, bg_path)
  self.bg_self = self:AddComponent(UIButton, bg_self_path)
  self.flag = self:AddComponent(UIImage, flag_path)
  self.first_img = self:AddComponent(UIImage, first_img_path)
  self.second_img = self:AddComponent(UIImage, second_img_path)
  self.third_img = self:AddComponent(UIImage, third_img_path)
  self.num_txt = self:AddComponent(UIText, num_txt_path)
  self.name_txt = self:AddComponent(UIText, name_txt_path)
  self.slider = self:AddComponent(UISlider, slider_path)
  self.slider_text = self:AddComponent(UIText, power_txt_path)
  self.maxPoint = SeasonUtil.GetPresidentOccupationRate("k2", 28800)
  self.addSpeed = SeasonUtil.GetPresidentOccupationRate("k1", 1)
  self.bg:SetOnClick(function()
    self:OnInfoBtnClick()
  end)
  self.bg_self:SetOnClick(function()
    self:OnInfoBtnClick()
  end)
end

function OccupyRankDetailItem:OnDestroy()
  self.isOver = false
  self.data = nil
  base.OnDestroy(self)
end

function OccupyRankDetailItem:OnInfoBtnClick()
  if self.data ~= nil then
    self.view:OnAllianceDetailClick(self.data.aId, self.data.name)
  end
end

function OccupyRankDetailItem:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.SearchAllianceSuccess, self.OnSearchAllianceSuccess)
end

function OccupyRankDetailItem:OnRemoveListener()
  self:RemoveUIListener(EventId.SearchAllianceSuccess, self.OnSearchAllianceSuccess)
  base.OnRemoveListener(self)
end

function OccupyRankDetailItem:OnSearchAllianceSuccess()
  if self.data == nil or self.data.allianceId == nil or self.name_txt == nil then
    return
  end
  local allianceInfo = DataCenter.AllianceTempListManager:GetSearchAllianceDataByUid(self.data.allianceId)
  if allianceInfo ~= nil then
    local serverId = allianceInfo.createServer or allianceInfo.ownerServerId
    if self.top then
      self.name_txt:SetText(UIUtil.FormatServerAllianceName(serverId, self.data.abbr, self.data.name))
    else
      self.name_txt:SetText("<color=#2a2830>" .. UIUtil.FormatServerAllianceName(serverId, self.data.abbr, self.data.name) .. "</color>")
    end
  end
end

function OccupyRankDetailItem:ReInit(rank, data, top)
  self.bg:SetActive(not top)
  self.bg_self:SetActive(top)
  self.first_img:SetActive(rank == 1)
  self.second_img:SetActive(rank == 2)
  self.third_img:SetActive(rank == 3)
  if type(rank) == "number" and 0 < rank and rank < 100 then
    self.num_txt:SetText(rank)
  else
    self.num_txt:SetText("100+")
  end
  local allianceInfo = DataCenter.AllianceTempListManager:GetSearchAllianceDataByUid(data.allianceId or data.aId)
  if allianceInfo == nil then
    SFSNetwork.SendMessage(MsgDefines.GetAllianceInfo, data.allianceId or data.aId)
    if top then
      self.name_txt:SetText(UIUtil.FormatAllianceAndName(data.abbr, data.name))
    else
      self.name_txt:SetText("<color=#2a2830>" .. UIUtil.FormatAllianceAndName(data.abbr, data.name) .. "</color>")
    end
  else
    local serverId = allianceInfo.createServer or allianceInfo.ownerServerId
    if top then
      self.name_txt:SetText(UIUtil.FormatServerAllianceName(serverId, data.abbr, data.name))
    else
      self.name_txt:SetText("<color=#2a2830>" .. UIUtil.FormatServerAllianceName(serverId, data.abbr, data.name) .. "</color>")
    end
  end
  if data.icon then
    self.flag:LoadSprite(string.format(AL_FLAG_SPRITE_PATH, tostring(data.icon)))
  end
  if data.speed then
    self.addSpeed = data.speed
  end
  if data.maxPoint then
    self.maxPoint = data.maxPoint
  end
  self.isOver = false
  self.top = top
  self.data = data
  self:Update100MS()
end

function OccupyRankDetailItem:Update100MS()
  if self.isOver then
    return
  end
  if self.data == nil or self.data.point == nil or self.maxPoint == nil or self.addSpeed == nil then
    self.slider:SetValue(0)
    self.slider_text:SetText("0%")
    return
  end
  local pointNow = self.data.point
  if self.data ~= nil and self.data.startTime ~= nil then
    local curTime = UITimeManager:GetInstance():GetServerTime()
    pointNow = (curTime - self.data.startTime) * 0.001 * self.addSpeed + pointNow
  end
  if pointNow < self.maxPoint then
    local pointRate = pointNow * 100 / self.maxPoint
    if 100 <= pointRate then
      self.isOver = true
      self.slider:SetValue(100)
      self.slider_text:SetText("100%")
    else
      self.slider:SetValue(pointRate)
      self.slider_text:SetText(string.format("%.2f", pointRate) .. "%")
    end
  else
    self.isOver = true
    self.slider:SetValue(100)
    self.slider_text:SetText("100%")
  end
end

return OccupyRankDetailItem
