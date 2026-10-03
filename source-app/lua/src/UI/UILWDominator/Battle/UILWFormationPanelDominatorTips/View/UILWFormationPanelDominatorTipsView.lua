local Base = require("UI.UILWHero.UIHeroSimpleTip.View.UIArrowTipBase")
local UILWFormationPanelDominatorTipsView = BaseClass("UILWFormationPanelDominatorTipsView", Base)
local Localization = CS.GameEntry.Localization
local UILWCommonDominatorHeadComponent = require("UI/UILWDominator/Common/UILWCommonDominatorHeadComponent")
local UIHeroCellSmall = require("UI.UIHero2.Common.UIHeroCellSmall")

local function ComponentDefine(self)
  Base.ComponentDefine(self)
  self.textTitle = self:AddComponent(UIText, "Root/ImgBg/Content/TitleText")
  self.textTitle:SetText(Localization:GetString("dominator_pve_dec_2"))
  self.compDominatorHead = self:AddComponent(UIHeroCellSmall, "Root/ImgBg/Content/MiddleContent/UIHeroCellSmall")
  self.imgTrainLevelIcon = self:AddComponent(UIImage, "Root/ImgBg/Content/MiddleContent/TrainLevel/TrainLevelIcon")
  self.imgTrainLevelBg = self:AddComponent(UIImage, "Root/ImgBg/Content/MiddleContent/TrainLevel/TrainLevelBg")
  self.textTrainLevel = self:AddComponent(UIText, "Root/ImgBg/Content/MiddleContent/TrainLevel/TrainLevelText")
  self.textTrainInfoItemText1 = self:AddComponent(UIText, "Root/ImgBg/Content/BottomContent/TrainInfoItem1/TrainInfoItemText1")
  self.textTrainInfoItemText2 = self:AddComponent(UIText, "Root/ImgBg/Content/BottomContent/TrainInfoItem2/TrainInfoItemText2")
  self.textTrainInfoItemText3 = self:AddComponent(UIText, "Root/ImgBg/Content/BottomContent/TrainInfoItem3/TrainInfoItemText3")
end

local function ComponentDestroy(self)
  self.textTitle = nil
  self.compDominatorHead = nil
  self.imgTrainLevelIcon = nil
  self.imgTrainLevelBg = nil
  self.textTrainLevel = nil
  self.textTrainInfoItemText1 = nil
  self.textTrainInfoItemText2 = nil
  self.textTrainInfoItemText3 = nil
  Base.ComponentDestroy(self)
end

local function RefreshShow(self)
  local param = self:GetUserData()
  if param == nil then
    return
  end
  local dominatorInfo = param.dominatorInfo
  if dominatorInfo == nil then
    return
  end
  self.compDominatorHead:InitWithConfigId(dominatorInfo.dominatorId, 0, 0, dominatorInfo:GetCurRankLv(), 0)
  if param.trainIds then
    for i, trainId in pairs(param.trainIds) do
      local trainLevelTemplate = DataCenter.DominatorTemplateManager:GetTrainLevelTemplateById(trainId)
      if trainLevelTemplate then
        local trainGroupTemplate = trainLevelTemplate:GetGroupTemplate()
        if trainGroupTemplate then
          if trainGroupTemplate:IsMainGroup() then
            self.imgTrainLevelIcon:LoadSprite(trainLevelTemplate:GetNumberIconPath())
            self.textTrainLevel:SetText(trainLevelTemplate:GetColoredName(false))
            local ret, r, g, b, a = trainLevelTemplate:GetQualityImageColorRGBA()
            if ret then
              self.imgTrainLevelIcon:SetColorRGBA255(r, g, b, a)
              self.textTrainLevel:SetColorRGBA255(r, g, b, a)
              self.imgTrainLevelBg:SetColorRGBA255(r, g, b, a)
            end
          elseif trainGroupTemplate.id == DominatorTrainGroupId.Attack then
            self.textTrainInfoItemText1:SetText("Lv." .. tostring(trainLevelTemplate.level_order))
          elseif trainGroupTemplate.id == DominatorTrainGroupId.Defence then
            self.textTrainInfoItemText2:SetText("Lv." .. tostring(trainLevelTemplate.level_order))
          elseif trainGroupTemplate.id == DominatorTrainGroupId.Hp then
            self.textTrainInfoItemText3:SetText("Lv." .. tostring(trainLevelTemplate.level_order))
          end
        end
      end
    end
  end
end

local function OnAddListener(self)
  Base.OnAddListener(self)
end

local function OnRemoveListener(self)
  Base.OnRemoveListener(self)
end

UILWFormationPanelDominatorTipsView.ComponentDefine = ComponentDefine
UILWFormationPanelDominatorTipsView.ComponentDestroy = ComponentDestroy
UILWFormationPanelDominatorTipsView.RefreshShow = RefreshShow
UILWFormationPanelDominatorTipsView.OnAddListener = OnAddListener
UILWFormationPanelDominatorTipsView.OnRemoveListener = OnRemoveListener
return UILWFormationPanelDominatorTipsView
