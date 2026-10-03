local UIChampionDuelFormation = BaseClass("UIChampionDuelFormation", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local UIChampionDuelMainCity = require("UI.UIChampionDuel.Component.UIChampionDuelMainCity")
local UIChampionDuelFormationCell = require("UI.UIChampionDuel.Component.UIChampionDuelFormationCell")
local wordBg_path = "Sign/WordBg"
local text_wordBg_path = "Sign/WordBg/DescText"
local mainCity_path = "Sign/MainCity"
local scroll_view_path = "ScrollView"
local scroll_content_path = "ScrollView/Viewport/Content"
local content_path = "ScrollView/Viewport/Content/Troop"
local arrow_path = "ScrollView/Viewport/Content/Troop/Bg/Arrow"
local inner_content_path = "ScrollView/Viewport/Content/Sign/ClickCheck"
local hero_cell_path = "UIHeroCellSmall"
local troop_cell_path = "TroopCell"
local btn_sync_path = "BtnSync"
local red_sync_path = "BtnSync/NewDot"
local text_btn_sync_path = "BtnSync/TextBtnSync"

function UIChampionDuelFormation:OnCreate()
  base.OnCreate(self)
  self.wordBg = self:AddComponent(UIBaseContainer, wordBg_path)
  self.text_wordBg = self:AddComponent(UIText, text_wordBg_path)
  self.mainCity = self:AddComponent(UIChampionDuelMainCity, mainCity_path)
  self.mainCity:SetActive(false)
  self.scroll_view = self:AddComponent(UIScrollRect, scroll_view_path)
  self.scroll_content = self:AddComponent(UIBaseContainer, scroll_content_path)
  self.content = self:AddComponent(UIBaseContainer, content_path)
  self.hero_cell = self.transform:Find(hero_cell_path)
  self.troop_cell = self.transform:Find(troop_cell_path)
  self.troopCells = {}
  self.hero_cell.gameObject:GameObjectCreatePool()
  self.troop_cell.gameObject:GameObjectCreatePool()
  for i = 1, 3 do
    local item = self.troop_cell.gameObject:GameObjectSpawn(self.content.transform)
    item.name = "item" .. i
    local obj = self.content:AddComponent(UIChampionDuelFormationCell, item.name)
    table.insert(self.troopCells, obj)
    obj:SetActive(true)
  end
  self.inner_content = self:AddComponent(UIButton, inner_content_path)
  self.inner_content:SetOnClick(BindCallback(self, self.OnAreaClick))
  self.arrow = self:AddComponent(UIButton, arrow_path)
  self.arrow:SetOnClick(BindCallback(self, self.OnArrowClick))
  self.btn_sync = self:AddComponent(UIButton, btn_sync_path)
  self.btn_sync:SetOnClick(BindCallback(self, self.OnBtnSyncClick))
  self.red_sync = self:AddComponent(UIImage, red_sync_path)
  self.text_btn_sync = self:AddComponent(UIText, text_btn_sync_path)
  self.text_btn_sync:SetLocalText("champion_duel_tips1034")
end

function UIChampionDuelFormation:OnDestroy()
  self:ClearCells()
  self.wordBg = nil
  self.text_wordBg = nil
  self.mainCity = nil
  self.scroll_view = nil
  self.scroll_content = nil
  self.content = nil
  self.hero_cell = nil
  self.troop_cell = nil
  self.inner_sign_content_path = nil
  self.inner_content = nil
  self.arrow = nil
  self.btn_sync = nil
  self.red_sync = nil
  self.text_btn_sync = nil
  base.OnDestroy(self)
end

function UIChampionDuelFormation:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.ChampionDuelFormationRefresh, self.OnFormationRefresh)
  self:AddUIListener(EventId.ChampionDuelHeroInoUpdate, self.UpdateRed)
  self:AddUIListener(EventId.ChampionDuelFormationBattleWordRefresh, self.OnBattleWordRefresh)
end

function UIChampionDuelFormation:OnRemoveListener()
  self:RemoveUIListener(EventId.ChampionDuelFormationRefresh, self.OnFormationRefresh)
  self:RemoveUIListener(EventId.ChampionDuelHeroInoUpdate, self.UpdateRed)
  self:RemoveUIListener(EventId.ChampionDuelFormationBattleWordRefresh, self.OnBattleWordRefresh)
  base.OnRemoveListener(self)
