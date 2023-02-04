data:extend(
    {
        -- runtime-global
        {name = "MileStoneSaves_name", type = "string-setting", default_value = "", setting_type = "runtime-global", order = "0100", allow_blank = true},
        {name = "MileStoneSaves_threshold", type = "int-setting", default_value = 1000, setting_type = "runtime-global", order = "0200"},
        {name = "MileStoneSaves_science", type = "bool-setting", default_value = "true", setting_type = "runtime-global", order = "0300"},
        {name = "MileStoneSaves_research", type = "bool-setting", default_value = "false", setting_type = "runtime-global", order = "0400"},
        -- startup
        {name = "MileStoneSaves_periodic", type = "int-setting", default_value = 60 * 60 * 60, setting_type = "startup", order = "0100"},
        {name = "MileStoneSaves_productivity", type = "int-setting", default_value = 60 * 60, setting_type = "startup", order = "0200"}
    }
)
