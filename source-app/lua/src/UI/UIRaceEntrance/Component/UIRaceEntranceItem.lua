local base = UIAsyncContainer
local UIRaceEntranceItem = BaseClass("UIRaceEntranceItem", base)
local UIRaceEntranceIcon = require("UI.UIRaceEntrance.Component.UIRaceEntranceIcon")
local Localization = CS.GameEntry.Localization
local img_extra_path = "ImgExtra"
local lang_content_path = "LangContent"
local name_text_path = "LangContent/NameText"
local tip_text_path = "LangContent/TipText"
local main_path = "LangContent/Main"
local lock_path = "LangContent/Main/Lock"
local main_text_path = "LangContent/Main/MainText"
local tip2_text_path = "LangContent/Tip2Text"
local info_btn_path = "InfoBtn"
local enter_btn_path = "EnterBtn"
local btn_name_path = "EnterBtn/BtnName"
local icon_content_path = "IconContent"
local item_path = "Item"
local new_path = "New"
local ICON_PATH = "Assets/Main/Sprites/UI/UIRaceEntrance/%s"
local cant_click_mask_path = "CantClickMask"
local mask_text_path = "CantClickMask/MaskText"
local mask_name_text_path = "CantClickMask/MaskNameText"

function UIRaceEntranceItem:OnCreate()
  base.OnCreate(self)
  self.lastReqTime = 0
  self.btn = self:AddComponent(UIButton, "")
  self.btn:SetOnClick(BindCallback(self, self.OnClick))
  self.img_extra = self:AddComponent(UIRawImage, img_extra_path)
  self.lang_content = self:AddComponent(UIBaseContainer, lang_content_path)
  self.name_text = self:AddComponent(UITextMeshProUGUIEx, name_text_path)
  self.tip_text = self:AddComponent(UITextMeshProUGUIEx, tip_text_path)
  self.main = self:AddComponent(UIBaseContainer, main_path)
  self.lock = self:AddComponent(UIImage, lock_path)
  self.main_text = self:AddComponent(UITextMeshProUGUIEx, main_text_path)
  self.tip2_text = self:AddComponent(UITextMeshProUGUIEx, tip2_text_path)
  self.info_btn = self:AddComponent(UIButton, info_btn_path)
  self.info_btn:SetOnClick(BindCallback(self, self.OnInfoClick))
  self.enter_btn = self:AddComponent(UIButton, enter_btn_path)
  self.enter_btn:SetOnClick(BindCallback(self, self.OnBtnClick))
  self.btn_name = self:AddComponent(UITextMeshProUGUIEx, btn_name_path)
  self.icon_content = self:AddComponent(UIBaseContainer, icon_content_path)
  self.theItem = self.transform:Find(item_path).gameObject
  self.theItem:GameObjectCreatePool()
  self.new = self:AddComponent(UIImage, new_path)
  self.cant_click_mask = self:AddComponent(UIImage, cant_click_mask_path)
  self.mask_text = self:AddComponent(UITextMeshProUGUIEx, mask_text_path)
  self.mask_text:SetLocalText("dsb_duel_interface_1060")
  self.mask_name_text = self:AddComponent(UITextMeshProUGUIEx, mask_name_text_path)
end

function UIRaceEntranceItem:OnDestroy()
  self:CleanIcon()
  self.lastReqTime = 0
  self.img_extra = nil
  self.lang_content = nil
  self.name_text = nil
  self.tip_text = nil
  self.main = nil
  self.lock = nil
  self.main_text = nil
  self.tip2_text = nil
  self.info_btn = nil
  self.enter_btn = nil
  self.btn_name = nil
  self.icon_content = nil
  self.theItem = nil
  self.new = nil
  self.template = nil
  self.endTime = 0
  self.curIdx = 0
  self.cant_click_mask = nil
  self.mask_text = nil
  self.mask_name_text = nil
  base.OnDestroy(self)
end

function UIRaceEntranceItem:GetLockTipStr()
  if self.template == nil then
    return ""
  end
  local tipStr
  if self.template.type == EnumActivity.ActMeteorite.Type then
    tipStr = Localization:GetString("battlefield_entrance_tips1006")
  elseif self.template.season ~= 0 then
    tipStr = Localization:GetString("battlefield_entrance_tips1001", self.template.season, self.template.week)
  else
    tipStr = Localization:GetString("battlefield_entrance_tips1002", self.template.week)
  end
  return tipStr