end

function UIChampionDuelFormation:OnEnable()
  base.OnEnable(self)
  DataCenter.ChampionDuelManager:SendQueryTeam()
end

function UIChampionDuelFormation:OnBtnSyncClick()
  DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
  local curTime = UITimeManager:GetInstance():GetServerTime()
  if self.lastBtnSyncClickTime == nil or curTime - self.lastBtnSyncClickTime > 1000 then
    DataCenter.ChampionDuelManager:SendSyncTeam()
    self.lastBtnSyncClickTime = curTime
  end
end

function UIChampionDuelFormation:OnAreaClick()
  if CoppaUtil.IsCoppaLimitWithTips() then
    return
  end
  local canChat = DataCenter.LWRefundPunishManager:GetCanChat()
  if not canChat then
    return
  end
  local screenPos = CS.UnityEngine.Input.mousePosition
  local worldP = CS.GameEntry.UICamera:ScreenToWorldPoint(screenPos)
  local localP = self.wordBg.transform:InverseTransformPoint(worldP)
  local rt = self.wordBg.rectTransform
  local width = rt.rect.width
  local height = rt.rect.height
  local pivot = rt.pivot
  local innerX = localP.x + width * pivot.x
  local innerY = localP.y + height * pivot.y
  if 0 < innerX and width > innerX and 0 < innerY and height > innerY then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIChampionDuelChangeBattleWord, {anim = true})
  end
end

function UIChampionDuelFormation:OnArrowClick()
  local y = self.scroll_content:GetAnchoredPositionY()
  local h1 = self.scroll_content.rectTransform.rect.height
  local h2 = self.scroll_view.rectTransform.rect.height
  local max = h1 - h2
  y = y > max * 0.9 and 0 or max
  self.scroll_view:StopMovement()
  self.scroll_content:SetAnchoredPositionXY(0, y)
end

function UIChampionDuelFormation:ReInit()
  DataCenter.ChampionDuelManager:SaveFormationTime()
  self.scroll_view:StopMovement()
  self.scroll_content:SetAnchoredPositionXY(0, 0)
end

function UIChampionDuelFormation:ClearCells()
  self.hero_cell.gameObject:GameObjectRecycleAll()
  self.content:RemoveComponents(UIChampionDuelFormationCell)
  self.troop_cell.gameObject:GameObjectRecycleAll()
  self.troopCells = {}
end

function UIChampionDuelFormation:OnFormationRefresh(uid)
  if uid ~= LuaEntry.Player:GetUid() then
    return
  end
  self:RefreshFormationCells()
end

function UIChampionDuelFormation:OnBattleWordRefresh(battleWord)
  if string.IsNullOrEmpty(battleWord) then
    battleWord = Localization:GetString("champion_duel_tips1032")
  end
  self.wordBg:SetActive(true)
  self.text_wordBg:SetText(battleWord)
end

function UIChampionDuelFormation:RefreshFormationCells()
  local teamInfo = DataCenter.ChampionDuelManager:GetMyTeamInfo()
  if teamInfo == nil then
    self.mainCity:SetActive(false)
    return
  end
  self.mainCity:ReInitWithInfo(teamInfo, "champion_duel_tips1031")
  self.mainCity:SetActive(true)
  local battleWord = teamInfo ~= nil and teamInfo.battleWord or ""
  self:OnBattleWordRefresh(battleWord)
  local teamOrder = teamInfo ~= nil and teamInfo.teamOrder or {}
  local maxOrder = 0
  for _, v in pairs(teamOrder) do
    local teamData = teamInfo:GetTeamDataByIdx(v)
    if v > maxOrder and teamData ~= nil then
      maxOrder = v
    end
  end
  for i, v in ipairs(self.troopCells) do
    local index = teamOrder[i]
    local teamData = index ~= nil and teamInfo:GetTeamDataByIdx(index) or nil
    v:RefreshData(i, maxOrder, self.hero_cell, teamData)
  end
  self:UpdateRed()
end

function UIChampionDuelFormation:UpdateRed()
  local syncCnt = DataCenter.ChampionDuelManager:CheckFormationSyncRed()
  self.red_sync:SetActive(0 < syncCnt)
end

return UIChampionDuelFormation
