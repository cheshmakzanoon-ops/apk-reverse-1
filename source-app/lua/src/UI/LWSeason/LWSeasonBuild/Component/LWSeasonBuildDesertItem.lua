local LWSeasonBuildDesertItem = BaseClass("LWSeasonBuildDesertItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local icon_path = "icon"
local title_path = "title"
local pos_path = "pos"
local server_path = "server"
local tips_path = "tips"
local tips_text_path = "tips/tipsText"
local give_up_btn_path = "giveUpBtn"
local give_up_icon_path = "giveUpBtn/GiveUpIcon"
local cancel_icon_path = "giveUpBtn/CancelIcon"
local share_btn_path = "shareBtn"
local CommandType = {
  None = 0,
  GiveUp = 1,
  CancelGiveUp = 2,
  Protect = 3
}

function LWSeasonBuildDesertItem:OnCreate()
  base.OnCreate(self)
  self.btn = self:AddComponent(UIButton, "")
  self.icon = self:AddComponent(UIImage, icon_path)
  self.title = self:AddComponent(UIText, title_path)
  self.pos = self:AddComponent(UIText, pos_path)
  self.server = self:AddComponent(UIText, server_path)
  self.tips = self:AddComponent(UIImage, tips_path)
  self.tips_text = self:AddComponent(UIText, tips_text_path)
  self.give_up_btn = self:AddComponent(UIButton, give_up_btn_path)
  self.give_up_icon = self:AddComponent(UIImage, give_up_icon_path)
  self.cancel_icon = self:AddComponent(UIImage, cancel_icon_path)
  self.share_btn = self:AddComponent(UIButton, share_btn_path)
  self.btn:SetOnClick(function()
    if self.data and self.data.pointId then
      local pos = SceneUtils.TileIndexToWorld(self.data.pointId, ForceChangeScene.World)
      local serverId = self.data.serverId
      GoToUtil.CloseAllWindows()
      GoToUtil.GotoWorldPos(pos, nil, nil, function()
      end, serverId, 0)
    end
  end)
  self.give_up_btn:SetOnClick(nil)
  self.give_up_btn:SetOnClick(function()
    self:OnCommandClick()
  end)
  self.share_btn:SetOnClick(function()
    self:OnShareClick()
  end)
  self:AddUIListener(EventId.UserDismissDesert, self.UpdateData)
  self:AddUIListener(EventId.UserCancelDismissDesert, self.UpdateData)
  self:AddUIListener(EventId.UserLostDesert, self.OnUserLostDesert)
end

function LWSeasonBuildDesertItem:OnDestroy()
  self.data = nil
  self.give_up_btn:SetOnClick(nil)
  self:RemoveUIListener(EventId.UserDismissDesert, self.UpdateData)
  self:RemoveUIListener(EventId.UserCancelDismissDesert, self.UpdateData)
  self:RemoveUIListener(EventId.UserLostDesert, self.OnUserLostDesert)
  base.OnDestroy(self)
end

function LWSeasonBuildDesertItem:OnUserLostDesert(uuid)
  if self.data and uuid == self.data.uuid then
    self.data = nil
    self:SetActive(false)
  end
end

function LWSeasonBuildDesertItem:UpdateData(uuid)
  if self.data and uuid == self.data.uuid then
    local data = DataCenter.DesertDataManager:GetSelfDesertDataByUuid(uuid)
    if data then
      self.data = data
      self:CheckStatus(data)
    end
  end
end

function LWSeasonBuildDesertItem:CheckStatus(data)
  local curTime = UITimeManager:GetInstance():GetServerTime()
  self.commandType = CommandType.None
  if data.giveUpEndTime and curTime < data.giveUpEndTime then
    self.commandType = CommandType.CancelGiveUp
    self.isUpdate = true
    self.endTime = data.giveUpEndTime
    self.tips:SetActive(true)
    self.give_up_icon:SetActive(false)
    self.cancel_icon:SetActive(true)
    self.share_btn:SetActive(false)
  elseif data.protectEndTime and curTime < data.protectEndTime then
    self.commandType = CommandType.Protect
    self.isUpdate = true
    self.endTime = data.protectEndTime
    self.tips:SetActive(true)
    self.give_up_icon:SetActive(true)
    self.cancel_icon:SetActive(false)
    self.share_btn:SetActive(false)
  else
    self.tips:SetActive(false)
    self.isUpdate = false
    self.endTime = nil
    self.commandType = CommandType.GiveUp
    self.give_up_icon:SetActive(true)
    self.cancel_icon:SetActive(false)
  end
  self.give_up_btn:SetActive(true)
  self:Update1000MS()
end

function LWSeasonBuildDesertItem:ReInit(index, data, selfServerDesert)
  local desertId = data.desertId
  local oriDesertId = data.oriDesertId
  local nameId = GetTableData(TableName.Desert, desertId, "desert_name")
  local name = Localization:GetString(nameId)
  local level = GetTableData(TableName.Desert, desertId, "desert_level")
  local is_gift = GetTableData(TableName.Desert, desertId, "is_gift")
  if oriDesertId ~= nil and oriDesertId ~= 0 and oriDesertId ~= desertId then
    is_gift = GetTableData(TableName.Desert, toInt(oriDesertId), "is_gift")
  end
  if level and 0 < level then
    name = "Lv." .. level .. " " .. name
    self.share_btn:SetActive(toInt(is_gift) == 1 and LuaEntry.Player:IsInAlliance())
  else
    name = Localization:GetString("110245")
    self.share_btn:SetActive(false)
  end
  local vecPos = SceneUtils.IndexToTilePos(data.pointId, ForceChangeScene.World)
  local str = GetTableData(TableName.Desert, desertId, "icon")
  local pic = string.format(LoadPath.SeasonDesert, str)
  self.data = data
  self.selfServerDesert = selfServerDesert
  self.title:SetText(name)
  self.icon:LoadSprite(pic)
  self.pos:SetText(string.format("x:%s,y:%s", vecPos.x, vecPos.y))
  self.server:SetText("#" .. data.serverId)
  self:CheckStatus(data)
end

function LWSeasonBuildDesertItem:Update1000MS()
  if self.isUpdate == true and self.endTime then
    local curTime = UITimeManager:GetInstance():GetServerTime()
    local deltaTime = self.endTime - curTime
    if 0 < deltaTime then
      local str = UITimeManager:GetInstance():MilliSecondToFmtString(deltaTime)
      if self.commandType == CommandType.Protect then
        self.tips_text:SetText(Localization:GetString("120092", "") .. "\n" .. str)
      elseif self.commandType == CommandType.CancelGiveUp then
        self.tips_text:SetText(Localization:GetString("300722") .. "\n" .. str)
      else
        self.tips_text:SetText(Localization:GetString("100238") .. "\n" .. str)
      end
    else
      self.tips:SetActive(false)
      self.isUpdate = false
      self.endTime = nil
    end
  end
end

function LWSeasonBuildDesertItem:OnShareClick()
  if self.data then
    SeasonUtil.ShareDesert(self.data.serverId, self.data.uuid, self.data.desertId, self.data.oriDesertId, self.data.pointId)
  end
end

function LWSeasonBuildDesertItem:OnCommandClick()
  local data = self.data
  local selfServerId = LuaEntry.Player:GetSourceServerId()
  if data == nil or data == 0 then
    return
  end
  if self.selfServerDesert and data.serverId ~= selfServerId or not self.selfServerDesert and data.serverId == selfServerId then
    return
  end
  if self.commandType == CommandType.GiveUp or self.commandType == CommandType.Protect then
    DataCenter.DesertDataManager:GiveUp(data.uuid, data.desertId, data, function()
      self.commandType = CommandType.CancelGiveUp
      self.give_up_btn:SetActive(false)
    end)
  elseif self.commandType == CommandType.CancelGiveUp then
    DataCenter.DesertDataManager:CancelGiveUp(data.uuid, data.desertId, data, function()
      self.commandType = CommandType.GiveUp
      self.give_up_btn:SetActive(false)
    end)
  end
end

return LWSeasonBuildDesertItem