end

function UIRaceEntranceItem:OnClick()
  DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
  if self.template == nil then
    return
  end
  local bCross = self.view:CheckBCross(self.template)
  if bCross then
    UIUtil.ShowTipsId("battlefield_entrance_ui1012")
    return
  end
  local state = self.template.state or 0
  if state == RaceEntranceUtil.OpenSate.Lock then
    local tipStr = self:GetLockTipStr()
    UIUtil.ShowTips(tipStr)
    return
  end
  if state <= RaceEntranceUtil.OpenSate.Coming then
    UIUtil.ShowTipsId("battlefield_entrance_ui1002")
    return
  end
  if state == RaceEntranceUtil.OpenSate.Open then
    self.view:OpenActivity(self.template.type)
  end
end

function UIRaceEntranceItem:OnBtnClick()
  DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
  if self.template == nil then
    return
  end
  local actType = self.template.type
  if actType == EnumActivity.ActDragon.Type then
    if self.curIdx == 4 then
      DataCenter.ActDragonManager:TryEnterBattlefield()
      return
    end
  elseif actType == EnumActivity.ActWinterStorm.Type then
    if self.curIdx == 3 then
      DataCenter.ActWinterStormManager:SendMatch()
      return
    elseif self.curIdx == 4 then
      DataCenter.ActWinterStormManager:SendMatchCancel()
      return
    elseif self.curIdx == 5 then
      DataCenter.ActWinterStormManager:TryEnterBattlefield()
      return
    end
  elseif actType == EnumActivity.ActMeteorite.Type then
    if self.curIdx == 2 then
      DataCenter.ActMeteoriteBattleManager:DoPointJump()
      return
    end
  elseif actType == EnumActivity.ActEpidemic.Type then
    if self.curIdx == 4 then
      DataCenter.ActEpidemicZoneManager:TryEnterBattlefield()
      return
    end
  elseif actType == EnumActivity.ActDsbDuel.Type and self.curIdx == BattlefieldDsbConst.BF_DSB_SMALL_PHASE_INDEX.TeamBattle then
    BattlefieldDsbDuelUtils.ActInfo:TryEnterBattle()
    return
  end
  self.view:OpenActivity(self.template.type)
end

function UIRaceEntranceItem:OnInfoClick()
  DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
  if self.template == nil then
    return
  end
  local strTip = Localization:GetString(self.template.desc)
  local pos = self.info_btn.transform.position
  local reversal = pos.y < Screen.height / 4
  local num = reversal and 30 or -30
  UIUtil.ShowBubbleTips(strTip, self.info_btn.transform.position, 0, num, 0, nil, nil, {reversal = reversal})
end

function UIRaceEntranceItem:CleanIcon()
  self.icon_content:RemoveComponents(UIRaceEntranceIcon)
  self.theItem:GameObjectRecycleAll()
end

function UIRaceEntranceItem:RefreshData(template)
  self.template = template
  self:RefreshView()
end

