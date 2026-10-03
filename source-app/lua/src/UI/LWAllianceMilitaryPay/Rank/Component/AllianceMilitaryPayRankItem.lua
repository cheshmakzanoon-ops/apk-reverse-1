local AllianceMilitaryPayRankItem = BaseClass("AllianceMilitaryPayRankItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization

function AllianceMilitaryPayRankItem:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
end

function AllianceMilitaryPayRankItem:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function AllianceMilitaryPayRankItem:ComponentDefine()
  self.head = self:AddComponent(UICommonHead, "head")
  self.btnHead = self:AddComponent(UIButton, "btnHead")
  self.txtName = self:AddComponent(UITextMeshProUGUIEx, "txtName")
  self.btnChat = self:AddComponent(UIButton, "btnChat")
  self.txtScore = self:AddComponent(UITextMeshProUGUIEx, "txtScore")
  self.txtOnline = self:AddComponent(UITextMeshProUGUIEx, "txtOnline")
  self.txtOffLineTime = self:AddComponent(UITextMeshProUGUIEx, "txtOffLineTime")
  self.imgRank = self:AddComponent(UIImage, "imgRank")
  self.imgBg = self:AddComponent(UIImage, "bg")
  self.btnHead:SetOnClick(function()
    self:OnClickBtnHead()
  end)
  self.btnChat:SetOnClick(function()
    self:OnClickBtnChat()
  end)
  self.txtOnline:SetLocalText(390188)
  self.txtOnline:SetActive(false)
  self.txtOffLineTime:SetActive(false)
end

function AllianceMilitaryPayRankItem:ComponentDestroy()
  self.head = nil
  self.btnHead = nil
  self.txtName = nil
  self.btnChat = nil
  self.txtScore = nil
  self.txtOnline = nil
  self.txtOffLineTime = nil
  self.imgRank = nil
  self.data = nil
  self.roleInfo = nil
  self.imgBg = nil
end

function AllianceMilitaryPayRankItem:SetData(data)
  if not data then
    return
  end
  self.data = data
  self.roleInfo = data.roleInfo
  if self.roleInfo.rank then
    self.imgRank:LoadSprite(LWAlMemberRankParam[self.roleInfo.rank].Icon)
  end
  if self.roleInfo then
    self.head:SetData(self.roleInfo.uid, self.roleInfo.headPic, self.roleInfo.headPicVer)
    local name = self.roleInfo.name
    name = UIUtil.FormatAllianceAndName(self.roleInfo.abbr, self.roleInfo.name, self.roleInfo.uid)
    self.txtName:SetText(name)
    local playerUid = LuaEntry.Player:GetUid()
    if playerUid == self.roleInfo.uid then
      self.btnChat:SetActive(false)
      self.imgBg:LoadSprite("Assets/Main/Sprites/UI/LWCommon/Sprite/FX_common_diban_lv.png")
    else
      self.btnChat:SetActive(true)
      self.imgBg:LoadSprite("Assets/Main/Sprites/UI/LWCommon/Sprite/FX_common_diban_bai.png")
    end
  end
  self.txtScore:SetText(data.score)
  local filterScore = LuaEntry.DataConfig:TryGetNum("alliance_pay_config", "k2") or 0
  if filterScore <= data.score then
    self.txtScore:SetColorHex("2A2830")
  else
    self.txtScore:SetColorHex("F53C3D")
  end
  local isOnline = self.roleInfo.offLineTime == 0
  if isOnline then
    self.txtOnline:SetActive(true)
    self.txtOffLineTime:SetActive(false)
  else
    local offLineTimeStr = self:GetOffLineTimeStr(self.roleInfo.offLineTime)
    self.txtOffLineTime:SetText(offLineTimeStr)
    self.txtOnline:SetActive(false)
    self.txtOffLineTime:SetActive(true)
  end
end

function AllianceMilitaryPayRankItem:OnClickBtnChat()
  local userInfo = {}
  userInfo.uid = self.roleInfo.uid
  userInfo.userName = self.roleInfo.name
  local data = {}
  data.privateUserInfo = userInfo
  GoToUtil.OpenChatView(true, {anim = false}, data)
end

function AllianceMilitaryPayRankItem:OnClickBtnHead()
  if self.roleInfo and self.roleInfo.uid then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UILWPlayerDetail, {anim = true}, self.roleInfo.uid)
  end
end

function AllianceMilitaryPayRankItem:GetOffLineTimeStr(offLineTime)
  local deltaTime = UITimeManager:GetInstance():GetServerTime() - offLineTime
  local str = ""
  if 86400000 < deltaTime then
    local day = math.floor(deltaTime / 86400000)
    str = Localization:GetString("390506", day)
  elseif 3600000 < deltaTime then
    local hour = math.floor(deltaTime / 3600000)
    str = Localization:GetString("390505", hour)
  elseif 60000 < deltaTime then
    local minute = math.floor(deltaTime / 60000)
    str = Localization:GetString("390504", minute)
  else
    str = Localization:GetString("390504", 1)
  end
  return str
end

return AllianceMilitaryPayRankItem
