local base = UIBaseContainer
local FishRankItemComponent = BaseClass("FishRankItemComponent", UIBaseContainer)
local Localization = CS.GameEntry.Localization
local UICommonHead = require("Framework.UI.Component.UICommonHead")
local ColorRank1 = "ab6100"
local ColorRank2 = "3d4d9b"
local ColorRank3 = "90624d"
local ColorRank4 = "2a2830"
local ColorRank5 = "3D7D1F"

function FishRankItemComponent:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function FishRankItemComponent:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function FishRankItemComponent:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.imgBg = self.viewSkin:AddComponent(self, UIImage, 1)
  self.textNameTxt = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 2)
  self.textWeightTxt = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 3)
  self.imgRank = self.viewSkin:AddComponent(self, UIImage, 4)
  self.textNumTxt = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 5)
  self.compHead = self.viewSkin:AddComponent(self, UICommonHead, 6)
  self.compHead:SetEnableClickShowInfo(true, true)
end

function FishRankItemComponent:ComponentDestroy()
  self.viewSkin = nil
  self.imgBg = nil
  self.textNameTxt = nil
  self.textWeightTxt = nil
  self.imgRank = nil
  self.textNumTxt = nil
  self.compHead = nil
end

function FishRankItemComponent:DataDefine()
end

function FishRankItemComponent:DataDestroy()
end

function FishRankItemComponent:OnAddListener()
  base.OnAddListener(self)
end

function FishRankItemComponent:OnRemoveListener()
  base.OnRemoveListener(self)
end

function FishRankItemComponent:SetData(data, weight_type, isMe)
  local bgPath = "Assets/Main/Sprites/UI/LWCommon/Sprite/FX_common_diban_bai.png"
  local rankBgPath
  local color = ColorRank4
  if data.rank == 1 then
    bgPath = "Assets/Main/Sprites/UI/UIRank/ljq_tongyong_paihangbang_1.png"
    rankBgPath = "Assets/Main/Sprites/UI/LWCommon/Sprite/FX_wordboss_paihangbang_icon_huizhang01.png"
    color = ColorRank1
  elseif data.rank == 2 then
    bgPath = "Assets/Main/Sprites/UI/UIRank/ljq_tongyong_paihangbang_2.png"
    rankBgPath = "Assets/Main/Sprites/UI/LWCommon/Sprite/FX_wordboss_paihangbang_icon_huizhang02.png"
    color = ColorRank2
  elseif data.rank == 3 then
    bgPath = "Assets/Main/Sprites/UI/UIRank/ljq_tongyong_paihangbang_3.png"
    rankBgPath = "Assets/Main/Sprites/UI/LWCommon/Sprite/FX_wordboss_paihangbang_icon_huizhang03.png"
    color = ColorRank3
  elseif isMe or data.uid == LuaEntry.Player.uid then
    bgPath = "Assets/Main/Sprites/UI/LWCommon/Sprite/FX_common_diban_lv.png"
    color = ColorRank5
    isMe = true
  end
  self.textNameTxt:SetColorHex(color)
  self.textWeightTxt:SetColorHex(color)
  self.imgBg:LoadSpriteAsync(bgPath)
  if rankBgPath then
    self.imgRank:LoadSpriteAsync(rankBgPath)
    self.imgRank:SetActive(true)
  else
    self.imgRank:SetActive(false)
  end
  if isMe then
    self.compHead:SetAsMyself()
  else
    self.compHead:ParseHeadInfo(data)
  end
  if data.rank and type(data.rank) == "number" and data.rank > 0 then
    self.textNumTxt:SetText(tostring(data.rank))
  else
    self.textNumTxt:SetLocalText(361054)
  end
  if isMe then
    self.textNameTxt:SetText(UIUtil.FormatServerAllianceName(LuaEntry.Player:GetSourceServerId(), LuaEntry.Player:GetAllianceAbbr(), LuaEntry.Player:GetName()))
  else
    self.textNameTxt:SetText(UIUtil.FormatServerAllianceName(data.serverId, data.abbr, data.name, data.uid))
  end
  if string.IsNullOrEmpty(data.score) or data.score == 0 or data.score == "0" then
    self.textWeightTxt:SetText("")
  else
    local weightUnit = weight_type == 1 and "%.2fg" or "%.2fkg"
    self.textWeightTxt:SetText(string.format(weightUnit, tonumber(data.score)))
  end
end

return FishRankItemComponent
