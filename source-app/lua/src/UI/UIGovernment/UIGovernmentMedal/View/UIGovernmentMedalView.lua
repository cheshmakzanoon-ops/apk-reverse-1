local UIGovernmentMedalView = BaseClass("UIGovernmentMedalView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local UIGovernmentMedalItem = require("UI.UIGovernment.UIGovernmentMedal.Component.UIGovernmentMedalItem")
local text_title_path = "Root/TopBar/TextTitle"
local btn_effect_path = "Root/BottomBar/BtnEffect"
local btn_back_path = "Root/BottomBar/BtnBack"
local item_count_path = "Root/BottomBar/BtnEffect/item/itemCount"
local cell_path = "Root/Bg/Content/PackList/Viewport/FlagCell"
local content_path = "Root/Bg/Content/PackList/Viewport/Content"
local info_root_path = "Root/Bg/Content/InfoRoot"
local desc_path = "Root/Bg/Content/InfoRoot/desc"
local icon_path = "Root/Bg/Content/InfoRoot/bg/icon"
local king_path = "Root/Bg/Content/InfoRoot/bg/king"
local title_path = "Root/Bg/Content/InfoRoot/bg/king/title"
local player_path = "Root/Bg/Content/InfoRoot/bg/king/player"
local power_path = "Root/Bg/Content/InfoRoot/bg/king/power"
local kill_path = "Root/Bg/Content/InfoRoot/bg/king/kill"
local name_path = "Root/Bg/Content/InfoRoot/bg/king/name"
local noking_path = "Root/Bg/Content/InfoRoot/bg/noking"

function UIGovernmentMedalView:OnCreate()
  base.OnCreate(self)
  self.curIdx = nil
  self.curFlag = nil
  self.serverId = LuaEntry.Player:GetSourceServerId()
  self:ComponentDefine()
  self:UpdateData()
end

function UIGovernmentMedalView:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIGovernmentMedalView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.KingdomBadgesInfoRefresh, self.UpdateData)
  self:AddUIListener(EventId.KingdomBadgesInfoUpdate, self.RefreshStatus)
end

function UIGovernmentMedalView:OnRemoveListener()
  self:RemoveUIListener(EventId.KingdomBadgesInfoRefresh, self.UpdateData)
  self:RemoveUIListener(EventId.KingdomBadgesInfoUpdate, self.RefreshStatus)
  base.OnRemoveListener(self)
end

function UIGovernmentMedalView:ComponentDefine()
  self.text_title = self:AddComponent(UIText, text_title_path)
  self.text_title:SetLocalText("801487")
  self.btn_back = self:AddComponent(UIButton, btn_back_path)
  self.btn_back:SetOnClick(BindCallback(self.ctrl, self.ctrl.CloseSelf))
  self.btn_effect = self:AddComponent(UIButton, btn_effect_path)
  self.btn_effect:SetOnClick(function()
    self:TrySetKingdomBadges()
  end)
  self.btn_effect:SetSafeClickMode(true)
  self.content = self:AddComponent(UIBaseContainer, content_path)
  self.item_count = self:AddComponent(UIText, item_count_path)
  local changeMedal = LuaEntry.DataConfig:TryGetNum("wonder_zone_war", "k6", 500)
  self.item_count:SetText(tostring(changeMedal))
  self.theItem = self.transform:Find(cell_path).gameObject
  self.theItem:GameObjectCreatePool()
  self.info_root = self:AddComponent(UIImage, info_root_path)
  self.desc = self:AddComponent(UIText, desc_path)
  self.icon = self:AddComponent(UICommonResItem, icon_path)
  self.king = self:AddComponent(UIBaseContainer, king_path)
  self.title = self:AddComponent(UIText, title_path)
  self.player = self:AddComponent(UICommonHead, player_path)
  self.playerPower = self:AddComponent(UIText, power_path)
  self.playerKill = self:AddComponent(UIText, kill_path)
  self.playerName = self:AddComponent(UIText, name_path)
  self.player:SetEnableClickShowInfo(true, true)
  self.noKing = self:AddComponent(UIText, noking_path)
  self.info_root:SetActive(false)
end

function UIGovernmentMedalView:ComponentDestroy()
  self.content:RemoveComponents(UIGovernmentMedalItem)
  self.theItem:GameObjectRecycleAll()
  self.btn_back = nil
end

