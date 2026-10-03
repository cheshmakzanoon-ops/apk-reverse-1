local ImgCreateContent = require("UI.LWUIChatCommonShare.Component.ImgCreateContent")
local ImgCreateContent_FlowerTrain = BaseClass("ImgCreateContent_FlowerTrain", ImgCreateContent)
local base = ImgCreateContent
local heat_path = "Content/PicContent/flowerTrain/Content/Heat"
local heat_txt_path = "Content/PicContent/flowerTrain/Content/HeatTxt"
local like_path = "Content/PicContent/flowerTrain/Content/Like"
local like_txt_path = "Content/PicContent/flowerTrain/Content/LikeTxt"
local content_path = "Content/PicContent/flowerTrain/Content"

function ImgCreateContent_FlowerTrain:OnCreate()
  base.OnCreate(self)
  self.heat = self:AddComponent(UIImage, heat_path)
  self.heat_txt = self:AddComponent(UITextMeshProUGUIEx, heat_txt_path)
  self.like = self:AddComponent(UIImage, like_path)
  self.like_txt = self:AddComponent(UITextMeshProUGUIEx, like_txt_path)
  self.content = self:AddComponent(UIBaseContainer, content_path)
end

function ImgCreateContent_FlowerTrain:OnDestroy()
  self.heat = nil
  self.heat_txt = nil
  self.like = nil
  self.like_txt = nil
  self.content = nil
  base.OnDestroy(self)
end

function ImgCreateContent_FlowerTrain:ReInitExtra()
  local extra = self.inputParam.extra
  local trainData = extra.trainData
  if trainData == nil then
    return
  end
  local maxWidth = 560
  local preferredValues = self.txt_title.unity_tmpro:GetPreferredValues(maxWidth, 0)
  self.content:SetAnchoredPositionXY(0, -preferredValues.y - 25)
  self.heat_txt:SetText(trainData:GetCurTotalExp() .. "!")
  self.like_txt:SetText(trainData:GetLikeCount())
  PostEventLog.Track(PostEventLog.Defines.FlowerTrain_Share_Moment_Success, {
    share_type = trainData.exp or 0,
    aid = trainData.uuid or "",
    actId = trainData.fromGoodsId or ""
  })
end

return ImgCreateContent_FlowerTrain
