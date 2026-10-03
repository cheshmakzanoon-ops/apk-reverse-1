EGameQuality = {
  Unknown = -1,
  Low = 1,
  Mid = 2,
  High = 3,
  Default = 4
}
EGameFeatureQuality = {
  UltraLow = 1,
  Low = 2,
  Mid = 3,
  High = 4,
  UltraHigh = 5
}
EDeviceLevel = {
  Unknown = -1,
  UltraLow = 0,
  Low = 1,
  MidLow = 2,
  Mid = 3,
  MidHigh = 4,
  High = 5,
  UltraHigh = 6
}
EGameQualityConfig = {}
EGameQualityConfig[1] = {
  Basic = EGameFeatureQuality.UltraLow,
  Shadow = EGameFeatureQuality.UltraLow,
  AA = EGameFeatureQuality.UltraLow,
  Material = EGameFeatureQuality.UltraLow,
  PostProcess = EGameFeatureQuality.UltraLow,
  Terrain = EGameFeatureQuality.UltraLow,
  Particle = EGameFeatureQuality.UltraLow,
  Animation = EGameFeatureQuality.UltraLow,
  Logic = EGameFeatureQuality.UltraLow
}
EGameQualityConfig[2] = {
  Basic = EGameFeatureQuality.Low,
  Shadow = EGameFeatureQuality.Low,
  AA = EGameFeatureQuality.Low,
  Material = EGameFeatureQuality.UltraLow,
  PostProcess = EGameFeatureQuality.UltraLow,
  Terrain = EGameFeatureQuality.UltraLow,
  Particle = EGameFeatureQuality.UltraLow,
  Animation = EGameFeatureQuality.UltraLow,
  Logic = EGameFeatureQuality.UltraLow
}
EGameQualityConfig[3] = {
  Basic = EGameFeatureQuality.Mid,
  Shadow = EGameFeatureQuality.Low,
  AA = EGameFeatureQuality.Low,
  Material = EGameFeatureQuality.Low,
  PostProcess = EGameFeatureQuality.Low,
  Terrain = EGameFeatureQuality.Low,
  Particle = EGameFeatureQuality.UltraLow,
  Animation = EGameFeatureQuality.Low,
  Logic = EGameFeatureQuality.UltraLow
}
EGameQualityConfig[4] = {
  Basic = EGameFeatureQuality.Mid,
  Shadow = EGameFeatureQuality.Mid,
  AA = EGameFeatureQuality.Mid,
  Material = EGameFeatureQuality.Mid,
  PostProcess = EGameFeatureQuality.Mid,
  Terrain = EGameFeatureQuality.Mid,
  Particle = EGameFeatureQuality.Low,
  Animation = EGameFeatureQuality.Low,
  Logic = EGameFeatureQuality.Low
}
EGameQualityConfig[5] = {
  Basic = EGameFeatureQuality.High,
  Shadow = EGameFeatureQuality.High,
  AA = EGameFeatureQuality.High,
  Material = EGameFeatureQuality.High,
  PostProcess = EGameFeatureQuality.High,
  Terrain = EGameFeatureQuality.High,
  Particle = EGameFeatureQuality.Mid,
  Animation = EGameFeatureQuality.Mid,
  Logic = EGameFeatureQuality.Mid
}
EGameQualityConfig[6] = {
  Basic = EGameFeatureQuality.UltraHigh,
  Shadow = EGameFeatureQuality.UltraHigh,
  AA = EGameFeatureQuality.UltraHigh,
  Material = EGameFeatureQuality.UltraHigh,
  PostProcess = EGameFeatureQuality.UltraHigh,
  Terrain = EGameFeatureQuality.UltraHigh,
  Particle = EGameFeatureQuality.High,
  Animation = EGameFeatureQuality.High,
  Logic = EGameFeatureQuality.High
}
EGameQualityConfig[7] = {
  Basic = EGameFeatureQuality.UltraHigh,
  Shadow = EGameFeatureQuality.UltraHigh,
  AA = EGameFeatureQuality.UltraHigh,
  Material = EGameFeatureQuality.UltraHigh,
  PostProcess = EGameFeatureQuality.UltraHigh,
  Terrain = EGameFeatureQuality.UltraHigh,
  Particle = EGameFeatureQuality.UltraHigh,
  Animation = EGameFeatureQuality.UltraHigh,
  Logic = EGameFeatureQuality.UltraHigh
}
EGameQualityConfig.Default = EGameQualityConfig[4]
EGameQualityConfig.Low = 2
EGameQualityConfig.Mid = 4
EGameQualityConfig.High = 6
EGameQualityConfig.DefaultLevel = 4
EGameDeviceQualityConfig = {}
EGameDeviceQualityConfig[EDeviceLevel.Unknown] = {
  [EGameQuality.Low] = 2,
  [EGameQuality.Mid] = 4,
  [EGameQuality.High] = 6,
  [EGameQuality.Default] = 4
}
EGameDeviceQualityConfig[EDeviceLevel.UltraLow] = {
  [EGameQuality.Low] = 1,
  [EGameQuality.Mid] = 2,
  [EGameQuality.High] = 4,
  [EGameQuality.Default] = 1
}
EGameDeviceQualityConfig[EDeviceLevel.Low] = {
  [EGameQuality.Low] = 2,
  [EGameQuality.Mid] = 3,
  [EGameQuality.High] = 4,
  [EGameQuality.Default] = 2
}
EGameDeviceQualityConfig[EDeviceLevel.MidLow] = {
  [EGameQuality.Low] = 2,
  [EGameQuality.Mid] = 3,
  [EGameQuality.High] = 5,
  [EGameQuality.Default] = 3
}
EGameDeviceQualityConfig[EDeviceLevel.Mid] = {
  [EGameQuality.Low] = 3,
  [EGameQuality.Mid] = 4,
  [EGameQuality.High] = 5,
  [EGameQuality.Default] = 4
}
EGameDeviceQualityConfig[EDeviceLevel.MidHigh] = {
  [EGameQuality.Low] = 3,
  [EGameQuality.Mid] = 5,
  [EGameQuality.High] = 6,
  [EGameQuality.Default] = 5
}
EGameDeviceQualityConfig[EDeviceLevel.High] = {
  [EGameQuality.Low] = 3,
  [EGameQuality.Mid] = 5,
  [EGameQuality.High] = 6,
  [EGameQuality.Default] = 6
}
EGameDeviceQualityConfig[EDeviceLevel.UltraHigh] = {
  [EGameQuality.Low] = 3,
  [EGameQuality.Mid] = 6,
  [EGameQuality.High] = 7,
  [EGameQuality.Default] = 7
}
