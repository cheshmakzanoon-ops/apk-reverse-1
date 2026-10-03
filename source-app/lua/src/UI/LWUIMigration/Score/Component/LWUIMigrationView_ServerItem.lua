local LWUIMigrationView_ServerItem = BaseClass("LWUIMigrationView_ServerItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local iBasePath = "C%d"
local tBasePath = "C%d/N%d"
local iSpPath = "C5Score"
local tSpPath = "C5Score/N5Score"
local btn_path = "Btn"

function LWUIMigrationView_ServerItem:OnCreate()
  base.OnCreate(self)
  self.imgList = {}
  self.textList = {}
  self.textSp = self:AddComponent(UIText, tSpPath)
  self.btnSp = self:AddComponent(UIButton, iSpPath)
  self.btnSp:SetOnClick(function()
    DataCenter.ActMigrationManager:OpenFupinGuide()
  end)
  for i = 1, 7 do
    local path = string.format(iBasePath, i)
    self.imgList[i] = self:AddComponent(UIImage, path)
    self.textList[i] = self:AddComponent(UIText, string.format(tBasePath, i, i))
  end
  self.btn = self:AddComponent(UIButton, btn_path)
  self.btn:SetOnClick(function()
    if self.score == nil then
      return
    end
    local strTip = string.GetFormattedSeparatorNum(self.score)
    UIUtil.ShowBubbleTipsAuto(strTip, self.btn.transform.position, 0, -30, 0, nil, nil)
  end)
end

function LWUIMigrationView_ServerItem:OnDestroy()
  self.imgList = {}
  self.textList = {}
  base.OnDestroy(self)
end

function LWUIMigrationView_ServerItem:SetData(serverId, state)
  local flag = state >= ActMigrationState.Prepare
  local mgr = DataCenter.ActMigrationManager
  local sInfo = mgr:GetServerInfo(serverId)
  local strList = {}
  strList[1] = "#" .. serverId
  local score = sInfo ~= nil and sInfo.serverScore or 0
  local actInfo = mgr:GetActInfo()
  local checkScore = (actInfo ~= nil and actInfo.baseScore or 0) * 0.8
  if score < checkScore then
    strList[2] = "<" .. string.GetFormattedStr(checkScore)
    self.score = nil
  else
    strList[2] = string.GetFormattedStr(score)
    self.score = score
  end
  local sState = sInfo ~= nil and sInfo.serverState or 0
  if sState == 1 then
    strList[3] = Localization:GetString("migration_activity_interface_10039")
  elseif sState == 2 then
    strList[3] = Localization:GetString("migration_activity_interface_10040")
  elseif sState == 3 then
    strList[3] = Localization:GetString("migration_activity_interface_10111")
  end
  local zInfo = mgr:GetZoneStandard(sState)
  strList[4] = zInfo ~= nil and zInfo.superLowNum or 0
  strList[5] = zInfo ~= nil and zInfo.lowNum or 0
  strList[6] = zInfo ~= nil and zInfo.normalNum or 0
  strList[7] = zInfo ~= nil and zInfo.strongNum or 0
  local bSelf = LuaEntry.Player:GetSourceServerId() == serverId
  for i, img in ipairs(self.imgList) do
    img:SetActive(flag or i < 2)
    if img:GetActive() then
      local text = self.textList[i]
      local str = strList[i]
      text:SetText(str)
      if bSelf then
        img:SetColorRGBA255(194, 224, 194, 255)
      elseif i == 3 then
        if sState == 1 then
          img:SetColorRGBA255(240, 209, 136, 255)
        elseif sState == 2 then
          img:SetColorRGBA255(241, 169, 145, 255)
        else
          img:SetColorRGBA255(208, 201, 198, 255)
        end
      else
        img:SetColorRGBA255(226, 219, 216, 255)
      end
    end
  end
  local isFupin = sInfo ~= nil and sInfo:IsFupin()
  self.btnSp:SetActive(flag and isFupin)
  if self.btnSp:GetActive() then
    self.textSp:SetText(string.GetFormattedStr(sInfo.totalFupinScore))
  end
end

return LWUIMigrationView_ServerItem
