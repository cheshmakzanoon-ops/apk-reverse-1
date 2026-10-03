local WS_MvpCell = BaseClass("WS_MvpCell", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local QuickGiftBtnCom = require("UI.LWPlayerInfo.UILWGiftSystem.Common.QuickGiftBtnCom")
local ICON_CNT = 3

function WS_MvpCell:OnCreate()
  base.OnCreate(self)
  self.img_bg = self:AddComponent(UIRawImage, "ImgBg/ImgBg_1")
  self.img_top = self:AddComponent(UIImage, "ImgBg/ImgTop")
  self.btn_top = self:AddComponent(UIButton, "ImgBg/ImgTop")
  self.btn_top:SetOnClick(BindCallback(self, self.OnClickMvpBtn))
  self.eff_gold = self:AddComponent(UIBaseComponent, "ImgBg/ImgTop/node_eff_quality/eff_gold")
  self.eff_purple = self:AddComponent(UIBaseComponent, "ImgBg/ImgTop/node_eff_quality/eff_purple")
  self.text_title = self:AddComponent(UIText, "ImgBg/TitleText")
  self.icon = self:AddComponent(UIPlayerHead, "Head/UIPlayerHead/HeadIcon")
  self.btn = self:AddComponent(UIButton, "Head/UIPlayerHead")
  self.btn:SetOnClick(BindCallback(self, self.OnClickInfoBtn))
  self.text_name = self:AddComponent(UIText, "NameText")
  self.text_lv = self:AddComponent(UIText, "LvText")
  self.layout = self:AddComponent(UIBaseComponent, "Layout")
  self.giftSendCom = self:AddComponent(QuickGiftBtnCom, "giftSendCom")
  self.icons = {}
  for i = 1, ICON_CNT do
    self.icons[i] = self:AddComponent(UIImage, "Layout/Icon" .. i)
  end
  self.arrow = self:AddComponent(UIBaseComponent, "Layout/Arrow")
  self.btnMore = self:AddComponent(UIButton, "Layout/BtnMore")
  self.btnMore:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    if table.IsNullOrEmpty(self.achievements) then
      return
    end
    EventManager:GetInstance():Broadcast(EventId.WinterStormResultAchievementShow, self.playerUid)
  end)
end

function WS_MvpCell:OnDestroy()
  self.achievements = nil
  self.img_bg = nil
  self.img_top = nil
  self.btn_top = nil
  self.eff_gold = nil
  self.eff_purple = nil
  self.text_title = nil
  self.icon = nil
  self.btn = nil
  self.text_name = nil
  self.text_lv = nil
  self.layout = nil
  self.icons = nil
  self.arrow = nil
  self.btnMore = nil
  base.OnDestroy(self)
end

function WS_MvpCell:OnClickMvpBtn()
  if not string.IsNullOrEmpty(self.mvpDesc) then
    UIUtil.ShowBubbleTips(self.mvpDesc, self.btn_top.transform.position, 0, -30, 0)
  end
end

function WS_MvpCell:OnClickInfoBtn()
  if self.playerUid ~= nil and self.playerUid ~= 0 then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UILWPlayerDetail, {anim = true, hideTop = false}, self.playerUid)
  end
end

function WS_MvpCell:ReInit(teamArr, showAchievement)
  self.playerUid = teamArr ~= nil and teamArr.uid or nil
  local mvpId = teamArr ~= nil and teamArr.mvpId or 0
  self.mvpId = mvpId
  local tbName = DataCenter.ActWinterStormManager:GetCfgValue(BattleFieldTableKey.STAR)
  local line = 0 < mvpId and LocalController:instance():getLine(tbName, mvpId) or nil
  if line then
    local icon = line:getValue("icon")
    self.img_top:LoadSpriteAsyncWithCallback(string.format(LoadPath.LWBattleFieldMvpPath, icon), function()
      if self.img_top then
        self.img_top:SetNativeSize()
      end
    end)
    self.btn_top:SetActive(true)
    local name = line:getValue("name")
    self.text_title:SetLocalText(name)
    self.text_title:SetActive(true)
    self.mvpDesc = Localization:GetString(line:getValue("desc"), line:getValue("score"))
    local rank = line:getIntValue("rank")
    self.eff_gold:SetActive(rank == 1)
    self.eff_purple:SetActive(rank ~= 1)
  else
    self.btn_top:SetActive(false)
    self.text_title:SetActive(false)
    self.mvpDesc = nil
    self.eff_gold:SetActive(false)
    self.eff_purple:SetActive(false)
  end
  local mySide = DataCenter.ActWinterStormManager:GetMySide()
  local side = teamArr ~= nil and teamArr.side or 0
  local bgName = mySide == side and "Battle/lrb_dongjifengbao_chenghao05.png" or "Battle/lrb_dongjifengbao_chenghao04.png"
  self.img_bg:LoadSpriteAuto(string.format(LoadPath.LWBattleFieldWinterTexturePath, bgName))
  self.giftSendCom:ReInit(teamArr.uid, GiftSystemConst.GiftSendPanelType.Winter)
  if teamArr then
    self.icon:SetData(teamArr.uid, teamArr.head, teamArr.frame)
    local name = UIUtil.FormatAllianceAndName(teamArr.allianceName, teamArr.name)
    self.text_name:SetText(name)
    local flag = showAchievement
    flag = flag and self:RefreshAchievement(teamArr)
    self.text_lv:SetActive(not flag)
    self.layout:SetActive(flag)
    if not flag then
      self.text_lv:SetLocalText(140002, teamArr.lv)
    end
    if teamArr.uid == LuaEntry.Player:GetUid() then
      self.text_name:SetColorRGBA255(95, 239, 135, 255)
    elseif mySide == side then
      self.text_name:SetColorRGBA255(45, 253, 255, 255)
    else
      self.text_name:SetColorRGBA255(255, 255, 255, 255)
    end
  end
end

function WS_MvpCell:RefreshAchievement(teamArr)
  self.achievements = teamArr.achievement or {}
  local cnt = #self.achievements
  if cnt == 0 then
    return false
  end
  self.arrow:SetActive(cnt > ICON_CNT)
  self.btnMore:SetActive(0 < cnt)
  for i, icon in ipairs(self.icons) do
    local acId = self.achievements[i]
    icon:SetActive(acId ~= nil)
    if acId ~= nil then
      local iconName = LocalController:instance():getValue(TableName.LW_BattleField_Achievement, acId, "icon")
      if not string.IsNullOrEmpty(iconName) then
        icon:LoadSpriteAuto(string.format(LoadPath.LWBattleFieldWinterAchievementPath, iconName))
      end
    end
  end
  return true
end

return WS_MvpCell
