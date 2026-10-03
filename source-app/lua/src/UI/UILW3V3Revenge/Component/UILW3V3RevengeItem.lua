local UILW3V3RevengeItem = BaseClass("UILW3V3RevengeItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local UIGray = CS.UIGray
local compBook = {
  {
    path = "root",
    name = "root",
    type = nil
  },
  {
    path = "root/imgHead",
    name = "imgHead",
    type = UICommonHead
  },
  {
    path = "root/btnHead",
    name = "btnHead",
    type = UIButton
  },
  {
    path = "root/imgBadge/txtRank",
    name = "txtRank",
    type = UIText
  },
  {
    path = "root/txtName",
    name = "txtName",
    type = UIText
  },
  {
    path = "root/txtPower",
    name = "txtPower",
    type = UIText
  },
  {
    path = "root/vfxGlow",
    name = "vfxGlow",
    type = nil
  },
  {
    path = "root/txtTimes",
    name = "txtTimes",
    type = UITextMeshProUGUIEx
  },
  {
    path = "root/Score/ScoreText",
    name = "scoreText",
    type = UIText
  },
  {
    path = "root/revengeBtn",
    name = "revengeBtn",
    type = UIButton
  },
  {
    path = "root/revengeBtn/revengeBg",
    name = "revengeBg",
    type = UIImage
  },
  {
    path = "root/revengeBtn/revengeText",
    name = "revengeBtnText",
    type = UITextMeshProUGUIEx
  },
  {
    path = "root/revengeBtn/revengeItemText",
    name = "revengeItemText",
    type = UITextMeshProUGUIEx
  },
  {
    path = "root/revengeBtn/item",
    name = "revengeItem",
    type = UIBaseContainer
  },
  {
    path = "root/revengeBtn/item/itemCount",
    name = "revengeCostText",
    type = UITextMeshProUGUIEx
  },
  {
    path = "root/giveUpBtn",
    name = "giveUpBtn",
    type = UIButton
  },
  {
    path = "root/imgBadge",
    name = "imgBadge",
    type = UIImage
  }
}

function UILW3V3RevengeItem:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
end

function UILW3V3RevengeItem:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
  self.data = nil
end

function UILW3V3RevengeItem:ComponentDefine()
  self:DefineCompsByBook(compBook)
  self.btnHead:SetOnClick(function()
    if self.data and self.holder and self.holder.holder and self.holder.holder.RequestDefenceTeam then
      if self.data.uid == LuaEntry.Player.uid then
        self.holder.holder:RequestDefenceTeam()
      else
        self.holder.holder:RequestDefenceTeam(self.data.uid)
      end
    end
  end)
  self.rankCanvasGroup = self.txtRank.gameObject:GetComponent(typeof(CS.UnityEngine.CanvasGroup))
  self.vfxGlow:SetActive(false)
  self.revengeBtn:SetOnClick(function()
    self:OnRevengeBtnClick()
  end)
  self.giveUpBtn:SetOnClick(function()
    self:OnGiveUpBtnClick()
  end)
  local t = Localization:GetString("arena_score_001")
  self.revengeBtnText:SetText(t)
  self.revengeItemText:SetText(t)
  local cost = LuaEntry.DataConfig:TryGetNum("arena_score_settings", "k11")
  self.revengeCostText:SetText(cost)
end

function UILW3V3RevengeItem:ComponentDestroy()
  self:ClearCompsByBook(compBook)
end

function UILW3V3RevengeItem:Refresh(data, isSelf)
  self.data = data
  self.isSelf = isSelf
  local nameStr = "#" .. data.playerInfo.serverId
  if not string.IsNullOrEmpty(data.playerInfo.abbr) then
    nameStr = nameStr .. " [" .. data.playerInfo.abbr .. "]"
  end
  nameStr = nameStr .. " " .. data.playerInfo.name
  self.nameStr = nameStr
  self.txtName:SetText(nameStr)
  self.txtPower:SetText(string.GetFormattedStr(data.formationPower or data.playerInfo.power))
  local framePath = DataCenter.DecorationDataManager:GetHeadFrame(data.playerInfo.headSkinId, data.playerInfo.headSkinET, false)
  self.imgHead:SetData(data.uid, data.playerInfo.pic, data.playerInfo.picver, nil, framePath)
  self.txtRank:SetText(data.rank)
  if data.rankScale then
    self.txtRank:SetLocalScaleXYZ(data.rankScale, data.rankScale, data.rankScale)
  else
    self.txtRank:SetLocalScaleXYZ(1, 1, 1)
  end
  if data.rankAlpha then
    self.rankCanvasGroup.alpha = data.rankAlpha
  else
    self.rankCanvasGroup.alpha = 1
  end
  if data.playVfxGlow then
    data.playVfxGlow = nil
    self.vfxGlow:SetActive(false)
    self.vfxGlow:SetActive(true)
  end
  self.scoreText:SetText(data.score)
  if isSelf then
    self.revengeBtn:SetActive(false)
    self.giveUpBtn:SetActive(false)
    self.txtTimes:SetText("")
    self.imgBadge:SetEnable(false)
  else
    self.revengeBtn:SetActive(true)
    self.giveUpBtn:SetActive(true)
    local times = self.data.defeatTimes or 0
    self.txtTimes:SetText(Localization:GetString("arena_score_003", times))
    local isCost = self.data.isCost or 0
    isCost = isCost == 1
    self.revengeItem:SetActive(not isCost)
    self.revengeItemText:SetActive(not isCost)
    self.revengeBtnText:SetActive(isCost)
    if isCost then
      self.revengeBg:LoadSprite("Assets/Main/Sprites/UI/LWCommon/Sprite/cfm_tongyong_anniu_3.png")
    else
      self.revengeBg:LoadSprite("Assets/Main/Sprites/UI/LWCommon/Sprite/cfm_tongyong_anniu_4.png")
    end
    local battleTimes = DataCenter.LW3V3ArenaManager.battleTimes or 0
    UIGray.SetGray(self.revengeBtn.transform, battleTimes == 0, true)
    local badge = self.data.rank < 4
    self.imgBadge:SetEnable(badge)
    if badge then
      if self.data.rank == 1 then
        self.imgBadge:LoadSprite("Assets/Main/Sprites/UI/LWPVPArena/LRB_3v3jingjichang_paiming01.png")
      elseif self.data.rank == 2 then
        self.imgBadge:LoadSprite("Assets/Main/Sprites/UI/LWPVPArena/LRB_3v3jingjichang_paiming02.png")
      elseif self.data.rank == 3 then
        self.imgBadge:LoadSprite("Assets/Main/Sprites/UI/LWPVPArena/LRB_3v3jingjichang_paiming03.png")
      end
    end
  end
end

function UILW3V3RevengeItem:OnRevengeBtnClick()
  if self.isSelf then
    return
  end
  if not self.data then
    return
  end
  if not self.data.uid then
    return
  end
  local battleTimes = DataCenter.LW3V3ArenaManager.battleTimes or 0
  if battleTimes == 0 then
    UIUtil.ShowTips(Localization:GetString("arena_score_008"))
    return
  end
  local isCost = self.data.isCost or 0
  isCost = isCost == 1
  if isCost then
    if self.holder and self.holder.holder and self.holder.holder.RequestRevengeMatch then
      self.holder.holder:RequestRevengeMatch(self.data.uid)
    end
  else
    local cost = LuaEntry.DataConfig:TryGetNum("arena_score_settings", "k11")
    if cost == 0 then
      if self.holder and self.holder.holder and self.holder.holder.RequestRevengeMatch then
        self.holder.holder:RequestRevengeMatch(self.data.uid)
      end
      return
    end
    local content = Localization:GetString("arena_score_005", cost, self.nameStr)
    UIUtil.ShowMessage(content, 1, GameDialogDefine.CONFIRM, GameDialogDefine.CANCEL, function()
      self:OnRevengeImp()
    end)
  end
end

function UILW3V3RevengeItem:OnRevengeImp()
  if self.isSelf then
    return
  end
  if not self.data then
    return
  end
  if not self.data.uid then
    return
  end
  local cost = LuaEntry.DataConfig:TryGetNum("arena_score_settings", "k11")
  local gold = LuaEntry.Player.gold
  if cost > gold then
    GoToUtil.GotoPayTips(cost)
    return
  end
  if self.holder and self.holder.holder and self.holder.holder.RequestRevengeMatch then
    self.holder.holder:RequestRevengeMatch(self.data.uid)
  end
end

function UILW3V3RevengeItem:OnGiveUpBtnClick()
  if self.isSelf then
    return
  end
  if self.data and self.data.uid then
    local content = Localization:GetString("arena_score_006", self.nameStr)
    UIUtil.ShowMessage(content, 1, GameDialogDefine.CONFIRM, GameDialogDefine.CANCEL, function()
      self:OnGiveUpImp()
    end)
  end
end

function UILW3V3RevengeItem:OnGiveUpImp()
  if self.data and self.data.uid then
    SFSNetwork.SendMessage(MsgDefines.Arena3V3RevengeGiveUp, self.data.uid)
  end
end

return UILW3V3RevengeItem
