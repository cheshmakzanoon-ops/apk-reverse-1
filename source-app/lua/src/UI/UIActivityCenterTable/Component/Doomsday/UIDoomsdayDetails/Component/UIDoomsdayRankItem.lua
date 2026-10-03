local base = UIBaseContainer
local UIDoomsdayRankItem = BaseClass("UIDoomsdayRankItem", base)
local compBook = {
  {
    path = "bgWhite",
    name = "bgWhite",
    type = nil
  },
  {
    path = "bgYellow",
    name = "bgYellow",
    type = nil
  },
  {
    path = "imgMedal",
    name = "imgMedal",
    type = UIImage
  },
  {
    path = "txtRank",
    name = "txtRank",
    type = UIText
  },
  {
    path = "txtKill",
    name = "txtKill",
    type = UIText
  },
  {
    path = "head",
    name = "head",
    type = UICommonHead
  },
  {
    path = "layoutName/txtName",
    name = "txtName",
    type = UIText
  },
  {
    path = "layoutName/gender",
    name = "gender",
    type = nil
  },
  {
    path = "layoutName/gender/female",
    name = "female",
    type = nil
  },
  {
    path = "layoutName/gender/male",
    name = "male",
    type = nil
  },
  {
    path = "layoutName",
    name = "layoutName",
    type = UIBaseContainer
  }
}

function UIDoomsdayRankItem:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self.head:SetEnableClickShowInfo(true, true)
end

function UIDoomsdayRankItem:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIDoomsdayRankItem:OnEnable()
  base.OnEnable(self)
end

function UIDoomsdayRankItem:OnDisable()
  base.OnDisable(self)
end

function UIDoomsdayRankItem:ComponentDefine()
  self:DefineCompsByBook(compBook)
end

function UIDoomsdayRankItem:ComponentDestroy()
  self:ClearCompsByBook(compBook)
end

function UIDoomsdayRankItem:Refresh(vo)
  self.bgWhite:SetActive(not vo.isSelf)
  self.bgYellow:SetActive(vo.isSelf)
  if vo.medalRes then
    self.imgMedal:SetActive(true)
    self.imgMedal:LoadSprite(vo.medalRes)
  else
    self.imgMedal:SetActive(false)
  end
  if vo.rank == 0 or vo.rank > 200 then
    self.txtRank:SetLocalText("challenge_zombie_no_rank")
  else
    self.txtRank:SetText(vo.rank)
  end
  self.txtKill:SetText(vo.killStr)
  self.head:SetHeadAndFrame(vo.uid, vo.pic, vo.picVer, false, vo.headSkinId, vo.headSkinET)
  self.txtName:SetText(vo.nameStr)
  self.gender:SetActive(vo.hasGender)
  self.female:SetActive(vo.isFemale)
  self.male:SetActive(not vo.isFemale)
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.layoutName.rectTransform)
end

return UIDoomsdayRankItem
