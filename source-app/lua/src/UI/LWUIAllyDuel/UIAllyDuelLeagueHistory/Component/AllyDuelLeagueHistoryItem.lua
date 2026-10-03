local AllyDuelLeagueHistoryItem = BaseClass("AllyDuelLeagueHistoryItem", UIBaseContainer)
local base = UIBaseContainer

function AllyDuelLeagueHistoryItem:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function AllyDuelLeagueHistoryItem:OnDestroy()
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

function AllyDuelLeagueHistoryItem:ComponentDefine()
  self.slider = self:AddComponent(UISlider, "Slider")
  self.blueName = self:AddComponent(UIText, "blueName")
  self.redName = self:AddComponent(UIText, "redName")
  self.blueScore = self:AddComponent(UIText, "blueScore")
  self.redScore = self:AddComponent(UIText, "redScore")
  self.blueFlag = self:AddComponent(UIImage, "blueFlag")
  self.redFlag = self:AddComponent(UIImage, "redFlag")
  self.blueBtn = self:AddComponent(UIButton, "blueBtn")
  self.blueBtn:SetOnClick(function()
    self:OnClick(1)
  end)
  self.redBtn = self:AddComponent(UIButton, "redBtn")
  self.redBtn:SetOnClick(function()
    self:OnClick(2)
  end)
  self.anim = self:AddComponent(UISimpleAnimation, "")
end

function AllyDuelLeagueHistoryItem:ComponentDestroy()
end

function AllyDuelLeagueHistoryItem:DataDefine()
end

function AllyDuelLeagueHistoryItem:DataDestroy()
end

function AllyDuelLeagueHistoryItem:OnAddListener()
  base.OnAddListener(self)
end

function AllyDuelLeagueHistoryItem:OnRemoveListener()
  base.OnRemoveListener(self)
end

function AllyDuelLeagueHistoryItem:Refresh(data)
  self.blueAlly = data.vsAllianceInfo[1]
  self.redAlly = data.vsAllianceInfo[2]
  self.slider:SetValue(self.blueAlly.winScore / (self.blueAlly.winScore + self.redAlly.winScore))
  self.blueName:SetText(UIUtil.FormatServerAllianceName(self.blueAlly.serverId, self.blueAlly.abbr, self.blueAlly.alName))
  if string.IsNullOrEmpty(self.redAlly.alName) then
    self.redName:SetLocalText(372814)
    self.redBtn:SetActive(false)
  else
    self.redName:SetText(UIUtil.FormatServerAllianceName(self.redAlly.serverId, self.redAlly.abbr, self.redAlly.alName))
    self.redBtn:SetActive(true)
  end
  self.blueScore:SetText(self.blueAlly.winScore)
  self.redScore:SetText(self.redAlly.winScore)
  self.blueFlag:LoadSprite(string.format(AL_FLAG_SPRITE_PATH, string.IsNullOrEmpty(self.blueAlly.icon) and 1 or self.blueAlly.icon))
  self.redFlag:LoadSprite(string.format(AL_FLAG_SPRITE_PATH, string.IsNullOrEmpty(self.redAlly.icon) and 1 or self.redAlly.icon))
  if self.blueAlly.allianceId == LuaEntry.Player.allianceId then
    self.blueName:SetColor(Color.New(0, 0.96, 1, 1))
  else
    self.blueName:SetColor(WhiteColor)
  end
  if self.redAlly.allianceId == LuaEntry.Player.allianceId then
    self.redName:SetColor(Color.New(0, 0.96, 1, 1))
  else
    self.redName:SetColor(WhiteColor)
  end
end

function AllyDuelLeagueHistoryItem:OnClick(index)
  local allyData = index == 1 and self.blueAlly or self.redAlly
  if not string.IsNullOrEmpty(allyData.allianceId) then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIAllianceDetail, {anim = true}, allyData.alName, allyData.allianceId)
  end
end

function AllyDuelLeagueHistoryItem:Focus()
  self.anim:Rewind("Select")
  self.anim:Play("Select")
end

return AllyDuelLeagueHistoryItem
