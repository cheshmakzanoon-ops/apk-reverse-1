local base = UIBaseContainer
local BattleMvpItem = BaseClass("BattleMvpItem", base)
local Localization = CS.GameEntry.Localization
local QuickGiftBtnCom = require("UI.LWPlayerInfo.UILWGiftSystem.Common.QuickGiftBtnCom")

function BattleMvpItem:OnCreate()
  base.OnCreate(self)
  self.dirType = nil
  self.btnBg = self:AddComponent(UIButton, "Bg")
  self.btnBg:SetOnClick(function()
    self:ShowInfoTip()
  end)
  self.textName = self:AddComponent(UITextMeshProUGUIEx, "NameText")
  self.textLv = self:AddComponent(UITextMeshProUGUIEx, "LvText")
  self.textScore = self:AddComponent(UITextMeshProUGUIEx, "ScoreText")
  self.compUIPlayerHead = self:AddComponent(UICommonHead, "Head/UIPlayerHead")
  self.giftSendCom = self:AddComponent(QuickGiftBtnCom, "giftSendCom")
  self.compUIPlayerHead:SetEnableClickShowInfo(true, true)
  self.btnLike = self:AddComponent(UIButton, "like")
  self.btnLike:SetOnClick(function()
    self:OnBtnLike()
  end)
  self.textLike = self:AddComponent(UITextMeshProUGUIEx, "like/likeCountText")
  if self.transform:Find("TypeIcon") then
    self.imgIcon = self:AddComponent(UIRawImage, "TypeIcon")
  end
  if self.transform:Find("TopText") then
    self.textTop = self:AddComponent(UITextMeshProUGUIEx, "TopText")
  end
end

function BattleMvpItem:SetGiftShowDirType(dirType)
  self.dirType = dirType
end

function BattleMvpItem:OnDestroy()
  self.imgIcon = nil
  if self.gift ~= nil then
    self:GameObjectDestroy(self.gift)
  end
  base.OnDestroy(self)
end

function BattleMvpItem:ShowInfoTip()
  if self.tipStr then
    UIUtil.ShowBubbleTips(self.tipStr, self.btnBg.transform.position, 0, -30, 0, nil, nil)
  end
end

function BattleMvpItem:OnBtnLike()
  local thePlayerUid = self.uid
  if thePlayerUid ~= nil and thePlayerUid ~= 0 and thePlayerUid ~= "system" then
    InteractiveUtil.TryThumbsUp(thePlayerUid, InteractiveUtil.ThumbsUpType.BattleField, "BattleField", function()
      UIUtil.ShowTipsId("activity_sports_uitips_017")
      self.likeNum = (self.likeNum or 0) + 1
      self.textLike:SetText(self.likeNum)
    end)
  end
end

function BattleMvpItem:ShowSendGiftBtn(isOn)
  self.giftSendCom:SetActive(isOn)
end

function BattleMvpItem:SetData(mvpData, idx)
  self.mvpData = mvpData
  if mvpData == nil then
    self:SetActive(false)
    return
  end
  self:SetActive(true)
  local playerData = mvpData.playerData
  local bSelf = false
  if mvpData.playerData then
    self.uid = playerData.uid
    bSelf = LuaEntry.Player:GetUid() == self.uid
    self.compUIPlayerHead:SetData(self.uid, playerData.pic, playerData.picVer, nil, playerData:GetHeadBgImg())
    self.textName:SetText(UIUtil.FormatAllianceAndName(playerData.abbr, playerData.name, playerData.uid))
    self.textLv:SetText(Localization:GetString(151116) .. (playerData.lv or 0))
    self.likeNum = playerData.thumbsUpCount or 0
    self.textLike:SetText(self.likeNum)
  else
    bSelf = true
    self.uid = LuaEntry.Player:GetUid()
    local userPic = LuaEntry.Player:GetPic() or ""
    local userPicVer = LuaEntry.Player.picVer or 0
    self.compUIPlayerHead:SetData(self.uid, userPic, userPicVer, nil, LuaEntry.Player:GetHeadBgImg())
    self.textName:SetText(LuaEntry.Player:GetFullName())
    self.textLv:SetText(Localization:GetString(151116) .. DataCenter.BuildManager:GetMainLevel())
  end
  self.giftSendCom:ReInit(self.uid, GiftSystemConst.GiftSendPanelType.Desert, self.dirType)
  self.btnLike:SetActive(not bSelf)
  local isCanShowGift = DataCenter.GiftSystemManager:IsCanShowQuickBtn(GiftSystemConst.GiftSendPanelType.Desert)
  self.giftSendCom:SetActive(isCanShowGift)
  local score, nameKey, descKey, extr
  if idx == 0 then
    score = mvpData.score
    local line
    local mvpId = mvpData.mvpId or 0
    if 0 < mvpId then
      local tbName = BattleFieldUtil.GetBattleFieldCfgValue(BattleFieldType.Desert, BattleFieldTableKey.STAR)
      line = LocalController:instance():getLine(tbName, mvpId)
    end
    if line ~= nil then
      local iconPath = line:getValue("icon")
      if self.imgIcon ~= nil and not string.IsNullOrEmpty(iconPath) then
        self.imgIcon:LoadSpriteAuto(iconPath, function()
          if self.imgIcon then
            self.imgIcon:SetNativeSize()
          end
        end)
      end
      nameKey = line:getValue("name")
      descKey = line:getValue("desc")
      local para = line:getValue("para")
      local tb = string.string2table_ii(para, "|", ",")
      extr = tb[2] ~= nil and tb[2][1] or nil
    end
  elseif idx == 1 then
    score = mvpData.score
    descKey = "Desert_strom_battlefield_honoraryTitle_name1120"
  elseif idx == 2 then
    score = mvpData.killScore
    nameKey = "Desert_strom_battlefield_honoraryTitle_name1117"
    descKey = nameKey
  elseif idx == 3 then
    score = mvpData.collectScore
    nameKey = "Desert_strom_battlefield_honoraryTitle_name1119"
    descKey = nameKey
  elseif idx == 4 then
    score = mvpData.occupyScore
    nameKey = "Desert_strom_battlefield_honoraryTitle_name1118"
    descKey = nameKey
  end
  self.textScore:SetText(score or 0)
  if not string.IsNullOrEmpty(descKey) then
    self.tipStr = Localization:GetString(descKey, extr)
  end
  if self.textTop and not string.IsNullOrEmpty(nameKey) then
    self.textTop:SetLocalText(nameKey)
  end
end

return BattleMvpItem