function UIGovernmentMedalView:UpdateData()
  local goItem, theItem, theActiveItem
  local dataList = DataCenter.GovernmentManager.KingdomBadges
  local itemList = {}
  self.dataList = dataList
  if dataList == nil then
  else
    self.content:RemoveComponents(UIGovernmentMedalItem)
    self.theItem:GameObjectRecycleAll()
    for i, v in ipairs(dataList) do
      local theName = "item_" .. i
      goItem = self.theItem:GameObjectSpawn(self.content.transform)
      goItem.name = theName
      goItem:SetActive(true)
      theItem = self.content:AddComponent(UIGovernmentMedalItem, theName)
      theItem:ReInit(i, v)
      theItem:SetOnValueChanged(function(tf)
        self:OnCellClick(i, tf)
      end)
      if v.curUse == 1 then
        if self.curIdx == nil then
          self.curIdx = i
          self.curFlag = i
          CS.UIGray.SetGray(self.btn_effect.transform, true, false)
        end
        theItem:SetIsOn(true)
        theActiveItem = theItem
      end
      table.insert(itemList, theItem)
    end
  end
  if theActiveItem then
    theActiveItem:SetIsOn(true)
  end
  self.itemList = itemList
end

function UIGovernmentMedalView:OnCellClick(index, selected)
  if selected then
    local cfg = self.dataList[index]
    if cfg and cfg.sourceType == 1 then
      self.info_root:SetActive(true)
      if cfg.source == nil or cfg.source.king == nil then
        self.noKing:SetActive(true)
        self.king:SetActive(false)
      else
        local kingData = cfg.source.king
        self.noKing:SetActive(false)
        self.king:SetActive(true)
        self.title:SetLocalText(457202)
        self.player:ParseHeadInfo(kingData)
        self.playerPower:SetLocalText("151115", string.GetFormattedStr(kingData.power or 0))
        self.playerKill:SetText(Localization:GetString("100196") .. string.GetFormattedStr(kingData.armyKill or 0))
        if string.IsNullOrEmpty(kingData.abbr) then
          self.playerName:SetText(kingData.name)
        else
          self.playerName:SetText("[" .. kingData.abbr .. "]" .. kingData.name)
        end
      end
      local serverStr = "???"
      if cfg.source ~= nil and cfg.source.servers ~= nil then
        serverStr = "#" .. table.concat(cfg.source.servers, ",#")
      end
      self.desc:SetLocalText(801488, UITimeManager:GetInstance():ConvertServerTimeToLocalTime(cfg.createTime), serverStr)
      self.icon:ReInit({
        rewardType = RewardType.GOODS,
        itemId = toInt(cfg.cfgId)
      })
    else
      self.info_root:SetActive(false)
    end
    self.curIdx = index
  elseif self.curIdx == index then
    self.info_root:SetActive(false)
  end
  if self.curIdx == self.curFlag then
    CS.UIGray.SetGray(self.btn_effect.transform, true, false)
  else
    CS.UIGray.SetGray(self.btn_effect.transform, false, true)
  end
end

function UIGovernmentMedalView:RefreshStatus()
  if self.itemList then
    for i, v in ipairs(self.itemList) do
      if v then
        v:RefreshUI()
        if v.cfg and v.cfg.curUse == 1 and v.index then
          self.curFlag = v.index
        end
      end
    end
    CS.UIGray.SetGray(self.btn_effect.transform, self.curIdx == self.curFlag, self.curIdx ~= self.curFlag)
  end
end

function UIGovernmentMedalView:TrySetKingdomBadges()
  if not LuaEntry.Player:IsPresident(self.serverId) then
    UIUtil.ShowTipsId(393018)
    return
  end
  local changeMedal = LuaEntry.DataConfig:TryGetNum("wonder_zone_war", "k6", 500)
  if changeMedal > LuaEntry.Player.gold then
    UIUtil.ShowTipsId("E100001")
    return
  end
  local cfg = self.dataList[self.curIdx]
  if cfg and cfg.cfgId then
    local tips = Localization:GetString("801600", changeMedal)
    UIUtil.ShowUseDiamondConfirm(TodayNoSecondConfirmType.SetKingdomBadges, tips, 2, GameDialogDefine.CONFIRM, GameDialogDefine.CANCEL, function()
      DataCenter.GovernmentManager:SetKingdomBadges(cfg.cfgId)
    end, function()
    end, nil, nil, false, DataCenter.ResourceManager:GetResourceIconByType(ResourceType.Gold), nil)
  end
end

return UIGovernmentMedalView
