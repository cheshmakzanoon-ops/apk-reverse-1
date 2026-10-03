local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local SeasonSelectLocationGameRankItem = BaseClass("SeasonSelectLocationGameRankItem", UIBaseContainer)

function SeasonSelectLocationGameRankItem:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.compCur = self.viewSkin:AddComponent(self, UIBaseComponent, 1)
  self.textRank = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 2)
  self.textScore = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 3)
  self.imgBg = self.viewSkin:AddComponent(self, UIImage, 4)
end

function SeasonSelectLocationGameRankItem:ComponentDestroy()
  self.viewSkin = nil
  self.compCur = nil
  self.textRank = nil
  self.textScore = nil
  self.imgBg = nil
end

function SeasonSelectLocationGameRankItem:DataDefine()
end

function SeasonSelectLocationGameRankItem:DataDestroy()
end

function SeasonSelectLocationGameRankItem:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function SeasonSelectLocationGameRankItem:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function SeasonSelectLocationGameRankItem:OnAddListener()
  base.OnAddListener(self)
end

function SeasonSelectLocationGameRankItem:OnRemoveListener()
  base.OnRemoveListener(self)
end

function SeasonSelectLocationGameRankItem:ReInit(data)
  if self:InitData(data) then
    self:InitUi()
    if self:UpdateData() then
      self:UpdateUi()
    end
  end
end

function SeasonSelectLocationGameRankItem:InitData(data)
  if data ~= nil then
    self.Data = data
    return true
  end
  return false
end

function SeasonSelectLocationGameRankItem:InitUi()
  self.compCur:SetActive(self.Data.sid == LuaEntry.Player.serverId)
  if self.Data.sid == LuaEntry.Player.serverId then
    self.imgBg:LoadSpriteAsync("Assets/Main/SeasonRes/S5/Sprites/SelectLocation/FX_S5_zhanquxuanwei_diban02")
    self.textRank:SetColor(Color.New(0.18823529411764706, 0.4823529411764706, 0.17254901960784313, 1))
    self.textScore:SetColor(Color.New(0.3803921568627451, 0.9372549019607843, 0.5333333333333333, 1))
  else
    self.imgBg:LoadSpriteAsync("Assets/Main/SeasonRes/S5/Sprites/SelectLocation/FX_S5_zhanquxuanwei_diban01")
    self.textRank:SetColor(Color.New(0.396078431372549, 0.20392156862745098, 0.12156862745098039, 1))
    self.textScore:SetColor(Color.New(1, 1, 1, 1))
  end
  if self.Data.rank > 0 then
    self.textRank:SetText(string.format("NO.%s", self.Data.rank))
  else
    self.textRank:SetLocalText("zone_selection_location_UI_26")
  end
  self.textScore:SetTextFormat("#%s: %s", self.Data.sid, checknumber(self.Data.score))
end

function SeasonSelectLocationGameRankItem:UpdateData()
  return true
end

function SeasonSelectLocationGameRankItem:UpdateUi()
end

function SeasonSelectLocationGameRankItem:Update1000MS()
end

return SeasonSelectLocationGameRankItem
