local UILWSeasonAllianceFriendMarkData = BaseClass("UILWSeasonAllianceFriendMarkData", UIBaseContainer)
local base = UIBaseContainer
local TranslateCache = {}
local translate_root_path = "bg/TranslateRoot"
local translating_path = "bg/TranslateRoot/Translating"
local translate_finish_img_path = "bg/TranslateRoot/TranslateFinishImg"
local translate_btn_path = "bg/TranslateRoot/TranslateBtn"
local translate_refresh_btn_path = "bg/TranslateRoot/TranslateRefreshBtn"

function UILWSeasonAllianceFriendMarkData:OnCreate()
  base.OnCreate(self)
  self.translate_root = self:AddComponent(UIBaseContainer, translate_root_path)
  self.translating = self:AddComponent(UIImage, translating_path)
  self.translate_finish_img = self:AddComponent(UIImage, translate_finish_img_path)
  self.translate_btn = self:AddComponent(UIButton, translate_btn_path)
  self.translate_refresh_btn = self:AddComponent(UIButton, translate_refresh_btn_path)
  self.translate_root:SetActive(true)
  self.translate_refresh_btn:SetActive(false)
  self.translate_btn:SetOnClick(function()
    self:DoTranslate()
  end)
  self.tick = self:AddComponent(UIImage, "bg/tick")
  self.icon = self:AddComponent(UIButton, "bg/icon")
  self.desc = self:AddComponent(UITextMeshProUGUIEx, "bg/desc")
  self.time = self:AddComponent(UITextMeshProUGUIEx, "bg/time")
  self.pos_btn = self:AddComponent(UIButton, "bg/PosBtn")
  self.pos_txt = self:AddComponent(UITextMeshProUGUIEx, "bg/PosBtn/PosTxt")
  self.pos_btn:SetOnClick(function()
    if self.serverId ~= nil and self.tilePos ~= nil then
      local serverId = self.serverId
      local worldPos = SceneUtils.TileToWorld(self.tilePos, ForceChangeScene.World)
      GoToUtil.CloseAllWindows()
      GoToUtil.GotoWorldPos(worldPos, CS.SceneManager.World.Zoom, 0, function()
      end, serverId)
    end
  end)
  self.icon:SetOnClick(function()
    if self.serverId ~= nil and self.tilePos ~= nil then
      local serverId = self.serverId
      local worldPos = SceneUtils.TileToWorld(self.tilePos, ForceChangeScene.World)
      GoToUtil.CloseAllWindows()
      GoToUtil.GotoWorldPos(worldPos, CS.SceneManager.World.Zoom, 0, function()
      end, serverId)
    end
  end)
end

function UILWSeasonAllianceFriendMarkData:OnDestroy()
  self.data = nil
  self.tick = nil
  self.icon = nil
  self.desc = nil
  self.time = nil
  self.translate_btn = nil
  self.pos_btn = nil
  self.pos_txt = nil
  self.translate_root = nil
  self.translating = nil
  self.translate_finish_img = nil
  self.translate_btn = nil
  self.translate_refresh_btn = nil
  base.OnDestroy(self)
end

function UILWSeasonAllianceFriendMarkData:ReInit(data)
  self.data = data
  if data == nil then
    self.tilePos = nil
    self.serverId = nil
    self:SetActive(false)
    return 0
  else
    self:SetActive(true)
    local showName = data.name
    local pointId = toInt((data.pos - data.pos % 10) / 10)
    local tilePos = SceneUtils.IndexToTilePos(pointId)
    local showPos = UIUtil.FormatServerPosition(data.server, tilePos.x, tilePos.y)
    self.tilePos = tilePos
    self.markType = data.type
    self.serverId = data.server
    self.endTime = data.startTime
    self.pos_txt:SetText(string.format("<u>#%s X:%s Y:%s</u>", data.server, tilePos.x, tilePos.y))
    if data and data.IsSelfAlliance and data:IsSelfAlliance() then
      local allianceBaseInfo = DataCenter.AllianceBaseDataManager:GetAllianceBaseData()
      if allianceBaseInfo ~= nil and allianceBaseInfo.abbr then
        showName = string.format([[
[%s]
%s]], allianceBaseInfo.abbr, showName)
      end
      self.desc:SetColorRGBA255(112, 230, 241, 255)
    else
      local allianceData = DataCenter.AllianceTempListManager:GetSearchAllianceDataByUid(data.allianceId)
      if allianceData ~= nil then
        showName = string.format([[
[%s]
%s]], allianceData.abbr, showName)
      end
      self.desc:SetColorRGBA255(45, 146, 255, 255)
    end
    self.desc:SetText(showName)
    self.translating:SetActive(false)
    self.translate_finish_img:SetActive(false)
    self.translate_btn:SetActive(true)
    self:Update1000MS()
    return 1
  end
end

function UILWSeasonAllianceFriendMarkData:Update1000MS()
  if self.endTime then
    local curTime = UITimeManager:GetInstance():GetServerTime()
    local diff = self.endTime - curTime
    if diff <= 0 then
      self.endTime = nil
      self.time:SetText("")
    else
      self.time:SetText(UITimeManager:GetInstance():MilliSecondToFmtString(diff))
    end
  end
end

function UILWSeasonAllianceFriendMarkData:DoTranslate()
  if self.data == nil then
    return
  end
  local msg = self.data.name
  if not string.IsNullOrEmpty(msg) then
    self.translating:SetActive(true)
    self.translate_finish_img:SetActive(false)
    self.translate_btn:SetActive(false)
    local markType = self.markType
    local userLang = CS.GameEntry.Localization:GetLanguage()
    ChatManager2:GetInstance().Translate:Translate(msg, "", "", function(ok, data)
      if self.data == nil or markType ~= self.markType or self.data.name ~= msg then
        return
      end
      if data ~= nil and ok == true and self.translating ~= nil and self.translate_btn ~= nil and not string.IsNullOrEmpty(data.translateMsg) then
        self.desc:SetText(data.translateMsg)
        self.translating:SetActive(false)
        self.translate_finish_img:SetActive(true)
        self.translate_btn:SetActive(false)
        if msg and TranslateCache[msg] == nil then
          TranslateCache[msg] = data.translateMsg
        end
      end
    end, userLang, nil)
  end
end

return UILWSeasonAllianceFriendMarkData
