local base = UIBaseContainer
local LWActMeteoriteBattleServerItem = BaseClass("LWActMeteoriteBattleServerItem", base)

function LWActMeteoriteBattleServerItem:OnCreate()
  base.OnCreate(self)
  self.di = self:AddComponent(UIImage, "Di")
  self.desc_text = self:AddComponent(UITextMeshProUGUIEx, "DescText")
end

function LWActMeteoriteBattleServerItem:OnDestroy()
  self.di = nil
  self.desc_text = nil
  base.OnDestroy(self)
end

function LWActMeteoriteBattleServerItem:SetData(sId)
  local sPath = sId == LuaEntry.Player:GetSelfServerId() and "lrb_zhouliuhuodong_zhanqu_lan.png" or "lrb_zhouliuhuodong_zhanqu_hong.png"
  self.di:LoadSpriteAuto(string.format(LoadPath.LWActMeteoriteBattlePath, sPath))
  self.desc_text:SetText("#" .. sId)
end

return LWActMeteoriteBattleServerItem