function UIRaceEntranceItem:UpdateData()
  if self.template == nil then
    return
  end
  local template = self.template
  self.endTime = 0
  self.curIdx = 0
  local OpenSate = RaceEntranceUtil.OpenSate
  local state = template.state or 0
  local actType = template.type
  if actType == EnumActivity.ActDsbDuel.Type then
    BattlefieldDsbDuelUtils.ActInfo:SendActPlayerListMsg()
  end
  local bCross = self.view:CheckBCross(template)
  local keyStr = GetTableData(TableName.Activity, template.activity_id, "name")
  self.name_text:SetLocalText(keyStr)
  self.mask_name_text:SetLocalText(keyStr)
  self.tip_text:SetActive(state >= OpenSate.Coming and not bCross)
  self.tip2_text:SetActive(state < OpenSate.Coming and not bCross)
  self.lock:SetActive(state == OpenSate.Lock or bCross)
  self.icon_content:SetActive(state >= OpenSate.Coming and not bCross)
  if self.icon_content:GetActive() then
    CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.icon_content.rectTransform)
  end
  self.enter_btn:SetActive(state == OpenSate.Open and not bCross)
  local bNew = RaceEntranceUtil.IsNewOrUnlock(template)
  self.new:SetActive(bNew)
  if bCross then
    self.main_text:SetLocalText("battlefield_entrance_ui1012")
  elseif template.state == OpenSate.Lock then
    self.main_text:SetLocalText("battlefield_entrance_ui1003")
    local tipStr = self:GetLockTipStr()
    self.tip2_text:SetText(tipStr)
  elseif template.state == OpenSate.UnLock then
    self.main_text:SetLocalText("battlefield_entrance_ui1002")
    self.tip2_text:SetLocalText(template.oping_soon_desc)
  elseif template.state == OpenSate.Coming then
    self.tip_text:SetLocalText("battlefield_entrance_ui1001")
    self.endTime = template.comingTime
    if self.endTime == nil or self.endTime == 0 then
      self.main_text:SetText("battlefield_entrance_ui1002")
    end
    self:CleanIcon()
    for i, v in ipairs(template.icons) do
      self:CreateIcon(i, string.format(ICON_PATH, v), template.icons_desc[i])
    end
  elseif template.state == OpenSate.Open then
    local idx, tipKey, endTime, btnKey = RaceEntranceUtil.GetOpenShow(actType)
    self.btn_name:SetLocalText(btnKey)
    self.curIdx = idx
    self.endTime = endTime
    if endTime == nil or endTime == 0 then
      self.main_text:SetText("")
    end
    self.tip_text:SetLocalText(tipKey)
    self:CleanIcon()
    for i, v in ipairs(template.rewards) do
      self:CreateIcon(i, string.format(LoadPath.ItemPath, v[1]), toInt(v[2]), actType)
    end
  end
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.main.rectTransform)
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.lang_content.rectTransform)
  local idx = (bCross or template.state < OpenSate.Coming) and 2 or 1
  self.img_extra:LoadSpriteAsync(string.format("%s%d%s", template.bg, idx, "_banner"))
  self:CheckDsbActMask()
  self:Update1000MS()
end

function UIRaceEntranceItem:CheckDsbActMask()
  local showMask = self.template.type == EnumActivity.ActDragon.Type and BattlefieldDsbDuelUtils.ActInfo:CheckIfActOpen() and not string.IsNullOrEmpty(LuaEntry.Player.allianceId) and BattlefieldDsbDuelUtils.ActInfo:IsRegistered() and BattlefieldDsbDuelUtils.ActInfo:IsInBattlePhase()
  self.cant_click_mask:SetActive(showMask)
  self.lang_content:SetActive(not showMask)
  self.btn:SetInteractable(not showMask)
end

function UIRaceEntranceItem:CreateIcon(i, path, desc, actType)
  local goItem = self.theItem:GameObjectSpawn(self.icon_content.transform)
  goItem.name = "icon_" .. i
  goItem:SetActive(true)
  local item = self.icon_content:AddComponent(UIRaceEntranceIcon, goItem.name)
  item:RefreshData(path, desc, actType)
end

function UIRaceEntranceItem:Update1000MS()
  if self.endTime == nil or self.endTime == 0 then
    return
  end
  local curSec = UITimeManager:GetInstance():GetServerSeconds()
  local remainTime = self.endTime - curSec
  if remainTime <= 0 then
    remainTime = 0
    if self.lastReqTime == 0 or curSec - self.lastReqTime > 5 then
      self.lastReqTime = curSec
      RaceEntranceUtil.ReqTimeInfo()
      RaceEntranceUtil.ReqActInfo(self.template.type)
    end
  end
  self.main_text:SetText(UITimeManager:GetInstance():SecondToFmtString(remainTime))
end

function UIRaceEntranceItem:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.DsbDuelActTimePhaseChange, self.CheckDsbActMask)
end

function UIRaceEntranceItem:OnRemoveListener()
  base.OnRemoveListener(self)
  self:RemoveUIListener(EventId.DsbDuelActTimePhaseChange, self.CheckDsbActMask)
end

return UIRaceEntranceItem
