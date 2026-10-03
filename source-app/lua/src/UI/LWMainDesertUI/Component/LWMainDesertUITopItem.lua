local LWMainDesertUITopItem = BaseClass("LWMainDesertUITopItem", UIBaseContainer)
local base = UIBaseContainer
local BuffIcon = require("UI.LWMainUI.Component.UIMainLeft.BuffIcon")
local power_path = "Power"
local text_power_path = "Power/TextPower"
local coin_path = "Coin"
local text_coin_path = "Coin/TextCoin"
local buff_path = "Buff"
local btn_buff_path = "Buff/BtnBuff"

function LWMainDesertUITopItem:OnCreate()
  base.OnCreate(self)
  self.btnPower = self:AddComponent(UIButton, power_path)
  self.btnPower:SetOnClick(function()
    if self.soldierInfo and self.soldierInfo.id then
      UIManager:GetInstance():OpenWindow(UIWindowNames.UIDesertBattleSoldierTip, {anim = true}, self.soldierInfo)
    end
  end)
  self.text_power = self:AddComponent(UIText, text_power_path)
  self.btnCoin = self:AddComponent(UIButton, coin_path)
  self.text_coin = self:AddComponent(UIText, text_coin_path)
  self.buff_content = self:AddComponent(UIButton, buff_path)
  self.btn_buff = self:AddComponent(UIBaseContainer, btn_buff_path)
  self.buff_content:SetOnClick(function()
    UIManager:GetInstance():OpenWindow(UIWindowNames.UILWCityBuff, {anim = true})
  end)
  self.btnCoin:SetOnClick(function()
    UIManager:GetInstance():OpenWindow(UIWindowNames.LWBuyDiamond, {anim = true}, WelfareTagType.DiamondShop)
  end)
  self:RefreshBuff()
  self:OnResourceUpdated()
end

function LWMainDesertUITopItem:OnDestroy()
  self.soldierInfo = nil
  self:DestroyBuff()
  base.OnDestroy(self)
end

function LWMainDesertUITopItem:OnEnable()
  base.OnEnable(self)
  self:OnResourceUpdated()
  self:OnHospitalUpdate()
end

function LWMainDesertUITopItem:OnDisable()
  base.OnDisable(self)
end

function LWMainDesertUITopItem:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.UpdateGold, self.OnResourceUpdated)
  self:AddUIListener(EventId.PlayerPowerInfoUpdated, self.OnResourceUpdated)
  self:AddUIListener(EventId.LuaEntryEffectRefreshStatus, self.RefreshBuff)
  self:AddUIListener(EventId.AllianceBaseDataUpdated, self.OnAllianceUpdated)
  self:AddUIListener(EventId.HospitalUpdate, self.OnHospitalUpdate)
end

function LWMainDesertUITopItem:OnRemoveListener()
  self:RemoveUIListener(EventId.UpdateGold, self.OnResourceUpdated)
  self:RemoveUIListener(EventId.PlayerPowerInfoUpdated, self.OnResourceUpdated)
  self:RemoveUIListener(EventId.LuaEntryEffectRefreshStatus, self.RefreshBuff)
  self:RemoveUIListener(EventId.AllianceBaseDataUpdated, self.OnAllianceUpdated)
  self:RemoveUIListener(EventId.HospitalUpdate, self.OnHospitalUpdate)
  base.OnRemoveListener(self)
end

function LWMainDesertUITopItem:OnResourceUpdated()
  self.text_coin:SetText(string.GetFormattedGoldNum(LuaEntry.Player.gold))
end

function LWMainDesertUITopItem:OnAllianceUpdated()
  if not LuaEntry.Player:IsInAlliance() then
    DataCenter.ActDragonManager:ReqLevelDragonWorld()
    UIUtil.PlayCutSceneAnim(function()
      CrossServerUtil.OnBackSelfServerFromDragonWorld()
      SceneUtils.ChangeToCity(function()
        LuaEntry.Player:SetBattleFieldPointId(-1)
        UIUtil.ShowTipsId(302045)
      end)
    end, nil, LuaEntry.Player:GetSelfServerId())
  end
end

function LWMainDesertUITopItem:RefreshBuff()
  self:DestroyBuff()
  local buffs = DataCenter.WarFlagDataManager:GetAllFlagAffectMe()
  self.buffIcons = {}
  if buffs ~= nil then
    local count = table.length(buffs)
    self.btn_buff:SetActive(5 < count)
    count = math.min(5, count)
    for i = 1, count do
      self.buffIcons[i] = self:GameObjectInstantiateAsync(UIAssets.BuffIcon, function(request)
        if request.isError then
          return
        end
        local go = request.gameObject
        go.gameObject:SetActive(true)
        go.transform:SetParent(self.buff_content.transform)
        go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
        go.name = "BuffIcon" .. i
        local cell = self.buff_content:AddComponent(BuffIcon, go.name)
        cell:ReInit(buffs[i])
      end)
    end
    if count < 5 then
      local dragonEffectList = BattleFieldUtil.GetEffectListWithInfo()
      if dragonEffectList and 0 < #dragonEffectList then
        for _, info in ipairs(dragonEffectList) do
          self.buffIcons[info.id] = self:GameObjectInstantiateAsync(UIAssets.BuffIcon, function(request)
            if request.isError then
              return
            end
            local go = request.gameObject
            go.gameObject:SetActive(true)
            go.transform:SetParent(self.buff_content.transform)
            go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
            go.name = "BuffIcon" .. info.id
            local cell = self.buff_content:AddComponent(BuffIcon, go.name)
            cell:ReInit({
              meta = {
                icon = info.effect_icon
              }
            })
          end)
          count = count + 1
          if 6 < count then
            self.btn_buff:SetActive(false)
            break
          end
        end
      end
    end
  else
    self.btn_buff:SetActive(false)
  end
end

function LWMainDesertUITopItem:DestroyBuff()
  self.buff_content:RemoveComponents(BuffIcon)
  if self.buffIcons ~= nil then
    for _, v in pairs(self.buffIcons) do
      if v ~= nil then
        self:GameObjectDestroy(v)
      end
    end
    self.buffIcons = nil
  end
end

function LWMainDesertUITopItem:OnHospitalUpdate()
  local info = BattleFieldUtil.GetSoldiersInfo()
  if info.id then
    self.soldierInfo = info
    self.text_power:SetText(string.GetFormattedStr(info.count + info.finishSoldierNum) .. "/" .. string.GetFormattedStr(info.total))
  else
    self.soldierInfo = nil
    self.text_power:SetText(0)
  end
end

return LWMainDesertUITopItem
