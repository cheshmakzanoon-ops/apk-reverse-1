local IChatItemPost = require("UI.UIChatNewV2.Component.ChatItem.IChatItemPost")
local PostFlowerTrainShare = BaseClass("PostFlowerTrainShare", IChatItemPost)
local base = IChatItemPost
local Localization = CS.GameEntry.Localization
local rapidjson = require("rapidjson")
local player_name_text_path = "Content/PlayerNameText"
local u_i_player_head_path = "Content/PlayHeadPoint/UIPlayerHead"
local rank_text_path = "Content/RankText"
local rank_icon_path = "Content/RankIcon"
local train_icon_path = "Content/TrainIcon"
local click_btn_path = "Content/ClickBtn"
local heat_txt_path = "Content/HeatTxt"
local heat_icon_path = "Content/HeatTxt/HeatIcon"

function PostFlowerTrainShare:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
end

function PostFlowerTrainShare:OnDestroy()
  base.OnDestroy(self)
end

function PostFlowerTrainShare:ComponentDefine()
  self.playerNameText = self:AddComponent(UIText, player_name_text_path)
  self.headItem = self:AddComponent(UICommonHead, u_i_player_head_path)
  self.headItem:SetEnableClickShowInfo(true)
  self.rankNameText = self:AddComponent(UIText, rank_text_path)
  self.heatText = self:AddComponent(UIText, heat_txt_path)
  self.heatIcon = self:AddComponent(UIImage, heat_icon_path)
  self.rankIcon = self:AddComponent(UIImage, rank_icon_path)
  self.trainIconRawImg = self:AddComponent(UIRawImage, train_icon_path)
  self.clickBtn = self:AddComponent(UIButton, click_btn_path)
  self.clickBtn:SetOnClick(function()
    self:OpenShareRankView()
  end)
end

function PostFlowerTrainShare:OnLoaded()
  local chatData = self:ChatData()
  if not chatData then
    return
  end
  if not chatData.attachmentId then
    return
  end
  local attachJson = rapidjson.decode(chatData.attachmentId)
  if not attachJson or table.count(attachJson) <= 0 then
    return
  end
  if not attachJson.uid then
    return
  end
  self.param = {}
  self.param.uid = attachJson.uid
  self.param.pic = attachJson.pic
  self.param.picVer = attachJson.picVer
  self.param.name = attachJson.name
  self.param.allianceAbbrName = attachJson.allianceAbbrName
  self.param.allianceName = attachJson.allianceName
  self.param.rank = attachJson.rank
  self.param.power = attachJson.power
  self.param.gender = attachJson.gender
  self.param.aid = attachJson.aid
  self.param.exp = attachJson.exp
  self.param.praise = attachJson.praise
  self.param.lv = attachJson.lv
  self.param.trainItemId = attachJson.trainItemId
  self:RefreshUI()
end

function PostFlowerTrainShare:RefreshUI()
  self:RefreshRankInfo()
  self:RefreshPlayerInfo()
end

function PostFlowerTrainShare:RefreshRankInfo()
  if self.param.trainItemId == nil then
    return
  end
  self.itemMeta = DataCenter.ItemTemplateManager:GetItemTemplate(self.param.trainItemId)
  if self.itemMeta == nil then
    return
  end
  self.showData = FlowerTrainUtils.GetFlowerTrainDisplayMetaByGoodsId(self.param.trainItemId, self.param.lv or 1)
  self.trainIconRawImg:LoadSprite(self.showData.pic4)
  self.trainIconRawImg:SetNativeSize()
  self.rankIcon:LoadSprite(self.showData.level_icon)
  self.rankNameText:SetLocalText(self.itemMeta.name)
  local path = FlowerTrainUtils.GetFlowerTrainFireImgPathByGoodsId(self.param.trainItemId, self.param.exp)
  self.heatIcon:LoadSprite(path)
  self.heatText:SetText(self.param.exp or 0)
end

function PostFlowerTrainShare:RefreshPlayerInfo()
  self.headItem:SetData(self.param.uid, self.param.pic, self.param.picVer)
  local showName = UIUtil.FormatAllianceAndName(self.param.allianceAbbrName, self.param.name)
  self.playerNameText:SetText(showName)
end

function PostFlowerTrainShare:OnRecycle()
  self.data = nil
end

function PostFlowerTrainShare:OpenShareRankView()
  if not self.param then
    return
  end
  local param = {}
  param.sourceType = 2
  param.uid = self.param.uid
  param.pic = self.param.pic
  param.picVer = self.param.picVer
  param.name = self.param.name
  param.allianceAbbrName = self.param.allianceAbbrName
  param.allianceName = self.param.allianceName
  param.rank = self.param.rank
  param.power = self.param.power
  param.gender = self.param.gender
  param.aid = self.param.aid
  param.exp = self.param.exp
  param.praise = self.param.praise
  param.lv = self.param.lv
  param.trainItemId = self.param.trainItemId
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIFlowerTrainShareRank, {anim = true}, param)
end

return PostFlowerTrainShare
