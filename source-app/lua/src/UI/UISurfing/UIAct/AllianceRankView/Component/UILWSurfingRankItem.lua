local base = UIBaseContainer
local UILWSurfingRankItem = BaseClass("UILWSurfingRankItem", UIBaseContainer)
local Localization = CS.GameEntry.Localization

function UILWSurfingRankItem:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UILWSurfingRankItem:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UILWSurfingRankItem:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.imgBg = self.viewSkin:AddComponent(self, UIImage, 1)
  self.imgFirst = self.viewSkin:AddComponent(self, UIImage, 2)
  self.imgRank = self.viewSkin:AddComponent(self, UIImage, 3)
  self.textNum = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 4)
  self.textName = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 5)
  self.textServer = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 6)
  self.textPower = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 7)
  self.uIPlayerHead = self.viewSkin:AddComponent(self, UICommonHead, 8)
  self.uIPlayerHead:SetEnableClickShowInfo(true)
  self.textNormalNum = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 9)
end

function UILWSurfingRankItem:ComponentDestroy()
  self.viewSkin = nil
  self.imgBg = nil
  self.imgFirst = nil
  self.imgRank = nil
  self.textNum = nil
  self.textName = nil
  self.textServer = nil
  self.textPower = nil
  self.uIPlayerHead = nil
  self.textNormalNum = nil
end

function UILWSurfingRankItem:DataDefine()
end

function UILWSurfingRankItem:DataDestroy()
end

function UILWSurfingRankItem:OnAddListener()
  base.OnAddListener(self)
end

function UILWSurfingRankItem:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UILWSurfingRankItem:SetItemShow(rankType, showInfo, isSelf)
  local bgPath = "Assets/Main/Sprites/UI/UIRank/ljq_tongyong_paihangbang_4.png"
  local isFirst = false
  if showInfo and showInfo.name and showInfo.abbr then
    self.textName:SetText(UIUtil.FormatAllianceAndName(showInfo.abbr, showInfo.name))
  end
  if isSelf then
    local allName = LuaEntry.Player.name
    if LuaEntry.Player:IsInAlliance() then
      local allInfo = DataCenter.AllianceBaseDataManager:GetAllianceBaseData()
      allName = UIUtil.FormatAllianceAndName(allInfo.abbr, LuaEntry.Player.name)
    end
    self.textName:SetText(allName)
    isFirst = false
    self.imgFirst.gameObject:SetActive(false)
    bgPath = "Assets/Main/Sprites/UI/UIRank/zyf_paihangban_lvsetiao.png"
  elseif showInfo.rank == 1 then
    isFirst = true
    bgPath = "Assets/Main/Sprites/UI/UIRank/ljq_tongyong_paihangbang_1.png"
  elseif showInfo.rank == 2 then
    isFirst = true
    bgPath = "Assets/Main/Sprites/UI/UIRank/ljq_tongyong_paihangbang_2.png"
  elseif showInfo.rank == 3 then
    isFirst = true
    bgPath = "Assets/Main/Sprites/UI/UIRank/ljq_tongyong_paihangbang_3.png"
  end
  if isSelf then
    self.uIPlayerHead:SetAsMyself()
  else
    self.uIPlayerHead:SetHead(showInfo.uid, showInfo.pic, showInfo.picver)
  end
  if isFirst then
    self.imgFirst.gameObject:SetActive(true)
    self.textNormalNum.gameObject:SetActive(false)
    self.imgFirst:LoadSprite(bgPath)
    self.textNum:SetText(showInfo.rank)
    self.imgRank:LoadSprite(NewRankIconPath[showInfo.rank])
  else
    self.imgFirst.gameObject:SetActive(false)
    self.textNormalNum.gameObject:SetActive(true)
    self.imgBg:LoadSprite(bgPath)
    if showInfo.rank < 1 then
      self.textNormalNum:SetLocalText("challenge_zombie_no_rank")
    else
      self.textNormalNum:SetText(showInfo.rank)
    end
  end
  self.textPower:SetText(showInfo.score)
end

return UILWSurfingRankItem
