local UIBattlePassNormalNewViewShowConfig = BaseClass("UIBattlePassNormalNewViewShowConfig")

function UIBattlePassNormalNewViewShowConfig:__init()
  self:DataDefine()
end

function UIBattlePassNormalNewViewShowConfig:__delete()
  self:OnDestroy()
end

function UIBattlePassNormalNewViewShowConfig:DataDefine()
  self.defaultType = -1
  self.defaultTab = {
    ImageBgColor = {
      0.9254901960784314,
      0.6078431372549019,
      0.30196078431372547,
      1
    },
    ImageBg3Color = {
      0.2196078431372549,
      0.08235294117647059,
      0 / 255,
      0.39215686274509803
    },
    ProgressBarImg = "FX_BP_bar_huangse",
    NotOnListToggleTxtColor = {
      0.7372549019607844,
      0.596078431372549,
      0.49019607843137253,
      1
    },
    OnListToggleTxtColor = {
      1,
      1,
      1,
      1
    },
    ToggleImg = "FX_BP_yeqian_huangse"
  }
  self.viewShowConfig = {}
  local configTab = {}
  self.viewShowConfig[self.defaultType] = setmetatable(configTab, {
    __index = self.defaultTab
  })
  configTab = {}
  self.viewShowConfig[BattlePassType.NormalNew1] = setmetatable(configTab, {
    __index = self.defaultTab
  })
  configTab = {
    ImageBgColor = {
      0.4470588235294118,
      0.45098039215686275,
      0.9176470588235294,
      1
    },
    ImageBg3Color = {
      0 / 255,
      0.050980392156862744,
      0.2196078431372549,
      0.39215686274509803
    },
    ProgressBarImg = "FX_BP_bar_zise",
    NotOnListToggleTxtColor = {
      0.4823529411764706,
      0.5803921568627451,
      0.7843137254901961,
      1
    },
    ToggleImg = "FX_BP_yeqian_zise"
  }
  self.viewShowConfig[BattlePassType.NormalNew2] = setmetatable(configTab, {
    __index = self.defaultTab
  })
  configTab = {
    ImageBgColor = {
      0.4117647058823529,
      0.6196078431372549,
      0.9647058823529412,
      1
    },
    ImageBg3Color = {
      0.00392156862745098,
      0.10588235294117647,
      0.39215686274509803,
      0.39215686274509803
    },
    ProgressBarImg = "FX_BP_bar_lanse",
    NotOnListToggleTxtColor = {
      0.4823529411764706,
      0.5803921568627451,
      0.7843137254901961,
      1
    },
    ToggleImg = "FX_BP_yeqian_lanse"
  }
  self.viewShowConfig[BattlePassType.NormalNew3] = setmetatable(configTab, {
    __index = self.defaultTab
  })
end

function UIBattlePassNormalNewViewShowConfig:OnDestroy()
end

function UIBattlePassNormalNewViewShowConfig:GetViewShowConfig(uiType)
  local targetType = uiType
  if self.viewShowConfig[targetType] == nil then
    targetType = self.defaultType
  end
  return self.viewShowConfig[targetType]
end

return UIBattlePassNormalNewViewShowConfig
